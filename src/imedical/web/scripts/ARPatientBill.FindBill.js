// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function SetAdmissionType() {
	var arrItems = new Array();
	var types="";
	var lst = document.getElementById("AdmissionType");
	var numberchosen=0
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			if (lst.options[j].selected) {
				numberchosen++;
				types = types + lst.options[j].value + "^"
				if (lst.options[j].value=="O") {
					var obj=document.getElementById("CurrAppts");
					if (obj) obj.value=1;
				}
			}
		}
		types=types.substring(0,(types.length-1));
		var obj=document.getElementById("SelAdmissionType");
		if (obj) obj.value=types;
	}
}

function LookupAdmLoc(str) {
	//alert(str);
	lu=str.split("^");
	var objAdmLocID=document.getElementById("AdmLocID");
	if (objAdmLocID) objAdmLocID.value=lu[1];
}

function BlurHandlerAdmLoc() {
	var obj=document.getElementById("AdmLoc");
	var objAdmLocID=document.getElementById("AdmLocID");
	if ((obj)&&(obj.value=="")&&(objAdmLocID)) objAdmLocID.value="";
}

function BlurHandlerAdmDateFrom() {
	var obj=document.getElementById("AdmDateFrom");
}

function BlurHandlerAdmDateTo() {
	var obj=document.getElementById("AdmDateTo");
}
function BodyLoadHandler() {
	var obj=document.getElementById("ToBill");
	if (obj) obj.checked=true;
	var obj=document.getElementById("Billed");
	if (obj) obj.checked=true;
	var obj=document.getElementById("Outstanding");
	if (obj) obj.checked=true;
	var obj=document.getElementById("Complete");
	if (obj) obj.checked=true;
	
	var obj=document.getElementById("AdmDateFrom");
	if (obj) obj.onblur=BlurHandlerAdmDateFrom;
	var obj=document.getElementById("AdmDateTo");
	if (obj) obj.onblur=BlurHandlerAdmDateTo;
	var obj=document.getElementById("AdmLoc");
	if (obj) obj.onblur=BlurHandlerAdmLoc;
	
	var obj=document.getElementById("AdmissionType");
	if (obj) obj.onchange=SetAdmissionType;
	SetAdmissionType();
	
	obj=document.getElementById('Find');
	if (obj) obj.onclick=FindClickHandler;
	if (tsc['Find']) websys_sckeys[tsc['Find']]=FindClickHandler;
}

function FindClickHandler() {
		SetAdmissionType();
		var RegistrationNo="";
		var objRegistrationNo=document.getElementById("RegistrationNo");
		if (objRegistrationNo) RegistrationNo=objRegistrationNo.value;
		var SelAdmissionType="";
		var objSelAdmissionType=document.getElementById("SelAdmissionType");
		if (objSelAdmissionType) SelAdmissionType=objSelAdmissionType.value;
		if (SelAdmissionType=="") {
			alert(t['SELECT_ADMISSION_TYPE'])
			return false;
		}
		var AdmDateFrom="";
		var objAdmDateFrom=document.getElementById("AdmDateFrom");
		if (objAdmDateFrom) AdmDateFrom=objAdmDateFrom.value;
		var AdmDateTo="";
		var objAdmDateTo=document.getElementById("AdmDateTo");
		if (objAdmDateTo) AdmDateTo=objAdmDateTo.value;
		var AdmLoc="";
		var objAdmLoc=document.getElementById("AdmLoc");
		if (objAdmLoc) AdmLoc=objAdmLoc.value;
		var AdmLocID="";
		var objAdmLocID=document.getElementById("AdmLocID");
		if (objAdmLocID) AdmLocID=objAdmLocID.value;
		var ToBill="";
		var objToBill=document.getElementById("ToBill");
		if ((objToBill)&&(objToBill.checked)) ToBill="Y";
		else ToBill="N";
		var Billed="";
		var objBilled=document.getElementById("Billed");
		if ((objBilled)&&(objBilled.checked)) Billed="Y";
		else Billed="N";
		var Outstanding="";
		var objOutstanding=document.getElementById("Outstanding");
		if ((objOutstanding)&&(objOutstanding.checked)) Outstanding="Y";
		else Outstanding="N";
		var Complete="";
		var objComplete=document.getElementById("Complete");
		if ((objComplete)&&(objComplete.checked)) Complete="Y";
		else Complete="N";
		var BillStatus=Outstanding+"^"+Complete+"^"+ToBill;
	
		var EpisodeNo="";
		var objEpNo=document.getElementById("EpisodeNo");
		if (objEpNo) EpisodeNo=objEpNo.value;

		var url="websys.default.csp?WEBSYS.TCOMPONENT=ARPatientBill.ListAll&Action=Receipting&GroupType=I&ShowPatientBillsOnly=Y&RegistrationNo="+RegistrationNo+"&SelAdmissionType="+SelAdmissionType
		url=url+"&AdmDateFrom="+AdmDateFrom+"&AdmDateTo="+AdmDateTo+"&AdmLocID="+AdmLocID+"&BillStatus="+BillStatus;
		url=url+"&EpisodeNo="+EpisodeNo+"&CONTEXT="+session['CONTEXT'];

		//alert(url);
		websys_createWindow(url,'ListAll','');
}
	
document.body.onload=BodyLoadHandler;