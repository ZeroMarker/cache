// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function UpdateHandler() {
	var Rtnobj=document.getElementById("ReturnDate");
	if ((Rtnobj)&&(Rtnobj.value!="")) {
		if (DateStringCompareToday(Rtnobj.value)<0) {
			alert(t['INVALID_RTNDATE']);
			return false;
		}
	}
	return Update_click();
}

if (tsc['Update']) {
	websys_sckeys[tsc['Update']]=UpdateHandler;
}

var obj=document.getElementById("Update");
if (obj) obj.onclick=UpdateHandler;
