// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
// ab 17.06.02 - from panok.list

function DocumentLoadHandler() {
	var obj;

	document.focus()

	obj=document.getElementById("New1");
	obj.onclick = NewClickHandler;

	obj=document.getElementById("tPAAdmRefDoc_List");
	obj.onclick = ListClickHandler;

}

function NewClickHandler(e) {
	var nurl=true;
	var parref="",patid="",hlinks="",twkfl="",twkfli="";

	var objParRef=document.getElementById('PARREF');
	if (objParRef) parref=objParRef.value;
	var objPatID=document.getElementById('PatientID');
	if (objPatID) patid=objPatID.value;
	var objHLinks=document.getElementById('hiddenLinks');
	if (objHLinks) hlinks=objHLinks.value;
	var objTWKFL=document.getElementById('TWKFL');
    if (objTWKFL) twkfl=objTWKFL.value;
	var objTWKFLI=document.getElementById('TWKFLI');
    if (objTWKFLI) twkfli=objTWKFLI.value;
	var url="websys.default.csp?WEBSYS.TCOMPONENT=PAAdmRefDoc.Edit&PatientBanner=1&PARREF="+parref+"&PatientID="+patid+"&hiddenLinks="+hlinks+"&TWKFL="+twkfl+"&TWKFLI="+twkfli;
	return chooseOpenMethod(url,nurl);
}

function ListClickHandler(e) { // handler for click on existing ref doc
		var eSrc = websys_getSrcElement(e);
		var nurl=false

		if (eSrc.tagName=="IMG") eSrc=websys_getParentElement(eSrc)

		if ((eSrc.tagName=="A") && (eSrc.id.indexOf("CONTTP_Descz")==0)) {
				var currentlink=eSrc.href.split("?");
				var url = "websys.default.csp?WEBSYS.TCOMPONENT=PAAdmRefDoc.Edit&" + currentlink[1];
				return chooseOpenMethod(url,nurl);
		}
}


function chooseOpenMethod(url,nurl) { // chooses whether to open in new or existing window
	var objHLinks=document.getElementById('hiddenLinks');
	var objTWKFL=document.getElementById('TWKFL');
	var objTWKFLI=document.getElementById('TWKFLI');
	var objParRef=document.getElementById('PARREF');
	var objPatID=document.getElementById('PatientID');
	var objHLinks=document.getElementById('hiddenLinks');
	
	if ((objHLinks) && (objTWKFL.value!="")) {
		objTWKFL.value="" 
		objTWKFLI.value="" 
		if (nurl) {
		var url="websys.default.csp?WEBSYS.TCOMPONENT=PAAdmRefDoc.Edit&PatientBanner=1&PARREF="+objParRef.value+"&PatientID="+objPatID.value+"&hiddenLinks="+objHLinks.value+"&TWKFL="+objTWKFL.value+"&TWKFLI="+objTWKFLI.value;
		}
		newlink=url.split("&TWKFL=")
		newlink2=newlink[1].split("&TWKFLJ=")
		url=newlink[0]+"&TWKFL="+objTWKFL.value+"&TWKFLI="+objTWKFLI.value+"&TWKFLJ="+newlink2[1]
		websys_lu(url,false,"width=720,height=480,left=20,top=50");
		return false;
	} else {
		self.location.href=url;
		return false;
	}
}

document.body.onload = DocumentLoadHandler;
