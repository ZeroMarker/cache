// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function DocumentLoadHandler() {
	assignClickHandler();
	var origval;
	var obj;

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

	var objNew=document.getElementById("new1");
	if (objNew) objNew.onclick=ClearFields;

	// Reload all epr.SOAPPlanning frames - so on update, we can see new order lists
	if (window.parent) {
		for (i=0;i<window.parent.frames.length;i++) {
			if (window.parent.frames[i].name=="fSOAPP") {
				websys_createWindow(window.parent.frames[i].frameElement.src,"fSOAPP");
			}
		}
	}

	var objUpdate=document.getElementById("update1");
	if (objUpdate) {
		objUpdate.onclick=UpdateHandler;
		if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateHandler;
	}

	var obj=document.getElementById("DiagList1");
	if (obj) obj.onchange=SelectDiagHandler;
	var obj=document.getElementById("DiagList2");
	if (obj) obj.onchange=SelectDiagHandler;
	var obj=document.getElementById("CurrentIllness");
	if (obj) obj.onchange=SelectDiagHandler;

	LoadDiagParams();

	var epId=document.getElementById("EpisodeID");
	var conEpId=document.getElementById("ConsultEpisodeID");
	if(epId && conEpId && conEpId.value!="" && conEpId.value!=epId.value){
		if(objUpdate){
			objUpdate.disabled=true;
			objUpdate.onclick=LinkDisable;
		}
		if(objNew){
			objNew.disabled=true;
			objNew.onclick=LinkDisable;
		}
	}
}

// ab 27.11.06 61666 - make this consistent with MRDiagnos.Edit, either you select a fav diagnosis or you use the diagnosis field
function SelectDiagHandler(e) {
	//var eSrc=websys_getSrcElement(e);
	var obj1=document.getElementById("DiagList1");
	var obj2=document.getElementById("DiagList2");
	var obj3=document.getElementById("CurrentIllness");

	if (((obj1)&&(obj1.selectedIndex!=-1))||((obj2)&&(obj2.selectedIndex!=-1))||((obj3)&&(obj3.selectedIndex!=-1))) {
		DisableField("MRDIAICDCodeDR");
		DisableLookup("ld2185iMRDIAICDCodeDR");
		var objCode=document.getElementById("MRCIDCode");
		if (objCode) objCode.value="";
	} else {
		EnableField("MRDIAICDCodeDR");
		EnableLookup("ld2185iMRDIAICDCodeDR");
	}
}

// ab 24.07.06 59776
function LoadDiagParams() {
	var params="";
	var obj=document.getElementById("DiagParams");
	if (obj) params=obj.value;

	if (params!="") {
		params=params.split(String.fromCharCode(1));
		var obj=document.getElementById("DiagDesc1");
		if (obj) obj.innerText=params[0];
		var obj=document.getElementById("DiagDesc2");
		if (obj) obj.innerText=params[1];
	}
}

// ab 26.07.06 59776
function SetMultiDiag() {
	var DiagString="";

	var lists = new Array("DiagList1","DiagList2","CurrentIllness");
	for (var j=0;j<lists.length; j++) {
		var obj=document.getElementById(lists[j]);
		if (obj) {
			for (var i=0; i<obj.length; i++) {
				if (obj.options[i].selected==true) {
					if (DiagString!="") DiagString=DiagString+"^";
					DiagString=DiagString+obj.options[i].value;
				}
			}
		}
	}

	var obj=document.getElementById("MultiDiag");
	if (obj) obj.value=DiagString;
}

