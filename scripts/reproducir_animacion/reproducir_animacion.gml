function playerChecker(playerID = 0) {
	var _player = "noone"
	
	switch (playerID) {
	    case 0:
	        _player = global.P1ID
	    break;
		case 1:
			if global.P2ID != 0 {_player = global.P2ID}
			else {_player = global.P1ID}
	    break;
		case 2:
			if global.P3ID != 0 {_player = global.P3ID}
			else {_player = global.P1ID}
	    break;
		case 3:
			if global.P4ID != 0 {_player = global.P4ID}
			else {_player = global.P1ID}
	    break;
		case 4:
			if global.P5ID != 0 {_player = global.P5ID}
			else {_player = global.P1ID}
	    break;
		case 5:
			if global.P6ID != 0 {_player = global.P6ID}
			else {_player = global.P1ID}
	    break;
	    default:
	        _player = global.P1ID
	    break;
	}
	
	return _player
}


/// @desc Reproduce una animación 1 sola vez (Taps)
/// @param {String/Asset} _anim Clave del diccionario o Sprite directo
function reproducir_animacion(_anim, playerID = 0) {
    var _player = playerChecker(playerID);
    
    with (_player) {
        // CHIVATO: Te dirá quién está ejecutando esto y qué animación intenta cargar
        show_debug_message("Aviso: Ejecutando en " + object_get_name(object_index) + " | Animación: " + string(_anim));
        
        state = "ACTION";
        
        if (is_string(_anim) && variable_struct_exists(anim_config, _anim)) {
            sprite_index = anim_config[$ _anim].spr;
        } else {
            show_debug_message("¡PELIGRO! anim_config no existe o falló en " + object_get_name(object_index));
            sprite_index = _anim;
        }
        
        image_index = 0;
    }
}

/// @desc Inicia una animación que se repite en bucle (Holds)
/// @param {String/Asset} _anim Clave del diccionario o Sprite directo
function iniciar_loop(_anim,playerID = 0) {
	
	var _player = playerChecker(playerID)
	
    with (_player) { // <--- CORREGIDO: Cambiado de oChichero a oPlayer
        state = "LOOP";
        
        if (is_string(_anim) && variable_struct_exists(anim_config, _anim)) {
            var _data = anim_config[$ _anim];
            sprite_index = _data.spr;
            current_loop_start = _data.loop_start;
            current_loop_end = _data.loop_end;
        } else {
            sprite_index = _anim;
            current_loop_start = 0;
            current_loop_end = -1;
        }
        
        image_index = 0; 
    }
}

/// @desc Rompe el estado de loop y devuelve al personaje al IDLE
function detener_loop(playerID = 0) {
	
	var _player = playerChecker(playerID)
	
    with (_player) { // <--- CORREGIDO: Cambiado de oChichero a oPlayer
        if (state == "LOOP") {
            state = "IDLE";
            
            var _beat = floor((oGameplay.current_time_sec * bpm) / 60);
            last_beat = _beat - 1; 
        }
    }
}