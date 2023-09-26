// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
var tbl=document.getElementById("tRBEventValidation_Results");

function DocumentLoadHandler() {
	var obj = document.getElementById("type")
	if (obj && obj.value=="FAC") highlightFacilitatorRows();
}

function highlightFacilitatorRows() {
	var cName=""
	for (var i=1;i<tbl.rows.length;i++) {
		//if (tbl.rowIndex>0) {if (tbl.rowIndex%2==0) {cName="RowEven1";} else {cName="RowOdd1";}}
		tbl.rows[i].className="RowOdd1";
	}
	return;
}

document.body.onload = DocumentLoadHandler;