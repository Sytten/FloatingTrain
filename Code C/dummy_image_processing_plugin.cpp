/*
 * dummy_gabarit_version_etudiante.cpp
 *
 *  Created on: Jun 08, 2016
 *      Author: chaj1907, micj1901
 */


//aucun include externe local autre que la librairie boost (déjà installée) ou
//les include standard n'est permis. Tout doit tenir dans ce fichier. 
//Si vous utilisez une librairie externe le code source doit tenir ici.
#include <cstdint>
#include <iostream>
#include <complex>
#include "image_processing_plugin.h"
using namespace std;


//Modifiez cette classe-ci, vous pouvez faire littéralement ce que vous voulez y compris la renommer
//à condition de faire un "replace all"
//à condition de conserver le constructeur par défaut et aucun autre
//le destructeur virtuel
//et à condition que vous conserviez les 2 fonctions publiques virtuelles telles quelles.
class DummyImageProcessingPlugin : public ImageProcessingPlugin
{
public:
	DummyImageProcessingPlugin(); 			//vous devez utiliser ce constructeur et aucun autre
	virtual ~DummyImageProcessingPlugin();
	
	/*! \brief Receive an image to process.
	 *
	 *  This function will be called every time we need the to send the X,Y position and differentials to
	 *  the **firmware**.
	 *
	 *  \param in_ptrImage Image data.
	 *  \param in_unWidth Image width (= 480).
	 *  \param in_unHeight Image height (= 480).
	 *  \param out_dXPos X coordinate (sub-)pixel position of the ball.
	 *  \param out_dYPos Y coordinate (sub-)pixel position of the ball.
	 *
	 */
	virtual void OnImage(const boost::shared_array<uint8_t> in_ptrImage, unsigned int in_unWidth, unsigned int in_unHeight,
			double & out_dXPos, double & out_dYPos);

			
			
	/*! \brief Receive an image to process.
	 *
	 *  This function will be called every time we need the to send the X,Y position and differentials to
	 *  the **firmware**.
	 *
	 *  \param in_dXPos X coordinate position of the ball in <arbitrary input units.
	 *  \param in_dYPos Y coordinate position of the ball.
	 *  \param out_dXDiff X speed of the ball in <input units> per second.
	 *  \param out_dYDiff Y speed of the ball in <input units> per second.
	 *
	 */
	virtual void OnBallPosition(double in_dXPos, double in_dYPos, double & out_dXDiff, double & out_dYDiff);

private:
	#define SIZE_BILLE 22


	// Cree la nouvelle image du plateau, normalisée entre 0 et 1, paddé aux dimensions requises
	complex<float>** PlateauNormPad(const boost::shared_array<uint8_t> in_ptrImage, unsigned int inWidth, unsigned int inHeight, unsigned int cropWidth, unsigned int cropHeight, unsigned int cropX, unsigned int cropY, unsigned int outWidth,unsigned int outHeight);

// Padding de la bille normalisée
	complex<float>** PadBille(const float* billeNorm, unsigned int outHeight, unsigned int outWidth);
	// Higher power of two
	int NextPowerOfTwo(int num);
	int FFT2D(complex<float> **c,int nx,int ny,int dir);
	int FFT(int dir,int m,float *x,float *y);
	// Lower power of two
	int Powerof2(int n,int *m,int *twopm);
    void MultiplicationComplexe(complex<float>** fft1, complex<float>** fft2, int sizeX, int sizeY);
	void PositionBille(complex<float>** correlation, int tailleX, int tailleY, int pointXCrop, int pointYCrop, float seuil, int* outPosX, int* outPosY);

