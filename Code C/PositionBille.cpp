
// Retourne la position de la bille dans le tableau de la corrélation
void PositionBille(float* correlation, unsigned int tailleX, unsigned int tailleY, float seuil, int* posX, int* posY)
{
	int posX_max = -1;
	int posY_max = -1;
	float val_max = 0.0;
	
	// Trouve la valeur maximale de la corrélation
	for(int height = 0; height < tailleY; height++)
	{
		for(int width = 0; width < tailleX; width++)
		{
			if(correlation[width + tailleX*height] > val_max)
			{
				val_max = correlation[width + tailleX*height];
				posX_max = width;
				posY_max = height;
			}
		}
	}
	
	// Si la valeur maximale est plus grande que le seuil, on retourne la position de la bille
	if(val_max > seuil)
	{
		posX = posX_max;
		posY = posY_max;
	}
	else
	{
		posX = -1;
		posY = -1;
	}
}




