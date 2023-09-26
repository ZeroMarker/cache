// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function DocumentLoadHandler() {
	obj=document.getElementById('Find');
	if (obj) obj.onclick=FindClickHandler;

	obj=document.getElementById('BulkTrans');
	if (obj) obj.onclick=BulkTransClickHandler;

	obj=document.getElementById('AutoBulkTransEdit');
	if (obj) obj.onclick=AutoBulkTransEditClickHandler;

	//Log 31312 BC 18-12-2002
	obj=document.getElementById('SERDesc');
	if (obj) obj.onblur=ServiceTextChangeHandler

	// LOG 28034 BC 3-9-2002
	obj=document.getElementById('BulkTransferAll');
	if (obj) obj.onclick=BulkTransAllClickHandler;
	// LOG 28034 BC 3-9-2002
	obj=document.getElementById('AutoBulkTransAll');
	if (obj) obj.onclick=AutoBulkTransAllClickHandler;

	//obj=document.getElementById('HoldFlag');
	//if (obj) obj.checked=true;

	//var obj = document.getElementById('CTLOCDesc');
	//if (obj) obj.value=" ";
	//var obj = document.getElementById('RESDesc');
	//if (obj) obj.value=" ";
	obj=document.getElementById('doFind');
	if ((obj)&&(obj.value!="")) FindClickHandler();
	if (tsc['Find']) websys_sckeys[tsc['Find']]=FindClickHandler;

	obj=document.getElementById('CTLOCDesc');
	//if (obj) obj.onchange=LocationChangeHandler;
	//Log 33903 BC 14-3-2003 Changed from onchange to onblur so broker works
	if (obj) obj.onblur=LocationChangeHandler;

	obj=document.getElementById('RESDesc');
	//if (obj) obj.onchange=ResourceChangeHandler;
	//Log 33903 BC 14-3-2003 Changed from onchange to onblur so broker works
	if (obj) obj.onblur=ResourceChangeHandler;

	obj=document.getElementById('HOSPDesc');
	if (obj) obj.onblur=HospitalChangeHandler;
	

	//EZ log 65004
	obj=document.getElementById('sesstype');
	if (obj) obj.onblur=sesstypeChangeHandler;

	websys_firstfocus();
}

/*function BulkTransAutoClickHandler(e) {
	var objTDate=document.getElementById('BulkTransAutoDate');
	var objBulkList=document.getElementById('BulkApptList');

	if ((objTDate)&&(objTDate.value!="")) {
		if ((objBulkList)&&(objBulkList.value=="")) {
			alert(t["RBNoApptSelected"]);
			return false;
		}
	} else {
		alert("Please enter a Transfer Date")
		return false;
	}

	return BulkTransAuto_click();
}*/

function AutoBulkTransEditClickHandler(e) {
	//var objTDate=document.getElementById('BulkTransAutoDate');
	var objBulkList=document.getElementById('BulkApptList');
	if (!CheckForMandatoryReason("APPTReasonForTransferDR")) {return false;};
	//Log 39218 BC 30-9-2003 Refind checked appointments
	if (objBulkList) ApptList=objBulkList.value;
	var obj = document.getElementById('LocId');
	if (obj) Loc=obj.value;
	var obj = document.getElementById('ResId');
	if (obj) Res=obj.value;
	if (ApptList=="") ApptList=GetSelected();
	if (ApptList=="") {
		alert(t["RBNoApptSelected"]);
		return false;
	}
	if (!CheckInvalidFields()) {
		return false
	}

	if (document.getElementById("ServId")) Serv = document.getElementById("ServId").value;
	if (document.getElementById("SS_ServId")) SS_Serv = document.getElementById("SS_ServId").value;
		// Log 37179 BC 27-8-2003 three new fields on Auto Bulk Tansfer
	if (document.getElementById("APPTReasonForTransferDR")) {var APPTReasonForTransferDR = document.getElementById("APPTReasonForTransferDR").value;} else {var APPTReasonForTransferDR=""}
	if ((document.getElementById("PrintPatientLetter"))&&(document.getElementById("PrintPatientLetter").checked)) {var PrintPatientLetter = "on";} else {var PrintPatientLetter=""}
	if ((document.getElementById("PrintGPLetter"))&&(document.getElementById("PrintGPLetter").checked)) {var PrintGPLetter ="on";} else {var PrintGPLetter=""}
	//alert("&ServId="+Serv);
	//Log 31317 BC Service Sets in Auto Bulk Transfer
	//var lnk="websys.default.csp?WEBSYS.TCOMPONENT=RBAppointment.AutoBulkTrans.Edit&ApptList="+ApptList+"&Res="+Res+"&Loc="+Loc+"&ServId="+Serv+"&SS_ServId="+SS_Serv;
	var lnk="rbappointment.automaticbulktransfer.csp?ApptList="+ApptList+"&Res="+Res+"&Loc="+Loc+"&ServId="+Serv+"&SS_ServId="+SS_Serv+"&APPTReasonForTransferDR="+APPTReasonForTransferDR+"&PrintPatientLetter="+PrintPatientLetter+"&PrintGPLetter="+PrintGPLetter;
	//Log: 59598, 03-07-2006 BC: add "status=yes"
	window.open(lnk,"frmAutoBulkTransEdit","top=50,left=50,width=400,height=350,resizable,scrollbars=yes,status=yes");
	return false;
}

