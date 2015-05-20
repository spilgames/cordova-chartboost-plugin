Cordova Chartboost plugin v 0.4
=============

This plugin will allow you to run Chartboost on cordova projects.
Source code of this plugin is forked from SpilGames's plugin (https://github.com/spilgames/cordova-chartboost-plugin)

Usage
-------

The plugin has the following calls:
```JavaScript
	Chartboost.init(appID,appSignature); 
```
This will initialize Chartboost. You will find the appID and the appSignature of your app on the Chartboost dashboard once you have create an app in your account
```JavaScript
	Chartboost.cacheInterstitial(success, fail, location);
```
This will cache an Insterstitial Ad. The parameters are the success and failure callbacks and the location of the interstitial.
```JavaScript
	Chartboost.showInterstitial(success, fail, location);
```
This will show an Insterstitial Ad. The parameters are the success and failure callbacks and the location of the interstitial.

For iOS applications also available calls for MoreApps screen and Video Ads:

```JavaScript
	Chartboost.showMoreGames(success, fail, location);
	Chartboost.cacheMoreGames(success, fail, location);
	Chartboost.showRewardedVideo(success, fail, location);
	Chartboost.cacheRewardedVideo(success, fail, location);
    Chartboost.hasRewardedVideo(success, fail, location);
```


The project still need a lot of work. Right now there are the basic calls to make it work and get interstitials from Chartboost.

INSTALLATION
-------------

	cordova plugin add https://github.com/alexportnoy/cordova-chartboost-plugin


SUPPORTED PLATFORMS
-------------------

- Android
- iOS

TODO
------

- Video Ads calls implementation for Android
- MoreApps calls implementation for Android

CHANGELOG
---------

v0.4 (by danmorton)
- Callbacks implementation on Android
- Support for didDissmiss callback on iOS/Android
- Bugfixes

v0.3:
First version of forked plugin:
- New versions of Chartboost SDKs
- Call to cache interstitials
- Call to cache/show MoreApps screen (iOS)
- Call to cache/show video ads (iOS)
- Implementation of callbacks system (iOS)

v0.2:
In original plugin repo:
- Support for iOS platform

v0.1:
First version of the plugin:
- Call to initialize Chartboost with the appId and the appSignature
- Call to show interestitials 


