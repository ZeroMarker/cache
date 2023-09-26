// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 


function DocumentLoadHandler() {
	assignClickHandler();
}

function assignClickHandler() {
	var tbl=document.getElementById("tARPatientBill_ListPayments");
	for (var i=1;i<tbl.rows.length;i++) {
		var obj=document.getElementById("CancelReceiptz"+i)
		if (obj) obj.onclick = CancelReceiptClickHandler;
	}
	return;
}

function CancelReceiptClickHandler(e) {
	var eSrc = websys_getSrcElement(e);
	if (eSrc.tagName=="IMG") eSrc=websys_getParentElement(eSrc);
	eSrc.target = "_parent";
}

function PrintSelectedRowsHandler(tblname,lnk,newwin) {
	if (tblname=="") {
		var eSrc=websys_getSrcElement();
		if(eSrc) var tbl=getTableName(eSrc);
	} else {
		var tbl=document.getElementById(tblname);
	}

	var BillRowID="";
	var objBillRowID=document.getElementById("BillRowID");
	if (objBillRowID) BillRowID=objBillRowID.value;

	var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	//JW:  changed to use CheckedCheckBoxesOrSelectedRow log 54668
	var aryfound=CheckedCheckBoxesOrSelectedRow(f,tbl,"SelectReceiptz");
	if (aryfound.length==0) {
		alert("No Rows Selected");
	} else {
		if (newwin=="TRAK_hidden") {
			var hiddenwin=window.open('',newwin);
			with (hiddenwin) {
				document.writeln('<HTML><HEAD></HEAD><BODY>');
				document.writeln('<FORM name="HFORM" id="HFORM" method="POST" action="' + lnk + '">');
				document.writeln('<INPUT NAME="MULTI" VALUE="1">');
				document.writeln('<INPUT NAME="MULTIITEMS" VALUE="PatientID,ReceiptRowID,ClassName,ClassNameID">');
				// for each row selected
				for (i in aryfound) {
					var row=aryfound[i];
					// check for specific values - these values must be hidden in the component
					if (!f.elements["ReceiptRowIDz"+row]) continue;
					if (f.elements["ReceiptRowIDz"+row].value!="") {
						document.writeln('<INPUT NAME="PatientID" VALUE="' + f.elements["PatientID"].value + '">');
						document.writeln('<INPUT NAME="ReceiptRowID" VALUE="' + f.elements["ReceiptRowIDz"+row].value + '">');
						document.writeln('<INPUT NAME="ClassName" VALUE="ARPatientBill">');
						document.writeln('<INPUT NAME="ClassNameID" VALUE="' + BillRowID + '">');
					}
				}
				//Log 63924 - 08.06.2007 - to prevent stack overflow error
				//document.writeln('</FORM><SCR'+'IPT>');
				//document.writeln('window.HFORM.submit();');
				//document.writeln('</SCR'+'IPT></BODY></HTML>');
				document.writeln('</FORM></BODY></HTML>');
				document.close();
				document.HFORM.submit();	
				// End Log 63924 
			}
		} else {
			// for each row selected
			for (i in aryfound) {
				var row=aryfound[i];
				// check for specific values - these values must be hidden in the component
				if (!f.elements["ReceiptRowIDz"+row]) continue;
				if (f.elements["ReceiptRowIDz"+row].value!="") {
					// when the report is crystal and will be previewed pass these parameters so they can
					// be converted to prompt(n) variables.
					PassReportParametersForPreview(lnk,newwin,f.elements["PatientID"].value,f.elements["ReceiptRowIDz"+row].value);
				}
			}
		}
	}
	return false;
}

function UnloadHandler(){
	//alert("Unload");
	var obj=document.getElementById('refresh');
	if ((obj) && (obj.value==0)) {
		//alert(obj.value);
		return false;
	}
	else {
		if (self == top) {
			var win=window.opener;
			if (win) {
				try { win.treload('websys.csp'); } catch(e) {}
				websys_onunload(); 
			}
		}
	}
}

function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	if (el.disabled) {
		return false;
	}
	return true;
}

// SA 23.1.03 - log 32170: Hightlighted rows which do not have the checkbox checked, 
// are now teated as selected rows.
function CheckedCheckBoxesOrSelectedRow(f,tbl,col) {
	var aryfound=new Array;found=0;
	for (var ic=1;ic<tbl.rows.length;ic++) {
		if (f.elements[col+ic] && f.elements[col+ic].checked && !f.elements[col+ic].disabled) {
			aryfound[found]=ic;found++;
		} else if (tbl.rows[ic].className=="clsRowSelected" && !f.elements[col+ic].disabled) {
			aryfound[found]=ic;found++;
		}
	} 
	return aryfound;
}

document.body.onload = DocumentLoadHandler;



