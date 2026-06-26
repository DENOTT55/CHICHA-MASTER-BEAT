function INT_REWARDS(){
	global.REWARDS = [
		//Nombre , Descripcion, flaged
		["Y ya?",							"Completa cualquier cancion",									false],
		["Si Luis",							"Completa una cancion al limite de perder",						false],
		["Eres una maquina",				"Haz 5 'Cool release' seguidos",								false],
		["Echando a perder se aprende",		"Falla 20 veces en una cancion",								false],
		["Sientete bienvenido",				"Entra al menú de creditos",									false],
		["No falta ninguna?",				"Completa todas las canciones del juego",						false],
		["Esto se va a descontrolar",		"Completa ABSOLUTAMENTE todas las canciones del juego",			false],
	];
	
	global.REWARD_QUEUE = [];
}

/// @function save_reward()
/// @description Guarda el progreso actual de los logros en un archivo .ini
function save_reward() {
    // Abrimos (o creamos si no existe) el archivo
    ini_open("logros_save.ini");
    
    // Recorremos el arreglo de recompensas
    for (var i = 0; i < array_length(global.REWARDS); i++) {
        // Usamos la sección "Logros", la clave será el NOMBRE del logro, y el valor será true/false (1 o 0)
        ini_write_real("Logros", global.REWARDS[i][0], global.REWARDS[i][2]);
    }
    
    // Es VITAL cerrar el archivo para que los datos se escriban en el disco duro
    ini_close();
    
    show_debug_message("Logros guardados correctamente.");
}

/// @function load_reward()
/// @description Carga el progreso de los logros desde el archivo .ini
function load_reward() {
    // Primero verificamos si el archivo de guardado existe
    if (file_exists("logros_save.ini")) {
        ini_open("logros_save.ini");
        
        for (var i = 0; i < array_length(global.REWARDS); i++) {
            // Leemos el valor. Si por alguna razón no existe esa clave (ej: añadiste un logro nuevo), 
            // tomará el valor por defecto que ya tiene en global.REWARDS[i][2] (que es false).
            global.REWARDS[i][2] = ini_read_real("Logros", global.REWARDS[i][0], global.REWARDS[i][2]);
        }
        
        ini_close();
        show_debug_message("Logros cargados correctamente.");
    } else {
        show_debug_message("No se encontró archivo de guardado previo. Iniciando desde cero.");
    }
}

/// @function UNLOCKREWARD(_name)
/// @param {string} _name El nombre exacto del logro a desbloquear
function UNLOCKREWARD(_name) {
    // Recorremos todo el arreglo de recompensas
    for (var i = 0; i < array_length(global.REWARDS); i++) {
        
        // Comprobamos si el nombre coincide con el de la lista
        if (global.REWARDS[i][0] == _name) {
            
            // Comprobamos si NO ha sido desbloqueado aún (flagged == false)
            //if (global.REWARDS[i][2] == false) {
                
                // 1. Lo marcamos como obtenido
                global.REWARDS[i][2] = true;
                
                // 2. Guardamos el progreso
                save_reward();
                
                // 3. --- NUEVO: Lo metemos a la lista de espera en vez de mostrarlo de golpe ---
                array_push(global.REWARD_QUEUE, {
                    titulo: global.REWARDS[i][0],
                    descripcion: global.REWARDS[i][1],
					imageNum : i
                });
                
                return true;
            //} else {
                // Si ya era true, simplemente lo ignoramos silenciosamente
           //     return false; 
           // }
        }
    }
    
    // Si el bucle termina y no encontró el nombre (por error tipográfico al llamarlo)
    show_debug_message("ERROR: El logro '" + _name + "' no existe en INT_REWARDS.");
    return false;
}