// 1. Calcular en qué Beat exacto de la canción estamos
var _beat_actual_decimal = (oGameplay.current_time_sec * bpm) / 60;
var _beat_actual_entero = floor(_beat_actual_decimal); 

x = lerp(x,toX,SPEEDX)
y = lerp(y,toY,SPEEDY)

// 2. Máquina de Estados del Jugador
switch (state) {
    
    case "IDLE":
        // --- DETECTAR SI LA ANIMACIÓN ACTUAL LLEGÓ A SU FIN ---
        var _anim_terminada = (image_index + image_speed >= image_number);

        if (_beat_actual_entero > last_beat) {
            if (idle_mode == "N") {
                sprite_index = anim_config.idle.spr;
                image_index = 0; 
            } else if (idle_mode == "ALT") {
               // --- CORRECCIÓN AQUÍ: Leer desde anim_config ---
                if (_beat_actual_entero % 2 == 0) {
                    sprite_index = anim_config.idle_l.spr;
                } else {
                    sprite_index = anim_config.idle_r.spr;
                }
                image_index = 0; 
            }
            last_beat = _beat_actual_entero;
        }
        // --- NUEVO: Si no ha cambiado el beat pero la animación ya terminó, congelar ---
        else if (_anim_terminada) {
            image_index = image_number - 1;
        }
        
        image_speed = anim_speed;
        break;

    case "ACTION":
        image_speed = anim_speed;
        
        // Comprobamos si la animación actual ya llegó a su último frame
        if (image_index + image_speed >= image_number) {
            state = "IDLE";
            last_beat = _beat_actual_entero - 1; 
        }
        break;
        
    case "LOOP":
        // Ignora el beat y fluye a su propia velocidad
        image_speed = anim_speed;
        
        // Determinar cuál es el frame final real
        var _end_frame = (current_loop_end == -1) ? (image_number - 1) : current_loop_end;
        
        // Si la animación está a punto de superar el frame de fin de loop...
        // Sumamos 1 para asegurar que el frame final se alcance a mostrar completo antes de reiniciar
        if (image_index + image_speed >= _end_frame + 1) {
            // ...regresamos suavemente al frame de inicio acordado
            image_index = current_loop_start;
        }
        break;
}