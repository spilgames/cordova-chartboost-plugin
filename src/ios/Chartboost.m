#import <Cordova/CDV.h>

#import <Chartboost/Chartboost.h>
#import <Chartboost/CBNewsfeed.h>
#import <CommonCrypto/CommonDigest.h>
#import <AdSupport/AdSupport.h>

@interface ChartboostPlugin : CDVPlugin <ChartboostDelegate, CBNewsfeedDelegate>{
	NSMutableArray* _queue;
}

-(void) init:(CDVInvokedUrlCommand*)command;
-(void) showInterstitial:(CDVInvokedUrlCommand*)command;

@end

@implementation ChartboostPlugin

-(void) init:(CDVInvokedUrlCommand*)command {
	NSString* appId = [command.arguments objectAtIndex:0];
	NSString* appSignature = [command.arguments objectAtIndex:1];
	NSString* callbackId = command.callbackId;
	
	if(_queue == nil){
		_queue = [NSMutableArray array];    
	}
	
	[_queue addObject: callbackId];
	[Chartboost startWithAppId:appId
				appSignature:appSignature
				delegate:self];
	
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
	[self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];

	[Chartboost cacheInterstitial:CBLocationDefault];
}

-(void) showInterstitial:(CDVInvokedUrlCommand*)command {
	NSString* location = [command.arguments objectAtIndex:0];
	NSString* callbackId = command.callbackId;
	
	[_queue addObject: callbackId];
	[Chartboost showInterstitial:location];
}

-(BOOL) shouldRequestInterstitialsInFirstSession {
	return NO;
}

// Called before requesting an interstitial via the Chartboost API server.
-(BOOL) shouldRequestInterstitial:(CBLocation)location{
	return YES; 
}

// Called before an interstitial will be displayed on the screen.
-(BOOL) shouldDisplayInterstitial:(CBLocation)location{
	return YES;
}

// Called after an interstitial has been displayed on the screen.
-(void) didDisplayInterstitial:(CBLocation)location{
	if(_queue != nil && _queue.count > 0){
		NSString* callbackId = _queue[0];
		[_queue removeObjectAtIndex:0];
		
		CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
		[self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
	}
}

// Called after an interstitial has been loaded from the Chartboost API
// servers and cached locally.
-(void) didCacheInterstitial:(CBLocation)location{
	if(_queue != nil && _queue.count > 0){
		NSString* callbackId = _queue[0];
		[_queue removeObjectAtIndex:0];
		
		CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
		[self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
	}
}

// Called after an interstitial has attempted to load from the Chartboost API
// servers but failed.
-(void) didFailToLoadInterstitial:(CBLocation)location
						 withError:(CBLoadError)error{
	if(_queue != nil && _queue.count > 0){
		NSString* callbackId = _queue[0];
		[_queue removeObjectAtIndex:0];
		
		CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Error loading the interstitial"];
		[self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
	}
}

@end