// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
// Log 29736 - AI - 18-12-2003 : File created for new Profile.

var f=document.fDHCPERis_Edit_Profile;
var frm=document.forms['fDHCPERis_Edit_Profile'];
Init();
function Init() {
}
function UpdateClickHandler(e) {
	setParameters();
	return update1_click();
}
//
function LookUpDHCHealthEditProfile(val) {
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
function setParameters() {
	f.PPParameters.value=f.StationID.value;
}
function AddParams(str) {
	var arr=str.split('|');
	str=arr[0];
	var objStationID=frm.elements['StationID'];
	if (str&&(objStationID)) {
		objStationID.value=str;
		var evt = document.createEventObject();
		frm.elements['GetStationDesc'].fireEvent("onchange",evt);
	}
}
function GetStationDesc_changehandler(encmeth) {
	var objStationDesc=frm.elements['StationDesc1'];
	var objStation=frm.elements['Station'];
	if (objStationDesc)	{		
		objStationDesc.value=cspRunServerMethod(encmeth,frm.elements['StationID'].value);
		objStation.value=objStationDesc.value;
	}
}

function DHCHealthCheckStation1(str)	{
	var arr=str.split('^');
	var objStationID=frm.elements['StationID'];
	var objStationDesc=frm.elements['StationDesc1'];
	if (arr[2]&&(objStationID))	{
		objStationID.value=arr[2];
		objStationDesc.value=arr[0];
		
	}
}