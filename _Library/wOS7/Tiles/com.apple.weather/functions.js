var EnableGreeting = false;

var enableWallpaper = true;

var isCelsius = true;

var useRealFeel = false;

var enableWallpaper = true;

var enableLockScreen = false;

var stylesheetWall = 'split_wim66mod';

var stylesheetLock = 'split';

var iconSetWall = 'spils';

var iconExtWall = ".png";

var iconSetLock = 'mau';

var iconExtLock = '.png';

var source = 'yahooWeather';

var updateInterval = 25;

var postal;

var demoMode = false;

var enabled;

if (location.href.indexOf("LockBackground")  == -1){

	stylesheet = stylesheetWall;

	iconSet = iconSetWall;

	iconExt = iconExtWall;

	enabled = enableWallpaper;

}else{

	stylesheet = stylesheetLock;

	iconSet = iconSetLock;

	iconExt = iconExtLock;

	enabled = enableLockScreen;

}

if(enabled == true){

if(iconSet == null || iconSet == 'null' || iconSet == ""){

	var iconSet = stylesheet;

}

	var headID = document.getElementsByTagName("head")[0];

	var styleNode = document.createElement('link');

	styleNode.type = 'text/css';

	styleNode.rel = 'stylesheet';

	styleNode.href = 'Stylesheets/'+stylesheet+'.css';

	headID.appendChild(styleNode);

	var scriptNode = document.createElement('script');

	scriptNode.type = 'text/javascript';

	scriptNode.src = 'Sources/'+source+'.js';

	headID.appendChild(scriptNode);

}

function onLoad(){

	if (enabled == true){

	if (demoMode == true){

		document.getElementById("weatherIcon").src="Icon Sets/"+iconSet+"/"+"cloudy1"+iconExt;

		document.getElementById("city").innerText="Somewhere";

		document.getElementById("desc").innerText="Partly Cloudy";

		document.getElementById("temp").innerText="100º";



	}else{

	validateWeatherLocation(escape(locale).replace(/^%u/g, "%"), setPostal);

	}

	}else{

	}

}

function convertTemp(num)

{

	if (isCelsius == true)

		return Math.round ((num - 32) * 5 / 9);

	else

		return num;

}

function setPostal(obj){



	if (obj.error == false){

		if(obj.cities.length > 0){

			postal = escape(obj.cities[0].zip).replace(/^%u/g, "%");

			weatherRefresherTemp();

		}else{

		}

	}else{

		setTimeout('validateWeatherLocation(escape(locale).replace(/^%u/g, "%"), setPostal)', Math.round(1000*60*5));

	}

}

function dealWithWeather(obj){

	if (obj.error == false){



		if(useRealFeel == true){

			tempValue = convertTemp(obj.realFeel);

		}else{

			tempValue = convertTemp(obj.temp);

		}

				var Conditions = ["thunderstorm","rain","rain","thunderstorm","thunderstorm","rain","rain","snow","snow","rain","snow","rain","rain","snow","snow","snow","snow","snow","snow","fog","fog","fog","fog","cloud","cloud","cloud","cloud","cloud","cloud","cloud","cloud","sun","sun","moon","sun","rain","sun","thunderstorm","thunderstorm","thunderstorm","thunderstorm","snow","snow","snow","cloud","thunderstorm","snow","thunderstorm","blank"];

		document.getElementById("animationFrame").src="Animations/"+Conditions[obj.icon]+".html";



	}else{

				document.getElementById("WeatherContainer").className = "errorWeatherDataFetch";

	}





}

function weatherRefresherTemp(){

	fetchWeatherData(dealWithWeather,postal);

	setTimeout(weatherRefresherTemp, 60*1000*updateInterval);

}

function constructError (string)

{

	return {error:true, errorString:string};

}

function findChild (element, nodeName)

{

	var child;



	for (child = element.firstChild; child != null; child = child.nextSibling)

	{

		if (child.nodeName == nodeName)

			return child;

	}



	return null;

}

function fetchWeatherData (callback, zip)

{

	url="http://weather.yahooapis.com/forecastrss?u=f&p=";



	var xml_request = new XMLHttpRequest();

	xml_request.onload = function(e) {xml_loaded(e, xml_request, callback);}

	xml_request.overrideMimeType("text/xml");

	xml_request.open("GET", url+zip);

	xml_request.setRequestHeader("Cache-Control", "no-cache");

	xml_request.send(null);



	return xml_request;

}

function xml_loaded (event, request, callback)

{

	if (request.responseXML)

	{

		var obj = {error:false, errorString:null};

		var effectiveRoot = findChild(findChild(request.responseXML, "rss"), "channel");

		obj.city = findChild(effectiveRoot, "yweather:location").getAttribute("city");

		obj.realFeel = findChild(effectiveRoot, "yweather:wind").getAttribute("chill");



		conditionTag = findChild(findChild(effectiveRoot, "item"), "yweather:condition");

		obj.temp = conditionTag.getAttribute("temp");

		obj.icon = conditionTag.getAttribute("code");

		obj.description = conditionTag.getAttribute("text");

		callback (obj);

	}else{

		callback ({error:true, errorString:"XML request failed. no responseXML"});

	}

}

function validateWeatherLocation (location, callback)

{

	var obj = {error:false, errorString:null, cities: new Array};

	obj.cities[0] = {zip: location};

	callback (obj);

}