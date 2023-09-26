// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function Init() {
	websys_firstfocus();

	var obj;

	setLinks()

	//alert("chris")
	//setConsultantFilter()

}

function setLinks() {
	var objID=document.getElementById('ID');

	obj=document.getElementById('SLADPAADMDR');
	if ((obj)&&(obj.value=="")) {
		SetupHiddenLink("EpisodeDetails");
	}

	obj=document.getElementById('SLADAPPTDR');
	if ((obj)&&(obj.value=="")) {
		SetupHiddenLink("AppointmentDetails");
	}

	obj=document.getElementById('SLADWaitListDR');
	if ((obj)&&(obj.value=="")) {
		SetupHiddenLink("WLDetails");
	}

	obj=document.getElementById('SLADAdmWardAttendDR');
	if ((obj)&&(obj.value=="")) {
		SetupHiddenLink("WardAttenderDetails");
	}

}


function SetupHiddenLink(link) {
	var obj=document.getElementById(link);
		if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}
}

function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	//if (el.id=="ViewableBy") VIEWABLE=el;
	if (el.disabled) {
		return false;
	}
	return true;
}


document.body.onload=Init;