

void fft2d(float* inputData, int width, int height, float* realOut, float* imagOut)
{

    // Two outer loops iterate on output data.

    for (int yWave = 0; yWave < height; yWave++)

    {

        for (int xWave = 0; xWave < width; xWave++)

        {

            // Two inner loops iterate on input data.

            for (int ySpace = 0; ySpace < height; ySpace++)

            {

                for (int xSpace = 0; xSpace < width; xSpace++)

                {

                    // Compute real, imag, and ampltude.

                    realOut[xWave + yWave*width] += (inputData[xSpace + ySpace*width] * cos(

                            2 * PI * ((1.0 * xWave * xSpace / width) + (1.0

                                    * yWave * ySpace / height)))) / sqrt(

                            width * height);

                    imagOut[xWave + yWave*width] -= (inputData[xSpace + ySpace*width] * sin(

                            2 * PI * ((1.0 * xWave * xSpace / width) + (1.0

                                    * yWave * ySpace / height)))) / sqrt(

                            width * height);
                }
            }

        }

    }
}

void convolution(float* realIn1, float* imagIn1, float* realIn2, float* imagIn2, int size, float* realOut, float* imagOut)
{
	for(int i = 0; i < size; i++)
	{
		realOut[i] = realIn1 * realIn2;
		imagOut[i] = imagIn1 * imagIn2;
	}
}

























