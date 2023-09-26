//Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
// ab 8.05.06 50671

function BodyLoadHandler() {
	var obj=document.getElementById("find1");
	if (obj) obj.onclick=FindClickHandler;
	if (tsc['find1']) websys_sckeys[tsc['find1']]=FindClickHandler;
}

function FindClickHandler() {
	var obj=document.getElementById("table");
	if ((obj)&&(obj.className=="clsInvalid")) {
		alert(t["table"]+" "+t["XINVALID"]);
		return false;
	}
	var obj=document.getElementById("UserCode");
	if ((obj)&&(obj.className=="clsInvalid")) {
		alert(t["UserCode"]+" "+t["XINVALID"]);
		return false;
	}
	return find1_click();
}

document.body.onload=BodyLoadHandler;
