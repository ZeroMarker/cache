// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
var tbl=document.getElementById("tARPatBillWriteOff_List");

function DocumentLoadHandler() {

	
	Disable_Delete();	
	try { EditBodyLoadHandler(); } catch(e) {}

	var transType = document.getElementById("TransType");

     	//AJI 25.08.03 - log 38334,xx5,xx7
	// Priory require to be able to assign write-offs (adjustments) against all invoices, 
	// even if they are in a closed accounting period
	//var periodClosed=document.getElementById("AcctPeriodClosed");

	if (transType && transType.value!='INV')     //(periodClosed && periodClosed.value == 'Y') || 
		DisableForm();
}

// Log 46170  Move the changes for Log 40604 to BodyUnLoadHandler because DeleteClickHandler cause script error, Delete_click() does not exist
/*
//AJI 40604 27.02.04 - wasn't refreshing the ListTotal
function DeleteClickHandler() {
	if (window.opener && window.opener.parent.frames[1]){
		var win=window.opener.parent.frames[1];
		if (win) {
			var formtot=win.document.forms['fARPatientBill_ListTotals'];
			if (formtot) {
				formtot.elements["RefreshCSP"].value="1";
			}
		}
	}
	Delete_click();
}
*/

// Log 46170  Move the changes for Log 40604 here because DeleteClickHandler cause script error, Delete_click() does not exist
function BodyUnLoadHandler(){
	if (window.opener && window.opener.parent.frames[1]){
		var win=window.opener.parent.frames[1];
		if (win) {
			var formtot=win.document.forms['fARPatientBill_ListTotals'];
			if (formtot) {
				formtot.elements["RefreshCSP"].value="1";
			}
		}
	}
}

function Disable_Delete(e) {	

	//KK 7/jun/2002 Log 25409
	//for every row of the table
	for (var i=1; i<tbl.rows.length; i++) {
		var disable=false;

		var TransferPatBill = document.getElementById("WO_TransferPatBillz"+i);
		if (TransferPatBill) {
			var val = TransferPatBill.value;
			if  ((val=="Y") || (val=="")) {
				var objDelete=document.getElementById("Deletez"+i);
				if (objDelete) {
					objDelete.style.visibility = "hidden";
					objDelete.onclick = LinkDisable;
					disable = true;
				}
			}
		}
		
		// Log 46170  Move the changes for Log 40604 to BodyUnLoadHandler because DeleteClickHandler cause script error, Delete_click() does not exist
		//AJI 40604 
		if (!disable) {
			//var objDelete=document.getElementById("Deletez"+i);
			//if (objDelete) objDelete.onclick=DeleteClickHandler();
		}
		else {
			var objDelete=document.getElementById("Deletez"+i);
			if (objDelete) objDelete.onclick="";
		}
		
		// SA 30.1.03 - log 32193: Refund Invoices have WO's added automatically
		// with comment "CINV" (Cancelled Invoice). Need to translate this here.
		var CommentsCol=document.getElementById("WO_Commentsz"+i);
		if (CommentsCol) {
			var val=CommentsCol.innerText;
			if  (val!="") {
				//alert("PRE inner text="+CommentsCol.innerText)
				if (val=="CINV") {
					CommentsCol.innerText=t['CINV'];
				}
			}
		}
	}
}

function LinkDisable(evt) {
	return false;
}

function Translate(e) {
	//var tbl=getTableName(window.event.srcElement);
	//translate field "TransType" column
	var tbl=document.getElementById("tARPatientBill_ListOrderBill");
	//var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	//for every row of the table
	for (var i=1; i<tbl.rows.length; i++) {
		//CellColumnName pattern is FieldName + z + rowNo
		var TransactTypeCol=document.getElementById("TransTypez"+i);
		if (TransactTypeCol) {
			var val=TransactTypeCol.innerText;
			if  (val!="") {
				//alert("PRE inner text="+TransactTypeCol.innerText)
				if (val=="INV") {
					TransactTypeCol.innerText=t['INV'];
				} else if (val=="DEP") {
					TransactTypeCol.innerText=t['DEP'];
				} else if (val=="REC") {
					TransactTypeCol.innerText=t['REC'];
				} else if (val=="REF") {
					TransactTypeCol.innerText=t['REF'];
				} else if (val=="CREC") {
					TransactTypeCol.innerText=t['CREC'];
				} 
				//alert("POST inner text="+TransactTypeCol.innerText)
			}
		}
	}
}
function DisableForm() {
	for (var i=1; i<tbl.rows.length; i++) {
		var objDelete=document.getElementById("Deletez"+i);
		if (objDelete) {
			objDelete.style.visibility = "hidden";
			objDelete.onclick=LinkDisable;
		}
		// SA 14.7.03 - log 34537: Do not allow modification of items transferred to others' bill.
		// A negative amounted adjustment should be created.
		var objWOAmount=document.getElementById("WO_Amountz"+i);
		if (objWOAmount) {
			objWOAmount.disabled=true;
			objWOAmount.onclick=LinkDisable;
		}
	}
}

function check_closed()
{
 if (document.all) {
 	var top=self.screenTop;
	if (top>9000) {
		BodyUnLoadHandler();
	}
 } 
}

document.body.onload = DocumentLoadHandler;
//document.body.onunload=UnloadHandler;
 document.body.onunload = check_closed;
