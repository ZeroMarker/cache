function UpdateClickHandler(){
	var oktoupdate=true;
	var defemailfrom=document.getElementById('DefaultEmailFrom');
	if (defemailfrom) {
		var emailReg = "^[\\w-_\.]*[\\w-_\.]\@[\\w]\.+[\\w]+[\\w]$";
		var regex = new RegExp(emailReg);
		if (regex.test(defemailfrom.value)||defemailfrom.value=="")
			;
		else {
			alert(t['INVALIDEMAIL']);
			defemailfrom.focus();
			oktoupdate=false;
		}
	}

	if (oktoupdate)
		return update1_click();

	return false;
}
function DateFormatHandler(str){
	if (str.indexOf("YMD")>-1){
		document.getElementById("DateSeparator").value="-";
	}else{
		document.getElementById("DateSeparator").value="/";
	}
}
function disableColEditHandler(){
	var obj = document.getElementById("DisableWebColEnc");
	if (obj){cspRunServerMethod(obj.value);}
}
//,"LogonPageTitle"
var ReadOnlyArr = ["SiteCode","LayoutManager","WebServer","PathToApp","OverrideAuthentication",
"TimeOut","ockScrTimeOut","LanguageApp","EnableCodeTableUpdates","DataNamespace","LabDataNamespace",
"SortMaxRows","RebuildJS","EnableTRAKOptions","IsHTTPS","PathToReports","PathToTemporaryFiles","XMLWindowsPath",
"PathToWebPatches","PathsToWebServers","CASLoginlURL","CASValidateURL",
"EnableCALogon","UserSingleLogon","EnableExitAlert","AheadTipDay","PwdAttemps","PwdMinLength",
"PwdContainWordAndNum","CheckPwdComplexit","PwdValidInterval","DateFormat","DateSeparator","DateTodayCharacter",
"DateWeekCharacter","DateMonthCharacter","DateYearCharacter","TimeFormat",
"TimeSeparator","TimeNowCharacter","TimePMSymbol","TimeAMSymbol","PerformanceStatisticsCapture","PerformanceStatisticsDisplay"];
document.body.onload = function(){
	var update=document.getElementById('update1');
	update1.onclick=UpdateClickHandler;
	var disableColEditBtn = document.getElementById("DisableColEdit");
	if (disableColEditBtn){
		disableColEditBtn.onclick = disableColEditHandler;
	}
	var dateSepObj = document.getElementById("DateSeparator");
	dateSepObj.setAttribute("readOnly",'true')
	dateSepObj.style.backgroundColor="#dddddd";
	var obj = document.getElementById("IsNew");
	if (obj && obj.value==1){ //ÊÇÐÂ½¨
		var str = tkMakeServerCall("websys.Configuration","GetJson",1);
		var json = {};
		eval("json="+str);
		for (var i in json){
			if (i!="ID"){
				if (document.getElementById(i)){
					document.getElementById(i).value = json[i];
				}
			}
		}
	}
	var obj = document.getElementById("ID"); 
	if (obj && obj.value!=1){
		for (var ind=0; ind<ReadOnlyArr.length; ind++){
			var obj = document.getElementById(ReadOnlyArr[ind]);
			if (obj) {
				if (obj.type.toLowerCase()=="checkbox"){
					obj.disabled=true;
				}else{
					obj.readOnly=true;
				}
				obj.style.backgroundColor="#EEEEEE"
			}
		}
	}
}
