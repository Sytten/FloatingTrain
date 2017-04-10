/*
 * dummy_gabarit_version_etudiante.cpp
 *
 *  Created on: Jun 08, 2016
 *      Author: chaj1907, micj1901
 *						carj2124, mcgj2701
 */


//#define DEBUG
#include <cstdint>
#include <iostream>
#include <complex>
#include <chrono>
#include <stdlib.h>
#include <time.h>
#include "image_processing_plugin.h"
using namespace std;
using namespace std::chrono; 


class DummyImageProcessingPlugin : public ImageProcessingPlugin
{
public:
	DummyImageProcessingPlugin(); 			
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
	// Constantes
	#define SIZE_BILLE 22
	#define FORWARD -1
	#define REVERSE 1
	#define ORDRE_DIFF 6
	#define SPHERE_LOOKUP_BOTTOM_LEFT 0
	#define SPHERE_LOOKUP_TOP_LEFT 1
	#define SPHERE_LOOKUP_TOP_RIGHT 2
	#define SPHERE_LOOKUP_BOTTOM_RIGHT 3
	#define LOOKUP_OVERLAP 35
	
	#define SPHERE_LOOKUP_RANDOM 4

	struct CoordBille 
	{
		int x;
		int y;
	};
	
	//Membres privee
	int lastPosX = -1;
	int lastPosY = -1;
	int sphereNotFoundCounter = 0;
	vector<CoordBille> PositionsBilles_Prec; //Vecteur ordonnée de la position la plus ancienne jusqua la plus récente (max 7 position enregistré)
	complex<float>** billeComplex;
	
	//Methode privee
	// Cree la nouvelle image du plateau, normalisée entre 0 et 1, paddé aux dimensions requises
	complex<float>** PlateauNormPad(const boost::shared_array<uint8_t> in_ptrImage, unsigned int inWidth, unsigned int inHeight, unsigned int cropWidth, unsigned int cropHeight, unsigned int cropX, unsigned int cropY, unsigned int outWidth,unsigned int outHeight);
	// Padding de la bille normalisée
	complex<float>** PadBille(const float* billeNorm, unsigned int outHeight, unsigned int outWidth);
	// Higher power of two
	int NextPowerOfTwo(int num);
	//FFT
	int FFT2D(complex<float> **c,int nx,int ny,int dir);
	int FFT(int dir,int m,float *x,float *y);
	int Powerof2(int n,int *m,int *twopm);
    void MultiplicationComplexe(complex<float>** fft1, complex<float>** fft2, int sizeX, int sizeY);
	void PositionBille(complex<float>** correlation, int tailleX, int tailleY, int pointXCrop, int pointYCrop, float seuil, int* outPosX, int* outPosY);
	void CalculVitesse(unsigned int ordreMax, int* out_VitesseX, int* out_VitesseY);
	
	//Image de la bille normalise
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
														0.34370443, 0.34370443, 0.34370443, 0.34370443, 0.26135150, 0.26135150, -0.28766814, -0.28766814, -0.41707990, -0.41707990, -0.35825637, -0.35825637, -0.068060279, -0.068060279, -0.21315832, -0.21315832, 0.28095934, 0.28095934, 0.34370443, 0.34370443, 0.34370443, 0.34370443
	};
};

DummyImageProcessingPlugin::DummyImageProcessingPlugin()
{
	//Construire image de la bille avec padding jusqua la 256 et 512
	billeComplex =PadBille(DummyImageProcessingPlugin::billeNorm, 256, 256);
	if(!FFT2D(billeComplex,256,256,FORWARD) ) //Forward FFT
		cout << "FFT bille 256 failed" << endl;

	srand (time(NULL));
}

DummyImageProcessingPlugin::~DummyImageProcessingPlugin()
{
	delete billeComplex;
}

