if menu {exit}

switch (a) {
	
	case "changeEvType":
		image_xscale = scalex*0.9
		image_yscale = scaley*0.9
		num = 2;draw = false
		// Evento Left Mouse Pressed
		if (oEditor.selected_event != -1) {
		    var _evento_actual = oEditor.events_array[oEditor.selected_event];
		    editor_change_event_type(_evento_actual);
		}
    break;
	
	case "changeCharID":
		image_xscale = scalex*0.9
		image_yscale = scaley*0.9
		
		num = 3;draw = false
		if oEditor.charPlaceID > global.chart_data.playersMax-1 {oEditor.charPlaceID=0}
		else {oEditor.charPlaceID++}
    break;
	
	case "playMusic":
		image_xscale = scalex*0.9
		image_yscale = scaley*0.9
		
		num = 4-oEditor.is_playing;//draw = false
		
		with (oEditor) {
			if active_input == "" {
			    is_playing = !is_playing;
			    if (is_playing) {
			        var _ogg_path = working_directory + global.chart_data.song_name + ".ogg";
			        if (file_exists(_ogg_path)) {
			            if (snd_stream != -1) audio_destroy_stream(snd_stream);
			            snd_stream = audio_create_stream(_ogg_path);
			            audio_instance = audio_play_sound(snd_stream, 1, false);
			            audio_sound_set_track_position(audio_instance, current_time_sec);
			        }
			    } else {
			        if (audio_is_playing(audio_instance)) audio_pause_sound(audio_instance);
			    }
			}
		}
    break;
	
	
	
    default:
        // code here
    break;
}