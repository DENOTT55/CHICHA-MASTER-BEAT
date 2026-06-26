// 1. REINICIAR ESTADO VISUAL DE BOTONES TÁCTILES
for (var i = 0; i < array_length(touch_buttons); i++) {
    touch_buttons[i].pressed = false;
}

// 2. LEER INPUTS FÍSICOS (PC)
var input_up = keyboard_check_pressed(global.UP);
var input_down = keyboard_check_pressed(global.DOWN);
var input_left = keyboard_check_pressed(global.LEFT);
var input_right = keyboard_check_pressed(global.RIGHT);
var input_enter = keyboard_check_pressed(global.ENTER);
var input_back = keyboard_check_pressed(global.BACK);

// 3. LEER INPUTS TÁCTILES (Móvil/Mouse)
if (use_touch_controls) {
    for (var t = 0; t < 4; t++) { // Soporta hasta 4 toques simultáneos
        if (device_mouse_check_button(t, mb_left)) {
            var mx = device_mouse_x_to_gui(t);
            var my = device_mouse_y_to_gui(t);

            for (var i = 0; i < array_length(touch_buttons); i++) {
                var btn = touch_buttons[i];
                var half = btn.size / 2;
                
                // Comprobar si el toque está dentro del área del botón
                if (mx > btn.x - half && mx < btn.x + half && 
                    my > btn.y - half && my < btn.y + half) {
                    
                    btn.pressed = true; // Cambia el índice del sprite

                    // Registrar la acción solo en el instante que se presiona
                    if (device_mouse_check_button_pressed(t, mb_left)) {
                        switch(btn.id) {
                            case "UP": input_up = true; break;
                            case "DOWN": input_down = true; break;
                            case "LEFT": input_left = true; break;
                            case "RIGHT": input_right = true; break;
                            case "ENTER": input_enter = true; break;
                            case "BACK": input_back = true; break;
                        }
                    }
                }
            }
        }
    }
}

visual_index = lerp(visual_index, menu_index, 0.10);

// 4. LÓGICA DE NAVEGACIÓN DEL MENÚ
if (input_up) {
    menu_index--;audio_play_sound(snd_menuClick,1,false,0.5)
    if (menu_index < 0) menu_index = menu_count - 1; // Vuelve al fondo
}
if (input_down) {
    menu_index++;audio_play_sound(snd_menuClick,1,false,0.5,0,0.9)
    if (menu_index >= menu_count) menu_index = 0; // Vuelve al inicio
}

if (input_back) {
	do_transition(rmMainMenu)
	audio_play_sound(snd_menuBack,1,false,0.5)
}

if (input_enter) {
	//do_transition(menu_options[menu_index].rm)
	audio_play_sound(snd_menuPlay,1,false,0.5)
}

// 5. MOVIMIENTO SUAVE (LERP) DEL SELECTOR DE LÍNEA PUNTEADA
var start_y = 200; // Posición Y del primer botón
var spacing_y = 110; // Distancia entre botones
target_cursor_y = start_y + (menu_index * spacing_y);

// Inicializar el cursor en su lugar exacto el primer frame para evitar saltos
if (cursor_y == 0) cursor_y = target_cursor_y;

// Suavizado matemático
cursor_y = lerp(cursor_y, target_cursor_y, 0.15);