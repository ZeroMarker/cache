//Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function BodyLoadHandler(e) {
	RollCount()
}

function RollCount() {
	var WIDStr=document.getElementById("WIDStr");
	var RollCnt=document.getElementById("NewRollCount");
	if ((WIDStr) && (RollCnt))
	{
		if(WIDStr.value == "AllRecords")		// MK, L: 29309
		{
			var count = document.getElementById("QueryCount");
			if(count) RollCnt.value = count.value;
		}
		else
		{
			WIDAry=WIDStr.value.split("^");
			RollCnt.value=WIDAry.length;
		}
	}
}

function WLTypeLookUpHandler(str) {
 	var lu = str.split("^");
	var obj;
	// SA 10.12.01: Function to default Department and Doctor if one 
	// is associated with the Waiting List Type selected.
	if (lu[2]!="") {
		obj=document.getElementById("NewSpeciality");
		if (obj) obj.value = lu[2];
	}
	if (lu[3]!="") {
		obj=document.getElementById("NewConsult");
		if (obj) obj.value = lu[3];
	}
	if (lu[4]!="") {
		obj=document.getElementById("NewHospital");
		if (obj) obj.value = lu[4];
	}
	
}

function LocLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById('NewSpeciality');
	if (obj) obj.value = lu[1];
}

function HospLookup(str) {
	var lu = str.split("^");
	var obj=document.getElementById("HospID");
	if (obj) obj.value=lu[1];
}
document.body.onload=BodyLoadHandler;