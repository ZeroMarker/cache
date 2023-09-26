//Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var selectedRowObj = new Object();
selectedRowObj.rowIndex="";
function SelectRow(evt) {
	var eSrc=websys_getSrcElement(evt);
	var rowObj=getRow(eSrc);
	if (rowObj.tagName != "TH") {
		//setRowClass(rowObj);
		if (eSrc.tagName != "A") eSrc=websys_getParentElement(eSrc);
		if (eSrc.tagName != "A") return;
		var rowsel=rowObj.rowIndex;
		var lnk="websys.csp?TWKFL="+document.getElementById("TWKFL").value+"&TWKFLI="+(document.getElementById("TWKFLI").value-1);
		var el;
		el=document.getElementById("IDz"+rowsel);
		if (el) lnk+="&ID="+el.value;
		el=document.getElementById("PatientID");
		if (el) lnk+="&PatientID="+el.value;
		window.location=lnk;
		return false;
	}
}
function getRow(eSrc) {
	while(eSrc.tagName != "TR") {
		if (eSrc.tagName == "TH") break;
		eSrc=eSrc.parentElement;
	}
	return eSrc;
}
function setRowClass(rowObj) {
	if (rowObj.rowIndex!=selectedRowObj.rowIndex) {
		rowObj.className='clsRowSelected';
		if (selectedRowObj.rowIndex%2==0 && selectedRowObj.rowIndex>0) {cName="RowEven";} else {cName="RowOdd";}
		selectedRowObj.className=cName;
		selectedRowObj=rowObj;
	}
}


var frm=document.forms["fPAAdmPatPreAdmission"];
var tbl=document.getElementById("tPAAdmPatPreAdmission");

 try {if (tbl) tbl.onclick=SelectRow;} catch(e) {}
 try {if (tbl) tbl.onKeyPress=SelectRow;} catch(e) {}




