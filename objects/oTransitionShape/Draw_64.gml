var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

if (transition_state == "out" || (transition_state == "in" && in_style == "iris")) {
    // --- LÓGICA DEL IRIS (Superficie y Substracción) ---
    if (!surface_exists(surf_transition)) {
        surf_transition = surface_create(_gui_w, _gui_h);
    }
    
    surface_set_target(surf_transition);
    draw_clear_alpha(transition_color, 1.0);
    
    gpu_set_blendmode(bm_subtract);
    var _center_x = _gui_w / 2;
    var _center_y = _gui_h / 2;
    draw_sprite_ext(transition_sprite, 0, _center_x, _center_y, current_scale, current_scale, 0, c_white, 1.0);
    
    gpu_set_blendmode(bm_normal);
    surface_reset_target();
    
    draw_surface(surf_transition, 0, 0);
    
} 
else if (transition_state == "in" && in_style == "fade") {
    // --- LÓGICA DEL FADE (Rectángulo simple) ---
    draw_set_color(transition_color);
    draw_set_alpha(fade_alpha);
    
    draw_rectangle(0, 0, _gui_w, _gui_h, false);
    
    // Restaurar siempre opacidad y color por defecto para no afectar tu juego
    draw_set_alpha(1.0);
    draw_set_color(c_white);
}