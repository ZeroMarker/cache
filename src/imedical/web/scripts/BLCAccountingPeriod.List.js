// Copyright (c) 2004 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function AssignClickHandler() {
	var tbl=document.getElementById("tBLCAccountingPeriod_List");

	for (var i=1;i<tbl.rows.length;i++) {
		var obj=document.getElementById("Closez"+i)
		if (obj) obj.onclick = ClosePeriodHandler;
	}
}

function ClosePeriodHandler(evt) {
	return confirm(t["CONFIRMATION"]);
}

document.body.onload=AssignClickHandler;