function BulkTransClickHandler(e) {
	var obj=document.getElementById('BulkApptList');
	if (obj) BulkApptList=obj.value;
	//Log 39218 BC 30-9-2003 Refind checked appointments
	if (BulkApptList=="") BulkApptList=GetSelected();
	;
	if (BulkApptList=="") {
		alert(t["RBNoApptSelected"]);
		return false;
	}
	if (!CheckInvalidFields()) {
		return false
	}
	if (!CheckForMandatoryReason("APPTReasonForTransferDR")) {return false;};
		// Log 37179 BC 27-8-2003 three new fields on Auto Bulk Tansfer
	if (document.getElementById("APPTReasonForTransferDR")) {var APPTReasonForTransferDR = document.getElementById("APPTReasonForTransferDR").value;} else {var APPTReasonForTransferDR=""}
	if ((document.getElementById("PrintPatientLetter"))&&(document.getElementById("PrintPatientLetter").checked)) {var PrintPatientLetter = "on";} else {var PrintPatientLetter=""}
	if ((document.getElementById("PrintGPLetter"))&&(document.getElementById("PrintGPLetter").checked)) {var PrintGPLetter ="on";} else {var PrintGPLetter=""}
	//var lnk = "rbappointmentframe.popup.csp?BulkApptList="+BulkApptList;
	var lnkobj=document.getElementById('BulkTrans');
	lnk = lnkobj.href + "&BulkApptList="+BulkApptList+"&APPTReasonForTransferDR="+APPTReasonForTransferDR+"&PrintPatientLetter="+PrintPatientLetter+"&PrintGPLetter="+PrintGPLetter;
	//alert(lnk)
	var swidth=screen.availWidth-60;
	if (swidth>750) swidth=750
	var sheight=screen.availHeight-60;
	if (sheight>500) sheight=500
	//Log: 59598, 03-07-2006 BC: add "status=yes"
	//alert(lnk)
	window.open(lnk,"frmAppointmentFrame","top=10,left=10,width="+swidth+",height="+sheight+",resizable,status=yes");
	//websys_createWindow(lnk,"frmAppointmentFrame","width=800,height=600");
	if (obj) obj.value="";
	return false;
}

function CTLOCDescLookUpSelect(str) {
	//LOG 23906 10/10/02 RC
	//Booked appointments not displaying on search in 'Bulk Transfer' menu.
	//This javascript function and the one below was just putting the wrong values into the wrong textboxes
	//Also made it so that if the resource is selected before the location, the resource is not necessarily erased.
	var lu = str.split("^");
	var obj=document.getElementById('RESDesc');
	if ((obj)&&(obj.value!="")&&(lu[5]!="")) obj.value=lu[5].split("*")[0];
	var obj=document.getElementById('ResId');
	if ((obj)&&(obj.value!="")&&(lu[5]!="")) obj.value=lu[5].split("*")[1];
	var obj=document.getElementById('CTLOCDesc');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('LocId');
	if (obj) obj.value=lu[1];
	var obj=document.getElementById('HOSPDesc')
	if (obj) obj.value=lu[4];
	var obj=document.getElementById('HOSPId')
	if (obj) obj.value=lu[7];
}

