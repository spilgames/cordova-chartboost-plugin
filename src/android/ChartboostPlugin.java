package com.portnou.cordova.plugin.chartboost;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import com.chartboost.sdk.CBLocation;
import com.chartboost.sdk.Chartboost;
import com.chartboost.sdk.ChartboostDelegate;
import com.chartboost.sdk.InPlay.CBInPlay;
import com.chartboost.sdk.Libraries.CBLogging.Level;
import com.chartboost.sdk.Model.CBError.CBClickError;
import com.chartboost.sdk.Model.CBError.CBImpressionError;
import com.chartboost.sdk.Tracking.CBAnalytics;


public class ChartboostPlugin extends CordovaPlugin{
	//tags for identifying Cordova Calls.
	private static final String ACTION_INI_CHARBOOST = "init";
	private static final String ACTION_SHOW_INTERSTITIAL = "showInterstitial";
	private static final String ACTION_CACHE_INTERSTITIAL = "cacheInterstitial";
	private static final String ACTION_SHOW_MOREGAMES = "showMoreGames";
	private static final String ACTION_CACHE_MOREGAMES = "cacheMoreGames";
	private static final String ACTION_SHOW_REWARDVIDEO = "showRewardedVideo";
	private static final String ACTION_CACHE_REWARDVIDEO = "cacheRewardedVideo";
	private static final String ACTION_HAS_REWARDVIDEO = "hasRewardedVideo";
	private static final String ACTION_SET_DISMISSCALLBACK = "setDidDismissInterstitialCallback";
	private ChartboostPlugin me;
	private static final String TAG = "ChartboostPlugin";


	@Override
	public boolean execute(String action, JSONArray args, CallbackContext callback) throws JSONException {
//		android.util.Log.i(TAG, "execute called: " + action + ", args: " + args.toString());
		me = this;
		final CallbackContext _callback = callback;
		if (action.equals(ACTION_INI_CHARBOOST)) {
			final String app_id = args.getString(0);
			final String app_sig = args.getString(1);
			cordova.getActivity().runOnUiThread(new Runnable() {
				@Override
				public void run() {
					me.chartboost_init(app_id, app_sig);
				}
			});			
			return true;
		} else if (action.equals(ACTION_SHOW_INTERSTITIAL)){
			final String location = args.getString(0);
			cordova.getActivity().runOnUiThread(new Runnable() {
				@Override
				public void run() {
					me.showInterstitial(location, _callback);
				}
			});
		} else if (action.equals(ACTION_CACHE_INTERSTITIAL)){
			final String location = args.getString(0);			
			cordova.getActivity().runOnUiThread(new Runnable() {
				@Override
				public void run() {
					me.preloadInterstitial(location, _callback);
				}
			});
		} else if (action.equals(ACTION_SHOW_MOREGAMES)){
			final String location = args.getString(0);
			cordova.getActivity().runOnUiThread(new Runnable() {
				@Override
				public void run() {
					me.showMoreApps(location, _callback);
				}
			});
		} else if (action.equals(ACTION_CACHE_MOREGAMES)){
			final String location = args.getString(0);			
			cordova.getActivity().runOnUiThread(new Runnable() {
				@Override
				public void run() {
					me.preloadMoreApps(location, _callback);
				}
			});
		} else if (action.equals(ACTION_SHOW_REWARDVIDEO)){
			final String location = args.getString(0);
			cordova.getActivity().runOnUiThread(new Runnable() {
				@Override
				public void run() {
					me.showRewardedVideo(location, _callback);
				}
			});
		} else if (action.equals(ACTION_CACHE_REWARDVIDEO)){
			final String location = args.getString(0);			
			cordova.getActivity().runOnUiThread(new Runnable() {
				@Override
				public void run() {
					me.preloadRewardedVideo(location, _callback);
				}
			});
		} else if (action.equals(ACTION_HAS_REWARDVIDEO)){
			final String location = args.getString(0);
			cordova.getActivity().runOnUiThread(new Runnable() {
				@Override
				public void run() {
					me.hasRewardedVideo(location, _callback);
				}
			});
		} else if (action.equals(ACTION_SET_DISMISSCALLBACK)){
			final String location = args.getString(0);			
			cordova.getActivity().runOnUiThread(new Runnable() {
				@Override
				public void run() {
					me.setDidDismissInterstitialCallback(location, _callback);
				}
			});
		}
		
		return false;
	}
	
	/**
	 * Some functions required for state change...
	 */
//	@Override
//	public void onStart() {
//		super.onStart();
//		Chartboost.onStart( cordova.getActivity() );
//	}
	
	@Override
	public void onStop() {
		super.onStop();
		Chartboost.onStop( cordova.getActivity() );
	}
	
