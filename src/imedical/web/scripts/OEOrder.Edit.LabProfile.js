// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

f=document.fOEOrder_Edit_LabProfile;
//create a global array (arrTestItems) matching testcodes with their descriptions, eg: arrTestItems['A010']='Full Blood Count';
//this avoids multiple looping for matches.
var arrTestItems=new Array();
var arrtempval=allcatval.split(',');
var arrtemptxt=allcattxt.split('^');
for (var i=0;i<arrtempval.length;i++) {
	arrTestItems[arrtempval[i]]=arrtemptxt[i];
}

function UpdateClickHandler(e) {
	ary=returnValues(f.CategorySelected);
	if (f.EpisodesAll) {
		if (f.EpisodesAll.checked==true) {var eAll=1} else {var eAll=0;}
	} else {
		var eAll=0;
	}
	f.PPParameters.value=ary.join(",")+"|"+eAll;
	return update1_click()
}
var frm=document.forms['fOEOrder_Edit_LabProfile'];

function LookUpLabProfileName(val) {
	var ary=val.split("^");
	frm.elements['ID'].value=ary[1];
	//fire broker to fetch params from selected profile id
	//frm.elements['xfetchparams'].change();
	//NB: may not work with N6
	var evt = document.createEventObject();
	frm.elements['xfetchparams'].fireEvent("onchange",evt);
}
//wrapper to call broker on hidden field to fetch params
function xfetchparams_changehandler(encmeth) {
	if (cspRunServerMethod(encmeth,'AddParams',frm.elements['ID'].value)) {
	}
}
function completeForm(str,graph) {
	AddParams(str.join('|'));
}
function AddParams(str) {
	var arr=str.split('|');
	str=arr[0];
	if (str) {
		lst=frm.elements['CategorySelected'];
		ClearAllList(lst);
		var arrParams=str.split(',');
		var code='';
		for (var i=0; i<arrParams.length; i++) {
			code=arrParams[i];
			lst.options[lst.options.length] = new Option(arrTestItems[code],code);
		}
	}
	var objEpisAll=frm.elements['EpisodesAll'];
	if (arr[1]&&(objEpisAll)) {
		if (arr[1]==1) {objEpisAll.checked=true;} else {objEpisAll.checked=false;}
	} else {
		if (objEpisAll) {
			objEpisAll.checked=false;
		}
	}
}