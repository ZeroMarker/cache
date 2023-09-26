// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

// Log 41303 - AI - 12-12-2003 : File created for new Profile.

var f=document.fOEOrder_Edit_TheatreProfile;
var frm=document.forms['fOEOrder_Edit_TheatreProfile'];

function UpdateClickHandler(e) {
	var eAll=0;
	if ((f.EpisodesAll) && (f.EpisodesAll.checked==true)) eAll=1;
	f.PPParameters.value=eAll;
	return update1_click();
}

function completeForm(str,graph) {
	AddParams(str.join('|'));
}

function AddParams(str) {
	var arr=str.split('|');
	var objEpisAll=frm.elements['EpisodesAll'];
	if (objEpisAll) {
		if (arr[0]==1) {
			objEpisAll.checked=true;
		} else {
			objEpisAll.checked=false;
		}
	}
}

function LookUpTheatreProfileName(val) {
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


