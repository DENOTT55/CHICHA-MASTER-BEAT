function INT_VARS(){
	global.P1ID = 0
	global.P2ID = 0
	global.P3ID = 0
	global.P4ID = 0
	global.P5ID = 0
	global.P6ID = 0
	
	global.CHARTING_MODE = false
	
	global.DEBUG1 = vk_f7
	
	global.BACK = vk_escape
	global.PAUSE = vk_escape
	global.PAUSE2 = vk_enter
	global.Lrow = ord("S")
	global.Rrow = ord("D")
	global.SLrow = ord("S")
	global.SRrow = ord("D")
	
	global.TAUNT = vk_space
	
	global.DOWN = vk_down
	global.UP = vk_up
	global.LEFT = vk_left
	global.RIGHT = vk_right
	
	global.ENTER = vk_enter
	
	global.current_chart = "test"
	
	global.MENUBPM = 120
	
	global.players_data = {
    player1: "chichero",
	player2: "",player3: "",player4: "",player5: "",player6: "",
	};
	
	// Datos del Nivel
	global.chart_data = {
	    song_name: global.current_chart,
	    bpm: 120,
	    skin_name: "vaso",
	    note_speed: 2,
	    snap_div: 2,
		playersMax: 1,
	};
	
	global.song_to_load = global.chart_data.song_name
	global.transitionShape = sChicheroIcon
	
	global.goTo = rmGame
	global.previus = rmFreeplay
	
	device_mouse_dbclick_enable(false);
	
	global.Fonts = {
		f1 : font_add_sprite_ext(sFont1,"ABCDEFGHIJKMNLOPQRSTUVWXYZabcdefghijkmnlopqrstuvwxyz:.,;!?@#$%/()|&0123456789+-",true,0),
		f1m : font_add_sprite_ext(sFont1Mini,"ABCDEFGHIJKMNLOPQRSTUVWXYZabcdefghijkmnlopqrstuvwxyz:.,;!?@#$%/()|&0123456789+-",true,0),
		f1O : font_add_sprite_ext(sFont1Outline,"ABCDEFGHIJKMNLOPQRSTUVWXYZabcdefghijkmnlopqrstuvwxyz:.,;!?@#$%/()|&0123456789+-",true,0),
		f1Om : font_add_sprite_ext(sFont1OutlineMini,"ABCDEFGHIJKMNLOPQRSTUVWXYZabcdefghijkmnlopqrstuvwxyz:.,;!?@#$%/()|&0123456789+-",true,0),
	}
}