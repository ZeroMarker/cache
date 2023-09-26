// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.


function DocumentLoadHandler(){
	obj=document.getElementById('update1');
	if (obj) obj.onclick= UpdateClickHandler;

	var obj = document.getElementById('RBOPStatus');
	if (obj) obj.onblur=CheckStatus;

	var obj = document.getElementById('RBOPDateArrived');
	if (obj) obj.onblur=CheckDateArrived;

	var obj = document.getElementById('RBOPTimeArrived');
	if (obj) obj.onblur=CheckTimeArrived;

	//Disable DateArrived and TimeArrived initially onload
	DoInitStatusValidation();

}

function labelMandatory(fld) {
	var lbl = document.getElementById('c' + fld)
	if (lbl) {
		lbl.className = "clsRequired";
	}
}

function labelNormal(fld) {
	var lbl = document.getElementById('c' + fld)
	if (lbl) {
		lbl.className = "";
	}
}

function DisableField(fldName,delVal) {
	var lbl = ('c'+fldName);
	var fld = document.getElementById(fldName);
	if (fld) {
		if (delVal) fld.value = "";
		fld.disabled = true;
		fld.className = "clsDisabled";
		if (lbl) lbl = lbl.className = "";
	}
}

function EnableField(fldName) {
	var lbl = ('c'+fldName);
	var fld = document.getElementById(fldName);
	if (fld) {
		fld.disabled = false;
		fld.className = "";
		if (lbl) lbl = lbl.className = "";
	}
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

function CheckDateArrived(){
	DoDateTimeFutureValidation("RBOPDateArrived","RBOPTimeArrived");
}

function CheckTimeArrived(){
	DoDateTimeFutureValidation("RBOPDateArrived","RBOPTimeArrived");
}

//Log 45085
//Disable DateArrived and TimeArrived initially onload
function DoInitStatusValidation(){
	var dateAObj = document.getElementById("RBOPDateArrived");
	var timeAObj = document.getElementById("RBOPTimeArrived");

	if(dateAObj){
		DisableField(dateAObj.id,false);
	}
	if(timeAObj){
		DisableField(timeAObj.id,false);
	}
}

function CheckStatus() {
	var obj = document.getElementById('RBOPStatus');
	if ((obj)&&(obj.value=="")) {
		var objCancelReason= document.getElementById('SUSPDesc');
		var objcCancelReason= document.getElementById('cSUSPDesc');
		var objNewStatus = document.getElementById('NewStatus');
		if (objcCancelReason) objcCancelReason.className = "";
		if (objCancelReason) { objCancelReason.className = "";objCancelReason.value="";}
		if (objNewStatus) objNewStatus.value="";

		//Log 45085 - If RBOPStatus is blank make Date/Time Arrived blank
		var dateAObj = document.getElementById("RBOPDateArrived");
		var timeAObj = document.getElementById("RBOPTimeArrived");
		var cdateAObj = document.getElementById("cRBOPDateArrived");
		var ctimeAObj = document.getElementById("cRBOPTimeArrived");
		if(dateAObj && cdateAObj && cdateAObj.className == "clsRequired"){
			DisableField(dateAObj.id,true);
			labelNormal(dateAObj.id);
		}
		if(timeAObj && ctimeAObj && ctimeAObj.className == "clsRequired"){
			DisableField(timeAObj.id,true);
			labelNormal(timeAObj.id);
		}
	}
}

function NewStatusLookUp(str) {
	var lu = str.split("^");
	//alert(str);
	var obj = document.getElementById('RBOPStatus');
	if (obj) obj.value=lu[0];
	var obj = document.getElementById('NewStatus');
	if (obj) obj.value=lu[2];
	var objCancelReason= document.getElementById('SUSPDesc');
	var objcCancelReason= document.getElementById('cSUSPDesc');
	var objCancelReason2= document.getElementById('RBOPCancelReason');
	//alert(lu[2]);
	if ((lu[2]=="X")&&(objCancelReason)) {
		//alert("found");
		objCancelReason.className = "clsRequired";
		if (objcCancelReason) objcCancelReason.className = "clsRequired";
	} else {
		objCancelReason.className = "";
		objCancelReason.value = "";
		if (objcCancelReason) objcCancelReason.className = "";
		if (objCancelReason2) objCancelReason2.value="";
	}

	//Log 45085 - If NewStatus is D and Date/Time Arrived are blank, then make them mandatory
	var dateAObj = document.getElementById("RBOPDateArrived");
	var timeAObj = document.getElementById("RBOPTimeArrived");
	var cdateAObj = document.getElementById("cRBOPDateArrived");
	var ctimeAObj = document.getElementById("cRBOPTimeArrived");
	if(obj && obj.value == "D"){
		if(dateAObj && dateAObj.value == ""){
			EnableField(dateAObj.id);
			labelMandatory(dateAObj.id);
		}
		if(timeAObj && timeAObj.value == ""){
			EnableField(timeAObj.id);
			labelMandatory(timeAObj.id);
		}
	}
	//If NewStatus is not D, then make Date/Time Arrived blank
	if(obj && obj.value != "D" && dateAObj && cdateAObj && cdateAObj.className == "clsRequired"){
		DisableField(dateAObj.id,true);
		labelNormal(dateAObj.id);
	}
	if(obj && obj.value != "D" && timeAObj && ctimeAObj && ctimeAObj.className == "clsRequired"){
		DisableField(timeAObj.id,true);
		labelNormal(timeAObj.id);
	}
}

function UpdateClickHandler(e) {
	var objCancelReason= document.getElementById('SUSPDesc');
	if ((objCancelReason)&&(objCancelReason.value=="")&&(objCancelReason.className == "clsRequired")) {
		alert( t['CancelReasonMissing']);
		return false;
	}
	var dateAObj=document.getElementById("RBOPDateArrived");
	var timeAObj=document.getElementById("RBOPTimeArrived");
	var cdateAObj=document.getElementById("cRBOPDateArrived");
	var ctimeAObj=document.getElementById("cRBOPTimeArrived");
	if ((dateAObj)&&(cdateAObj)&&(dateAObj.value=="")&&(cdateAObj.className == "clsRequired")) {
		alert( t[dateAObj.id] + " " + t['XMISSING']);
		return false;
	}
	if ((timeAObj)&&(ctimeAObj)&&(timeAObj.value=="")&&(ctimeAObj.className == "clsRequired")) {
		alert( t[timeAObj.id] + " " + t['XMISSING']);
		return false;
	}

	var objNewStat= document.getElementById('NewStatus');
	var objCurStat= document.getElementById('HCurrentStatus');
	var objCancelEp= document.getElementById('CancelEpisodeFlag');
	if (objNewStat.value=="R" && objCurStat.value=="B") {
		var ret=confirm(t["CancelEpisode"])
		objCancelEp.value=ret
	}
	return update1_click();
}

function OutPatCancel(msg1,msgAPPT,info) {
	var frm=document.forms['fRBOperatingRoom_ChangeStatus'];
	var cnfmsg=msg1+"  "+t["CoverApptData"]+":"+msgAPPT+"\n"+t["OutPatCancel"];
	if (info==1) { cnfmsg=cnfmsg+"\n"+t["BookingAdd"] }
	if (confirm(cnfmsg)) {
		document.getElementById('NoCancel').value=0
		if (frm) frm.TOVERRIDE.value=1;
		//SB 17/04/07 (63313)
		var str=document.getElementById('WLDetails').value
		if (str!="") {
			var wldet = str.split("^");
			var url="pawaitlistadm.csp?&PARREF="+wldet[0]+"&ID="+wldet[1]+"&PatientID="+wldet[2]+"&CONTEXT=W200"
			window.opener.open(url,"","top=20,width=800,height=600,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes");
		}
	} else {
		document.getElementById('NoCancel').value=1
		if (frm) frm.TOVERRIDE.value=1;
	}
}


document.body.onload = DocumentLoadHandler;