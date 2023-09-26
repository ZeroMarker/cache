var evtTimer;
var evtName='';
var doneInit=0;

var objOrdItm=document.getElementById("OEOrdItem");
var objAdmLoc=document.getElementById("AdmLoc");
var objEpisType=document.getElementById("EpisType");

function OEOrdItem_changehandler(encmeth) {

	if (objOrdItm.value=="") {
		try {
			OnValueClear(objOrdItm.id);
		} catch (e) { }
	}

	evtName='OEOrdItem';
	if (doneInit) { evtTimer=window.setTimeout("OEOrdItem_changehandlerX('"+encmeth+"');",200); }
	else { OEOrdItem_changehandlerX(encmeth); evtTimer=""; }
}
function OEOrdItem_changehandlerX(encmeth) {
	if (evtTimer) {
		window.clearTimeout(evtTimer);
		evtName='';
		evtTimer='';
	}
	var obj=document.getElementById('OEOrdItem');
	if (obj.value!='') {
		var tmp=document.getElementById('OEOrdItem');
		if (tmp) {var p1=tmp.value } else {var p1=''};
		var tmp=document.getElementById('GroupID');
		if (tmp) {var p2=tmp.value } else {var p2=''};
		var tmp=document.getElementById('OEOrderCat');
		if (tmp) {var p3=tmp.value } else {var p3=''};
		var tmp=document.getElementById('OEOrderSubCatID');
		if (tmp) {var p4=tmp.value } else {var p4=''};
		var p5='';
		var p6='';
		var p7='';
		var p8='';
		var p9='';
		var p10='';
		var p11='';
		var tmp=document.getElementById('OEOrderCatGroup');
		if (tmp) {var p12=tmp.value } else {var p12=''};
		if (cspRunServerMethod(encmeth,'OEOrdItem_lookupsel','OEOrdItemLookupSelect',p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12)=='0') {
			obj.className='clsInvalid';
			websys_setfocus('OEOrdItem');
			return websys_cancel();
		}
	}
	obj.className='';
}

function AdmLoc_changehandler(encmeth) {

	if (objAdmLoc.value=="") {
		try {
			OnValueClear(objAdmLoc.id);
		} catch (e) { }
	}

	evtName='AdmLoc';
	if (doneInit) { evtTimer=window.setTimeout("AdmLoc_changehandlerX('"+encmeth+"');",200); }
	else { AdmLoc_changehandlerX(encmeth); evtTimer=""; }
}

function AdmLoc_changehandlerX(encmeth) {
	if (evtTimer) {
		window.clearTimeout(evtTimer);
		evtName='';
		evtTimer='';
	}
	var obj=document.getElementById('AdmLoc');
	if (obj.value!='') {
		var tmp=document.getElementById('AdmLoc');
		if (tmp) {var p1=tmp.value } else {var p1=''};
		var p2='';
		var p3='';
		var tmp=document.getElementById('SelEpisType');
		if (tmp) {var p4=tmp.value } else {var p4=''};
		var p5='';
		var tmp=document.getElementById('Hospital');
		if (tmp) {var p6=tmp.value } else {var p6=''};

		if (cspRunServerMethod(encmeth,'AdmLoc_lookupsel','AdmLocLookupSelect',p1,p2,p3,p4,p5,p6)=='0') {
			obj.className='clsInvalid';
			websys_setfocus('AdmLoc');
			return websys_cancel();
		}
	}
	obj.className='';
}
