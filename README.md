# Cocoa Menulet App Base for OS X 10.8+ 

![Overview of Menulet](https://raw.github.com/scalabl3/PubNub-Cocoa-Menulet/master/screenshots/menulet-overview.png "Menulet Overview")

### Base XCode Workspace and Projects

Use this base to build your own Menulet based apps that use PubNub! 

One Workspace, Two Projects: 

* Objective-C

* Swift

### Brief Instructions

1. Clone the Repo

2. Open the **Workspace File** (MenuletApps.xcworkspace) rather than project files
because we use CocoaPods for the PubNub SDK. CocoaPods updates the build info for
workspace files to include Pods (libraries) in the build process.

3. If you decide to remove a Project, make sure to update the Podfile in the root folder.

4. The Swift one obviously won't build in XCode 5, so don't try to build that target without XCode 6 Beta. 
However, the project itself won't interfere with the Objective-C one.

```
+------------------------------------------+
| PubNub-Cocoa-Menulet                     |
+------------------------------------------+
|                                           
+-+ Podfile                                 
|                                           
+-+ Pods/                                   
|                                           
+-+ screenshots/                            
|                                           
+-+ MenuletApps.xcworkspace <<<             
|                                           
+-----+ Menulet/Menulet.xcproject           
|                                           
+-----+ MenuletSwift/MenuletSwift.xcproject 
```

 