// Botón de Volver
btn_back = [10, 10, 110, 50];

depth = -999999

// --- DATOS DEL NIVEL ---
notes_array = [];
events_array = [];     
event_index_cam = 0;   
note_speed = 200;
current_time_sec = 0;
song_name = global.current_chart;
playersMax = 1;

noteTypeActual = 0
noteTypeActualType = 0

// SISTEMA MÓVIL DINÁMICO
global.sistema_movil_avanzado = true; // true para activarlo, false para el sistema clásico
global.modo_input = "FULL";           // "FULL" (pantalla completa) o "SPLIT" (dividida)
global.alerta_cambio_input = false;   // Úsala en tu evento Draw GUI para dibujar el aviso
global.tiempo_sin_fila2 = 0;          // Temporizador para volver a modo FULL tras 40s

// --- SISTEMA DE PUNTOS Y COMBOS ---
puntos = 0;
combo = 0;
max_combo = 0;
MISSES = 0
texto_precision = "";
color_precision = c_white;
precision_alpha = 0; 

_W = display_get_gui_width();
_H = display_get_gui_height();

// --- UI ---
btn_back = [_W - 120, 10, _W-10, 60];

// --- NUEVO: CONFIGURACIÓN INDEPENDIENTE POR FILA/CARRIL ---
// [Fila 0, Fila 1, Fila 2] -> Modifica estos valores a tu gusto en X
hit_x_col = [room_width / 2, room_width / 2 -60, room_width / 2 +60];

hit_x_colEVENT = [room_width / 2, room_width / 2-60, room_width / 2+60];
hit_x_colEVENTvel = [0.2, 0.2, 0.2];
NLINE = 1

// Dirección de la nota (1 = Izquierda a Derecha || -1 = Derecha a Izquierda)
// Configurado para que la segunda fila (índice 1) vaya al revés
dir_col = [1, 1, -1]; 

hit_x = room_width / 2; // Respaldo por compatibilidad

// --- ESTADOS ---
col_is_pressed = [false, false, false];
touch_start_y = [-1, -1, -1, -1, -1];
audio_instance = 0;
// --- Inicialización de Audio ---
snd_stream = -1;

song_name = global.song_to_load;

// --- CARGA DEL JSON ---
var _path = working_directory + song_name + ".json";
if (file_exists(_path)) {
    var _file = file_text_open_read(_path);
    var _json = "";
    
    // Agregué llaves {} al while por seguridad estructural
    while (!file_text_eof(_file)) {
        _json += file_text_read_string(_file); 
        file_text_readln(_file);
    }
    file_text_close(_file);
    
    var _data = json_parse(_json);
    
    // Carga segura de variables principales usando [$ "llave"] y un valor por defecto (??)
    notes_array  = _data[$ "notes"] ?? [];
    events_array = _data[$ "evento"] ?? [];
    note_speed   = _data[$ "note_speed"] ?? 100; // Ajusta el 100 a tu valor base por defecto
    playersMax   = _data[$ "playersMax"] ?? 1;
    
    // Carga dinámica del NUEVO sistema de personajes (Máximo 6)
    for (var i = 0; i < 6; i++) {
        var _llave = "player" + string(i + 1); // Genera "player1", "player2", etc.
        
        // Intentamos leer el personaje del JSON. Si no existe (chart viejo), le ponemos "?" o "chichero"
        var _personaje_cargado = _data[$ _llave] ?? "?";
        
        // 1. Lo actualizamos en tu struct global original
        global.players_data[$ _llave] = _personaje_cargado;
        
        // 2. Lo metemos en el array local (player[]) que usa tu nuevo menú dinámico
        player[i] = _personaje_cargado;
    }
    
    scr_sort_events();
    
    // Iniciar Música
    var _ogg_path = working_directory + song_name + ".ogg";
    if (file_exists(_ogg_path)) {
        snd_stream = audio_create_stream(_ogg_path);
        audio_instance = audio_play_sound(snd_stream, 1, false);
		audio_sound_gain(audio_instance,0)
    }
}

global.current_chart = global.chart_data.song_name

note_speed = note_speed*100

if playersMax > 3 {playersMax = 3}

player = [0,0,0,0,0,0,0,0,0,0];

for (var i = 0; i < playersMax; ++i) {
    player[i+1] = instance_create_layer(1216,864,"Instances",oPlayer);
}

				 global.P1ID = player[1].id;global.P1ID.playerID = 0;global.P1ID.playerName = global.players_data.player1
if player[2]!=0 {global.P2ID = player[2].id;global.P2ID.playerID = 1;global.P2ID.playerName = global.players_data.player2}
if player[3]!=0 {global.P3ID = player[3].id;global.P3ID.playerID = 2;global.P2ID.playerName = global.players_data.player3}
if player[4]!=0 {global.P4ID = player[4].id;global.P4ID.playerID = 3;global.P2ID.playerName = global.players_data.player4}
if player[5]!=0 {global.P5ID = player[5].id;global.P5ID.playerID = 4;global.P2ID.playerName = global.players_data.player5}
if player[6]!=0 {global.P6ID = player[6].id;global.P6ID.playerID = 5;global.P2ID.playerName = global.players_data.player6}

playersInGame = {
	p1: global.P1ID, 
	p2: global.P2ID, 
	p3: global.P3ID,
	p4: global.P4ID,
	p5: global.P5ID,
	p6: global.P6ID,
}

// --- VARIABLES RESTANTES ---
row_height = 100; 
row_y = [
    (room_height / 2) + 140,
    (room_height / 2) + 140,
    (room_height / 2) + 140,
];

EOlist = {}

instance_create_layer(1216,864+200,"Instances",oChichamovil_EO);

touch_start_y = [-1, -1, -1, -1, -1];

// --- CONFIGURACIÓN DE CÁMARA ---
cam_x = room_width / 2;
cam_y = room_height / 2;
cam_zoom = 1;

cam_target_x = room_width / 2;
cam_target_y = room_height / 2;
cam_target_zoom = 1;

cam_lerp_speed = 0.1; 
cam_zoom_speed = 0.05;
event_index_cam = 0; 
cam_shake = 0;

is_countdown = true;
is_playing = false;

// Calcular cuánto dura un "beat" en segundos
// Fórmula: 60 / BPM = Segundos por cada golpe
var _bpm = global.chart_data.bpm; // Cambia esto por tu variable real de BPM
sec_per_beat = 60 / _bpm; 

countdown_timer = 0;
countdown_beats = 4; // Cambia esto si quieres una cuenta de 3, 4, o más tiempos

// --- Configuración Visual ---
countdown_sprite = sCountdown; // Tu sprite con imágenes: [0]=3, [1]=2, [2]=1, [3]=GO!
countdown_alpha = 1.0;
countdown_scale = 1.5;
countdown_index = 0; // Para saber qué sub-imagen mostrar
countdown_fading = false; // Controla cuándo empieza a desaparecer
countdown_falling = 0

// Variables para el control táctil del menú
touch_start_y = 0;
initial_Mn = 0;
is_swiping = false;