var gw = display_get_gui_width();
var gh = display_get_gui_height();
draw_set_font(global.Fonts.f1O);

// --- 1. DIBUJAR BARRA NEGRA DE INFORMACIÓN ---
// Si use_touch_controls es true, la barra sube automáticamente para dar espacio
var touch_area_height = use_touch_controls ? (touch_btn_size/2 + 20) : 0;
var bar_y = gh - touch_area_height - info_bar_height;

draw_set_color(c_black);
draw_set_alpha(0.8);
draw_rectangle(0, bar_y, gw, bar_y + info_bar_height+400, false);
draw_set_alpha(1.0);

// Texto de la barra negra
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(global.Fonts.f1Om);
draw_text(gw / 2, bar_y + (info_bar_height / 2), "Usa flechas para navegar, ENTER para confirmar");
draw_set_font(global.Fonts.f1O);

// --- 2. DIBUJAR BOTONES TÁCTILES (sButtonPush) ---
if (use_touch_controls) {
    for (var i = 0; i < array_length(touch_buttons); i++) {
        var btn = touch_buttons[i];
        var img_index = btn.pressed ? 1 : 0; // 0 = reposo, 1 = presionado

        // Gracias al Nine Slice, el botón "BACK" se deformará sin perder calidad
        draw_sprite_stretched(sButtonPush, img_index, btn.x - btn.size/2, btn.y - btn.size/4, btn.size, btn.size/2);
        
        // Dibujar el icono o el texto según el botón
        draw_set_color(btn.pressed ? c_gray : c_white);
        
		if (btn.id == "DOWN") {
            draw_sprite_ext(sIconsFont, 0, btn.x, btn.y, 1, 1, 0, c_white, image_alpha);
        }
        else if (btn.id == "UP") {
            draw_sprite_ext(sIconsFont, 0, btn.x, btn.y, 1, 1, 180, c_white, image_alpha);
        }
        else {
            draw_text(btn.x, btn.y, btn.id);
        }
    }
}

// --- 3. DIBUJAR LOS BOTONES DEL MENÚ (sButtonMenu) ---
var btn_width = 520;
var btn_height = 90;
var spacing_y = 110;

// CENTRADO DINÁMICO HORIZONTAL Y VERTICAL
var btn_x = (gw / 2) - (btn_width / 2) - 180; 

// ==========================================
// VARIABLE MANUAL PARA AJUSTAR EL CENTRO Y
// ==========================================
// Cambia este valor para subir o bajar toda la lista. 
// Ej: (gh / 2) + 50 bajará todo 50 píxeles.
var menu_center_y = (gh / 2) - 140; 

for (var i = 0; i < menu_count; i++) {
    var option = menu_options[i];
    
    // CÁLCULO DE POSICIÓN Y CON SCROLL SUAVE
    // Calculamos la distancia de esta opción respecto al centro visual
    var dist_y = (i - visual_index) * spacing_y;
    var current_y = menu_center_y + dist_y - (btn_height / 2);
    
    // CORRECCIÓN DEL LERP: Empuje de 0 a 80px
    if (menu_index == i) {
        X[i] = lerp(X[i], 80, 0.2);
    } else {
        X[i] = lerp(X[i], 0, 0.2);
    }
    var _X = X[i];

    // CÁLCULO DE OPACIDAD (ALPHA)
    // Medimos qué tan lejos está la opción del centro.
    // abs() convierte números negativos en positivos para que funcione arriba y abajo igual.
    var dist_alpha = abs(i - visual_index);
    
    // 0.4 es la velocidad de desvanecimiento. 
    // Cámbialo a 0.5 para que desaparezcan más rápido, o 0.2 para que tarden más.
    var _alpha = clamp(1 - (dist_alpha * 0.3), 0, 1); 

    // Si el alpha es mayor a 0, lo dibujamos. Si es 0, nos ahorramos el procesamiento.
    if (_alpha > 0) {
        draw_set_alpha(_alpha); // Aplicamos la opacidad dinámica

        // Dibujar base de color (0=azul, 1=rojo, 2=amarillo)
        

        // Textos del botón
        draw_set_font(global.Fonts.f1O);
        draw_set_color(c_white);
        draw_set_halign(fa_center);
        draw_text(btn_x + btn_width/2 + _X, current_y + btn_height/2 - 12, option.name);
        
        draw_set_font(global.Fonts.f1Om);
        draw_text(btn_x + btn_width/2 + _X, current_y + btn_height/2 + 18.5, option.rol);
        
        draw_set_alpha(1.0); // IMPORTANTE: Resetear siempre el alpha a 1 al final del loop
    }
}

draw_sprite_ext(sCreditsProfile, menu_index, gw - 360, gh / 2 - 40, 0.9, 0.9,0,c_white,1);

// --- 4. DIBUJAR EL SELECTOR LERP (Línea punteada) ---
// El índice 3 es la línea punteada. Se dibuja siguiendo la variable cursor_y
// con un ligero margen exterior (padding) para englobar el botón.
var padding = 12;
var current_offset = X[menu_index]; // Toma el empuje actual para que la línea lo siga

// He quitado las barras "//" por si quieres reactivar la línea adaptada al nuevo centrado
//draw_sprite_stretched(sButtonMenu, 3, btn_x + current_offset - padding, cursor_y - padding, btn_width + (padding * 2), btn_height + (padding * 2));