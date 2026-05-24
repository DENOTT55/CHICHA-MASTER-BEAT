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

// 1. SISTEMA DE ESCRITURA (Anti-Crash y Android)
if (active_input != "") {
    if (keyboard_check_pressed(vk_enter)) {
        active_input = "";
        if (os_type == os_android) keyboard_virtual_hide();
    } else {
        if (is_string(global.chart_data[$ active_input])) {
            global.chart_data[$ active_input] = keyboard_string;
        } else {
            var _solo_numeros = string_digits(keyboard_string);
            global.chart_data[$ active_input] = (_solo_numeros != "") ? real(_solo_numeros) : 0;
        }
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
    if (keyboard_check_pressed(vk_delete) || keyboard_check_pressed(vk_backspace)) {
        array_delete(events_array, selected_event, 1);
        selected_event = -1;
    }
    if (keyboard_check_pressed(vk_escape)) selected_event = -1;
}