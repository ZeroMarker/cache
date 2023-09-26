// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function Init() {
	var obj=document.getElementById('SelectAll');
	if (obj) obj.onclick=SelectAll;
	obj=document.getElementById('SelectNone');
	if (obj) obj.onclick=SelectNone;
}

function SelectAll() {
	SelectRows(1);
}

function SelectNone() {
	SelectRows(0);
}

function SelectRows(OnOff) {
	var f=document.getElementById("fChartFX_Select_List");
	var tbl=document.getElementById("tChartFX_Select_List");
	for (var i=1;i<tbl.rows.length;i++) {
		if (OnOff==1) { f.elements["Selectz"+i].checked = true;}
		else { f.elements["Selectz"+i].checked = false;}
	}
	return false;
}

document.body.onload=Init
