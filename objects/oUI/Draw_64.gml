with (oGameplay) {

// ==========================================================
// CONFIGURACIÓN DE RESOLUCIÓN PARA MÓVILES (DRAW GUI)
// ==========================================================

draw_set_alpha(1)

// ==========================================================
// 1. FONDOS MODO SPLIT Y ALERTA (Corregido para Móvil)
// ==========================================================
if (global.alerta_cambio_input) {
    //draw_set_halign(fa_center);
    //draw_text(_W/2, 50, "CAMBIO APROXIMANDOSE!");
}

if global.SHOWSPLIT == true
{
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
}

// ==========================================================
// 2. BARRA DE PROGRESO, TIMER Y FIN DE CANCIÓN
// ==========================================================
if (!variable_instance_exists(id, "total_song_time")) total_song_time = audio_sound_length(audio_instance); 
if (!variable_instance_exists(id, "cancion_terminada")) cancion_terminada = false;

var _progreso = clamp(current_time_sec / total_song_time, 0, 1);
var _ancho_barra = _W * 0.3; // Ocupa el 60% de la pantalla (o 30% dependiendo de tu base)
var _x_barra = (_W - _ancho_barra) / 2;
var _y_barra = 40; // Pegado arriba
var _alto_barra = 20;

// --- DIBUJO DE LA BARRA DE PROGRESO ---

// Dibujar borde de la barra (Negro)
draw_set_color(c_black);
draw_rectangle(_x_barra-5, _y_barra-5, _x_barra + _ancho_barra+5, _y_barra + _alto_barra+5, false);

// Dibujar Fondo de la barra (Gris)
draw_set_color(c_dkgray);
draw_rectangle(_x_barra, _y_barra, _x_barra + _ancho_barra, _y_barra + _alto_barra, false);

// Dibujar Relleno de la barra (Verde Lima)
draw_set_color(c_lime);
draw_rectangle(_x_barra, _y_barra, _x_barra + (_ancho_barra * _progreso), _y_barra + _alto_barra, false);
draw_set_color(c_white);

// --- NUEVO: CÁLCULO Y DIBUJO DEL TIMER ---
// Aseguramos que el tiempo no baje de 0
var _tiempo_restante = max(0, total_song_time - current_time_sec); 

var _minutos = floor(_tiempo_restante / 60);
var _segundos = floor(_tiempo_restante mod 60);

// Añadir un cero a la izquierda si los segundos son de un solo dígito
var _texto_segundos = (_segundos < 10) ? "0" + string(_segundos) : string(_segundos);
var _texto_timer = string(_minutos) + ":" + _texto_segundos;

// Dibujar el Timer justo encima de la barra
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);
draw_set_color(c_black);
draw_text((_W / 2)+3, _y_barra + 20+3, _texto_timer);
draw_set_color(c_white);
draw_text(_W / 2, _y_barra + 20, _texto_timer);
// Restaurar alineación vertical
draw_set_valign(fa_top); 
draw_set_halign(fa_left);

// --- DISPARADOR DE FIN DE CANCIÓN ---
if (_progreso >= 1 && !cancion_terminada) {
    cancion_terminada = true;
    show_debug_message("¡LA CANCIÓN HA TERMINADO!");
    // Aquí puedes poner tu lógica para cambiar de room, mostrar resultados, etc.
}

// ==========================================================
// 3. UI ORIGINAL (Textos, Botón y Puntuación)
// ==========================================================
draw_set_halign(fa_left);



// Textos de Combo
if (combo > 3) {
    draw_set_halign(fa_center);
	draw_set_colour(c_black)
    draw_text_transformed(_W / 2+3, 90+3, string(combo) + " COMBO", 1.2+other.hitScale, 1.2+other.hitScale, other.hitAngle);
	draw_set_colour(c_white)
	draw_text_transformed(_W / 2, 90, string(combo) + " COMBO", 1.2+other.hitScale, 1.2+other.hitScale, other.hitAngle);
    draw_set_halign(fa_left);
}

other.hitAngle = lerp(other.hitAngle,0,0.3)
other.hitScale = lerp(other.hitScale,0,0.3)

// Datos de Jugadores
/*
draw_text_transformed(_W/16, 100, string(global.players_data.player1), 1.5, 1.5, 0);
draw_text_transformed(_W/16, 120, string(global.players_data.player2), 1.5, 1.5, 0);
draw_text_transformed(_W/16, 140, string(global.players_data.player3), 1.5, 1.5, 0);
draw_text_transformed(_W/16, 160, string(global.players_data.player4), 1.5, 1.5, 0);
draw_text_transformed(_W/16, 180, string(global.players_data.player5), 1.5, 1.5, 0);
draw_text_transformed(_W/16, 200, string(global.players_data.player6), 1.5, 1.5, 0);
*/

// Puntuación
if (object_exists(oPlayer)) {
    draw_set_halign(fa_center);draw_set_valign(fa_middle);
    
    // Cambiamos view_get_hport por _W para anclarlo perfecto a la derecha de la pantalla
	draw_set_colour(c_black)
    draw_text(_W / 2+3, 20+3, "SCORE: " + string(puntos)+" | "+"MAX COMBO: " + string(max_combo)+" | "+"MISSES: " + string(MISSES));
	draw_set_colour(c_white)
    draw_text(_W / 2, 20, "SCORE: " + string(puntos)+" | "+"MAX COMBO: " + string(max_combo)+" | "+"MISSES: " + string(MISSES));
}