void DummyImageProcessingPlugin::OnImage(const boost::shared_array<uint8_t> in_ptrImage, unsigned int in_unWidth, unsigned int in_unHeight,
		double & out_dXPos, double & out_dYPos)
{
	#ifdef DEBUG
	high_resolution_clock::time_point t1 = high_resolution_clock::now();
	#endif // DEBUG

	out_dXPos = -1.0;
	out_dYPos = -1.0;

	int seuil = 20;
	int cropW;
	int cropH;
	int cropX;
	int cropY;
	int padW;
	int padH;

	complex<float>** plateauComplex;

	// If the previous position of the sphere is not known, we analyze an incomplete quadrant of the image
	if(lastPosX == -1 || lastPosY == -1)
	{
		cropW = 256-SIZE_BILLE-1;
		cropH = 256-SIZE_BILLE-1;

		// Selects which quadrant of the image to analyze (or a random position)
		switch (sphereNotFoundCounter){
			case SPHERE_LOOKUP_BOTTOM_LEFT:
				cropX = (in_unWidth/2)-cropW+LOOKUP_OVERLAP;
				if(cropX < 0)
					cropX = 0;
				cropY = (in_unHeight/2)-LOOKUP_OVERLAP;
				break;

			case SPHERE_LOOKUP_TOP_LEFT:
				cropX = (in_unWidth/2)-cropW+LOOKUP_OVERLAP;
				if(cropX < 0)
					cropX = 0;
				cropY = (in_unHeight/2)-cropH+LOOKUP_OVERLAP;
				if(cropY < 0)
					cropY  = 0;
				break;

			case SPHERE_LOOKUP_TOP_RIGHT:
				cropX = (in_unWidth/2)-LOOKUP_OVERLAP;
				cropY = (in_unHeight/2)-cropH+LOOKUP_OVERLAP;
				if(cropY < 0)
					cropY  = 0;
				break;

			case SPHERE_LOOKUP_BOTTOM_RIGHT:
				cropX = (in_unWidth/2)-LOOKUP_OVERLAP;
				cropY = (in_unHeight/2)-LOOKUP_OVERLAP;
				break;
	
			default:	// Random lookup
				cropX = rand() % (in_unWidth - cropW);
				cropY = rand() % (in_unHeight - cropH);
				sphereNotFoundCounter = SPHERE_LOOKUP_RANDOM;
				
				break;

		}

		// Checks to make sure we don't try to crop out of bounds
		if(cropX+cropW > in_unWidth)
		{
			cropW -= (cropX + cropW) - in_unWidth;
		}
		if(cropY+cropH > in_unHeight)
		{
			cropH -= (cropY + cropH) - in_unHeight;
		}

		padW = 256;
		padH = 256;

		high_resolution_clock::time_point t1 = high_resolution_clock::now();

		plateauComplex = PlateauNormPad(in_ptrImage, in_unWidth , in_unHeight , cropW, cropH, cropX, cropY, padW, padH);
	
	
		if(!FFT2D(plateauComplex,padW,padH,FORWARD) ) //Forward FFT 
			cout << "FFT Plateau Failed" << endl;

		// Multiplication Complexe 
		MultiplicationComplexe(plateauComplex, billeComplex, padW,padH);

	}
	// If the previous position of the sphere is known, we analyze a subsection of the image
	else
	{
		sphereNotFoundCounter = -1;
		cropW = 256-SIZE_BILLE-1;
		cropH = 256-SIZE_BILLE-1;
		cropX = lastPosX-(cropW/2);
		cropY = lastPosY-(cropH/2);
		// Checks to make sure we don't try to crop out of bounds
		if(cropX < 0)
			cropX = 0;
		if(cropY < 0)
			cropY = 0;
		if(cropX+cropW > in_unWidth)
			cropW -= (cropX + cropW) - in_unWidth;
		if(cropY+cropH > in_unHeight)
			cropH -= (cropY + cropH) - in_unHeight;

		padW = 256;
		padH = 256;

		plateauComplex = PlateauNormPad(in_ptrImage, in_unWidth , in_unHeight , cropW, cropH, cropX, cropY, padW, padH);
	
		if(!FFT2D(plateauComplex,padW,padH,FORWARD) ) //Forward FFT 
			cout << "FFT Plateau Failed" << endl;

		// Multiplication Complexe 
		MultiplicationComplexe(plateauComplex, billeComplex, padW,padH);
	}
	
	if (!FFT2D(plateauComplex, padW,padH,REVERSE) )// Reverse FFT
		cout << "Correlation  Failed!!!l" << endl;


    // Détection et position de la bille
	int positionX,positionY;   
    PositionBille(plateauComplex,padW,padH, cropX, cropY, seuil, &positionX,&positionY);

	// Temps
	#ifdef DEBUG
	high_resolution_clock::time_point t2 = high_resolution_clock::now();
    auto duration = duration_cast<microseconds>( t2 - t1 ).count();
    cout << "Recherche: " << duration/1000.0 << "ms" << endl;;
	
	cout << "PositionX : " << positionX << endl;
	cout << "PositionY: " << positionY << endl;
	#endif // DEBUG


	lastPosX = positionX;
	lastPosY = positionY;
	out_dXPos = positionX;
	out_dYPos = positionY;

	if(lastPosX == -1 || lastPosY == -1)
		sphereNotFoundCounter++;
                                                                               
	delete plateauComplex;
}

