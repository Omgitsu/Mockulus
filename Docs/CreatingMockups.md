
# How to create a new `mockup`

Mockups and Frames are comprised of a number of image files and a dictionary entry in the appropriate plist.

Included in the project is a file titled `Mockups-Public.plist`.  This demonstrates a fully functional mockup with a base, alternate bases, glare, status bar, branding/logo, and shadows for portrait and landscape mode. It is found in the project at:

* Mockulus >  Supporting Files > Mockups-Public.plist

## Important notes:
* all measurements and coordinates in the plist are in **points** and *not in pixels*.
* keep in mind that an image that is saved at @2x resolution will have a size in points that is **one half** of its size in pixels.
* the origin point (0,0) is the **bottom left** for all images.  x position moves to the right, y position moves to the top.
* do not include @2x suffixes to file names in the plist.
* don't position anything on an odd pixel or at an odd size.  odd pixels like (13,13) may result in artifacts, blurry images or misplaced or mis-scaled  images.
* no negative numbers!


## Mockups plist

If desired, you can duplicate the `Mockups-Public.plist` and retitle it `Mockups-Private.plist`.  At runtime the private plist will be used instead of the public one.

The following is an explanation of the fields in `Mockups-Public.plist`.  

* mockup-name // (required) configuration dictionary for the mockup.  title it as you see fit.  mockups will be displayed in alphabetical order
  * title // (required) the title of the mockup as it will appear in the interface,
  * icon_file // (required) the filename for the icon file
  * bottom_gutter // (optional - defaults to 0) distance from the base image to the actual mockup - see below for more info
  * allows_landscape // (optional - defaults to NO) whether the mockup can be rotated 90 degrees counter-clockwise
  * screen // (required) configuration dictionary for the screen
    * origin // (required) configuration dictionary for the screen origin
      * x // (required) x position in **points**
      * y // (required) y position in **points**
    * size // (required) configuration dictionary for the screen size
      * width // (required) width of the screen **points**
      * height // (required) height of the screen **points**
  * base // (required) configuration dictionary for the base image
    * file // (required) the filename for the base mockup image
    * origin // (required) configuration dictionary for the base origin
      * x // (required) x position in **points**
      * y // (required) y position in **points**
    * default_base // (optional) if you have alternate base images, this is the name of the alternate image that you want to default to
    * alternates // (optional) dictionary of alternate base images in name:filename pairs
  * glare (optional) configuration dictionary for the base image
    * file // (required) the filename for the glare image
    * origin // (required) configuration dictionary for the glare origin
      * x // (required) x position in **points**
      * y // (required) y position in **points**
  * shadow (optional) configuration dictionary for the shadow image
    * file // (required) the filename for the shadow image
    * landscape_file // (optional) the filename for the landscape shadow image. see note below
    * origin // (required) configuration dictionary for the shadow origin
      * x // (required) x position in **points**
      * y // (required) y position in **points**
  * statusbar (optional) configuration dictionary for the statusbar image
    * file // (required) the filename for the statusbar image
    * origin // (required) configuration dictionary for the statusbar origin
      * x // (required) x position in **points**
      * y // (required) y position in **points**
  * logo (optional) configuration dictionary for the logo/branding image
    * file // (required) the filename for the logo/branding image
    * origin // (required) configuration dictionary for the logo/branding origin
      * x // (required) x position in **points**
      * y // (required) y position in **points**

### Image guidelines
* it’s recommended that the base image origin be placed at (0,0).
* it’s recommended that the shadow image origin be placed at (0,0).
* all images should be created at 2x resolution.  That means that if your devices has a screen resolution of 640x480 then in the base image the allotted space for the screen should be 1280x960.
* make sure to append @2x to each of the images before adding to the Xcode project.  for example: `base_image@2x.png`.
* you can add your images to `Images-Public.xcassets` located in the *Interface* folder or you can create a new *Asset Catalog* to hold your new image assets.

The only images that are required for a mockup to fully function are the base image and the icon image.  All other images are optional.  The application will only display controls for images that are included in the plist. Even if you have imported an image into the project, it will need to be represented in the plist.

### Sizing guidelines

Below is an image that illustrates the proper sizing and positioning of the screen image.  In this example, the actual size of the device’s screen is 640x1136. Since the base image is *two times* the resolution, if you were to measure the pixels in an image editor it would show that the screen size is 1280x2272.  Accordingly, the proper origin for the screen is counted in points from the bottom left origin point (0,0) resulting in a position in points of (270,320).  If you were to measure in an image editor it would result in (540,640) - which is the incorrect placement.

<p align="center" >
  <img src="https://raw.github.com/Omgitsu/mockulus/Docs/assets/phone-measurements.png" alt=“Mockulus Phone Measurements” title="Mockulus Phone Measurements">
</p>


### Notes on shadows

When creating your base image for mockups take into account the height of the shadow.  Don't place the mockup's base at the very bottom of the base image.  Give enough space for the shadow.  Refer to how the images are set up in the project.

If you have to make space for a bottom shadow that is 100 pixels high, don't put the shadow at 0,-100.  Instead put the shadow at 0,0 and move the other images up by 100 pixels.  Images at negative positions won't display or save correctly.

<p align="center" >
  <img src="https://raw.github.com/Omgitsu/mockulus/Docs/assets/shadow-guideline.png" alt=“Mockulus Shadow Measurements” title="Mockulus Shadow Measurements">
</p>

Because of the way that the base image is rotated negative 90 degrees, the landscape shadow file origin will be at the top left of the base image.  
