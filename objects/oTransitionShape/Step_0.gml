if (transition_state == "out") {
    // Animación de Iris cerrándose
    current_scale = lerp(current_scale, target_scale, transition_speed);
    
    if (abs(current_scale - target_scale) < 0.05) {
		
		if t != 0 {t--}
		if t = 0
		{
	        if (room_exists(target_room)) {global.previus = room;room_goto(target_room);}
        
	        transition_state = "in";
			t = resetT
        
	        // Preparamos el terreno para la siguiente animación
	        if (in_style == "iris") {
	            target_scale = max_scale;
	        } else if (in_style == "fade") {
	            fade_alpha = 1.0; // Empezamos totalmente negros
	        }
		}
    }
} 
else if (transition_state == "in") {
    
    if (in_style == "iris") {
        // Animación de Iris abriéndose
        current_scale = lerp(current_scale, target_scale, transition_speed);
        if (abs(current_scale - target_scale) < 0.05) {
            instance_destroy();
        }
    } 
    else if (in_style == "fade") {
        // Animación de Fade aclarando la pantalla
        fade_alpha = lerp(fade_alpha, 0, transition_speed);
        if (fade_alpha < 0.05) {
            instance_destroy();
        }
    }
}

