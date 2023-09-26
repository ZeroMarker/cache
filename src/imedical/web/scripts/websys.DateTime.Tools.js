// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

//for generic date calculations.
//this is not for date validation, components that require date validation should use functions from component's scripts_gen
//all datestrings are pressumed to be valid dates

var TK_dtsepartor="/"; try {TK_dtsepartor=dtseparator} catch(err) {};
var TK_dtformat="DMY"; try {TK_dtformat=dtformat} catch(err) {};
var TK_tmseparator=":"; try {TK_tmseparator=tmseparator} catch(err) {};
if (TK_dtformat=="DMMMY") TK_dtsepartor=" ";

//Cache date of 1 = 1/1/1841; increments by one for each day
//Javascript date of 1 = 1/1/1970,0:00:00:001 increment by one for each millisecond
//Cache date of 47117 = 1/1/1970
var msperday = 86400000; //milliseconds in one day
var cachetojs=47117;

//if (format=="THAI") objDate.setYear(objDate.getFullYear()+543);

//returns an array
function DateStringToArray(datestr) {
 	var arrDateComponents = new Array(3);
	//arrDateComponents["yr"]="",arrDateComponents["mn"]="",arrDateComponents["dy"]="";
	//if (datestr=="") return arrDateComponents;
	if ((TK_dtformat=="HIJRA")&&(datestr.indexOf(' [')!=-1)) datestr=datestr.slice(0,datestr.indexOf(' ['));
	if ((TK_dtformat=="THAI")&&(datestr.indexOf(' [')!=-1)) datestr=datestr.slice(0,datestr.indexOf(' ['));
	var arrDate = datestr.split(TK_dtsepartor);
 	switch (TK_dtformat) {
  		case "YMD":
   			arrDateComponents["yr"] = parseInt(arrDate[0],10);
   			arrDateComponents["mn"] = parseInt(arrDate[1],10);
   			arrDateComponents["dy"] = parseInt(arrDate[2],10);
   			break;
  		case "MDY":
   			arrDateComponents["yr"] = parseInt(arrDate[2],10);
   			arrDateComponents["mn"] = parseInt(arrDate[0],10);
   			arrDateComponents["dy"] = parseInt(arrDate[1],10);
   			break;
		case "DMMMY":
   			arrDateComponents["yr"] = parseInt(arrDate[2],10);
   			arrDateComponents["mn"] = arrDate[1];
			if (arrDateComponents["mn"]) arrDateComponents["mn"]=arrDateComponents["mn"].toUpperCase();
   			arrDateComponents["dy"] = parseInt(arrDate[0],10);
			//convert month in words to number
			var arrTMONTHSSHORT=session['XMONTHSSHORT'].toUpperCase().split(",");
			for (i in arrTMONTHSSHORT) { if (arrDateComponents["mn"]==arrTMONTHSSHORT[i]) {arrDateComponents["mn"]=1+parseInt(i,10); break;}}
   			break;
		case "HIJRA": //fall through
  		case "THAI": //fall through
  		default: //treat as DMY
   			arrDateComponents["yr"] = parseInt(arrDate[2],10);
   			arrDateComponents["mn"] = parseInt(arrDate[1],10);
   			arrDateComponents["dy"] = parseInt(arrDate[0],10);
   			break;
 	}
	return arrDateComponents;
}
function DateStringToday() {
	var objToday = new Date();
	var yr=objToday.getFullYear();
	if (TK_dtformat=="THAI") yr+=543;
	return ReWriteDate(objToday.getDate(),objToday.getMonth()+1,yr);
}

//returns a javascript date object
// this returns obj in GMT time - ???should it be using UTC time instead???
function DateStringToDateObj(datestr) {
	var arrDateComponents = DateStringToArray(datestr);
	var objDate = new Date(arrDateComponents["yr"],arrDateComponents["mn"]-1,arrDateComponents["dy"],0,0,0);
	return objDate;
}

//returns a javascript date object (with time)
// this returns obj in GMT time - ???should it be using UTC time instead???
function DateTimeStringToDateObj(datestr,timestr) {
	var arrDateComponents = DateStringToArray(datestr);
	var arrTimeComponents = TimeStringToArray(timestr);
	var objDate = new Date(arrDateComponents["yr"],arrDateComponents["mn"]-1,arrDateComponents["dy"],arrTimeComponents["hr"],arrTimeComponents["mn"],0);
	return objDate;
}

