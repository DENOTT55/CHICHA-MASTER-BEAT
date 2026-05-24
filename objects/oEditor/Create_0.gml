global.current_chart = "test";

INT_VARS()

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
// Datos del Nivel
global.chart_data = {
    song_name: "test",
    bpm: 120,
    skin_name: "vaso",
    note_speed: 2,
    snap_div: 2,
	playersMax: 1,
};

player = ["chichero","chichero",0,0,0,0,0,0,0,0];
player1= "chichero";player2= "";player3= "";player4= "";player5= "";player6= "";

global.players_data = {
    player1: "chichero",
	player2: "",player3: "",player4: "",player5: "",player6: "",
};

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
        if (variable_struct_exists(_loaded, "note_speed"))  global.chart_data.note_speed = _loaded.note_speed / 100;
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
