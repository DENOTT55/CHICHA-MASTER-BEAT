;draw_set_font(global.Fonts.f1Om)

/*
if (combo > 1) {
    draw_text_transformed(room_width/2, 100, string(combo) + " COMBO", 1.5, 1.5, 0);
}*/

draw_set_halign(fa_left); // Resetear alineación

// 2. Dibujar las 3 filas horizontales usando nuestro arreglo row_y
draw_set_color(c_white);
for (var i = 0; i < 3; i++) {
    var _ly = row_y[i];
    //draw_line_width_color(0, _ly, room_width, _ly, 2, c_dkgray, c_dkgray);
}

// --- CONFIGURACIÓN DE SKIN ---
var _skinPath = global.chart_data.skin_name;
var _noteS = asset_get_index("s"+_skinPath);
var _noteSHand = asset_get_index(string(_noteS)+"hand");

if (_noteS == -1) {
    show_debug_message("¡CUIDADO! No se encontró la skin: s" + string(_skinPath));
    _noteS = svaso; 
}

if (_noteSHand == -1) {
    show_debug_message("¡CUIDADO! No se encontró la skin: s" + string(_skinPath));
    _noteSHand = svasohand; 
}

// 3. Dibujar la línea o receptor de HIT (Ahora dibuja uno en el centro de cada fila)
draw_set_alpha(0.4);
for (var c = 1; c < 3; c++) {
    //draw_sprite(_noteS, 4, hit_x_col[c], row_y[c]);
}
draw_set_alpha(1);

hit_x_col[NLINE] = lerp(hit_x_col[NLINE],hit_x_colEVENT[NLINE],hit_x_colEVENTvel[NLINE])



// ==============================================================================
// 4. PREPARACIÓN Y CÁLCULO DE DISTANCIAS CERCANAS (NUEVO SECTION)
// ==============================================================================

// Creamos una estructura rápida para guardar la distancia de la nota más cercana en cada columna.
// Inicializamos con un número muy alto (infinito) para que cualquier nota esté más cerca.
var _min_dists_by_col = {}; 
var _num_cols = array_length(dir_col);
for (var c = 0; c < _num_cols; c++) {
    variable_struct_set(_min_dists_by_col, string(c), 999999);
}

// PRIMER PASO RÁPIDO: Solo calcular posiciones y encontrar la nota más cercana por carril
for (var i = 0; i < array_length(notes_array); i++) {
    var _note = notes_array[i];
    var _base_x = hit_x_col[_note.col];
    var _dir = dir_col[_note.col];
    
    // Calculamos la X de la nota (igual que antes)
    var _nx = _base_x - _dir * ((_note.time - current_time_sec) * note_speed);
    
    // Calculamos la distancia absoluta al centro del hit
    var _dist = abs(_base_x - _nx);
    
    // Actualizamos la distancia mínima para esta columna si esta nota está más cerca
    var _col_key = string(_note.col);
    var _current_min = variable_struct_get(_min_dists_by_col, _col_key);
    if (_dist < _current_min) {
        variable_struct_set(_min_dists_by_col, _col_key, _dist);
    }
}

// ==============================================================================
// 5. DIBUJAR LOS RECEPTORES DEL HIT (NUEVO SECTION)
// ==============================================================================
// Definimos los rangos de aparición para los receptores
// Queremos que empiecen a aparecer cuando una nota esté a 200px y sean 100% visibles a 20px.
var _r_invisible_at = 200;
var _r_full_visible_at = 20;

// Dibujamos un receptor para cada columna
for (var c = 0; c < _num_cols; c++) {
    var _rx = hit_x_col[c];
    var _ry = row_y[c];
    
    // Obtenemos la distancia de la nota más cercana a esta columna
    var _closest_dist = variable_struct_get(_min_dists_by_col, string(c));
    
    // CÁLCULO OPACIDAD DEL RECEPTOR: Entre más cerca la nota (< _closest_dist), más alto el alpha
    var _r_alpha = 1 - clamp((_closest_dist - _r_full_visible_at) / (_r_invisible_at - _r_full_visible_at), 0, 1);
    
    // Dibujamos el receptor (puedes usar el mismo sprite de vaso _noteS o uno gris/especial)
    // He usado c_dkgray y alpha base 0.5 para que el receptor sea sutil al aparecer
    draw_sprite_ext(_noteS, 0, _rx, _ry, 1, 1, 0, c_black, _r_alpha * 0.7); 
}


// ==============================================================================
// 6. DIBUJAR LAS NOTAS (TU CÓDIGO CON EL FADE-IN ANTERIOR)
// ==============================================================================
// (Mantenemos exactamente el mismo bucle de dibujo de notas que optimizamos antes)
for (var i = 0; i < array_length(notes_array); i++) {
    var _note = notes_array[i];
    
    if (!variable_struct_exists(_note, "max_hold")) {
        _note.max_hold = _note.hold; 
    }
    
    var _ny = row_y[_note.col];
    var _dir = dir_col[_note.col];
    var _base_x = hit_x_col[_note.col];
    var _nx = _base_x - _dir * ((_note.time - current_time_sec) * note_speed);
    
    if (_nx > -100 && _nx < room_width + 100) {
        
        // --- EFECTO VISUAL: NOTAS APARECEN POCO A POCO (FADE IN) ---
        var _dist = abs(_base_x - _nx);
        var _dist_full = 150; // Totalmente visible a 150px antes del centro
        var _dist_fade = 300; // Transición de 300px
        var _alpha = clamp(1 - ((_dist - _dist_full) / _dist_fade), 0, 1);
        
        var _fill = 1;
        
        // Dibujar cuerpo de la nota sostenida (Hold)
        if (_note.hold > 0)  {
            draw_set_alpha(_alpha); // Aplicamos alpha a la línea
            draw_set_color(c_aqua);
            // draw_line_width(_nx, _ny, _base_x, _ny, 20); // Hold horizontal básico
            draw_set_alpha(1); // Restauramos alpha
            _fill = 0;
        }
        
        // Color según tipo o carril
        var _color = c_white;
        if (_note.col == 0) _color = c_orange; 
        if (_note.type == 1)  _fill = 0;
		
		if (_note.type == 0 and _note.hold == 0) _fill = 2;
        
        // Usamos draw_sprite_ext para aplicar _alpha
        draw_sprite_ext(_noteS, _note.type + _fill, _nx, _ny, 1, 1, 0, _color, _alpha);
        
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
                c_aqua, 0.6 * _alpha // Multiplicamos tu 0.6 base por nuestro alpha dinámico                 
            );
        }
        
        // Dibujamos la mano por encima, también con draw_sprite_ext
        draw_sprite_ext(_noteSHand, 0, _nx, _ny, 1, 1, 0, c_white, _alpha);
    }
}