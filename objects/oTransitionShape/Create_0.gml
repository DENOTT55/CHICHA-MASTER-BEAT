persistent = true; 

transition_state = "out"; 
target_room = -1; 
in_style = "fade"; // Por defecto, se sobreescribe desde el script

transition_sprite = global.transitionShape; 
transition_color = c_black; 
transition_speed = 0.15; 

t = 25
resetT = t

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();
max_scale = max(_gui_w, _gui_h) / (sprite_get_width(transition_sprite) / 2); 

// Variables para el Iris
current_scale = max_scale; 
target_scale = 0;          

// Nueva variable para el Fade
fade_alpha = 1.0; 

surf_transition = -1;