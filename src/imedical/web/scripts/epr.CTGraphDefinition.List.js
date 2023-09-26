// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

// Log 44734 - AI - 06-10-2004 : File created to disable links the User does not have access to.

var nRows=0;

function BodyLoadHandler() {
	var tbl, x, obj1;
	var tbl=document.getElementById("tepr_CTGraphDefinition_List");
	if (tbl) {
		nRows=tbl.rows.length;
		for(x=1; x<nRows; x++) {
			obj1=document.getElementById("GRPHCodez"+x);
			obj2=document.getElementById("graphchkz"+x);
			if ((obj2)&&(obj2.value=="Y")) {
				if (obj1) obj1.disabled=true;
			}
		}
		assignChkHandler();
	}
}

function assignChkHandler() {
	for (var i=1;i<nRows;i++) {
		var obj=document.getElementById("GRPHCodez"+i)
		obj.onclick = GRPHCodeClickHandler;
	}
	return;
}

function GRPHCodeClickHandler(e) {
   	var eSrc=websys_getSrcElement(e);
	var rowObj=getRow(eSrc);
	var selRowNo=rowObj.rowIndex;
	var selCode=document.getElementById("GRPHCodez" + selRowNo);
	if ((selCode)&&(selCode.disabled==true)) return false;
}

document.body.onload=BodyLoadHandler;

