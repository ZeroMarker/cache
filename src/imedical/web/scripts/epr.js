// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

//If this edit component is called from an epr chart then need to refresh chart on update.
//Target adjusted here and serversideredirect changed to chart CSP page in websysBeforeSave

function setTargetWindow(ChartID) {
	var win=window;
	if (ChartID!="") {while (win.opener) {win=win.opener}}
	return win.name;
}

function epr_RepeatClickHandler(evt,frm) {
	var el=document.getElementById('TWKFLI');
	if (frm) el=frm.TWKFLI;
	if ((el)&&(el.value!="")) {
		el.value = el.defaultValue - 1;
		ValidateUpdate();
	}
	return Repeat_click();
}

//used for textarea lookup with websys.ReplaceLookupCode.js
var lookupqryNURN="Kweb.MRCNursingNoteCodes:LookUpByCode";
var jsfuncNURN="NursingNoteCodes_lookupSelect";