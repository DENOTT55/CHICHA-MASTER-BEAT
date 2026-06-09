

function check_hit(_col, _time_now, _input_type) {
    var _max_window = 0.20; // Ventana máxima para "Bad"
    
    for (var i = 0; i < array_length(oGameplay.notes_array); i++) {
        var _n = oGameplay.notes_array[i];
        
        if (_n.col == _col) {
            var _diff = abs(_n.time - _time_now);
            
            if (_diff <= _max_window) {
				
				if (_n.type == 2)
				{
					var _player = playerChecker(_n.playerID)
					
					if _player.playerID <= global.chart_data.playersMax
					{_player.toX = hit_x_col[_col]}
					else 
					{_player = playerChecker(0);_player.toX = hit_x_col[_col]}
					
					//_player.toX = hit_x_col[_col]
					
					crear_feedback(_col, _input_type);
                    reproducir_animacion("hit",_player.playerID)
                    array_delete(oGameplay.notes_array, i, 1);
					oUI.hitAngle = choose(5,-5);oUI.hitScale = 0.2
				}
				
                // CORRECCIÓN: Ahora valida que el swipe coincida específicamente con _n.type == 1
                if ((_n.type == 0 && _input_type == "tap") || (_n.type == 1 && _input_type == "swipe")) {
                    
                    // Calcular Calificación
                    var _rating = "PERFECT!";
                    if (_diff > 0.05) _rating = "GREAT";
                    if (_diff > 0.10) _rating = "GOOD";
                    if (_diff > 0.15) _rating = "BAD";
                    
                    actualizar_puntuacion(_rating);
                    oGameplay.noteTypeActual = _n.hold;
					oGameplay.noteTypeActualType = _n.type;
                    
                    if (_n.hold > 0) {
                        _n.is_being_held = true;
                        // --- ACCIÓN: Iniciar el loop de Hold ---
						var _player = playerChecker(_n.playerID)
                        iniciar_loop("hold",_player.playerID); 
						
						if _player.playerID <= global.chart_data.playersMax
						{_player.toX = hit_x_col[_col]}
						else 
						{_player = playerChecker(0);_player.toX = hit_x_col[_col]}
						//_player.toX = hit_x_col[_col]
                    } else {
                        crear_feedback(_col, _input_type);
                        
                        // --- ACCIÓN: Reproducir animación de golpe normal ---
						var _player = playerChecker(_n.playerID)
						
						if _n.type == 0 {
							if _col == 1
							{reproducir_animacion("hitL",_player.playerID);_player.image_xscale = 1}
							else //if _col == 2
							{reproducir_animacion("hitR",_player.playerID);_player.image_xscale = -1}
						}
						if _n.type == 1 {
							if _col == 1
							{reproducir_animacion("swipeL",_player.playerID);_player.image_xscale = 1}
							else //if _col == 2
							{reproducir_animacion("swipeR",_player.playerID);_player.image_xscale = -1}
						}
						
						_player.toX = hit_x_col[_col]
                        
                        array_delete(oGameplay.notes_array, i, 1);
						
						oUI.hitAngle = choose(5,-5);oUI.hitScale = 0.2
                    }
                    return true; // Se encontró y procesó la nota, salimos de la función
                }
            }
        }
    }
    
    return false; // Retorna falso si el jugador tocó pero no había ninguna nota válida
}