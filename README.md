# 500pxBicycle
Cruise through 500px on iOS

## What is it?
500pxBicycle is a simple app that lets you browse 500px's most popular photos

## Setup
Note: The API key included in the DeveloperParameters.swift file is not valid. You must create your own.

0. Get a consumer key from 500px (account required)
1. Clone this repository and open the workspace file in Xcode
2. Navigate to <code>DeveloperParameters.swift</code>
3. In this file, edit the <code>struct</code> named <code>DeveloperParameters</code> and set the <code>consumerKey</code> property to your API key.

## Usage
Open the app, and browse through the thumbnails. If you tap on a thumbnail, you'll be able to see a high resolution version of that image. You can also pinch to zoom and swipe to pan through the image. Tap on the drop down bar at the top to switch featured photo categories like Editor's Choice, Upcoming and Highest Rated. To get a new set of photos, drag the grid of photos down in the Featured tab to activate the refresh.

Each time a high resolution image is viewed, it's saved to disk. To view the saved images, go to the History tab and tap on the title of the image.

Images can be deleted when you view them individually by tapping the Delete button, or by swiping them to the left in the History tab and tapping Delete.

500px can contain (tasteful) nude photos and this app will request to exclude Nude and Uncategorized categories if Allow NSFW mode is off. Allow NSFW mode is off by default. To activate Allow NSFW mode, tap the restricted button at the top right of the Featured tab. Allow NSFW mode is on if the button is red, and off if the button is gray. This feature doesn't always work in the end, since users don't always categorize their photos as Nude or turn on the NSFW tag.

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

##Acknowledgements
UI icons from Icons8, App icon from illustrio

