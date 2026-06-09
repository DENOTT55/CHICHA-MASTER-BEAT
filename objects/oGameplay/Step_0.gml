// 1. PRIORIDAD: BOTÓN VOLVER (GUI)
var _gui_mx = device_mouse_x_to_gui(0);
var _gui_my = device_mouse_y_to_gui(0);

if (device_mouse_check_button_pressed(0, mb_left) and global.CHARTING_MODE = true) {
    if (_gui_mx > btn_back[0] && _gui_mx < btn_back[2] && _gui_my > btn_back[1] && _gui_my < btn_back[3]) {
        if audio_exists(audio_instance)
        {if (audio_is_playing(audio_instance)) audio_stop_sound(audio_instance);}
        do_transition(rmEditor); 
        exit; 
    }
}


if (keyboard_check_pressed(global.DEBUG1)) {
	    if audio_exists(audio_instance)
	    {if (audio_is_playing(audio_instance)) audio_stop_sound(audio_instance);}
		do_transition(rmEditor)
	    exit; 
}


var chartMode = global.CHARTING_MODE
var pausePulsed = keyboard_check_pressed(global.PAUSE) | keyboard_check_pressed(global.PAUSE2)

if chartMode
{
	if (pausePulsed and oUI.Mn = 1) {
	    if audio_exists(audio_instance)
	    {if (audio_is_playing(audio_instance)) audio_stop_sound(audio_instance);}
	    do_transition(rmEditor); 
	    exit; 
	}
}

if (pausePulsed and oUI.Mn = 1+chartMode) {
    if audio_exists(audio_instance)
    {if (audio_is_playing(audio_instance)) audio_stop_sound(audio_instance);}
    do_transition(room)
    exit; 
}

if (pausePulsed and oUI.Mn = 2+chartMode) {
    if audio_exists(audio_instance)
    {if (audio_is_playing(audio_instance)) audio_stop_sound(audio_instance);}
    do_transition(rmOptions); 
    exit; 
}

if (pausePulsed and oUI.Mn = 3+chartMode) {
    if audio_exists(audio_instance)
    {if (audio_is_playing(audio_instance)) audio_stop_sound(audio_instance);}
	global.CHARTING_MODE = false
    do_transition(rmMainMenu); 
    exit;
}

if (pausePulsed and oUI.Mn = 0) {
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
}

if !is_playing {exit}

// 2. ACTUALIZAR TIEMPO
if (precision_alpha > 0) precision_alpha -= 0.05; // Desvanecer texto de precisión

// ======================================================
// --- CONFIGURACIÓN MAESTRA DE COLUMNAS (FILAS) ---
// ======================================================
// Si la Fila 1 no detecta nada, es casi seguro que las notas 
// en tu editor están en la pista central (1) y no en la izquierda (0).
// Cambia _f1 a 1 si el índice 0 no detecta tus notas.
var _f1 = 1; // Fila 1 (Izquierda = 0, Centro = 1)
var _f2 = 2; // Fila 2 (Derecha = 2)
// ======================================================

// --- 2.5 LÓGICA DE SISTEMA DE INPUT DINÁMICO Y ALERTA ---
var _ancho_pantalla = display_get_gui_width(); 
var _mitad_pantalla = _ancho_pantalla / 2;

if (global.sistema_movil_avanzado) {
    var _nota_fila2_cerca = false;
    
    // Revisar si viene una nota en la Fila 2
    for (var i = 0; i < array_length(notes_array); i++) {
        var _n = notes_array[i];
        if (_n.col == _f2) { 
            global.tiempo_sin_fila2 = 0; // Reiniciamos contador
            
            if (abs(_n.time - current_time_sec) < 1.5) {
                _nota_fila2_cerca = true;
            }
        }
    }
    
    // Mostrar alerta solo si estamos en FULL y se acerca una nota de Fila 2
    global.alerta_cambio_input = (_nota_fila2_cerca && global.modo_input == "FULL");
    
    // Revertir a modo FULL tras 40 segundos sin notas en la Fila 2
    global.tiempo_sin_fila2 += delta_time / 1000000;
    if (global.tiempo_sin_fila2 > 5 && global.modo_input == "SPLIT") {
        global.modo_input = "FULL";
    }
}
// ------------------------------------------------------

// 3. LIMPIAR NOTAS (SISTEMA DE MISS)
for (var i = array_length(notes_array) - 1; i >= 0; i--) {
    var _n = notes_array[i];
    var _is_held = variable_struct_exists(_n, "is_being_held") && _n.is_being_held;
    
    if (!_is_held && current_time_sec > _n.time + 0.2) { 
        actualizar_puntuacion("MISS");
        crear_feedback(_n.col, "miss");
        var _player = playerChecker(_n.playerID);
        reproducir_animacion("miss",_player.playerID);
        detener_loop(); 
        
        // Forzar modo SPLIT si fallamos la nota de la Fila 2
        if (global.sistema_movil_avanzado && _n.col == _f2 && global.modo_input == "FULL") {
            global.modo_input = "SPLIT";
            global.alerta_cambio_input = false;
        }
        
        array_delete(notes_array, i, 1);
    }
}

