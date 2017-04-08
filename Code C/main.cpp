
#include <stdint.h>
#include "image_processing_plugin.h"
#include "dummy_image_processing_plugin.cpp"

int main()
{
	DummyImageProcessingPlugin iPP() = new DummyImageProcessingPlugin();
		
	double x = 1.0;
	double y = 1.0;

	iPP->OnBallPosition(1.0, 1.0, x, y);

	

	delete iPP;
	return 0;
}