function RESDescLookUpSelect(str) {
	//LOG 23906 10/10/02
	var lu = str.split("^");
	//alert(lu);
	var obj=document.getElementById('RESDesc');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('ResId');
	if (obj) obj.value=lu[2];
	//var obj=document.getElementById('CTLOCDesc');
	//if (obj && obj.value!="") obj.value=lu[3];
	//var obj=document.getElementById('LocId');
	//if (obj && obj.value!="") obj.value=lu[3];
}

function FindClickHandler(e) {

if (CheckMandatoryFields()) {
	var HoldFlag=document.getElementById("HoldFlag");
	var BookedFlag=document.getElementById("BookedFlag");
	var ArrivedFlag=document.getElementById("ArrivedFlag");
	var TransFlag=document.getElementById("TransFlag");
	var CancelledFlag=document.getElementById("CancelledFlag");
	var CompleteFlag=document.getElementById("CompleteFlag");
	var NAFlag=document.getElementById("NAFlag");
	//log 60308 13/10/2006 ElenaZ include Departed in search
	var DepartedFlag=document.getElementById("DepartedFlag");


	var BulkApptList=document.getElementById("BulkApptList");
	if (BulkApptList) BulkApptList.value=""
	//alert("Alert")
	//
	//Build list if selected appointment statuses
    	var SearchApptStatus = ""

    	if ((HoldFlag) && (HoldFlag.checked)) SearchApptStatus = SearchApptStatus + "HJ"
	if ((BookedFlag) && (BookedFlag.checked)) SearchApptStatus = SearchApptStatus + "IP"
    	if ((TransFlag) && (TransFlag.checked)) SearchApptStatus = SearchApptStatus + "T"
   	if ((CancelledFlag) && (CancelledFlag.checked)) SearchApptStatus = SearchApptStatus + "X"
    	if ((CompleteFlag) && (CompleteFlag.checked)) SearchApptStatus = SearchApptStatus + "C"
    	if ((NAFlag) && (NAFlag.checked)) SearchApptStatus = SearchApptStatus + "N"
    	if ((ArrivedFlag) && (ArrivedFlag.checked)) SearchApptStatus = SearchApptStatus + "A"
	//log 60308 13/10/2006 ElenaZ include Departed in search
	if ((DepartedFlag) && (DepartedFlag.checked)) SearchApptStatus = SearchApptStatus + "D"
    	//alert(SearchApptStatus)
	//Log 38107 BC 19-8-2003 Fix the "T" in date field error
	if (document.getElementById("sdate")) {
		objDate = document.getElementById("sdate");
		if (objDate) ConvertTDate(objDate);
		sdate = objDate.value;
	}
	if (document.getElementById("edate")) {
		objDate = document.getElementById("edate");
		if (objDate) ConvertTDate(objDate);
		edate = objDate.value;
	}
	if (document.getElementById("stime")) {
		objSTime = document.getElementById("stime");
  		if (objSTime) ConvNTime(objSTime);
  		stime =  objSTime.value;
  	}
  	if (document.getElementById("etime")) {
  		objSTime = document.getElementById("etime");
  		if (objSTime) ConvNTime(objSTime);
  		etime = objSTime.value;
  	}

	if (document.getElementById("LocId")) Loc = document.getElementById("LocId").value;
	if (document.getElementById("ResId")) Res = document.getElementById("ResId").value;
	if (document.getElementById("ServId")) Serv = document.getElementById("ServId").value;
	if (document.getElementById("HOSPId")) Hosp = document.getElementById("HOSPId").value;
	if (document.getElementById("SS_ServId")) SS_Serv = document.getElementById("SS_ServId").value;
	var PatientID=document.getElementById("PatientID").value;
	if (document.getElementById("SessionId")) SessionId = document.getElementById("SessionId").value; //65004
	
	//alert("websys.default.csp?WEBSYS.TCOMPONENT=RBAppointment.BulkTransfer.List&TWKFL=&TWKFLI=&LocId="+Loc+"&ResId="+Res+"&sdate="+sdate+"&edate="+edate+"&status="+SearchApptStatus+"&stime="+stime+"&etime="+etime+"&ServId="+Serv+"&SSServId="+SS_Serv+"&PatientID="+PatientID+"&HospID="+Hosp+"&CONTEXT="+session['CONTEXT']+"&SessionId="+SessionId);
	// Log 61750 28/11/06 EZ bottom screen is losing its context
	// added to the end of line +"&CONTEXT="+session['CONTEXT'];
	//log 65004 13/10/2007 ElenaZ include session type in search
	//added to the end of line +"&SessionId="+SessionId;
	parent.frames["RBBulkTransList"].location="websys.default.csp?WEBSYS.TCOMPONENT=RBAppointment.BulkTransfer.List&TWKFL=&TWKFLI=&LocId="+Loc+"&ResId="+Res+"&sdate="+sdate+"&edate="+edate+"&status="+SearchApptStatus+"&stime="+stime+"&etime="+etime+"&ServId="+Serv+"&SSServId="+SS_Serv+"&PatientID="+PatientID+"&HospID="+Hosp+"&CONTEXT="+session['CONTEXT']+"&SessionId="+SessionId;
	//return Find_click();
} else {
	return;
}
}


