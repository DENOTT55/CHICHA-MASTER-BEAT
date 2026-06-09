// ==========================================================
// CONFIGURACIÓN DE RESOLUCIÓN PARA MÓVILES (DRAW GUI)
// ==========================================================

draw_set_alpha(1)

// ==========================================================
// 1. FONDOS MODO SPLIT Y ALERTA (Corregido para Móvil)
// ==========================================================
if (global.alerta_cambio_input) {
    draw_set_halign(fa_center);
    draw_text(_W/2, 50, "CAMBIO APROXIMANDOSE!");
}

// Convertimos el Alpha en una variable de la instancia para que el Lerp funcione
if (!variable_instance_exists(id, "alpha_split")) alpha_split = 0;

var _ALPto = (global.modo_input == "SPLIT") ? 0.1 : 0;
alpha_split = lerp(alpha_split, _ALPto, 0.1);

if (alpha_split > 0.01) {
    draw_set_alpha(alpha_split);

    draw_set_color(c_green);
    draw_rectangle(0, 0, _W/2, _H, false); // Mitad Izquierda

    draw_set_color(c_aqua);
    draw_rectangle(_W/2, 0, _W, _H, false); // Mitad Derecha
    
    draw_set_alpha(1); // RESTAURAR ALPHA: Vital para que el resto de textos no se vuelvan transparentes
}

// ==========================================================
// 2. BARRA DE PROGRESO Y FIN DE CANCIÓN
// ==========================================================
// IMPORTANTE: Sustituye '120' por la duración real de tu canción en segundos.
// (O usa audio_sound_length(tu_audio) en tu Create Event)
if (!variable_instance_exists(id, "total_song_time")) total_song_time = audio_sound_length(audio_instance); 
if (!variable_instance_exists(id, "cancion_terminada")) cancion_terminada = false;

var _progreso = clamp(current_time_sec / total_song_time, 0, 1);
var _ancho_barra = _W * 0.3; // Ocupa el 60% de la pantalla
var _x_barra = (_W - _ancho_barra) / 2;
var _y_barra = 40; // Pegado arriba
var _alto_barra = 20;

// Dibujar Fondo de la barra (Gris)
draw_set_color(c_dkgray);
draw_rectangle(_x_barra, _y_barra, _x_barra + _ancho_barra, _y_barra + _alto_barra, false);

// Dibujar Relleno de la barra (Verde Lima)
draw_set_color(c_lime);
draw_rectangle(_x_barra, _y_barra, _x_barra + (_ancho_barra * _progreso), _y_barra + _alto_barra, false);
draw_set_color(c_white);

// Disparador de Fin de Canción
if (_progreso >= 1 && !cancion_terminada) {
    cancion_terminada = true;
    show_debug_message("¡LA CANCIÓN HA TERMINADO!");
    // Aquí puedes poner tu lógica para cambiar de room, mostrar resultados, etc.
}

// ==========================================================
// 3. UI ORIGINAL (Textos, Botón y Puntuación)
// ==========================================================
draw_set_halign(fa_left);

if global.CHARTING_MODE = true
{
	// Botón Volver
	draw_set_color(c_dkgray);
	draw_rectangle(btn_back[0], btn_back[1], btn_back[2], btn_back[3], false);
	draw_set_color(c_white);
	draw_text(btn_back[0] + 10, btn_back[1] + 15, "< VOLVER");
}

/*
// Textos de Combo
if (combo > 3) {
    draw_set_halign(fa_center);
    draw_text_transformed(_W/2+90, 200, string(combo) + " COMBO", 1.5, 1.5, 0);
    draw_set_halign(fa_left);
}
*/

// Datos de Jugadores
/*
draw_text_transformed(_W/16, 100, string(global.players_data.player1), 1.5, 1.5, 0);
draw_text_transformed(_W/16, 120, string(global.players_data.player2), 1.5, 1.5, 0);
draw_text_transformed(_W/16, 140, string(global.players_data.player3), 1.5, 1.5, 0);
draw_text_transformed(_W/16, 160, string(global.players_data.player4), 1.5, 1.5, 0);
draw_text_transformed(_W/16, 180, string(global.players_data.player5), 1.5, 1.5, 0);
draw_text_transformed(_W/16, 200, string(global.players_data.player6), 1.5, 1.5, 0);
*/

// Puntuación lateral
if (object_exists(oPlayer)) {
    draw_set_halign(fa_center);draw_set_valign(fa_middle);
    
    // Cambiamos view_get_hport por _W para anclarlo perfecto a la derecha de la pantalla
    draw_text(_W / 2, 20, "SCORE: " + string(puntos)+" | "+"MAX COMBO: " + string(max_combo)+" | "+"MISSES: " + string(MISSES));
}

// Resetear variables de dibujo por buenas prácticas
draw_set_halign(fa_left);
draw_set_font(-1);