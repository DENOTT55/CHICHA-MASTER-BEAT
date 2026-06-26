// --- 1. CONFIGURACIÓN DEL MENÚ PRINCIPAL ---
menu_options = [
    { name: "DENOTT",		rol: "Director | Animador | Artista | Programador", },
    { name: "RATIGANM",		rol: "Animador | Artista", },
    { name: "KIMIHITO",		rol: "Musico", },
];

menu_index = 0;
menu_count = array_length(menu_options);

// Variables para el movimiento suave (Lerp) de la línea punteada
cursor_y = 0;
target_cursor_y = 0;

// --- 2. CONFIGURACIÓN TÁCTIL Y BARRA DE INFORMACIÓN ---
use_touch_controls = false;
if os_type == os_android {use_touch_controls = true;}

info_bar_height = 50;
visual_index = 0;

// Obtenemos el tamaño de la pantalla (GUI)
var gw = display_get_gui_width();
var gh = display_get_gui_height();

// Propiedades de los botones táctiles
touch_btn_size = 180; // Tamaño estándar
touch_btn_back_size = 180; // Botón "Volver" más pequeño, como pediste
touch_btn_y = gh - touch_btn_size / 4 - 10; // Al fondo de la pantalla

// Distribuimos el espacio a lo ancho para 6 botones (7 espacios de separación)
var spacing = gw / 5;

X = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]

// Estructura de los 6 botones táctiles
touch_buttons = [
    { id: "BACK",  x: spacing * 1, y: touch_btn_y, size: touch_btn_back_size, key: global.BACK, pressed: false },
    //{ id: "LEFT",  x: spacing * 2, y: touch_btn_y, size: touch_btn_size, key: global.LEFT, pressed: false },
    { id: "DOWN",  x: spacing * 2, y: touch_btn_y, size: touch_btn_size, key: global.DOWN, pressed: false },
    { id: "UP",    x: spacing * 3, y: touch_btn_y, size: touch_btn_size, key: global.UP, pressed: false },
    //{ id: "RIGHT", x: spacing * 5, y: touch_btn_y, size: touch_btn_size, key: global.RIGHT, pressed: false },
    { id: "ENTER", x: spacing * 4, y: touch_btn_y, size: touch_btn_size, key: global.ENTER, pressed: false }
];