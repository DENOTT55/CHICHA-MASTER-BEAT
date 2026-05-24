image_xscale = lerp(image_xscale,scalex,0.3)
image_yscale = lerp(image_yscale,scaley,0.3)

with (oEditor) {
    if (show_meta_menu)
	{
		other.image_alpha = 0
	}
	else
	{
		other.image_alpha = 1
	}
	other.menu = -show_meta_menu
}