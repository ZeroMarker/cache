// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var nRows=0;

function DocumentLoadHandler() {
		var table =document.getElementById("tRBOperatingRoom_ListByEpId");
		if (table) {
			nRows = table.rows.length;
			//alert("nRows " + nRows);
			assignChkHandler();
		}		
}

function assignChkHandler() {
	for (var i=1;i<nRows;i++) {
		var obj=document.getElementById("selectz"+i)
		obj.onclick = chkClickHandler;
	}
	return;
}

function chkClickHandler(e) {
   	var eSrc = websys_getSrcElement(e);
	var rowObj = getRow(eSrc);
	var selRowNo = rowObj.rowIndex;
	//alert("sel row " + selRowNo);

	for(var i=1;i<nRows;i++){
		if(i != selRowNo){
			var chkObj = document.getElementById("selectz" + i);
			if (chkObj) chkObj.checked=false;
		}
	}
	
	var selRBOPId = document.getElementById("RBOPId");
	var rbId = document.getElementById("RBOP_RowIdz" + selRowNo);
	var chkSelObj = document.getElementById("selectz" + selRowNo);
	if(rbId && selRBOPId && chkSelObj){
		if (chkSelObj.checked){
			selRBOPId.value = rbId.value;
		}
		else
			selRBOPId.value = "";
	}
	//alert("sel " + selRBOPId.value);
}


document.body.onload = DocumentLoadHandler;