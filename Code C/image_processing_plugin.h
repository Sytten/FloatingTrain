/*
 * image_processing_plugin.h
 *
 *  Created on: Oct 23, 2014
 *      Author: chaj1907
 */

#ifndef IMAGE_PROCESSING_PLUGIN_H_
#define IMAGE_PROCESSING_PLUGIN_H_

#include <boost/shared_array.hpp>

/*! \brief Base plugin class for doing image processing on images from the camera.
 *
 *  This is the base class for building plugins for image processing in the **Core application**.
 *  Subclasses of this interface must be built in a dynamic library (.so) and will be loaded by the
 *  PluginLoader class.
 */
class ImageProcessingPlugin
{
public:
	ImageProcessingPlugin() = default;
	virtual ~ImageProcessingPlugin() {};

	ImageProcessingPlugin(const ImageProcessingPlugin & in_Plugin) = delete;
	ImageProcessingPlugin & operator=(const ImageProcessingPlugin & in_Plugin) = delete;

	/*! \brief Receive an image to process.
	 *
	 *  This function will be called every time we need the to send the X,Y position and differentials to
	 *  the **firmware**.
	 *
	 *  \param in_ptrImage Image data.
	 *  \param in_unWidth Image width.
	 *  \param in_unHeight Image height.
	 *  \param out_dXPos X coordinate pixel position of the ball.
	 *  \param out_dYPos Y coordinate pixel position of the ball.
	 *
	 */
	virtual void OnImage(boost::shared_array<uint8_t> in_ptrImage, unsigned int in_unWidth, unsigned int in_unHeight,
			double & out_dXPos, double & out_dYPos) = 0;

	/*! \brief Receive an image to process.
	 *
	 *  This function will be called every time we need the to send the X,Y position and differentials to
	 *  the **firmware**.
	 *
	 *  \param in_dXPos X coordinate position of the ball.
	 *  \param in_dYPos Y coordinate position of the ball.
	 *  \param out_dXDiff X pixel speed of the ball.
	 *  \param out_dYDiff Y pixel speed of the ball.
	 *
	 */
	virtual void OnBallPosition(double in_dXPos, double in_dYPos, double & out_dXDiff, double & out_dYDiff) = 0;
};

#endif /* IMAGE_PROCESSING_PLUGIN_H_ */
