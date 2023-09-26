//Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

//log 57690 TedT
function BodyLoadHandler() {
	var obj=document.getElementById('Find');
	if (obj) obj.onclick=FindClickHandler;
}

function FindClickHandler() {
	
	var empty=true;
	var UniqueKey=document.getElementById('UniqueKey');
	if (empty && UniqueKey && UniqueKey.value!="") empty=false;
	var RecordType=document.getElementById('RecordType');
	if (empty && RecordType && RecordType.value!="") empty=false;
	var PatientNumber=document.getElementById('PatientNumber');
	if (empty && PatientNumber && PatientNumber.value!="") empty=false;
	var BatchNumber=document.getElementById('BatchNumber');
	if (empty && BatchNumber && BatchNumber.value!="") empty=false;
	
	if (empty) {
		alert(t['EMPTY']);
		return false;
	}
	
	var obj=document.getElementById('flag');
	if(obj) obj.value=1;
	
	Find_click();
}

document.body.onload=BodyLoadHandler;
