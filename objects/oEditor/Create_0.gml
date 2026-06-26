
global.current_chart = global.chart_data.song_name

global.CHARTING_MODE = true

playersInGame = {
	player1: global.P1ID, 
	player2: global.P2ID, 
	player3: global.P3ID,
	player4: global.P4ID,
	player5: global.P5ID,
	player6: global.P6ID,
}

TXT = "";
alpha = 0;
snap_div = 2


player = ["chichero","chichero",0,0,0,0,0,0,0,0];
player1= "chichero";player2= "";player3= "";player4= "";player5= "";player6= "";



// --- INICIALIZACIÓN DE ARREGLOS ---
notes_array = [];
events_array = [];
selected_note = -1;
selected_event = -1;
loadSong = false;
is_playing = false;
snd_stream = -1;
audio_instance = -1;
current_time_sec = 0;
active_input = "";

// ... (Mantén tu código anterior hasta active_input = "") ...

// --- NUEVAS VARIABLES PARA SYNC INDICATOR ---
sync_flash = 0;
prev_time_sec = 0;

// --- NUEVO SISTEMA DE MENÚ METADATOS ESCALABLE ---
current_meta_tab = 0; 
active_input_type = ""; // Para saber si editamos texto o número
active_input_min = 0;
active_input_max = 0;

// Estructura del menú: ¡Añade o quita secciones fácilmente aquí!
meta_menu_layout = [
    {
        tab_name: "Canción",
        elements: [
            { key: "song_name", label: "Nombre de Audio", type: "text" },
            { key: "bpm", label: "Velocidad BPM", type: "number", min_val: 10, max_val: 500 },
            { key: "skin_name", label: "Skin Global", type: "text" }
        ]
    },
    {
        tab_name: "Gameplay",
        elements: [
            { key: "note_speed", label: "Vel. Notas (x100)", type: "number", min_val: 1, max_val: 200 },
            { key: "snap_div", label: "Div. Grilla", type: "number", min_val: 1, max_val: 16 },
        ]
    },
	{
        // --- NUEVA SOLAPA DE PERSONAJES ---
        tab_name: "Personajes",
        elements: [
			{ key: "playersMax", label: "Max Jugadores", type: "number", min_val: 1, max_val: 6 },
            { type: "players_list" } // Este tipo especial avisará al Draw que debe dibujar los iconos
        ]
    },
    {
        tab_name: "Opciones",
        elements: [
            // Ejemplo de Checkbox. Asegúrate de que global.CHARTING_MODE esté en global.chart_data si vas a usarlo así.
            { key: "silent", label: "Silenciar sonidos in-Game", type: "bool" } 
        ]
    }
];

// Nos aseguramos que los booleanos existan en el chart_data para evitar crash
if (!variable_struct_exists(global.chart_data, "silent")) global.chart_data.silent = false;

// ... (Sigue con el resto de tu Create original, como loadSong etc.) ...

editing_player_name = -1
charPlaceID = 0

// --- NUEVAS VARIABLES PARA MÓVIL Y MENÚ ---
show_meta_menu = false;
// Botones UI Dinámicos (Se calculan en Step/Draw)
btn_meta = [0, 0, 0, 0]; 
btn_play = [0, 0, 0, 0];
btn_save = [0, 0, 0, 0];
btn_load = [0, 0, 0, 0];
btn_close_meta = [0, 0, 0, 0];

// Variables para el Scroll Táctil
touch_y_start = 0;
time_start_scroll = 0;
is_dragging = false;
click_valid = false;
drag_threshold = 15; // Píxeles de holgura antes de considerarlo un scroll

// Configuración de la grilla (Se actualiza dinámicamente)
col_x = [0, 0, 0];
col_width = 100;
hit_y = 0; 

// --- NUEVAS VARIABLES PARA EDICIÓN DE EVENTOS Y DESPLEGABLE ---
current_event_tool = 0;        // ID del evento seleccionado en la lista desplegable
show_event_dropdown = false;   // Controla si se muestra la lista desplegable
editing_event_prop_key = "";   // Qué propiedad del evento estamos editando
editing_event_prop_type = "";  // Si es un número o texto

#region // Cargar chart al iniciar
if (loadSong == false) {
    var _path = working_directory + global.chart_data.song_name + ".json";
    if (file_exists(_path)) {
        var _file = file_text_open_read(_path);
        var _json = "";
        while (!file_text_eof(_file)) {
            _json += file_text_read_string(_file);
            file_text_readln(_file);
        }
        file_text_close(_file);
        
        var _loaded = json_parse(_json);
        
        // --- METADATOS GLOBALES ---
        // Comprueba si la variable existe en el JSON antes de asignarla
        if (variable_struct_exists(_loaded, "song_name"))   global.chart_data.song_name = _loaded.song_name;
        if (variable_struct_exists(_loaded, "bpm"))         global.chart_data.bpm = _loaded.bpm;
        if (variable_struct_exists(_loaded, "player_name")) global.chart_data.player_name = _loaded.player_name;
        if (variable_struct_exists(_loaded, "skin_name"))   global.chart_data.skin_name = _loaded.skin_name;
        if (variable_struct_exists(_loaded, "note_speed"))  global.chart_data.note_speed = _loaded.note_speed;
        if (variable_struct_exists(_loaded, "snap_div"))    global.chart_data.snap_div = _loaded.snap_div;
        if (variable_struct_exists(_loaded, "playersMax"))  global.chart_data.playersMax = _loaded.playersMax;
        
        // --- DATOS DE LOS JUGADORES ---
        if (variable_struct_exists(_loaded, "player1")) {
            global.players_data.player1 = _loaded.player1;
            player[0] = _loaded.player1;
        }
        if (variable_struct_exists(_loaded, "player2")) {
            global.players_data.player2 = _loaded.player2;
            player[1] = _loaded.player2;
        }
        if (variable_struct_exists(_loaded, "player3")) {
            global.players_data.player3 = _loaded.player3;
            player[2] = _loaded.player3;
        }
        if (variable_struct_exists(_loaded, "player4")) {
            global.players_data.player4 = _loaded.player4;
            player[3] = _loaded.player4;
        }
        if (variable_struct_exists(_loaded, "player5")) {
            global.players_data.player5 = _loaded.player5;
            player[4] = _loaded.player5;
        }
        if (variable_struct_exists(_loaded, "player6")) {
            global.players_data.player6 = _loaded.player6;
            player[5] = _loaded.player6;
        }
        
        // --- ARRAYS DE NOTAS Y EVENTOS ---
        // También protegemos "notes" por si acaso cargas un JSON antiguo que no tenga notas aún
        if (variable_struct_exists(_loaded, "notes")) {
            notes_array = _loaded.notes;
        }
        if (variable_struct_exists(_loaded, "evento")) {
            events_array = _loaded.evento;
        }
    }
    loadSong = true;
}
#endregion
