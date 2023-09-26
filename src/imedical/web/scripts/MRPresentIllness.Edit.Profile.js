// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var f=document.fMRPresentIllness_Edit_Profile;

function UpdateClickHandler(e)
{
	setParameters()
	return update1_click()
}

function setParameters()
{
	// Present Illnesses checkbox
	if (f.PresentIllness)
	{
		if (f.PresentIllness.checked==true) {var presentIllness=1} else {var presentIllness=0;}
	} else {
		var presentIllness=0;
	}

	// Past Illnesses checkbox
	if (f.PastIllness)
	{
		if (f.PastIllness.checked==true) {var pastIllness=1} else {var pastIllness=0;}
	} else {
		var pastIllness=0;
	}

	f.PPParameters.value=presentIllness+"|"+pastIllness;
}

var frm=document.forms['fMRPresentIllness_Edit_Profile'];

function LookUpPresentIllnessProfileName(val)
{
	var ary=val.split("^");
	frm.elements['ID'].value=ary[1];
	//fire broker to fetch params from selected profile id
	//frm.elements['xfetchparams'].change();
	//NB: may not work with N6
	var evt = document.createEventObject();
	frm.elements['xfetchparams'].fireEvent("onchange",evt);
}

//wrapper to call broker on hidden field to fetch params
function xfetchparams_changehandler(encmeth)
{
	if (cspRunServerMethod(encmeth,'AddParams',frm.elements['ID'].value))
	{
	}
}

function completeForm(str,graph)
{
	AddParams(str.join('|'));
}

function AddParams(str)
{
	var arr=str.split('|');

	if (arr[0]&&(f.PresentIllness))
	{
		if (arr[0]==1) {f.PresentIllness.checked=true;} else {f.PresentIllness.checked=false}
	}
	else
	{
		if (f.PresentIllness){f.PresentIllness.checked=false;}
	}
	if (arr[1]&&(f.PastIllness))
	{
		if (arr[1]==1) {f.PastIllness.checked=true;} else {f.PastIllness.checked=false}
	}
	else
	{
		if (f.PastIllness){f.PastIllness.checked=false;}
	}
	/*
	// Log 55973 - PJC - 20-12-2005 : Add the "Only show entries marked for DS Report" checkbox.
	if (arr[7]&&(f.OnlyShowEntriesMarkedForDS))
	{
		if (arr[7]==1) {f.OnlyShowEntriesMarkedForDS.checked=true;} else {f.OnlyShowEntriesMarkedForDS.checked=false}
	} else {
		if (f.OnlyShowEntriesMarkedForDS)
		{
			f.OnlyShowEntriesMarkedForDS.checked=false;
		}
	}
	// end Log 55973
	*/

}

