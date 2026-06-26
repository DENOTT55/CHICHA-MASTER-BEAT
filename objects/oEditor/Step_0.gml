if (alpha > 0) { alpha -= 0.005; }

// --- ADAPTACIÓN RESPONSIVA (Orientación) ---
var _w = room_width;
var _h = room_height;
var _cx = _w / 2;

if (_w > _h) { 
    // MODO HORIZONTAL (Apaisado)
    col_x = [_cx - 200, _cx, _cx + 80];
    hit_y = _h - 100;
} else { 
    // MODO VERTICAL (Retrato)
    col_x = [_cx - 120, _cx - 10, _cx + 100];
    hit_y = _h - 150;
}

// 1. SISTEMA DE ESCRITURA (Soporte Móvil unificado)
if (active_input != "" || editing_player_name != -1 || editing_event_prop_key != "") {
    
    if (keyboard_check_pressed(vk_enter)) {
        // Al dar Enter, aplicamos los valores según lo que estemos editando
        if (active_input != "" && active_input_type == "number") {
            var _val = real(global.chart_data[$ active_input]);
            global.chart_data[$ active_input] = clamp(_val, active_input_min, active_input_max);
        }
        
        // --- NUEVO: GUARDAR LA EDICIÓN DEL EVENTO ---
        if (editing_event_prop_key != "" && selected_event != -1) {
            var _ev_ref = events_array[selected_event];
            
            if (editing_event_prop_type == "number") {
                try {
                    // Si la caja está vacía, evitamos crasheos asignando un 0
                    if (keyboard_string == "") {
                        _ev_ref[$ editing_event_prop_key] = 0;
                    } else {
                        // Convierte la cadena en un número matemático real (soporta decimales y negativos)
                        _ev_ref[$ editing_event_prop_key] = real(keyboard_string);
                    }
                } catch(_e) { 
                    // Si por algún motivo se coló una letra no válida, devolvemos a 0 por seguridad
                    _ev_ref[$ editing_event_prop_key] = 0; 
                }
            } 
            else if (editing_event_prop_type == "text") {
                // Si el tipo es texto, se guarda como cadena de texto plano inalterada
                _ev_ref[$ editing_event_prop_key] = keyboard_string;
            }
        }
        
        // Cerramos cualquier edición activa
        active_input = "";
        editing_player_name = -1;
        editing_event_prop_key = ""; // Resetear evento
        if (os_type == os_android) keyboard_virtual_hide();
        
    } else {
        // Lógica de escritura en tiempo real para variables antiguas
        if (active_input != "") {
            if (active_input_type == "text") {
                global.chart_data[$ active_input] = keyboard_string;
            } else if (active_input_type == "number") {
                var _solo_numeros = string_digits(keyboard_string);
                global.chart_data[$ active_input] = (_solo_numeros != "") ? real(_solo_numeros) : 0;
            }
        } else if (editing_player_name != -1) {
            player[editing_player_name] = keyboard_string;
        }
        // NOTA: Para las propiedades de eventos, no lo actualizamos en tiempo real para 
        // evitar errores (crash) al teclear símbolos como '-' o '.' antes del número final.
    }
}

// 2. REPRODUCCIÓN Y SCROLL POR TECLADO
if (keyboard_check_pressed(vk_space) && active_input == "") {
    is_playing = !is_playing;
    if (is_playing) {
        var _ogg_path = working_directory + global.chart_data.song_name + ".ogg";
        if (file_exists(_ogg_path)) {
            if (snd_stream != -1) audio_destroy_stream(snd_stream);
            snd_stream = audio_create_stream(_ogg_path);
            audio_instance = audio_play_sound(snd_stream, 1, false);
            audio_sound_set_track_position(audio_instance, current_time_sec);
        }
    } else {
        if (audio_is_playing(audio_instance)) audio_pause_sound(audio_instance);
    }
}

if (is_playing) {
    if (audio_is_playing(audio_instance)) {
        current_time_sec = audio_sound_get_track_position(audio_instance);
    } else {
        current_time_sec += delta_time / 1000000;
    }
} else if (active_input == "") {
    var _spd = keyboard_check(vk_shift) ? 0.2 : 0.05;
    if (keyboard_check(vk_up)) current_time_sec -= _spd;
    if (keyboard_check(vk_down)) current_time_sec += _spd;
    if (mouse_wheel_up()) current_time_sec -= _spd*4;
    if (mouse_wheel_down()) current_time_sec += _spd*4;
    current_time_sec = max(0, current_time_sec);
}

// 3. BORRADO POR TECLADO
if (selected_note != -1) {
    if (keyboard_check_pressed(vk_delete) || keyboard_check_pressed(vk_backspace)) {
        array_delete(notes_array, selected_note, 1);
        selected_note = -1;
    }
    if (keyboard_check_pressed(vk_escape)) selected_note = -1;
}

if (selected_event != -1) {
    if (keyboard_check_pressed(vk_delete)) {
        array_delete(events_array, selected_event, 1);
        selected_event = -1;
    }
    if (keyboard_check_pressed(vk_escape)) selected_event = -1;
}

// 4. INDICADOR SONORO Y VISUAL DE SYNC
if (is_playing) {
    for (var i = 0; i < array_length(notes_array); i++) {
        var _n = notes_array[i];
        // Si la nota pasó la línea en este exacto frame
        if (_n.time > prev_time_sec && _n.time <= current_time_sec) {
            sync_flash = 1;
            // NOTA: Asegúrate de tener un sonido llamado snd_tick (o cámbialo por el tuyo)
            if (audio_exists(snd_tick)) audio_play_sound(snd_tick, 1, false);
        }
    }
    prev_time_sec = current_time_sec;
} else {
    prev_time_sec = current_time_sec; // Mantiene el tiempo rastreado al pausar o scrollear
}

// Reduce el destello visual progresivamente
if (sync_flash > 0) sync_flash -= 0.1;