/// @desc Ordena los eventos cronológicamente
	function scr_sort_events() {
	    if (variable_instance_exists(id, "events_array") && array_length(events_array) > 1) {
	        array_sort(events_array, function(_elm1, _elm2) {
	            return _elm1.time - _elm2.time;
	        });
	        show_debug_message("Eventos ordenados correctamente.");
	    }
	}