// Resetear variables de dibujo por buenas prácticas
draw_set_halign(fa_left);
draw_set_font(global.Fonts.f1O)

if (!is_playing && !is_countdown)
{
    // --- 1. DIBUJO DEL MENÚ ---
    draw_set_color(c_black);
    draw_set_alpha(0.8);
    draw_rectangle(0, 0, _W, _H, false);

    // Ajustes visuales fáciles de modificar
    var _separacion = 70;         // Separación vertical entre las opciones (antes 40)
    var _escala_texto = 1.5;      // Tamaño del texto (1.5 = 50% más grande)
    var _movimiento_derecha = 30; // Píxeles que avanza la opción seleccionada

    for (var i = 0; i < array_length(other.menuRow); ++i) {
        var _target_x = 0; // Posición destino por defecto

        if (i == other.Mn) { 
            draw_set_colour(c_yellow); 
            _target_x = _movimiento_derecha; // Si está seleccionado, el destino es más a la derecha
        } else { 
            draw_set_colour(c_white); 
            _target_x = 0; // Si no, el destino es su posición original
        }
        
        // Aplicamos la magia del LERP para el movimiento suave (0.15 es la velocidad)
        other.menu_offsets[i] = lerp(other.menu_offsets[i], _target_x, 0.15);
        
        // Calculamos las coordenadas finales
        var _pos_x = 120 + other.menu_offsets[i];
        var _pos_y = _H/2 - _separacion + (_separacion * i);
        
        // Dibujamos el texto escalado
        draw_text_transformed(_pos_x, _pos_y, string(other.menuRow[i]), _escala_texto, _escala_texto, 0);
    }
    
    draw_set_alpha(1);

    // --- 2. LÓGICA DE TECLADO (Mantenida como respaldo) ---
    if keyboard_check_pressed(global.DOWN) {
        if other.Mn < array_length(other.menuRow) - 1 { other.Mn++; } else { other.Mn = 0; }
		audio_play_sound(snd_menuClick,1,false,0.5)
    }

    if keyboard_check_pressed(global.UP) {
        if other.Mn > 0 { other.Mn--; } else { other.Mn = array_length(other.menuRow) - 1; }
		audio_play_sound(snd_menuClick,1,false,0.5,0,0.9)
    }

    // --- 3. NUEVA LÓGICA TÁCTIL ---
    var _swipe_threshold = 10;
    var _is_tap = false;
    var _total_items = array_length(other.menuRow);

    // AL TOCAR LA PANTALLA
    if (device_mouse_check_button_pressed(0, mb_left)) {
        other.touch_start_y = device_mouse_y(0);
        other.initial_Mn = other.Mn; // Congelamos la selección actual del menú
        other.is_swiping = false;
    }

    // MIENTRAS MANTIENES EL DEDO (Scroll en tiempo real)
    if (device_mouse_check_button(0, mb_left)) {
        var _current_y = device_mouse_y(0);
        var _diff_y = _current_y - other.touch_start_y;

        if (abs(_diff_y) > _swipe_threshold) {
            other.is_swiping = true;
            
            // Recomiendo alinear esto con tu variable _separacion para mayor coherencia visual
            var _pixeles_por_opcion = 140; 
            
            var _saltos = round(-_diff_y / _pixeles_por_opcion);
            var _new_selected = other.initial_Mn - _saltos;
            
            // Ajuste circular para navegar infinitamente arriba/abajo
            other.Mn = ((_new_selected % _total_items) + _total_items) % _total_items;
        }
    }

    // AL SOLTAR EL DEDO (Tap para confirmar)
    if (device_mouse_check_button_released(0, mb_left)) {
        if (!other.is_swiping) {
            // Obtenemos la posición X del dedo en la pantalla
            var _tap_x = device_mouse_x(0);
            
            // Si el toque ocurrió en la mitad izquierda de la pantalla
            if (_tap_x < _W / 2) {
                _is_tap = true;
                
                // ACCIÓN AL SELECCIONAR LA OPCIÓN (other.Mn)
            }
        }
    }
}

// Dibujar botón de pausa en la esquina superior izquierda
// Los valores 20, 20 son los mismos márgenes que pusimos en el Step
var _frame = is_playing

if is_playing {_frame = 0} else {_frame = 1}

draw_sprite_ext(sPauseButton, _frame, 20, 20,0.5,0.5,0,c_white,1);

if (is_countdown and countdown_index<4) {
    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();
    var _cx = _gui_w / 2;
    var _cy = _gui_h / 2;
	// Asumiendo que tu variable 'tiempo' sube de 0 a 1
	var _efecto = ease_in_sine(0.3);
	
	if countdown_index == 3 and countdown_alpha > 0 {
		countdown_falling+=1;countdown_alpha = lerp(countdown_alpha,0,_efecto)
	}

    // Dibujar el sprite de la cuenta atrás
    // countdown_index es el frame del sprite (0, 1, 2, 3...)
    draw_sprite_ext(
        countdown_sprite, 
        countdown_index, 
        _cx, 
        _cy+countdown_falling, 
        countdown_scale, 
        countdown_scale, 
        0, 
        c_white, 
        countdown_alpha
    );
}

if os_type == os_android and (!is_playing && !is_countdown)
{
	// Botón Volver
	draw_set_color(c_dkgray);
	draw_rectangle(btn_back[0], btn_back[1], btn_back[2], btn_back[3], false);
	draw_set_color(c_white);
	draw_text(btn_back[0] + 10, btn_back[1] + 15, "Dev");
}

}