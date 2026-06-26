draw_self();image_index = num

if a = "changeCharID" and !(oEditor.show_meta_menu)
{	
	var sContainer = skinFunction(oEditor.player[oEditor.charPlaceID])
	var sICON = sContainer.icon.spr
	
	draw_set_halign(fa_center);draw_set_colour(c_white);draw_set_valign(fa_middle)
	draw_sprite_ext(sICON,-1,x,y,image_xscale,image_yscale,image_angle,image_blend,image_alpha)
	draw_text(x,y-(sprite_get_height(sprite_index)/2)-20,"NOTE FOR:\n"+string(oEditor.player[oEditor.charPlaceID]))
	draw_text(x,y+(sprite_get_height(sprite_index)/2)+20,"NOTE ID: "+string(oEditor.charPlaceID)+"\nMax: "+string(global.chart_data.playersMax-1))
	if oEditor.charPlaceID > global.chart_data.playersMax-1 {oEditor.charPlaceID=0}
}
draw_set_halign(fa_left);draw_set_valign(fa_top)
if draw
{draw_sprite_ext(sEditButtonsIcon,num,x,y,image_xscale,image_yscale,image_angle,image_blend,image_alpha)}