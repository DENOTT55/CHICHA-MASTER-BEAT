var mx = mouse_x;
var my = mouse_y;

// =====================================================================
// SISTEMA DE BORRADO RELÁMPAGO POR ARRASTRE (CLIC DERECHO CONTINUO)
// =====================================================================
if !show_meta_menu {
    // CAMBIO CLAVE: Cancelamos el scroll por arrastre para que la goma funcione libremente
    is_dragging = false; 
    
    var _drag_col = -1;
    for (var c = 0; c < 3; c++) {
        if (mx >= col_x[c] - (col_width/2) && mx <= col_x[c] + (col_width/2)) {
            _drag_col = c;
            break;
        }
    }

    if (_drag_col != -1) {
        // Calculamos el tiempo usando tu misma fórmula matemática de la grilla
        var _drag_time = current_time_sec + ((hit_y - my) / global.chart_data.note_speed/100);
        
        // Sintonizamos el SNAP exacto de tus filas
        var _beat_dur = 60 / global.chart_data.bpm;
        var _snap_interval = _beat_dur / global.chart_data.snap_div; 
        _drag_time = round(_drag_time / _snap_interval) * _snap_interval;
        
        var _tolerancia = 0.05; 

        if (_drag_col == 0) {
            // Borrar Eventos en la fila actual
            for (var i = array_length(events_array) - 1; i >= 0; i--) {
                if (abs(events_array[i].time - _drag_time) < _tolerancia) {
                    array_delete(events_array, i, 1);
                }
            }
            selected_event = -1; // Limpiamos selección por seguridad
        } else {
            // Borrar Notas en la fila actual
            for (var i = array_length(notes_array) - 1; i >= 0; i--) {
                var _n = notes_array[i];
                if (_n.col == _drag_col && abs(_n.time - _drag_time) < _tolerancia) {
                    array_delete(notes_array, i, 1);
                }
            }
            selected_note = -1; // Limpiamos selección por seguridad
        }
    }
    exit; // Detiene el frame aquí para que no interfiera con el clic izquierdo
}