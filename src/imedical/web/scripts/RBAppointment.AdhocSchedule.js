//Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.


function BodyLoadHandler() {
	var obj=document.getElementById("update");
	if (obj) obj.onclick=UpdateClickHandler;
}

function ResourceToLookUp(str) {
	var lu = str.split("^");
	
	var obj=document.getElementById("ResToId");
	if (obj) obj.value=lu[2]
}

function CheckValidDateTime() {
	var FromStTime,FromEndTime=""
	var msg=""
	var obj=document.getElementById("FromStTime")
	if (obj) FromStTime=obj.value
	var obj=document.getElementById("FromEndTime")
	if (obj) FromEndTime=obj.value
	
	if (FromStTime,FromEndTime!="") {
		//0=they are equal, -1=valid, 1=invalid
		if (TimeStringCompare(FromStTime,FromEndTime)!=-1) msg=t['InvalidDateTime']
		
	}
	if (msg=="") {
		return true;
	} else {
		alert(msg)
		return false;
	}	
	
}
function UpdateClickHandler() {
	if (CheckValidDateTime()) return update_click();
}

document.body.onload = BodyLoadHandler;