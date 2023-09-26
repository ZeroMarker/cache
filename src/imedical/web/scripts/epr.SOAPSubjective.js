// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function DocumentLoadHandler() {
	assignClickHandler();
	var origval;

	// disable multiple select for listboxes
	obj=document.getElementById("BodySite");
	if (obj) {
		obj.multiple=false;
		obj.onmousedown=setorigval;
		obj.onchange=checkorigval;
	}

	obj=document.getElementById("Laterality");
	if (obj) {
		obj.multiple=false;
		obj.onmousedown=setorigval;
		obj.onchange=checkorigval;
	}

	obj=document.getElementById("Severity");
	if (obj) {
		obj.multiple=false;
		obj.onmousedown=setorigval;
		obj.onchange=checkorigval;
	}

	obj=document.getElementById("DurationUnit");
	if (obj) {
		obj.multiple=false;
		obj.onmousedown=setorigval;
		obj.onchange=checkorigval;
	}

	obj=document.getElementById("DurationNum");
	if(obj) obj.onchange=DurationNumChangeHandler;

	objnew=document.getElementById("new1");
	if (objnew) objnew.onclick=ClearFields;

	objUpdate=document.getElementById("update1");
	if (objUpdate) {
		objUpdate.onclick=UpdateClickHandler;
		if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateClickHandler;
	}

	var epId=document.getElementById("EpisodeID");
	var conEpId=document.getElementById("ConsultEpisodeID");
	if(epId && conEpId && conEpId.value!="" && conEpId.value!=epId.value){
		if(objUpdate){
			objUpdate.disabled=true;
			objUpdate.onclick=LinkDisable;
		}
		if(objnew){
			objnew.disabled=true;
			objnew.onclick=LinkDisable;
		}
	}

}

// Log 59746 YC - this combo of functions allows users to deselect from a listbox when they click a selected option
function setorigval(evt) {
	var obj=websys_getSrcElement(evt);
	origval=obj.selectedIndex;
	obj.selectedIndex=-1;
}

function checkorigval(evt) {
	var obj=websys_getSrcElement(evt);
	if(obj.selectedIndex==origval) obj.selectedIndex=-1;
}
// END Log 59746

function ClearFields() {
	var field=document.getElementById("UserCode");
	if (field) field.value=session['LOGON.USERCODE'];

	var field=document.getElementById("ID");
	if (field) field.value="";

	var field=document.getElementById("Text");
	if (field) field.value="";

	var field=document.getElementById("BodySite");
	if (field) field.value="";

	var field=document.getElementById("Laterality");
	if (field) field.value="";

	var field=document.getElementById("Severity");
	if (field) field.value="";

	var field=document.getElementById("DurationNum");
	if (field) { field.value=""; field.className=""; }

	var field=document.getElementById("DurationUnit");
	if (field) { field.value=""; field.className=""; }

	var field=document.getElementById("ChiefComplaints");
	if (field) field.value=""; field.className="";

	var field=document.getElementById("Approx");
	if (field) field.checked=false;

	var field=document.getElementById("OnsetDate");
	if (field) { field.value=""; field.className=""; }

	var field=document.getElementById("OnsetTime");
	if (field) { field.value=""; field.className=""; }

	var field=document.getElementById("EndDate");
	if (field) { field.value=""; field.className=""; }

	var field=document.getElementById("EndTime");
	if (field) { field.value=""; field.className=""; }

	var field=document.getElementById("CalcDuration");
	if (field) field.innerText="";

	var field=document.getElementById("PIN");
	if (field) field.value="";

	return false;
}

function assignClickHandler() {
	var tbl=document.getElementById("tepr_SOAPSubjective");
	for (var i=1;i<tbl.rows.length;i++) {
		var objEdit=document.getElementById("Editz"+i)
		if (objEdit) objEdit.onclick=ClickHandler;
		var objDel=document.getElementById("delete1z"+i)
		if (objDel) objDel.onclick=DelClickHandler;
	}
	return false;
}

