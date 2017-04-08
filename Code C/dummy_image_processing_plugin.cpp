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
	float* PlateauNormPad(const boost::shared_array<uint8_t> in_ptrImage, unsigned int inWidth, unsigned int inHeight, unsigned int cropWidth, unsigned int cropHeight, unsigned int cropX, unsigned int cropY, unsigned int outWidth,unsigned int outHeight);

// Padding de la bille normalisée
	float* PadBille(const float* billeNorm, unsigned int outHeight, unsigned int outWidth);
	// Higher power of two
	int NextPowerOfTwo(int num);
	int FFT2D(complex<float> **c,int nx,int ny,int dir);
	int FFT(int dir,int m,float *x,float *y);
	// Lower power of two
	int Powerof2(int n,int *m,int *twopm);
    void convolution(complex<float>** fft1, complex<float>** fft2, int sizeX, int sizeY);
	void PositionBille(complex<float>** correlation, int tailleX, int tailleY, float seuil, int* outPosX, int* outPosY);

	const float billeNorm[SIZE_BILLE*SIZE_BILLE] = { 	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.249586776859504,	0.249586776859504,	0.0613514827418568,	0.0613514827418568,	0.143704423918327,	0.143704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,										
													0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.249586776859504,	0.249586776859504,	0.0613514827418568,	0.0613514827418568,	0.143704423918327,	0.143704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,
													0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.182920110192837,	0.182920110192837,	-0.397472046669908,	-0.397472046669908,	-0.440609301571869,	-0.440609301571869,	-0.401393615297359,	-0.401393615297359,	-0.424923027062065,	-0.424923027062065,	-0.389628909415006,	-0.389628909415006,	-0.224923027062065,	-0.224923027062065,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,
													0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.182920110192837,	0.182920110192837,	-0.397472046669908,	-0.397472046669908,	-0.440609301571869,	-0.440609301571869,	-0.401393615297359,	-0.401393615297359,	-0.424923027062065,	-0.424923027062065,	-0.389628909415006,	-0.389628909415006,	-0.224923027062065,	-0.224923027062065,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,
													0.343704423918327,	0.343704423918327,	0.171155404310484,	0.171155404310484,	-0.444530870199320,	-0.444530870199320,	-0.487668125101281,	-0.487668125101281,	-0.464138713336575,	-0.464138713336575,	-0.397472046669908,	-0.397472046669908,	-0.440609301571869,	-0.440609301571869,	-0.0680602819640256,	-0.0680602819640256,	-0.432766164316967,	-0.432766164316967,	-0.326883811375790,	-0.326883811375790,	0.343704423918327,	0.343704423918327,
													0.343704423918327,	0.343704423918327,	0.171155404310484,	0.171155404310484,	-0.444530870199320,	-0.444530870199320,	-0.487668125101281,	-0.487668125101281,	-0.464138713336575,	-0.464138713336575,	-0.397472046669908,	-0.397472046669908,	-0.440609301571869,	-0.440609301571869,	-0.0680602819640256,	-0.0680602819640256,	-0.432766164316967,	-0.432766164316967,	-0.326883811375790,	-0.326883811375790,	0.343704423918327,	0.343704423918327,
													0.343704423918327,	0.343704423918327,	-0.299432830983633,	-0.299432830983633,	-0.385707340787555,	-0.385707340787555,	-0.322962242748339,	-0.322962242748339,	-0.138648517258143,	-0.138648517258143,	-0.126883811375790,	-0.126883811375790,	-0.268060281964026,	-0.268060281964026,	-0.319040674120888,	-0.319040674120888,	-0.417079889807163,	-0.417079889807163,	-0.471981850591477,	-0.471981850591477,	-0.0445308701993197,	-0.0445308701993197,
													0.343704423918327,	0.343704423918327,	-0.299432830983633,	-0.299432830983633,	-0.385707340787555,	-0.385707340787555,	-0.322962242748339,	-0.322962242748339,	-0.138648517258143,	-0.138648517258143,	-0.126883811375790,	-0.126883811375790,	-0.268060281964026,	-0.268060281964026,	-0.319040674120888,	-0.319040674120888,	-0.417079889807163,	-0.417079889807163,	-0.471981850591477,	-0.471981850591477,	-0.0445308701993197,	-0.0445308701993197,
													0.084880894506563,	0.084880894506563,	0.022135796467347,	0.022135796467347,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.0927240317614646,	0.0927240317614646,	0.343704423918327,	0.343704423918327,	0.0417436396046018,	0.0417436396046018,	-0.330805380003241,	-0.330805380003241,	-0.322962242748339,	-0.322962242748339,
													0.084880894506563,	0.084880894506563,	0.022135796467347,	0.022135796467347,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.0927240317614646,	0.0927240317614646,	0.343704423918327,	0.343704423918327,	0.0417436396046018,	0.0417436396046018,	-0.330805380003241,	-0.330805380003241,	-0.322962242748339,	-0.322962242748339,
													-0.173942634905202,	-0.173942634905202,	-0.075903419218928,	-0.075903419218928,	0.222135796467347,	0.222135796467347,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	-0.0915896937287315,	-0.0915896937287315,
													-0.173942634905202,	-0.173942634905202,	-0.075903419218928,	-0.075903419218928,	0.222135796467347,	0.222135796467347,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	-0.0915896937287315,	-0.0915896937287315,
													-0.189628909415006,	-0.189628909415006,	-0.483746556473830,	-0.483746556473830,	-0.393550478042457,	-0.393550478042457,	-0.091589693728732,	-0.091589693728732,	0.343704423918327,	0.343704423918327,	0.284880894506563,	0.284880894506563,	0.163312267055582,	0.163312267055582,	0.343704423918327,	0.343704423918327,	0.159390698428131,	0.159390698428131,	-0.322962242748339,	-0.322962242748339,	-0.279824987846379,	-0.279824987846379,
													-0.189628909415006,	-0.189628909415006,	-0.483746556473830,	-0.483746556473830,	-0.393550478042457,	-0.393550478042457,	-0.091589693728732,	-0.091589693728732,	0.343704423918327,	0.343704423918327,	0.284880894506563,	0.284880894506563,	0.163312267055582,	0.163312267055582,	0.343704423918327,	0.343704423918327,	0.159390698428131,	0.159390698428131,	-0.322962242748339,	-0.322962242748339,	-0.279824987846379,	-0.279824987846379,
													0.014292659212445,	0.014292659212445,	-0.499432830983633,	-0.499432830983633,	-0.468060281964026,	-0.468060281964026,	-0.209236752552261,	-0.209236752552261,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.214292659212445,	0.214292659212445,	0.343704423918327,	0.343704423918327,	-0.122962242748339,	-0.122962242748339,	-0.432766164316967,	-0.432766164316967,	-0.232766164316967,	-0.232766164316967,
													0.014292659212445,	0.014292659212445,	-0.499432830983633,	-0.499432830983633,	-0.468060281964026,	-0.468060281964026,	-0.209236752552261,	-0.209236752552261,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.214292659212445,	0.214292659212445,	0.343704423918327,	0.343704423918327,	-0.122962242748339,	-0.122962242748339,	-0.432766164316967,	-0.432766164316967,	-0.232766164316967,	-0.232766164316967,
													0.343704423918327,	0.343704423918327,	-0.452374007454222,	-0.452374007454222,	-0.464138713336575,	-0.464138713336575,	-0.307275968238535,	-0.307275968238535,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	-0.303354399611084,	-0.303354399611084,	-0.354334791767947,	-0.354334791767947,	0.328018149408523,	0.328018149408523,
													0.343704423918327,	0.343704423918327,	-0.452374007454222,	-0.452374007454222,	-0.464138713336575,	-0.464138713336575,	-0.307275968238535,	-0.307275968238535,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	-0.303354399611084,	-0.303354399611084,	-0.354334791767947,	-0.354334791767947,	0.328018149408523,	0.328018149408523,
													0.343704423918327,	0.343704423918327,	0.124096580781072,	0.124096580781072,	-0.417079889807163,	-0.417079889807163,	-0.417079889807163,	-0.417079889807163,	-0.224923027062065,	-0.224923027062065,	-0.181785772160104,	-0.181785772160104,	0.120175012153621,	0.120175012153621,	-0.338648517258143,	-0.338648517258143,	-0.373942634905202,	-0.373942634905202,	0.0339005023496999,	0.0339005023496999,	0.343704423918327,	0.343704423918327,
													0.343704423918327,	0.343704423918327,	0.124096580781072,	0.124096580781072,	-0.417079889807163,	-0.417079889807163,	-0.417079889807163,	-0.417079889807163,	-0.224923027062065,	-0.224923027062065,	-0.181785772160104,	-0.181785772160104,	0.120175012153621,	0.120175012153621,	-0.338648517258143,	-0.338648517258143,	-0.373942634905202,	-0.373942634905202,	0.0339005023496999,	0.0339005023496999,	0.343704423918327,	0.343704423918327,
													0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.261351482741857,	0.261351482741857,	-0.287668125101281,	-0.287668125101281,	-0.417079889807163,	-0.417079889807163,	-0.358256360395398,	-0.358256360395398,	-0.0680602819640256,	-0.0680602819640256,	-0.213158321179712,	-0.213158321179712,	0.280959325879112,	0.280959325879112,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,
													0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.261351482741857,	0.261351482741857,	-0.287668125101281,	-0.287668125101281,	-0.417079889807163,	-0.417079889807163,	-0.358256360395398,	-0.358256360395398,	-0.0680602819640256,	-0.0680602819640256,	-0.213158321179712,	-0.213158321179712,	0.280959325879112,	0.280959325879112,	0.343704423918327,	0.343704423918327,	0.343704423918327,	0.343704423918327};
					
					
					
};

