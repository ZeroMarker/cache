// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
var	objCP1=document.getElementById('CP1');
if (objCP1) objCP1.onclick=CP1ClickHandler;
	
var	objCP2=document.getElementById('CP2');
if (objCP2) objCP2.onclick=CP2ClickHandler;

var	objArrived=document.getElementById('ShowArrived');
var	objToSee=document.getElementById('PatFuture');
var	objCurrent=document.getElementById('PatCurrent');

function BodyLoadHandler() {
	var obj=document.getElementById("Lock");
	var obj1=document.getElementById("RetainValues");
	if ((obj)&&(obj1)) {
		if (obj1.value=="on") obj.checked=true;
	}

	obj=document.getElementById('Find');
	if (obj) obj.onclick=FindClickHandler;
	if (tsc['Find']) websys_sckeys[tsc['Find']]=FindClickHandler;
	FindClickHandler();
	
	obj=document.getElementById('NextPatient');
	if (obj) obj.onclick=NextPatientClickHandler;
	if (tsc['NextPatient']) websys_sckeys[tsc['NextPatient']]=NextPatientClickHandler;
}

function CareProviderDRLookUpHandler(str) {
	var lu=str.split("^");
	var obj=document.getElementById("CareProvider");
	var obj1=document.getElementById("CPType");
	var objId=document.getElementById("CareProvID");
	if (lu[0]&&obj)  obj.value=lu[0];
	if (lu[4]&&obj1)  obj1.value=lu[4];
	if (lu[1]&&objId)  objId.value=lu[1];
}

function SessionLookUpSelect(str) {
	var lu = str.split("^");
	var objId=document.getElementById('SessID');
	if (objId) objId.value=lu[1];
	var obj=document.getElementById('Session');
	if (obj) obj.value=lu[0] + " (" + lu[2] + "-" + lu[3] + ") " + lu[4];
	if (objId.value!="") getClinicDefaults();
}

function ResourceLookUpHandler(str) {
	//alert(str);
	var lu=str.split("^");
	var obj=document.getElementById("ResID");
	if (lu[2]&&obj)  obj.value=lu[2];
}

function LocationLookUpHandler(str) {
	var lu=str.split("^");
	var obj=document.getElementById("LocID");
	if (lu[1]&&obj)  obj.value=lu[1];
}

function getClinicDefaults() {
	var ClinicType="";
	var Date="";
	
	var objDate=document.getElementById("Date");
	if (objDate) Date=objDate.value;
	var objSessId=document.getElementById("SessID");
	if (objSessId) ClinicType=tkMakeServerCall("web.RBApptSchedule","getClinicType",objSessId.value,Date);
	
	switch (ClinicType) {
			case "SI":
				var objChk=document.getElementById("Single");
				if (objChk) objChk.checked=true;
				var objChk=document.getElementById("Dual");
				if (objChk) objChk.checked=false;
				var objChk=document.getElementById("Seq");
				if (objChk) objChk.checked=false;
				//if its Single CP clinic we assume care provider is 1
				var objChk=document.getElementById("CP1");
				if (objChk) objChk.checked=true;
				var objChk=document.getElementById("CP2");
				if (objChk) objChk.checked=false;
				
				var Room=ClinicType=tkMakeServerCall("web.RBApptSchedule","getOPDRoom",objSessId.value,Date);
				if (Room!="") {
					var objRoom=document.getElementById("RoomNo");
					if (objRoom) objRoom.value=Room;
				}
				break;
			case "DU":
				var objChk=document.getElementById("Dual");
				if (objChk) objChk.checked=true;
				var objChk=document.getElementById("Single");
				if (objChk) objChk.checked=false;
				var objChk=document.getElementById("Seq");
				if (objChk) objChk.checked=false;
				break;
			case "SE":
				var objChk=document.getElementById("Seq");
				if (objChk) objChk.checked=true;
				var objChk=document.getElementById("Dual");
				if (objChk) objChk.checked=false;
				var objChk=document.getElementById("Single");
				if (objChk) objChk.checked=false;
				break;			
			default:
				var objChk=document.getElementById("Seq");
				if (objChk) objChk.checked=false;
				var objChk=document.getElementById("Dual");
				if (objChk) objChk.checked=false;
				var objChk=document.getElementById("Single");
				if (objChk) objChk.checked=false;			
				break;
	}			
}

function NextPatientClickHandler() {
	var CP1="";
	if (objCP1) CP1=objCP1.checked;
		
	var CP2="";
	if (objCP2) CP2=objCP2.checked;
		
	var Loc="";
	var objLoc=document.getElementById("Location");
	if (objLoc) Loc=objLoc.value;
		
	var Room="";
	var objRoom=document.getElementById("RoomNo");
	if (objRoom) Room=objRoom.value;
		
	var Res="";
	var objRes=document.getElementById("ResID");
	if (objRes) Res=objRes.value;
		
	var CP="";
	var objCP=document.getElementById("CareProvID");
	if (objCP) CP=objCP.value;
		
	var single="";
	var objSingle=document.getElementById("Single");
	if (objSingle) single=objSingle.checked;
		
	var dual="";
	var objDual=document.getElementById("Dual");
	if (objDual) dual=objDual.checked;
		
	var seq="";
	var objSeq=document.getElementById("Seq");
	if (objSeq) seq=objSeq.checked;		
			
	var CP1or2="1";
	if (CP1) CP1or2="1";
	else if (CP2) CP1or2="2"
		
	var ClinicType="";
	if (single) ClinicType="1"
	if (dual) ClinicType="2";
	if (seq) ClinicType="3";

		
	var url="rbappointment.nextpatient.csp?&CP1or2="+CP1or2+"&Location="+Loc+"&CareProvider="+CP
	url=url+"&ClinicType="+ClinicType+"&CONTEXT="+session['CONTEXT']+"&RoomNo="+Room+"&Resource="+Res;				
				
	win=window.parent.frames["PatTrack"];
	if (win.name=="PatTrack") {
		var tbl=win.document.getElementById("tRBApptPatientTraking_List")
		var f=win.document.getElementById("fRBApptPatientTraking_List");
		var aryfound=checkedCheckBoxes(f,tbl,"Selectz");
		
		if (aryfound.length==1) {
			for (var i=0;i<tbl.rows.length;i++) {
				for (var j=0;j<aryfound.length;j++) {
					if (aryfound[j]==i) {
						ApptID=f.elements['ApptIDz'+i].value;
					}	
				}
			}
			url=url+"&ApptID="+ApptID;
		}
		websys_createWindow(url,"TRAK_hidden");
	}
}

