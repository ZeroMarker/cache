// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.


document.body.onload = Init;

function Init(){
	//disable the New link on ORAnaestAgent.List if Anaesthesia is new (if ID is blank)
	DisableNewAgentLink();

	var obj;

	obj=document.getElementById('DeleteAnaeCompl');
	if (obj) obj.onclick=AnaeComplDeleteClickHandler;

	obj=document.getElementById('DeleteMonDev');
	if (obj) obj.onclick=MonDevDeleteClickHandler;

	obj=document.getElementById('update');
	if (obj) obj.onclick=UpdateAll;
	if (tsc['update']) websys_sckeys[tsc['update']]=UpdateAll;

	obj=document.getElementById('UpdateClose');
	if (obj) obj.onclick=UpdateCloseAll;
	if (tsc['UpdateClose']) websys_sckeys[tsc['UpdateClose']]=UpdateCloseAll;


	obj=document.getElementById('ANADate');
	if (obj) obj.onblur=DoAnaStartDateVal;

	obj=document.getElementById('ANAFinishDate');
	if (obj) obj.onblur=DoAnaFinishDateVal;

	obj=document.getElementById('ANAAnaStartTime');
	if (obj) obj.onblur=DoAnaStartTimeVal;

	obj=document.getElementById('ANAAnaFinishTime');
	if (obj) obj.onblur=DoAnaFinishTimeVal;

	obj=document.getElementById('ANAAreaInDate');
	if (obj) obj.onblur=DoAreaStartDateVal;

	obj=document.getElementById('ANAAreaOutDate');
	if (obj) obj.onblur=DoAreaFinishDateVal;

	obj=document.getElementById('ANAAreaInTime');
	if (obj) obj.onblur=DoAreaStartTimeVal;

	obj=document.getElementById('ANAAreaOutTime');
	if (obj) obj.onblur=DoAreaFinishTimeVal;

	obj=document.getElementById('ANATheatreInDate');
	if (obj) obj.onblur=DoThtrStartDateVal;

	obj=document.getElementById('ANATheatreOutDate');
	if (obj) obj.onblur=DoThtrFinishDateVal;

	obj=document.getElementById('ANATheatreInTime');
	if (obj) obj.onblur=DoThtrStartTimeVal;

	obj=document.getElementById('ANATheatreOutTime');
	if (obj) obj.onblur=DoThtrFinishTimeVal;

	obj=document.getElementById('ANAPACUStartDate');
	if (obj) obj.onblur=DoPACUStartDateVal;

	obj=document.getElementById('ANAPACUFinishDate');
	if (obj) obj.onblur=DoPACUFinishDateVal;

	obj=document.getElementById('ANAPACUStartTime');
	if (obj) obj.onblur=DoPACUStartTimeVal;

	obj=document.getElementById('ANAPACUFinishTime');
	if (obj) obj.onblur=DoPACUFinishTimeVal;

	obj=document.getElementById('ANAStatus');
	if (obj) obj.onblur=DoStatusValidation;

	obj=document.getElementById('AnaPref');
	if (obj) obj.onclick=AnaPrefClickHandler;

	obj=document.getElementById('RecPref');
	if (obj) obj.onclick=RecPrefClickHandler;

	// Log 55973 - PJC - 20-12-2005 : DSReportFlag logic.
	obj=document.getElementById('ANADSReportFlag');
	var obj2=document.getElementById('ANADSReportFlagValue');
	if (obj) {
		obj.onclick=ANADSReportFlagClickHandler;
		if (obj2) {
			if (obj.checked) {
				obj2.value="Y";
			} else {
				obj2.value="N";
			}
		}
	} else {
		if (obj2) obj2.value="N";
	}
	// end Log 55973

	CalcDurations();

	DisableLinks();

	InitBoldLinks();

	DoInitStatusValidation();

	DoInitDefaults();
}

//Log 43894
//If a new ORAnaesthesia object, set ANADate to HANADate value.
//ANADate by default is set to today's date (DB default).  If a preference is setup to copy the Operation Date from
//RBOperatingRoom.Edit, then HANADate is set to the RBOPDateOper.
function DoInitDefaults(){
	var idObj = document.getElementById("ID");
	if (idObj && idObj.value==""){
		var hObj = document.getElementById("HANADate");
		var obj = document.getElementById("ANADate");
		if (obj && hObj && hObj.value!="") {
			obj.value=hObj.value;
		}
		obj = document.getElementById("ANAFinishDate");
		if (obj && hObj && hObj.value!="") {
			obj.value=hObj.value;
		}
		obj = document.getElementById("ANAAreaInDate");
		if (obj && hObj && hObj.value!="") {
			obj.value=hObj.value;
		}
		obj = document.getElementById("ANAAreaOutDate");
		if (obj && hObj && hObj.value!="") {
			obj.value=hObj.value;
		}
		obj = document.getElementById("ANAPACUStartDate");
		if (obj && hObj && hObj.value!="") {
			obj.value=hObj.value;
		}
		obj = document.getElementById("ANAPACUFinishDate");
		if (obj && hObj && hObj.value!="") {
			obj.value=hObj.value;
		}
		obj = document.getElementById("ANATheatreInDate");
		if (obj && hObj && hObj.value!="") {
			obj.value=hObj.value;
		}
		obj = document.getElementById("ANATheatreOutDate");
		if (obj && hObj && hObj.value!="") {
			obj.value=hObj.value;
		}
		obj = document.getElementById("ANAPACUReadyLeaveDate");
		if (obj && hObj && hObj.value!="") {
			obj.value=hObj.value;
		}
	}
}

