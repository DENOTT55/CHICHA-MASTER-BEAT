if (click_valid && !is_playing) {
    var _dist = abs(mouse_y - touch_y_start);
    
    if (_dist > drag_threshold) {
        is_dragging = true;
    }
    
    if (is_dragging) {
        // Scroll hacia arriba aumenta el tiempo, hacia abajo lo disminuye
        current_time_sec = time_start_scroll - ((touch_y_start - mouse_y) / global.chart_data.note_speed/100);
        current_time_sec = max(0, current_time_sec);
    }
}