draw_set_font(global.Fonts.f1O)

draw_sprite_ext(sDjRoll,0,x,y,1,1,0,c_white,1)
draw_sprite_ext(sDjRoll,1,x,y,1,1,angle,c_white,1)

if angle < 360 {angle++}
else{angle = 0}

if room != rmFreeplay {exit}

// 1. Configurar la alineación del texto
draw_set_halign(fa_left);   
draw_set_valign(fa_middle); 

// 2. Variables de ajuste base
var _pad_left = 30;     
var _pad_right = 100;   
var _min_width = 200;   
var _icon_margin = 15;  
var _base_width = sprite_get_width(sSongCapsule); 

for (var i = 0; i < array_length(songs); ++i) {
    var _song_name = songs[i][0];
    var _ICONOS    = songs[i][1]; 
    
    var _y = center_y + (i * item_spacing) - current_scroll;
    var _x = song_visual_x[i];
    var _alpha = song_visual_alpha[i];

    var _text_w = string_width(_song_name);
    var _target_width = _pad_left + _text_w + _pad_right;
    _target_width = max(_target_width, _min_width);

    var _xscale = _target_width / _base_width;

    draw_sprite_ext(sSongCapsule, 0, _x, _y, _xscale + 0.25, 1, 0, c_white, _alpha);

    var _previous_alpha = draw_get_alpha();
    draw_set_alpha(_alpha);

    draw_text(_x + _pad_left + 30, _y + 55, _song_name);

    var _icon_x = _x + _target_width + _icon_margin;
    draw_sprite(_ICONOS, 0, _icon_x + 50, _y + 55); 
    
    draw_set_alpha(_previous_alpha);
}

// 8. Resetear las alineaciones
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// --- NUEVO: DIBUJAR EL ARTE ---
// Dibujamos el arte usando la variable 'art_x' animada por el Step
if (sprite_exists(current_art)) {
    // Si el origen de tu sprite de arte está en "Middle Center", quedará perfecto
    draw_sprite(current_art, 0, art_x, art_y);
}


// --- DIBUJAR MENSAJE DE ERROR ---
if (show_error_msg) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    draw_set_color(c_red); // Color de advertencia
    
    // Dibuja el texto centrado en la parte inferior de la pantalla
    // Ajusta las coordenadas room_width/2 y room_height - 50 a tu gusto
    draw_text(room_width / 2, room_height - 50, "Error: ¡El archivo de la canción no existe!");
    
    // Restablecer valores
    draw_set_color(c_white); 
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}