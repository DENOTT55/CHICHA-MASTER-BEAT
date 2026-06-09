draw_set_halign(fa_left);draw_set_font(global.Fonts.f1m)
var _w = room_width;
var _h = room_height;

// 1. Botones Principales (UI Principal)
btn_meta = [10, 10, 130, 60];
btn_play = [140, 10, 260, 60];

// --- CAMBIO: Rectángulos principales cambiados por sEditButtons ---
draw_sprite_stretched_ext(sEditButtons, 0, btn_meta[0], btn_meta[1], btn_meta[2] - btn_meta[0], btn_meta[3] - btn_meta[1], c_dkgray, 1);
draw_sprite_stretched_ext(sEditButtons, 0, btn_play[0], btn_play[1], btn_play[2] - btn_play[0], btn_play[3] - btn_play[1], c_dkgray, 1);

draw_set_color(c_white);
draw_text(btn_meta[0]+15, btn_meta[1]+20, "METADATOS");
draw_text(btn_play[0]+15, btn_play[1]+20, "PROBAR >");


// 2. Dibujar Grilla (CON PROTECCIÓN ANTI-CRASH)
var _pixel_interval = 64; 
var _safe_speed = 4;

try {
    // Intentamos convertir los inputs a valores reales puros
    var _bpm = real(global.chart_data.bpm);
    var _snap = real(global.chart_data.snap_div);
    var _speed = real(global.chart_data.note_speed*100);
    
    if (_bpm > 0 && _snap > 0 && _speed > 0) {
        var _beat_dur = 60 / _bpm;
        var _snap_interval = _beat_dur / _snap;
        _pixel_interval = _snap_interval * _speed;
        _safe_speed = _speed;
    }
} catch (_exception) {
    // Si el usuario borra todo ("") o escribe algo inválido, usamos fallbacks temporales
    _pixel_interval = 64;
    _safe_speed = 4;
}

// Candado extra: Evita a toda costa valores menores o iguales a cero
if (_pixel_interval <= 0) _pixel_interval = 64;

var _base_y = hit_y + (current_time_sec * _safe_speed);
var _start_y = _base_y % _pixel_interval;
while (_start_y > 0) _start_y -= _pixel_interval;

// Dibujar líneas centrales de guía visual
draw_set_color(c_dkgray);
for (var c = 0; c < 3; c++) {
    var _lx = col_x[c];
    draw_line_width(_lx, 0, _lx, _h, 1);
}

// Dibujar los cuadros de 64x64
draw_set_alpha(0.3);
draw_set_color(c_white);
var box_size = 64;
var half_box = box_size / 2;

for (var _y = _start_y; _y < _h; _y += _pixel_interval) {
    if (_y > 0) {
        for (var c = 0; c < 3; c++) {
            var _lx = col_x[c];
            draw_rectangle(_lx - half_box, _y - half_box, _lx + half_box, _y + half_box, true);
        }
    }
}
draw_set_alpha(1);

// DIBUJO DE LA HIT LINE + DESTELLO
draw_line_color(0, hit_y, _w, hit_y, c_red, c_red);
if (sync_flash > 0) {
    draw_set_alpha(sync_flash);
    draw_line_width_color(0, hit_y, _w, hit_y, 4, c_white, c_white);
    draw_set_alpha(1);
}

// 3. DIBUJAR NOTAS E INDICADOR DE SELECCIÓN
var _noteS = sNoteVisual; 

