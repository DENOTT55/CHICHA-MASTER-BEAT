// Botón Volver row_y
draw_set_color(c_dkgray);
draw_rectangle(btn_back[0], btn_back[1], btn_back[2], btn_back[3], false);
draw_set_color(c_white);
draw_text(btn_back[0]+15, btn_back[1]+15, "< MENU");

// Puntos y Combo
draw_set_halign(fa_right);
draw_text(room_width - 20, 20, "SCORE: " + string(puntos));
draw_text(room_width - 20, 50, "MAX COMBO: " + string(max_combo));
draw_set_halign(fa_center);
draw_set_font(-1);

/*
if (combo > 1) {
    draw_text_transformed(room_width/2, 100, string(combo) + " COMBO", 1.5, 1.5, 0);
}*/

draw_set_halign(fa_left); // Resetear alineación

// 2. Dibujar las 3 filas horizontales usando nuestro arreglo row_y
draw_set_color(c_white);
for (var i = 0; i < 3; i++) {
    var _ly = row_y[i];
    draw_line_width_color(0, _ly, room_width, _ly, 2, c_dkgray, c_dkgray);
}

// --- CONFIGURACIÓN DE SKIN ---
var _skinPath = global.chart_data.skin_name;
var _noteS = asset_get_index("s"+_skinPath);

if (_noteS == -1) {
    show_debug_message("¡CUIDADO! No se encontró la skin: s" + string(_skinPath));
    _noteS = svaso; 
}

// 3. Dibujar la línea o receptor de HIT (Ahora dibuja uno en el centro de cada fila)
draw_set_alpha(0.4);
for (var c = 1; c < 3; c++) {
    draw_sprite(_noteS, 4, hit_x_col[c], row_y[c]);
}
draw_set_alpha(1);

hit_x_col[NLINE] = lerp(hit_x_col[NLINE],hit_x_colEVENT[NLINE],hit_x_colEVENTvel[NLINE])

// 4. Dibujar las Notas con Direcciones Variables
for (var i = 0; i < array_length(notes_array); i++) {
    var _note = notes_array[i];
    
    if (!variable_struct_exists(_note, "max_hold")) {
        _note.max_hold = _note.hold; 
    }
    
    var _ny = row_y[_note.col];
    
    // Obtenemos la dirección y el punto de impacto de esta columna específica
    var _dir = dir_col[_note.col];
    var _base_x = hit_x_col[_note.col];
    
    // Si _dir es 1 se resta (viene de la izquierda), si es -1 se suma (viene de la derecha)
    var _nx = _base_x - _dir * ((_note.time - current_time_sec) * note_speed);
    
    // Solo dibujar si está en pantalla
    if (_nx > -100 && _nx < room_width + 100) {
        
        var _fill = 0;
        
        // Dibujar cuerpo de la nota sostenida (Hold)
        if (_note.hold > 0) {
            var _hold_end_x = _base_x - _dir * (((_note.time + _note.hold) - current_time_sec) * note_speed);
            draw_set_color(c_aqua);
            // Si necesitas renderizar la línea de hold horizontal descomenta abajo ajustando el sentido
            // draw_line_width(_nx, _ny, _hold_end_x, _ny, 20);
            _fill = 1;
        }
        
        // Color según tipo o carril
        var _color = c_white;
        if (_note.col == 0) _color = c_orange; 
        if (_note.type == 2) _color = c_fuchsia; 
        
        draw_set_color(_color);
        draw_sprite(_noteS, _note.type + _fill, _nx, _ny);
        
        // --- EFECTO VISUAL: LLENAR EL VASO ---
        if (_note.max_hold > 0 && _note.hold < _note.max_hold) {
            var _pct = 1 - (_note.hold / _note.max_hold);
            
            var _sw = sprite_get_width(_noteS);
            var _sh = sprite_get_height(_noteS);
            var _sx = sprite_get_xoffset(_noteS);
            var _sy = sprite_get_yoffset(_noteS);
            
            var _part_h = _sh * _pct;
            var _part_top = _sh - _part_h; 
            
            draw_sprite_part_ext(
                _noteS,                     
                _note.type + _fill,         
                0, _part_top,               
                _sw, _part_h,               
                _nx - _sx, _ny - _sy + _part_top, 
                1, 1,                       
                c_aqua, 0.6                 
            );
        }
    }
}