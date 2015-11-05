# RealmExplorer
Example **iOS Objective-C Project** to explore basic data manipulation in conjunction with a [Realm](https://github.com/realm/realm-cocoa) database and [FXForms](https://github.com/nicklockwood/FXForms). There is also a post in my [blog](http://www.thetawelle.de/?p=5086) explaining a bit of the background story.

## Features
This iOS app demonstrates **following features** by creating a sample app which should keep track of captains *(DBCaptain)* which own a yacht *(DBYacht)*:

* Setup a DB model of two entities with a relationship *(DBCaptain, DBYacht)*
* Have a model change over time & use migrations (demonstrates a history of changes to start with a tiny model which expands from migration to migration)
* Create/Insert single & bulk entities into Realm DB also on a background thread
* Edit entities in conjunction with & without FXForms (you can set a flag)
* Drive the whol database encrypted/unencrypted by switching a PCH-flag


## Precompiler Flags
You drive the whole app-build via precompiler header flags. So just have a look at the `RealmExplorer_Prefix.pch` and check out the documented PCH-flags you should change. These flags also change which kind of code goes into the build and they allow to adjust the UI of each build according to the current db schema version used.

## Realm Framework
Please download the **Realm.framework** for Objective-C from the website at [https://realm.io/docs/objc/latest/](https://realm.io/docs/objc/latest/) and place the static binary build for Xcode 7 in the `Realm`-folder of the project.

## FXForms
To better get to know the possibilities of [FXForms](https://github.com/nicklockwood/FXForms) please visit the github repo of *Nick Lockwood*. Huge thank you to him for providing this solution. It was perfect to tinkering with this sample. Any help & hints how to get Realm-entities better integrated with the FXForms are welcome.

## Screenshot
![image](https://raw.githubusercontent.com/trailblazr/RealmExplorer/master/realmexplorer.gif)

## Versions

* Version 1.1 (5.11.2015)

## Contact
If you have suggestions how to  **improve** this sample app contact me at  [trailblazr@noxymo.com](mailto:trailblazr@noxymo.com?subject=Feedback%20for%20RealmExplorer%20on%20Github) or via Twitter an [@noxymo](http://twitter.com/@noxymo).

## License
The code is licensed under GPLv3 License.