var mx = mouse_x;
var my = mouse_y;

if (show_meta_menu) {
    // Si haces clic fuera de cualquier caja y estás escribiendo
    if (mouse_check_button_pressed(mb_left) && active_input != "") {
        // Un chequeo de seguridad simple para cancelar input
        if (mx < room_width * 0.1 || mx > room_width * 0.9) { 
            active_input = ""; 
            if (os_type == os_android) keyboard_virtual_hide(); 
        }
    }
    
    // Botón Guardar
    if (mx > btn_save[0] && mx < btn_save[2] && my > btn_save[1] && my < btn_save[3]) {
        guardar_chart(global.chart_data.song_name, notes_array, events_array, player);
        scr_sort_events();
        TXT = "Guardado con exito."; alpha = 1;
    }
    
    // Botón Cargar
    if (mx > btn_load[0] && mx < btn_load[2] && my > btn_load[1] && my < btn_load[3]) {
        var _loaded_data = cargar_chart(global.chart_data.song_name);
        
        if (_loaded_data != undefined) {
            notes_array = variable_struct_exists(_loaded_data, "notes") ? _loaded_data.notes : [];
            events_array = variable_struct_exists(_loaded_data, "evento") ? _loaded_data.evento : [];
            
            // Cargar jugadores
            for(var p = 0; p < global.chart_data.playersMax; p++) {
                var pk = "player" + string(p+1);
                if (variable_struct_exists(_loaded_data, pk)) {
                    player[p] = _loaded_data[$ pk];
                }
            }
            
            selected_note = -1; selected_event = -1;
            TXT = "Cargado con exito."; alpha = 1;
        } else {
            TXT = "Error: Archivo no existe."; alpha = 1;
        }
    }
    
    // Botón Cerrar
    if (mx > btn_close_meta[0] && mx < btn_close_meta[2] && my > btn_close_meta[1] && my < btn_close_meta[3]) {
        show_meta_menu = false;
        active_input = "";
        if (os_type == os_android) keyboard_virtual_hide();
    }
    exit;
}

// Si estábamos arrastrando para hacer scroll, abortamos el clic
if (is_dragging) {
    is_dragging = false;
    exit;
}

// Botones UI Principales
if (mx > btn_meta[0] && mx < btn_meta[2] && my > btn_meta[1] && my < btn_meta[3]) {
    show_meta_menu = true;
    exit;
}

if (mx > btn_play[0] && mx < btn_play[2] && my > btn_play[1] && my < btn_play[3]) {
    global.current_chart = global.chart_data.song_name;
    if (audio_is_playing(audio_instance)) audio_stop_sound(audio_instance);
    room_goto(rmGame);
    exit;
}



// --- CLIC EN LA GRILLA (COLOCAR/SELECCIONAR NOTAS) ---
if (click_valid) {
    var _clicked_col = -1;
    for (var c = 0; c < 3; c++) {
        if (mx >= col_x[c] - (col_width/2) && mx <= col_x[c] + (col_width/2)) {
            _clicked_col = c; break;
        }
    }

    if (_clicked_col != -1) {
        var _clicked_time = current_time_sec + ((hit_y - my) / global.chart_data.note_speed/100);
        
        var _beat_dur = 60 / global.chart_data.bpm;
        var _snap_interval = _beat_dur / global.chart_data.snap_div; 
        _clicked_time = round(_clicked_time / _snap_interval) * _snap_interval;
        
        if (_clicked_col == 0) {
            // MANEJO DE EVENTOS (COLUMNA 0)
            selected_note = -1;
            var _found_ev = false;
            
            for (var i = 0; i < array_length(events_array); i++) {
                if (abs(events_array[i].time - _clicked_time) < 0.05) {
                    selected_event = i; _found_ev = true; break;
                }
            }

            if (!_found_ev && _clicked_time >= 0) {
                var _base_meta = get_event_metadata(0);
                var _new_ev = { time: _clicked_time, type: 0 };

                for(var k=0; k < array_length(_base_meta.properties); k++) {
                    var _p = _base_meta.properties[k];
                    _new_ev[$ _p.key] = _p.def;
                }
                array_push(events_array, _new_ev);
                selected_event = array_length(events_array) - 1;
            }
        } else {
            // MANEJO DE NOTAS
            selected_event = -1;
            var _found = false;
            for (var i = 0; i < array_length(notes_array); i++) {
                var _n = notes_array[i];
                if (_n.col == _clicked_col && abs(_n.time - _clicked_time) < 0.05) {
                    selected_note = i; _found = true; break;
                }
            }
            
            if (!_found && _clicked_time >= 0) {
                array_push(notes_array, {
                    col: _clicked_col,
                    time: _clicked_time,
                    hold: 0,
                    type: 0,
					playerID: charPlaceID,
                });
                selected_note = array_length(notes_array) - 1;
            }
        }
    }
}