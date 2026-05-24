function skinFunction(_name = playerName){
	switch (_name) {
	    case "chichero":
	        anim_config = {
				icon:    { spr: sChicheroIcon},
			    idle:    { spr: schicheroidle, loop_start: 0, loop_end: -1 },
			    idle_l:  { spr: schicheroleft, loop_start: 0, loop_end: -1 },
			    idle_r:  { spr: schicheroright, loop_start: 0, loop_end: -1 },
    
			    // Ejemplo de un Tap normal (no usa loop, solo se reproduce 1 vez en ACTION)
			    hit:   { spr: schicherohit, loop_start: 0, loop_end: -1 },
				miss:   { spr: schicheromiss, loop_start: 0, loop_end: 1 },
				hold:   { spr: schicherohold, loop_start: 7, loop_end: -1 },
				misshold:   { spr: schicheromisshold, loop_start: 0, loop_end: 1 },
				nice:   { spr: schicheronice, loop_start: 0, loop_end: -1 },
				happy:   { spr: schicherohappy, loop_start: 0, loop_end: -1 },
				getout:   { spr: schicherogetout, loop_start: 0, loop_end: -1 },
    
			    // Ejemplo de un Hold (se reproduce desde el frame 0, y cuando llega al 5, vuelve al 2 infinitamente)
			    //hold_left:  { spr: sChicheroIdle, loop_start: 2, loop_end: 5 }   // Cambiar por sChichero_HoldLeft
			};
	    break;
	    default:
	        anim_config = {
				icon:    { spr: sMissingIcon},
			    idle:    { spr: smissingleft, loop_start: 0, loop_end: -1 },
			    idle_l:  { spr: smissingleft, loop_start: 0, loop_end: -1 },
			    idle_r:  { spr: smissingleft, loop_start: 0, loop_end: -1 },
    
			    // Ejemplo de un Tap normal (no usa loop, solo se reproduce 1 vez en ACTION)
			    hit:   { spr: schicherohit, loop_start: 0, loop_end: -1 },
				miss:   { spr: schicheromiss, loop_start: 0, loop_end: 1 },
				hold:   { spr: schicherohold, loop_start: 7, loop_end: -1 },
				misshold:   { spr: schicheromisshold, loop_start: 0, loop_end: 1 },
				nice:   { spr: schicheronice, loop_start: 0, loop_end: -1 },
				happy:   { spr: schicherohappy, loop_start: 0, loop_end: -1 },
				getout:   { spr: schicherogetout, loop_start: 0, loop_end: -1 },
    
			    // Ejemplo de un Hold (se reproduce desde el frame 0, y cuando llega al 5, vuelve al 2 infinitamente)
			    //hold_left:  { spr: sChicheroIdle, loop_start: 2, loop_end: 5 }   // Cambiar por sChichero_HoldLeft
			};
	    break;
	}
	
	return anim_config
}