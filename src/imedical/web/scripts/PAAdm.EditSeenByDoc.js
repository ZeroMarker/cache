// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var admType=document.getElementById('PAADMType');

function setCareProvider() {
	var obj = document.getElementById('CTPCPDesc');
	var objDate = document.getElementById('PAADMSeenDate');
	var objTime = document.getElementById('PAADMSeenTime');
	if ((obj)&&(objDate)&&(objTime)) {
		if ((objDate!="")||(objTime!="")) {
		labelMandatory('CTPCPDesc')
		labelMandatory('PAADMSeenDate')
		labelMandatory('PAADMSeenTime')
		}
	}
}



function MRCIDDescLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById('MRCIDDesc');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('BODARDesc');
	if (obj) obj.value=lu[1];
	var obj=document.getElementById('STATDesc');
	if (obj) obj.value=lu[2];
}

function CareProvChangeHandler() {
	var obj = document.getElementById('CTPCPDesc');
	var objDate = document.getElementById('PAADMSeenDate');
	var objTime = document.getElementById('PAADMSeenTime');
	if ((obj)&&(obj.value == "")) {

		// ab 26.03.02 - removed - 23797
		//if (objDate) objDate.value = "";
		//if (objTime) objTime.value = "";
		//REMOVED:  LOG 19645
		//} else {
			//if (objDate) objDate.value = SetCurrentDate();
			//if (objTime) objTime.value = SetCurrentTime();
		//}
		var objPractFlag1= document.getElementById('PractFlag1');
		if (objPractFlag1) { objPractFlag1.checked=false; }
		PractFlag1Cl();
	}
}



function CareProvLookUpSelect(str) {
	//var lu = str.split("^");
	//CareProvChangeHandler();

}

function CTPCPDescSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById('Location')
	if ((obj)&&(lu[2]!="")) obj.value=lu[2];
	var obj=document.getElementById("LocationID");
	if ((obj)&&(lu[4]!="")) obj.value = lu[4];
	var obj=document.getElementById('HOSPDesc')
	if (obj) obj.value=lu[5];
	var objPractFlag1= document.getElementById('PractFlag1');
	if (objPractFlag1) {
	if (lu[15]=="Y") { objPractFlag1.checked=true; }
	if (lu[15]!="Y") { objPractFlag1.checked=false; }
	}
	PractFlag1Cl();

}

function SetCurrentDate() {
	var today = new Date();
	return ReWriteDate(today.getDate(),today.getMonth()+1,today.getYear());
}

function SetCurrentTime() {
	var now = new Date();
	return ReWriteTime(now.getHours(),now.getMinutes(),now.getSeconds());
}

function UpdateClickHandler() {
	var msg = "";
	var obj = document.getElementById('CTPCPDesc');
	if ((obj) && (obj.value != "")) {
		var obj = document.getElementById('PAADMSeenDate');
		if ((obj)&&(obj.value == "")) {
			msg += "\'" + t['PAADMSeenDate'] + "\' " + t['XMISSING'] + "\n";
		}
		var obj = document.getElementById('PAADMSeenTime');
		if ((obj)&&(obj.value == "")) {
			msg += "\'" + t['PAADMSeenTime'] + "\' " + t['XMISSING'] + "\n";
		}
	}
	if (msg != "") {
		alert(msg);
		return false;
	}
	return update1_click();
}


function UpdateAll() {
	if (!checkMandatoryFields()) { return false; }
	if (admType.value!="E") {alert(t['InvalidAdmType']); return false;}
	return update1_click();
}

function PractFlag1Clhitter() {
	if (!checkMandatoryFields()) { return false; }
	if (admType.value!="E") {alert(t['InvalidAdmType']); return false;}
	return PractDetail_click();
}

