function crear_feedback(_col, _input_type){
    // Creamos el objeto de efecto en la posición de impacto de la fila correspondiente
    var _fx = instance_create_depth(oGameplay.hit_x, oGameplay.row_y[_col], -10, oFeedback);
    if dir_col[_col]==1{_fx.dir = 1}
	if dir_col[_col]==-1{_fx.dir = -1}
    // Le asignamos un color según si fue un Tap o un Swipe
    if (_input_type == "swipe") {
        _fx.color = c_fuchsia;
    } else if (_input_type == "tap") {
        _fx.color = c_yellow;
    } else {
		_fx.MISS = true
        _fx.color = c_red;
		MISSES++
    }
}