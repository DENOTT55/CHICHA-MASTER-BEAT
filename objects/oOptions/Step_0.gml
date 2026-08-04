// Entradas
var _up = keyboard_check_pressed(global.UP);
var _down = keyboard_check_pressed(global.DOWN);
var _left = keyboard_check_pressed(global.LEFT); // [cite: 41]
var _right = keyboard_check_pressed(global.RIGHT); // [cite: 41]
var _enter = keyboard_check_pressed(global.ENTER); // [cite: 41]
var _back = keyboard_check_pressed(vk_escape) || keyboard_check_pressed(vk_backspace);

// ==========================================
// INTEGRACIÓN DE INPUTS TÁCTILES AÑADIDA (Step_0.gml)
// ==========================================
for (var i = 0; i < array_length(touch_buttons); i++) { // [cite: 27]
    touch_buttons[i].pressed = false; // [cite: 27]
} // [cite: 28]

if (use_touch_controls) { // [cite: 30]
    for (var t = 0; t < 4; t++) { // [cite: 30]
        if (device_mouse_check_button(t, mb_left)) { // [cite: 30]
            var mx = device_mouse_x_to_gui(t); // [cite: 30]
            var my = device_mouse_y_to_gui(t); // [cite: 31]

            for (var i = 0; i < array_length(touch_buttons); i++) { // [cite: 31]
                var btn = touch_buttons[i]; // [cite: 31]
                var half = btn.size / 2; // [cite: 32]
                
                if (mx > btn.x - half && mx < btn.x + half && my > btn.y - half && my < btn.y + half) { // [cite: 32]
                    btn.pressed = true; // [cite: 33]

                    if (device_mouse_check_button_pressed(t, mb_left)) { // [cite: 34]
                        switch(btn.id) { // [cite: 34]
                            case "UP": _up = true; break; // [cite: 35]
                            case "DOWN": _down = true; break; // [cite: 36]
                            case "LEFT": _left = true; break; // [cite: 36]
                            case "RIGHT": _right = true; break; // [cite: 36]
                            case "ENTER": _enter = true; break; // [cite: 37]
                            case "BACK": _back = true; break; // [cite: 37]
                        } // [cite: 38]
                    }
                }
            }
        }
    }
}
// ==========================================

var _current_cat = options_list[sel_cat]; // [cite: 41]
var _items_count = array_length(_current_cat.items); // [cite: 41]

