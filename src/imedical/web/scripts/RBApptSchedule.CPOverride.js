// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function DocumentLoadHandler() {
	AdjustSurg(); AdjustAna();
	var obj=document.getElementById('ClearSurg');
	if (obj) obj.onclick=AdjustSurg;

	var obj=document.getElementById('ClearAna');
	if (obj) obj.onclick=AdjustAna;

	var obj=document.getElementById('RBOTNumWeeks');
	if (obj) obj.onblur=NoWeeksBlurHandler;

	var obj=document.getElementById('RBOTSess');
	if (obj) obj.onblur=SessionBlurHandler;

	var Uobj=document.getElementById('Update');
	if (Uobj) Uobj.onclick=UpdateClickHandler;

	var UCobj=document.getElementById('UpdateClose');
	if (UCobj) UCobj.onclick=UpdateCloseClickHandler;
}

function UpdateClickHandler() {
	if (NoWeeksBlurHandler()==false) return false;
	var dfobj=document.getElementById('RBOTDtFrom');
	var dtobj=document.getElementById('RBOTDtTo');
	var nweek=document.getElementById('RBOTNumWeeks');

	var mesg=""
	var fld=document.getElementsByTagName('INPUT');
	for (var j=0; j<fld.length; j++) {
		if (fld[j].className=="clsInvalid") {
			mesg=mesg+t[fld[j].id]+" "+t["XINVALID"]+"\n"
		}
	}

	if (mesg!="") {alert(mesg); return false;}

	if ((dfobj)&&(dtobj)&&(nweek)) {
		if ((dfobj.value==dtobj.value)&&((nweek.value!="")&&(nweek.value>1))) {
			alert(t['NWRedundant']);
		}
	}
	return Update_click();
}

function UpdateCloseClickHandler() {
	if (NoWeeksBlurHandler()==false) return false;
	var dfobj=document.getElementById('RBOTDtFrom');
	var dtobj=document.getElementById('RBOTDtTo');
	var nweek=document.getElementById('RBOTNumWeeks');

	var mesg=""
	var fld=document.getElementsByTagName('INPUT');
	for (var j=0; j<fld.length; j++) {
		if (fld[j].className=="clsInvalid") {
			mesg=mesg+t[fld[j]]+" "+t["XINVALID"]+"\n"
		}
	}

	if (mesg!="") {alert(mesg); return false;}

	if ((dfobj)&&(dtobj)&&(nweek)) {
		if ((dfobj.value!="")&&(dtobj.value!="")) {
			if ((dfobj.value==dtobj.value)&&((nweek.value!="")&&(nweek.value>1))) {
				alert(t['NWRedundant']);
			}
		}
	}
	return UpdateClose_click();
}

function AdjustSurg() {
	var obj=document.getElementById('ClearSurg');
	if (obj) {
		var surgobj=document.getElementById('RBOTSurg');
		var surgidobj=document.getElementById('RBOTSurgID');
		var surgobjlu=document.getElementById('ld2092iRBOTSurg');
		if (obj.checked==true) {
			if (surgobj) {
				surgobj.value="";
				surgidobj.value="";
				surgobj.disabled=true;
				surgobj.className="disabledField";
			}
			if (surgobjlu) surgobjlu.disabled=true;
		} else if (obj.checked==false) {
			if (surgobj) surgobj.disabled=false; surgobj.className="";
			if (surgobjlu) surgobjlu.disabled=false;
		}
	}
}

function AdjustAna() {
	var obj=document.getElementById('ClearAna');
	if (obj) {
		var anaobj=document.getElementById('RBOTAna');
		var anaidobj=document.getElementById('RBOTAnaID');
		var anaobjlu=document.getElementById('ld2092iRBOTAna');
		if (obj.checked==true) {
			if (anaobj) {
				anaobj.value="";
				anaidobj.value="";
				anaobj.disabled=true;
				anaobj.className="disabledField";
			}
			if (anaobjlu) anaobjlu.disabled=true;
		} else if (obj.checked==false) {
			if (anaobj) anaobj.disabled=false; anaobj.className="";
			if (anaobjlu) anaobjlu.disabled=false;
		}
	}
}

function NoWeeksBlurHandler() {
	var obj=document.getElementById('RBOTNumWeeks');
	if ((obj)&&(obj.value.length>2)) {
		alert(t["NWError"]);
		obj.className='clsInvalid';
		return false;
	}
}

function SessionBlurHandler() {
	var obj=document.getElementById('RBOTSess');
	var obj1=document.getElementById('RBOTSessID');
	if ((obj)&&(obj1)) {
		if ((obj.value!="")&&(obj1.value=="")) {
			obj.className='clsInvalid';
			return false;
		}
		if (obj.value=="") {
			obj1.value="";
			obj.className="";
		}
	}
}

function RBOTLocLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById('RBOTLoc');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('RBOTLocID');
	if (obj) obj.value=lu[1];
	var obj=document.getElementById('RBOTRes');
	if (obj) obj.value="";
	var obj=document.getElementById('RBOTResID');
	if (obj) obj.value="";
	var obj=document.getElementById('RBOTSess');
	if (obj) obj.value="";
	var obj=document.getElementById('RBOTSessID');
	if (obj) obj.value="";
}

function RBOTResLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById('RBOTRes');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('RBOTResID');
	if (obj) obj.value=lu[2];
	var obj=document.getElementById('RBOTSess');
	if (obj) obj.value="";
	var obj=document.getElementById('RBOTSessID');
	if (obj) obj.value="";
}

function RBOTSessLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById('RBOTSessID');
	if (obj) obj.value=lu[1];
	var obj=document.getElementById('RBOTSess');
	if (obj) obj.value=lu[0] + " (" + lu[2] + "-" + lu[3] + ") " + lu[4];
}

function RBOTSurgLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById('RBOTSurg');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('RBOTSurgID');
	if (obj) obj.value=lu[1];
}

function RBOTAnaLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById('RBOTAna');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('RBOTAnaID');
	if (obj) obj.value=lu[1];
}

document.body.onload = DocumentLoadHandler;