function UpdateHandler() {
	SetMultiDiag();

	// declare vars & make sure they are all not clsInvalid
	var durobj=document.getElementById("DurationNum");
	if (durobj)	durobj.className="";
	var durunitobj=document.getElementById("DurationUnit");
	if (durunitobj) durunitobj.className="";
	var ODobj=document.getElementById("MRDIAOnsetDate");
	if (ODobj) ODobj.className="";
	var OTobj=document.getElementById("MRDIAOnsetTime");
	if (OTobj) OTobj.className="";
	var EDobj=document.getElementById("MRDIAEndDate");
	if (EDobj) EDobj.className="";
	var ETobj=document.getElementById("MRDIAEndTime");
	if (ETobj) ETobj.className="";
	var objd=document.getElementById("MRDIADateDiagnosisIdentif");
	if (objd) objd.className="";
	var objt=document.getElementById("MRDIATimeDiagnosisIdentif");
	if (objt) objt.className="";

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
				alert(t['MRDIAOnsetDate']+" & "+t['MRDIAOnsetTime']+" "+t['NOT_IN_FUTURE']);
				ODobj.className="clsInvalid";
				OTobj.className="clsInvalid";
				return false;
			}
		}
		if (DateStringCompareToday(ODobj.value)==1) {
			alert(t['MRDIAOnsetDate']+" "+t['NOT_IN_FUTURE']);
			ODobj.className="clsInvalid";
			return false;
		}
	}

	// checks that end date/time is not in the future
	if(EDobj && EDobj.value!="") {
		if(ETobj && ETobj.value!="") {
			if (DateTimeStringCompareToday(EDobj.value,ETobj.value)==1) {
				alert(t['MRDIAEndDate']+" & "+t['MRDIAEndTime']+" "+t['NOT_IN_FUTURE']);
				EDobj.className="clsInvalid";
				ETobj.className="clsInvalid";
				return false;
			}
		}
		if (DateStringCompareToday(EDobj.value)==1) {
			alert(t['MRDIAEndDate']+" "+t['NOT_IN_FUTURE']);
			EDobj.className="clsInvalid";
			return false;
		}
	}

	// checks that date/time diagnos identif is not in the future
	if(objd && objd.value!="") {
		if(objt && objt.value!="") {
			if (DateTimeStringCompareToday(objd.value,objt.value)==1) {
				alert(t['MRDIADateDiagnosisIdentif']+" & "+t['MRDIATimeDiagnosisIdentif']+" "+t['NOT_IN_FUTURE']);
				objd.className="clsInvalid";
				objt.className="clsInvalid";
				return false;
			}
		}
		if (DateStringCompareToday(objd.value)==1) {
			alert(t['MRDIADateDiagnosisIdentif']+" "+t['NOT_IN_FUTURE']);
			objd.className="clsInvalid";
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

	// checks that d/t diagnosis identif is after onset d/t
	if (objd && ODobj && objd.value!="" && ODobj.value!="") {
		if(objt && OTobj && objt.value!="" && OTobj.value!="") {
			if(DateTimeStringCompare(ODobj.value,OTobj.value,objd.value,objt.value)==1) {
				// Onset Date & Onset Time must be before Date Diagnosis Identified & Time Diagnosis Identified
				alert(t['MRDIAOnsetDate']+" & "+t['MRDIAOnsetTime']+" "+t['DT_BEFORE']+" "+t['MRDIADateDiagnosisIdentif']+" & "+t['MRDIATimeDiagnosisIdentif']);
				ODobj.className="clsInvalid";
				objd.className="clsInvalid";
				OTobj.className="clsInvalid";
				objt.className="clsInvalid";
				return false;
			}
		}
		else if(DateStringCompare(ODobj.value,objd.value)==1) {
			// Onset Date must be before Date Diagnosis Identified
			alert(t['MRDIAOnsetDate']+" "+t['DT_BEFORE']+" "+t['MRDIADateDiagnosisIdentif']);
			ODobj.className="clsInvalid";
			objd.className="clsInvalid";
			return false;
		}
	}

	return update1_click();
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

function ClearFields(e) {
	var field=document.getElementById("UserCode");
	if (field) field.value=session['LOGON.USERCODE'];

	var field=document.getElementById("ID");
	if (field) field.value="";

	var field=document.getElementById("MRDIAOnsetDate");
	if (field) { field.value=""; field.className=""; }

	var field=document.getElementById("MRDIAOnsetTime");
	if (field) { field.value=""; field.className=""; }

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

	var field=document.getElementById("MRDIAICDCodeDR");
	if (field) field.value="";

	var field=document.getElementById("MRDIADesc");
	if (field) field.value="";

	var field=document.getElementById("MRCIDCode");
	if (field) field.value="";

	var field=document.getElementById("PIN");
	if (field) field.value="";

	var field=document.getElementById("MRDIADiagStatDR");
	if (field) field.value="";

	var field=document.getElementById("MRDIAActive");
	if (field) field.checked=false;

	// Log 61970 YC - Add diag fields and current illness
	var field=document.getElementById("DiagList1");
	if (field) field.selectedIndex=-1;

	var field=document.getElementById("DiagList2");
	if (field) field.selectedIndex=-1;

	var field=document.getElementById("CurrentIllness");
	if (field) field.selectedIndex=-1;

	var field=document.getElementById("MRDIAEndDate");
	if (field) { field.value=""; field.className=""; }

	var field=document.getElementById("MRDIAEndTime");
	if (field) { field.value=""; field.className=""; }

	var field=document.getElementById("MRDIADateDiagnosisIdentif");
	if (field) field.value="";

	var field=document.getElementById("MRDIATimeDiagnosisIdentif");
	if (field) field.value="";

	var field=document.getElementById("MRDIAApproximate");
	if (field) field.checked=false;

	var field=document.getElementById("CalcDuration");
	if (field) field.innerText="";

	SelectDiagHandler();

	return false;
}

function assignClickHandler() {
	var tbl=document.getElementById("tepr_SOAPAssessment");
	for (var i=1;i<tbl.rows.length;i++) {
		var objEdit=document.getElementById("Editz"+i);
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

		var field=document.getElementById("MRDIAOnsetDate");
		if (field) field.value=temp[1];

		var field=document.getElementById("MRDIAOnsetTime");
		if (field) field.value=temp[2];

		// Comments
		var field=document.getElementById("MRDIADesc");
		if (field) field.value=temp[3];

		// Diagnosis
		var field=document.getElementById("MRDIAICDCodeDR");
		if (field) field.value=temp[4];

		// Diagnosis id
		var field=document.getElementById("MRCIDCode");
		if (field) field.value=temp[5];

		var field=document.getElementById("BodySite");
		if (field) field.value=temp[6];

		var field=document.getElementById("Laterality");
		if (field) field.value=temp[7];

		var field=document.getElementById("Severity");
		if (field) field.value=temp[8];

		var field=document.getElementById("DurationNum");
		if (field) field.value=temp[9];

		var field=document.getElementById("DurationUnit");
		if (field) field.value=temp[10];

		var field=document.getElementById("MRDIADiagStatDR");
		if (field) field.value=temp[11];

		var field=document.getElementById("PIN");
		if (field) field.value="";

		var field=document.getElementById("MRDIAActive");
		if (field) {
			field.checked=false;
			if (temp[12] == "N") field.checked=true
		}

		var field=document.getElementById("MRDIADateDiagnosisIdentif");
		if (field) field.value=temp[13];

		var field=document.getElementById("MRDIATimeDiagnosisIdentif");
		if (field) field.value=temp[14];

		var field=document.getElementById("MRDIAEndDate");
		if (field) field.value=temp[15];

		var field=document.getElementById("MRDIAEndTime");
		if (field) field.value=temp[16];

		var field=document.getElementById("MRDIAApproximate");
		if (field) {
			field.checked=false;
			if (temp[17] == "Y") field.checked=true
		}

		var field=document.getElementById("CalcDuration");
		if (field) field.innerText=temp[18];
	}
	return false;
}

function DelClickHandler() {
	if(!confirm(t['CONFIRM_DELETE'])) return false;
}

function LookUpDiagnos(str)
{
	var lu=str.split("^");
	var objDesc=document.getElementById("MRDIAICDCodeDR");
	if (objDesc) objDesc.value=lu[0];
	var objCode=document.getElementById("MRCIDCode");
	if (objCode) objCode.value=lu[2];
}

// log 64759 YC - clears duration unit if duration num is deleted
function DurationNumChangeHandler() {
	var objN=document.getElementById("DurationNum");
	var objU=document.getElementById("DurationUnit");
	if (objN && objU && objN.value=="") objU.selectedIndex=-1;

	return DurationNum_changehandler();
}

document.body.onload = DocumentLoadHandler;
