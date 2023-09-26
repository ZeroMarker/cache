// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function BodyLoadHandler() {
	ARCSundryDebtorListOrderBill_Translate();
	
	var objNew=document.getElementById('AddNewOrder');
	if (objNew) objNew.onclick=AddNewOrder;

	CheckCancelBill();
}

//36748
function AddNewOrder(e) {
	
	var objSund   = document.getElementById("SundryID");
	var objOrd    = document.getElementById("OEOrderIDz1");
	var objOrdItm = document.getElementById("OEOrderItemIDz1");

	var SundryID="";
	var OEOrderID=""
	var OEOrderItemID="";

	if (objSund) SundryID=objSund.value;
	if (objOrd) OEOrderID=objOrd.value;
	if (objOrdItm) OEOrderItemID=objOrdItm.value;

	if (OEOrderID!="" && OEOrderItemID!="") {
		var url = "arpatientbill.addcharges.csp?ID=" + OEOrderID + "&OrderID=" + OEOrderID;
		url += "&Sundry=Y&SundryDebtorID=" + SundryID + "&SundryID=" + SundryID;

		self.location=url;
	}
}

function ARCSundryDebtorListOrderBill_Translate(e) {

	var tbl=document.getElementById("tARCSundryDebtor_ListOrderBill");
	
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
				} else if (val=="CINV") {
					TransactTypeCol.innerText=t['CINV'];
				} else if (val=="ADJ") {
					TransactTypeCol.innerText=t['ADJ'];
				} 
			}
		}
		var objPrice=document.getElementById("Pricez"+i);
		if (objPrice) {
			var tot=objPrice.innerText;
			if (tot!="" && tot=="OUTTOT") {
				objPrice.innerText=t['OUTTOT'];
			}
		}
	}
}

//AJI 37343 
function OEStatusFilterLookupSelect(str) {	
	var lu=str.split("^");	
	var objOrdStatus=document.getElementById('OEStatus');
	if (objOrdStatus) objOrdStatus.value=lu[1]; //get the code
	//alert(objOrdStatus.value);
}

//AJI 37343 
function BillGroupFilterLookupSelect(str) {
	var lu=str.split("^");
	var objBillGroup=document.getElementById('BillGroupID');
	if (objBillGroup) objBillGroup.value=lu[1]; // get the id
	//alert(objBillGroup.value);
}


//KK 28/May/2002 Log 25405
//AJI 26.08.03 log 38334,xx5,xx7 - added a check whether acct. period is closed
function CheckCancelBill() {
	
	var acctClosed = document.getElementById("AcctPeriodClosed");
	var objBR      = document.getElementById('BillRowIDz1');

	if ((acctClosed && acctClosed.value == "Y") || (objBR && objBR.value=="")) {
		var objCB=document.getElementById('CancelBill');
		if (objCB) {
			objCB.disabled=true;
			objCB.onclick=LinkDisable;
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

//KK 5/jun/2003 Log:33286
function PrintSelectedRowsHandler(tblname,lnk,newwin) {
	//alert(tblname);
	var found=0;
	if (tblname=="") {
		var eSrc=websys_getSrcElement();
		if(eSrc) var tbl=getTableName(eSrc);
	} else {
		var tbl=document.getElementById(tblname);
	}
	//if (tbl=="") tbl=document.getElementById("tARCSundryDebtor_ListOrderBill");
	var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var aryfound=checkedCheckBoxes(f,tbl,"Selectz");
	//HitCount var required to force Crystal Web Server to rerun query - see KnowledgeBase Article c2002771
	//Log 19666
	var HitCount=Math.round(Math.random() * 1000)
	if (aryfound.length==0) {
		alert(t['NOITEMSSELECTED']);
	} else {
		if (newwin=="TRAK_hidden") {
			//alert(newwin);
			var hiddenwin=window.open('',newwin);
			with (hiddenwin) {
				//alert("in hidden win");
				document.writeln('<HTML><HEAD></HEAD><BODY>');
				document.writeln('<FORM name="HFORM" id="HFORM" method="POST" action="' + lnk + '">');
				document.writeln('<INPUT NAME="MULTI" VALUE="1">');
				document.writeln('<INPUT NAME="MULTIITEMS" VALUE="PatientID,BillRowID">');
				// for each row selected
				for (i in aryfound) {
					var row=aryfound[i];
					// check for specific values - these values must be hidden in the component
					if (!f.elements["PatientIDz"+row]) continue;
					if (!f.elements["BillRowIDz"+row]) continue;
					if ((f.elements["BillRowIDz"+row].value!="")&&(f.elements["PatientIDz"+row].value!="")) {
						document.writeln('<INPUT NAME="PatientID" VALUE="' + f.elements["PatientIDz"+row].value + '">');
						document.writeln('<INPUT NAME="BillRowID" VALUE="' + f.elements["BillRowIDz"+row].value + '">');
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
		}
	}
	return false;
}


document.body.onload=BodyLoadHandler;
