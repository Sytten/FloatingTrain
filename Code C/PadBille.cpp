

/*
	Padding de la bille normalisée
*/
float* PadBille(float* billeNorm, unsigned int outHeight, unsigned int outWidth)
{
	float* billeNormPad = new float[outHeight*outWidth];
	
	
	for(int height = 0; height < SIZE_BILLE; height++)
	{
		for(int width = 0; width < SIZE_BILLE; width++)
		{
			billeNormPad[width + outWidth*height] = billeNorm[width + SIZE_BILLE*height];
		}
	}
	
	return billeNormPad;
}