	@Override
	public void onPause(boolean multitasking) {
		super.onPause(multitasking);
		Chartboost.onPause( cordova.getActivity() );
	}
	
	@Override
	public void onResume(boolean multitasking) {
		super.onResume(multitasking);
		Chartboost.onResume( cordova.getActivity() );
	}

//	@Override
//	public void onBackPressed() {
//	     // If an interstitial is on screen, close it. Otherwise continue as normal.
//        if (Chartboost.onBackPressed())
//            return;
//        else
//            super.onBackPressed();
//	}
	
	@Override
	public void onDestroy() {
		// TODO Auto-generated method stub
		super.onDestroy();
		Chartboost.onDestroy( cordova.getActivity() );
	}

	/** 
	 * Functions for setting up Chartboost and handling Callbacks...
	 */
	/** 
	 * Register callback to call later...
	 */	
	private HashMap<String, CallbackContext> callbackMap;
	public void registerCallback(CallbackContext callback, java.lang.String location, java.lang.String funcId) {
		if (null == callbackMap) callbackMap = new HashMap<String, CallbackContext>();
		java.lang.String callbackKey = location + ":" + funcId;
		callbackMap.put(callbackKey, callback);
	}
	/** 
	 * Register callback to call later...
	 */	
	public void doSuccessCallback(java.lang.String location, java.lang.String funcId) {
		if (null == callbackMap) callbackMap = new HashMap<String, CallbackContext>();
		java.lang.String callbackKey = location + ":" + funcId;
		CallbackContext callContext = callbackMap.get(callbackKey);
		if (callContext != null) {
			callbackMap.remove(callbackKey);//remove our callback from queue
			callContext.success("{\"location\": \""+location+"\",\"function\": \""+funcId+"\"}");
		}
	}
	/** 
	 * Register callback to call later...
	 */	
	public void doFailureCallback(java.lang.String location, java.lang.String funcId) {
		if (null == callbackMap) callbackMap = new HashMap<String, CallbackContext>();
		java.lang.String callbackKey = location + ":" + funcId;
		CallbackContext callContext = callbackMap.get(callbackKey);
		if (callContext != null) {
			callbackMap.remove(callbackKey);//remove our callback from queue
			callContext.error("{\"location\": \""+location+"\",\"function\": \""+funcId+"\"}");
		}
	}		

	public void chartboost_init(java.lang.String app_id, java.lang.String app_sig) {
		Chartboost.onStart( cordova.getActivity() );//init cb session as onstart override isn't working..
		Chartboost.startWithAppId(cordova.getActivity(), app_id, app_sig);
		Chartboost.setDelegate( delegate );
		Chartboost.onCreate( cordova.getActivity() );
	}

	public void showInterstitial(java.lang.String location, CallbackContext callback) {
		this.registerCallback(callback, location, ACTION_SHOW_INTERSTITIAL);
		Chartboost.showInterstitial( location );
	}

	public void showMoreApps(java.lang.String location, CallbackContext callback) {
		this.registerCallback(callback, location, ACTION_SHOW_MOREGAMES);	
		Chartboost.showMoreApps( location );
	}

	public void preloadInterstitial(java.lang.String location, CallbackContext callback) {
		this.registerCallback(callback, location, ACTION_CACHE_INTERSTITIAL);
		Chartboost.cacheInterstitial( location );
	}

	public void preloadMoreApps(java.lang.String location, CallbackContext callback) {
		this.registerCallback(callback, location, ACTION_CACHE_MOREGAMES);	
		Chartboost.cacheMoreApps( location );
	}

	public void showRewardedVideo(java.lang.String location, CallbackContext callback) {
		this.registerCallback(callback, location, ACTION_SHOW_REWARDVIDEO);		
		Chartboost.showRewardedVideo( location ); 
	}

	public void preloadRewardedVideo(java.lang.String location, CallbackContext callback) {
		this.registerCallback(callback, location, ACTION_CACHE_REWARDVIDEO);		
		Chartboost.cacheRewardedVideo( location );
	}

	public void hasRewardedVideo(java.lang.String location, CallbackContext callback) {
		this.registerCallback(callback, location, ACTION_HAS_REWARDVIDEO);
		if (Chartboost.hasRewardedVideo( location )) {
			this.doSuccessCallback(location, ACTION_HAS_REWARDVIDEO);
		} else {
			this.doFailureCallback(location, ACTION_HAS_REWARDVIDEO);
		}
	}
	public void setDidDismissInterstitialCallback(java.lang.String location, CallbackContext callback) {
		this.registerCallback(callback, location, ACTION_SET_DISMISSCALLBACK);
		//this is handled in the delegate...
	}
	