//Disable the Other Staff link for a new operation
//Log 53433 RC - Added disabling of new links: Anaesthetic Preferences and Recovery Preferences
function DisableLinks(){
	var objId = document.getElementById("ID");
	if (objId && objId.value==""){
		var objLink = document.getElementById("StaffLink");
		if (objLink){
			objLink.disabled=true;
			objLink.onclick="";
		}
		var objAnaLink = document.getElementById("AnaPref");
		if (objAnaLink){
			objAnaLink.disabled=true;
			objAnaLink.onclick="";
		}
		var objRecLink = document.getElementById("RecPref");
		if (objRecLink){
			objRecLink.disabled=true;
			objRecLink.onclick="";
		}
	}
	var AnaOEString = document.getElementById("AnaOEString");
	if (AnaOEString && AnaOEString.value==0){
		var objAnaLink = document.getElementById("AnaPref");
		if (objAnaLink){
			objAnaLink.disabled=true;
			objAnaLink.onclick="";
		}
	}
	var RecOEString = document.getElementById("RecOEString");
	if (RecOEString && RecOEString.value==0){
		var objRecLink = document.getElementById("RecPref");
		if (objRecLink){
			objRecLink.disabled=true;
			objRecLink.onclick="";
		}
	}
	var RBOpIDobj=document.getElementById("RBOPId");
	if (RBOpIDobj && RBOpIDobj.value=="") {
		var objTBFLink=document.getElementById("TBFormLink");
		if (objTBFLink){
			objTBFLink.disabled=true;
			objTBFLink.onclick="";
		}
	}
	var objfchild=document.getElementById("fchID");
	if (objfchild&&objfchild.value=="") {
	var objLink = document.getElementById("PositionLink");
		if (objLink){
			objLink.disabled=true;
			objLink.onclick="";
		}
	}	
}

function setBoldLinks(el,state) {
	obj=document.getElementById(el);
	if (obj) {
		if (state==1) {obj.style.fontWeight="bold";}
		else {obj.style.fontWeight="normal";}
	}
}

function InitBoldLinks(){
	var objBold=document.getElementById('BoldLinks');
	if (objBold) {
		var BoldLink = objBold.value.split("^");
		setBoldLinks("StaffLink",BoldLink[0]);
		setBoldLinks("AnaPref",BoldLink[1]);
		setBoldLinks("RecPref",BoldLink[2]);
	}
}

//If the status (StatusId) is "D" or "A", then disable all fields.  This is executed on page load.
function DoInitStatusValidation(){
	var objSId = document.getElementById("StatusId");
	if(objSId && (objSId.value == "D" || objSId.value == "A")){
		makeReadOnly();
	}
}

//This function makes fields disabled.
function makeReadOnly() {
	var el=document.forms["fORAnaesthesia_Edit"].elements;
	if(!el) {return;}

	//disable input fields
	for (var i=0;i<el.length;i++) {
		if (!(el[i].type=="hidden")) {
			el[i].disabled=true;
		}
	}
	//disable image elements (lookup, dates etc. images)
	var arrLookUps=document.getElementsByTagName("IMG");
	for (var i=0; i<arrLookUps.length; i++) {
		if ((arrLookUps[i].id)&&(arrLookUps[i].id.charAt(0)=="l")) {
				arrLookUps[i].disabled=true;
		}
	}
	//disable links
	var arrLinks=document.getElementsByTagName("A");
	for (var i=0; i<arrLinks.length; i++) {
		if ((arrLinks[i].id)) {
			var par=websys_getParentElement(arrLinks[i]);
			if ((par)&&(par.id)&&(par.id.indexOf("tbMenu")==0)) continue;
			if(arrLinks[i].id != "Close" && arrLinks[i].id != "StaffLink" && arrLinks[i].id != "AuditTrailData" && arrLinks[i].id != "AuditTrailLog" && arrLinks[i].id != "RecPref" && arrLinks[i].id != "AnaPref"){
				arrLinks[i].disabled=true;
				arrLinks[i].className="clsDisabled";
				arrLinks[i].onclick=LinkDisabled;
				arrLinks[i].style.cursor='default';
			}
		}
	}
	//58620 RC 21/03/06 Make TextAreas readonly instead, so scrollbars can be used.
	var txtAreas=document.getElementsByTagName("textarea")
	for (var i=0; i<txtAreas.length; i++) {
		if(txtAreas[i].id){
			txtAreas[i].disabled=false;
			txtAreas[i].readOnly=true;
			txtAreas[i].className="clsReadOnly";
		}
	}

	//var obj=document.getElementById("UserCode");
	//if (obj) obj.disabled=false;
	//var obj=document.getElementById("PIN");
	//if (obj) obj.disabled=false;
}

