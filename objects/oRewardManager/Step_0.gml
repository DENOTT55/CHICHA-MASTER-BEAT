// REWARD QUEUE

// Comprobamos si hay algún logro esperando en la cola
if (array_length(global.REWARD_QUEUE) > 0) {
    
    // Comprobamos si la pantalla está libre (No existe ningún oShowReward activo)
    if (!instance_exists(oShowReward)) {
        
        // 1. Tomamos el primer logro de la lista (el índice 0)
        var _siguiente_logro = global.REWARD_QUEUE[0];
        
        // 2. Instanciamos el objeto en pantalla
        // (Ajusta la capa "UI" y las coordenadas X/Y a las que tú uses)
		if !layer_exists("UI") {layer_create(-10,"UI")}
        var _notif = instance_create_layer(0, 0, "UI", oShowReward);
        _notif.titulo = _siguiente_logro.titulo;
        _notif.descripcion = _siguiente_logro.descripcion;
		_notif.imageNum = _siguiente_logro.imageNum;
        
        // 3. Eliminamos ese logro de la lista de espera para que no se repita
        array_delete(global.REWARD_QUEUE, 0, 1);
    }
}