//takes 2 date strings and compares which is the greater
//returns 0 if the dates are equal.
//returns -1 if date1 is earlier than date2
//returns 1 if date1 is after date2
function DateStringCompare(datestr1,datestr2) {
	
	var objDate1 = DateStringToDateObj(datestr1);
	var objDate2 = DateStringToDateObj(datestr2);
	
	if (objDate1.getTime() < objDate2.getTime()) return -1;
	if (objDate1.getTime() == objDate2.getTime()) return 0;
	if (objDate1.getTime() > objDate2.getTime()) return 1;
}

//takes a date string and compares it to today
//returns 0 if the date is today.
//returns -1 if date is earlier than today
//returns 1 if date is after today
function DateStringCompareToday(datestr) {
	var objDate = DateStringToDateObj(datestr);
	var objToday = new Date();
	objToday.setHours(0);objToday.setMinutes(0);objToday.setSeconds(0);objToday.setMilliseconds(0); //reset gmt hrs
	if (TK_dtformat=="THAI") objToday.setYear(objToday.getFullYear()+543);
	if (objDate.getTime() < objToday.getTime()) return -1;
	if (objDate.getTime() == objToday.getTime()) return 0;
	if (objDate.getTime() > objToday.getTime()) return 1;
}

//takes a date string and compares it to a cache date
//returns 0 if the date string is equal to the cache date.
//returns -1 if date string is earlier than the cache date
//returns 1 if date string is after the cache date
function DateStringAndCacheCompare(datestr,cachedate) {
	var objDate = DateStringToDateObj(datestr);
	var msCacheDate = (cachedate-cachetojs)*msperday;
	var objCacheDate = new Date(msCacheDate);
	objCacheDate.setHours(0);objCacheDate.setMinutes(0);objCacheDate.setSeconds(0);objCacheDate.setMilliseconds(0); //reset gmt hrs
	if (objDate.getTime() < objCacheDate.getTime()) return -1;
	if (objDate.getTime() == objCacheDate.getTime()) return 0;
	if (objDate.getTime() > objCacheDate.getTime()) return 1;
}

//takes 2 date and time strings and compares which is the greater
//returns 0 if the they are equal.
//returns -1 if datestr1&timestr1 is earlier than datestr2&timestr2
//returns 1 if datestr1&timestr1 is after datestr2&timestr2
function DateTimeStringCompare(datestr1,timestr1,datestr2,timestr2) {
	//get Date objects
	var objDate1 = DateTimeStringToDateObj(datestr1,timestr1);
	var objDate2 = DateTimeStringToDateObj(datestr2,timestr2);

	if (objDate1.getTime() < objDate2.getTime()) return -1;
	if (objDate1.getTime() == objDate2.getTime()) return 0;
	if (objDate1.getTime() > objDate2.getTime()) return 1;
}

//takes 2 date and time string and compares it to today's date and current time
//returns 0 if the they are equal.
//returns -1 if datestr1&timestr1 is earlier than today and current time
//returns 1 if datestr1&timestr1 is after today and current time
function DateTimeStringCompareToday(datestr1,timestr1) {
	//get Date objects
	var objDate = DateTimeStringToDateObj(datestr1,timestr1);
	var objToday = new Date();
	objToday.setSeconds(0);objToday.setMilliseconds(0); //reset gmt seconds, milliseconds
	if (TK_dtformat=="THAI") objToday.setYear(objToday.getFullYear()+543);
	if (objDate.getTime() < objToday.getTime()) return -1;
	if (objDate.getTime() == objToday.getTime()) return 0;
	if (objDate.getTime() > objToday.getTime()) return 1;
}


