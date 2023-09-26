// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var winOpener=null;
var thewindow="BatchInvoices"; //44929

function BodyLoadHandler() {

	if (this.window.opener) winOpener = this.window.opener;

	objAddToBatchRec=document.getElementById("AddToBatchReceipt");
	if (objAddToBatchRec) objAddToBatchRec.onclick=AddToBatchReceiptingList;
	if (tsc['AddToBatchReceipt']) websys_sckeys[tsc['AddToBatchReceipt']]=AddToBatchReceiptingList;

	var tbl=document.getElementById("tARInvoicesPayor_List");
	for (var i=1;i<tbl.rows.length;i++) {
		var obj=document.getElementById("BatchInvNumberz"+i)
		obj.onclick = BatchInvNumberClickHandler;
	}
}

//44929
function CreateEDI() {

	if (websys_windows[thewindow]) {
		var win=websys_windows[thewindow]; //this is the ARPatientBill.ListAll child window.
		try {
			win.CreateEDI();
		} catch(e) { }
	}
}

//44929
function BatchInvNumberClickHandler(e) {

	var obj=websys_getSrcElement(e);
	if (obj.tagName=="IMG") obj=websys_getParentElement(obj);
	var rowid=obj.id;
	var rowAry=rowid.split("z");

	var BatchNum = document.getElementById("BatchInvNumberz"+rowAry[1]).innerHTML;

	var url="websys.default.csp?WEBSYS.TCOMPONENT=ARPatientBill.ListAll&BatchNum="+BatchNum+"&ChkBills=Y&ChkUnpBillsOnly=N&PageType=Payor&CONTEXT="+session['CONTEXT'];
	websys_createWindow(url,thewindow,"top=30,left=20,width=750,height=480,scrollbars=yes,resizable=yes");

	return false;
}

function AddToBatchReceiptingList() {

	if (winOpener==null) {
		alert("Invalid Operation!!\nThis link is not supposed to be placed on here");
		return;
	}

	var ReceiptAmt="";
	var Action="";
	var Payor="";
	var DepositRowIDs="";
	var BillRowIDs="";
	var BatchNum="";

	var originalContext=winOpener.session['CONTEXT'];

	var objBillRowIDs    = winOpener.document.getElementById("BillRowIDs");
	var objReceiptAmt    = winOpener.document.getElementById("ReceiptAmt");
	var objAction        = winOpener.document.getElementById("Action");
	var objPayor         = winOpener.document.getElementById("Payor");
	var objDepositRowIDs = winOpener.document.getElementById("DepositRowIDs");

	var tbl = document.getElementById("tARInvoicesPayor_List");
	var f   = document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var selRow = CheckSelectedRow(f, tbl, "Selectz");

	if (selRow==0) {
		alert(t['NO_BATCH']);
		return false;
	}
	BatchNum = f.elements["HiddenBatchInvNumberz"+selRow].value;
	Payor    = f.elements["HiddenPayorDescz"+selRow].value;
	
	if (BatchNum!=""&&Payor!="")
	{
		if (objReceiptAmt) ReceiptAmt=objReceiptAmt.value;
		if (objAction) Action=objAction.value;

		if (objBillRowIDs) BillRowIDs=objBillRowIDs.value;
		if (objDepositRowIDs) DepositRowIDs=objDepositRowIDs.value;

		var url="arpatientbill.batchfind.csp?PageType=Batch&BillRowIDs="+BillRowIDs+"&DepositRowIDs="+DepositRowIDs;
		url += "&DontClearPayDet=1&ReceiptAmt="+ReceiptAmt+"&Payor="+websys_escape(Payor)+"&CONTEXT="+originalContext+"&Action="+Action;
		url += "&ChkBills=Y&BatchNum="+BatchNum;

		// ensure that ChkBills is set to Y, otherwise MVBARPB11 won't return anything

		window.close();
		winOpener.websys_createWindow(url,"TRAK_main");
	}
	else {
		alert(t['NOT_VALID_BATCH']);
	}
}

/**
 * only for checking single selection
 */
function CheckSelectedRow(f,tbl,col) {
	var found=0;
	for (var ic=1;ic<tbl.rows.length;ic++) {
		if (f.elements[col+ic] && f.elements[col+ic].checked && !f.elements[col+ic].disabled) {
			found=ic;
			break;
		}
	}

	return found;
}

/**
 * checking for multi selection
 */
function CheckSelectedRows(f,tbl,col) {
	var aryfound=new Array;found=0;
	for (var ic=1;ic<tbl.rows.length;ic++) {
		if (f.elements[col+ic] && f.elements[col+ic].checked && !f.elements[col+ic].disabled) {
			aryfound[found]=ic;found++;
		}
	} 
	return aryfound;
}

function SelectRowHandler(evt) {
	var allowMultiSelect="Y";
	allowMultiSelect=document.getElementById("AllowMultiSelect").value;

	if (allowMultiSelect=="N") 
	{
		var tbl=document.getElementById("tARInvoicesPayor_List");
		var f = document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
		var col="Selectz";

		var eSrc=websys_getSrcElement(evt);
		var rowObj=getRow(eSrc);
		var selRow=rowObj.rowIndex;

		// can only select one row at a time, clear previous selections
		for (var i=1;i<tbl.rows.length;i++) {
			if (f.elements[col+i] && f.elements[col+i].checked && !f.elements[col+i].disabled) {
				if (i!=selRow) {
					f.elements[col+i].checked = false;
				}
			}
		}
	}
}

function PrintSelectedRowsHandler(tblname,lnk,newwin) {

	if (tblname=="") {
		var eSrc=websys_getSrcElement();
		if(eSrc) var tbl=getTableName(eSrc);
	} else {
		var tbl=document.getElementById(tblname);
	}
	var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));

	var aryfound=CheckSelectedRows(f,tbl,"Selectz");

	if (aryfound.length==0) {
		alert(t['NO_BATCH']);
	} else {
		if (newwin=="TRAK_hidden") {
			var hiddenwin=window.open('',newwin);
			with (hiddenwin) {
				document.writeln('<HTML><HEAD></HEAD><BODY>');
				document.writeln('<FORM name="HFORM" id="HFORM" method="POST" action="' + lnk + '">');
				document.writeln('<INPUT NAME="MULTI" VALUE="1">');
				document.writeln('<INPUT NAME="MULTIITEMS" VALUE="BatchNumber,BatchRowID">');
				// for each row selected
				for (i in aryfound) {
					var row=aryfound[i];
					// check for specific values - these values must be hidden in the component
					document.writeln('<INPUT NAME="BatchNumber" VALUE="' + f.elements["HiddenBatchInvNumberz"+row].value + '">');
					document.writeln('<INPUT NAME="BatchRowID" VALUE="' + f.elements["InvRowIDz"+row].value + '">');
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
				if (!f.elements["HiddenBatchInvNumberz"+row]) continue;
				if (!f.elements["InvRowIDz"+row]) continue;
				if ((f.elements["HiddenBatchInvNumberz"+row].value!="")&&(f.elements["InvRowIDz"+row].value!="")) {
					// when the report is crystal and will be previewed pass these parameters so they can
					// be converted to prompt(n) variables.
					PassReportParametersForPreview(lnk,newwin,f.elements["HiddenBatchInvNumberz"+row].value,f.elements["InvRowIDz"+row].value);
				}
			}
		}
	}
	return false;
}

document.body.onload=BodyLoadHandler;