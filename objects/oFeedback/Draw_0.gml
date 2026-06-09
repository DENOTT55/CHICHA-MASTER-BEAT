draw_set_alpha(alpha);draw_set_font(global.Fonts.f1Om)


var _STATE = oGameplay.noteTypeActualType
var _HOLD = oGameplay.noteTypeActual
var _SKIN = asset_get_index("s"+_skinPath);
var _SKINHAND = asset_get_index(string(_SKIN)+"hand");

var holdSum = 0
var wellDone = 0

if _HOLD != 0 {holdSum = 3}

if MISS = false {
if _STATE == 0 {_STATENOW = 4-holdSum}
if _STATE == 1 {_STATENOW = 3}
if _STATE == 2 {_STATENOW = 3}

wellDone = 1
} else {
	_STATENOW = 0
	wellDone = 0
}

if dir = 1 {ler = 240}
else {ler = -240}
lerpX = lerp(lerpX,ler,0.1)

// Primero comprobamos que _SKIN sea un sprite válido (que no sea -1)
if (_SKIN != -1) {
    draw_sprite_ext(_SKIN, _STATENOW, x+lerpX, y+Y,image_xscale,image_yscale,angle,image_blend,alpha);
} else {
    draw_sprite_ext(svaso, _STATENOW, x+lerpX, y+Y,image_xscale,image_yscale,angle,image_blend,alpha);
    //draw_text(x+240, y-190+Y, "ERROR: Skin no encontrada");
	show_debug_message( "ERROR: Skin no encontrada")
}

if (_SKINHAND != -1) {
    draw_sprite_ext(_SKINHAND, _STATENOW, x+lerpX, y+Y+50,image_xscale,image_yscale,0,image_blend,alpha);
} else {
    draw_sprite_ext(svasohand, 1+wellDone, x+lerpX, y+Y+50,image_xscale,image_yscale,0,image_blend,alpha);
    //draw_text(x+240, y-190+Y, "ERROR: Skin no encontrada");
	show_debug_message( "ERROR: Skin no encontrada")
}

draw_set_halign(fa_center);
draw_set_color(c_black);
draw_text_transformed(x+lerpX+3, y+Y+3 -110, TXT, 1.4, 1.4, 0);
draw_set_color(col);
draw_text_transformed(x+lerpX, y+Y -110, TXT, 1.4, 1.4, 0);
draw_set_halign(fa_left);



draw_set_alpha(1);