function CheckMandatoryFields() {
	Loc = document.getElementById("LocId").value;
	Res = document.getElementById("ResId").value;
	var msg="";
	//SB 11/03/03 (32500): Resource is now the only mandatory field
	//if ((Loc.value!="")&&(Res.value!="")) {
	if (Res.value!="") {
		/*
		var obj = document.getElementById('CTLOCDesc');
		if ((obj)&&(obj.value=="")) {
			msg += "\'" + t['CTLOCDesc'] + "\' " + t['XMISSING'] + "\n";
		}
		*/
		var obj = document.getElementById('RESDesc');
		if ((obj)&&(obj.value=="")) {
			msg += "\'" + t['RESDesc'] + "\' " + t['XMISSING'] + "\n";
		}

		if (msg=="") {
			return true;
		} else {
			alert(msg)
			return false;
		}
	} else {
		return true;
	}
}

// LOG 28034 BC 3-9-2002
function AutoBulkTransAllClickHandler(e) {
if ((CheckMandatoryFields())&&(CheckForMandatoryReason("APPTReasonForTransferDR"))) {
	if (!CheckInvalidFields()) {
		return false
	}
	var HoldFlag=document.getElementById("HoldFlag");
	var BookedFlag=document.getElementById("BookedFlag");
	var ArrivedFlag=document.getElementById("ArrivedFlag");
	var TransFlag=document.getElementById("TransFlag");
	var CancelledFlag=document.getElementById("CancelledFlag");
	var CompleteFlag=document.getElementById("CompleteFlag");
	var NAFlag=document.getElementById("NAFlag");
	var BulkApptList=document.getElementById("BulkApptList");
		// Log 37179 BC 27-8-2003 three new fields on Auto Bulk Tansfer
	if (document.getElementById("APPTReasonForTransferDR")) {var APPTReasonForTransferDR = document.getElementById("APPTReasonForTransferDR").value;} else {var APPTReasonForTransferDR=""}
	if ((document.getElementById("PrintPatientLetter"))&&(document.getElementById("PrintPatientLetter").checked)) {var PrintPatientLetter = "on";} else {var PrintPatientLetter=""}
	if ((document.getElementById("PrintGPLetter"))&&(document.getElementById("PrintGPLetter").checked)) {var PrintGPLetter ="on";} else {var PrintGPLetter=""}
	if (BulkApptList) BulkApptList.value=""
	//alert("Alert")
	//
	//Build list if selected appointment statuses
    	var SearchApptStatus = ""

    	if ((HoldFlag) && (HoldFlag.checked)) SearchApptStatus = SearchApptStatus + "HJ"
	if ((BookedFlag) && (BookedFlag.checked)) SearchApptStatus = SearchApptStatus + "IP"
    	if ((TransFlag) && (TransFlag.checked)) SearchApptStatus = SearchApptStatus + "T"
   	if ((CancelledFlag) && (CancelledFlag.checked)) SearchApptStatus = SearchApptStatus + "X"
    	if ((CompleteFlag) && (CompleteFlag.checked)) SearchApptStatus = SearchApptStatus + "C"
    	if ((NAFlag) && (NAFlag.checked)) SearchApptStatus = SearchApptStatus + "N"
    	if ((ArrivedFlag) && (ArrivedFlag.checked)) SearchApptStatus = SearchApptStatus + "A"
	//alert(SearchApptStatus)

	if (document.getElementById("LocId")) Loc = document.getElementById("LocId").value;
	if (document.getElementById("ResId")) Res = document.getElementById("ResId").value;
	if (document.getElementById("ServId")) Serv = document.getElementById("ServId").value;
	if (document.getElementById("SS_ServId")) SS_Serv = document.getElementById("SS_ServId").value;
	if (document.getElementById("sdate")) sdate = document.getElementById("sdate").value;
	if (document.getElementById("edate")) edate = document.getElementById("edate").value;
	if (document.getElementById("stime")) stime = document.getElementById("stime").value;
	if (document.getElementById("etime")) etime = document.getElementById("etime").value;
	if (document.getElementById("PatientID")) patid=document.getElementById("PatientID").value;
	if (document.getElementById("SessionId")) SessionId = document.getElementById("SessionId").value; //65004
	var APPTReasonForTransferDR=""
	if (document.getElementById("APPTReasonForTransferDR")) APPTReasonForTransferDR = document.getElementById("APPTReasonForTransferDR").value;
	var obj = document.getElementById('CTLOCDesc');
	if (obj) Locdesc=obj.value;
	var obj = document.getElementById('RESDesc');
	if (obj) Resdesc=obj.value;

	var lnk = "rbautobulktransall.csp?LocId="+Loc+"&ResId="+Res+"&sdate="+sdate+"&edate="+edate+"&status="+SearchApptStatus+"&stime="+stime+"&etime="+etime+"&LOCDesc="+Locdesc+"&RESDesc="+Resdesc+"&ServId="+Serv+"&SSServId="+SS_Serv+"&APPTReasonForTransferDR="+APPTReasonForTransferDR+"&PrintPatientLetter="+PrintPatientLetter+"&PrintGPLetter="+PrintGPLetter+"&PatientID="+patid+"&HospID="+Hosp+"&CONTEXT="+session['CONTEXT']+"&SessionId="+SessionId;;
	websys_createWindow(lnk,"TRAK_hidden");
} else {
	return;
}
}

