# MostActivePosts


This sample project is a simple Reddit client that shows the top
entries from https://www.reddit.com/top

## Technical guidelines:
* Xcode 10.2
* Swift 5.0
* iPhone 6/6+/X screen size with support of landscape and portrait
* 1st party frameworks only

## Description:
The app is able to show data from each entry such as:
* Title (at its full length, so take this into account when sizing your cells)
* Author
* Entry date, following a format like “X hours ago”
* A thumbnail for those who have a picture
* Number of comments

In addition, for those having a picture (besides the thumbnail), the app
allows the user to tap on the thumbnail to be sent to the full sized
picture. If user tap on it the picture will be saved into the picture gallery

The app was built with pagination support. Whenever user scrolls up the app 
displays new entries

Also the app has state-preservation/restoration using the power of CoreData

