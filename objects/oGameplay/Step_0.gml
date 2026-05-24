

// 1. PRIORIDAD: BOTÓN VOLVER (GUI)
var _gui_mx = device_mouse_x_to_gui(0);
var _gui_my = device_mouse_y_to_gui(0);

if (device_mouse_check_button_pressed(0, mb_left)) {
    if (_gui_mx > btn_back[0] && _gui_mx < btn_back[2] && _gui_my > btn_back[1] && _gui_my < btn_back[3]) {
        if audio_exists(audio_instance)
        {if (audio_is_playing(audio_instance)) audio_stop_sound(audio_instance);}
        room_goto(rmEditor); 
        exit; 
    }
}

// 2. ACTUALIZAR TIEMPO
current_time_sec += delta_time / 1000000;
if (precision_alpha > 0) precision_alpha -= 0.05; // Desvanecer texto de precisión

// 3. LIMPIAR NOTAS (SISTEMA DE MISS)
for (var i = array_length(notes_array) - 1; i >= 0; i--) {
    var _n = notes_array[i];
    
    // Verificamos si la nota está siendo sostenida actualmente (para notas Hold)
    var _is_held = variable_struct_exists(_n, "is_being_held") && _n.is_being_held;
    
    // Si NO está siendo sostenida y se nos pasó el tiempo de la CABEZA (+0.2s de tolerancia)
    if (!_is_held && current_time_sec > _n.time + 0.2) { 
        actualizar_puntuacion("MISS");
        crear_feedback(_n.col, "miss");
		var _player = playerChecker(_n.playerID)
        reproducir_animacion("miss",_player.playerID);
        // --- AÑADIDO: Detener loop en caso de fallar y estar trabado, y reproducir miss ---
        detener_loop(); 
        
        array_delete(notes_array, i, 1);
    }
}

// 4. DETECTAR PRESIÓN ACTUAL (Para lógicas de HOLD)
// (Este bloque se mantiene igual que tu original)
for(var i=0; i<3; i++) col_is_pressed[i] = false;

// Presión PC
if (keyboard_check(ord("A"))) col_is_pressed[0] = true;
if (keyboard_check(ord("S"))) col_is_pressed[1] = true;
if (keyboard_check(ord("D"))) col_is_pressed[2] = true;

// Presión Móvil
for (var i = 0; i < 5; i++) {
    if (device_mouse_check_button(i, mb_left)) {
        var _ty = device_mouse_y(i);
        for (var r = 0; r < 3; r++) {
            if (abs(_ty - row_y[r]) < 70) col_is_pressed[r] = true;
        }
    }
}

// 5. ENTRADAS DE HIT (TAP / SWIPE / TECLADO)
var _keys = [ord("A"), ord("S"), ord("D")];
for (var k = 0; k < 3; k++) {
    if (keyboard_check_pressed(_keys[k])) check_hit(k, current_time_sec, "tap");
}
if (keyboard_check_pressed(vk_down)) check_hit(1, current_time_sec, "swipe");

