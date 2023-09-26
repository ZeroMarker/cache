// Copyright (c) 2006 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
// ab 11.05.06 52166


var obj=document.getElementById("PARREF");
if ((obj)&&(obj.value=="")) {
	var obj=document.getElementById("new1");
	if (obj) {
		obj.disabled=true;
		obj.onclick=LinkDisable;
	}
} else {
	var obj=document.getElementById("new1");
	if (obj) {
		obj.onclick = NewClickHandler;
	}
}




function NewClickHandler () {
	var ID = document.getElementById('ID');
	var TotalControls = document.getElementById('TotalControls');
	if (TotalControls.value>329) {
		alert(t["ControlsExceed330"]);
		return false;
	}
	var url="websys.default.csp?WEBSYS.TCOMPONENT=SSUserDefWindowControls.Edit&PARREF=" + ID.value;
	//Log: 59598, 03-07-2006 BC: add "status=yes"
	window.open(url,"SSUserDefWindowControlsEdit","top=50,left=50,width=700,height=500,scrollbars=yes,status=yes");
}


// conflicts with .edit bodyloadhandler
//document.body.onload = BodyLoadHandler;
