// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.


function ListDocumentLoadHandler() {
	DocumentLoadHandler();
	CheckBoxHandler();
	EnablePrefMethod();
	AssignClickHandler();
}

function AssignClickHandler() {
	var tbl=document.getElementById("tCTCareProvAddress_List");
	for (var i=1;i<tbl.rows.length;i++) {
		var objCP=document.getElementById("ADDRTypez"+i)
		if (objCP) objCP.onclick=CPClickHandler;
	}
	return;
}

function CPClickHandler(e) {
	// RQG 20.9.02 - log 23316.
	var SSUserID="";
	var CareProvID="";
	var PARREF="";
	var CONTEXT=session['CONTEXT'];
	var CPAddID="";
	var ADDRPrefMethod="";
	var objTWKFL=document.getElementById('TWKFL');
	var objTWKFLI=document.getElementById('TWKFLI');
	var TWKFL="";
	var TWKFLI="";
	if (objTWKFL) TWKFL=objTWKFL.value;
	if (objTWKFLI) TWKFLI=objTWKFLI.value;

	var objSSUserID=document.getElementById("SSUserID");
	var objCareProvID=document.getElementById("CareProvID");
	var objPARREF=document.getElementById("PARREF");

	if (objSSUserID) SSUserID=objSSUserID.value;
	if (objCareProvID) CareProvID=objCareProvID.value;
	if (objPARREF) PARREF=objPARREF.value;
	
	//To get the Address title row id from the list
	var obj=websys_getSrcElement(e);
	if (obj.tagName=="LINK") obj=websys_getParentElement(obj);
	var rowid=obj.id;
	var rowAry=rowid.split("z");
	var CPAddID= document.getElementById('ADDRRowIdz'+rowAry[1]).value;

	var prefmethod=document.getElementById('ADDRPrefMethodz'+rowAry[1]);
	if ((prefmethod)&&(prefmethod.checked)) {
		var ADDRPrefMethod=prefmethod.value;
	} else {
		var ADDRPrefMethod="";
	}

	var url="ctcareprovaddress.csp?SSUserID="+SSUserID+"&CareProvID="+CareProvID+"&ID="+CPAddID+"&PARREF="+PARREF+"&ADDRPrefMethod="+ADDRPrefMethod+"&TWKFL="+TWKFL+"&TWKFLI="+TWKFLI+"&CONTEXT="+CONTEXT;

	websys_createWindow(url,"TRAK_main");
	return false;
}

function CheckBoxHandler(){
	var tbl=document.getElementById("tCTCareProvAddress_List");
	for (var i=1; i<tbl.rows.length; i++) {
		var objPM=document.getElementById("ADDRPrefMethodz"+i);
		if ((objPM) && (objPM.checked)) {
			var objPME=document.getElementById("ADDRPrefMethod");
			if (objPME) objPME.disabled=true;
		}
	}
	
}

document.body.onload=ListDocumentLoadHandler;
