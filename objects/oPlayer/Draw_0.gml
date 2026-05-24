draw_self()
if playerID = 1 {image_blend = c_aqua}
if playerID = 2 {image_blend = c_lime}

draw_text(x,y,"playerID: "+ string(playerName))
/*
with (oGameplay) {
    draw_text(other.x,other.y,"ZT +" + string(cam_target_zoom))
	draw_text(other.x,other.y-40,"Z +" + string(cam_zoom))
}
