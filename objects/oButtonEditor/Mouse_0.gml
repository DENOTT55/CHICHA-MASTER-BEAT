if menu {exit}

switch (a) {
    case "scrollUp":
		image_xscale = scalex*0.9
		image_yscale = scaley*0.9
	
		oEditor.current_time_sec -= 0.1;
		oEditor.current_time_sec = max(0, oEditor.current_time_sec);
    break;
	
	case "scrollDown":
		image_xscale = scalex*0.9
		image_yscale = scaley*0.9
	
		oEditor.current_time_sec += 0.1;
		oEditor.current_time_sec = max(0, oEditor.current_time_sec);
    break;
	
	case "deselect":
		image_xscale = scalex*0.9
		image_yscale = scaley*0.9
		num = 1
		oEditor.selected_note = -1
		oEditor.selected_event = -1
    break;
	
	case "deleteNote":
		image_xscale = scalex*0.9
		image_yscale = scaley*0.9
		
		num = 0
		
		with (oEditor) {
		    if (selected_note != -1) {
			        array_delete(notes_array, selected_note, 1);
			        selected_note = -1;
			}

			if (selected_event != -1) {
			        array_delete(events_array, selected_event, 1);
			        selected_event = -1;
			}
		}
    break;
	
    default:
        // code here
    break;
}