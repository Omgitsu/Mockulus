
<p align="center" >
  <img src="https://github.com/Omgitsu/Mockulus/blob/master/Assets/moculus_logo.png?raw=true" alt=“Mockulus” title=“Mockulus”>
  <img src="https://github.com/Omgitsu/Mockulus/blob/master/Docs/assets/mockulus-demo-image.png?raw=true" alt=“Mockulus” title=“Mockulus”>
</p>

##### Mockulus is a program for OS X 10.10 and above that allows you to visualize your designs in mockups of devices and browsers.

> Refer to the [application homepage for mockul.us](http://mockul.us) for more info (and snazzy screenshots).

# How To Get Started

## Step 1: Download CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries in your projects.  

CocoaPods is distributed as a ruby gem, and is installed by running the following commands in Terminal.app:

    $ sudo gem install cocoapods
    $ pod setup

> Depending on your Ruby installation, you may not have to run as `sudo` to install the cocoapods gem.

## Step 2: Install Dependencies

Mockulus is dependent on [PureLayout](https://github.com/smileyborg/PureLayout). Once cocoapods is installed and up to date you can install the dependencies for the project:

    $ pod install

From now on, be sure to always open the generated Xcode workspace (`Mockulus.xcworkspace `) instead of the project file when building your project:

    $ open Mockulus.xcworkspace

## Step 3: Get Working

The open source version of Mockul.us is the same as the one for sale with one major difference - we only include a starter mockup and a starter frame.  It’s up to you to create the ones that you want.

## Requirements

| Mockulus Version |  Minimum OS X Target  |                                   Notes                                   |
|:--------------------:|:---------------------------:|:----------------------------:|:-------------------------------------------------------------------------:|
|          1.x         |           OS X 10.10          | Xcode 5 is required.|

(OS X projects must support [64-bit with modern Cocoa runtime](https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtVersionsPlatforms.html)).


## Next Steps

* [Guide to creating a Mockup](https://github.com/Omgitsu/Mockulus/blob/master/Docs/CreatingFrames.md)
* [Guide to creating a Frame](https://github.com/Omgitsu/Mockulus/blob/master/Docs/CreatingMockups.md)

## Communication

- If you **found a bug**, _and can provide steps to reliably reproduce it_, open an issue.
- If you **have a feature request**, open an issue, or better yet implement it yourself :)
- If you **want to contribute**, submit a pull request.

## Quick FAQ
* Can I get the mockup and frame files you use in the app?
  * nope.
* Can I get any mockup or frame images from you?
  * sorry, no.
* Okay then, Where can I find mockups or frames to use?
  * [Pixeden](http://www.pixeden.com/) is a great resource
  * [GraphicBurger](http://www.graphicburger.com) is good as well
  * [Here are a Bunch](http://www.tinydesignr.com/2014/03/free-iphone-mockup-psd.html)
  * [Google is your friend](https://www.google.com/search?q=smartphone+mockups)

## License

Mockulus is released under the MIT license. See LICENSE for details.