function LinkDisabled() {
	return false;
}

//Calculate in hours and minutes the difference between start date/time and end date/time.  Display as HH:MM.
function CalcTimeDiffHM(sDateName, sTimeName, eDateName, eTimeName, durFldName){
	var sDate = document.getElementById(sDateName);
	var sTime = document.getElementById(sTimeName);
	var eDate = document.getElementById(eDateName);
	var eTime = document.getElementById(eTimeName);
	var durFld = document.getElementById(durFldName);

	if(sDate == null || sTime == null || eDate == null || eTime == null || durFld == null)
		return;

	if(sDate.value == "" || sTime.value == "" || eDate.value == "" || eTime.value == ""){
		durFld.value = "";
		return;
	}

	durFld.value = DateTimeDiffInHMStr(sDate.value, sTime.value, eDate.value, eTime.value);
}

//This function compares the passed date and time to current date and time.  If passed date/time is in the future,
//an error message is given.
function DoDateTimeFutureValidation(dateFld, timeFld){
	var dt = document.getElementById(dateFld);
	if(dt && dt.value != ""){
		var dateCmpr = DateStringCompareToday(dt.value);
		if(dateCmpr == 1){
			alert(t[dateFld] + " " + t["FutureDate"]);
    			dt.value = "";
	    		websys_setfocus(dateFld);
			return false;

			//dt.className='clsInvalid';
			//websys_setfocus(dateFld);
			//return  websys_cancel();
		}
		//if date is today's date, then check time to make sure that it's not in the future
		else if (dateCmpr == 0){
			var tm = document.getElementById(timeFld);
			if(tm && tm.value!="" && dt.value!=""){//need to check dt as well as it may have been set to "" above
				// Log 59259 - GC - 29/05/06: Modified for THAI date format
				var timeCmpr=DateTimeStringCompareToday(dt.value,tm.value)
				if(timeCmpr == 1) {
					alert(t[timeFld] + " " + t["FutureDate"]);
					tm.value = "";
					websys_setfocus(timeFld);
					return false;
				}				
				/*var arrDate = DateStringToArray(dt.value);
				var arrTime = TimeStringToArray(tm.value);
				var entDateTime = new Date(arrDate["yr"],arrDate["mn"]-1,arrDate["dy"],arrTime["hr"],arrTime["mn"],0);
				var nowDateTime = new Date();
				if (entDateTime.getTime() > nowDateTime.getTime()){
					alert(t[timeFld] + " " + t["FutureDate"]);
	    				tm.value = "";
    					websys_setfocus(timeFld);
					return false;
				}*/
				// End Log 59259
			}

		}
	}
	return true;
}

//This function compares the passed date and time to the admission date and time.  If passed date/time is not after
//the admission date time, an error message is given.
function DoDateTimeAdmValidation(dateFld, timeFld){
	var dt = document.getElementById(dateFld);
	var dtAdm = document.getElementById("AdmDate");
	var tmAdm = document.getElementById("AdmTime");
	if(dt && dt.value != "" && dtAdm && dtAdm.value != ""){
		var dateCmpr = DateStringCompare(dtAdm.value,dt.value);
		if(dateCmpr == 1){
			alert(t[dateFld] + " " + t["AdmDate"] + " " + dtAdm.value + " " + tmAdm.value);
    			dt.value = "";
	    		websys_setfocus(dateFld);
			return false;
		}
		//if date is after adm date, then check time to make sure that it is after admission time
		else if (dateCmpr == 0){
			var tm = document.getElementById(timeFld);
			if(tm && tm.value!="" && dt.value!="" && tmAdm && tmAdm.value!=""){//need to check dt as well as it may have been set to "" above
			/*	var arrDate = DateStringToArray(dt.value);
				var arrTime = TimeStringToArray(tm.value);
				var arrAdmDate = DateStringToArray(dtAdm.value);
				var arrAdmTime = TimeStringToArray(tmAdm.value);
				var entDateTime = new Date(arrDate["yr"],arrDate["mn"]-1,arrDate["dy"],arrTime["hr"],arrTime["mn"],0);
				var admDateTime = new Date(arrAdmDate["yr"],arrAdmDate["mn"]-1,arrAdmDate["dy"],arrAdmTime["hr"],arrAdmTime["mn"],0);
				if (entDateTime.getTime() < admDateTime.getTime()){
					alert(t[timeFld] + " " + t["AdmDate"] + " " + dtAdm.value + " " + tmAdm.value);
	    				tm.value = "";
    					websys_setfocus(timeFld);
					return false;
				}
			*/
			var dtcompare= DateTimeStringCompare(dtAdm.value,tmAdm.value,dt.value,tm.value)
				if (dtcompare=="1"){
					alert(t[timeFld] + " " + t["AdmDate"] + " " + dtAdm.value + " " + tmAdm.value);
	    				tm.value = "";
    					websys_setfocus(timeFld);
					return false;
				}	
			}

		}
	}
	return true;
}