DummyImageProcessingPlugin::DummyImageProcessingPlugin()
{
	cout << "Hello World!" << endl;
//Insérez votre code ici
}

DummyImageProcessingPlugin::~DummyImageProcessingPlugin()
{
	cout << "Goodbye Cruel World!" << endl;
//Insérez votre code ici
}

void DummyImageProcessingPlugin::OnImage(const boost::shared_array<uint8_t> in_ptrImage, unsigned int in_unWidth, unsigned int in_unHeight,
		double & out_dXPos, double & out_dYPos)
{
//Insérez votre code ici
	out_dXPos = -1.0;
	out_dYPos = -1.0;

	int cropW = 480;
	int cropH = 480;
	int cropX = 0;
	int cropY = 0;
	int padW = NextPowerOfTwo(cropW+SIZE_BILLE-1);
	int padH = NextPowerOfTwo(cropH+SIZE_BILLE-1);

	float* platNormPad = PlateauNormPad(in_ptrImage, in_unWidth , in_unHeight , cropW, cropH, cropX, cropY, padW, padH);
	float* billeNormPad = PadBille(DummyImageProcessingPlugin::billeNorm, padH, padW);
	
	complex<float>** PlateauComplex = new complex<float>* [padH];  	// Creer une matrice de complex pour le plateau
	complex<float>** BilleComplex = new complex<float>* [padH];    // Creer une matrice de complex pour la bille

	// Each real of complex matrix is set to a pixel value and imag = 0
	for(int height = 0; height < padH; height++)
	{
	    PlateauComplex[height] = new complex<float>[padW];		
		BilleComplex[height] = new complex<float>[padW];		
		for(int width = 0; width < padW; width++)
		{
			PlateauComplex[height][width].real(platNormPad[width+height*padH]);
			PlateauComplex[height][width].imag(0.0);		  
			BilleComplex[height][width].real(billeNormPad[width+height*padH]);
			BilleComplex[height][width].imag(0.0);	
		}
	}

	if( FFT2D(PlateauComplex,padW,padH,-1) ) //Forward FFT 
   {
		cout << "FFT Plateau sucessful" << endl;
		cout<<PlateauComplex[0][0].real()  << " " << PlateauComplex[0][0].imag() << "j" << endl;
		cout<< PlateauComplex[0][1].real()  << " " << PlateauComplex[0][1].imag() << "j" << endl;
		cout<< PlateauComplex[0][2].real()  << " " << PlateauComplex[0][2].imag() << "j" << endl;
   }
	else
	{
		cout << "FFT Failed" << endl;
	}

	if( FFT2D(BilleComplex,padW,padH,-1) ) //Forward FFT 
   {
		cout << "FFT Bille sucessful" << endl;
		cout<<BilleComplex[0][0].real()  << " " << BilleComplex[0][0].imag() << "j" << endl;
		cout<< BilleComplex[0][1].real()  << " " << BilleComplex[0][1].imag() << "j" << endl;
		cout<< BilleComplex[0][2].real()  << " " << BilleComplex[0][2].imag() << "j" << endl;
   }
	else
	{
		cout << "FFT Failed" << endl;
	}
	// Convolution 
	convolution(PlateauComplex, BilleComplex, padW,padH);	
	if ( FFT2D(PlateauComplex, padW,padH,1) )// Reverse FFT
	{
		cout << "Correlation succesful" << endl;
	}
	else
	{
		cout << "Correlation Failed!!!" << endl;		
	}

   // Seuil
	int PositionX,PositionY;   
    PositionBille(PlateauComplex,padW,padH, 25, &PositionX,&PositionY);

	cout << "PositionX : " << PositionX << endl;
	cout << "PositionY: " << PositionY << endl;

	delete platNormPad;
	delete billeNormPad;
}

