function wydgetLoader() {
	localStorage.setItem("zipCode", "32723");
	var _day = new Date();
	var _dateDay = document.getElementsByTagName("dateDay");
	var _dateDayArray = "Sunday|Monday|Tuesday|Wednesday|Thursday|Friday|Saturday".split("|");
	for(var i = 0; i<_dateDay.length; i++){
		_dateDay[i].innerHTML = _dateDayArray[_day.getDay()];
	}
	
	var _dateDate = document.getElementsByTagName("dateDate");
	for(var i = 0; i<_dateDate.length; i++){
		_dateDate[i].innerHTML = _day.getDate();
	}
	
	var _dateMonth = document.getElementsByTagName("dateMonth");
	var _dateMonthArray = "January|February|March|April|May|June|July|August|September|October|November|December".split("|");
	for(var i = 0; i<_dateMonth.length; i++){
		_dateMonth[i].innerHTML = _dateMonthArray[_day.getMonth()];
	}
	
	var _dateMonthNum = document.getElementsByTagName("dateMonthNum");
	for(var i = 0; i<_dateMonthNum.length; i++){
		_dateMonthNum[i].innerHTML = _day.getMonth()+1;
	}
	
	var _dateYear = document.getElementsByTagName("dateYear");
	for(var i = 0; i<_dateYear.length; i++){
		_dateYear[i].innerHTML = _day.getFullYear();
	}
	_updateTime();
}
function _updateTime(){
	var _day = new Date();
	var _timeHour = document.getElementsByTagName("timeHour");
	var _time24Hour = document.getElementsByTagName("time24Hour");
	var _timePaddedHour = document.getElementsByTagName("timePaddedHour");
	var _timePadded24Hour = document.getElementsByTagName("timePadded24Hour");
	var _timeMin = document.getElementsByTagName("timeMin");
	var _timeSec = document.getElementsByTagName("timeSec");
	var _ampm = document.getElementsByTagName("ampm");
	
	for(var i = 0; i<_timeHour.length; i++){
		_timeHour[i].innerHTML = _day.getHours()==0?12:(_day.getHours()>12?(_day.getHours()-12):_day.getHours());
	}
	for(var i = 0; i<_time24Hour.length; i++){
		_time24Hour[i].innerHTML = _day.getHours();
	}
	
	for(var i = 0; i<_timePaddedHour.length; i++){
		_timePaddedHour[i].innerHTML =	_day.getHours()==0?12:(_day.getHours()>=10?(_day.getHours()>12?((_day.getHours()-12)>=10?(_day.getHours()-12):("0"+(_day.getHours()-12))):_day.getHours()):"0"+_day.getHours());
	}
	
	for(var i = 0; i<_timePadded24Hour.length; i++){
		_timePadded24Hour[i].innerHTML =  _day.getHours()>=10?_day.getHours():("0"+_day.getHours());
	}
	
	for(var i = 0; i<_timeMin.length; i++){
		_timeMin[i].innerHTML = (_day.getMinutes()>=10?_day.getMinutes():"0"+_day.getMinutes());
	}
	
	for(var i = 0; i<_timeSec.length; i++){
		_timeSec[i].innerHTML = (_day.getSeconds()>=10?_day.getSeconds():"0"+_day.getSeconds());
	}
	
	for(var i = 0; i<_ampm.length; i++){
		_ampm[i].innerHTML = _day.getHours()<12?"AM":"PM";
	}
	
	if((_timeHour.length + _time24Hour.length + _timePaddedHour.length + _timePadded24Hour.length + _timeMin.length + _timeSec.length + _ampm.length)!=0){
		if(_timeSec.length==0){
			setTimeout(_updateTime,1000*(60-(_day.getSeconds())-1));
		}else{
			setTimeout(_updateTime,1000);
		}
	}
}