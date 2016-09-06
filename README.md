# 500pxBicycle
Cruise through 500px on iOS

## What is it?
500pxBicycle is a simple app that lets you browse 500px's most popular photos

## Setup
Note: if you're a Udacity reviewer, this setup isn't necessary; I included my key in the submitted zip file. Just build the project after opening the workspace file.

0. Get a consumer key from 500px (account required)
1. Clone this repository and open the workspace file in Xcode
2. Add a Swift file named <code>DeveloperParameters.swift</code> to the project
3. In this file, create a <code>struct</code> named <code>DeveloperParameters</code> with property <code>static let consumerKey = "your 500px consumer key here"</code>

## Usage
Open the app, and browse through the thumbnails. If you tap on a thumbnail, you'll be able to see a high resolution version of that image. You can also pinch to zoom and swipe to pan through the image.

Each time a high resolution image is viewed, it's saved to disk. To view the saved images, go to the History tab and tap on the title of the image.

Images can be deleted when you view them individually by tapping the Delete button.

## Future features and to-do list
###Viewing images
Image views should properly snap to the edges of the screen without sudden, jarring animations

The user should be able to swipe left or right while viewing an image to view a different one

The UI should completely disappear when user taps screen, as is commonly expected in iOS apps

The user should be able to zoom when double-tapping screen, as expected in iOS apps

More information about the photo should be shown when the UI is visible, like username, location, date, tags
###API features
The user should be able to buy photos if they are available for purchase through 500px

Should be able to sort photos with more criteria available to user, including search functionality

The user should be allowed to log in... This means implementing OAuth which I had a lot of trouble with

###Frameworks
Should implement RealmGridController and load images into memory to improve performance of UICollectionView
