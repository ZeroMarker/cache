// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var f=document.fMRDiagnos_Edit_Profile;

function UpdateClickHandler(e)
{
	setParameters()
	return update1_click()
}

function setParameters()
{
	// Present Illnesses checkbox
	if (f.ActiveDiagnosis)
	{
		if (f.ActiveDiagnosis.checked==true) {var active=1} else {var active=0;}
	} else {
		var active=0;
	}

	// Past Illnesses checkbox
	if (f.InactiveDiagnosis)
	{
		if (f.InactiveDiagnosis.checked==true) {var inactive=1} else {var inactive=0;}
	} else {
		var inactive=0;
	}

	f.PPParameters.value=active+"|"+inactive;
}

var frm=document.forms['fMRDiagnos_Edit_Profile'];

function LookUpDiagnosProfileName(val)
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

	if (arr[0]&&(f.ActiveDiagnosis))
	{
		if (arr[0]==1) {f.ActiveDiagnosis.checked=true;} else {f.ActiveDiagnosis.checked=false}
	}
	else
	{
		if (f.ActiveDiagnosis){f.ActiveDiagnosis.checked=false;}
	}
	if (arr[1]&&(f.InactiveDiagnosis))
	{
		if (arr[1]==1) {f.InactiveDiagnosis.checked=true;} else {f.InactiveDiagnosis.checked=false}
	}
	else
	{
		if (f.InactiveDiagnosis){f.InactiveDiagnosis.checked=false;}
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


