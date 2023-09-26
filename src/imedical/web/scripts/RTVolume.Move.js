// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function UpdateClickHandler() {
	cspPage="";	
	epid="";
	pid="";

//log 60109 Bo 26-07-2006: use websys.reload.csp instead of javascript
	if (!ValidateField()) { alert(t['Location_Check']);return false;}
	Update_click();
	/*
	if (fRTVolume_Move_submit()) {

		var win=window.opener;

		if (win.name=="TRAK_main") {
			var pid="";
			var pobj=document.getElementById("PatientID");
			if (pobj) pid=pobj.value;
	
			var pgobj=document.getElementById("Page");
			if (pgobj) cspPage=pgobj.value;
			//alert("csp page "+cspPage);
			var eobj=document.getElementById("EpisodeID");
			if (eobj) epid=eobj.value;
			//alert(epid);

			if (cspPage=="") {
				if (win.document.forms['fRTMasVol_FindRequestVolume']) {
					//alert("win refresh");
					win.treload('websys.csp');
					//win.refresh();
				}
				//var form=win.document.forms['fRTRequest_Edit']
				//var TWKFL=form.document.getElementById("TWKFL").value;
				//var TWKFLI=form.document.getElementById("TWKFLI").value;
				//var url="rtrequest.edit.csp?PatientID="+pid+"&TWKFL="+TWKFL+"&TWKFLI="+TWKFLI;
			} else {
				//alert("csp not blank ");
				var url="rtpostdischarge.edit.csp?PatientID="+pid+"&EpisodeID="+epid;
				if (win.parent[1]) win.parent[1].location.href=url;
			}
			//if (win.parent[1]) win.parent[1].location.href=url;
		} else {
			if (win.document.forms['fRTMasVol_FindRequestVolume']) {
				win.refresh();
			}
		}
		window.close();
		return;
	} else {
		return false;
	}*/
}

function ValidateField() {
	var found=true;
	var lbl=document.getElementById("cMRLocation");
	var locobj=document.getElementById("MRLocation");
	if ((locobj) && (locobj.value=="")) {
		if (lbl) lbl = lbl.className = "clsRequired";	
		found=false;
	}
	//alert(found);
	return found;
}

function HospitalLookupSelect(txt) {
		
	var adata=txt.split("^");
	var hospDesc=adata[0];
	var hospID=adata[1];	
	var iobj=document.getElementById("hospID");
	if (iobj) iobj.value=hospID;
}

function ClearField() {
	var HOSPDescObj=document.getElementById("hospDesc"); 
	var HospIDObj=document.getElementById("HospID");
	//alert("w650hosp : "+HOSPDescObj.value);
	//HOSPDescObj.value="";
	//alert("obj: "+HOSPDescObj);
	if (HOSPDescObj){
		//alert("obj and blank");
		
		if ((HospIDObj) && (HOSPDescObj.value=="")) HospIDObj.value="";
	}else{
		//alert("null obj");
		if (HospIDObj) HospIDObj.value="";
	}
	//alert("hidden: "+HospIDObj.value);

}
var HOSPDescObj=document.getElementById("hospDesc"); 
if (HOSPDescObj){
	//alert("obj exist");
	 HOSPDescObj.onblur=ClearField;
}else{
	//alert("In else");
	ClearField();
}
var uobj=document.getElementById("Update");
if (uobj) uobj.onclick=UpdateClickHandler;


document.body.onload=BodyLoadHandler;

var mrobj=document.getElementById("MRLocation");
if (mrobj) mrobj.focus();

function BodyLoadHandler() {
	if (tsc['Update']) websys_sckeys[tsc['Update']]=UpdateClickHandler;
}