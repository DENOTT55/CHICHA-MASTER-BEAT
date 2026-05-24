touch_y_start = mouse_y;
time_start_scroll = current_time_sec;
is_dragging = false;

// Comprobar si tocamos un elemento de la UI (Para no iniciar scroll)
var mx = mouse_x;
var my = mouse_y;
click_valid = true;

if (show_meta_menu) {
    click_valid = false; // Si el menú está abierto, el fondo no hace nada
} else {
    if (mx > btn_meta[0] && mx < btn_meta[2] && my > btn_meta[1] && my < btn_meta[3]) click_valid = false;
    if (mx > btn_play[0] && mx < btn_play[2] && my > btn_play[1] && my < btn_play[3]) click_valid = false;
    
    // Anula el click en el editor de notas/eventos si está abierto (evita scrollear si deslizas en la UI lateral)
    if (selected_note != -1 || selected_event != -1) {
        if (mx > room_width - 320) click_valid = false;
    }
}