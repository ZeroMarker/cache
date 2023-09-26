// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var rowIDs="";

function BodyLoadHandler() {
	var objPrintBatch=document.getElementById("PrintBatch");
	if (objPrintBatch) objPrintBatch.onclick=GetRowsSelected;
	var objSelectAll=document.getElementById("SelectAll");
	if (objSelectAll) objSelectAll.onclick=SelectAllHandler;
}	

function GetRowsSelected() {
	var objID=document.getElementById("ID");
	var objRowIDs=document.getElementById("PrintRowIDs");

	var tbl=document.getElementById("twebsys_PrintStatus_ListDeferred");
	var f=document.getElementById("fwebsys_PrintStatus_ListDeferred");
	if ((f)&&(tbl)) {
		//var aryfound=checkedCheckBoxes(f,tbl,"Selectz");
		var aryID=new Array(); var aryStat=new Array(); var n=0;
		for (var i=1;i<tbl.rows.length;i++) {
			if ((f.elements["SelectBoxz"+i])&&(f.elements["SelectBoxz"+i].checked)) {
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
	return PrintBatch_click();
}

function SelectAllHandler(e) {
	var eSrc = websys_getSrcElement(e);
	if (eSrc.id=="SelectAll") {
		var tbl=document.getElementById("twebsys_PrintStatus_ListDeferred");
		var f=document.getElementById("fwebsys_PrintStatus_ListDeferred");
		if ((f)&&(tbl)) {
			for (var i=0;i<tbl.rows.length;i++) {
				var obj=document.getElementById('SelectBoxz'+i);
				if (obj) {
					obj.checked=true;
				}
			}
		}
	}
	return false;
}

document.body.onload=BodyLoadHandler;
