#import <Cordova/CDV.h>

#import <Chartboost/Chartboost.h>
#import <Chartboost/CBNewsfeed.h>
#import <CommonCrypto/CommonDigest.h>
#import <AdSupport/AdSupport.h>

@interface ChartboostPlugin : CDVPlugin <ChartboostDelegate, CBNewsfeedDelegate>{
//	NSMutableArray* _queue;
    NSMutableDictionary* _queue;
}

-(void) init:(CDVInvokedUrlCommand*)command;
-(void) showInterstitial:(CDVInvokedUrlCommand*)command;

@end

@implementation ChartboostPlugin

-(void) init:(CDVInvokedUrlCommand*)command {
	NSString* appId = [command.arguments objectAtIndex:0];
	NSString* appSignature = [command.arguments objectAtIndex:1];
	NSString* callbackId = command.callbackId;
	
//	if(_queue == nil){
//		_queue = [NSMutableArray array];    
//	}
    // initialization has no delegate method, so just init callback queue
    if(_queue == nil) {
        _queue = [[NSMutableDictionary alloc] init];
    }

    [Chartboost startWithAppId:appId
				appSignature:appSignature
				delegate:self];
	
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
	[self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];

	[Chartboost cacheInterstitial:CBLocationDefault];
}

#pragma mark -
#pragma mark Chartboost interstitials

-(void) showInterstitial:(CDVInvokedUrlCommand*)command {
	NSString* location = [command.arguments objectAtIndex:0];
	NSString* callbackId = command.callbackId;
    NSString* callbackKey = [NSString stringWithFormat:@"showInterstitial:%@", location];
	
//	[_queue addObject: callbackId];
    [_queue setObject: callbackId forKey:callbackKey];
	[Chartboost showInterstitial:location];
}

-(void) setDidDismissInterstitialCallback:(CDVInvokedUrlCommand*)command {
	NSString* location = [command.arguments objectAtIndex:0];
	NSString* callbackId = command.callbackId;
    	NSString* callbackKey = [NSString stringWithFormat:@"setDidDismissInterstitialCallback:%@", location];
	[_queue setObject: callbackId forKey:callbackKey];
}

-(void) cacheInterstitial:(CDVInvokedUrlCommand*)command {
    NSString* location = [command.arguments objectAtIndex:0];
    NSString* callbackId = command.callbackId;
    NSString* callbackKey = [NSString stringWithFormat:@"cacheInterstitial:%@", location];

//    [_queue addObject: callbackId];
    [_queue setObject: callbackId forKey:callbackKey];
    [Chartboost cacheInterstitial:location];
}

#pragma mark -
#pragma mark Chartboost MoreGames

-(void) showMoreGames:(CDVInvokedUrlCommand*)command {
    NSString* location = [command.arguments objectAtIndex:0];
    NSString* callbackId = command.callbackId;
    NSString* callbackKey = [NSString stringWithFormat:@"showMoreGames:%@", location];

    [_queue setObject: callbackId forKey:callbackKey];
    [Chartboost showMoreApps:location];
}

-(void) cacheMoreGames:(CDVInvokedUrlCommand*)command {
    NSString* location = [command.arguments objectAtIndex:0];
    NSString* callbackId = command.callbackId;
    NSString* callbackKey = [NSString stringWithFormat:@"cacheMoreGames:%@", location];

    [_queue setObject: callbackId forKey:callbackKey];
    [Chartboost cacheMoreApps:location];
}

#pragma mark -
#pragma mark Chartboost rewarded video

-(void) showRewardedVideo:(CDVInvokedUrlCommand*)command {
    NSString* location = [command.arguments objectAtIndex:0];
    NSString* callbackId = command.callbackId;
    NSString* callbackKey = [NSString stringWithFormat:@"showRewardedVideo:%@", location];

    [_queue setObject: callbackId forKey:callbackKey];
    [Chartboost showRewardedVideo:location];
}

-(void) cacheRewardedVideo:(CDVInvokedUrlCommand*)command {
    NSString* location = [command.arguments objectAtIndex:0];
    NSString* callbackId = command.callbackId;
    NSString* callbackKey = [NSString stringWithFormat:@"cacheRewardedVideo:%@", location];

    [_queue setObject: callbackId forKey:callbackKey];
    [Chartboost cacheRewardedVideo:location];
}

-(void) hasRewardedVideo:(CDVInvokedUrlCommand*)command {
    NSString* location = [command.arguments objectAtIndex:0];
    NSString* callbackId = command.callbackId;

    BOOL hasRewardedVideo = [Chartboost hasRewardedVideo:location];

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:hasRewardedVideo];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];

}

#pragma mark -
#pragma mark ChartboostDelegate

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