//This function gives an error message if the start date/time and end date/time are not in sequence.
function DoDateTimeStartEndValidation(sdateFld, stimeFld, edateFld, etimeFld, entFld){
	var dtStart = document.getElementById(sdateFld);
	var dtEnd = document.getElementById(edateFld);
	var entFld = document.getElementById(entFld);
	if(dtStart && dtStart.value != "" && dtEnd && dtEnd.value != ""){
		var dateCmpr = DateStringCompare(dtStart.value,dtEnd.value);
		if(dateCmpr == 1){
			alert(t['StartEndDateTime']);
    			//dtStart.value = "";
	    		//websys_setfocus(sdateFld);
			entFld.value = "";
			websys_setfocus(entFld);
			return false;
		}
		//if start date is before end date, then check start time to make sure that it is befor end time
		else if (dateCmpr == 0){
			var tmStart = document.getElementById(stimeFld);
			var tmEnd = document.getElementById(etimeFld);
			if(tmStart && tmStart.value!="" && dtStart.value!="" && dtEnd.value!="" && tmEnd && tmEnd.value!=""){//need to check dt as well as it may have been set to "" above
			/*	var arrSDate = DateStringToArray(dtStart.value);
				var arrSTime = TimeStringToArray(tmStart.value);
				var arrEDate = DateStringToArray(dtEnd.value);
				var arrETime = TimeStringToArray(tmEnd.value);
				var startDateTime = new Date(arrSDate["yr"],arrSDate["mn"]-1,arrSDate["dy"],arrSTime["hr"],arrSTime["mn"],0);
				var endDateTime = new Date(arrEDate["yr"],arrEDate["mn"]-1,arrEDate["dy"],arrETime["hr"],arrETime["mn"],0);
				if (endDateTime.getTime() < startDateTime.getTime()){
					alert(t['StartEndDateTime']);
	    				//tmStart.value = "";
    					//websys_setfocus(stimeFld);
					entFld.value = "";
					websys_setfocus(entFld);
					return false;
				}
			*/
			var dtcompare= DateTimeStringCompare(dtStart.value,tmStart.value,dtEnd.value,tmEnd.value)
				if (dtcompare=="1"){
					alert(t['StartEndDateTime']);
	    				//tmStart.value = "";
    					//websys_setfocus(stimeFld);
					entFld.value = "";
					websys_setfocus(entFld);
					return false;
				}	
			}

		}
	}
	return true;
}

function DoAnaStartDateVal(){
	ANADate_changehandler(e)
	if (DoDateTimeFutureValidation("ANADate","ANAAnaStartTime")){
		if (DoDateTimeAdmValidation("ANADate","ANAAnaStartTime")){
			DoDateTimeStartEndValidation("ANADate","ANAAnaStartTime","ANAFinishDate","ANAAnaFinishTime","ANADate");
			CalcTimeDiffHM("ANADate","ANAAnaStartTime","ANAFinishDate","ANAAnaFinishTime","AnaDuration");
		}
	}
}

function DoAnaStartTimeVal(){
	ANAAnaStartTime_changehandler(e)
	if(DoDateTimeFutureValidation("ANADate","ANAAnaStartTime")){
		if(DoDateTimeAdmValidation("ANADate","ANAAnaStartTime")){
			DoDateTimeStartEndValidation("ANADate","ANAAnaStartTime","ANAFinishDate","ANAAnaFinishTime","ANAAnaStartTime");
			CalcTimeDiffHM("ANADate","ANAAnaStartTime","ANAFinishDate","ANAAnaFinishTime","AnaDuration");
		}
	}
}

