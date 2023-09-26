// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var tbl=document.getElementById("tINRequest_List");

function BodyLoadHandler(){
	var sobj="";
	if (tbl) {
		for (i=1; i<tbl.rows.length; i++) {
			sobj=document.getElementById("INRQUserCompletedz"+i);
			if(sobj) {
				sobj.disabled=true;
				sobj.onclick=returnFalse
			}
		}
	}
}

function returnFalse(){
	return false;
}

function refresh() {
	var find=document.getElementById("find");
	if (find) find.click();
}

document.body.onload = BodyLoadHandler;
