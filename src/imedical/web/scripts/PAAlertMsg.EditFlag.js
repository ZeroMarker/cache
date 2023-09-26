// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function Init() {
	var obj1=document.getElementById('ALMClosedFlag');
	var obj2=document.getElementById('ALMAlertDR');
	var obj3=document.getElementById('ALMMessage');
	if ((obj1)&&(obj2)&&(obj3)) {
		if (obj1.checked) {
			obj1.disabled=true;
			obj2.disabled=true;
			obj3.disabled=true;
		} else {
			obj1.disabled=false;
			obj2.disabled=false;
			obj3.disabled=false;
		}
	}
}

document.body.onload=Init