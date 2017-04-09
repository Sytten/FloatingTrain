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

using namespace std;

namespace {

	const unsigned int IMAGE_WIDTH = 480;
	const unsigned int IMAGE_HEIGHT = 480;
	const unsigned int IMAGE_SIZE = IMAGE_WIDTH * IMAGE_HEIGHT * 3;
};

int main( int argc, char **argv)
{
	// Open image file
	ifstream image_file_1("image_718.rgb", ios::binary);
	ifstream image_file_2("image_751.rgb", ios::binary);
	ifstream image_file_3("image_785.rgb", ios::binary);
	ifstream image_file_4("image_818.rgb", ios::binary);
	ifstream image_file_5("image_852.rgb", ios::binary);
	ifstream image_file_6("image_884.rgb", ios::binary);

	// Read file
	boost::shared_array<uint8_t> image_1(new uint8_t[IMAGE_SIZE]);
	image_file_1.read(reinterpret_cast<char *>(image_1.get()), IMAGE_SIZE);
	
	boost::shared_array<uint8_t> image_2(new uint8_t[IMAGE_SIZE]);
	image_file_2.read(reinterpret_cast<char *>(image_2.get()), IMAGE_SIZE);
	
	boost::shared_array<uint8_t> image_3(new uint8_t[IMAGE_SIZE]);
	image_file_3.read(reinterpret_cast<char *>(image_3.get()), IMAGE_SIZE);
	
	boost::shared_array<uint8_t> image_4(new uint8_t[IMAGE_SIZE]);
	image_file_4.read(reinterpret_cast<char *>(image_4.get()), IMAGE_SIZE);
	
	boost::shared_array<uint8_t> image_5(new uint8_t[IMAGE_SIZE]);
	image_file_5.read(reinterpret_cast<char *>(image_5.get()), IMAGE_SIZE);
	
	boost::shared_array<uint8_t> image_6(new uint8_t[IMAGE_SIZE]);
	image_file_6.read(reinterpret_cast<char *>(image_6.get()), IMAGE_SIZE);

	// Votre code ici: l'image est un tableau lineaire de uint8.
	// Chaque pixel contient 3 uint8 soit les composantes: Red, Green, Blue (expliquant le "*3" dans IMAGE_SIZE)
	// Les pixels sont sotckes en mode: row-major order.
	// L'outil convert de imagemagick peut etre interessant pour convertir le format d'image si requis:
	// convert -depth 8 -size 480x480 test.rgb test.png

	DummyImageProcessingPlugin* iPP = new DummyImageProcessingPlugin();
		
	double x = 1.0;
	double y = 1.0;

	iPP->OnImage(image_1, 480, 480, x, y);
	iPP->OnImage(image_2, 480, 480, x, y);
	iPP->OnImage(image_3, 480, 480, x, y);
	iPP->OnImage(image_4, 480, 480, x, y);
	iPP->OnImage(image_5, 480, 480, x, y);
	iPP->OnImage(image_6, 480, 480, x, y);

	delete iPP;

	return EXIT_SUCCESS;

}


