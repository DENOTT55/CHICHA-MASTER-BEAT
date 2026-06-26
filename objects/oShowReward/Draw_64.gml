
X = lerp(X,toX,0.1)
alpha = lerp(alpha,toAlpha,0.05)
image_yscale = lerp(image_yscale,Yscale,0.3)

draw_sprite_ext(sReward,0,X+20,10,4,image_yscale,0,image_blend,1)
draw_sprite_ext(sReward,imageNum+2,X+30,10,1,image_yscale,0,image_blend,1)

draw_set_font(global.Fonts.f1O);draw_set_halign(fa_left)
draw_text(X+20+20+150,30,titulo)
draw_set_font(global.Fonts.f1Om);
draw_text_ext(X+20+20+150,30+50,"- "+string(descripcion),20,400)

draw_sprite_ext(sReward,1,X+20,10,4,image_yscale,0,image_blend,alpha)


if X >= -(340*2) and X < -(340*2)+20
{instance_destroy()}