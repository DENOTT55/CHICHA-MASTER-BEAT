// 1. Controles base (Teclado)
var _prev_selected = selected_song;

var _up = keyboard_check_pressed(global.UP);
var _down = keyboard_check_pressed(global.DOWN);
var _enter = keyboard_check_pressed(global.ENTER);

// --- NUEVA LÓGICA TÁCTIL EN TIEMPO REAL ---
var _swipe_threshold = 10; // Lo bajamos para que reaccione más rápido al dedo
var _is_tap = false;

// AL TOCAR LA PANTALLA
if (device_mouse_check_button_pressed(0, mb_left)) {
    touch_start_x = device_mouse_x(0);
    touch_start_y = device_mouse_y(0);
    initial_selected = selected_song; // Congelamos la selección inicial
    is_swiping = false;
}

// MIENTRAS MANTIENES EL DEDO (El scroll en tiempo real)
if (device_mouse_check_button(0, mb_left) and !STOPMOVING) {
    var _current_y = device_mouse_y(0);
    var _diff_y = _current_y - touch_start_y;

    // Si ya pasaste el umbral, activamos el estado de arrastre
    if (abs(_diff_y) > _swipe_threshold) {
        is_swiping = true;
        
        // Sensibilidad: Píxeles físicos que debes arrastrar para saltar 1 canción
        var _pixeles_por_cancion = 100; 
        
        // Usamos round() para que cambie de canción suavemente al pasar la mitad de la distancia
        var _saltos = round(-_diff_y / _pixeles_por_cancion); 
        
        // Calculamos la nueva selección sumando los saltos a la canción con la que empezamos
        var _total_songs = array_length(songs);
        var _new_selected = initial_selected + _saltos;
        
        // Ajuste circular (wrap) para navegar infinitamente
        selected_song = ((_new_selected % _total_songs) + _total_songs) % _total_songs;
    }
}

// AL SOLTAR EL DEDO
if (device_mouse_check_button_released(0, mb_left)) {
    // Si soltaste y NUNCA arrastraste, fue un toque simple
    if (!is_swiping and !STOPMOVING) {
        _is_tap = true;
    }
}

// Controles de teclado
if (_up and !STOPMOVING) {
    selected_song--;
    if (selected_song < 0) selected_song = array_length(songs) - 1;
}
if (_down and !STOPMOVING) {
    selected_song++;
    if (selected_song >= array_length(songs)) selected_song = 0;
}

// --- VALIDACIÓN DE CLIC IZQUIERDO ---
if (_is_tap and !STOPMOVING) {
    var _tap_x = device_mouse_x(0);
    if (_tap_x < (room_width / 2)) { // Si tocó la mitad izquierda de la pantalla
        _enter = true;
    }
}

// --- LÓGICA DE ANIMACIÓN DEL ARTE ---
if (selected_song != _prev_selected) {
    var _new_art = songs[selected_song][2]; 
    
    if (_new_art != current_art) {
        current_art = _new_art; 
        art_x = art_start_x;    
    }
}

art_x = lerp(art_x, art_target_x, 0.12); 

// 2. Scroll general de la lista
// Al actualizar selected_song en tiempo real arriba, el lerp persigue tu dedo automáticamente
var _target_scroll = selected_song * item_spacing;
current_scroll = lerp(current_scroll, _target_scroll, 0.15);

// 3. Lógica de Lerp Individual para cada canción
var _base_x = 80;

for (var i = 0; i < array_length(songs); ++i) {
    var _target_x = _base_x;
    var _target_alpha = 1.0; 
    
    if (i != selected_song) {
        _target_alpha = 0.4; 
        
        if (i < selected_song) {
            _target_x = _base_x - 120; 
        } else {
            _target_x = _base_x - 60;  
        }
    }
    
    song_visual_x[i] = lerp(song_visual_x[i], _target_x, 0.15);
    song_visual_alpha[i] = lerp(song_visual_alpha[i], _target_alpha, 0.15);
}

// --- LÓGICA AL DAR ENTER O CLIC IZQUIERDO ---
if (_enter and !STOPMOVING) {
    var _selected_song_name = songs[selected_song][0]; 
    var _path = working_directory + _selected_song_name + ".json";
    
    if (file_exists(_path)) {
        global.song_to_load = _selected_song_name;
        global.transitionShape = songs[selected_song][1];
        do_transition(rmGame);
        STOPMOVING = true;
    } else {
        show_error_msg = true;
        alarm[0] = 120; 
    }
}