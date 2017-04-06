

/*
	Cree la nouvelle image du plateau, normalisée entre 0 et 1, paddé aux dimensions requises
*/
float* PlateauNormPad(const boost::shared_array<uint8_t> in_ptrImage, unsigned int inWidth, unsigned int inHeight, unsigned int cropWidth, unsigned int cropHeight, unsigned int cropX, unsigned int cropY, unsigned int outWidth,unsigned int outHeight)
{
	float* plateauPad = new float[outWidth*outHeight]();
	
	// Checks to make sure we don't try to crop out of bounds
	if(cropX+cropWidth > inWidth)
	{
		cropWidth -= (cropX + cropWidth) - inWidth;
	}
	if(cropY+cropHeight > inHeight)
	{
		cropHeight -= (cropY + cropHeight) - inHeight;
	}
	
	// Copies a subsection of the image, from int8 to float (0.0-1.0) to a new array
	for(int height = 0; height < cropHeight; height++)
	{
		for(int width = 0, int; width < cropWidth*3; width += 3)
		{
			plateauPad[width + outWidth*height] = (float)(in_ptrImage[width + inWidth*3*height]) / 255.0;
		}
	}
	
	return plateauPad;
}