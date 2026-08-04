angle = 0
if room != rmFreeplay {exit}

songs = [
	["Chicha Mania", sChicheroIcon, sChicheroArt, "Kimihito"],
    ["Carcel Infierno", sChicheroIcon, sChicheroArt, "Kimihito"],
    ["Test", sChicheroIcon, sChicheroArt, "Kimihito"],
]

// --- NUEVAS VARIABLES PARA EL ARTE ---
current_art = songs[0][2];      // Guardamos cuál es el arte que se está mostrando
art_target_x = 1100;             // Posición X final (centro/derecha de tu pantalla, ajusta a tu gusto)
art_start_x = room_width + 400; // Posición X inicial (escondido a la derecha fuera de pantalla)
art_x = art_target_x;           // Empieza ya en su lugar
art_y = 500;                    // Altura Y a la que se dibuja el arte

// Variables de selección y control
selected_song = 0;          // Índice de la canción seleccionada
item_spacing = 140;         // Espacio vertical entre canciones

// Variables para el movimiento y centrado general
center_y = 160;             
current_scroll = 0;         

// NUEVO: Arreglos para controlar el lerp individual de cada canción
var _num_songs = array_length(songs);
song_visual_x = array_create(_num_songs, 80);     // Al inicio todas parten en X = 80
song_visual_alpha = array_create(_num_songs, 1.0); // Al inicio todas parten con opacidad 1.0

STOPMOVING = false

// Variables para el control táctil
touch_start_y = 0;
touch_start_x = 0;
initial_selected = 0; // Guarda qué canción estaba activa justo al tocar
is_swiping = false;   // Nos dice si estamos arrastrando o solo tocando

// --- VARIABLES DE ERROR (Añadir al final del Create) ---
show_error_msg = false;  // Controla si se dibuja el texto de error