function BulkTransAllClickHandler(e) {
//alert("bulk trans");
if ((CheckMandatoryFields())&&(CheckForMandatoryReason("APPTReasonForTransferDR"))) {
	if (!CheckInvalidFields()) {
		return false
	}
	var HoldFlag=document.getElementById("HoldFlag");
	var BookedFlag=document.getElementById("BookedFlag");
	var ArrivedFlag=document.getElementById("ArrivedFlag");
	var TransFlag=document.getElementById("TransFlag");
	var CancelledFlag=document.getElementById("CancelledFlag");
	var CompleteFlag=document.getElementById("CompleteFlag");
	var NAFlag=document.getElementById("NAFlag");
	var BulkApptList=document.getElementById("BulkApptList");
	if (BulkApptList) BulkApptList.value=""
	//alert("Alert")
	//
	//Build list if selected appointment statuses
    	var SearchApptStatus = ""

    	if ((HoldFlag) && (HoldFlag.checked)) SearchApptStatus = SearchApptStatus + "HJ"
	if ((BookedFlag) && (BookedFlag.checked)) SearchApptStatus = SearchApptStatus + "IP"
    	if ((TransFlag) && (TransFlag.checked)) SearchApptStatus = SearchApptStatus + "T"
   	if ((CancelledFlag) && (CancelledFlag.checked)) SearchApptStatus = SearchApptStatus + "X"
    	if ((CompleteFlag) && (CompleteFlag.checked)) SearchApptStatus = SearchApptStatus + "C"
    	if ((NAFlag) && (NAFlag.checked)) SearchApptStatus = SearchApptStatus + "N"
    	if ((ArrivedFlag) && (ArrivedFlag.checked)) SearchApptStatus = SearchApptStatus + "A"
	//alert(SearchApptStatus)
	// Log 37179 BC 27-8-2003 three new fields on Auto Bulk Tansfer
	if (document.getElementById("APPTReasonForTransferDR")) {var APPTReasonForTransferDR = document.getElementById("APPTReasonForTransferDR").value;} else {var APPTReasonForTransferDR=""}
	if ((document.getElementById("PrintPatientLetter"))&&(document.getElementById("PrintPatientLetter").checked)) {var PrintPatientLetter = "on";} else {var PrintPatientLetter=""}
	if ((document.getElementById("PrintGPLetter"))&&(document.getElementById("PrintGPLetter").checked)) {var PrintGPLetter ="on";} else {var PrintGPLetter=""}
	if (document.getElementById("LocId")) Loc = document.getElementById("LocId").value;
	if (document.getElementById("ResId")) Res = document.getElementById("ResId").value;
	if (document.getElementById("ServId")) Serv = document.getElementById("ServId").value;
	if (document.getElementById("SS_ServId")) SS_Serv = document.getElementById("SS_ServId").value;
	if (document.getElementById("sdate")) sdate = document.getElementById("sdate").value;
	if (document.getElementById("edate")) edate = document.getElementById("edate").value;
	if (document.getElementById("stime")) stime = document.getElementById("stime").value;
	if (document.getElementById("etime")) etime = document.getElementById("etime").value;
	if (document.getElementById("PatientID")) patid=document.getElementById("PatientID").value;
	if (document.getElementById("SessionId")) SessionId = document.getElementById("SessionId").value; //65004
	var lnk = "rbbulktransall.csp?LocId="+Loc+"&ResId="+Res+"&sdate="+sdate+"&edate="+edate+"&status="+SearchApptStatus+"&stime="+stime+"&etime="+etime+"&ServId="+Serv+"&SSServId="+SS_Serv+"&APPTReasonForTransferDR="+APPTReasonForTransferDR+"&PrintPatientLetter="+PrintPatientLetter+"&PrintGPLetter="+PrintGPLetter+"&PatientID="+patid+"&HospID="+Hosp+"&CONTEXT="+session['CONTEXT']+"&SessionId="+SessionId;
	//alert(lnk);
	websys_createWindow(lnk,"TRAK_hidden");
} else {
	return;
}
}

