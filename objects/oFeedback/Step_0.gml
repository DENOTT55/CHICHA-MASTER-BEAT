if MISS = false {
	alpha -= 0.02; // Se desvanece
	scale += 0.1;  // Se agranda
	if (alpha <= 0) instance_destroy();

	Y-=1
} else {
	alpha -= 0.02; // Se desvanece
	if (alpha <= 0) instance_destroy();
	angle+=20
	Y+=8
}