// ==========================================
// ESTADO 0: NAVEGANDO CATEGORÍAS
// ==========================================
if (menu_state == 0) {
    if (_down) {sel_cat++;audio_play_sound(snd_menuClick,1,false,0.5,0,0.9) } // [cite: 42]
    if (_up) {sel_cat--;audio_play_sound(snd_menuClick,1,false,0.5) } // [cite: 42]
    
    sel_cat = clamp(sel_cat, 0, array_length(options_list) - 1); // [cite: 43]
    
    if (_enter || _right) { //
        menu_state = 1; //
        sel_opt = 0; //
    }
    
    // NUEVO: Guardar y Salir del Menú
    if (keyboard_check_pressed(vk_escape) || _left || keyboard_check_pressed(vk_backspace) || _back) {
        scr_save_settings(options_list); 
        do_transition(global.previus)
        audio_play_sound(snd_menuBack,1,false,0.5)
    }
    
    // NUEVO: Guardar y Salir del Menú (Duplicado que dejaste)
    if (keyboard_check_pressed(vk_escape) || _left || _back) {
        scr_save_settings(options_list); 
        do_transition(global.previus)
        audio_play_sound(snd_menuBack,1,false,0.5)
    }
} 
// ==========================================
// ESTADO 1: NAVEGANDO OPCIONES
// ==========================================
else if (menu_state == 1) {
    
    if (_down) { sel_opt++; if (sel_opt >= _items_count) sel_opt = 0;audio_play_sound(snd_menuClick,1,false,0.5,0,0.9) } //
    if (_up) { sel_opt--; if (sel_opt < 0) sel_opt = _items_count - 1;audio_play_sound(snd_menuClick,1,false) } //
    
    var _current_cat = options_list[sel_cat]; //
    var _item = _current_cat.items[sel_opt]; //
    
    if (_left && !_enter) { //
        menu_state = 0; //
    }
    
    if (_back){
    menu_state = 0}
    
    // 4. Interacción con la opción seleccionada
    if (_enter || _right) {
        if (_item.type == "check" && _enter) { //
            _item.val = !_item.val; //
            if (!_item.val) _item.frame = 0; //
            
            // NUEVO: Ejecución Instantánea de Antialiasing
            if (_item.key == "disable_aa") {
                scr_apply_aa(_item.val);
            }
			
			if (_item.key == "splitScreen") {
                global.SHOWSPLIT = _item.val
            }
        } 
        else if (_item.type == "list") { //
            _item.val++; //
            if (_item.val >= array_length(_item.options)) _item.val = 0; //
            
            // NUEVO: Ejecución Instantánea de Resolución
            if (_item.key == "resolution") {
                scr_apply_resolution(_item.val);
            }
        }
        else if (_item.type == "action" && _enter) { //
            if (_item.key == "rebind_keys") { //
                menu_state = 2; //
                sel_ctrl = 0; //
            }
            show_debug_message("Ejecutando acción: " + _item.name); //
        }
    }
}
// ==========================================
// ESTADO 2: NAVEGANDO MENÚ DE CONTROLES (Step Event)
// ==========================================
else if (menu_state == 2) {
    var _ctrl_count = array_length(controls_list);
    
    if (_down) { sel_ctrl++; if (sel_ctrl >= _ctrl_count) sel_ctrl = 0;audio_play_sound(snd_menuClick,1,false,0.5,0,0.9) }
    if (_up) { sel_ctrl--; if (sel_ctrl < 0) sel_ctrl = _ctrl_count - 1;audio_play_sound(snd_menuClick,1,false) }
    
    // Si presionas Escape, Izquierda, o seleccionas Volver, sales a categorías o al menú anterior
    if (keyboard_check_pressed(vk_escape) || _left || _back) {
        menu_state = 0; // Vuelve directo a la selección de categorías
    }
    else if (_enter) {
        var _c_item = controls_list[sel_ctrl];
        
        if (_c_item.key_ref == "back") {
            menu_state = 0; // Cambiado a 0 para volver a categorías en vez de a opciones (estado 1)
        } else {
            // Activar el Estado 3 e iniciar la cuenta regresiva (3 segundos)
            menu_state = 3;
            rebind_timer = room_speed * 3; 
            keyboard_lastkey = -1;
        }
    }
}
// ==========================================
// ESTADO 3: CUENTA REGRESIVA Y ASIGNACIÓN
// ==========================================
else if (menu_state == 3) {
    rebind_timer--;
    
    // Si se presiona cualquier tecla mientras corre el tiempo
    if (keyboard_check_pressed(vk_anykey)) {
        var _new_key = keyboard_lastkey;
        var _ref = controls_list[sel_ctrl].key_ref;
        
        // Sobreescribimos el valor de la variable global con la nueva tecla
        variable_global_set(_ref, _new_key);
        
        menu_state = 2; // Devolver el control al submenú
    } 
    // Si se acaba el tiempo sin presionar nada
    else if (rebind_timer <= 0) {
        menu_state = 2; // Volver al submenú sin hacer cambios
    }
}

// ==========================================
// CÁLCULO DE SCROLL SUAVE (Step Event)
// ==========================================
if (menu_state == 1) {
    // 50 es la altura de cada opción (item_height)
    target_scroll = max(0, (sel_opt - 3) * 50); 
} 
else if (menu_state >= 2) {
    // Scroll para el submenú de controles (también 50 de separación)
    target_scroll = max(0, (sel_ctrl - 3) * 50); 
} 
else {
    target_scroll = 0;
}

// Lerp para movimiento fluido
scroll_y = lerp(scroll_y, target_scroll, 0.15);