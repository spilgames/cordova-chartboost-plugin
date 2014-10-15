Cordova Chartboost plugin v.0.1
=============

This plugin will allow you to run Chartboost on cordova projects. 

Usage
-------

The plugin has the following calls:

	Chartboost.ini(appID,appSignature); 

This will initialize Chartboost. You will find the appID and the appSignature of your app on the Chartboost dashboard once you have create an app in your account

	Chartboost.showInterstitial(success, fail, location);

This will show an Insterstitial Add. The parameters are the success and failure callbacks and the location of the interstitial