//takes 2 date strings and returns an array of components for the differences between the dates
//differences returned in days,weeks,months,years
//NB: diff between 30/8/03 and 30/9/04 = 1 year; 13 months
// but diff between 31/8/03 and 30/9/04 = 1 year; 12 months
function DateStringDifference(datestr1,datestr2) {
	var arrDateDiff = new Array(4);
	var days=0;var wks=0;var mths=0;var yrs=0;
	//date subtraction used as date2 - date1 so if date1 is after date2, switch dates around.
	if (DateStringCompare(datestr1,datestr2)==1) {
		var dtemp=datestr2; datestr2=datestr1; datestr1=dtemp;
	}
	arrD1=DateStringToArray(datestr1);
	arrD2=DateStringToArray(datestr2);
	//need to convert to UTC date to take into account DST for day calculations
	var objD1 = new Date(Date.UTC(arrD1["yr"],arrD1["mn"]-1,arrD1["dy"],0,0,0));
	var objD2 = new Date(Date.UTC(arrD2["yr"],arrD2["mn"]-1,arrD2["dy"],0,0,0));
	days=(objD2-objD1)/msperday;
	wks=Math.floor(days/7);
	var xdays=arrD2["dy"]-arrD1["dy"];
	mths=arrD2["mn"]-arrD1["mn"];
	yrs=arrD2["yr"]-arrD1["yr"];
	if (xdays<0) mths=mths-1;
	if (mths<0) {mths=mths+12; yrs=yrs-1;}
	mths=(yrs*12)+mths;
	arrDateDiff["dy"]=days; arrDateDiff["wk"]=wks; arrDateDiff["mn"]=mths; arrDateDiff["yr"]=yrs;
	return arrDateDiff;
}
//like DateStringDifference with Today as datestr2
function DateStringDifferenceToday(datestr) {
	return DateStringDifference(datestr,DateStringToday());
}



function MonthsShortToNum(month) {
	var found=0;
	var arrTMONTHSSHORT=session['XMONTHSSHORT'].toUpperCase().split(",");
	for (i in arrTMONTHSSHORT) {
		if (arrTMONTHSSHORT[i]==month.toUpperCase()) {found=1+parseInt(i,10); break;}
	}
	if ((found)&&(found<10)) found="0"+found;
	return found;
}

// cjb 27/08/2003 37908
// pass in a date string and return the $h date, using 01/01/1970 as the reference date
function DateStringTo$H(str) {
	var arrD1=DateStringToArray(str);
	//if ((TK_dtformat=="THAI") arrD1["dy"]-=543;
	var objD1 = new Date(Date.UTC(arrD1["yr"],arrD1["mn"]-1,arrD1["dy"],0,0,0));
	var mssince1970=objD1.getTime()
	var dayssince1970=mssince1970/msperday
	var $H=cachetojs+dayssince1970
	return $H
}
//return cache $h
function DateStringTo$HToday() {
	var objD1 = new Date();
	var mssince1970=objD1.getTime()
	var dayssince1970=mssince1970/msperday
	var $H=cachetojs+dayssince1970
	return Math.round($H)
}



/****************
	Time functions
****************/
function TimeStringToArray(str) {
 	var arrTimeComponents = new Array(2);
	//arrTimeComponents["hr"]="",arrTimeComponents["mn"]=""
	//if (str=="") return arrTimeComponents;
 	var arrTime = str.split(TK_tmseparator);
	arrTimeComponents["hr"] = arrTime[0];
	arrTimeComponents["mn"] = arrTime[1];
	return arrTimeComponents;
}

//takes 2 time strings and compares which is the greater
//returns 0 if the times are equal.
//returns -1 if time1 is earlier than time2
//returns 1 if time1 is after time2
function TimeStringCompare(str1,str2) {
	var arrTime1 = TimeStringToArray(str1);
	var arrTime2 = TimeStringToArray(str2);
	if (arrTime1["hr"] < arrTime2["hr"]) return -1;
	if (arrTime1["hr"] == arrTime2["hr"]) {
		if (arrTime1["mn"] < arrTime2["mn"]) return -1;
		if (arrTime1["mn"] == arrTime2["mn"]) return 0;
		if (arrTime1["mn"] > arrTime2["mn"]) return 1;
	}
	if (arrTime1["hr"] > arrTime2["hr"]) return 1;
}

