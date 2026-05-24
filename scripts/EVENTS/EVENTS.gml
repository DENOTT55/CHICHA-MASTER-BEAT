function get_event_metadata(_type) {
    static _list = [
        { 
            name: "ENFOQUE", 
            spr: sEvCam, 
            properties: [
                { name: "Objetivo", key: "val", type: "list", options: ["player", "player2", "centro", "centrar", "publico"], def: "player" },
                { name: "Suavizado", key: "lerp_spd", type: "number", step: 0.1, def: 0.1 }
            ]
        },
        { 
            name: "ZOOM DRAMATICO", 
            spr: sEvZoom, 
            properties: [
                { name: "Nivel Zoom", key: "val", type: "number", step: 0.1, def: 1 },
                { name: "Velocidad", key: "zoom_spd", type: "number", step: 0.1, def: 0.05 }
            ]
        },
        { 
            name: "EFECTO SACUDIDA", 
            spr: sEvShake, 
            properties: [
                { name: "Fuerza", key: "intensity", type: "number", step: 1, def: 10 },
                { name: "Duración", key: "duration", type: "number", step: 0.1, def: 0.5 }
            ]
        },
		{ 
            name: "CENTRO DE IMPACTO", 
            spr: sEvShake, 
            properties: [
                { name: "Linea", key: "line", type: "number", step: 1, def: 1 },
				{ name: "Separacion X", key: "plus", type: "number", step: 10, def: 0 },
                { name: "Duración", key: "duration", type: "number", step: 0.1, def: 0.2 }
            ]
        }
    ];
    
	// --- NUEVO: Si pides -1, te da el total de eventos automáticamente ---
    if (_type == -1) return array_length(_list);
	
    // --- SEGURIDAD: Retornar un evento genérico si el índice falla ---
    if (_type < 0 || _type >= array_length(_list)) {
        return { 
            name: "EVENTO DESCONOCIDO", 
            spr: sEvUnknown, // <--- Tu sprite de emergencia
            properties: [{ name: "Valor", key: "val", type: "number", step: 1, def: 1 }] 
        };
    }
    
    return _list[_type];
}