// 4. DETECTAR PRESIÓN ACTUAL (Para lógicas de HOLD)
for(var i=0; i<3; i++) col_is_pressed[i] = false;

// Presión PC
if (keyboard_check(ord("A"))) col_is_pressed[0] = true;
if (keyboard_check(global.Lrow)) col_is_pressed[1] = true;
if (keyboard_check(global.Rrow)) col_is_pressed[2] = true;

// Presión Móvil
for (var i = 0; i < 5; i++) {
    if (device_mouse_check_button(i, mb_left)) {
        if (global.sistema_movil_avanzado) {
            var _tx_gui = device_mouse_x_to_gui(i); 
            
            if (global.modo_input == "FULL") {
                col_is_pressed[_f1] = true; // Todo presiona la Fila 1
                
                if (global.alerta_cambio_input && _tx_gui > _mitad_pantalla) {
                    col_is_pressed[_f2] = true; // Excepción para Fila 2
                }
            } else if (global.modo_input == "SPLIT") {
                if (_tx_gui < _mitad_pantalla) col_is_pressed[_f1] = true; 
                else col_is_pressed[_f2] = true; 
            }
        } else {
            // Sistema Clásico (desactivado por defecto)
            var _ty = device_mouse_y(i);
            for (var r = 0; r < 3; r++) {
                if (abs(_ty - row_y[r]) < 70) col_is_pressed[r] = true;
            }
        }
    }
}

// 5. ENTRADAS DE HIT (TAP / SWIPE / TECLADO)
var _keys = [ord("A"), global.Lrow, global.Rrow];
for (var k = 0; k < 3; k++) {
    if (keyboard_check_pressed(_keys[k])) check_hit(k, current_time_sec, "tap");
}
if (keyboard_check_pressed(global.SLrow)) check_hit(_f1, current_time_sec, "swipe");
if (keyboard_check_pressed(global.SRrow)) check_hit(_f2, current_time_sec, "swipe");

for (var i = 0; i < 5; i++) {
    var _tx = device_mouse_x(i);
    var _ty = device_mouse_y(i);
    var _tx_gui = device_mouse_x_to_gui(i); 
    
    if (device_mouse_check_button_pressed(i, mb_left)) {
        touch_start_y[i] = _ty; 
        touch_start_x[i] = _tx; 
        touch_start_time[i] = current_time_sec; 
        
        if (global.sistema_movil_avanzado) {
            var _target_col = _f1; 
            
            if (global.modo_input == "FULL") {
                if (global.alerta_cambio_input && _tx_gui > _mitad_pantalla) {
                    _target_col = _f2; 
                    global.modo_input = "SPLIT"; 
                    global.alerta_cambio_input = false;
                } else {
                    _target_col = _f1; 
                }
            } else if (global.modo_input == "SPLIT") {
                _target_col = (_tx_gui < _mitad_pantalla) ? _f1 : _f2; 
            }
            
            check_hit(_target_col, current_time_sec, "tap");
            
        } else {
            for (var r = 0; r < 3; r++) {
                if (abs(_ty - row_y[r]) < 60) check_hit(r, current_time_sec, "tap");
            }
        }
    }
    
    if (device_mouse_check_button(i, mb_left) && touch_start_y[i] != -1) {
        if (abs(_ty - touch_start_y[i]) > 40 || abs(_tx - touch_start_x[i]) > 40) {
            
            if (global.sistema_movil_avanzado) {
                var _target_col = _f1;
                if (global.modo_input == "FULL") {
                    if (global.alerta_cambio_input && _tx_gui > _mitad_pantalla) {
                        _target_col = _f2; 
                        global.modo_input = "SPLIT"; 
                        global.alerta_cambio_input = false;
                    } else {
                        _target_col = _f1;
                    }
                } else if (global.modo_input == "SPLIT") {
                    _target_col = (_tx_gui < _mitad_pantalla) ? _f1 : _f2; 
                }
                
                check_hit(_target_col, touch_start_time[i], "swipe");
                touch_start_y[i] = -1;
                touch_start_x[i] = -1; 
                
            } else {
                for (var r = 0; r < 3; r++) {
                    if (abs(_ty - row_y[r]) < 80) { 
                        check_hit(r, touch_start_time[i], "swipe"); 
                        touch_start_y[i] = -1;
                        touch_start_x[i] = -1; 
                        break;
                    }
                }
            }
        }
    }
}

// 6. ACTUALIZAR NOTAS LARGAS (HOLD) - SISTEMA COOL RELEASE
var _dt = delta_time / 1000000;
var _cool_window = 0.15; // Margen de error para soltar (en segundos)