function DoAnaFinishDateVal(){
	ANAFinishDate_changehandler(e)
	if (DoDateTimeFutureValidation("ANAFinishDate","ANAAnaFinishTime")){
		if (DoDateTimeAdmValidation("ANAFinishDate","ANAAnaFinishTime")){
			DoDateTimeStartEndValidation("ANADate","ANAAnaStartTime","ANAFinishDate","ANAAnaFinishTime","ANAFinishDate");
			CalcTimeDiffHM("ANADate","ANAAnaStartTime","ANAFinishDate","ANAAnaFinishTime","AnaDuration");
		}
	}
}

function DoAnaFinishTimeVal(){
	ANAAnaFinishTime_changehandler(e)
	if (DoDateTimeFutureValidation("ANAFinishDate","ANAAnaFinishTime")){
		if (DoDateTimeAdmValidation("ANAFinishDate","ANAAnaFinishTime")){
			DoDateTimeStartEndValidation("ANADate","ANAAnaStartTime","ANAFinishDate","ANAAnaFinishTime","ANAAnaFinishTime");
			CalcTimeDiffHM("ANADate","ANAAnaStartTime","ANAFinishDate","ANAAnaFinishTime","AnaDuration");
		}
	}
}

function DoAreaStartDateVal(){
	ANAAreaInDate_changehandler(e)
	if (DoDateTimeFutureValidation("ANAAreaInDate","ANAAreaInTime")){
		if (DoDateTimeAdmValidation("ANAAreaInDate","ANAAreaInTime")){
			DoDateTimeStartEndValidation("ANAAreaInDate","ANAAreaInTime","ANAAreaOutDate","ANAAreaOutTime","ANAAreaInDate");
			CalcTimeDiffHM("ANAAreaInDate","ANAAreaInTime","ANAAreaOutDate","ANAAreaOutTime","AreaDuration");
		}
	}
}

function DoAreaStartTimeVal(){
	ANAAreaInTime_changehandler(e)
	if(DoDateTimeFutureValidation("ANAAreaInDate","ANAAreaInTime")){
		if(DoDateTimeAdmValidation("ANAAreaInDate","ANAAreaInTime")){
			DoDateTimeStartEndValidation("ANAAreaInDate","ANAAreaInTime","ANAAreaOutDate","ANAAreaOutTime","ANAAreaInTime");
			CalcTimeDiffHM("ANAAreaInDate","ANAAreaInTime","ANAAreaOutDate","ANAAreaOutTime","AreaDuration");
		}
	}
}

function DoAreaFinishDateVal(){
	ANAAreaOutDate_changehandler(e)
	if (DoDateTimeFutureValidation("ANAAreaOutDate","ANAAreaOutTime")){
		if (DoDateTimeAdmValidation("ANAAreaOutDate","ANAAreaOutTime")){
			DoDateTimeStartEndValidation("ANAAreaInDate","ANAAreaInTime","ANAAreaOutDate","ANAAreaOutTime","ANAAreaOutDate");
			CalcTimeDiffHM("ANAAreaInDate","ANAAreaInTime","ANAAreaOutDate","ANAAreaOutTime","AreaDuration");
		}
	}
}

function DoAreaFinishTimeVal(){
	ANAAreaOutTime_changehandler(e)
	if (DoDateTimeFutureValidation("ANAAreaOutDate","ANAAreaOutTime")){
		if (DoDateTimeAdmValidation("ANAAreaOutDate","ANAAreaOutTime")){
			DoDateTimeStartEndValidation("ANAAreaInDate","ANAAreaInTime","ANAAreaOutDate","ANAAreaOutTime","ANAAreaOutTime");
			CalcTimeDiffHM("ANAAreaInDate","ANAAreaInTime","ANAAreaOutDate","ANAAreaOutTime","AreaDuration");
		}
	}
}


function DoThtrStartDateVal(){
	ANATheatreInDate_changehandler(e)
	if (DoDateTimeFutureValidation("ANATheatreInDate","ANATheatreInTime")){
		if (DoDateTimeAdmValidation("ANATheatreInDate","ANATheatreInTime")){
			DoDateTimeStartEndValidation("ANATheatreInDate","ANATheatreInTime","ANATheatreOutDate","ANATheatreOutTime","ANATheatreInDate");
			CalcTimeDiffHM("ANATheatreInDate","ANATheatreInTime","ANATheatreOutDate","ANATheatreOutTime","ThtrDuration");
		}
	}
}

function DoThtrStartTimeVal(){
	ANATheatreInTime_changehandler(e)
	if(DoDateTimeFutureValidation("ANATheatreInDate","ANATheatreInTime")){
		if(DoDateTimeAdmValidation("ANATheatreInDate","ANATheatreInTime")){
			DoDateTimeStartEndValidation("ANATheatreInDate","ANATheatreInTime","ANATheatreOutDate","ANATheatreOutTime","ANATheatreInTime");
			CalcTimeDiffHM("ANATheatreInDate","ANATheatreInTime","ANATheatreOutDate","ANATheatreOutTime","ThtrDuration");
		}
	}
}