for (var i = 0; i < array_length(notes_array); i++) {
    var _note = notes_array[i];
    if (!variable_struct_exists(_note, "col")) continue;

    var _nx = col_x[_note.col];
    var _ny = hit_y - ((_note.time - current_time_sec) * _safe_speed);
    
    if (_ny > -100 && _ny < _h + 100) {
        if (variable_struct_exists(_note, "hold") && _note.hold > 0) {
            var _end_y = hit_y - (((_note.time + _note.hold) - current_time_sec) * _safe_speed);
            draw_set_color(c_aqua);
            draw_rectangle(_nx - 20, _ny, _nx + 20, _end_y, false);
        }
        
        if (selected_note == i) {
            draw_set_color(c_yellow);
            draw_rectangle(_nx - 36, _ny - 36, _nx + 36, _ny + 36, false); 
        }
        
        draw_set_color(c_white);
        if (sprite_exists(_noteS)) {
            var _img = is_numeric(_note.type) ? _note.type : 0;
            draw_sprite(_noteS, _img, _nx, _ny);
        }
		
		if (sprite_exists(_noteS) and global.chart_data.playersMax>1) {
			
			var sContainer = skinFunction(player[_note.playerID])
			var sICON = sContainer.icon.spr
			
            draw_sprite_ext(sICON, 0, _nx+25, _ny-25,0.4,0.4,15,c_white,1);
        }
    }
}

// 4. DIBUJAR EVENTOS EN LA GRILLA
for (var e = 0; e < array_length(events_array); e++) {
    var _ev = events_array[e];
    var _ex = col_x[0];
    var _ey = hit_y - ((_ev.time - current_time_sec) * _safe_speed);
    
    if (_ey > -50 && _ey < _h + 50) {
        draw_set_color(c_purple);
        draw_line_width(0, _ey, _w, _ey, 1);
        
        var _meta = get_event_metadata(_ev.type);
        var _color = (selected_event == e) ? c_yellow : c_white;
        draw_sprite_ext(_meta.spr, 0, _ex, _ey, 1, 1, 0, _color, 1);
    }
}