//Takes two date time strings and returns the difference between them in hours and minutes
//Eg.1 date1 = "04/08/2003" time1 = "14:00" date2 = "04/08/2003" time2 = "23:15" returns an array with 9 hours and 15 minutes
//Eg.2 date1 = "04/08/2003" time1 = "14:00" date2 = "04/08/2003" time2 = "14:00" returns an array with 0 hours and 0 minutes
//Eg.3 date1 = "05/08/2003" time1 = "17:30" date2 = "04/08/2003" time2 = "14:00" returns an array with 27 hours and 30 minutes
function DateTimeDiffInHM(date1,time1,date2,time2) {
	var objDate1 = DateTimeStringToDateObj(date1,time1);
	var objDate2 = DateTimeStringToDateObj(date2,time2);
	
	var diffDate = new Date();
	diffDate.setTime(Math.abs(objDate1.getTime() - objDate2.getTime()));
	var diffNo = diffDate.getTime();
	
	var days = Math.floor(diffNo / (24 * 60 * 60 * 1000));

	var hours = Math.floor(diffNo / (60 * 60 * 1000));
	diffNo -= hours * (60 * 60 * 1000);

	var mins = Math.floor(diffNo / (60 * 1000));
	diffNo -= mins * (60 * 1000);

	var arrComps = new Array(2);
	arrComps["hr"] = hours;
	arrComps["mn"] = mins;

	return arrComps;	
}

//Takes two date time strings and returns the difference between them in hours and minutes
//Eg.1 date1 = "04/08/2003" time1 = "14:00" date2 = "04/08/2003" time2 = "23:15" returns the string 09:15
//Eg.2 date1 = "04/08/2003" time1 = "14:00" date2 = "04/08/2003" time2 = "14:00" returns the string 00:00
//Eg.3 date1 = "05/08/2003" time1 = "17:30" date2 = "04/08/2003" time2 = "14:00" returns the string 27:30
function DateTimeDiffInHMStr(date1,time1,date2,time2) {
	var arr = DateTimeDiffInHM(date1,time1,date2,time2)

	var hrmn = ReWriteTime(arr["hr"],arr["mn"],0);	

	return hrmn;	
}

//Takes a datestring (date only,not time), type ("D" = Days, "W" = Weeks, "M" = Months, "Y" = Years), and no. to add to type.
//Returns a Date object
function AddToDateStrGetDateObj(dateStr,type,addNo){
	var dateObj = DateStringToDateObj(dateStr);
	var dateNo = dateObj.getTime();
	var addedDate;
	var formatDate;
	
	//add days
	if(type == "D"){
		// ab 8.11.07 - 65334 - need to do it this way because of daylight saving bug
		dateObj.setDate(dateObj.getDate()+addNo);
		//addedDate = new Date(dateNo + (addNo * 24 * 60 * 60 * 1000));
		//formatDate = ReWriteDate(addedDate.getDate(),addedDate.getMonth()+1,addedDate.getFullYear());
		return dateObj;
	}
	//add weeks
	else if(type == "W"){
		//addedDate = new Date(dateNo + (addNo * 7 * 24 * 60 * 60 * 1000));
		dateObj.setDate(dateObj.getDate()+(addNo*7));
		return dateObj;
	}
	//add months
	else if (type == "M"){
		var mnth = dateObj.getMonth();
		var yr = dateObj.getFullYear();
		while(addNo > 11){
			yr++;
			addNo -= 12;
		}
		var newMnth = mnth + addNo;
		if(newMnth > 11){ 
			yr++;
			newMnth = newMnth - 12;
		}
		addedDate = new Date(dateObj.getTime());
		addedDate.setMonth(newMnth);
		addedDate.setFullYear(yr);
		return addedDate;
	}
	//add years
	else if (type == "Y"){
		addedDate = new Date(dateObj.getTime());
		addedDate.setFullYear(dateObj.getFullYear() + addNo);
		return addedDate;		
	}
}

//Takes a datestring (date only,not time), type ("D" = Days, "W" = Weeks, "M" = Months, "Y" = Years), and no. to add to type.
//Returns a Date string
function AddToDateStrGetDateStr(dateStr,type,addNo){
	var dateObj = AddToDateStrGetDateObj(dateStr,type,addNo);
	if(dateObj == null)
		return "";
	else
		return ReWriteDate(dateObj.getDate(),dateObj.getMonth()+1,dateObj.getFullYear());

}

function mPiece(s1,sep,n) {
	delimArray = s1.split(sep);
	if ((n <= delimArray.length-1) && (n >= 0)) return delimArray[n];
}