function DoThtrFinishDateVal(){
	ANATheatreOutDate_changehandler(e)
	if (DoDateTimeFutureValidation("ANATheatreOutDate","ANATheatreOutTime")){
		if (DoDateTimeAdmValidation("ANATheatreOutDate","ANATheatreOutTime")){
			DoDateTimeStartEndValidation("ANATheatreInDate","ANATheatreInTime","ANATheatreOutDate","ANATheatreOutTime","ANATheatreOutDate");
			CalcTimeDiffHM("ANATheatreInDate","ANATheatreInTime","ANATheatreOutDate","ANATheatreOutTime","ThtrDuration");
		}
	}
}

function DoThtrFinishTimeVal(){
	ANATheatreOutTime_changehandler(e)
	if (DoDateTimeFutureValidation("ANATheatreOutDate","ANATheatreOutTime")){
		if (DoDateTimeAdmValidation("ANATheatreOutDate","ANATheatreOutTime")){
			DoDateTimeStartEndValidation("ANATheatreInDate","ANATheatreInTime","ANATheatreOutDate","ANATheatreOutTime","ANATheatreOutTime");
			CalcTimeDiffHM("ANATheatreInDate","ANATheatreInTime","ANATheatreOutDate","ANATheatreOutTime","ThtrDuration");
		}
	}
	try {DefaultInRecTime()} catch(e) {}
}

function DoPACUStartDateVal(){
	ANAPACUStartDate_changehandler(e)
	if (DoDateTimeFutureValidation("ANAPACUStartDate","ANAPACUStartTime")){
		if (DoDateTimeAdmValidation("ANAPACUStartDate","ANAPACUStartTime")){
			DoDateTimeStartEndValidation("ANAPACUStartDate","ANAPACUStartTime","ANAPACUFinishDate","ANAPACUFinishTime","ANAPACUStartDate");
			CalcTimeDiffHM("ANAPACUStartDate","ANAPACUStartTime","ANAPACUFinishDate","ANAPACUFinishTime","PACUDuration");
		}
	}
	
}

function DoPACUStartTimeVal(){
	ANAPACUStartTime_changehandler(e)
	if(DoDateTimeFutureValidation("ANAPACUStartDate","ANAPACUStartTime")){
		if(DoDateTimeAdmValidation("ANAPACUStartDate","ANAPACUStartTime")){
			DoDateTimeStartEndValidation("ANAPACUStartDate","ANAPACUStartTime","ANAPACUFinishDate","ANAPACUFinishTime","ANAPACUStartTime");
			CalcTimeDiffHM("ANAPACUStartDate","ANAPACUStartTime","ANAPACUFinishDate","ANAPACUFinishTime","PACUDuration");
		}
	}
}

function DoPACUFinishDateVal(){
	ANAPACUFinishDate_changehandler(e)
	if (DoDateTimeFutureValidation("ANAPACUFinishDate","ANAPACUFinishTime")){
		if (DoDateTimeAdmValidation("ANAPACUFinishDate","ANAPACUFinishTime")){
			DoDateTimeStartEndValidation("ANAPACUStartDate","ANAPACUStartTime","ANAPACUFinishDate","ANAPACUFinishTime","ANAPACUFinishDate");
			CalcTimeDiffHM("ANAPACUStartDate","ANAPACUStartTime","ANAPACUFinishDate","ANAPACUFinishTime","PACUDuration");
		}
	}
}

function DoPACUFinishTimeVal(){
	ANAPACUFinishTime_changehandler(e)
	if (DoDateTimeFutureValidation("ANAPACUFinishDate","ANAPACUFinishTime")){
		if (DoDateTimeAdmValidation("ANAPACUFinishDate","ANAPACUFinishTime")){
			DoDateTimeStartEndValidation("ANAPACUStartDate","ANAPACUStartTime","ANAPACUFinishDate","ANAPACUFinishTime","ANAPACUFinishTime");
			CalcTimeDiffHM("ANAPACUStartDate","ANAPACUStartTime","ANAPACUFinishDate","ANAPACUFinishTime","PACUDuration");
		}
	}
}

//calculates the durations between start date/time and end date/time
function CalcDurations(){
	CalcTimeDiffHM("ANADate","ANAAnaStartTime","ANAFinishDate","ANAAnaFinishTime","AnaDuration");
	CalcTimeDiffHM("ANAAreaInDate","ANAAreaInTime","ANAAreaOutDate","ANAAreaOutTime","AreaDuration");
	CalcTimeDiffHM("ANATheatreInDate","ANATheatreInTime","ANATheatreOutDate","ANATheatreOutTime","ThtrDuration");
	CalcTimeDiffHM("ANAPACUStartDate","ANAPACUStartTime","ANAPACUFinishDate","ANAPACUFinishTime","PACUDuration");
}

