// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.


var admType=document.getElementById('PAADMType');

function CareProvChangeHandler(str) {
	var lu = str.split("^");

	var obj=document.getElementById("CTPCPCode");
	if (obj) obj.value=lu[1];
	var obj=document.getElementById('TRANSCTLOCDR')
	if ((obj)&&(lu[2]!="")) obj.value=lu[2];
	var obj=document.getElementById('HOSPDesc')
	if (obj) obj.value=lu[5];
	var obj=document.getElementById("LocationID");
	if ((obj)&&(lu[4]!="")) obj.value = lu[4];
}

function EditListBodyLoadHandler() {
	var obj=document.getElementById('TRANSStartDate');
	if (obj) obj.onblur=StartDateBlurHandler;

	if (admType.value!="E") alert(t['InvalidAdmType']);

	var obj=document.getElementById('update1');
	if (obj) obj.onclick=UpdateAll;
}

function StartDateBlurHandler(e) {
	var eobj=websys_getSrcElement(e);
	if (eobj) {
		var obj=document.getElementById("TRANSStartDateH");
		if ((obj)&&(eobj.value!="")) obj.value=DateStringTo$H(eobj.value);
		if ((obj)&&(eobj.value=="")) obj.value=obj.defaultValue;
	}
}

function UpdateAll() {
	
	if (admType.value!="E") {alert(t['InvalidAdmType']); return false;}
	return update1_click();
}

function LocationChangeHandler(str) {
	try {
		CustomLocationChangeHandler(str);
	} catch(e) {
		var lu = str.split("^");
		if (lu[1]!="") {
			var obj=document.getElementById("TRANSCTLOCDR");
			if (obj) obj.value = lu[1];
			var obj=document.getElementById("HOSPDesc");
			if (obj) obj.value = lu[6];
			var obj=document.getElementById("LocationID");
			if (obj) obj.value = lu[3];
			
		}
	}
}


document.body.onload=EditListBodyLoadHandler;