// 5. SISTEMA DE MENÚS (METADATOS O EDICIÓN)
if (show_meta_menu) {
    draw_set_color(c_black); draw_set_alpha(0.8); draw_rectangle(0, 0, _w, _h, false); draw_set_alpha(1);
    
    var _mx1 = _w * 0.1, _my1 = _h * 0.15, _mx2 = _w * 0.9, _my2 = _h * 0.9; // _my1 bajó un poco para dar espacio a las solapas
    
    // --- DIBUJAR SOLAPAS (TABS) ---
    var _tabs_count = array_length(meta_menu_layout);
    var _tab_w = (_mx2 - _mx1) / _tabs_count;
    
    for (var t = 0; t < _tabs_count; t++) {
        var _tx1 = _mx1 + (t * _tab_w);
        var _ty1 = _my1 - 40; // Sobresale 40px hacia arriba
        
        // Color activo vs inactivo
        draw_set_color(current_meta_tab == t ? c_dkgray : c_gray);
        draw_rectangle(_tx1, _ty1, _tx1 + _tab_w, _my1, false);
        draw_set_color(c_white);
        draw_text(_tx1 + 15, _ty1 + 10, meta_menu_layout[t].tab_name);
        
        // Detectar Clic en solapa (Directo en draw para agilizar UI)
        if (mouse_check_button_pressed(mb_left) && mouse_x > _tx1 && mouse_x < _tx1 + _tab_w && mouse_y > _ty1 && mouse_y < _my1) {
            current_meta_tab = t;
            active_input = ""; // Resetea si estabas escribiendo
        }
    }
    
    // --- FONDO DEL MENÚ ---
    draw_set_color(c_dkgray);
    draw_rectangle(_mx1, _my1, _mx2, _my2, false);
    
    // --- CONTENIDO DE LA SOLAPA ACTUAL ---
    var _iy = _my1 + 20;
    var _current_elements = meta_menu_layout[current_meta_tab].elements;
    var _click_pressed = mouse_check_button_pressed(mb_left);
    
    for(var i = 0; i < array_length(_current_elements); i++) {
        var _elem = _current_elements[i];
        
        // A. SI EL ELEMENTO ES LA LISTA DE PERSONAJES
        if (_elem.type == "players_list") {
            for (var p = 0; p < global.chart_data.playersMax; ++p) {
                var sContainer = skinFunction(player[p]);
                var sICON = sContainer.icon.spr;
                
                var _icon_x = _mx1 + 80;
                var _icon_y = _iy + 30; // Centrado en su respectiva fila
                
                draw_sprite(sIconBG, 0, _icon_x, _icon_y);
                draw_sprite_ext(sICON, 0, _icon_x, _icon_y,0.8,0.8,0,c_white,1);
                
                var _w_icon = sprite_get_width(sIconBG);
                var _h_icon = sprite_get_height(sIconBG);
                var _hover_icon = (mouse_x > _icon_x - _w_icon/2 && mouse_x < _icon_x + _w_icon/2 && mouse_y > _icon_y - _h_icon/2 && mouse_y < _icon_y + _h_icon/2);
                
                var _box_x1 = _icon_x + _w_icon/2 + 10;
                var _box_x2 = _box_x1 + 180;
                var _box_y1 = _icon_y - 15;
                var _box_y2 = _icon_y + 15;
                var _hover_box = (mouse_x > _box_x1 && mouse_x < _box_x2 && mouse_y > _box_y1 && mouse_y < _box_y2);
                
                // Activar edición al hacer clic en icono O en la caja
                if ((_hover_icon || _hover_box) && _click_pressed) {
                    editing_player_name = p;
                    active_input = ""; // Desactivar variables normales
                    keyboard_string = string(player[p]);
                    if (os_type == os_android) keyboard_virtual_show(kbv_type_default, kbv_returnkey_done, kbv_autocapitalize_none, false);
                }
                
                // Dibujo de la caja
                if (editing_player_name == p) {
                    draw_set_color(c_white);
                    draw_rectangle(_box_x1, _box_y1, _box_x2, _box_y2, false);
                    draw_set_color(c_black);
                    draw_text(_box_x1 + 5, _box_y1 + 5, string(player[p]) + "|");
                    
                    // Cerrar edición si se da clic afuera
                    if (_click_pressed && !_hover_icon && !_hover_box) {
                        editing_player_name = -1;
                        if (os_type == os_android) keyboard_virtual_hide();
                    }
                } else {
                    draw_set_color(c_gray);
                    draw_rectangle(_box_x1, _box_y1, _box_x2, _box_y2, false);
                    draw_set_color(c_white);
                    draw_text(_box_x1 + 5, _box_y1 + 5, string(player[p]));
                }
                
                _iy += 65; // Aumentar espacio en Y para el siguiente personaje
            }
        
        // B. SI EL ELEMENTO ES BOOL (CHECKBOX)
        } else if (_elem.type == "bool") {
            var _k = _elem.key;
            var _val = global.chart_data[$ _k];
            
            draw_set_color(c_gray);
            draw_rectangle(_mx1 + 20, _iy, _mx2 - 300, _iy + 35, false);
            draw_set_color(c_white);
            
            var _box_x = (_mx2 - 300) - 30; 
            draw_rectangle(_box_x, _iy + 5, _box_x + 25, _iy + 30, true);
            if (_val == true) { 
                draw_rectangle(_box_x + 5, _iy + 10, _box_x + 20, _iy + 25, false);
            }
            draw_text(_mx1 + 30, _iy + 8, _elem.label);
            
            if (_click_pressed && mouse_x > _mx1 + 20 && mouse_x < _mx2 - 300 && mouse_y > _iy && mouse_y < _iy + 35) {
                global.chart_data[$ _k] = !_val;
            }
            _iy += 45; 
            
        // C. SI EL ELEMENTO ES TEXTO O NÚMERO
        } else {
            var _k = _elem.key;
            
            draw_set_color(active_input == _k ? c_ltgray : c_gray);
            draw_rectangle(_mx1 + 20, _iy, _mx2 - 300, _iy + 35, false);
            draw_set_color(c_white);
            
            var _val_str = string(global.chart_data[$ _k]);
            if (active_input == _k) _val_str += "|";
            draw_text(_mx1 + 30, _iy + 8, _elem.label + ": " + _val_str);
            
            if (_click_pressed && mouse_x > _mx1 + 20 && mouse_x < _mx2 - 300 && mouse_y > _iy && mouse_y < _iy + 35) {
                active_input = _k;
                active_input_type = _elem.type;
                editing_player_name = -1; // Asegurar que no estemos editando personajes a la vez
                
                if (_elem.type == "number") {
                    active_input_min = _elem.min_val;
                    active_input_max = _elem.max_val;
                }
                
                keyboard_string = string(global.chart_data[$ _k]);
                if (os_type == os_android) keyboard_virtual_show(kbv_type_default, kbv_returnkey_done, kbv_autocapitalize_none, false);
            }
            _iy += 45; 
        }
    }
	
	// --- CAMBIO: Variable para detectar clics únicos al abrir/cerrar casillas ---
    var _click_pressed = mouse_check_button_pressed(mb_left);

    //icons
    /*
    for (var i = 0; i < global.chart_data.playersMax; ++i) {
        var sContainer = skinFunction(player[i]);
        var sICON = sContainer.icon.spr;
        
        var _icon_x = _mx2 - 200;
        var _icon_y = _iy - 300 + (60 * i);
        
        draw_sprite(sIconBG, 0, _icon_x, _icon_y);
        draw_sprite(sICON, 0, _icon_x, _icon_y);
        
        // Calcular el área interactiva del icono (Origen en el CENTRO)
        var _w_icon = sprite_get_width(sIconBG);
        var _h_icon = sprite_get_height(sIconBG);
        var _hover_icon = (mouse_x > _icon_x - _w_icon/2 && mouse_x < _icon_x + _w_icon/2 && mouse_y > _icon_y - _h_icon/2 && mouse_y < _icon_y + _h_icon/2);
        
        // A. Abrir la caja de texto al hacer clic en el icono
        if (_hover_icon && _click_pressed) {
            editing_player_name = i;
            keyboard_string = string(player[i]); 
        }
        
        // Variables para la posición de la caja (Lado DERECHO del icono)
        var _box_x1 = _icon_x + _w_icon/2 + 10;  // Inicia 10px a la derecha del icono
        var _box_x2 = _box_x1 + 150;             // 150px de ancho para escribir
        var _box_y1 = _icon_y - 15;              // Centrado verticalmente (30px de alto total)
        var _box_y2 = _icon_y + 15;
        
        // B. Lógica si ESTE jugador está siendo editado
        if (editing_player_name == i) {
            player[i] = keyboard_string; 
            
            // Dibujar la caja de texto blanca
            draw_set_color(c_white);
            draw_rectangle(_box_x1, _box_y1, _box_x2, _box_y2, false);
            
            // Dibujar el texto negro escribiéndose
            draw_set_color(c_black);
            draw_text(_box_x1 + 5, _box_y1 + 5, string(player[i]) + "|"); 
            
            // C. Cerrar si se hace clic fuera del icono y de la caja
            var _hover_box = (mouse_x > _box_x1 && mouse_x < _box_x2 && mouse_y > _box_y1 && mouse_y < _box_y2);
            if (_click_pressed && !_hover_icon && !_hover_box) {
                editing_player_name = -1;
            }
        } else {
            // D. Dibujar el texto blanco normal si no se está editando
            draw_set_color(c_white);
            draw_text(_box_x1 + 5, _box_y1 + 5, string(player[i]));
        }
    }*/
    
    var _btn_y = _my2 - 70;
    btn_save = [_mx1 + 20, _btn_y, _mx1 + 140, _btn_y + 50];
    btn_load = [_mx1 + 150, _btn_y, _mx1 + 270, _btn_y + 50];
    btn_close_meta = [_mx2 - 120, _btn_y, _mx2 - 20, _btn_y + 50];
    
    // --- CAMBIO: Detección visual de presión interactiva para los botones de control ---
    var _mx = mouse_x;
    var _my = mouse_y;
    var _click = mouse_check_button(mb_left);
    
    var _press_save  = (_mx > btn_save[0] && _mx < btn_save[2] && _my > btn_save[1] && _my < btn_save[3] && _click);
    var _press_load  = (_mx > btn_load[0] && _mx < btn_load[2] && _my > btn_load[1] && _my < btn_load[3] && _click);
    var _press_close = (_mx > btn_close_meta[0] && _mx < btn_close_meta[2] && _my > btn_close_meta[1] && _my < btn_close_meta[3] && _click);
    
    // Si se presionan, oscurecemos el color base
    var _c_save  = _press_save  ? merge_color(c_green, c_black, 0.3) : c_green;
    var _c_load  = _press_load  ? merge_color(c_teal, c_black, 0.3)  : c_teal;
    var _c_close = _press_close ? merge_color(c_red, c_black, 0.3)   : c_red;
    
    // Si se presionan, desplazamos el dibujo 2px hacia abajo (efecto click click)
    var _y_save  = _press_save  ? 2 : 0;
    var _y_load  = _press_load  ? 2 : 0;
    var _y_close = _press_close ? 2 : 0;
    
    draw_sprite_stretched_ext(sEditButtons, 0, btn_save[0], btn_save[1] + _y_save, btn_save[2] - btn_save[0], btn_save[3] - btn_save[1], _c_save, 1);
    draw_sprite_stretched_ext(sEditButtons, 0, btn_load[0], btn_load[1] + _y_load, btn_load[2] - btn_load[0], btn_load[3] - btn_load[1], _c_load, 1);
    draw_sprite_stretched_ext(sEditButtons, 0, btn_close_meta[0], btn_close_meta[1] + _y_close, btn_close_meta[2] - btn_close_meta[0], btn_close_meta[3] - btn_close_meta[1], _c_close, 1);
    
    draw_set_color(c_white);
    draw_text(btn_save[0] + 15, btn_save[1] + 15 + _y_save, "GUARDAR");
    draw_text(btn_load[0] + 15, btn_load[1] + 15 + _y_load, "CARGAR");
    draw_text(btn_close_meta[0] + 15, btn_close_meta[1] + 15 + _y_close, "CERRAR");

} else {
    // --- MENÚ ESCALABLE DE LA NOTA SELECCIONADA ---
    if (selected_note != -1) {
        var _panel_x = room_width - 320; 
        var _note_ref = notes_array[selected_note];
        
        draw_set_color(c_dkgray);
        draw_rectangle(_panel_x, 80, room_width - 10, 520, false); 
        draw_set_color(c_white);
        
        draw_text_transformed(_panel_x + 10, 90, "EDITAR NOTA", 1, 1, 0);
        draw_line(_panel_x + 10, 115, room_width - 20, 115);

        var _n_keys = variable_struct_get_names(_note_ref);
        var _ny_text = 150; 

        for(var j=0; j<array_length(_n_keys); j++) {
            var _nk = _n_keys[j];
            if (_nk == "col" || _nk == "time") continue; 

            draw_set_color(c_white);
            draw_text(_panel_x + 10, _ny_text, string_upper(_nk) + ":");
            
            var _val = _note_ref[$ _nk];
            draw_set_color(c_aqua);
            draw_text(_panel_x + 10, _ny_text + 30, string(_val));

            var _btn_w = 45;
            var _btn_h = 45;
            var bx1 = room_width - 110; 
            var bx2 = room_width - 60;  

            // --- CAMBIO: Botones + y - cambiados por sEditButtons ---
            draw_sprite_stretched_ext(sEditButtons, 0, bx1, _ny_text, _btn_w, _btn_h, c_white, 1);
            draw_sprite_stretched_ext(sEditButtons, 0, bx2, _ny_text, _btn_w, _btn_h, c_white, 1);
            
            draw_set_color(c_white);
            draw_text_transformed(bx1 + 12, _ny_text + 10, "+", 1.5, 1.5, 0);
            draw_text_transformed(bx2 + 15, _ny_text + 10, "-", 1.5, 1.5, 0);

            if (mouse_check_button_pressed(mb_left)) {
                var mx = mouse_x; var my = mouse_y;
                if (my > _ny_text && my < _ny_text + _btn_h) {
                    var _step = (_nk == "hold") ? 0.1 : 1;
                    if (mx > bx1 && mx < bx1 + _btn_w) _note_ref[$ _nk] += _step;
                    if (mx > bx2 && mx < bx2 + _btn_w) _note_ref[$ _nk] -= _step;
                    
                    if (_note_ref[$ _nk] < 0) _note_ref[$ _nk] = 0; 
                }
            }
            _ny_text += 70; 
        }
        
        // --- CAMBIO: Botón BORRAR cambiado por sEditButtons ---
        //draw_sprite_stretched_ext(sEditButtons, 0, _panel_x + 10, 460, (room_width - 20) - (_panel_x + 10), 510 - 460, c_red, 1);
        draw_set_color(c_red);
        draw_text(_panel_x + 20, 475, "BORRAR [DEL]");
        
        if (keyboard_check_pressed(vk_delete)) {
            array_delete(notes_array, selected_note, 1);
            selected_note = -1;
        }
    }

    // --- MENÚ ESCALABLE DE EVENTOS ---
    if (selected_event != -1) {
        var _panel_x = room_width - 320; 
        var _ev_ref = events_array[selected_event];
        var _meta = get_event_metadata(_ev_ref.type);

        draw_set_color(c_dkgray);
        draw_rectangle(_panel_x, 80, room_width - 10, 520, false); 
        draw_set_color(c_white);
        
        draw_text_transformed(_panel_x + 10, 90, "EVENTO: " + _meta.name, 1, 1, 0);
        draw_line(_panel_x + 10, 115, room_width - 20, 115);

        var _props = _meta.properties;
        var _ey_text = 150; 

        for(var j=0; j < array_length(_props); j++) {
            var _p = _props[j]; 
            var _key = _p.key;  
            var _current_val = _ev_ref[$ _key];

            draw_set_color(c_white);
            draw_text(_panel_x + 10, _ey_text, _p.name + ":");
            
            draw_set_color(c_aqua);
            draw_text(_panel_x + 10, _ey_text + 30, string(_current_val)); 

            var _btn_w = 45;
            var _btn_h = 45;
            var bx1 = room_width - 110; 
            var bx2 = room_width - 60;  
            
            // --- CAMBIO: Botones + y - de eventos cambiados por sEditButtons ---
            draw_sprite_stretched_ext(sEditButtons, 0, bx1, _ey_text, _btn_w, _btn_h, c_white, 1);
            draw_sprite_stretched_ext(sEditButtons, 0, bx2, _ey_text, _btn_w, _btn_h, c_white, 1);
            
            draw_set_color(c_white);
            draw_text_transformed(bx1 + 12, _ey_text + 10, "+", 1.5, 1.5, 0);
            draw_text_transformed(bx2 + 15, _ey_text + 10, "-", 1.5, 1.5, 0);

            if (mouse_check_button_pressed(mb_left)) {
                var mx = mouse_x; var my = mouse_y;
                if (my > _ey_text && my < _ey_text + _btn_h) {
                    
                    if (mx > bx1 && mx < bx1 + _btn_w) { 
                        if (_p.type == "list") {
                            var _opts = _p.options;
                            var _idx = 0;
                            for(var o=0; o<array_length(_opts); o++) { if (_opts[o] == _current_val) _idx = o; }
                            _idx++;
                            if (_idx >= array_length(_opts)) _idx = 0;
                            _ev_ref[$ _key] = _opts[_idx];
                        } else {
                            _ev_ref[$ _key] += _p.step;
                        }
                    }
                    
                    if (mx > bx2 && mx < bx2 + _btn_w) { 
                        if (_p.type == "list") {
                            var _opts = _p.options;
                            var _idx = 0;
                            for(var o=0; o<array_length(_opts); o++) { if (_opts[o] == _current_val) _idx = o; }
                            _idx--;
                            if (_idx < 0) _idx = array_length(_opts) - 1;
                            _ev_ref[$ _key] = _opts[_idx];
                        } else {
                            _ev_ref[$ _key] -= _p.step;
                        }
                    }
                }
            }
            _ey_text += 70; 
        }
    }
}

draw_set_alpha(alpha);
draw_text(_w/2, 30, TXT);
draw_set_alpha(1);