	const float billeNorm[SIZE_BILLE*SIZE_BILLE] = { 	0.34370440, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.24958678, 0.24958678, 0.061351482, 0.061351482, 0.14370443, 0.14370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443,
0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.24958678, 0.24958678, 0.061351482, 0.061351482, 0.14370443, 0.14370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443,
0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.18292011, 0.18292011, -0.39747205, -0.39747205, -0.44060931, -0.44060931, -0.40139362, -0.40139362, -0.42492303, -0.42492303, -0.38962892, -0.38962892, -0.22492303, -0.22492303, 0.34370443, 0.34370443, 0.34370443, 0.34370443,
0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.18292011, 0.18292011, -0.39747205, -0.39747205, -0.44060931, -0.44060931, -0.40139362, -0.40139362, -0.42492303, -0.42492303, -0.38962892, -0.38962892, -0.22492303, -0.22492303, 0.34370443, 0.34370443, 0.34370443, 0.34370443,
0.34370443, 0.34370443, 0.17115541, 0.17115541, -0.44453087, -0.44453087, -0.48766813, -0.48766813, -0.46413872, -0.46413872, -0.39747205, -0.39747205, -0.44060931, -0.44060931, -0.068060279, -0.068060279, -0.43276617, -0.43276617, -0.32688382, -0.32688382, 0.34370443, 0.34370443,
0.34370443, 0.34370443, 0.17115541, 0.17115541, -0.44453087, -0.44453087, -0.48766813, -0.48766813, -0.46413872, -0.46413872, -0.39747205, -0.39747205, -0.44060931, -0.44060931, -0.068060279, -0.068060279, -0.43276617, -0.43276617, -0.32688382, -0.32688382, 0.34370443, 0.34370443,
0.34370443, 0.34370443, -0.29943284, -0.29943284, -0.38570735, -0.38570735, -0.32296225, -0.32296225, -0.13864851, -0.13864851, -0.12688380, -0.12688380, -0.26806030, -0.26806030, -0.31904069, -0.31904069, -0.41707990, -0.41707990, -0.47198185, -0.47198185, -0.044530869, -0.044530869,
0.34370443, 0.34370443, -0.29943284, -0.29943284, -0.38570735, -0.38570735, -0.32296225, -0.32296225, -0.13864851, -0.13864851, -0.12688380, -0.12688380, -0.26806030, -0.26806030, -0.31904069, -0.31904069, -0.41707990, -0.41707990, -0.47198185, -0.47198185, -0.044530869, -0.044530869,
0.084880896, 0.084880896, 0.022135796, 0.022135796, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.092724033, 0.092724033, 0.34370443, 0.34370443, 0.041743640, 0.041743640, -0.33080539, -0.33080539, -0.32296225, -0.32296225,
0.084880896, 0.084880896, 0.022135796, 0.022135796, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.092724033, 0.092724033, 0.34370443, 0.34370443, 0.041743640, 0.041743640, -0.33080539, -0.33080539, -0.32296225, -0.32296225,
-0.17394264, -0.17394264, -0.075903416, -0.075903416, 0.22213580, 0.22213580, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443, -0.091589697, -0.091589697,
-0.17394264, -0.17394264, -0.075903416, -0.075903416, 0.22213580, 0.22213580, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443, -0.091589697, -0.091589697,
-0.18962891, -0.18962891, -0.48374656, -0.48374656, -0.39355049, -0.39355049, -0.091589697, -0.091589697, 0.34370443, 0.34370443, 0.28488091, 0.28488091, 0.16331227, 0.16331227, 0.34370443, 0.34370443, 0.15939070, 0.15939070, -0.32296225, -0.32296225, -0.27982500, -0.27982500,
-0.18962891, -0.18962891, -0.48374656, -0.48374656, -0.39355049, -0.39355049, -0.091589697, -0.091589697, 0.34370443, 0.34370443, 0.28488091, 0.28488091, 0.16331227, 0.16331227, 0.34370443, 0.34370443, 0.15939070, 0.15939070, -0.32296225, -0.32296225, -0.27982500, -0.27982500,
0.014292659, 0.014292659, -0.49943283, -0.49943283, -0.46806028, -0.46806028, -0.20923676, -0.20923676, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.21429266, 0.21429266, 0.34370443, 0.34370443, -0.12296224, -0.12296224, -0.43276617, -0.43276617, -0.23276617, -0.23276617,
0.014292659, 0.014292659, -0.49943283, -0.49943283, -0.46806028, -0.46806028, -0.20923676, -0.20923676, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.21429266, 0.21429266, 0.34370443, 0.34370443, -0.12296224, -0.12296224, -0.43276617, -0.43276617, -0.23276617, -0.23276617,
0.34370443, 0.34370443, -0.45237401, -0.45237401, -0.46413872, -0.46413872, -0.30727598, -0.30727598, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443, -0.30335441, -0.30335441, -0.35433480, -0.35433480, 0.32801816, 0.32801816,
0.34370443, 0.34370443, -0.45237401, -0.45237401, -0.46413872, -0.46413872, -0.30727598, -0.30727598, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.34370443, -0.30335441, -0.30335441, -0.35433480, -0.35433480, 0.32801816, 0.32801816,
0.34370443, 0.34370443, 0.12409658, 0.12409658, -0.41707990, -0.41707990, -0.41707990, -0.41707990, -0.22492303, -0.22492303, -0.18178578, -0.18178578, 0.12017501, 0.12017501, -0.33864853, -0.33864853, -0.37394264, -0.37394264, 0.033900503, 0.033900503, 0.34370443, 0.34370443,
0.34370443, 0.34370443, 0.12409658, 0.12409658, -0.41707990, -0.41707990, -0.41707990, -0.41707990, -0.22492303, -0.22492303, -0.18178578, -0.18178578, 0.12017501, 0.12017501, -0.33864853, -0.33864853, -0.37394264, -0.37394264, 0.033900503, 0.033900503, 0.34370443, 0.34370443,
0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.26135150, 0.26135150, -0.28766814, -0.28766814, -0.41707990, -0.41707990, -0.35825637, -0.35825637, -0.068060279, -0.068060279, -0.21315832, -0.21315832, 0.28095934, 0.28095934, 0.34370443, 0.34370443, 0.34370443, 0.34370443,
0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.26135150, 0.26135150, -0.28766814, -0.28766814, -0.41707990, -0.41707990, -0.35825637, -0.35825637, -0.068060279, -0.068060279, -0.21315832, -0.21315832, 0.28095934, 0.28095934, 0.34370443, 0.34370443, 0.34370443, 0.34370443};
					
					
					
					
};

