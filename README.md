# Cocoa Menulet App Base for OS X 10.8+ 

![Overview of Menulet](https://raw.github.com/scalabl3/PubNub-Cocoa-Menulet/master/screenshots/menulet-overview.png "Menulet Overview")

### Base XCode Workspace and Projects

Use this base to build your own Menulet based apps that use PubNub! 
There are two projects, one for Objective-C and one for the new Swift language by Apple.
They are aptly named Menulet and MenuletSwift. 
However, remember to open the Workspace file (xcworkspace) rather than xcproject files because CocoaPods is used for PubNub libraries.
The PubNub library is in the Podfile.
If you remove a Project, make sure to update the Podfile in the root folder.
The Swift one obviously won't build in XCode 5, so don't try to build that target without XCode 6 Beta.

