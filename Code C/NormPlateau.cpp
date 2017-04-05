

/*
	Cree la nouvelle image du plateau, normalisée entre 0 et 1, paddé aux dimensions requises
*/
float* PlateauNormPad(const boost::shared_array<uint8_t> in_ptrImage, unsigned int inWidth, unsigned int inHeight, unsigned int outWidth,unsigned int outHeight)
{
	float* plateauPad = new float[outWidth*outHeight];
	
	
	for(int height = 0; height < inHeight; height++)
	{
		for(int width = 0; width < inWidth*3; width += 3)
		{
			plateauPad[width + outWidth*height] = (float)(in_ptrImage[width + inWidth*3*height]) / 255.0;
		}
	}
	
	
}