void DummyImageProcessingPlugin::OnBallPosition(double in_dXPos, double in_dYPos, double & out_dXDiff, double & out_dYDiff)
{
	//insérez votre code ici
	out_dXDiff = 0.0;
	out_dYDiff = 0.0;

}

float* DummyImageProcessingPlugin::PlateauNormPad(const boost::shared_array<uint8_t> in_ptrImage, unsigned int inWidth, unsigned int inHeight, unsigned int cropWidth, unsigned int cropHeight, unsigned int cropX, unsigned int cropY, unsigned int outWidth,unsigned int outHeight)
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
		int newColumn = 0;
		for(int oldColumn = 0; oldColumn < cropWidth*3; oldColumn += 3)
		{
			plateauPad[newColumn + outWidth*height] = (float)(in_ptrImage[oldColumn + inWidth*3*height]) / 255.0;
			newColumn++;
		}
	}
	
	return plateauPad;
}


// Padding de la bille normalisée
float* DummyImageProcessingPlugin::PadBille(const float* billeNorm, unsigned int outHeight, unsigned int outWidth)
{
	float* billeNormPad = new float[outHeight*outWidth]();
	
	
	for(int height = 0; height < SIZE_BILLE; height++)
	{
		for(int width = 0; width < SIZE_BILLE; width++)
		{
			billeNormPad[width + outWidth*height] = billeNorm[width + SIZE_BILLE*height];
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
	void DummyImageProcessingPlugin::convolution(complex<float>** fft1, complex<float>** fft2, int sizeX, int sizeY)
	{
       
		for (int i = 0; i < sizeX; i++)
		{
			for(int j = 0; j < sizeY; j++)
			{
				fft1[i][j].real( fft1[i][j].real() * fft2[i][j].real() );
				fft1[i][j].imag( fft1[i][j].imag() * fft2[i][j].imag() );
			}
		}
	}
	
	// Retourne la position de la bille dans le tableau de la corrélation
	void DummyImageProcessingPlugin::PositionBille(complex<float>** correlation, int tailleX, int tailleY, float seuil, int* outPosX, int* outPosY)
	{
		int posX_max = -1;
		int posY_max = -1;
		float val_max = 0.0;
	
		// Trouve la valeur maximale de la corrélation
		for(int height = 0; height < tailleY; height++)
		{
			for(int width = 0; width < tailleX; width++)
			{
				if(abs(correlation[height][width]) > val_max)
				{
					val_max = abs(correlation[height][width]);
					posX_max = width;
					posY_max = height;
				}
			}
		}
	
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