    /**
     * Chartboost Delegate
     */
	private ChartboostDelegate delegate = new ChartboostDelegate() {

		@Override
		public boolean shouldRequestInterstitial(String location) {	
			return true;
		}
	
		@Override
		public boolean shouldDisplayInterstitial(String location) {
			return true;
		}
	
		@Override
		public void didCacheInterstitial(String location) {
			me.doSuccessCallback(location, ACTION_CACHE_INTERSTITIAL);
		}
	
		@Override
		public void didFailToLoadInterstitial(String location, CBImpressionError error) {
			android.util.Log.e(TAG, error.toString());
			me.doFailureCallback(location, ACTION_CACHE_INTERSTITIAL);
			me.doFailureCallback(location, ACTION_SHOW_INTERSTITIAL);
		}
	
		@Override
		public void didDismissInterstitial(String location) {
			//attempt to callback to JS...
			me.doSuccessCallback(location, ACTION_SET_DISMISSCALLBACK);
		}

		@Override
		public void didCloseInterstitial(String location) { }
		@Override
		public void didClickInterstitial(String location) { }
	
		@Override
		public void didDisplayInterstitial(String location) {
			me.doSuccessCallback(location, ACTION_SHOW_INTERSTITIAL);
		}
	
		@Override
		public boolean shouldRequestMoreApps(String location) {
			return true;
		}
	
		@Override
		public boolean shouldDisplayMoreApps(String location) {
			return true;
		}
	
		@Override
		public void didFailToLoadMoreApps(String location, CBImpressionError error) {
			me.doFailureCallback(location, ACTION_SHOW_MOREGAMES);
			me.doFailureCallback(location, ACTION_CACHE_MOREGAMES);
		}
	
		@Override
		public void didCacheMoreApps(String location) {
			me.doSuccessCallback(location, ACTION_CACHE_MOREGAMES);
		}
	
		@Override
		public void didDismissMoreApps(String location) {
			me.doSuccessCallback(location, ACTION_SET_DISMISSCALLBACK);
		}

		@Override
		public void didCloseMoreApps(String location) { }
		@Override
		public void didClickMoreApps(String location) { }
	
		@Override
		public void didDisplayMoreApps(String location) {
			me.doSuccessCallback(location, ACTION_SHOW_MOREGAMES);
		}
	
		@Override
		public void didFailToRecordClick(String uri, CBClickError error) { }
	
		@Override
		public boolean shouldDisplayRewardedVideo(String location) {			
			return true;
		}
	
		@Override
		public void didCacheRewardedVideo(String location) {
			me.doSuccessCallback(location, ACTION_CACHE_REWARDVIDEO);
		}
	
		@Override
		public void didFailToLoadRewardedVideo(String location, CBImpressionError error) {
			me.doFailureCallback(location, ACTION_SHOW_REWARDVIDEO);
			me.doFailureCallback(location, ACTION_CACHE_REWARDVIDEO);
		}
	
		@Override
		public void didDismissRewardedVideo(String location) {
			me.doSuccessCallback(location, ACTION_SET_DISMISSCALLBACK);
		}
		@Override
		public void didCloseRewardedVideo(String location) { }
		@Override
		public void didClickRewardedVideo(String location) { }
		@Override
		public void didCompleteRewardedVideo(String location, int reward) { }
		
		@Override
		public void didDisplayRewardedVideo(String location) {
			me.doSuccessCallback(location, ACTION_SHOW_REWARDVIDEO);
		}
		@Override
		public void willDisplayVideo(String location) { }
		
	};
	
// 	@SuppressLint("ClickableViewAccessibility")
// 	public void onInPlayButtonClick(View view) {
// 		String toastStr = "Loading InPlay";
// 		Log.i(TAG, toastStr);
// 		Toast.makeText(this, toastStr,
// 				Toast.LENGTH_SHORT).show();
// 		
// 		final CBInPlay inPlay  = CBInPlay.getInPlay(CBLocation.LOCATION_GAMEOVER);
// 		
// 		if(inPlay != null) {
// 			ImageView myview = (ImageView) findViewById(R.id.inplayView);
// 			myview.setImageBitmap(inPlay.getAppIcon());
// 			inPlay.show();
// 			myview.setOnTouchListener(new View.OnTouchListener() {
// 			
// 				@Override
// 				public boolean onTouch(View v, MotionEvent event) {
// 					inPlay.click();
// 					return false;
// 				}
// 			});
// 		}
// 	}
// 	
// 	public void onPreloadInPlayButtonClick(View view) {
// 		String toastStr = "Preloading InPlay";
// 		Log.i(TAG, toastStr);
// 		CBInPlay.cacheInPlay(CBLocation.LOCATION_GAMEOVER);
// 	}
}