function ResourceTextChangeHandler() {
	//SB 12/06/02: This function is called from RBResource.LookUpBrokerRes, as the onchange handler overwrites the broker method.
	//DO NOT REMOVE!
}

function LocationTextChangeHandler() {
	//RC 11/12/02: This function is called from RBResource.LookUpBrokerLocRes, as the onchange handler overwrites the broker method.
	//DO NOT REMOVE!
}

//Log 31312 BC 18-12-2002
function SERDescLookUpSelect(str) {
	var lu = str.split("^");
	var char4=String.fromCharCode(4)
	var char1=String.fromCharCode(1)
	var SScheck=""
	var obj=document.getElementById('SERDesc');
	if (obj) obj.value=lu[1];
	SScheck=mPiece(lu[3],char4,1)
	SScheck=mPiece(SScheck,char1,0)
	if (SScheck=="SS") {
		var obj=document.getElementById('SS_ServId');
		if (obj) obj.value=mPiece(lu[3],char4,0);
		var obj=document.getElementById('ServId');
		if (obj) obj.value="";
	} else {
		var obj=document.getElementById('ServId');
		if (obj) obj.value=mPiece(lu[3],char4,0);
		var obj=document.getElementById('SS_ServId');
		if (obj) obj.value="";
	}
}
//Log 31312 BC 18-12-2002
function ServiceTextChangeHandler() {
	var obj=document.getElementById('SERDesc');
	//alert("changed");
	if ((obj)&&(obj.value=="")) {
		var obj=document.getElementById('ServId');
		if (obj) obj.value="";
		//alert("ServId="+obj.value);
		var obj=document.getElementById('SS_ServId');
		if (obj) obj.value="";
		//alert("SS_ServId="+obj.value);
	}
}