DummyImageProcessingPlugin::DummyImageProcessingPlugin()
{
//Insérez votre code ici
}

DummyImageProcessingPlugin::~DummyImageProcessingPlugin()
{
//Insérez votre code ici
}

void DummyImageProcessingPlugin::OnImage(const boost::shared_array<uint8_t> in_ptrImage, unsigned int in_unWidth, unsigned int in_unHeight,
		double & out_dXPos, double & out_dYPos)
{
//Insérez votre code ici
	out_dXPos = -1.0;
	out_dYPos = -1.0;

	int seuil = 20;
	int FORWARD = -1;
	int REVERSE = 1;
	int cropW = 480;
	int cropH = 480;
	int cropX = 0;
	int cropY = 0;

	// Checks to make sure we don't try to crop out of bounds
	if(cropX+cropW > in_unWidth)
	{
		cropW -= (cropX + cropW) - in_unWidth;
	}
	if(cropY+cropH > in_unHeight)
	{
		cropH -= (cropY + cropH) - in_unHeight;
	}

	int padW = NextPowerOfTwo(cropW+SIZE_BILLE-1);
	int padH = NextPowerOfTwo(cropH+SIZE_BILLE-1);

	complex<float>** plateauComplex = PlateauNormPad(in_ptrImage, in_unWidth , in_unHeight , cropW, cropH, cropX, cropY, padW, padH);
	complex<float>** billeComplex = PadBille(DummyImageProcessingPlugin::billeNorm, padH, padW);
	
	if(!FFT2D(plateauComplex,padW,padH,FORWARD) ) //Forward FFT 
		cout << "FFT Plateau Failed" << endl;

	if(!FFT2D(billeComplex,padW,padH,FORWARD) ) //Forward FFT 
		cout << "FFT Bille Failed" << endl;

	// Multiplication Complexe 
	MultiplicationComplexe(plateauComplex, billeComplex, padW,padH);	

	if (!FFT2D(plateauComplex, padW,padH,REVERSE) )// Reverse FFT
		cout << "Correlation  Failed!!!l" << endl;


   // Seuil
	int positionX,positionY;   
    PositionBille(plateauComplex,padW,padH, cropX, cropY, seuil, &positionX,&positionY);

	cout << "PositionX : " << positionX << endl;
	cout << "PositionY: " << positionY << endl;

	out_dXPos = positionX;
	out_dYPos = positionY;

	delete plateauComplex;
	delete billeComplex;
}