//Log 41693 - This code is moved here from ORAnaestAgent.List.js DocumentLoadHandler method.
//Disable the New link on ORAnaestAgent.List if Anaesthesia is new (if ID is blank)
function DisableNewAgentLink(){
	var objId = document.getElementById("ID");
	if (objId && objId.value==""){
		var objNewLink = document.getElementById("new1");
		if (objNewLink){
			objNewLink.disabled=true;
			objNewLink.onclick="";
		}
	}

}

//This is executed everytime value in ANAStatus is changed.
//if status is blanked out, set statusid to blank (b/c when status is blanked out lookuphandler is not called and status id retains it's previous value)
function DoStatusValidation(){
	var objSId = document.getElementById("StatusId");
	var objSts = document.getElementById("ANAStatus");
	if (objSId && objSts){
		if(objSts.value == ""){
			objSId.value = "";
		}
	}
}

function ANAStatusLookupHandler(str){
	var lu=str.split("^");
	var obj=document.getElementById("StatusId");
	if (obj) obj.value=lu[2];

	DoStatusValidation();
}


function ANAASADescLookUpHandler(str) {
	var lu=str.split("^");
	var obj=document.getElementById("ANAASADesc");
	if (obj) obj.value=lu[1];
}

function ANABldtTypeLookUpHandler(str) {
	var lu=str.split("^");
	var obj=document.getElementById("ANABldtType");
	if (obj) obj.value=lu[1];
}

function UpdateAll() {
	UpdateAnaeCompl();
	UpdateMonDev();

	//set Updated flag to true b/c attempting to update once now
	var obj=document.getElementById('Updated');
	if (obj){
		if(obj.value == "0") obj.value = "1";
	}

	return update_click()
}

function UpdateCloseAll() {
	UpdateAnaeCompl();
	UpdateMonDev();

	//set Updated flag to true b/c attempting to update once now
	var obj=document.getElementById('Updated');
	if (obj){
		if(obj.value == "0") obj.value = "1";
	}

	//if (document.getElementById('menu').value=="1") document.getElementById('UpdateClose').href="epr.default.csp"

	return UpdateClose_click()
}

function AnaPrefClickHandler() {
	var obj=document.getElementById('AnaPref');
	var objSId = document.getElementById("StatusId");
	//log 60490 TedT
	var patient=document.getElementById("PatientID");
	if(patient) patient=patient.value;
	var episode=document.getElementById("PARREF");
	if(episode) episode=episode.value;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=OEOrder.OrderItemList&Pref=Anaesthetic_Preferences&CONTEXT=AN&PatientID="+patient+"&EpisodeID="+episode;
	if (objSId.value=="D") lnk+="&ReadOnly=1"
	//log57509 TedT
	var AnaDR=document.getElementById("ID");
	var indx="Ana";
	if(AnaDR) lnk+="&AnaestDR="+AnaDR.value+"&index="+indx;
	websys_createWindow(lnk,"","width=800, height=600, top=30, left=30 scrollbars resizable");
	return false;
}

function RecPrefClickHandler() {
	var obj=document.getElementById('RecPref');
	var objSId = document.getElementById("StatusId");
	//log 60490 TedT
	var patient=document.getElementById("PatientID");
	if(patient) patient=patient.value;
	var episode=document.getElementById("PARREF");
	if(episode) episode=episode.value;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=OEOrder.OrderItemList&Pref=Recovery_Preferences&CONTEXT=REC&PatientID="+patient+"&EpisodeID="+episode;
	if (objSId.value=="D") lnk+="&ReadOnly=1"
	//log57509 TedT
	var AnaDR=document.getElementById("ID");
	var indx="AnaOp";
	if(AnaDR) lnk+="&AnaestDR="+AnaDR.value+"&index="+indx;
	websys_createWindow(lnk,"","width=800, height=600, top=30, left=30 scrollbars resizable");
	return false;
}

// Log 55973 - PJC - 20-12-2005 : DSReportFlag logic.
function ANADSReportFlagClickHandler() {
	obj=document.getElementById('ANADSReportFlag');
	var obj2=document.getElementById('ANADSReportFlagValue');
	if (obj) {
		if (obj.disabled==true) {
			return false;
		}
		if (obj2) {
			if (obj.checked) {
				obj2.value="Y";
			} else {
				obj2.value="N";
			}
		}
	} else {
		if (obj2) obj2.value="N";
	}
	return true;
}
// end Log 55973


///////////////////////////////// LIST BOXES ////////////////////////////////////////////////////////////////////////
function AddItemToList(list,code,desc) {
	//Add an item to a listbox
	code=String.fromCharCode(2)+code;
	list.options[list.options.length] = new Option(desc,code);
}

