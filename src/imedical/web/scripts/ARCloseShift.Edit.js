// Copyright (c) 2004 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var objCreateUser = document.getElementById("CLSCreateUserDR")
var objShiftNum = document.getElementById("CLSNumber")
var objOpenBal = document.getElementById("CLSOpeningBalance")
var objCloseBal = document.getElementById("CLSClosingBalance")
var objCloseUser = document.getElementById("CLSCashierClosingDR")
var objChkUser = document.getElementById("CLSCashierCheckDR")
var objStatus = document.getElementById("status")
var objCancel = document.getElementById("CancelShift")
var objReopen = document.getElementById("ReOpen")
var objClose = document.getElementById("CloseShift")
var objDate = document.getElementById("CLSCreateDate")
var objCreate = document.getElementById("CreateShift")
var objCashBal = document.getElementById("CashBal")
	
function BodyOnloadHandler() {
	adjustFields();
	
	if (objCloseBal) objCloseBal.onchange=CheckCashDiff;
	
	if ((objStatus)&&(objStatus.value!="")) refreshTransactions();
	
	if (objCreate) {
		objCreate.onclick=CreateClickHandler;
		if (tsc['CreateShift']) websys_sckeys[tsc['CreateShift']]=CreateClickHandler;
	}
	
	if (objClose) {
		objClose.onclick=CloseClickHandler;
		if (tsc['CloseShift']) websys_sckeys[tsc['CloseShift']]=UpdateClickHandler;
	}
	
	if (objStatus) {
		if ((objStatus.value!="")&&(objStatus.value=="O")) checkCloseBalDiff();
	}	
}

function CheckCashDiff(){
	CLSClosingBalance_changehandler(e)
	
    checkCloseBalDiff();
	
	return true;
}

function CreateClickHandler(evt) {
	if (evtTimer) {
		setTimeout("CreateClickHandler()",400);   //43123: timer needed.
	} else {
		var warnMsg = CheckForAllMendatoryFields();
		if (warnMsg!="") {
			alert(warnMsg);
			return false;
		}
	}
	CreateShift_click();
}

function CloseClickHandler(evt) {
	if (evtTimer) {
		setTimeout("CloseClickHandler()",400);   //43123: timer needed.
	} else {
		var warnMsg = CheckForAllMendatoryFields();
		if (warnMsg!="") {
			alert(warnMsg);
			return false;
		}
	}
	CloseShift_click();
}

function CheckForAllMendatoryFields() {
	var AllGetValue="";
	for (var i=0;i<document.fARCloseShift_Edit.elements.length;i++) {
		if (document.fARCloseShift_Edit.elements[i].id!="") {
			var elemid="c"+document.fARCloseShift_Edit.elements[i].id;
			var elemc=document.getElementById(elemid);
			var elem=document.getElementById(document.fARCloseShift_Edit.elements[i].id);
			if ((elemc) && (elemc.className=="clsRequired")) {
				if ((elem)&&(elem.value=="")) AllGetValue=AllGetValue+ "'" + elemc.innerText + "' "+t['XMISSING']+"\n";
			}
		}
	}
	return AllGetValue;
}

function labelMandatory(fldName) {
	var fld = document.getElementById(fldName);
	fld.className = "";
	var lbl = document.getElementById('c' + fldName)
	if (lbl) {
		lbl.className = "clsRequired";
	}
}

function labelNormal(fld) {
	var lbl = document.getElementById('c' + fld)
	if (lbl) {
		lbl=lbl.className = "";
	}
}

function adjustFields() {
	if ((objShiftNum)&&(objShiftNum.value!="")) {
		objShiftNum.disabled=true;
		objCreate.disabled=true;
		objCreate.click=""
	}
	
	if ((objShiftNum)&&(objShiftNum.value=="")) {
		if (objReopen) {
			objReopen.disabled=true;
			objReopen.onclick="";
		}	
		
		if (objClose) {
			objClose.disabled=true;
			objClose.onclick="";
		}	
		if (objCancel) {
			objCancel.disabled=true;
			objCancel.onclick="";
		}	
		if (objCreateUser) labelMandatory("CLSCreateUserDR")
		if (objOpenBal) labelMandatory("CLSOpeningBalance")
		if (objDate) labelMandatory("CLSCreateDate")
	}
	
	if ((objOpenBal)&&(objOpenBal.value!="")&&(objShiftNum)&&(objShiftNum.value!="")) {
		objOpenBal.disabled=true;
	}
	
	if ((objStatus)&&(objStatus.value=="C")) {
		if (objCloseBal) objCloseBal.disabled=true;
		if (objCloseUser) objCloseUser.disabled=true;
		if (objChkUser) objChkUser.disabled=true;
	}	
	
	if ((objStatus)&&((objStatus.value=="C")||(objStatus.value=="X"))) {
		if (objCancel) {
			objCancel.disabled=true;
			objCancel.onclick="";
		}
		if (objClose) {
			objClose.disabled=true;
			objClose.onclick="";
		}
	}
}

function checkCloseBalDiff() {
	if ((objCashBal)&&(objCloseBal)) {
		if (objCloseBal.value!=objCashBal.value) labelMandatory("CLSNotes");
		else labelNormal("CLSNotes");
	}

}

function refreshTransactions() {
	var objTransFrame=parent.frames[1];
	var objTrasID=objTransFrame.document.location;
	var objID = document.getElementById("ID")
	var objUser = document.getElementById("CashierID")
	
	if (objUser) {var USER=objUser.value;}
	
	if (objID) {var ID=objID.value;}
	
	objTransFrame.document.location="websys.default.csp?WEBSYS.TCOMPONENT=ARCashierTransactions.List&PARREF="+ID+"&USER="+USER;
}

function ShiftLookUpSelect(str) {
	if (str!="") {
		var lu = str.split("^");
		var shiftStr = lu[3];
		var shifts = shiftStr.split("|");
		
		var objDate=document.getElementById('CLSCreateDate');
		if ((objDate)&&(shifts[1]!="")) objDate.value=shifts[1];
		
		var objLoc=document.getElementById('CLSRecLocationDR');
		if ((objLoc)&&(shifts[2]!="")) objLoc.value=shifts[2];
		
		var objOpenBal=document.getElementById('CLSOpeningBalance');
		if ((objOpenBal)&&(shifts[3]!="")) objOpenBal.value=shifts[3];
		
		var objShift=document.getElementById('CLSNumber');
		if ((objShift)&&(shifts[4]!="")) objShift.value=shifts[4];
		
		var objStatus=document.getElementById('CLSStatus');
		if ((objStatus)&&(shifts[5]!="")) objStatus.value=shifts[5];
		
		var objCloseBal=document.getElementById('CLSClosingBalance');
		if ((objCloseBal)&&(shifts[6]!="")) objCloseBal.value=shifts[6];
		
		var objCloseUser=document.getElementById('CLSCashierClosingDR');
		if ((objCloseUser)&&(shifts[7]!="")) objCloseUser.value=shifts[7];
		
		var objCheckUser=document.getElementById('CLSCashierCheckDR');
		if ((objCheckUser)&&(shifts[8]!="")) objCheckUser.value=shifts[8];
		
		var objNotes=document.getElementById('CLSNotes');
		if ((objNotes)&&(shifts[9]!="")) objNotes.value=shifts[9];
	}	
	
}

document.body.onload=BodyOnloadHandler;