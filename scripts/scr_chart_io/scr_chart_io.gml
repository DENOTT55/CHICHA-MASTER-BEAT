// Script: scr_chart_io
function guardar_chart(_song_name, _notes, _events, _players) {
    var _save_data = {};
    
    // 1. Guardar todos los metadatos dinámicamente
    var _keys = variable_struct_get_names(global.chart_data);
    for(var i = 0; i < array_length(_keys); i++) {
        var _k = _keys[i];
        _save_data[$ _k] = global.chart_data[$ _k];
    }
    
    // 2. Guardar arrays del nivel
    _save_data.notes = _notes;
    _save_data.evento = _events;
    
    // 3. Guardar jugadores
    for(var p = 0; p < global.chart_data.playersMax; p++) {
        _save_data[$ "player" + string(p+1)] = _players[p];
    }
    
    // Escribir archivo
    var _file = file_text_open_write(working_directory + _song_name + ".json");
    file_text_write_string(_file, json_stringify(_save_data));
    file_text_close(_file);
    
    return true;
}

function cargar_chart(_song_name) {
    var _path = working_directory + _song_name + ".json";
    if (!file_exists(_path)) return undefined; // Falla si no existe
    
    var _file = file_text_open_read(_path);
    var _json = "";
    while (!file_text_eof(_file)) {
        _json += file_text_read_string(_file);
    }
    file_text_close(_file);
    
    var _loaded = json_parse(_json);
    
    // Cargar metadatos a global.chart_data dinámicamente
    var _keys = variable_struct_get_names(_loaded);
    for(var i = 0; i < array_length(_keys); i++) {
        var _k = _keys[i];
        if (_k != "notes" && _k != "evento" && string_copy(_k, 1, 6) != "player") {
            global.chart_data[$ _k] = _loaded[$ _k];
        }
    }
    
    return _loaded; // Retornamos el struct para que el objeto extraiga las notas y eventos
}