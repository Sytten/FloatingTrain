

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




/*-------------------------------------------------------------------------
   Perform a 2D FFT inplace given a complex 2D array
   The direction dir, 1 for forward, -1 for reverse
   The size of the array (nx,ny)
   Return false if there are memory problems or
      the dimensions are not powers of 2
*/
int FFT2D(complex<float> **c,int nx,int ny,int dir)
{
   int i,j;
   int m,twopm;
   float *real,*imag;

   /* Transform the rows */
   real = (float *)malloc(nx * sizeof(float));
   imag = (float *)malloc(nx * sizeof(float));
   if (real == NULL || imag == NULL)
      return(FALSE);
   if (!Powerof2(nx,&m,&twopm) || twopm != nx)
      return(FALSE);
   for (j=0;j<ny;j++) {
      for (i=0;i<nx;i++) {
         real[i] = c[i][j].real;
         imag[i] = c[i][j].imag;
      }
      FFT(dir,m,real,imag);
      for (i=0;i<nx;i++) {
         c[i][j].real = real[i];
         c[i][j].imag = imag[i];
      }
   }
   free(real);
   free(imag);

   /* Transform the columns */
   real = (float *)malloc(ny * sizeof(float));
   imag = (float *)malloc(ny * sizeof(float));
   if (real == NULL || imag == NULL)
      return(FALSE);
   if (!Powerof2(ny,&m,&twopm) || twopm != ny)
      return(FALSE);
   for (i=0;i<nx;i++) {
      for (j=0;j<ny;j++) {
         real[j] = c[i][j].real;
         imag[j] = c[i][j].imag;
      }
      FFT(dir,m,real,imag);
      for (j=0;j<ny;j++) {
         c[i][j].real = real[j];
         c[i][j].imag = imag[j];
      }
   }
   free(real);
   free(imag);

   return(TRUE);
}

/*-------------------------------------------------------------------------
   This computes an in-place complex-to-complex FFT
   x and y are the real and imaginary arrays of 2^m points.
   dir =  1 gives forward transform
   dir = -1 gives reverse transform

     Formula: forward
                  N-1
                  ---
              1   \          - j k 2 pi n / N
      X(n) = ---   >   x(k) e                    = forward transform
              N   /                                n=0..N-1
                  ---
                  k=0

      Formula: reverse
                  N-1
                  ---
                  \          j k 2 pi n / N
      X(n) =       >   x(k) e                    = forward transform
                  /                                n=0..N-1
                  ---
                  k=0
*/
int FFT(int dir,int m,float *x,float *y)
{
   long nn,i,i1,j,k,i2,l,l1,l2;
   float c1,c2,tx,ty,t1,t2,u1,u2,z;

   /* Calculate the number of points */
   nn = 1;
   for (i=0;i<m;i++)
      nn *= 2;

   /* Do the bit reversal */
   i2 = nn >> 1;
   j = 0;
   for (i=0;i<nn-1;i++) {
      if (i < j) {
         tx = x[i];
         ty = y[i];
         x[i] = x[j];
         y[i] = y[j];
         x[j] = tx;
         y[j] = ty;
      }
      k = i2;
      while (k <= j) {
         j -= k;
         k >>= 1;
      }
      j += k;
   }

   /* Compute the FFT */
   c1 = -1.0;
   c2 = 0.0;
   l2 = 1;
   for (l=0;l<m;l++) {
      l1 = l2;
      l2 <<= 1;
      u1 = 1.0;
      u2 = 0.0;
      for (j=0;j<l1;j++) {
         for (i=j;i<nn;i+=l2) {
            i1 = i + l1;
            t1 = u1 * x[i1] - u2 * y[i1];
            t2 = u1 * y[i1] + u2 * x[i1];
            x[i1] = x[i] - t1;
            y[i1] = y[i] - t2;
            x[i] += t1;
            y[i] += t2;
         }
         z =  u1 * c1 - u2 * c2;
         u2 = u1 * c2 + u2 * c1;
         u1 = z;
      }
      c2 = sqrt((1.0 - c1) / 2.0);
      if (dir == 1)
         c2 = -c2;
      c1 = sqrt((1.0 + c1) / 2.0);
   }

   /* Scaling for forward transform */
   if (dir == 1) {
      for (i=0;i<nn;i++) {
         x[i] /= (float)nn;
         y[i] /= (float)nn;
      }
   }

   return(TRUE);
}

/*-------------------------------------------------------------------------
   Calculate the closest but lower power of two of a number
   twopm = 2**m <= n
   Return TRUE if 2**m == n
*/
int Powerof2(int n,int *m,int *twopm)
{
   if (n <= 1) {
      *m = 0;
      *twopm = 1;
      return(FALSE);
   }

   *m = 1;
   *twopm = 2;
   do {
      (*m)++;
      (*twopm) *= 2;
   } while (2*(*twopm) <= n);

   if (*twopm != n)
      return(FALSE);
   else
      return(TRUE);
}

























