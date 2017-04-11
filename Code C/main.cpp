/*
 * Code d'exemple pour charger une image de format rgb raw.
 * Exemple:
 *
 * load_image image.rgb
 *
 */

#include <stdint.h>
#include "image_processing_plugin.h"
#include "dummy_image_processing_plugin.cpp"
#include <boost/shared_array.hpp>
#include <cstdlib>
#include <iostream>
#include <fstream>
#include <string>
#include <vector>

using namespace std;

namespace {

	const unsigned int IMAGE_WIDTH = 480;
	const unsigned int IMAGE_HEIGHT = 480;
	const unsigned int IMAGE_SIZE = IMAGE_WIDTH * IMAGE_HEIGHT * 3;
};

int main( int argc, char **argv)
{
	if(argc <= 1)
	{
		cerr << "Erreur: Vous devez specifier une image a charger" << endl;
		return EXIT_FAILURE;
	}

	DummyImageProcessingPlugin* iPP = new DummyImageProcessingPlugin();	

	for(int i = 1; i < argc; i++)
	{
		// Open image file
		ifstream image_file(argv[i], ios::binary);
		if(!image_file)
		{
			cerr << "Erreur: Chemin de l'image invalide" << endl;
			return EXIT_FAILURE;
		}

		// Check file size
		image_file.seekg(0, image_file.end);
		if(image_file.tellg() != IMAGE_SIZE)
		{
			cerr << "Erreur: La taille de l'image specifiee est incorrecte" << endl;
			return EXIT_FAILURE;
		}
		image_file.seekg(0, image_file.beg);


		// Read file
		boost::shared_array<uint8_t> image(new uint8_t[IMAGE_SIZE]);
		image_file.read(reinterpret_cast<char *>(image.get()), IMAGE_SIZE);

		// Votre code ici: l'image est un tableau lineaire de uint8.
		// Chaque pixel contient 3 uint8 soit les composantes: Red, Green, Blue (expliquant le "*3" dans IMAGE_SIZE)
		// Les pixels sont sotckes en mode: row-major order.
		// L'outil convert de imagemagick peut etre interessant pour convertir le format d'image si requis:
		// convert -depth 8 -size 480x480 test.rgb test.png

		
	
		double x = 1.0;
		double y = 1.0;

		double vX;
		double vY;


		iPP->OnImage(image, 480, 480, x, y);
		iPP->OnBallPosition(x,y,vX,vY);
		cout << "Vitesse X : " << vX << "  Y: " << vY << endl;


		
	}

	delete iPP;

	return EXIT_SUCCESS;

}