//called after intersittial is dismissed
- (void)didDismissInterstitial:(CBLocation)location {
    NSString* callbackKey = [NSString stringWithFormat:@"setDidDismissInterstitialCallback:%@", location];
    if(_queue != nil && [_queue objectForKey:callbackKey] != nil){
	NSString* callbackId = [_queue objectForKey:callbackKey];
	[_queue removeObjectForKey:callbackKey];
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
	[self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
     }
}

// Called after an interstitial has been displayed on the screen.
-(void) didDisplayInterstitial:(CBLocation)location{
    NSString* callbackKey = [NSString stringWithFormat:@"showInterstitial:%@", location];
    if(_queue != nil && [_queue objectForKey:callbackKey] != nil){
		NSString* callbackId = [_queue objectForKey:callbackKey];
		[_queue removeObjectForKey:callbackKey];
		
		CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
		[self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
	}
}

// Called after an interstitial has been loaded from the Chartboost API
// servers and cached locally.
-(void) didCacheInterstitial:(CBLocation)location{
    NSString* callbackKey = [NSString stringWithFormat:@"cacheInterstitial:%@", location];
    if(_queue != nil && [_queue objectForKey:callbackKey] != nil){
        NSString* callbackId = [_queue objectForKey:callbackKey];
        [_queue removeObjectForKey:callbackKey];

		CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
		[self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
	}
}

// Called after an interstitial has attempted to load from the Chartboost API
// servers but failed.
-(void) didFailToLoadInterstitial:(CBLocation)location
						 withError:(CBLoadError)error{
    NSString* callbackKey = [NSString stringWithFormat:@"cacheInterstitial:%@", location];
    if(_queue != nil && [_queue objectForKey:callbackKey] != nil){
        NSString* callbackId = [_queue objectForKey:callbackKey];
        [_queue removeObjectForKey:callbackKey];

        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Error loading the interstitial"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
    }
    callbackKey = [NSString stringWithFormat:@"showInterstitial:%@", location];
    if(_queue != nil && [_queue objectForKey:callbackKey] != nil){
        NSString* callbackId = [_queue objectForKey:callbackKey];
        [_queue removeObjectForKey:callbackKey];

        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Error loading the interstitial"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
    }
}

// Called before a MoreApps page will be displayed on the screen.
- (BOOL)shouldDisplayMoreApps:(CBLocation)location {
    return YES;
}

// Called after a MoreApps page has been loaded from the Chartboost API
// servers and cached locally.
- (void)didCacheMoreApps:(CBLocation)location {
    NSString* callbackKey = [NSString stringWithFormat:@"cacheMoreGames:%@", location];
    if(_queue != nil && [_queue objectForKey:callbackKey] != nil){
        NSString* callbackId = [_queue objectForKey:callbackKey];
        [_queue removeObjectForKey:callbackKey];

        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
    }
}

// Called after a MoreApps page attempted to load from the Chartboost API
// servers but failed.
- (void)didFailToLoadMoreApps:(CBLocation)location
                    withError:(CBLoadError)error {
    NSString* callbackKey = [NSString stringWithFormat:@"cacheMoreGames:%@", location];
    if(_queue != nil && [_queue objectForKey:callbackKey] != nil){
        NSString* callbackId = [_queue objectForKey:callbackKey];
        [_queue removeObjectForKey:callbackKey];

        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Error loading MoreGames"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
    }
    callbackKey = [NSString stringWithFormat:@"showMoreGames:%@", location];
    if(_queue != nil && [_queue objectForKey:callbackKey] != nil){
        NSString* callbackId = [_queue objectForKey:callbackKey];
        [_queue removeObjectForKey:callbackKey];

        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Error loading MoreGames"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
    }
}

// Called before a rewarded video will be displayed on the screen.
- (BOOL)shouldDisplayRewardedVideo:(CBLocation)location {
    return YES;
}

// Called after a rewarded video has been loaded from the Chartboost API
// servers and cached locally.
- (void)didCacheRewardedVideo:(CBLocation)location {
    NSString* callbackKey = [NSString stringWithFormat:@"cacheRewardedVideo:%@", location];
    if(_queue != nil && [_queue objectForKey:callbackKey] != nil){
        NSString* callbackId = [_queue objectForKey:callbackKey];
        [_queue removeObjectForKey:callbackKey];

        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
    }
}

// Called after a rewarded video has attempted to load from the Chartboost API
// servers but failed.
- (void)didFailToLoadRewardedVideo:(CBLocation)location
                         withError:(CBLoadError)error {
    NSString* callbackKey = [NSString stringWithFormat:@"cacheRewardedVideo:%@", location];
    if(_queue != nil && [_queue objectForKey:callbackKey] != nil){
        NSString* callbackId = [_queue objectForKey:callbackKey];
        [_queue removeObjectForKey:callbackKey];

        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Error loading video"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
    }
    callbackKey = [NSString stringWithFormat:@"showRewardedVideo:%@", location];
    if(_queue != nil && [_queue objectForKey:callbackKey] != nil){
        NSString* callbackId = [_queue objectForKey:callbackKey];
        [_queue removeObjectForKey:callbackKey];

        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Error loading video"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
    }
}

// Called after a rewarded video has been viewed completely and user is eligible for reward.
- (void)didCompleteRewardedVideo:(CBLocation)location
                      withReward:(int)reward {
    NSString* callbackKey = [NSString stringWithFormat:@"showRewardedVideo:%@", location];
    if(_queue != nil && [_queue objectForKey:callbackKey] != nil){
        NSString* callbackId = [_queue objectForKey:callbackKey];
        [_queue removeObjectForKey:callbackKey];

        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Video has been completely viewed"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
    }
}


@end
