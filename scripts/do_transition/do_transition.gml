/// @function do_transition(_target_room, [_in_style])
/// @description Crea el objeto de transición y viaja a la room indicada
/// @param {Asset.GMRoom} _target_room La room destino a la que queremos ir
/// @param {String} [_in_style] El estilo de entrada: "fade" (por defecto) o "iris"

function do_transition(_target_room, _in_style = "fade") {
    if (!instance_exists(oTransitionShape)) {
		global.previus = room
        var _trans = instance_create_depth(0, 0, -9999, oTransitionShape);
		global.goTo = _target_room
        _trans.target_room = _target_room; 
        _trans.in_style = _in_style; // Le pasamos el estilo elegido
    }
}