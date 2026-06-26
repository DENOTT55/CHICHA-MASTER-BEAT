// ==========================================
// DIBUJAR BOTONES TÁCTILES AÑADIDOS (Draw_64.gml)
// ==========================================
var gw = display_get_gui_width(); // 
var gh = display_get_gui_height(); // 
draw_set_font(global.Fonts.f1O); // 

var touch_area_height = use_touch_controls ? (touch_btn_size/2 - 20) : -200;
var bar_y = gh - touch_area_height - info_bar_height;

draw_set_color(c_black);
draw_set_alpha(0.8);
draw_rectangle(0, bar_y, gw, bar_y + info_bar_height+400, false);
draw_set_alpha(1.0);


if (use_touch_controls) { // [cite: 15]
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	
    for (var i = 0; i < array_length(touch_buttons); i++) { // [cite: 15]
        var btn = touch_buttons[i]; // [cite: 15]
        var img_index = btn.pressed ? 1 : 0; // [cite: 16] // 0 = reposo, 1 = presionado

        // Gracias al Nine Slice, el botón "BACK" se deformará sin perder calidad
        draw_sprite_stretched(sButtonPush, img_index, btn.x - btn.size/2, btn.y - btn.size/4, btn.size, btn.size/2); // [cite: 16]
        
        // Texto simple en el centro para identificar el botón
        draw_set_color(btn.pressed ? c_gray : c_white); // [cite: 17]
		
        if btn.id = "DOWN"{
			draw_sprite_ext(sIconsFont,0,btn.x, btn.y,1,1,0,c_white,image_alpha)
		}
		else if btn.id = "UP"{
			draw_sprite_ext(sIconsFont,0,btn.x, btn.y,1,1,180,c_white,image_alpha)
		}
		else if btn.id = "LEFT"{
			draw_sprite_ext(sIconsFont,0,btn.x, btn.y,1,1,270,c_white,image_alpha)
		}
		else if btn.id = "RIGHT"{
			draw_sprite_ext(sIconsFont,0,btn.x, btn.y,1,1,90,c_white,image_alpha)
		}
		else
			{draw_text(btn.x, btn.y, btn.id);}
    }
}