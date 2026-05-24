// Evento Draw GUI de oGameplay
draw_set_color(c_dkgray);
draw_rectangle(btn_back[0], btn_back[1], btn_back[2], btn_back[3], false);
draw_set_color(c_white);
draw_text(btn_back[0] + 10, btn_back[1] + 15, "< VOLVER");
var _W = camera_get_view_width(0)

if (combo > 3) {
    draw_text_transformed(_W/2, 100, string(combo) + " COMBO", 1.5, 1.5, 0);
}

draw_text_transformed(_W/16, 100, string(global.players_data.player1), 1.5, 1.5, 0);
draw_text_transformed(_W/16, 120, string(global.players_data.player2), 1.5, 1.5, 0);
draw_text_transformed(_W/16, 140, string(global.players_data.player3), 1.5, 1.5, 0);
draw_text_transformed(_W/16, 160, string(global.players_data.player4), 1.5, 1.5, 0);
draw_text_transformed(_W/16, 180, string(global.players_data.player5), 1.5, 1.5, 0);
draw_text_transformed(_W/16, 200, string(global.players_data.player6), 1.5, 1.5, 0);


if object_exists(oPlayer) 
{

	// Puntos y Combo
	draw_set_halign(fa_right);
	draw_text((view_get_hport(0)*1.8) - 40, 20, "SCORE: " + string(puntos));
	draw_text((view_get_hport(0)*1.8) - 40, 50, "MAX COMBO: " + string(max_combo));
	draw_text((view_get_hport(0)*1.8) - 40, 80, "MISSES: " + string(MISSES));
	draw_set_halign(fa_center);
	draw_set_font(-1); // Usa una fuente más grande si tienes una
	
}