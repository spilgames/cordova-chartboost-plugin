
	var Chartboost = exports;

	var exec = require('cordova/exec');
	var cordova = require('cordova');

	Chartboost.init = function(appId, appSignature) {
		exec(null, null, "ChartboostPlugin", "iniChartboost", [
				appId, appSignature ]);
	}

	Chartboost.showInterstitial = function(sucessCallback, failCallback, location) {
		exec(sucessCallback, failCallback, "ChartboostPlugin", "showInterstitial", [location]);
	}