for (var i = array_length(notes_array) - 1; i >= 0; i--) {
    var _n = notes_array[i];
    
    if (variable_struct_exists(_n, "is_being_held") && _n.is_being_held) {
        
        // CASO A: EL JUGADOR SOLTÓ EL BOTÓN
        if (!col_is_pressed[_n.col]) {
            if (_n.hold <= _cool_window) {
                actualizar_puntuacion("COOL RELEASE!");
                var _player = playerChecker(_n.playerID)
                reproducir_animacion("happy",_player.playerID); 
                puntos += 100;
                crear_feedback(_n.col, "tap");
				oUI.hitAngle = choose(5,-5);oUI.hitScale = 0.2
            } else {
                actualizar_puntuacion("MISS");
                detener_loop(); 
                crear_feedback(_n.col, "MISS");
                var _player = playerChecker(_n.playerID)
                reproducir_animacion("misshold",_player.playerID);
            }
            array_delete(notes_array, i, 1);
            continue;
        }

        // --- CASO B: EL JUGADOR SIGUE PRESIONANDO ---
        _n.time = current_time_sec; 
        _n.hold -= _dt;             
        
        if (_n.hold <= 0) {
            actualizar_puntuacion("PERFECT!"); 
            var _player = playerChecker(_n.playerID)
            reproducir_animacion("nice",_player.playerID); 
            puntos += 50; 
            crear_feedback(_n.col, "tap");
            array_delete(notes_array, i, 1);
			oUI.hitAngle = choose(5,-5);oUI.hitScale = 0.2
        }
    }
}

// ======================================================
// (Eventos de cámara y LERP a partir de aquí sin cambios)
// ======================================================
if (variable_instance_exists(id, "events_array") && array_length(events_array) > 0) {
    if (event_index_cam < array_length(events_array)) {
        while (event_index_cam < array_length(events_array) && current_time_sec >= events_array[event_index_cam].time) {
            var _event = events_array[event_index_cam];

            if (current_time_sec >= _event.time) {
                switch(_event.type) {
                    case 0: 
                        var _target = _event.val; 
                        cam_lerp_speed = _event.lerp_spd; 
                        
                        if (_target == "player") {
                            if (instance_exists(global.P1ID)) {
                                cam_target_x = global.P1ID.x;
                                cam_target_y = global.P1ID.y - 210;
                            }
                        }
                        else if (_target == "player2") {
                            if (instance_exists(global.P2ID)) {
                                cam_target_x = global.P2ID.x;
                                cam_target_y = global.P2ID.y - 210;
                            }
                            else if (instance_exists(global.P1ID)) {
                                cam_target_x = global.P1ID.x + 400;
                                cam_target_y = global.P1ID.y - 100;
                            }
                        }
                        else if (_target == "centro") {
                            if (instance_exists(global.P1ID) and instance_exists(global.P2ID)) {
                                cam_target_x = (global.P1ID.x + global.P2ID.x)/2;
                                cam_target_y = global.P1ID.y - 210;
                            }
                        }
                        else if (_target == "centrar") {
                            cam_target_x = room_width / 2;
                            cam_target_y = room_height / 2;
                        }
                        else if (_target == "publico") {
                            cam_target_x = room_width / 2;
                            cam_target_y = 400;
                        }
                        break;
                        
                    case 1: 
                        cam_target_zoom = _event.val;
                        cam_zoom_speed = _event.zoom_spd; 
                    break;
                        
                    case 2: 
                        cam_shake = _event.intensity;
                        break;
                        
                    case 3: 
                        NLINE = _event.line
                        hit_x_colEVENT[_event.line] += _event.plus
                        hit_x_colEVENTvel[_event.line] = _event.duration;
                    break;
					
					case 4: 
                        var _ID = _event.ID;
						var _col = _event.line;
						var _anim = _event.name;
                        
                        if (_ID == "0") {
                            if (instance_exists(global.P1ID)) {
                                global.P1ID.toX = hit_x_col[_col]
								if _anim != "noone"{reproducir_animacion(_anim,global.P1ID.playerID)}
                            }
                        }
                        else if (_ID == "1") {
                            if (instance_exists(global.P2ID)) {
                                global.P2ID.toX = hit_x_col[_col]
								if _anim != "noone"{reproducir_animacion(_anim,global.P2ID.playerID)}
                            }
                            else if (instance_exists(global.P1ID)) {
                                global.P1ID.toX = hit_x_col[_col]
								if _anim != "noone"{reproducir_animacion(_anim,global.P1ID.playerID)}
                            }
                        }
                    break;
                }
                
                show_debug_message("Evento disparado a las: " + string(_event.time));
                event_index_cam++; 
            }
        }
    }
}

cam_x = lerp(cam_x, cam_target_x, cam_lerp_speed);
cam_y = lerp(cam_y, cam_target_y, cam_lerp_speed);
cam_zoom = lerp(cam_zoom, cam_target_zoom, cam_zoom_speed);

var _sx = random_range(-cam_shake, cam_shake);
var _sy = random_range(-cam_shake, cam_shake);
cam_shake = lerp(cam_shake, 0, 0.1); 

var _view_w = 1152 * cam_zoom; 
var _view_h = 648 * cam_zoom;

camera_set_view_size(view_camera[0], _view_w, _view_h);
camera_set_view_pos(view_camera[0], (cam_x - _view_w/2) + _sx, (cam_y - _view_h/2) + _sy);