function ClickHandler(e) {
	var obj=websys_getSrcElement(e);
	if ((obj)&&(obj.tagName=="IMG")) obj=websys_getParentElement(obj);
	if (obj) {
		// clears and removes any red/invalid boxes
		ClearFields();

		var rowid=obj.id;
		var rowAry=rowid.split("z");
		var HIDDEN=document.getElementById("HIDDENz"+rowAry[1]).value;
		var temp=HIDDEN.split("^");

		var field=document.getElementById("ID");
		if (field) field.value=temp[0];

		var field=document.getElementById("Text");
		if (field) field.value=temp[1];

		var field=document.getElementById("BodySite");
		if (field) field.value=temp[2];

		var field=document.getElementById("Laterality");
		if (field) field.value=temp[3];

		var field=document.getElementById("Severity");
		if (field) field.value=temp[4];

		var field=document.getElementById("DurationNum");
		if (field) field.value=temp[5];

		var field=document.getElementById("DurationUnit");
		if (field) field.value=temp[6];

		var field=document.getElementById("ChiefComplaints");
		if (field) field.value=temp[7];

		var field=document.getElementById("Approx");
		if (field) {
			field.checked=false;
			if (temp[8] == "Y") field.checked=true;
		}

		var field=document.getElementById("OnsetDate");
		if (field) field.value=temp[9];

		var field=document.getElementById("OnsetTime");
		if (field) field.value=temp[10];

		var field=document.getElementById("EndDate");
		if (field) field.value=temp[11];

		var field=document.getElementById("EndTime");
		if (field) field.value=temp[12];

		var field=document.getElementById("CalcDuration");
		if (field) field.innerText=temp[13];

		var field=document.getElementById("PIN");
		if (field) field.value="";
	}
	return false;
}

// log 64759 YC - clears duration unit if duration num is deleted
function DurationNumChangeHandler() {
	var objN=document.getElementById("DurationNum");
	var objU=document.getElementById("DurationUnit");
	if (objN && objU && objN.value=="") objU.selectedIndex=-1;

	return DurationNum_changehandler();
}

function DelClickHandler() {
	if(!confirm(t['CONFIRM_DELETE'])) return false;
}

function UpdateClickHandler() {
	// declare vars & make sure they are all not clsInvalid
	var durobj=document.getElementById("DurationNum");
	if (durobj)	durobj.className="";
	var durunitobj=document.getElementById("DurationUnit");
	if (durunitobj) durunitobj.className="";
	var ODobj=document.getElementById("OnsetDate");
	if (ODobj) ODobj.className="";
	var OTobj=document.getElementById("OnsetTime");
	if (OTobj) OTobj.className="";
	var EDobj=document.getElementById("EndDate");
	if (EDobj) EDobj.className="";
	var ETobj=document.getElementById("EndTime");
	if (ETobj) ETobj.className="";

	// check that both duration and duration unit are entered (must be entered as pairs)
	if (durobj && durobj.value!="") {
		if (!durunitobj) {
			alert(t['DUR_MISSING']);
			return false;
		}
		else if(durunitobj.value=="") {
			durunitobj.className="clsInvalid";
			alert(t['DUR_MISSING']);
			return false;
		}
	}
	if (durunitobj) {
		if (durunitobj.value!="") {

			if (!durobj) {
				alert(t['DUR_MISSING']);
				return false;
			}
			else if (durobj.value=="") {
				durobj.className="clsInvalid";
				alert(t['DUR_MISSING']);
				return false;
			}
		}
	}

	// checks that onset date/time is not in the future
	if(ODobj && ODobj.value!="") {
		if (OTobj && OTobj.value!="") {
			if (DateTimeStringCompareToday(ODobj.value,OTobj.value)==1) {
				alert(t['OnsetDate']+" & "+t['OnsetTime']+" "+t['NOT_IN_FUTURE']);
				ODobj.className="clsInvalid";
				OTobj.className="clsInvalid";
				return false;
			}
		}
		if (DateStringCompareToday(ODobj.value)==1) {
			alert(t['OnsetDate']+" "+t['NOT_IN_FUTURE']);
			ODobj.className="clsInvalid";
			return false;
		}
	}

	// checks that end date/time is not in the future
	if(EDobj && EDobj.value!="") {
		if(ETobj && ETobj.value!="") {
			if (DateTimeStringCompareToday(EDobj.value,ETobj.value)==1) {
				alert(t['EndDate']+" & "+t['EndTime']+" "+t['NOT_IN_FUTURE']);
				EDobj.className="clsInvalid";
				ETobj.className="clsInvalid";
				return false;
			}
		}
		if (DateStringCompareToday(EDobj.value)==1) {
			alert(t['EndDate']+" "+t['NOT_IN_FUTURE']);
			EDobj.className="clsInvalid";
			return false;
		}
	}

	// check if onset date/time is before end date/time
	var compare=0;
	if (ODobj && EDobj && ODobj.value!="" && EDobj.value!="") {
		if (OTobj && ETobj && OTobj.value!="" && ETobj.value!="") {
			compare=DateTimeStringCompare(ODobj.value,OTobj.value,EDobj.value,ETobj.value);
		}
		else {
			compare=DateStringCompare(ODobj.value,EDobj.value);
		}
		if (compare==1) {
			alert(t['ONSET_AFTER_END']);
			ODobj.className="clsInvalid";
			EDobj.className="clsInvalid";
			if (OTobj) OTobj.className="clsInvalid";
			if (ETobj) ETobj.className="clsInvalid";
			return false;
		}
	}

	return update1_click();
}

document.body.onload = DocumentLoadHandler;


