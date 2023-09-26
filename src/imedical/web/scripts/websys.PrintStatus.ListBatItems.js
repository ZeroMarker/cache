// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var rowIDs="";

function BodyLoadHandler() {
	var objReprintSelected=document.getElementById("ReprintSelected");
	var objReprintBatch=document.getElementById("ReprintBatch");
	if (objReprintSelected) objReprintSelected.onclick=GetRowsSelected;
	if (objReprintBatch) objReprintBatch.onclick=GetAllRows;
}	

function GetRowsSelected() {
	var objID=document.getElementById("ID");
	var objRowIDs=document.getElementById("RowIDs");

	var tbl=document.getElementById("twebsys_PrintStatus_ListBatItems");
	var f=document.getElementById("fwebsys_PrintStatus_ListBatItems");

	if ((f)&&(tbl)) {
		var aryID=new Array(); var aryStat=new Array(); var n=0;
		for (var i=1;i<tbl.rows.length;i++) {
			if ((f.elements["Selectz"+i])&&(f.elements["Selectz"+i].checked)) {
				aryID[n]=f.elements['IDz'+i].value;
				n++;
			} else if (tbl.rows[i].className=="clsRowSelected") {
				aryID[n]=f.elements['IDz'+i].value;
				n++;
			}
		}
		objRowIDs.value=aryID.join("^");
		//alert("objRowIDs="+objRowIDs.value);
	}
	return ReprintSelected_click();
}

function GetAllRows() {
	var objID=document.getElementById("ID");
	var objRowIDs=document.getElementById("RowIDs");

	var tbl=document.getElementById("twebsys_PrintStatus_ListBatItems");
	var f=document.getElementById("fwebsys_PrintStatus_ListBatItems");

	if ((f)&&(tbl)) {
		var aryID=new Array(); var aryStat=new Array(); var n=0;
		for (var i=1;i<tbl.rows.length;i++) {
			if (f.elements["Selectz"+i]) {
				aryID[n]=f.elements['IDz'+i].value;
				n++;
			}
		}
		objRowIDs.value=aryID.join("^");
		//alert("objRowIDs="+objRowIDs.value);
	}
	return ReprintBatch_click();
}

document.body.onload=BodyLoadHandler;
