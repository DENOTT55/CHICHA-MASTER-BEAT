alpha = 1;
scale = 0.5;
angle = 0
col = c_white;
Y = -10
TXT = ""
dir = 1
ler = 240*dir

MISS = false

_STATENOW = 0
lerpX = 0

_skinPath = global.chart_data.skin_name


with (oGameplay) {
	other.col = color_precision
	other.TXT = texto_precision
	other.dir = texto_precision
}

depth = -999999


/*
show_debug_message("-----------------------------------");
show_debug_message("El valor de _skinPath es: >" + string(_skinPath) + "<");
show_debug_message("El texto final a buscar es: >s" + string(_skinPath) + "<");
show_debug_message("-----------------------------------");
show_debug_message("Buscando el sprite: " + "s" + string(_skinPath));