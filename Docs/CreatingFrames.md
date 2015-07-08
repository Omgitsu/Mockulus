
# How to create a new `frame`

A Frame is what we call the window dressing around an application.  For example the top bar for an application or the url bar and bookmarks for a browser.  In the past this was called the 'window chrome', but the existence of Google Chrome makes that a bit more confusing than it needs to be. So for our purposes we're calling them **frames**.

Mockups and Frames are comprised of a number of image files and a dictionary entry in the appropriate plist.

Included in the project is a file titled `Frames-Public.plist`.  This demonstrates a fully functional frame with a base, url bar, url, and window title. It is found in the project at:

* Mockulus > Supporting Files > Frames-Public.plist

## Important notes:
* all measurements and coordinates in the plist are in **points** and *not in pixels*.
* keep in mind that an image that is saved at @2x resolution will have a size in points that is **one half** of its size in pixels.
* the origin point (0,0) is the **bottom left** for all images.  x position moves to the right, y position moves to the top.
* do not include @2x suffixes to file names in the plist.  
* don't position anything on an odd pixel or size any images at an odd size.  odd pixels like (13,13) may result in artifacts, blurry images or misplaced or mis-scaled  images.

## Frames plist

If desired, you can duplicate the `Frames-Public.plist` and retitle it `Frames-Private.plist`.  At runtime, the private plist will be used instead of the public one.

The following is an explanation of the fields in `Frames-Public.plist`.

* frame-name // (required) configuration dictionary for the frame.  title it as you see fit.  frames will be displayed in alphabetical order
  * title // (required) the title of the frame as it will appear in the interface,
  * icon_file // (required) the filename for the icon file
  * mask_type (optional) // the type of mask to use.  see below.
  * top_bar_height (required) // the height of the top bar. in **points** see below for how to measure this accurately
  * bottom_bar_height (required) // the height of the bottom bar. in **points**
  * left_border_width (required) // width of the left border. in **points**
  * right_border_width (required) // width of the right border. in **points**
  * minimum_width (required) // the minimum width of the frame. in **points** see below for more information
  * base (required) configuration dictionary for the frame's base image.
    * file (required) the filename for the base image
    * origin (required) configuration dictionary for the frame's base image origin
      * x (required) // x position in **points**. this should be 0
      * y (required) // y position in **points**. this should be 0
  * title_label (optional) configuration dictionary for the frame's title label
    * available (required) whether you want to display the title label or not
    * center (required) whether the title should be centered or left aligned
    * size (required) the font size for the title
    * origin (required) configuration dictionary for the title label
      * x (required) // x position in **points**. this should be 0
      * y (required) // y position in **points**. this should be 0
  * url_label (optional) configuration dictionary for the frame's url label
    * available (required) whether you want to display the url label or not
    * center (required) whether the url should be centered or left aligned
    * size (required) the font size for the title
    * origin (required) configuration dictionary for the url label
      * x (required) // x position in **points**.
      * y (required) // y position in **points**.
  * url_bar (optional) // configuration dictionary for the frame's url bar (the image that will sit behind the url)
    * file (required) the filename for the url bar image
    * origin (required) configuration dictionary for the url bar image origin
      * x (required) // x position in **points**.
      * y (required) // y position in **points**.


#### Measuring top_bar_height
<p align="center" >
  <img src="https://raw.github.com/Omgitsu/mockulus/Docs/assets/top-bar-height-demo.png" alt=“Mockulus Measuring Top Bar Height” title="Mockulus Measuring Top Bar Height">
</p>
Top bar height is measured in points from the top of the base image top the top of the area for the imported image. This number should be the **50%** of the `Top` image slice in Xcode's image asset slicing tool.

#### Measuring bottom_bar_height
Bottom bar height should be measured in points from the bottom of the frame base image to the bottom of the dropped image. This number should **50%** of the `Bottom` image slice in Xcode's image slicing tool.  If there is no bottom bar the height should be 0.

#### Setting minimum_width
Minimum width is the minimum width that you want a frame to be in **points**.  If an image is imported by the user, the frame will not scale to be less than this width.  Instead there will be a visible gutter around the image.

#### mask_type
There is an included window mask titled "Yosemite".  It will mask the dropped image so that the bottom left and bottom right corners are rounded. If you set mask_type to 'Yosemite' this mask will be applied when necessary.  Otherwise there will be no masking of the image.  
### Image guidelines
* it’s recommended that the base image origin be placed at (0,0)
* all images should be created at 2x resolution.  That means that if your devices has a screen image of 640x480 then in the base image the allotted space for the screen should be 1280x960.
* make sure to append @2x to each of the images before adding to the Xcode project.  for example: `base_image@2x.png`.
* you can add your images to `Images-Public.xcassets` located in the *Interface* folder or you can create a new *Asset Catalog* to hold your new image assets.

### Image slicing
For your frame images to properly scale to fit the images a user imports into the application you need to configure image slicing for the frame base image and the url bar image in Xcode.

Refer to Apple's [documentation](https://developer.apple.com/library/ios/recipes/xcode_help-image_catalog-1.0/chapters/SlicinganImage.html) to learn how Xcode image slicing works.

> Xcode image slicing is finicky especially dealing with @2x images.  In general don't slice on an odd number.  Keep all slices divisible by two. Don't create any area that is one pixel wide or one pixel high. And don't freak out when you import an image and it doesn't slice or scale correctly. Just keep tweaking positions and sizes and rebuilding.