for (var i = 0; i < 5; i++) {
    var _tx = device_mouse_x(i);
    var _ty = device_mouse_y(i);
    
    if (device_mouse_check_button_pressed(i, mb_left)) {
        touch_start_y[i] = _ty; 
        touch_start_x[i] = _tx; // --- AÑADIDO: Guardar también la X inicial ---
        
        for (var r = 0; r < 3; r++) {
            if (abs(_ty - row_y[r]) < 60) check_hit(r, current_time_sec, "tap");
        }
    }
    
    if (device_mouse_check_button(i, mb_left) && touch_start_y[i] != -1) {
        // --- MODIFICADO: Usar abs() para detectar cualquier dirección (Arriba, Abajo, Izquierda, Derecha) y bajar umbral a 40 ---
        if (abs(_ty - touch_start_y[i]) > 40 || abs(_tx - touch_start_x[i]) > 40) {
            for (var r = 0; r < 3; r++) {
                if (abs(_ty - row_y[r]) < 80) {
                    check_hit(r, current_time_sec, "swipe");
                    touch_start_y[i] = -1;
                    touch_start_x[i] = -1; // --- AÑADIDO: Limpiar la X también ---
                    break;
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
		        reproducir_animacion("happy",_player.playerID); // <--- AQUÍ: El Chichero se pone feliz
		        puntos += 100;
		        crear_feedback(_n.col, "tap");
		    } else {
		        actualizar_puntuacion("MISS");
		        detener_loop(); // Detiene el loop si falló
				crear_feedback(_n.col, "MISS");
				var _player = playerChecker(_n.playerID)
				reproducir_animacion("misshold",_player.playerID);
		    }
		    array_delete(notes_array, i, 1);
		    continue;
		}

        // --- CASO B: EL JUGADOR SIGUE PRESIONANDO ---
        _n.time = current_time_sec; // La nota se queda "pegada" al hit_x
        _n.hold -= _dt;            // La barra se va consumiendo
        
        // Si la barra se agota por completo mientras aún presiona
		if (_n.hold <= 0) {
		    actualizar_puntuacion("PERFECT!"); 
			var _player = playerChecker(_n.playerID)
		    reproducir_animacion("nice",_player.playerID); // <--- AQUÍ: Animación de éxito al terminar el hold
		    puntos += 50; 
		    crear_feedback(_n.col, "tap");
		    array_delete(notes_array, i, 1);
		}
    }
}

// Comprobamos que existan eventos y que el índice sea válido
if (variable_instance_exists(id, "events_array") && array_length(events_array) > 0) {
    
    // 1. LEER EVENTOS DEL CHART (Procesamiento por tipo)
    if (event_index_cam < array_length(events_array)) {
		
	while (event_index_cam < array_length(events_array) && current_time_sec >= events_array[event_index_cam].time) {
        var _event = events_array[event_index_cam];

        if (current_time_sec >= _event.time) {
            
            // Evaluamos según el TIPO de evento definido en tu script
            switch(_event.type) {
                
                case 0: // ENFOQUE (Metadata: Objetivo, Suavizado)
                    var _target = _event.val; // "player", "centro", etc.
                    cam_lerp_speed = _event.lerp_spd; // Usamos el lerp que pusimos en el editor
                    
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
                    
                case 1: // ZOOM DRAMÁTICO (Metadata: Nivel Zoom, Velocidad)
                    cam_target_zoom = _event.val;
                    cam_zoom_speed = _event.zoom_spd; // La velocidad de zoom también es dinámica ahora
                    break;
                    
                case 2: // EFECTO SACUDIDA (Metadata: Fuerza, Duración)
                    cam_shake = _event.intensity;
                    // Nota: Si quieres usar la duración, podrías usar una alarma o un timer
                    break;
				case 3: // CENTRO DE IMPACTO (Metadata: columna, Duración)
					NLINE = _event.line
					hit_x_colEVENT[_event.line] += _event.plus
                    hit_x_colEVENTvel[_event.line] = _event.duration;

                break;
            }
            
			show_debug_message("Evento disparado a las: " + string(_event.time));
            event_index_cam++; // Pasar al siguiente evento
        }
    }
	}
}
    // 2. MOTOR DE MOVIMIENTO (LERP)
    // Se mantiene igual, pero ahora usa los valores actualizados por los eventos
    cam_x = lerp(cam_x, cam_target_x, cam_lerp_speed);
    cam_y = lerp(cam_y, cam_target_y, cam_lerp_speed);
    cam_zoom = lerp(cam_zoom, cam_target_zoom, cam_zoom_speed);

    // 3. APLICAR SHAKE (Sacudida)
    var _sx = random_range(-cam_shake, cam_shake);
    var _sy = random_range(-cam_shake, cam_shake);
    cam_shake = lerp(cam_shake, 0, 0.1); 

    // 4. APLICAR A LA CÁMARA DE GAMEMAKER
    // Usamos tus valores de resolución (1152x648)
    var _view_w = 1152 * cam_zoom; 
    var _view_h = 648 * cam_zoom;

    camera_set_view_size(view_camera[0], _view_w, _view_h);
    camera_set_view_pos(view_camera[0], (cam_x - _view_w/2) + _sx, (cam_y - _view_h/2) + _sy);
