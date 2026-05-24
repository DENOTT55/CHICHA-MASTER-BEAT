draw_self();image_index = num

if a = "changeCharID" and !(oEditor.show_meta_menu)
{
	draw_set_halign(fa_center);draw_set_colour(c_maroon);draw_set_valign(fa_middle)
	draw_text(x,y,"NOTE ID: "+string(oEditor.charPlaceID)+"\nMax: "+string(global.chart_data.playersMax-1))
	if oEditor.charPlaceID > global.chart_data.playersMax-1 {oEditor.charPlaceID=0}
}
draw_set_halign(fa_left);draw_set_valign(fa_top)
if draw
{draw_sprite_ext(sEditButtonsIcon,num,x,y,image_xscale,image_yscale,image_angle,image_blend,image_alpha)}