void DummyImageProcessingPlugin::OnBallPosition(double in_dXPos, double in_dYPos, double & out_dXDiff, double & out_dYDiff)
{
	//insérez votre code ici
	out_dXDiff = 0.0;
	out_dYDiff = 0.0;

}

complex<float>** DummyImageProcessingPlugin::PlateauNormPad(const boost::shared_array<uint8_t> in_ptrImage, unsigned int inWidth, unsigned int inHeight, unsigned int cropWidth, unsigned int cropHeight, unsigned int cropX, unsigned int cropY, unsigned int outWidth,unsigned int outHeight)
{
	complex<float>** plateauPad = new complex<float>* [outHeight]();

	for(int height = 0; height < outHeight; height++)
	{
		plateauPad[height] = new complex<float>[outWidth]();
	}
	
	// Copies a subsection of the image, from int8 to float (0.0-1.0) to a new array
	for(int height = 0; height < cropHeight; height++)
	{
		int newColumn = 0;
		for(int oldColumn = 0; oldColumn < cropWidth*3; oldColumn += 3)
		{
			plateauPad[height][newColumn].real((float)(in_ptrImage[oldColumn + inWidth*3*height]) / 255.0);
			newColumn++;
		}
	}
	
	return plateauPad;
}


// Padding de la bille normalisée
complex<float>** DummyImageProcessingPlugin::PadBille(const float* billeNorm, unsigned int outHeight, unsigned int outWidth)
{
	complex<float>** billeNormPad = new complex<float>* [outHeight](); 
	

	for(int height = 0; height < outHeight; height++)
	{
		billeNormPad[height] = new complex<float>[outWidth]();
	}	
	
	for(int height = 0; height < SIZE_BILLE; height++)
	{
		for(int width = 0; width < SIZE_BILLE; width++)
		{
			billeNormPad[height][width].real(billeNorm[width + SIZE_BILLE*height]);
		}
	}
	
	return billeNormPad;
}

// Returns the next biggest power of two
int DummyImageProcessingPlugin::NextPowerOfTwo(int num)
{
	int powOfTwo = 0;
	float exponent = 1;
	do
	{
		powOfTwo = (int) pow(2.0, exponent);
		exponent += 1.0;
	}while(num > powOfTwo);

	return powOfTwo;
}

