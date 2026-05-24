function actualizar_puntuacion(_rating) {
    oGameplay.texto_precision = _rating;
    oGameplay.precision_alpha = 1.5; // Empieza visible
    
    switch(_rating) {
        case "PERFECT!": 
            oGameplay.puntos += 100; oGameplay.combo++; 
            oGameplay.color_precision = c_yellow; break;
        case "GREAT": 
            oGameplay.puntos += 75; oGameplay.combo++; 
            oGameplay.color_precision = c_aqua; break;
        case "GOOD": 
            oGameplay.puntos += 50; oGameplay.combo++; 
            oGameplay.color_precision = c_lime; break;
        case "BAD": 
            oGameplay.puntos += 10; oGameplay.combo = 0; 
            oGameplay.color_precision = c_orange; break;
        case "MISS": 
            oGameplay.combo = 0; 
            oGameplay.color_precision = c_red; break;
    }
    
    if (oGameplay.combo > oGameplay.max_combo) oGameplay.max_combo = oGameplay.combo;
}