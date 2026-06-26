// Coordenadas base
var _cat_x = 100;
var _opt_x = 450;
var _base_y = 150;

draw_set_halign(fa_left);

draw_set_font(global.Fonts.f1Om); // Asigna tu fuente aquí
if (menu_state < 2) {
// ==========================================
// 1. DIBUJAR CATEGORÍAS (Lado Izquierdo)
// ==========================================
for (var c = 0; c < array_length(options_list); c++) {
    var _cat = options_list[c];
    var _yy = _base_y + (c * 60);
    
    // Si estamos en Estado 0 y es la categoría seleccionada: Alpha 1. Si no: 0.7
    var _cat_alpha = (menu_state == 0 && sel_cat == c) ? 1.0 : 0.7;
    // Si entramos a Estado 1, mantenemos encendida la categoría actual para saber dónde estamos
    if (menu_state == 1 && sel_cat == c) _cat_alpha = 1.0; 
    
    draw_set_alpha(_cat_alpha);
    draw_set_color(c_white);
    draw_text(_cat_x, _yy, _cat.category);
}

// ==========================================
// 2. DIBUJAR OPCIONES (Lado Derecho con Scroll)
// ==========================================
var _items = options_list[sel_cat].items;

for (var i = 0; i < array_length(_items); i++) {
    var _item = _items[i];
    
    // Posición Y dinámica restando la variable global de scroll_y
    var _yy = _base_y + (i * item_height) - scroll_y;
    
    // Lógica de Transparencia estricta: Solo alpha 1 si estás sobre la opción en el estado 1
    var _is_selected = (menu_state == 1 && sel_opt == i);
    draw_set_alpha(_is_selected ? 1.0 : 0.7);
    draw_set_color(_is_selected ? c_yellow : c_white);
    
    // Dibujar nombre de la opción
    draw_text(_opt_x, _yy, _item.name);
    
    // ==========================================
    // DIBUJO DE VALORES SEGÚN EL TIPO
    // ==========================================
    var _val_x = _opt_x + 450; // Distancia hacia la derecha donde se dibujan los valores
    
    if (_item.type == "list") {
        // Formato con flechas direccionales
        var _txt = "< " + _item.options[_item.val] + " >";
        draw_text(_val_x, _yy, _txt);
        
    } 
    else if (_item.type == "check") {
        // ANIMACIÓN DE CHECKBOX
        if (_item.val) {
            var _total_frames = sprite_get_number(sCheckbox);
            // Si la animación no ha llegado al último frame, suma velocidad
            if (_item.frame < _total_frames - 1) {
                // Avanza según la velocidad nativa del sprite
                _item.frame += (sprite_get_speed(sCheckbox) / room_speed); 
            }
        } else {
            _item.frame = 0; // Vuelve al frame inicial al desactivarse
        }
        
        draw_sprite(sCheckbox, floor(_item.frame), _val_x+65, _yy + 10);
        
    } 
    else if (_item.type == "action") {
        // Feedback visual para botones de acción
        draw_text(_val_x, _yy, "[ PRESIONAR ]");
    }
}

} 
else {
    // ==========================================
    // 3. DIBUJAR SUBMENÚ DE CONTROLES (ESTADOS 2 Y 3)
    // ==========================================
    draw_set_alpha(1.0);
    draw_set_color(c_white);
    
    // Centramos el título
    var _screen_center = room_width / 2;
    draw_set_halign(fa_center);
    draw_text(_screen_center, 80, "CONFIGURACIÓN DE TECLAS");
    draw_line(_screen_center - 200, 110, _screen_center + 200, 110);
    
    draw_set_halign(fa_left); // Alineación para el contenido
    var _base_y_ctrl = 140;
    
    for (var i = 0; i < array_length(controls_list); i++) {
        var _c_item = controls_list[i];
        
        // Aplicamos scroll vertical para que no se salgan de la pantalla
        var _yy = _base_y_ctrl + (i * 50) - scroll_y; 
        
        var _is_selected = (sel_ctrl == i);
        draw_set_color(_is_selected ? c_yellow : c_white);
        draw_set_alpha(_is_selected ? 1.0 : 0.5);
        
        // Centramos las columnas calculando desde el centro de la pantalla
        draw_text(_screen_center - 200, _yy, _c_item.name);
        
        // Si no es el botón "Volver", dibujamos la tecla o el conteo
        if (_c_item.key_ref != "back") {
            // Si estamos en cuenta regresiva
            if (menu_state == 3 && _is_selected) {
                var _segundos_restantes = ceil(rebind_timer / room_speed);
                draw_set_color(c_red);
                draw_text(_screen_center + 50, _yy, "PRESIONA... " + string(_segundos_restantes) + "s");
            } 
            else {
                var _key_val = variable_global_get(_c_item.key_ref);
                var _key_name = scr_obtener_nombre_tecla(_key_val);
                draw_text(_screen_center + 50, _yy, "[ " + _key_name + " ]");
            }
        }
    }
    draw_set_halign(fa_center); // Reset de alineación
}

// Reset de seguridad
draw_set_alpha(1.0);