/*-------------------------------------------------------------------------
   Perform a 2D FFT inplace given a complex 2D array
   The direction dir, 1 for forward, -1 for reverse
   The size of the array (nx,ny)
   Return false if there are memory problems or
      the dimensions are not powers of 2
*/
	int DummyImageProcessingPlugin::FFT2D(complex<float> **c,int nx,int ny,int dir)
	{
	   int i,j;
	   int m,twopm;
	   float *real,*imag;

	   /* Transform the rows */
	   real = (float *)malloc(nx * sizeof(float));
	   imag = (float *)malloc(nx * sizeof(float));
	   if (real == NULL || imag == NULL)
		  return(false);
	   if (!Powerof2(nx,&m,&twopm) || twopm != nx)
		  return(false);
	   for (j=0;j<ny;j++) {
		  for (i=0;i<nx;i++) {
		     real[i] = c[i][j].real();
		     imag[i] = c[i][j].imag();
		  }
		  FFT(dir,m,real,imag);
		  for (i=0;i<nx;i++) {
		     c[i][j].real(real[i]);
		     c[i][j].imag(imag[i]);
		  }
	   }
	   free(real);
	   free(imag);

	   /* Transform the columns */
	   real = (float *)malloc(ny * sizeof(float));
	   imag = (float *)malloc(ny * sizeof(float));
	   if (real == NULL || imag == NULL)
		  return(false);
	   if (!Powerof2(ny,&m,&twopm) || twopm != ny)
		  return(false);
	   for (i=0;i<nx;i++) {
		  for (j=0;j<ny;j++) {
		     real[j] = c[i][j].real();
		     imag[j] = c[i][j].imag();
		  }
		  FFT(dir,m,real,imag);
		  for (j=0;j<ny;j++) {
		     c[i][j].real(real[j]);
		     c[i][j].imag(imag[j]);
		  }
	   }
	   free(real);
	   free(imag);

	   return(true);
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
	int DummyImageProcessingPlugin::FFT(int dir,int m,float *x,float *y)
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

	   return(true);
	}

	/*-------------------------------------------------------------------------
	   Calculate the closest but lower power of two of a number
	   twopm = 2**m <= n
	   Return TRUE if 2**m == n
	*/
	int DummyImageProcessingPlugin::Powerof2(int n,int *m,int *twopm)
	{
	   if (n <= 1) {
		  *m = 0;
		  *twopm = 1;
		  return(false);
	   }

	   *m = 1;
	   *twopm = 2;
	   do {
		  (*m)++;
		  (*twopm) *= 2;
	   } while (2*(*twopm) <= n);

	   if (*twopm != n)
		  return(false);
	   else
		  return(true);
	}

	// Executes pixel by pixel multiplication places result in fft1
	void DummyImageProcessingPlugin::MultiplicationComplexe(complex<float>** fft1, complex<float>** fft2, int sizeX, int sizeY)
	{
		for (int i = 0; i < sizeX; i++)
		{
			for(int j = 0; j < sizeY; j++)
			{
				fft1[i][j] = fft1[i][j] * fft2[i][j];
			}
		}
	}
	
	// Retourne la position de la bille dans le tableau de la corrélation
	void DummyImageProcessingPlugin::PositionBille(complex<float>** correlation, int tailleX, int tailleY, int pointXCrop, int pointYCrop, float seuil, int* outPosX, int* outPosY)
	{
		int posX_max = -1;
		int posY_max = -1;
		float val_max = 0.0;
	
		// Trouve la valeur maximale de la corrélation
		for(int height = 0; height < tailleY; height++)
		{
			for(int width = 0; width < tailleX; width++)
			{
				if(correlation[height][width].real() > val_max)
				{
					val_max = abs(correlation[height][width]);
					posX_max = width - (SIZE_BILLE/2) + pointXCrop;
					posY_max = height - (SIZE_BILLE/2) + pointYCrop;
				}
			}
		}
		cout << "v: " << val_max << " x: " << posX_max << "y: " << posY_max << endl;
	
		// Si la valeur maximale est plus grande que le seuil, on retourne la position de la bille
		if(val_max > seuil)
		{
			*outPosX = posX_max;
			*outPosY = posY_max;
		}
		else
		{
			*outPosX = -1;
			*outPosY = -1;
		}
	}



//ne rien modifier passé ce commentaire
//ne rien modifier passé ce commentaire
//ne rien modifier passé ce commentaire
//ne rien modifier passé ce commentaire
//ne rien modifier passé ce commentaire
//ne rien modifier passé ce commentaire
//ne rien modifier passé ce commentaire
//ne rien modifier passé ce commentaire

extern "C"
{
	ImageProcessingPlugin * Load();
	void Unload( ImageProcessingPlugin * in_pPlugin );
}

void Unload( ImageProcessingPlugin * in_pPlugin )
{
	delete in_pPlugin;
}

ImageProcessingPlugin * Load()
{
	//si vous changez le nom de la classe asssurez-vous de le changer aussi ci-dessous
	return new DummyImageProcessingPlugin;
}
