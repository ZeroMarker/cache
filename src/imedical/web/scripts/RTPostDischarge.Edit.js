// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
//; *****  Log# 28200; AmiN ; 02/Oct/2002  Restructured web page.  *****
var cstatus="";
var cvolumeno="";

function UpdateClickHandler() {
	return Update1_click();
}

function LookUpRegSelect(str) {


//0=RegistrationNo 1=EpisodeNo 2=PAADMAdmDate 3=PAADMDischgDate 4=PAADMDischgTime 5=ward 6=CareProv 7=Location 8=Status 9=PatientID 10=VolumeNo
	var lu=str.split("^");
	if (lu.length>0) {

	   var regobj=document.getElementById("RegistrationNo");
	   if (regobj) { regobj.value=lu[0];  var RegistrationNo= lu[0]; }

	   var epobj=document.getElementById("PAADMADMNo");	//EpisodeNo
	   if (epobj){ epobj.value=lu[1];  var PAADMADMNo= lu[1]; }

	   var dateobj=document.getElementById("PAADMAdmDate");
	   if (dateobj) { dateobj.value=lu[2]; var PAADMAdmDate= lu[2]; }

	   var disdateobj=document.getElementById("PAADMDischgDate");
	   if (disdateobj){ disdateobj.value=lu[3]; var PAADMDischgDate= lu[3]; }

	   var timeobj=document.getElementById("PAADMDischgTime");
	   if (timeobj) { timeobj.value=lu[4]; var PAADMDischgTime= lu[4]; }

	   var wardobj=document.getElementById("Ward");
	   if (wardobj){ wardobj.value=lu[5];  var Ward= lu[5]; }

	   var careobj=document.getElementById("CareProv");
	   if (careobj) { careobj.value=lu[6];  var CareProv= lu[6]; }

	   var locobj=document.getElementById("Location");
	   if (locobj){ locobj.value=lu[7]; var Location= lu[7]; }

	   var statusobj=document.getElementById("Status");
	   if (statusobj) { statusobj.value=lu[8];	var Status= lu[8]; cstatus=Status; }

	   var patobj=document.getElementById("PatientID");
	   if (patobj) { patobj.value=lu[9];	 var PatientID= lu[9]; }

	   var patobj=document.getElementById("VolumeNo");
	   if (patobj) { patobj.value=lu[10];	 var VolumeNo= lu[10]; cvolumeno=VolumeNo; }

	   var epidobj=document.getElementById("EpisodeID");
	   if (epidobj) { epidobj.value=lu[11];	 var EpisodeID= lu[11]; }

	   var vidobj=document.getElementById("RTMAVRowID");
	   if (vidobj) { vidobj.value=lu[12]; var RTMAVRowID=lu[12] }

	   var objTWKFL="";	var  TWKFL="";  var objTWKFLI=""; var TWKFLI="";  var CONTEXT="";

	    objTWKFL=document.getElementById('TWKFL');
		if (objTWKFL)  TWKFL=objTWKFL.value;

	    objTWKFLI=document.getElementById('TWKFLI');
		if (objTWKFLI)  TWKFLI=objTWKFLI.value;

		CONTEXT=session['CONTEXT'];

		//alert("context = "+CONTEXT); //W450
	 //alert("TWKFL+TWKFLI  "+TWKFL+"^"+TWKFLI);  //450 ^ 1
		//alert("status take 2: "+Status);
	   var url = "websys.default.csp?WEBSYS.TCOMPONENT=RTPostDischarge.Edit&PatientBanner=1&RegistrationNo="+RegistrationNo+"&PAADMADMNo="+PAADMADMNo+"&PAADMAdmDate="+PAADMAdmDate+"&PAADMDischgDate="+PAADMDischgDate+"&PAADMDischgTime="+PAADMDischgTime+"&Ward="+Ward+"&CareProv="+CareProv+"&Location="+Location+"&Status="+Status+"&PatientID="+PatientID+"&VolumeNo="+VolumeNo+"&EpisodeID="+EpisodeID+"&TWKFL="+TWKFL+"&TWKFLI="+TWKFLI+"&CONTEXT="+CONTEXT+"&RTMAVRowID="+RTMAVRowID;
	   //alert("url : "+url);
	   // window.opener.top.frames["TRAK_main"].location.href=url;
    window.location.href=url;
	//alert("url"+url);
	   //websys_createWindow(url,"TRAK_main");
   }
}

