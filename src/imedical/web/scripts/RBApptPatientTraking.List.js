// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 


var tbl=document.getElementById("tRBApptPatientTraking_List");
var f=document.getElementById("fRBApptPatientTraking_List");
var RescID=f.elements['ResID'].value;
var dt=f.elements['DateNow'].value;

	
function BodyLoadHandler() {
	//Highlight the Next patient to be seen
	highlightNextPatient();
}

function highlightNextPatient() {
	for (var i=1;i<tbl.rows.length;i++) {
		var eSrc=f.elements['PatStatusz'+i];
		var obj=getRow(eSrc)
		if (eSrc.value=="N") {
			obj.style.backgroundColor="LightGreen";
		}
	}
}

function refreshEdit(tEvent,ApptID,TimeType,ClinicType) {
	var CareProvider="";
	var objCPId=document.getElementById("CareProvider");	
	if (objCPId) CareProvider=objCPId.value;
	
	var ResID="";
	var objResId=document.getElementById("ResID");	
	if (objResId) ResID=objResId.value;

	//Log 62342 - 29.01.2007 - validations
	var CPType="";
	var objCPType=document.getElementById("CP1or2");	
	if (objCPType) CPType=objCPType.value;
	
	if ((CPType=="1")&&((TimeType=="3")||(TimeType=="4"))) {
		alert(t["CP1_NO_CHANGE"]);
		return false;
	}	
	if ((CPType=="2")&&((TimeType=="1")||(TimeType=="2"))) {
		alert(t["CP2_NO_CHANGE"]);
		return false;
	}	
	if ((CPType=="2")&&(ClinicType=="1")) {
		alert(t["CP2_NOT_ALLOWED"]);
		return false;
	}
	// End Log 62342 
	
	var ret=tkMakeServerCall("web.RBAppointment","websysSaveCareProvTimes",tEvent,ApptID,CareProvider,TimeType,ResID);
	if (ret==1) alert(t["NO_ARRIVE_NEXT"]);
	if (ret==2) alert(t["CANNOT_DEPART"]);
	if (ret==3) alert(t["WITH_CP1"]);
	if (ret==4) alert(t["WITH_CP2"]);
	top.frames["TRAK_main"].frames["PatTrack"].location.reload();
}

function SelectRowHandler() {
	var ApptID,CareProv; 
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var eSrcAry=eSrc.id.split("z");
	if (eSrcAry.length>0) {
		var row=eSrcAry[1];
		if ((eSrcAry[0]=="CP1Arrive")||(eSrcAry[0]=="CP1Depart")||(eSrcAry[0]=="CP2Arrive")||(eSrcAry[0]=="CP2Depart")) {
			var objApptID=document.getElementById("ApptIDz"+row);
			if (objApptID) ApptID=objApptID.value;
			
			var objCareProv=document.getElementById("CareProvider");
			if (objCareProv) CareProv=objCareProv.value;
			
			eSrc.href = eSrc.href+'&ApptID='+ApptID+'&CareProvider='+CareProv;
			return true;
		}
	}

}	

function removeLinks() {
	objitem=document.getElementById("item");
	alert(objitem);
	if (objitem) {
			objitem.disabled=true;
			objitem.className="clsRequired";
			objitem.onclick=LinkDisable;
		}
	for (var i=1;i<tbl.rows.length;i++) {
		var objtabitem=document.getElementById("tabitemz"+i);
		alert(objtabitem);
		
		if (objtabitem) {
			objtabitem.disabled=true;
			objtabitem.style.color="black";
			objtabitem.onclick=LinkDisable;
		}
	}
}

function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);

	if (el.disabled||el.id=="") return false;

	return true;
}



document.body.onload=BodyLoadHandler;