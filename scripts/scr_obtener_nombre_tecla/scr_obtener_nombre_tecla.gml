/// @function scr_obtener_nombre_tecla(codigo_tecla)
function scr_obtener_nombre_tecla(_key) {
    switch(_key) {
        case vk_up: return "Arriba";
        case vk_down: return "Abajo";
        case vk_left: return "Izquierda";
        case vk_right: return "Derecha";
        case vk_space: return "Espacio";
        case vk_enter: return "Enter";
        case vk_shift: return "Shift";
        case vk_control: return "Control";
        case vk_alt: return "Alt";
        case vk_escape: return "Esc";
        case vk_tab: return "Tab";
        default: 
            // Si es una letra o número estándar, se convierte a texto normal
            return chr(_key);
    }
}