function BodyLoadHandler() {

	setCareProvider()

	if (admType.value!="E") alert(t['InvalidAdmType']);

	var obj=document.getElementById('CTPCPDesc');
	if (obj) obj.onblur=CareProvChangeHandler;

	var obj=document.getElementById('PAADMSeenDate');
	if (obj) obj.onblur=StartDateBlurHandler;

	PractFlag1Cl();
	var obj=document.getElementById("PractFlag1");
	if (obj) obj.onclick=PractFlag1Cl;
	//var obj=document.getElementById('update1');
	//if (obj) obj.onclick=UpdateClickHandler;

	var obj=document.getElementById('update1');
	if (obj) obj.onclick=UpdateAll;
}

function PractFlag1Cl() {
	var obj=document.getElementById("PractFlag1");
	var objLINK=document.getElementById("PractDetail");
	
	if ((obj)&&(obj.checked)) {
		if (objLINK) {
		objLINK.disabled=false;
		objLINK.onclick=PractFlag1Clhitter;
		}
		}
		else {
		if (objLINK){
		objLINK.disabled=true;
		objLINK.onclick=LinkDisable;
		}
		}
		
}

function StartDateBlurHandler(e) {
	var eobj=websys_getSrcElement(e);
	if (eobj) {
		var obj=document.getElementById("TRANSStartDateH");
		if ((obj)&&(eobj.value!="")) obj.value=DateStringTo$H(eobj.value);
		if ((obj)&&(eobj.value=="")) obj.value=obj.defaultValue;
	}
}

function checkMandatoryFields() {

	var msg="";
	var obj=document.getElementById('CTPCPDesc');
	var objDate=document.getElementById('PAADMSeenDate');
	var objTime=document.getElementById('PAADMSeenTime');

	if (((obj)&&(obj.value!=""))||((objDate)&&(objDate.value!=""))) {
		if ((objTime)&&(objTime.value=="")) {
		msg += "\'" + t['PAADMSeenTime'] + "\' " + t['XMISSING'] + "\n";
		}
	}
	if (((obj)&&(obj.value!=""))||((objTime)&&(objTime.value!=""))) {
		if ((objDate)&&(objDate.value=="")) {
		msg += "\'" + t['PAADMSeenDate'] + "\' " + t['XMISSING'] + "\n";
		}
	}
	if (((objDate)&&(objDate.value!=""))||((objTime)&&(objTime.value!=""))) {
		if ((obj)&&(obj.value=="")) {
		msg += "\'" + t['CTPCPDesc'] + "\' " + t['XMISSING'] + "\n";
		}
	}

	if (msg != "") {
		alert(msg)
		return false;
		} else {
		return true;
	}

}

function referredToLookUp(str) {
	var lu = str.split("^");
	var objREFDEPDesc=document.getElementById("REFDEPDesc");
	if (objREFDEPDesc) { objREFDEPDesc.value=lu[0]; }	
	ReplaceHiddenCodeGlobal(16,lu[2],lu[3]);
	try {
		Custom_referredToLookUp(str);
	} catch(e) { 
		}	finally  {
	}
}

function ReplaceHiddenCodeGlobal(piece,val1,val2) {
	var obj=document.getElementById('HiddenCodes');
	if (obj) {
		var hiddenCodes=obj.value.split("^");
		var vsarray=new Array();
		vsarray[0]=val1;
		vsarray[1]=val2;
		var vts=vsarray.join("||");
		hiddenCodes[piece]=vts;
		obj.value=hiddenCodes.join("^");
	}
}
function LocationChangeHandler(str) {
	try {
		CustomLocationChangeHandler(str);
	} catch(e) {
		var lu = str.split("^");
		if (lu[1]!="") {
			var obj=document.getElementById("Location");
			if (obj) obj.value = lu[1];
			var obj=document.getElementById("LocationID");
			if (obj) obj.value = lu[3];
			var obj=document.getElementById('HOSPDesc');
			if (obj) obj.value = lu[6];
			
		}
	}
}

document.body.onload = BodyLoadHandler;