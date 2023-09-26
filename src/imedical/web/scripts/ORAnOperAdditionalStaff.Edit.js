// Copyright (c) 2004 TrakHealth Pty Limited. ALL RIGHTS RESERVED.


function DocumentLoadHandler() {
	var obj = document.getElementById("update1");
	if (obj) {
		obj.onclick = UpdateClickHandler;
		if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateClickHandler;
	}

	obj=document.getElementById('OPASCareProvType');
	if (obj) obj.onblur=DoCareProvTypeValidation;

	obj=document.getElementById('OPASStartDate');
	if (obj) obj.onblur=DoOpStartDateVal;

	obj=document.getElementById('OPASEndDate');
	if (obj) obj.onblur=DoOpFinishDateVal;

	obj=document.getElementById('OPASStartTime');
	if (obj) obj.onblur=DoOpStartTimeVal;

	obj=document.getElementById('OPASEndTime');
	if (obj) obj.onblur=DoOpFinishTimeVal;

	DoInitHInternalCode();
	DoInitStatusValidation();

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
	var el=document.forms["fORAnOperAdditionalStaff_Edit"].elements;  
	if(!el) {return;}
	
	//disable input fields
	for (var i=0;i<el.length;i++) {
		if (!(el[i].type=="hidden")) {
			el[i].disabled=true;
		}
	}
	//disable image elements (lookup, dates etc. images)
	var arrImgs=document.getElementsByTagName("IMG");
	for (var i=0; i<arrImgs.length; i++) {
		if ((arrImgs[i].id)&&(arrImgs[i].id.charAt(0)=="l")) {
			arrImgs[i].disabled=true;
		}
	}
	//disable links
	var arrLinks=document.getElementsByTagName("A");
	for (var i=0; i<arrLinks.length; i++) {
		if ((arrLinks[i].id)) {
			arrLinks[i].disabled=true;
			arrLinks[i].className="clsDisabled";
			arrLinks[i].onclick=LinkDisabled;
			arrLinks[i].style.cursor='default';
		}
	}

}

function LinkDisabled() {
	return false;
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
				var dtcompare=DateTimeStringCompareToday(dt.value,tm.value) 
				if (dtcompare=="1"){
					alert(t[timeFld] + " " + t["FutureDate"]);
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

function DoOpStartDateVal(){
	OPASStartDate_changehandler(e)
	if (DoDateTimeFutureValidation("OPASStartDate","OPASStartTime")){
		DoDateTimeStartEndValidation("OPASStartDate","OPASStartTime","OPASEndDate","OPASEndTime","OPASStartDate");
	}	
}

function DoOpStartTimeVal(){
	OPASStartTime_changehandler(e)
	if(DoDateTimeFutureValidation("OPASStartDate","OPASStartTime")){
		DoDateTimeStartEndValidation("OPASStartDate","OPASStartTime","OPASEndDate","OPASEndTime","OPASStartTime");
	}
}

function DoOpFinishDateVal(){
	OPASEndDate_changehandler(e)
	if (DoDateTimeFutureValidation("OPASEndDate","OPASEndTime")){
		DoDateTimeStartEndValidation("OPASStartDate","OPASStartTime","OPASEndDate","OPASEndTime","OPASEndDate");
	}		
}

function DoOpFinishTimeVal(){
	OPASEndTime_changehandler(e)
	if (DoDateTimeFutureValidation("OPASEndDate","OPASEndTime")){
		DoDateTimeStartEndValidation("OPASStartDate","OPASStartTime","OPASEndDate","OPASEndTime","OPASEndTime");
	}	
}

function UpdateClickHandler() {
	var frm = document.forms["fORAnOperAdditionalStaff_Edit"];
	if (parent.frames["frm_edit"]) {
		frm.elements['TFRAME'].value=window.parent.name;
	}
	var obj=frm.elements['TWKFLI'];
	if (!(fORAnOperAdditionalStaff_Edit_submit())) return false
	if (obj.value!="") obj.value-=1;
		
	return update1_click()

}

//If the careprovtype is blanked out, set HCareProvTypeId and HCPInternalCode to blank
//This is executed when page is loaded and everytime value in ANAOPStatus is changed.
function DoCareProvTypeValidation(){
	var objId = document.getElementById("HCareProvTypeId");
	var obj = document.getElementById("OPASCareProvType");
	var obj2 = document.getElementById("HCPInternalCode");
	var obj3 = document.getElementById("HCPFlag");
	if (objId && obj){ 
		if(obj.value == ""){ 
			objId.value = "";
			if(obj2) obj2.value = "";
			if(obj3) obj3.value = "";
		}
	}
}

//When a lookup is done on CareProvType, HCareProvTypeId is populated with the ID.
function OPASCareProvTypeLookUpHandler(str) {
	var lu=str.split("^");
	var obj=document.getElementById("HCareProvTypeId");
	var obj2=document.getElementById("HCPInternalCode");
	var obj3 = document.getElementById("HCPFlag");
	if (obj && obj2 && obj3) {
		obj.value=lu[1];
		if(lu[1]=="AA" || lu[1]=="SA") obj2.value = "DOCTOR";
		//if(lu[1]=="AA") obj3.value = "^Y^";
		//if(lu[1]=="SA") obj3.value = "^^Y";
		if(lu[1]=="AA") obj3.value = "|Y";
		if(lu[1]=="SA") obj3.value = "||Y";
		if(lu[1]=="SN" || lu[1]=="CN") {
			obj2.value = "NURSE";
			obj3.value="";
		}
		if(lu[1]=="O") {
			obj2.value="DOCTOR^NURSE";
			obj3.value="";
		}
	}
}

//This is run when the page loads.
//HCPInternalCode and HCPFlag are used as parameters for CT_CareProv lookup
function DoInitHInternalCode(){
	var obj=document.getElementById("HCareProvTypeId");
	var obj2=document.getElementById("HCPInternalCode");
	var obj3 = document.getElementById("HCPFlag");
	if (obj && obj2 && obj3) {
		if(obj.value=="AA" || obj.value=="SA") obj2.value = "DOCTOR";
		//if(obj.value=="AA") obj3.value = "^Y^";
		//if(obj.value=="SA") obj3.value = "^^Y";
		if(obj.value=="AA") obj3.value = "|Y";
		if(obj.value=="SA") obj3.value = "||Y";
		if(obj.value=="SN" || obj.value=="CN"){ 
			obj2.value = "NURSE";
			obj3.value = "";
		}
		if(obj.value=="O") {
			obj2.value="DOCTOR^NURSE";
			obj3.value="";
		}
	}
}

function OPASCareProvDRLookUpHandler(str) {

	var lu=str.split("^");
	var obj=document.getElementById("OPASCareProvDR");
	var obj1=document.getElementById("CareProvType");
	if (lu[0]&&obj)  obj.value=lu[0];
	if (lu[4]&&obj1)  obj1.value=lu[4];



}



document.body.onload = DocumentLoadHandler;

