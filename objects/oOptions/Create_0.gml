// ==========================================
// ESTRUCTURA DEL MENÚ DE OPCIONES
// ==========================================
menu_state = 0; // 0 = Navegando Categorías, 1 = Navegando Opciones
sel_cat = 0;    // Categoría seleccionada
sel_opt = 0;    // Opción seleccionada

// Variables para el Scroll de las opciones
scroll_y = 0;
target_scroll = 0;
item_height = 50; // Separación vertical entre opciones

options_list = [
    {
        category: "Pantalla y Gráficos",
        items: [
            { name: "Resolución", key: "resolution", type: "list", options: ["1280x720", "1920x1080", "2560x1440"], val: 1 },
            { name: "Desactivar Antialiasing", key: "disable_aa", type: "check", val: false, frame: 0 }
        ]
    },
    {
        category: "Juego y Controles",
        items: [
            { name: "Cambiar Controles", key: "rebind_keys", type: "action", val: 0 },
            { name: "Velocidad de Notas", key: "note_speed", type: "list", options: ["x1.0", "x1.5", "x2.0", "x2.5", "x3.0"], val: 0 },
            { name: "Modo Autoplay", key: "autoplay", type: "check", val: false, frame: 0 }
        ]
    }
];


// ==========================================
// ESTRUCTURA DEL MENÚ DE CONTROLES
// ==========================================
sel_ctrl = 0;       // Opción seleccionada dentro de controles
rebind_timer = 0;   // Temporizador para el conteo de 3 segundos

// Lista de controles a configurar adaptada a tus variables reales
controls_list = [
    { name: "Carril Izquierdo",     key_ref: "Lrow" },
    { name: "Carril Derecho",       key_ref: "Rrow" },
    { name: "Carril Sec. Izq",      key_ref: "SLrow" },
    { name: "Carril Sec. Der",      key_ref: "SRrow" },
    { name: "Acción: Taunt",        key_ref: "TAUNT" },
    { name: "Pausar Juego",         key_ref: "PAUSE" },
    { name: "Navegar Arriba",       key_ref: "UP" },
    { name: "Navegar Abajo",        key_ref: "DOWN" },
    { name: "Navegar Izquierda",    key_ref: "LEFT" },
    { name: "Navegar Derecha",      key_ref: "RIGHT" },
    { name: "Aceptar / Ok",         key_ref: "ENTER" },
    { name: "Volver",               key_ref: "BACK" },
    { name: "Modo Debug",           key_ref: "DEBUG1" },
];

// ==========================================
// APLICAR RESOLUCIÓN
// ==========================================
function scr_apply_resolution(_index) {
    var _w = 1280; var _h = 720; // Default (16:9)
    
    // Lista actualizada: ["1280x720", "1920x1080", "2160x1080", "2400x1080"]
    if (_index == 1) { _w = 1920; _h = 1080; }      // 16:9 (Estándar)
    else if (_index == 2) { _w = 2160; _h = 1080; } // 18:9 (Móviles estándar)
    else if (_index == 3) { _w = 2400; _h = 1080; } // 20:9 (Móviles modernos)
    
    // Aplicar tamaño a la superficie principal
    surface_resize(application_surface, _w, _h);
    
    // Solo cambiar el tamaño de ventana y centrar si NO estamos en Android
    if (os_type != os_android) {
        window_set_size(_w, _h);
        // Usar una alarma de 1 frame para centrar suele ser más seguro, 
        // pero puedes llamarlo directo si no te da fallos.
        window_center(); 
    }
}

// ==========================================
// APLICAR ANTIALIASING (Filtro de Textura)
// ==========================================
function scr_apply_aa(_is_disabled) {
    // Si está desactivado (true), usa interpolación de píxeles (pixel-perfect).
    // Si está activado (false), usa suavizado lineal (Antialiasing).
    gpu_set_texfilter(!_is_disabled);
}

// ==========================================
// GUARDAR CONFIGURACIÓN EN JSON
// ==========================================
function scr_save_settings(_options_list) {
    // Extraemos los valores de tu options_list
    var _save_data = {
        resolution: _options_list[0].items[0].val,
        disable_aa: _options_list[0].items[1].val,
        note_speed: _options_list[1].items[1].val,
        autoplay: _options_list[1].items[2].val,
        
        // Guardamos las teclas globales
        key_Lrow: global.Lrow,
        key_Rrow: global.Rrow,
        key_SLrow: global.SLrow,
        key_SRrow: global.SRrow,
        key_TAUNT: global.TAUNT,
        key_PAUSE: global.PAUSE,
        key_UP: global.UP,
        key_DOWN: global.DOWN,
        key_LEFT: global.LEFT,
        key_RIGHT: global.RIGHT,
        key_ENTER: global.ENTER,
        key_BACK: global.BACK,
        key_DEBUG1: global.DEBUG1
    };
    
    // Guardar en un archivo JSON local
    var _json_string = json_stringify(_save_data);
    var _file = file_text_open_write("settings.json");
    file_text_write_string(_file, _json_string);
    file_text_close(_file);
    
    show_debug_message("Configuración guardada exitosamente.");
}

// Asumo que esta función existe en algún script tuyo
// scr_load_settings(options_list); 

// ==========================================
// SISTEMA DE BOTONES TÁCTILES AÑADIDO (Create_0.gml)
// ==========================================
use_touch_controls = false;
if os_type == os_android {use_touch_controls = true;}

info_bar_height = 50; // [cite: 4]

var gw = display_get_gui_width(); // [cite: 5]
var gh = display_get_gui_height(); // [cite: 5]

touch_btn_size = 180; // [cite: 6]
touch_btn_back_size = 180; // [cite: 6]
touch_btn_y = gh - touch_btn_size / 4 - 10; // [cite: 7, 8]

var spacing = gw / 7; // [cite: 9]
X = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]; // [cite: 9]

// Estructura de los 6 botones táctiles exactos a tu código
touch_buttons = [
    { id: "BACK",  x: spacing * 1, y: touch_btn_y, size: touch_btn_back_size, key: global.BACK, pressed: false }, // [cite: 9]
    { id: "LEFT",  x: spacing * 2, y: touch_btn_y, size: touch_btn_size, key: global.LEFT, pressed: false }, // [cite: 9]
    { id: "DOWN",  x: spacing * 3, y: touch_btn_y, size: touch_btn_size, key: global.DOWN, pressed: false }, // [cite: 9]
    { id: "UP",    x: spacing * 4, y: touch_btn_y, size: touch_btn_size, key: global.UP, pressed: false }, // [cite: 9]
    { id: "RIGHT", x: spacing * 5, y: touch_btn_y, size: touch_btn_size, key: global.RIGHT, pressed: false }, // [cite: 10]
    { id: "ENTER", x: spacing * 6, y: touch_btn_y, size: touch_btn_size, key: global.ENTER, pressed: false } // [cite: 10]
];