void DummyImageProcessingPlugin::OnBallPosition(double in_dXPos, double in_dYPos, double & out_dXDiff, double & out_dYDiff)
{
	//Declarations Variable
	int vitesseX,vitesseY;
	
	CoordBille NouvellePosition;
	NouvellePosition.x = in_dXPos;
	NouvellePosition.y = in_dYPos;
	
	//Ajouter position recu dans le vecteur
	PositionsBilles_Prec.push_back(NouvellePosition);
	
	//Retirer le premier element si la taille depasse 7
	if(PositionsBilles_Prec.size() > 7)
		PositionsBilles_Prec.erase (PositionsBilles_Prec.begin(),PositionsBilles_Prec.begin()+1);
	
	
	CalculVitesse(ORDRE_DIFF,&vitesseX,&vitesseY);
	
	out_dXDiff = vitesseX;
	out_dYDiff = vitesseY;

}

complex<float>** DummyImageProcessingPlugin::PlateauNormPad(const boost::shared_array<uint8_t> in_ptrImage, unsigned int inWidth, unsigned int inHeight, unsigned int cropWidth, unsigned int cropHeight, unsigned int cropX, unsigned int cropY, unsigned int outWidth,unsigned int outHeight)
{
	complex<float>** plateauPad = new complex<float>* [outHeight]();

	for(int height = 0; height < outHeight; height++)
	{
		plateauPad[height] = new complex<float>[outWidth]();
	}
	
	// Copies a subsection of the image, from int8 to float (0.0-1.0) to a new array
	int newHeight = 0;
	for(int oldHeight = cropY; oldHeight < cropY+cropHeight; oldHeight++)
	{
		int newColumn = 0;
		for(int oldColumn = cropX*3; oldColumn < cropX*3+cropWidth*3; oldColumn += 3)
		{
			plateauPad[newHeight][newColumn].real((float)(in_ptrImage[oldColumn + inWidth*3*oldHeight]) / 255.0);
			newColumn++;
		}
		newHeight++;
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
		  return(false);struct CoordBille 
{
	int x;
	int y;
};
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
		//cout << "v: " << val_max << " x: " << posX_max << "y: " << posY_max << endl;
	
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

	void DummyImageProcessingPlugin::CalculVitesse(unsigned int ordreMax, int* out_VitesseX, int* out_VitesseY)
	{
		// Clamp ordre max entre 1 et 6
		if(ordreMax < 1)
		{
			ordreMax = 1;
		}
		else if( ordreMax > 6)
		{
			ordreMax = 6;
		}
	
	
		// Déterminer l'ordre possible
		int ordrePossible;
		int TailleVecteur = PositionsBilles_Prec.size();
	
		if( TailleVecteur> ordreMax)	
		{
			ordrePossible = ordreMax;
		}
		else
		{
			ordrePossible = TailleVecteur -1;
		}
	
		//Appliquer l'équation de dérivation correspondante 
		switch(ordrePossible)
		{
			case 1: // Ordre 1
				*out_VitesseX = (PositionsBilles_Prec.at(TailleVecteur-1).x - PositionsBilles_Prec.at(TailleVecteur-2).x);
				*out_VitesseY = (PositionsBilles_Prec.at(TailleVecteur-1).y - PositionsBilles_Prec.at(TailleVecteur-2).y);
				cout << "Order was 1"  << endl;
				break;
			case 2: // Ordre 2
				*out_VitesseX = (3*PositionsBilles_Prec.at(TailleVecteur-1).x - 4*PositionsBilles_Prec.at(TailleVecteur-2).x + PositionsBilles_Prec.at(TailleVecteur-3).x)/2;
				*out_VitesseY = (3*PositionsBilles_Prec.at(TailleVecteur-1).y - 4*PositionsBilles_Prec.at(TailleVecteur-2).y + PositionsBilles_Prec.at(TailleVecteur-3).y)/2;
				cout << "Order was 2"  << endl;
				break;
			case 3: // Ordre 3
				*out_VitesseX = (11*PositionsBilles_Prec.at(TailleVecteur-1).x - 18*PositionsBilles_Prec.at(TailleVecteur-2).x + 9*PositionsBilles_Prec.at(TailleVecteur-3).x- 2*PositionsBilles_Prec.at(TailleVecteur-4).x)/6;
				*out_VitesseY = (11*PositionsBilles_Prec.at(TailleVecteur-1).y - 18*PositionsBilles_Prec.at(TailleVecteur-2).y + 9*PositionsBilles_Prec.at(TailleVecteur-3).y- 2*PositionsBilles_Prec.at(TailleVecteur-4).y)/6;
				cout << "Order was 3"  << endl;
				break;
			case 4:
				*out_VitesseX = (25*PositionsBilles_Prec.at(TailleVecteur-1).x - 48*PositionsBilles_Prec.at(TailleVecteur-2).x + 36*PositionsBilles_Prec.at(TailleVecteur-3).x- 16*PositionsBilles_Prec.at(TailleVecteur-4).x + 3*PositionsBilles_Prec.at(TailleVecteur-5).x)/12;
				*out_VitesseY = (25*PositionsBilles_Prec.at(TailleVecteur-1).y - 48*PositionsBilles_Prec.at(TailleVecteur-2).y + 36*PositionsBilles_Prec.at(TailleVecteur-3).y- 16*PositionsBilles_Prec.at(TailleVecteur-4).y + 3*PositionsBilles_Prec.at(TailleVecteur-5).y)/12;
				cout << "Order was 4"  << endl;
				break;
			case 5:
				*out_VitesseX = (137*PositionsBilles_Prec.at(TailleVecteur-1).x - 300*PositionsBilles_Prec.at(TailleVecteur-2).x + 300*PositionsBilles_Prec.at(TailleVecteur-3).x- 200*PositionsBilles_Prec.at(TailleVecteur-4).x + 75*PositionsBilles_Prec.at(TailleVecteur-5).x - 12*PositionsBilles_Prec.at(TailleVecteur-6).x)/60;
				*out_VitesseY = (137*PositionsBilles_Prec.at(TailleVecteur-1).y - 300*PositionsBilles_Prec.at(TailleVecteur-2).y + 300*PositionsBilles_Prec.at(TailleVecteur-3).y- 200*PositionsBilles_Prec.at(TailleVecteur-4).y + 75*PositionsBilles_Prec.at(TailleVecteur-5).y - 12*PositionsBilles_Prec.at(TailleVecteur-6).y)/60;
				cout << "Order was 5"  << endl;
				break;
			case 6:
				*out_VitesseX = (147*PositionsBilles_Prec.at(TailleVecteur-1).x - 360*PositionsBilles_Prec.at(TailleVecteur-2).x + 450*PositionsBilles_Prec.at(TailleVecteur-3).x- 400*PositionsBilles_Prec.at(TailleVecteur-4).x + 225*PositionsBilles_Prec.at(TailleVecteur-5).x - 72*PositionsBilles_Prec.at(TailleVecteur-6).x + 10*PositionsBilles_Prec.at(TailleVecteur-7).x)/60;
				*out_VitesseY = (147*PositionsBilles_Prec.at(TailleVecteur-1).y - 360*PositionsBilles_Prec.at(TailleVecteur-2).y + 450*PositionsBilles_Prec.at(TailleVecteur-3).y- 400*PositionsBilles_Prec.at(TailleVecteur-4).y + 225*PositionsBilles_Prec.at(TailleVecteur-5).y - 72*PositionsBilles_Prec.at(TailleVecteur-6).y + 10*PositionsBilles_Prec.at(TailleVecteur-7).y)/60;
				cout << "Order was 6"  << endl;
				break;
			default :
				*out_VitesseX = 0;
				*out_VitesseY = 0;
				break;
		}
		*out_VitesseX = *out_VitesseX * 30;
		*out_VitesseY = *out_VitesseY * 30;
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
