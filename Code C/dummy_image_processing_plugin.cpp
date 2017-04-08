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
}

void DummyImageProcessingPlugin::OnBallPosition(double in_dXPos, double in_dYPos, double & out_dXDiff, double & out_dYDiff)
{
	//insérez votre code ici
	out_dXDiff = 0.0;
	out_dYDiff = 0.0;
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
