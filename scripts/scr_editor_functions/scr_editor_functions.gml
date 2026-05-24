/// @desc Cambia el tipo de un evento y resetea sus propiedades a los valores por defecto.
/// @param _ev_ref Referencia al struct del evento (ej: events_array[i])
function editor_change_event_type(_ev_ref) {
    if (_ev_ref == undefined) return;

    // 1. Avanzar al siguiente tipo
    _ev_ref.type++;
    
    // 2. OBTENER METADATA AUTOMÁTICA
    // ¡Listo! Ahora lee dinámicamente cuántos elementos hay en tu función maestra
    var _total_eventos = get_event_metadata(-1); 
    if (_ev_ref.type >= _total_eventos) _ev_ref.type = 0;
    
    // 3. Obtener la nueva metadata
    var _new_meta = get_event_metadata(_ev_ref.type);
    
    // 4. Limpiar variables antiguas y aplicar los nuevos valores 'def'
    var _keys = variable_struct_get_names(_ev_ref);
    for (var i = 0; i < array_length(_keys); i++) {
        var _k = _keys[i];
        if (_k != "time" && _k != "type") {
            variable_struct_remove(_ev_ref, _k);
        }
    }
    
    // 5. Inyectar las nuevas propiedades según el script de definiciones
    for (var k = 0; k < array_length(_new_meta.properties); k++) {
        var _prop = _new_meta.properties[k];
        _ev_ref[$ _prop.key] = _prop.def;
    }
    
    show_debug_message("Evento cambiado a: " + _new_meta.name);
}