function getCurrentDayStr() {
	var currentDate = new Date();
	var cyear = currentDate.getFullYear();
	var cmonth = currentDate.getMonth() + 1;
	var cday = currentDate.getDate();
	var descStr = outDays(cyear, cmonth, cday);
	return descStr;
}

function outDays(oyear, omonth, oday) {
	var descStr;
	if(omonth < 10) {
		descStr = oyear + "-0" + omonth;
	} else {
		descStr = oyear + "-" + omonth;
	}
	if(oday < 10) {
		descStr = descStr + "-0" + oday;
	} else {
		descStr = descStr + "-" + oday;
	}
	return descStr;
}

function getLastDay(dayStr){
	var dict = getYearMonthDayDictWithStr(dayStr)
	var cyear = dict['year'];
	var cmonth = dict['month'];
	var cday = dict['day'];
	var maxDay = getLastMonthMaxDay(cyear,cmonth);
	cday -= 1
	if (cday < 1) {
		cday = maxDay;
		cmonth -= 1
		if (cmonth < 1) {
			cmonth = 12;
			cyear -= 1;
		}
	}
	return outYearMonthDayStr(cyear,cmonth,cday);
}
function getNextDay(dayStr){
	var dict = getYearMonthDayDictWithStr(dayStr)
	var cyear = dict['year'];
	var cmonth = dict['month'];
	var cday = dict['day'];
	var maxDay = getMonthMaxDay(cyear,cmonth);
	cday += 1
	if (cday > maxDay) {
		cday = 1;
		cmonth += 1
		if (cmonth > 12) {
			cmonth = 1;
			cyear += 1;
		}
	}
	return outYearMonthDayStr(cyear,cmonth,cday);
}

function getFullWeek(startStr) {
	var weekArr = [];
	var oneDay = startStr;
	for (var i = 0; i < 7;i++) {
		var weekIndex = getWeekIndex(oneDay)
		var week = getChinaWeekIndexStr(weekIndex);
		var dict = {'day':oneDay,'week':week};
		weekArr.push(dict);
		oneDay = getNextDay(oneDay);
	}
	return weekArr;
}

function getWeekStartEndDate(dayStr){
	var arr = dayStr.split("-");
	var cyear = parseInt(arr[0]);
	var cmonth = parseInt(arr[1]);
	var cday = parseInt(arr[2]);
	var startDate = '',endDate='';
	var weekDay = getWeekIndex(dayStr);
	var maxDay = getMonthMaxDay(cyear,cmonth);
	
	if (weekDay == 0) {
		endDate = dayStr;
		var sday = cday - 6
		if (sday < 1) {
			cmonth -= 1;
			if (cmonth < 0) {
				cmonth = 12;
				cyear -= 1;
			}
			maxDay = getMonthMaxDay(cyear,cmonth);
			sday += maxDay;
		}
		startDate = outDays(cyear,cmonth,sday);
		return [startDate,endDate];
	}
	var syear = cyear;
	var smonth = cmonth;
	var sday = cday;
	var sday = cday - weekDay + 1;
	cday = cday + 7 - weekDay;
	if(cday > maxDay) {
		cmonth += 1;
		cday = cday - maxDay;
		if(cmonth == 13) {
			cyear += 1;
			cmonth = 1;
		}
	}
	if(sday < 1) {
		maxDay = getLastMonthMaxDay(cyear,cmonth)
		sday = maxDay + sday;
		smonth -= 1;
		if(smonth == 0) {
			syear -= 1;
			smonth = 12;
		}
	}
	
	startDate = outDays(syear, smonth, sday);
	endDate = outDays(cyear, cmonth, cday);
	return [startDate,endDate];
}

function getChinaWeekIndexStr(weekIndex){
	var arr = ['周日','周一','周二','周三','周四','周五','周六'];
	return arr[weekIndex]
}


function getWeekIndex(dayStr) {
	var arr = dayStr.split("-");
	var year = parseInt(arr[0]);
	var month = parseInt(arr[1]) - 1;
	var day = parseInt(arr[2]);
	var originDate = new Date(year, month, day);
	return originDate.getDay()
}
function getYearMonthDictWithStr(dayStr){
	var arr = dayStr.split("-");
	var year = parseInt(arr[0]);
	var month = parseInt(arr[1]);
	return {'year':year,'month':month};
}
function getYearMonthDayDictWithStr(dayStr){
	var arr = dayStr.split("-");
	var year = parseInt(arr[0]);
	var month = parseInt(arr[1]);
	var day = parseInt(arr[2]);
	return {'year':year,'month':month,'day':day};
}
function getLastYearMonthDict(year, month){
	if(month == 1) {
		month = 12;
		year -= 1;
	} else {
		month -= 1;
	}
	return {'year':year,'month':month};
}
function getNextYearMonthDict(year, month){
	if(month == 12) {
		month = 1;
		year += 1;
	} else {
		month += 1;
	}
	return {'year':year,'month':month};
}

function getLastMonthMaxDay(year, month) {
	if(month == 1) {
		month = 12;
		year -= 1;
	} else {
		month -= 1;
	}
	var maxDay = getMonthMaxDay(year, month);
	return maxDay;
}

function getMonthMaxDay(year, month) {
	var maxDay = 31;
	if(month == 2) {
		maxDay = 28;
		if(year % 400 == 0 || (year % 100 != 0 && year % 4 == 0)) {
			maxDay = 29;
		}
	} else if(month == 4 || month == 6 || month == 9 || month == 11) {
		maxDay = 30;
	}
	return maxDay;
}


function outYearMonthStr(year, month) {
	var monthStr = month + '';
	if (month < 10) {
		monthStr = '0'+month;
	}
	return year + '-'+monthStr;	
}
function outYearMonthDayStr(year, month,day) {
	var monthStr = month + '';
	if (month < 10) {
		monthStr = '0'+month;
	}
	var dayStr = day + '';
	if (day < 10) {
		dayStr = '0'+day;
	}
	return year + '-'+monthStr+'-'+dayStr;
}

function outChinaYearMonthStr(year, month) {
	var monthStr = month + '';
	if (month < 10) {
		monthStr = '0'+month;
	}
	return year + '年'+monthStr+'月';
}

function outChinaMonthDayStr(month,day) {
	var monthStr = month + '';
	if (month < 10) {
		monthStr = '0'+month;
	}
	var dayStr = day + '';
	if (day < 10) {
		dayStr = '0'+day;
	}
	return monthStr+'月'+dayStr+'日';
}
