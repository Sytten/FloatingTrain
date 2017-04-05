

/*
	Cree la nouvelle image du plateau, normalisée entre 0 et 1, paddé aux dimensions requises
*/
float* PlateauNormPad(const boost::shared_array<uint8_t> in_ptrImage, unsigned int inWidth, unsigned int inHeight, unsigned int outWidth,unsigned int outHeight)
{
	float* plateauPad = new float[outWidth*outHeight];
	
	
	for(int i = 0; i < inHeight; i++)
	{
		for(int j = 0; j < inWidth*3; j += 3)
		{
			plateauPad[j + outWidth*i] = (float)(in_ptrImage[j + inWidth*3*i]) / 255.0;
		}
	}
	
	
}