function AddItemToList_Reload(list,code,desc) {
	//Add an item to a listbox
	list.options[list.options.length] = new Option(desc,code);
}

function RemoveFromList(obj) {
	for (var i=(obj.length-1); i>=0; i--) {
		if (obj.options[i].selected)
			obj.options[i]=null;
	}

}

function RemoveAllFromList(obj){
	for (var i=(obj.length-1); i>=0; i--) {
		obj.options[i]=null;
	}

}

//TN: reload listboxes with values in hidded fields.
//this is due to page being refreshed upon error message (such as invalid pin)
function ReloadListBoxes() {
	ListboxReload("ANAECOMPLDescString","ANAECOMPLEntered");
	ListboxReload("MONDEVDescString","MONDEVEntered");
}

function ListboxReload(strName, lstName) {
	var el = document.getElementById(strName);
	var lst = document.getElementById(lstName);
	var updated = document.getElementById("Updated");
	//don't execute this when page loads for the first time b/c first time values come from db,
	//execute for subsequent reloads (such as on error condition).
	if ((lst) && (el) && (updated.value == "1")) {
		RemoveAllFromList(lst);
		if(el.value != ""){
			var arrITEM=el.value.split(String.fromCharCode(1));
			for (var i=0; i<arrITEM.length; i++) {
				var arrITEMVAL=arrITEM[i].split(String.fromCharCode(2));
				AddItemToList_Reload(lst,arrITEMVAL[0]+String.fromCharCode(2)+arrITEMVAL[1],arrITEMVAL[2]);
			}
		}
	}
}

function AnaeComplLookupSelect(txt) {
	//Add an item to list when an item is selected from
	//the Lookup, then clears the Item text field.
	var adata=txt.split("^");
	var obj=document.getElementById("ANAECOMPLEntered")

	if (obj) {
		//Need to check if Condition already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == String.fromCharCode(2)+adata[1]) {
				alert(t['ANAECOMPLDesc'] + " has already been selected");
				var obj=document.getElementById("ANAECOMPLDesc")
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
				alert(t['ANAECOMPLDesc'] + " has already been selected");
				var obj=document.getElementById("ANAECOMPLDesc")
				if (obj) obj.value="";
				return;
			}
		}
	}
	AddItemToList(obj,adata[1],adata[0]);

	var obj=document.getElementById("ANAECOMPLDesc");
	if (obj) obj.value="";
}

function UpdateAnaeCompl() {
	var arrItems = new Array();
	var lst = document.getElementById("ANAECOMPLEntered");
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			//TN:need to pass description for reloading when update error occurs
			arrItems[j] = lst.options[j].value + String.fromCharCode(2) + lst.options[j].text;
		}
		var el = document.getElementById("ANAECOMPLDescString");
		if (el) el.value = arrItems.join(String.fromCharCode(1));
	}
}

function AnaeComplDeleteClickHandler() {
	//Delete items from ANAECOMPLEntered listbox when a "Delete" button is clicked.
	var obj=document.getElementById("ANAECOMPLEntered");
	if (obj)
		RemoveFromList(obj);
	return false;
}


function MonDevLookupSelect(txt) {
	//Add an item to list when an item is selected from
	//the Lookup, then clears the Item text field.
	var adata=txt.split("^");
	var obj=document.getElementById("MONDEVEntered")

	if (obj) {
		//Need to check if Condition already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == String.fromCharCode(2)+adata[1]) {
				alert(t['MONDEVDesc'] + " has already been selected");
				var obj=document.getElementById("MONDEVDesc")
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
				alert(t['MONDEVDesc'] + " has already been selected");
				var obj=document.getElementById("MONDEVDesc")
				if (obj) obj.value="";
				return;
			}
		}
	}
	AddItemToList(obj,adata[1],adata[0]);

	var obj=document.getElementById("MONDEVDesc");
	if (obj) obj.value="";
}


function UpdateMonDev() {
	var arrItems = new Array();
	var lst = document.getElementById("MONDEVEntered");
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			//TN:need to pass description for reloading when update error occurs
			
			arrItems[j] = lst.options[j].value + String.fromCharCode(2) + lst.options[j].text;
		}
		var el = document.getElementById("MONDEVDescString");
		if (el) el.value = arrItems.join(String.fromCharCode(1));
	}
}

function MonDevDeleteClickHandler() {
	//Delete items from MONDEVEntered listbox when a "Delete" button is clicked.

	var obj=document.getElementById("MONDEVEntered");
	if (obj)
		RemoveFromList(obj);
	return false;
}



///////////////////////////////// END LIST BOXES ////////////////////////////////////////////////////////////////////////

//TN: call this outside onload call so it can be called straight away, and not wait till everything has loaded.
ReloadListBoxes();
