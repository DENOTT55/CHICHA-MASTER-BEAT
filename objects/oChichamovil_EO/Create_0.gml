// --- SISTEMA DE ANIMACIÓN DEL JUGADOR ---
playerID = 0;playerName = "chichamovil"
bpm = global.chart_data.bpm;

state = "IDLE"; // Estados: "IDLE", "ACTION", "LOOP"
idle_mode = "N"; //- N normal - ALT left y right

depth = -1

last_beat = -1;
anim_speed = 1;

toX = x
toY = y
SPEED = 0.5

SPEEDX = SPEED
SPEEDY = SPEED

check = false

// --- DICCIONARIO DE ANIMACIONES ---
// Formato: "nombre_clave" : { spr: sprite_index, loop_start: inicio, loop_end: fin }
// (Si loop_end es -1, significa que el loop abarca hasta el último frame del sprite)

anim_config = skinFunction()

spr_idle_normal = anim_config.idle.spr;

// Variables de control interno para el estado LOOP
current_loop_start = 0;
current_loop_end = -1;