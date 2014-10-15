
	var Chartboost = exports;

	var exec = require('cordova/exec');
	var cordova = require('cordova');

	Chartboost.init = function(sucessCallback, failCallback, appId,appSignature) {
		exec(sucessCallback, failCallback, "ChartboostPlugin", "iniChartboost", [
				appId, appSignature ]);
	}

	Chartboost.showInterstitial = function(sucessCallback, failCallback, location) {
		exec(sucessCallback, failCallback, "ChartboostPlugin", "showInterstitial", [location]);
	}
