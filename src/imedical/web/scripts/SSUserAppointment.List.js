//Copyright (c) 2002 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function DocumentBodyLoadHandler(){
	//alert("SSUserAppointment.List.js BodyLoadHandler called")
	try { BodyLoadHandler(); } catch(e) {}
	AssignClickHandler();
	var objNew=document.getElementById("New");
	if (objNew) objNew.onclick=NewClickHandler;
}

function AssignClickHandler() {
	var tbl=document.getElementById("tSSUserAppointment_List");
	for (var i=1;i<tbl.rows.length;i++) {
		var objAPT=document.getElementById("USAPTLDescz"+i)
		if (objAPT) objAPT.onclick=AppointmentTitleClickHandler;
	}
	return;
}

function AppointmentTitleClickHandler(e) {
	// SA 12.7.02 - log 23316.
	//alert("hello");

	var SSUserID="";
	var CareProvID="";
	var PARREF="";
	var CONTEXT=session['CONTEXT'];
	var ApptID="";

	var objTWKFL=document.getElementById('TWKFL');
	var objTWKFLI=document.getElementById('TWKFLI');
	var TWKFL="";
	var TWKFLI="";
	if (objTWKFL) TWKFL=objTWKFL.value;
	if (objTWKFLI) TWKFLI=objTWKFLI.value;
	//alert("ApptList: objTWKFL="+TWKFL+ " objTWKFLI="+TWKFLI);

	var objSSUserID=document.getElementById("SSUserID");
	var objCareProvID=document.getElementById("CareProvID");
	var objPARREF=document.getElementById("PARREF");

	if (objSSUserID) SSUserID=objSSUserID.value;
	if (objCareProvID) CareProvID=objCareProvID.value;
	if (objPARREF) PARREF=objPARREF.value;
	
	//To get the Appointment title row id from the list
	var obj=websys_getSrcElement(e);
	if (obj.tagName=="IMG") obj=obj.parentElement;
	if (obj.tagName=="LINK") obj=websys_getParentElement(obj);
	var rowid=obj.id;
	var rowAry=rowid.split("z");
	var ApptID = document.getElementById('APPTRowIdz'+rowAry[1]).value
	//alert(ApptID);
	
	var url="ssuserappointment.csp?SSUserID="+SSUserID+"&CareProvID="+CareProvID+"&ID="+ApptID+"&PARREF="+PARREF+"&TWKFL="+TWKFL+"&TWKFLI="+TWKFLI+"&CONTEXT="+CONTEXT;

	//alert(url);
	
	websys_createWindow(url,"TRAK_main");
	return false;
}

function NewClickHandler() {
	var SSUserID="";
	var CareProvID="";
	var PARREF="";
	var CONTEXT=session['CONTEXT'];

	var objSSUserID=document.getElementById("SSUserID");
	var objCareProvID=document.getElementById("CareProvID");
	var objPARREF=document.getElementById("PARREF");

	var objTWKFL=document.getElementById('TWKFL');
	var objTWKFLI=document.getElementById('TWKFLI');
	var TWKFL="";
	var TWKFLI="";

	if (objTWKFL) TWKFL=objTWKFL.value;
	if (objTWKFLI) TWKFLI=objTWKFLI.value;

	if (objSSUserID) SSUserID=objSSUserID.value;
	if (objCareProvID) CareProvID=objCareProvID.value;
	if (objPARREF) PARREF=objPARREF.value;

	var url="ssuserappointment.csp?SSUserID="+SSUserID+"&CareProvID="+CareProvID+"&PARREF="+PARREF+"&TWKFL="+TWKFL+"&TWKFLI="+TWKFLI+"&CONTEXT="+CONTEXT;
	
	//alert(url);

	websys_createWindow(url,"TRAK_main");
	return false;

}

document.body.onload=DocumentBodyLoadHandler;
