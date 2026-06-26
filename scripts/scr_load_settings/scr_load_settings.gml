/// @function scr_load_settings(options_list)
/// @description Carga la configuración desde el archivo JSON, restablece los controles globales, aplica los cambios gráficos y sincroniza el menú.
/// @param {Array} _options_list El arreglo 'options_list' del objeto menú para actualizar sus valores visuales.
function scr_load_settings(_options_list) {
    var _filename = "settings.json";
    
    // Si el archivo no existe, se cancela la carga (el juego usará los valores iniciales por defecto)
    if (!file_exists(_filename)) {
        show_debug_message("No se encontró el archivo de configuración. Usando valores por defecto.");
        return;
    }
    
    // 1. Leer el archivo de texto estructurado en JSON
    var _file = file_text_open_read(_filename);
    var _json_string = file_text_read_string(_file);
    file_text_close(_file);
    
    // Parsear el string JSON para convertirlo en una estructura de GameMaker
    var _load_data = json_parse(_json_string);
    
    // ==========================================
    // 2. ASIGNACIÓN DE CONTROLES GLOBALES
    // ==========================================
    // Usamos variable_global_set para mapear las cadenas del JSON a tus variables globales reales
    if (variable_struct_exists(_load_data, "key_Lrow"))   variable_global_set("Lrow", _load_data.key_Lrow);
    if (variable_struct_exists(_load_data, "key_Rrow"))   variable_global_set("Rrow", _load_data.key_Rrow);
    if (variable_struct_exists(_load_data, "key_SLrow"))  variable_global_set("SLrow", _load_data.key_SLrow);
    if (variable_struct_exists(_load_data, "key_SRrow"))  variable_global_set("SRrow", _load_data.key_SRrow);
    if (variable_struct_exists(_load_data, "key_TAUNT"))  variable_global_set("TAUNT", _load_data.key_TAUNT);
    if (variable_struct_exists(_load_data, "key_PAUSE"))  variable_global_set("PAUSE", _load_data.key_PAUSE);
    if (variable_struct_exists(_load_data, "key_UP"))     variable_global_set("UP", _load_data.key_UP);
    if (variable_struct_exists(_load_data, "key_DOWN"))   variable_global_set("DOWN", _load_data.key_DOWN);
    if (variable_struct_exists(_load_data, "key_LEFT"))   variable_global_set("LEFT", _load_data.key_LEFT);
    if (variable_struct_exists(_load_data, "key_RIGHT"))  variable_global_set("RIGHT", _load_data.key_RIGHT);
    if (variable_struct_exists(_load_data, "key_ENTER"))  variable_global_set("ENTER", _load_data.key_ENTER);
    if (variable_struct_exists(_load_data, "key_BACK"))   variable_global_set("BACK", _load_data.key_BACK);
    if (variable_struct_exists(_load_data, "key_DEBUG1")) variable_global_set("DEBUG1", _load_data.key_DEBUG1);
    
    // ==========================================
    // 3. SINCRONIZACIÓN DE VALORES EN EL MENÚ
    // ==========================================
    // Recorremos tu estructura 'options_list' para actualizar el parámetro '.val' de cada elemento
    if (_options_list != undefined) {
        var _cat_count = array_length(_options_list);
        for (var c = 0; c < _cat_count; c++) {
            var _items = _options_list[c].items;
            var _items_count = array_length(_items);
            
            for (var i = 0; i < _items_count; i++) {
                var _item = _items[i];
                
                // Si el elemento del menú tiene un 'key' definido y existe en el JSON, cargamos su valor
                if (variable_struct_exists(_item, "key") && variable_struct_exists(_load_data, _item.key)) {
                    _item.val = variable_struct_get(_load_data, _item.key);
                }
            }
        }
    }
    
    // ==========================================
    // 4. APLICACIÓN DE EFECTOS GRÁFICOS
    // ==========================================
    // Ejecuta instantáneamente la resolución cargada
    if (variable_struct_exists(_load_data, "resolution")) {
        scr_apply_resolution(_load_data.resolution);
    }
    
    // Ejecuta instantáneamente el estado de Anti-aliasing
    if (variable_struct_exists(_load_data, "disable_aa")) {
        scr_apply_aa(_load_data.disable_aa);
    }
    
    show_debug_message("Configuración cargada y aplicada con éxito.");
}