package com.portnou.cordova.plugin.chartboost;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;

import com.chartboost.sdk.Chartboost;


public class ChartboostPlugin extends CordovaPlugin{
	
	
	private static final String ACTION_INI_CHARBOOST = "init";
	private static final String ACTION_SHOW_INTERSTITIAL = "showInterstitial";
	private static final String ACTION_CACHE_INTERSTITIAL = "cacheInterstitial";
	
	@Override
	public void onDestroy() {
		Chartboost.onDestroy(cordova.getActivity());
		super.onDestroy();
	}
	
	@Override
	public void onResume(boolean multitasking) {
		Chartboost.onResume(cordova.getActivity());
		super.onResume(multitasking);
	}
	
	@Override
	public void onPause(boolean multitasking) {
		Chartboost.onPause(cordova.getActivity());
		super.onPause(multitasking);
	}
	
	
	@Override
	public boolean execute(String action, JSONArray args, CallbackContext callback) throws JSONException{
		
		if (action.equals(ACTION_INI_CHARBOOST)) {
			final String appId = args.getString(0);
			final String appSignature = args.getString(1);
			
			cordova.getActivity().runOnUiThread(new Runnable() {
				@Override
				public void run() {
					Chartboost.startWithAppId(cordova.getActivity(), appId , appSignature);
					Chartboost.onCreate(cordova.getActivity());
					Chartboost.onStart(cordova.getActivity());
				}
			});
			
			return true;
		}else if(action.equals(ACTION_SHOW_INTERSTITIAL)){
			final String location = args.getString(0);
			
			cordova.getActivity().runOnUiThread(new Runnable() {
				@Override
				public void run() {
					Chartboost.showInterstitial(location);
				}
			});
		}else if(action.equals(ACTION_CACHE_INTERSTITIAL)){
			final String location = args.getString(0);
			
			cordova.getActivity().runOnUiThread(new Runnable() {
				@Override
				public void run() {
					Chartboost.cacheInterstitial(location);
				}
			});
		}
		
		return false;
	}
}