draw_set_alpha(alpha);


var _STATE = oGameplay.noteTypeActual
var _SKIN = asset_get_index("s"+_skinPath);

if MISS = false {
if _STATE = 0 {_STATENOW = 3}
if _STATE > 0 {_STATENOW = 2}
} else {
	_STATENOW = 4
}

if dir = 1 {ler = 240}
else {ler = -240}
lerpX = lerp(lerpX,ler,0.1)

// Primero comprobamos que _SKIN sea un sprite válido (que no sea -1)
if (_SKIN != -1) {
    draw_sprite_ext(_SKIN, _STATENOW, x+lerpX, y+Y,image_xscale,image_yscale,angle,image_blend,alpha);
} else {
    draw_sprite_ext(svaso, _STATENOW, x+lerpX, y+Y,image_xscale,image_yscale,angle,image_blend,alpha);
    draw_text(x+240, y-190+Y, "ERROR: Skin no encontrada");
}

draw_set_halign(fa_center);
draw_set_color(col);
draw_text_transformed(x+lerpX, y+Y -110, TXT, 2, 2, 0);
draw_set_halign(fa_left);



draw_set_alpha(1);