function LocationChangeHandler() {
	var obj=document.getElementById('CTLOCDesc');
	var obj2=document.getElementById('LocId');
	if (obj && obj.value=="") obj2.value=""
}

function ResourceChangeHandler() {
	var obj=document.getElementById('RESDesc');
	var obj2=document.getElementById('ResId');
	if (obj && obj.value=="") obj2.value=""
}

function HospitalChangeHandler() {
	var obj=document.getElementById('HOSPDesc');
	var obj2=document.getElementById('HOSPId');
	if (obj && obj.value=="") obj2.value=""
}
//EZ log 65004
function sesstypeChangeHandler() {
	var obj=document.getElementById('sesstype');
	var obj2=document.getElementById('SessionId');
	if (obj && obj.value=="") obj2.value=""
}

function CheckForMandatoryReason(label) {
	var msg="";
	var objlabel=document.getElementById('c'+label);
	var obj=document.getElementById(label);
	if ((obj)&&(objlabel)) {
		if ((objlabel.className=="clsRequired")&&(obj.value=="")){
			alert("\'" + t[label] + "\' " + t['XMISSING']);
			return false
		}
	}
	return true;
}

function CheckInvalidFields() {
	if (evtTimer) {
		setTimeout('CheckInvalidFields()',200)
	} else {
		for (var j=0; j<document.fRBAppointment_BulkTransfer_Edit.elements.length; j++) {
			if (document.fRBAppointment_BulkTransfer_Edit.elements[j].className=='clsInvalid') {
				websys_setfocus(document.fRBAppointment_BulkTransfer_Edit.elements[j].name);
				alert(t[document.fRBAppointment_BulkTransfer_Edit.elements[j].name]+": "+t['RBInvalidField']);
				return false;
			}
		}
		return true;
	}
}

//Log 39218 BC 30-9-2003 Refind checked appointments
function GetSelected() {
	var doc=top.frames["TRAK_main"].frames["RBBulkTransEdit"].document;
	var doc2=top.frames["TRAK_main"].frames["RBBulkTransList"].document;
	var BulkApptList=doc.getElementById("BulkApptList");
	var tbl=doc2.getElementById("tRBAppointment_BulkTransfer_List");
	var f=doc2.getElementById("fRBAppointment_BulkTransfer_List");
	BulkApptList.value="";
	if ((f)&&(tbl)) {
		for (var j=1;j<tbl.rows.length;j++) {
			var obj=doc2.getElementById('Transferz'+j);
			var ApptId=doc2.getElementById('ApptIDz'+j);
			if ((obj) && (!obj.disabled) && (obj.checked)) {
				BulkApptList.value=BulkApptList.value+ApptId.value+"^"
			}
		}
	}
	//alert(BulkApptList.value);
	return BulkApptList.value
}

function HospLookup(str) {
	var lu = str.split("^");
	//alert(lu);
	var obj=document.getElementById('HOSPId');
	if (obj) obj.value=lu[1];

	return;
}

function mPiece(s1,sep,n) {
    //Split the array with the passed delimeter
    delimArray = s1.split(sep);
    //If out of range, return a blank string
    if ((n <= delimArray.length-1) && (n >= 0)) {
        return delimArray[n];
    }
}
//EZ log 65004
function SessionTypeLookUp(str) {
	var lu = str.split("^");
	//alert(str)
	var obj=document.getElementById('SessionId');
	if (obj) obj.value=lu[1];
	var obj=document.getElementById('sesstype');
	if (obj) obj.value=lu[0] + " (" + lu[2] + "-" + lu[3] + ") " + lu[4];
	
}

document.body.onload = DocumentLoadHandler;