function RegistrationNo_changehandler(encmeth) {	//have to have for broker only!!!
	//alert("hello ");
	var obj=document.getElementById('RegistrationNo');
	var p1='';
	if (obj) p1=obj.value;
	var obj=document.getElementById('RegistrationNo');
	if (cspRunServerMethod(encmeth,'','LookUpRegSelect',p1)=='0') {
		obj.className='clsInvalid';  ///generic name to check all fields.
		obj.focus();
		return websys_cancel();
	} else {
		obj.className='';
	}
}


function PAADMADMNo_changehandler(encmeth) {

	var obj=document.getElementById('PAADMADMNo');
	var p1='';
	if (obj) p1=obj.value;
	var obj=document.getElementById('PAADMADMNo');
	if (cspRunServerMethod(encmeth,'','LookUpRegSelect',p1)=='0') {
		obj.className='clsInvalid';
		obj.focus();
		return websys_cancel();
	} else {
		obj.className='';
	}
}


function AssignEpToVolume_ClickHandler() {
	var mObj=document.getElementById("VolumeNo");
	if ((mObj) && (mObj.value!=null)) {
		if (mObj.value=="") {
			alert(t['Validate_VolumeNo']);
		} else {
			if ((AssEpObj) && (!AssEpObj.disabled)) {
				var MasVolID="";
				var pid="";
				var epid="";
				var mobj=document.getElementById("RTMAVRowID");
				if (mobj) MasVolID=mobj.value;
				var pobj=document.getElementById("PatientID");
				if (pobj) pid=pobj.value;
				var epobj=document.getElementById("EpisodeID");
				if (epobj) epid=epobj.value;
				if (cstatus=="") {
					var statusobj=document.getElementById("Status");
	   				if (statusobj) cstatus=statusobj.value;
				}
				if (cvolumeno=="") {
					var voobj=document.getElementById("VolumeNo");
	  				if (voobj) cvolumeno=voobj.value;
				}
				//var url="websys.default.csp?WEBSYS.TCOMPONENT=RTMasVolAdm.List&PARREF="+MasVolID+"&PatientID="+pid+"&PageFrom=PostDischarge"+"&EpisodeID="+epid+"&Status="+cstatus+"&VolumeNo="+cvolumeno;
				var url="rtvolmicrofilmframes.csp?PARREF="+MasVolID+"&PatientID="+pid+"&PageFrom=PostDischarge"+"&EpisodeID="+epid+"&Status="+cstatus+"&VolumeNo="+cvolumeno;

				// Log 59598 - BC - 29-06-2006 : remove statusbar variable (status=) to display the status bar.
				websys_createWindow(url, "","left=100,width=400,height=480,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
			}
		}
	}
}

function NewVolume_ClickHandler() {

	var pid="";
	var pobj=document.getElementById("PatientID");
	if (pobj) pid=pobj.value;
	var url="rtvolume.edit.csp?PatientID="+pid;
	// Log 59598 - BC - 29-06-2006 : remove statusbar variable (status=) to display the status bar.
	if (pid!="") websys_createWindow(url, "","left=250,width=290,height=150,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
}

function ChangeLocation_ClickHander() {
//At the moment the link is done through the component
	var pid="";
	var VolID="";
	var epid="";
	var volDesc="";

	var pobj=document.getElementById("PatientID");
	if (pobj) pid=pobj.value;

	var eobj=document.getElementById("EpisodeID");
	if (eobj) epid=eobj.value;

	var vdobj=document.getElementById("VolumeNo");
	if (vdobj) volDesc=vdobj.value;
	var vidobj=document.getElementById("RTMAVRowID");
	if (vidobj) VolID=vidobj.value;
	//alert(vidobj+"  "+VolID+"  "+vidobj.value);

	if (VolID=="") alert(t['Validate_VolumeNo']);
	if ((pid!="") && (VolID!="")) {
		var url="websys.default.csp?WEBSYS.TCOMPONENT=RTVolume.move&MasVolID="+VolID+"&PatientID="+pid+"&Page=rtpostdischarge.edit.csp"+"&EpisodeID="+epid;
		//alert("url="+url);
		// Log 59598 - BC - 29-06-2006 : remove statusbar variable (status=) to display the status bar.
		websys_createWindow(url, "","left=250,width=400,height=190,top=200,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
	}
}

function LookUpSelectStatus(str) {
	//alert(str);
	var lu=str.split("^");   // Description,HIDDEN,Code       Complete,4,COMP,	or     Discharge,3,D,
	cstatus=lu[0];
	if (lu.length>0) {
	   var idobj=document.getElementById("StatusID");
	   if (idobj) {  idobj.value=lu[1];  }

	   var codeobj=document.getElementById("StatusCode");
	   if (codeobj) {  codeobj.value=lu[2]; }
	}
}

function LookUpSelectEpisodeNo(str) {  //desc,status,pid,regno //for broker of Episode Number
	//alert("in LookUpSelectStatus");
	var sobj=document.getElementById("Status");
	var pobj=document.getElementById("PatientID");
	var urobj=document.getElementById("RegistrationNo");
	var lu=str.split("^");
	if (lu.length>0) {
		if ((sobj) && (sobj.value="")) sobj.value=lu[1];
		if (pobj) pobj.value=lu[2];
		if ((urobj) && (urobj.value=="")) urobj.value=lu[3];
	}
}


function LookUpSelectVolDesc(str) {
//HIDDEN:%String,    MRType:%String,   VolumeDesc:%String,    HIDDEN:%String
	var lu=str.split("^");
	if (lu.length>0) {
	   var mobj=document.getElementById("RTMAVRowID");
	   if (mobj) mobj.value=lu[0];
	 //  alert("RTMAVRowID="+lu[0]+"  "+mobj.value);

	   var vobj=document.getElementById("VolumeNo");
	   if (vobj) { vobj.value=lu[2]; cvolumeno=lu[2]; }

	   var pobj=document.getElementById("PatientID");
	   if (pobj) pobj.value=lu[3];
	}
}


//; *****  Log# 28200 ; AmiN ; 10/09/2002 *****
function DisplayAllEpisodes_ClickHandler() {
	var pid=""; var regid="";
	var pobj=document.getElementById("PatientID");
	var regobj=document.getElementById("RegistrationNo");
	if (pobj){
		pid=pobj.value;
		if (regobj){ regid=regobj.value; }
		var url="websys.default.csp?WEBSYS.TCOMPONENT=RTPostDischarge.ListAllEpis&PatientID="+pid;
		// Log 59598 - BC - 29-06-2006 : remove statusbar variable (status=) to display the status bar.
		websys_createWindow(url, "","left=100,width=400,height=480,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
	}
}


var displayEpobj=document.getElementById("DisplayAllEpisodes");
if (displayEpobj) displayEpobj.onclick=DisplayAllEpisodes_ClickHandler;

var Uobj=document.getElementById("Update1");
if (Uobj) Uobj.onclick=UpdateClickHandler;
if (self==top) websys_reSizeT();

var AssEpObj=document.getElementById("AssignEpToVolume");
if (AssEpObj) AssEpObj.onclick=AssignEpToVolume_ClickHandler;

var nvObj=document.getElementById("NewVolume");
if (nvObj) nvObj.onclick=NewVolume_ClickHandler;

var clobj=document.getElementById("ChangeLocation");
if (clobj) clobj.onclick=ChangeLocation_ClickHander;