function FindClickHandler() {
	var obj=document.getElementById("Lock");
	var obj1=document.getElementById("RetainValues");
	if ((obj)&&(obj1)) {
		if (obj.checked==true) obj1.value="on";
		if (obj.checked==false) obj1.value="off";
		var RetainFieldValue=obj1.value;
	}
	
	var CP1="";
	if (objCP1) CP1=objCP1.checked;
		
	var CP2="";
	if (objCP2) CP2=objCP2.checked;
		
	var Loc="";
	var objLoc=document.getElementById("Location");
	if (objLoc) Loc=objLoc.value;
		
	var CP="";
	var objCP=document.getElementById("CareProvID");
	if (objCP) CP=objCP.value;
		
	var Room="";
	var objRoom=document.getElementById("RoomNo");
	if (objRoom) Room=objRoom.value;
		
	var Res="";
	var objRes=document.getElementById("ResID");
	if (objRes) Res=objRes.value;
		
	var ResDesc="";
	var objResDesc=document.getElementById("Resource");
	if (objResDesc) ResDesc=objResDesc.value;
		
	var single="";
	var objSingle=document.getElementById("Single");
	if (objSingle) single=objSingle.checked;

	var dual="";
	var objDual=document.getElementById("Dual");
	if (objDual) dual=objDual.checked;
		
	var seq="";
	var objSeq=document.getElementById("Seq");
	if (objSeq) seq=objSeq.checked;		

	var CP1or2="1";
	if (CP1) CP1or2="1";
	else if (CP2) CP1or2="2"
		
	var ClinicType="";
	if (single) ClinicType="1"
	if (dual) ClinicType="2";
	if (seq) ClinicType="3";
		
	var PatSeen="0";
	var objSeen=document.getElementById("PatSeen");
	if (objSeen) PatSeen=objSeen.checked;
	if (PatSeen) PatSeen="1";
	else PatSeen="0";

	var PatToBeSeen="0";
	var objToBeSeen=document.getElementById("PatFuture");
	if (objToBeSeen) PatToBeSeen=objToBeSeen.checked;
	if (PatToBeSeen) PatToBeSeen="1";
	else PatToBeSeen="0";

	var PatCurrent="0";
	var objCurrent=document.getElementById("PatCurrent");
	if (objCurrent) PatCurrent=objCurrent.checked;		
	if (PatCurrent) PatCurrent="1";
	else PatCurrent="0";
		
	var RegNo="";
	var objRegNo=document.getElementById("RegistrationNo");
	if (objRegNo) RegNo=objRegNo.value;
		
	var Date="";
	var objDt=document.getElementById("Date");
	if (objDt) Date=objDt.value;
		
	var ArrFlag="";
	var objArr=document.getElementById("ShowArrived");
	if (objArr) ArrFlag=objArr.checked;
		
	if (ArrFlag) ArrFlag="1";
	else ArrFlag="0";
	
	var Sess="";
	var objSess=document.getElementById("Session");
	if (objSess) Sess=objSess.value;

	var SessId="";
	var objSessId=document.getElementById("SessId");
	if (objSessId) SessId=objSessId.value;
	
	var CPType="";
	var objCPType=document.getElementById("CPType");
	if (objCPType) CPType=objCPType.value;
	
	var url="websys.default.csp?WEBSYS.TCOMPONENT=RBApptPatientTraking.List&CP1or2="+CP1or2+"&Location="+Loc+"&CareProvider="+CP;
	url=url+"&ClinicType="+ClinicType+"&Seen="+PatSeen+"&ToSee="+PatToBeSeen+"&Current="+PatCurrent+"&RoomNo="+Room+"&CONTEXT="+session['CONTEXT'];
	url=url+"&Resource="+Res+"&RegistrationNo="+RegNo+"&Date="+Date+"&ShowArrived="+ArrFlag+"&ResourceDesc="+ResDesc;
	url=url+"&RetainValues="+RetainFieldValue+"&Sess="+Sess+"&CPType="+CPType+"&SessId="+SessId;
	websys_createWindow(url,'PatTrack','');
}

function CP1ClickHandler()
{
	if (objCP1.checked) {
		if (objCP2) objCP2.checked=false;
	}	
}

function CP2ClickHandler()
{
	if (objCP2.checked) {
		if (objCP1) objCP1.checked=false;
	}	
}

document.body.onload=BodyLoadHandler;