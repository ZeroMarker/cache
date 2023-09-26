// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var objShowUnpaidBillsOnly=document.getElementById("ShowUnpaidBillsOnly");
var objShowPatientBillsOnly=document.getElementById("ShowPatientBillsOnly");
var objShowZeroBills=document.getElementById("ShowZeroBills");
var objPageType=document.getElementById("PageType");
//Log 46817 - 11.09.2006 - Get Page type from component
var PageType=""
if (objPageType) PageType=objPageType.value;
//End Log 46817

var objHosp=document.getElementById("HospDesc");
var objinvoiceforbatch=document.getElementById("invoiceforbatch"); //"Add Invoice to Batch" button
var objSelectAll=document.getElementById("SelectAll");
var objSelDeselectAll=document.getElementById("SelDeselectAll");
var objAutoSelDeposit=document.getElementById("AutoSelDeposit"); //54669
var objAdmDateFrom=document.getElementById("AdmDateFrom"); //Log 60884 - 13/10/2006
var objAdmDateTo=document.getElementById("AdmDateTo"); //Log 60884 - 13/10/2006

//Log 50221 PeterC 16/02/04: Break out of the frame
var ConObj=document.getElementById("Continue");
if (ConObj) ConObj.onclick=Continue;

function Continue() {
	var frm = document.forms["fARPatientBill_ListAll"];
	if ((frm)&&(window.parent)) frm.elements['TFRAME'].value=window.parent.name;
	return Continue_click();
}

var SelBillRowID="";  //global variable to store the selected bill-row-ids

var SelBillTypes=""; //global variable to store the selected bill-types

var OldUnpaidOnclickEvent="";
var OldPatBillsOnlyOnclickEvent="";
var OldHospitalChangeHandler="";
var OldShowZeroBillsOnclickEvent="";
var OldDateFromChangeHandler=""; 	//Log 60884 - 13/10/2006
var OldDateToChangeHandler="";		//Log 60884 - 13/10/2006

var delim="^";
var aryPatBill=new Array();
var objGroupType=document.getElementById("GroupType")
var GroupType=""
if (objGroupType) GroupType=objGroupType.value;

var winOpener="";

var docBatchFind;
var winBatchFind;
var docBillFind;

//44252 - batch receipting
if (parent.frames["BR.ARPatBillFindBatch"]) {
	var frm=parent.frames["BR.ARPatBillFindBatch"];
	docBatchFind = frm.document;
	winBatchFind = frm.window;
}

//48371 - batch letter
if (parent.frames["FRAMEARPatientBillFind"]) {
	var frm = parent.frames["FRAMEARPatientBillFind"];
	docBillFind = frm.document;
}

/**
 */
function BodyLoadHandler() {

	var obj="";
	if (top.frames["TRAK_main"]) {

		obj=top.frames["TRAK_main"].frames["ListTotals"];
		
		if (obj) {
			var formtot=obj.document.forms['fARPatientBill_ListTotals']; 
			if (formtot) {
				//only refresh the ARPatientBill.ListTotals alone
				if (formtot.elements["RefreshCSP"].value==1) RefreshListTotals();
			}
		} else {
			//PageType var set from arpatientbill.listreg.csp only
			if ((objPageType)&&(objPageType.value=="Patient")) {
				CheckBoxRefresh(); //To load all the frames(patientbanner,listtotals and listall)
			}
		}
	}
	else {  		
		// HERE means -> it's opened in a new window eg. from batch receipting or batch letter (search by patient)

		// 42792 - must be familiar with BatchReceipting and BatchLetter component to understand this

		if (top.frames["ListAll"]) {
			var frm = top.frames["ListAll"];
			
			if (frm.parent.window.opener) {
				winOpener = frm.parent.window.opener; // BR.ARPatBillFindBatch (from batch receipting) or FRAMEARPatientBillFindBatch (see batchletter.csp)
			}
		}
	}

	ARPatBillListAll_DispNegOustand();
	ARPatBillListAll_Translate();
	
	// RQG 12.03.03 L32825 - Disable 'Compensible Detail' if BillType is 'D'
	//ARPatBillListAll_DisableCompDetails();

	// FindBatchBodyLoadHandler appears in ARPatientBill.FindBatch.js
	try { FindBatchBodyLoadHandler();} catch (e) {}
	
	if (objShowUnpaidBillsOnly) {
		OldUnpaidOnclickEvent=objShowUnpaidBillsOnly.onclick;
		objShowUnpaidBillsOnly.onclick=ShowUnpaidClickHandler;
	}

	if (objShowPatientBillsOnly) {
		OldPatBillsOnlyOnclickEvent=objShowPatientBillsOnly.onclick;
		objShowPatientBillsOnly.onclick=ShowPatBillsClickHandler;
	}

	//log 52353
	if (objShowZeroBills) {
		OldShowZeroBillsOnclickEvent=objShowZeroBills.onclick;
		objShowZeroBills.onclick=ShowZeroBillsClickHandler;
	}

	if (objHosp) {
		OldHospitalChangeHandler=objHosp.onchange;
		objHosp.onchange=HospitalChangeHandler;
	}
	
	//Log 60884 - 13/10/2006
	if (objAdmDateFrom) objAdmDateFrom.onchange=DateFromChangeHandler;
	if (objAdmDateTo)   objAdmDateTo.onchange  =DateToChangeHandler;
	//End Log 60884

	if (objinvoiceforbatch) objinvoiceforbatch.onclick=InvoiceForBatchHandler;

	// SA 19.3.03 - log 32860: SelectAll var is currently set "Y" in 
	// the transition expression for Batch Invoicing workflow
	//
	if ((objSelectAll)&&(objSelectAll.value=="Y")) {
		SelectAllRows();
	}
	
	if (objSelDeselectAll) {
		objSelDeselectAll.onclick=SelectAllRows;
		if (tsc['SelDeselectAll']) websys_sckeys[tsc['SelDeselectAll']]=SelectAllRows;
	}

	if (top.frames["TRAK_main"]) {
		var objLAll=top.frames["TRAK_main"].frames["FRAMEARPatientBillListAll"];
		if (objLAll){
			SelectAllRows();
		}
	}

	//44413
	CheckEpisodeOnHold();
	
	// Log 59287
	DisablePayor();

	//46814
	var MABNobj = document.getElementById("ManuBatchNo");
	if(MABNobj) MABNobj.onchange=BatchNumberChangeHandler;

	//44252 - 2 lines below are for use in batch recepting
	HighlightNewlyAddedBill();
	HighlightNewlyAddedDeposit();

	AssignRemoveClickHandler();
	
	//Log 61529 - 29.11.2006 - Make "Account Comments" link Bold if comments exist
	var obj=document.getElementById("AccCommExist");
	if (obj) {
		var hasComment=obj.value;
		if (hasComment=="1") {
			var obj=document.getElementById("AccComment");
			if (obj) obj.style.fontWeight="bold"; 
		}
	}
	//End Log 61529
}

//Log 60884 - 13/10/2006 
function DateFromChangeHandler() {
   	AdmDateFrom_changehandler();
	CheckBoxRefresh();
	RefreshListTotals();
}

function DateToChangeHandler() {
    AdmDateTo_changehandler();
	CheckBoxRefresh();
	RefreshListTotals();
}
//End Log 60884

function BatchNumberChangeHandler() {
	var ManuBatchNum=""
	var MABNobj = document.getElementById("ManuBatchNo");
	if((MABNobj)&&(MABNobj.value!="")) ManuBatchNum=MABNobj.value;
    
	// Log 59697 - 15.06.2006 - Used tkMakeServerCall to validate ManuBatchNum instead of the hidden csp
	var Exist="";
	Exist=tkMakeServerCall("web.ARPatientBill","CheckBatchNumber",ManuBatchNum);
	
	if (Exist!="") MABNobj.className="clsInvalid";
	else MABNobj.className="";
	
	//	var path="arpatientbill.checkbatchnum.csp?ManuBatchNum="+ManuBatchNum+"&WINNAME="+window.name;
	//	websys_createWindow(path,"TRAK_hidden");
    // End Log 59697
}

function CheckEpisodeOnHold() {
	var tbl=document.getElementById("tARPatientBill_ListAll");
	for (var i=1; i<tbl.rows.length; i++) {
		var EpisodeOnHoldCol=document.getElementById("EpisodeOnHoldz"+i);
		if ((EpisodeOnHoldCol) && (EpisodeOnHoldCol.value=="Y")) {
			//var SelectBillCol=document.getElementById("SelectBillz"+i);
			//if (SelectBillCol) {SelectBillCol.disabled=true; SelectBillCol.onclick=LinkDisable;}

			var RecDepTotCol=document.getElementById("RecDepTotz"+i);
			if (RecDepTotCol) {RecDepTotCol.disabled=true; RecDepTotCol.onclick=LinkDisable;}
			var AdjTotalCol=document.getElementById("AdjTotalz"+i);
			if (AdjTotalCol) {AdjTotalCol.disabled=true; AdjTotalCol.onclick=LinkDisable;}
			var PaymentAllocCol=document.getElementById("PaymentAllocz"+i);
			if (PaymentAllocCol) {PaymentAllocCol.disabled=true; PaymentAllocCol.onclick=LinkDisable;}
			var CMTCommentCol=document.getElementById("CMTCommentz"+i);
			if (CMTCommentCol) {CMTCommentCol.disabled=true; CMTCommentCol.onclick=LinkDisable;}
			var ARPBLNotesExistCol=document.getElementById("ARPBLNotesExistz"+i);
			if (ARPBLNotesExistCol) {ARPBLNotesExistCol.disabled=true; ARPBLNotesExistCol.onclick=LinkDisable;}
			var EditPaymentAllocCol=document.getElementById("EditPaymentAllocz"+i);
			if (EditPaymentAllocCol) {EditPaymentAllocCol.disabled=true; EditPaymentAllocCol.onclick=LinkDisable;}
			var CompoDetailsCol=document.getElementById("CompoDetailsz"+i);
			if (CompoDetailsCol) {CompoDetailsCol.disabled=true; CompoDetailsCol.onclick=LinkDisable;}
			var EpisodeCompoDetailsCol=document.getElementById("EpisodeCompoDetailsz"+i);
			if (EpisodeCompoDetailsCol) {EpisodeCompoDetailsCol.disabled=true; EpisodeCompoDetailsCol.onclick=LinkDisable;}
		}
	}
}

function DisableAllLinks() {

	var fld=document.getElementsByTagName('A');
	for (var j=0; j<fld.length; j++) {
		fld[j].onclick = LinkDisable;
	}
}

function ShowUnpaidClickHandler() {

	if (typeof OldUnpaidOnclickEvent!="function") OldUnpaidOnclickEvent=new Function(OldUnpaidOnclickEvent); 
	//call the function i.e. the original handler
	if (OldUnpaidOnclickEvent()==false) return false;

	CheckBoxRefresh();

}

function ShowPatBillsClickHandler() {	
	
	if (typeof OldPatBillsOnlyOnclickEvent!="function") OldPatBillsOnlyOnclickEvent=new Function(OldPatBillsOnlyOnclickEvent);
	//call the function i.e. the original handler
	if (OldPatBillsOnlyOnclickEvent()==false) return false;

	CheckBoxRefresh();
}

//log 52353
function ShowZeroBillsClickHandler() {
	if (typeof OldShowZeroBillsOnclickEvent!="function") OldShowZeroBillsOnclickEvent=new Function(OldShowZeroBillsOnclickEvent); 
	//call the function i.e. the original handler
	if (OldShowZeroBillsOnclickEvent()==false) return false;

	CheckBoxRefresh();
}

function HospitalChangeHandler() {

	if (typeof OldHospitalChangeHandler!="function") OldHospitalChangeHandler=new Function(OldHospitalChangeHandler); 
	if (OldHospitalChangeHandler()==false) return false;

	if ((objHosp)&&(objHosp.value==""))	CheckBoxRefresh();
}

function HospitalLookUpSelect() {
	CheckBoxRefresh();
}

function CheckBoxRefresh() {
	//alert("CheckBoxRefresh");

	//52353 - dealing with a sys param in VB "Include Zero Bills when Unpaid"
	ShowZeroBills="N";
	if (objShowZeroBills) {
		if (objShowZeroBills.checked)	ShowZeroBills="Y";
	}
	else {
		ShowZeroBills=document.getElementById("SysParamShowZeroBill").value;
	}

	var Hospital="";
	if (objHosp) { //36689
		if (objHosp.tagName=="LABEL") Hospital=objHosp.innerText;
		else Hospital=objHosp.value;
	}
	var PageParams = document.getElementById("PageParams").value;
	
	//Log 60884 - 13/10/2006
	var AdmDateFrom="";
	if (objAdmDateFrom) { 
		if (objAdmDateFrom.tagName=="LABEL") AdmDateFrom=objAdmDateFrom.innerText;
		else AdmDateFrom=objAdmDateFrom.value;
	}
	var AdmDateTo="";
	if (objAdmDateTo) { 
		if (objAdmDateTo.tagName=="LABEL") AdmDateTo=objAdmDateTo.innerText;
		else AdmDateTo=objAdmDateTo.value;
	}

	var url="websys.default.csp?WEBSYS.TCOMPONENT=ARPatientBill.ListAll&CONTEXT="+session['CONTEXT']+"&Hospital="+Hospital+"&ShowZeroBills="+ShowZeroBills+"&AdmDateFrom="+AdmDateFrom+"&AdmDateTo="+AdmDateTo;
	url += PageParams;
	//End Log 60884

	document.fARPatientBill_ListAll.target="_self";
	document.fARPatientBill_ListAll.action=url;
	document.fARPatientBill_ListAll.submit();
}

//log 44178

function ARPatBillListAll_PaySelBillsHandler(e) {
	var tbl=document.getElementById("tARPatientBill_ListAll");
	if (!tbl) tbl=getTableName(window.event.srcElement);
	var PatientID="";
	var BillsOK=true;
	
	var objShowUnpaidBillsOnly = document.getElementById("ShowUnpaidBillsOnly");
	var ShowUnpaidBillsOnly = "";
	var CONTEXT     = session['CONTEXT'];
	var objPageType = document.getElementById("PageType");
	var objAction   = document.getElementById("Action");
	var objTWKFL    = document.getElementById("TWKFL");
	var objTWKFLI   = document.getElementById("TWKFLI");
	
	var PageType="";
	var Action="";

	var f = document.getElementById("f" + tbl.id.substring(1,tbl.id.length));
	var aryfound = CheckedCheckBoxesOrSelectedRow(f, tbl, "SelectBillz");
	
	if (aryfound.length==0) {
		alert(t['NO_BILL_SELECTED']);
		return false;
	}

	var BillRowIds ="";
	var PatientIds ="";
	var EpisodeIds ="";
	var DepositIds ="";
	var BillType ="";
	var NextBillType ="";
	var PayorId ="";
	var MsgBillsNotPrinted ="";
	var CreatingAdmDep =false;
	var DepositEpisodeIds ="";
	var Payor ="";

	//51226
	var DepositPayorIds="";
	var BillPayorIds=""; 
	var foundDiffPayor=false;
	var TransType="";
	//Log 65879 - 20.12.2007
	var DiscAllocs ="";

	//Log 66213
	var DepHospIds="";
	var BilHospIds="";
	
	for (var i=0; i<aryfound.length; i++) 
	{
		j = aryfound[i];
		//Log 63073 - 30.03.2007
		var EpisodeOnHoldObj=f.elements["EpisodeOnHoldz"+j];
		if ((EpisodeOnHoldObj) && (EpisodeOnHoldObj.value=="Y")) {
			alert(t['NO_ACTION_ALLOWED_FOR_ONHOLD_EPISODE']);
			return;
		}
		//End Log 63073
			
		NextBillType = f.elements["BillTypez"+j].value;
		PatientID = f.elements["PatientIDz"+j].value;  //44111 AJIW

		// log 32354: Payment can no longer be made against a cancelled invoice.
		// log 47242: Check a hidden field instead of the table cell.

		var hidTransType= document.getElementById("hidTransTypez"+j);
		if (hidTransType) {
			TransType=hidTransType.value;
			if  ((TransType!="")&&(TransType=="CINV")) { // canc. invoice
				alert(t['NO_PAY_CINV_REF']);
				return false;
			}			
			//51226 - allow payment using credit note, TransType CREF
			
			//Log 63218 - 03.04.2007 - See comments in staff notes
			if  ((TransType!="")&&(TransType=="CREF")) {
				var objPaid=document.getElementById("OrigPayAmtz"+j);
				if (objPaid) {
					var paid=objPaid.value;
					if (paid==0) { //  Credit Note of canc. invoice when no payment as been made
						alert(t['NOT_PAID']);
						return false;
					}			
				}	
			}	
		}

		// SA 12.11.02 - log 30133: Payor/Patient deposits may be paid against the other's bill.
		// But one Payor's deposit may NOT be paid against another Payor's bill.
		// this limitation is overriden in 51226

		if (PayorId =="") {
			PayorId=f.elements["PayorIDz"+j].value;
			if (NextBillType=="I") {
				var PayorCol=document.getElementById("INSTDescz"+j);
				if (PayorCol) Payor=PayorCol.innerText;
			}
		} else {
			if (!foundDiffPayor) {
				foundDiffPayor=true;
				if (!CheckDiffPayors(f.elements["PayorIDz"+j].value,PayorId))
					return false;
			}
		}

		if (NextBillType =="D") {  //Deposit

			if (DepositIds =="") {
				DepositIds=f.elements["ReceiptIDz"+j].value;  //log 33200
			} else {
				DepositIds=DepositIds+"^"+f.elements["ReceiptIDz"+j].value;
			}

			// SA 13.3.03 - log 32197: Build list of episode specific deposits
			if (f.elements["EpisodeIDz"+j].value!="") {
				if (DepositEpisodeIds=="") {	
					DepositEpisodeIds=f.elements["EpisodeIDz"+j].value;
				} else {
					DepositEpisodeIds=DepositEpisodeIds+"|"+f.elements["EpisodeIDz"+j].value;
				}
			}	

			//51226
			if (f.elements["PayorIDz"+j].value!="") {
				if (DepositPayorIds=="")
					DepositPayorIds=f.elements["PayorIDz"+j].value;
				else
					DepositPayorIds=DepositPayorIds+"|"+f.elements["PayorIDz"+j].value;
			}
			
			//Log 66213
			if ((f.elements["Hospz"+j])&&(f.elements["Hospz"+j].value!="")) {
				if (DepHospIds=="") DepHospIds=f.elements["Hospz"+j].value;
				else DepHospIds=DepHospIds+"|"+f.elements["Hospz"+j].value;
			}
			//End Log 66213			
		} 
		else if (NextBillType =="A") {  // Unbilled Episode

			// 32197: A SINGLE unbilled episode row may now be selected.
			// If a single admission is selected, the deposit screen will now appear,
			// allowing a deposit to be taken against that EPISODE only.

			if (aryfound.length > 1) {
				alert(t['SINGLE_ADM_SEL']);
				return false;
			} else {
				EpisodeIds = f.elements["EpisodeIDz"+j].value;
				PatientID = f.elements["PatientIDz"+j].value;  // was PatientIds

				// SA: This is a hardcoded workflow context, required because we are calling the
				// same component (ARReceipts.Edit) in different contexts (deposit/receipting) 
				// from the same workflow/menu.
				BillType ="D";
				CONTEXT ="S1";
				CreatingAdmDep =true;		
			}

		} 
		else {  //Invoice

			if (BillType =="") {
				BillType = NextBillType;
			} else {				
				if (!CheckDiffBillType(BillType,NextBillType))  //51226
					return false;
			}

			//SA Ensure BillRowIds etc. are NOT added for deposits as doing so will
			//cause doubling/tripling etc. of bill totals in ARReceipts.Edit screen

			BillRowIds = BillRowIds + f.elements["BillRowIDz"+j].value;
			EpisodeIds = EpisodeIds + f.elements["EpisodeIDz"+j].value;
			PatientIds = PatientIds + f.elements["PatientIDz"+j].value;
			//Log 65879 - 20.12.2007, Log 66313 - 08.02.2008
			objDisc=document.getElementById("DiscTotalz"+j);
			if (objDisc) DiscAllocs = DiscAllocs + Math.abs(document.getElementById("DiscTotalz"+j).innerText);			

			if (i < aryfound.length-1) {
				BillRowIds = BillRowIds + "|";
				PatientIds = PatientIds + "|";  //42697
				EpisodeIds = EpisodeIds + "|";
				DiscAllocs = DiscAllocs + "|";	//Log 65879 - 20.12.2007				
			}

			try {
				//54041 custom functionality -> payment cannot be allocated unless confirmed they are ready for billing
				if (!CheckReadyForBilling(f.elements["NotReadyForBillingz"+j].value)) return false;
			} catch(e) { }

			//51226
			// was if (f.elements["PayorIDz"+j].value!="")

			if (f.elements["PayorIDz"+j].value!=""&&TransType!=""&&TransType=="INV") {
				if (BillPayorIds=="") {
					BillPayorIds=f.elements["PayorIDz"+j].value;
				} else {
					BillPayorIds=BillPayorIds+"|"+f.elements["PayorIDz"+j].value;
				}
			}

			//Log 66213
			if ((f.elements["Hospz"+j])&&(f.elements["Hospz"+j].value!="")) {
				if (BilHospIds=="") BilHospIds=f.elements["Hospz"+j].value;
				else BilHospIds=BilHospIds+"|"+f.elements["Hospz"+j].value;
			}
			//End Log 66213
			
			// SA 5.2.03 - log 32198: Warning message to appear when attempting to pay unprinted bills
			if (f.elements["BillPrintedz"+j].value =="N") {
				//Log 66151 - 30.01.2008 - moved the code to function 'CheckBillPrinted' 
				MsgBillsNotPrinted=CheckBillPrinted(j,MsgBillsNotPrinted);
			}
		}
		//Log 65095 - 24.10.2007
		billid=f.elements["BillRowIDz"+j].value;
		if (billid!="") {
			found = tkMakeServerCall("web.ARPatientBill","CheckBill",billid);	
			if (found==1) {
				alert(t['REBILL_PAT']);
				return false;
			}	
		}	
		//End Log 65095 			
	} // end for

	//Log 66213
	var objDepAlloc=document.getElementById("depAllocParam");
	var DepAlloc="",Hosps="";
	if (objDepAlloc) DepAlloc=objDepAlloc.value;

	if ((DepAlloc=="FE")||(DepAlloc=="WN")) {
		if ((BilHospIds!="")&&(DepHospIds!="")) {
			if (!HospitalCheck(DepHospIds,BilHospIds)) {
				if (DepAlloc=="FE") {
					alert(t['DIFF_HOSPS']);
					return false;
				} else {	//if (DepAlloc=="WN") 
					bConfirmDiffHosps=confirm(t['DIFF_HOSPS']+"\n\n"+t['CONTINUE']);
					if (!bConfirmDiffHosps) return false;
				}
			}			
		}
	}	
	//End Log 66213
	
	if ((BillType=="")&&(DepositIds=="")&&(!CreatingAdmDep)) {
		alert(t['NO_BILL_SELECTED_PAY']+"\n"+t['SELECT_ATLEAST_ONE']);
		return false;
	}

	if ((DepositEpisodeIds!="")&&(EpisodeIds!="")) {
		if (!DepositBillsEpisodesCheck(DepositEpisodeIds,EpisodeIds)) {
			alert(t['BILL_DEP_EP_DIFF']);
			return false;
		}
	}

	//51226
	if (!DepositPayorCheck(DepositPayorIds)) {
		return false;
	}
	//51226
	if (!BillsPayorCheck(BillPayorIds)) {
		return false;
	}

	// SA 5.2.03 - log 32198: Warning message to appear when attempting to pay unprinted bills
	if (MsgBillsNotPrinted!="") {
		var bConfirmBillsNotPrinted=1;
		MsgBillsNotPrinted+="\n"+t['BILLS_NOT_PRINTED']+"\n\n"+t['CONTINUE'];
		bConfirmBillsNotPrinted=confirm(MsgBillsNotPrinted);
		if (!bConfirmBillsNotPrinted) return false;
	}

	if (objShowUnpaidBillsOnly) {
		ShowUnpaidBillsOnly="N";
		if (objShowUnpaidBillsOnly.checked) ShowUnpaidBillsOnly="Y";
	}

	if (objPageType) PageType=objPageType.value;
     	if (objAction) Action=objAction.value;

	//Log 64789 - 03.09.2007 - used websys_escape on Payor	
	var url="websys.default.csp?WEBSYS.TCOMPONENT=ARReceipts.Edit&BillRowIDs="+BillRowIds+"&PatientID="+PatientID+"&PatientIds="+PatientIds+"&EpisodeID="+EpisodeIds+"&BillType="+BillType+"&DepositIDs="+DepositIds+"&PayorHidden="+websys_escape(Payor);
	url += "&PageType="+PageType+"&Action="+Action+"&ShowUnpaidBillsOnly="+ShowUnpaidBillsOnly+"&CONTEXT="+CONTEXT+"&GroupType="+GroupType+"&PatientBanner=1"+"&DiscAllocs="+DiscAllocs;
	//log 50221: Do not pass the workflow/item ID

	//alert(url);
        //Log 59598 - BC - 29-06-2006 : remove statusbar variable (status=) to display the status bar.
	websys_createWindow(url,'child2','toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes');
}


/**
 51226 - default functionality
*/
function BillsPayorCheck(BillPayorIDs) {
	return true;
}

/**
 51226 - default functionality
*/
function DepositPayorCheck(DepositPayorIds) {
	return true;
}

/**
 51226 - default functionality
*/
function CheckDiffBillType(BillType,NextBillType) {
	if (BillType!=NextBillType) {
		alert(t['NO_PAT_INS_BILLS'] + "\n" + t['ONLY_SAME_BILLS']);
		return false;
	}
	return true;
}

/**
 51226 - default functionality
*/
function CheckDiffPayors(SelPayor,PayorId) {
	// A blank PayorID should indicate a patient bill has been selected.
	if (SelPayor!="") {
		if (SelPayor!=PayorId) {
			alert(t['DIFF_PAYORS']);
			return false;
		}
	}
	return true;
}

//Log 61793 - 08/01/2007 
function ARPatBillListAll_RemoveFromBatch(lnk,newwin) {
	var tbl =document.getElementById("tARPatientBill_ListAll");
	var bConfirmRemoveFromBatch=1;
	var batchNumFound=0;
	var BillRowIds="";
	var BatchNos="";
	
	var f = document.getElementById("f" + tbl.id.substring(1,tbl.id.length));
	var aryfound = CheckedCheckBoxesOrSelectedRow(f,tbl,"SelectBillz");

	if (aryfound.length==0) {
		alert(t['NO_BILL_SELECTED']);
		return;
	} else {
		if (aryfound.length > 0) {
			//Log 63073 - 30.03.2007
			var EpisodeOnHoldObj=f.elements["EpisodeOnHoldz"+aryfound];
			if ((EpisodeOnHoldObj) && (EpisodeOnHoldObj.value=="Y")) {
				alert(t['NO_ACTION_ALLOWED_FOR_ONHOLD_EPISODE']);
				return;
			} 
			//End Log 63073
			for (var i=0; i<aryfound.length; i++) {
				j = aryfound[i];
				
				BillRowIds = BillRowIds + f.elements["BillRowIDz"+j].value;
				BatchNos   = f.elements["ARBatchIDz"+j].value;
				if (BatchNos!="") batchNumFound=1;
				
				if (i<aryfound.length-1) {
					BillRowIds=BillRowIds+"|";
				}	
			}
			
			if (!batchNumFound) {
				alert(t['NO_BATCH_NO']);
				return false;
			}	
			bConfirmRemoveFromBatch=confirm(t['REMOVE_FROM_BATCH']);
			if (!bConfirmRemoveFromBatch) return false;
			
			lnk += "&BillRowIDs="+BillRowIds;
		}
	}
	window.location = lnk;		
}
//End Log 61793

function ARPatBillListAll_AddModifyComments(e) {
	var tbl=getTableName(window.event.srcElement);
	//var tbl=document.getElementById("tARPatientBill_ListAll");

	var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var aryfound=CheckedCheckBoxesOrSelectedRow(f,tbl,"SelectBillz");
	var pContext=document.getElementById("TWKFL");
	if (pContext) {
		var billContext=pContext.value;
		//alert(billContext);
	}
	//alert(aryfound.length);
	if (aryfound.length==0) {
		alert(t['NO_BILL_SELECTED']);
	} else {
		//KK 28/Apr/2003 Log 33029 
		var obj=top.frames["TRAK_main"].frames["ListTotals"];
		if (obj) {
			var formtot=obj.document.forms['fARPatientBill_ListTotals']; 
			if (formtot) formtot.elements["RefreshCSP"].value=1;
		}

		if (aryfound.length==1) {
			var BillID=f.elements["BillRowIDz"+aryfound].value;
			//alert(BillID);
			var EpisID=f.elements["EpisodeIDz"+aryfound].value;
			var PatID=f.elements["PatientIDz"+aryfound].value;
			var EpisodeOnHoldObj=f.elements["EpisodeOnHoldz"+aryfound];
			if ((EpisodeOnHoldObj) && (EpisodeOnHoldObj.value=="Y")) {
				alert(t['NO_ACTION_ALLOWED_FOR_ONHOLD_EPISODE']);
				return;
			} 
			var objPageType=document.getElementById('PageType'); 
			var strPageType="";
			var strPageParams="";
			if (objPageType) {
				var strPageType=objPageType.value; 			
			}
			var objPageParams=document.getElementById('PageParams'); 
			if (objPageParams) {
				var strPageParams=objPageParams.value; 			
			}
			var PageParams="&PageType="+strPageType+"&PageParams="+strPageParams
			//var url="websys.default.csp?WEBSYS.TCOMPONENT=PAAdm.EditComments&BillRowID="+BillID+"&EpisodeID="+EpisID+"&PatientID="+PatID+PageParams+"&TWKFL="+billContext;
			var url="websys.default.csp?WEBSYS.TCOMPONENT=PAAdm.EditComments&BillRowID="+BillID+"&EpisodeID="+EpisID+"&PatientID="+PatID+PageParams;
                        //Log 59598 - BC - 29-06-2006 : remove statusbar variable (status=) to display the status bar.
			websys_createWindow(url,'child2','left=100,width=400,height=480,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes');
		} else {	
			var TempBillRowid="";
			for (var i=0; i<aryfound.length; i++) {
				var BillAry=new Array();
				j=aryfound[i];
				if (TempBillRowid!=f.elements["BillRowIDz"+j].value) {
					alert(t['SELECT_ONLY_ONE']);
					break;
				} else {
					//var BillRowid=f.elements["BillRowIDz"+aryfound].value;
					//var EpisID=f.elements["EpisodeIDz"+aryfound].value;
					//var url="websys.default.csp?WEBSYS.TCOMPONENT=PAAdm.EditComments&BillRowID="+BillRowid+"&EpisodeID="+EpisID;
                                        //Log 59598 - BC - 29-06-2006 : remove statusbar variable (status=) to display the status bar.
					//websys_createWindow(url,'child','left=100,width=400,height=480,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes');					
				}
				//if (f.elements["BillRowIDz"+j].value=="") f.elements["BillRowIDz"+j].value="55";							
				var TempBillRowid=f.elements["BillRowIDz"+j].value;
				BillAry[BillAry.length]=f.elements["BillRowIDz"+j].value;
			}
		}
	}
}

function ARPatBillListAll_Adjustments(e) {
	var tbl=getTableName(window.event.srcElement);

	var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var aryfound=CheckedCheckBoxesOrSelectedRow(f,tbl,"SelectBillz");
	if (aryfound.length==0) {
		alert(t['NO_BILL_SELECTED']);
	} else {
		if (aryfound.length==1) {
			if (f.elements["BillRowIDz"+aryfound].value=="") {
				alert(t['INV_ROW_SEL']+" "+t['ADJ_ONLY_FOR_INVOICES']);
			} else {
				var BillRowid=f.elements["BillRowIDz"+aryfound].value;
				var PatID=f.elements["PatientIDz"+aryfound].value;
				var objPageType=document.getElementById('PageType'); 
				var strPageType="";
				var strPageParams="";
				if (objPageType) {
					var strPageType=objPageType.value; 			
				}
				var objPageParams=document.getElementById('PageParams'); 
				if (objPageParams) {
					var strPageParams=objPageParams.value; 			
				}
				var PageParams="&PageType="+strPageType+"&PageParams="+strPageParams

				var url="arpatientbill.writeoff.csp?PARREF="+BillRowid+"&BillRowID="+BillRowid+"&PatientID="+PatID+PageParams;
                                //Log 59598 - BC - 29-06-2006 : remove statusbar variable (status=) to display the status bar.
				websys_createWindow(url,'child2','left=100,width=400,height=480,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes');
			}
		} else {
			var TempBillRowid="";
			for (var i=0; i<aryfound.length; i++) {
					var BillAry=new Array();
				j=aryfound[i];
				if (TempBillRowid!=f.elements["BillRowIDz"+j].value) {
					alert(t['SELECT_ONLY_ONE']);
					break;
				}
				//if (f.elements["BillRowIDz"+j].value=="") f.elements["BillRowIDz"+j].value="55";							
				if (f.elements["BillRowIDz"+j].value=="") {
					alert(t['INV_ROW_SEL']+" "+t['ADJ_ONLY_FOR_INVOICES']);
					break;
				}
				var TempBillRowid=f.elements["BillRowIDz"+j].value;				
				BillAry[BillAry.length]=f.elements["BillRowIDz"+j].value;
			}
		}
	}

}
function ARPatBillListAll_BillSelectedAdms(lnk,newwin) {
	var tbl =document.getElementById("tARPatientBill_ListAll");
	var PatientID ="";
	var BillsOK   =true;

	var f = document.getElementById("f" + tbl.id.substring(1,tbl.id.length));
	var aryfound = CheckedCheckBoxesOrSelectedRow(f,tbl,"SelectBillz");

	var objContext = document.getElementById("TWKFL");
	if (objContext) {
		var currContext=objContext.value;
	}

	if (aryfound.length==0) {
		alert(t['NO_BILL_SELECTED']);
		return;
	} else {
        
		if (aryfound.length > 0) {

			var BillRowIds="";
			var PatientIds="";
			var EpisodeIds="";
			var BillType="";
			var NextBillType="";
			for (var i=0; i<aryfound.length; i++) {
				j = aryfound[i];
				
				BillRowIds   = BillRowIds + f.elements["BillRowIDz"+j].value;
				PatientIds   = PatientIds + f.elements["PatientIDz"+j].value;
				EpisodeIds   = EpisodeIds + f.elements["EpisodeIDz"+j].value;
				NextBillType = f.elements["BillTypez"+j].value;
				//alert(f.elements["LinkedToIdz"+j].value)
				/*
				if (f.elements["LinkedToIdz"+j]&&f.elements["LinkedToIdz"+j].value!="") {
				alert ("MSD:Linked episode no need to bill"); 
				BillsOK=false;
				return;				
				}
				*/
				if (NextBillType=="D") {
					//Deposit lines may not be selected
					alert(t['DEP_ROW_SEL']+" "+t['NO_DEPS_BILL']);
					BillsOK=false;
					return;				
				}
				if (BillType=="") {
					BillType=NextBillType;	
				} else {
					if (BillType!=NextBillType) {
						alert(t['NO_PAT_INS_BILLS']+"\n"+t['ONLY_SAME_BILLS']);
						BillsOK=false;
						return;	
					}
				}
				if (i<aryfound.length-1) {
					BillRowIds=BillRowIds+"|";
					PatientIds=PatientIds+"|";
					EpisodeIds=EpisodeIds+"|";
				}	
			}		
		}
		
		var objTWKFL  = document.getElementById('TWKFL');
		var objTWKFLI = document.getElementById('TWKFLI');
		var TWKFL=""; var TWKFLI="";
		if (objTWKFL)  TWKFL  = objTWKFL.value;
		if (objTWKFLI) TWKFLI = objTWKFLI.value;
		
		//Log 46817 - 11.09.2006 - Get Page type from component instead of hardcoding it as "Patient"
		
		lnk += "&PageType="+PageType+"&PatientIDs="+PatientIds+"&EpisodeIDs="+EpisodeIds+"&BillRowIDs="+BillRowIds+"&GroupType="+GroupType;
		lnk += "&CONTEXT="+session["CONTEXT"]+"&TWKFL="+TWKFL+"&TWKFLI="+TWKFLI;
	}
	
	//42379 - 27.02.04
	var frmListTotals = window.top.frames["TRAK_main"].frames[1];
	if (frmListTotals) {
		var formtot = frmListTotals.document.forms['fARPatientBill_ListTotals'];
		if (formtot) formtot.elements["RefreshCSP"].value = "1";
	}
	//alert(lnk);
	window.location = lnk;
}

function ARPatBillListAll_InterimBillSelectedAdms(lnk,newwin) {

	var tbl=document.getElementById("tARPatientBill_ListAll");
	var PatientID="";
	var BillsOK=true;

	var f = document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var aryfound = CheckedCheckBoxesOrSelectedRow(f,tbl,"SelectBillz");
	
	if (aryfound.length==0) {
		alert(t['NO_BILL_SELECTED']);
		return;
	} else {
		// SA 30.5.02 - no log: I have changed the premise aryfound.length to be greater
		// than zero rather than just equal 1. Not sure why it was written for this menu option.
		// The other menu options only allow one bill to be processed at a time, so it is fine
		// there. Please consult me if there are any problems here.
		//if (aryfound.length==0) {

		if (aryfound.length > 0) {
			var BillRowIds="";
			var PatientIds="";
			var EpisodeIds="";
			var BillType="";
			var NextBillType="";
			
			for (var i=0; i<aryfound.length; i++) {
				j=aryfound[i];
				BillRowIds=BillRowIds+f.elements["BillRowIDz"+j].value;
				PatientIds=PatientIds+f.elements["PatientIDz"+j].value;
				EpisodeIds=EpisodeIds+f.elements["EpisodeIDz"+j].value;
				NextBillType=f.elements["BillTypez"+j].value;

				if (NextBillType=="D") {
					//Deposit lines may not be selected
					alert(t['DEP_ROW_SEL']+" "+t['NO_DEPS_BILL']);
					BillsOK=false;
					return;				
				}
				if (BillType=="") {
					BillType=NextBillType;	
				} else {
					if (BillType!=NextBillType) {
						alert(t['NO_PAT_INS_BILLS']+"\n"+t['ONLY_SAME_BILLS']);
						BillsOK=false;
						return;	
					}
				}
				if (i<aryfound.length-1) {
					BillRowIds=BillRowIds+"|";
					PatientIds=PatientIds+"|";
					EpisodeIds=EpisodeIds+"|";
				}
			}
		}

		
		
		//Log 64188 - 04.07.2007 - the URL is too long when the patient, episode and bill row ids are concatenated together.
		/*var url="websys.default.csp?WEBSYS.TCOMPONENT=ARPatientBill.EditInterim";
		url += "&PatientIDs="+PatientIds+"&EpisodeIDs="+EpisodeIds+"&BillRowIDs="+BillRowIds+"&CONTEXT="+session["CONTEXT"];
		*/
		var url="websys.default.csp "; 
		//still need to open new window this way to be able to remove locationbar, toolbar, etc 
		//Log 59598 - BC - 29-06-2006 : remove statusbar variable (status=) to display the status bar.
		websys_createWindow(url,'child2','left=100,top=100,width=300,height=150,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes');		
		var winChild=window.open('','TRAK_hidden'); 
		with (winChild) { 
			document.open("text/html"); 
			document.write('<HTML><HEAD></HEAD><BODY>'); 
			document.writeln('<FORM name="HFORM" id="HFORM" method="POST" action="websys.default.csp" target="child2">'); 
			document.writeln('<INPUT NAME="WEBSYS.TCOMPONENT" VALUE="ARPatientBill.EditInterim">'); 
			document.writeln('<INPUT NAME="PatientIDs" VALUE="'+PatientIds+'">'); 
			document.writeln('<INPUT NAME="EpisodeIDs" VALUE="'+EpisodeIds+'">'); 
			document.writeln('<INPUT NAME="BillRowIDs" VALUE="'+BillRowIds+'">'); 
			document.writeln('<INPUT NAME="CONTEXT" VALUE="'+session["CONTEXT"]+'">'); 
			document.writeln('</FORM></BODY></HTML>'); 
			document.close(); 
			document.HFORM.submit(); 
		}
		//End Log 64188 		
	}

}

function ARPatBillListAll_CancelSelectedBills(lnk,newwin) {
	var tbl=document.getElementById("tARPatientBill_ListAll");
	var PatientID="";
	var BillsOK=true;

	var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var aryfound=CheckedCheckBoxesOrSelectedRow(f,tbl,"SelectBillz");
	var objContext=document.getElementById("TWKFL");
	if (objContext) {
		var currContext=objContext.value;
		//alert("currContext="+currContext);
	} else {
		//alert("no context");
	}
	if (aryfound.length==0) {
		alert(t['NO_BILL_SELECTED']);
		return;
	} else {
		if (aryfound.length) {
			var BillRowIds="";
			var PatientIds="";
			var EpisodeIds="";
			var BillType="";
			var NextBillType="";
			for (var i=0; i<aryfound.length; i++) {
				j=aryfound[i];
				BillRowIds=BillRowIds+f.elements["BillRowIDz"+j].value;
				PatientIds=PatientIds+f.elements["PatientIDz"+j].value;
				EpisodeIds=EpisodeIds+f.elements["EpisodeIDz"+j].value;
				NextBillType=f.elements["BillTypez"+j].value;
				if (NextBillType=="D") {
					//Deposit lines may not be selected
					alert(t['DEP_ROW_SEL']+" "+t['NO_DEPS_BILL']);
					BillsOK=false;
					return;				
				}
				if (NextBillType=="ADM") {
					//Admission lines may not be selected
					alert(t['INV_ONLY_CANC']);
					BillsOK=false;
					return;				
				}
				if (BillType=="") {
					BillType=NextBillType;	
				} else {
					if (BillType!=NextBillType) {
						alert(t['NO_PAT_INS_BILLS']+"\n"+t['ONLY_SAME_BILLS']);
						BillsOK=false;
						return;	
					}
				}
				if (i<aryfound.length-1) {
					BillRowIds=BillRowIds+"|";
					PatientIds=PatientIds+"|";
					EpisodeIds=EpisodeIds+"|";
				}	
			}		
		}
		lnk += "&PatientIDs="+PatientIds+"&EpisodeIDs="+EpisodeIds+"&BillRowIDs="+BillRowIds+"&CONTEXT="+session["CONTEXT"];
		//var obj=document.getElementById("TRELOADID")
		//if (obj) lnk+="&TRELOADID="+obj.value;
		//alert (lnk);
	}
	if (window.opener) {
		window.opener.top.frames["TRAK_hidden"].location.href=lnk;
	} else {
		top.frames["TRAK_hidden"].location.href=lnk;
	}
	//window.location = lnk;
	treload();
}

function ARPatBillListAll_DispNegOustand(e) {
	//var tbl=getTableName(window.event.srcElement);

	var tbl=document.getElementById("tARPatientBill_ListAll");
	//var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));


//	var aryfound=CheckedCheckBoxesOrSelectedRow(f,tbl,"SelectBillz");
	for (var i=1; i<tbl.rows.length; i++) {
		var OutAmtCol=document.getElementById("OutstandAmtz"+i);
		//alert(OutAmtCol.innerText);
		if (OutAmtCol) {
			var val=parseInt(OutAmtCol.innerText,10);
			if (OutAmtCol && val<0) {
				OutAmtCol.style.color="Red";
			}
		}
		//if (tbl.rows[i].cells['OutAmtCol'].innerText!="" && parseInt(tbl.rows[i].cells[9].innerText,10)<0) {
		//	tbl.rows[i].cells[9].style.color="Red";	
		//}
		
	}
	
}

function ARPatBillListAll_Translate(e) {

	var tbl=document.getElementById("tARPatientBill_ListAll");

	//for every row of the table
	for (var i=1; i<tbl.rows.length; i++) {

		var transTypeCol=document.getElementById("TransTypez"+i);
		var EpisodeOnHoldCol=document.getElementById("EpisodeOnHoldz"+i);

		var hidTransType= document.getElementById("hidTransTypez"+i);
		var code = hidTransType.value;

		if  ((transTypeCol)&&(code!="")) {
			if (code=="INV") {
				if ((EpisodeOnHoldCol) && (EpisodeOnHoldCol.value=="Y")) transTypeCol.innerText=t['INV_ONHOLD'];
				else transTypeCol.innerText=t['INV'];
			} else if (code=="DEP") {
				transTypeCol.innerText=t['DEP'];
			} else if (code=="REC") {
				transTypeCol.innerText=t['REC'];
			} else if (code=="ADM") {
				transTypeCol.innerText=t['ADM'];
			} else if (code=="REF") {
				transTypeCol.innerText=t['REF'];
			} else if (code=="CREF") {    //41942,44178 CREF=Credit Note
				transTypeCol.innerText=t['CN'];
			} else if (code=="CINV") {
				transTypeCol.innerText=t['CINV'];
			} else if (code=="OVERPAY") {
				transTypeCol.innerText=t['OVERPAY'];
			} else if (code=="RECOUPED") {
				transTypeCol.innerText=t['RECOUPED'];  //44252
			}
		}

		//Disable invoice total and adjustment total links if transactype is other than invoice
		//41942 AJI - added CREF

		if (code!="INV" && code!="REF" && code!="CINV" && code!="CREF") {
			//invoice total
			var objCB=document.getElementById("InvTotalz"+i);
			if (objCB) {
				objCB.disabled=true;
				objCB.onclick=LinkDisable;
			}
			//Adjustment Total
			var objAT=document.getElementById("AdjTotalz"+i);
			if (objAT) {
				objAT.disabled=true;
				objAT.onclick=LinkDisable;
			}
		} else {
			// AJI 42397 - 10.03.04 -> had to introduce custom script to decide whether to disable or not.
			try {	DisableAdjustmentLink(i); } catch(e) { }
		}
	}
}

/**
 *
 */
function PrintSelectedRowsHandler(tblname,lnk,newwin) {
	
	var found=0;
	var BillType="";
	var BillRowID="";
	var PatientID="";
	var EpisodeID="";
	var Payor="";
	if (tblname=="") {
		//alert("tblname");
		var eSrc=websys_getSrcElement();
		if (eSrc) var tbl=getTableName(eSrc);
	} else {
		//alert("tablename else");
		var tbl=document.getElementById(tblname);
	}

	var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var aryfound=CheckedCheckBoxesOrSelectedRow(f,tbl,"SelectBillz");
	if (aryfound.length==0) {
		alert(t['NO_BILL_SELECTED']);
	} else {
		if (newwin=="TRAK_hidden") {
			for (i in aryfound) {
				j = aryfound[i];

				BillRowID=f.elements["BillRowIDz"+j].value;
				PatientID=f.elements["PatientIDz"+j].value;
				EpisodeID=f.elements["EpisodeIDz"+j].value;
				NextBillType=f.elements["BillTypez"+j].value;
				if (f.document.getElementById("INSTDescz"+j)) { //55417
					Payor=f.document.getElementById("INSTDescz"+j).innerText;
				}
				if ((NextBillType!="I")&&(NextBillType!="P")) {
					//bill type other than invoice has been selected.
					alert(t['PRNT_INVOICES']);
					return false;
				}
				if (BillType=="") {
					BillType=NextBillType;
				}
				if ((BillType!="I")&&(BillType!="P")) {
					alert(t['PRNT_INVOICES']);
					return false;
				}

				// if sites want different payor to validate,
				// the method needs to be overriden in custom script (eg. 44315)
				try {
					if (!CheckPayorType(Payor)) return false;
				} catch(e) { }

				try {
					//54041 custom functionality -> payment cannot be allocated unless confirmed they are ready for billing
					if (!CheckReadyForBilling(f.elements["NotReadyForBillingz"+j].value)) return false;
				} catch(e) { }
			}
			var hiddenwin=window.open('',newwin);
			with (hiddenwin) {
 				document.open("text/html");
				document.write('<HTML><HEAD></HEAD><BODY>');
				document.writeln('<FORM name="HFORM" id="HFORM" method="POST" action="' + lnk + '">');
				document.writeln('<INPUT NAME="MULTI" VALUE="1">');
				document.writeln('<INPUT NAME="MULTIITEMS" VALUE="PatientID,BillRowID,EpisodeID,ClassName,ClassNameID">');
				// for each row selected
				for (i in aryfound) {
					var row=aryfound[i];
					// check for specific values - these values must be hidden in the component
					if (!f.elements["PatientIDz"+row]) continue;
					if (!f.elements["BillRowIDz"+row]) continue;
					if (!f.elements["EpisodeIDz"+row]) continue;
					if ((f.elements["BillRowIDz"+row].value!="")&&(f.elements["PatientIDz"+row].value!="")&&(f.elements["EpisodeIDz"+row].value!="")) {
						document.writeln('<INPUT NAME="PatientID" VALUE="' + f.elements["PatientIDz"+row].value + '">');
						document.writeln('<INPUT NAME="BillRowID" VALUE="' + f.elements["BillRowIDz"+row].value + '">');
						document.writeln('<INPUT NAME="EpisodeID" VALUE="' + f.elements["EpisodeIDz"+row].value + '">');
						//pass the following params to enable RequestedReportHistory functionality
						document.writeln('<INPUT NAME="ClassName" VALUE="ARPatientBill">');
						document.writeln('<INPUT NAME="ClassNameID" VALUE="' + f.elements["BillRowIDz"+row].value + '">');
					}
				}
				//document.writeln('</FORM><SCR'+'IPT language=javascript>');
				//document.writeln('window.document.HFORM.submit();');
				//document.writeln('</SCR'+'IPT></BODY></HTML>');
				document.writeln('</FORM></BODY></HTML>');
				document.close();
				document.HFORM.submit();
			}
		} else {
			// for each row selected
			for (i in aryfound) {
				var row=aryfound[i];
				// check for specific values - these values must be hidden in the component
				if (!f.elements["BillRowIDz"+row]) continue;
				if (!f.elements["PatientIDz"+row]) continue;
				if (!f.elements["EpisodeIDz"+row]) continue;
				if ((f.elements["BillRowIDz"+j].value!="")&&(f.elements["PatientIDz"+j].value)&&(f.elements["EpisodeIDz"+j].value)) {
					// KK 20/feb/2003 Log 31568
					// when the report is crystal and will be previewed pass these parameters so they can
					// be converted to prompt(n) variables.
					PassReportParametersForPreview(lnk,newwin,f.elements["BillRowIDz"+row].value,f.elements["PatientIDz"+row].value);
				}
			}
		}
	}
	return false;
}

function LinkedEpisodes() {
	return true;
}

function CheckPayorType() {
	return true;
}

function CheckReadyForBilling(flag) {
	//54041
	return true;
}

//JPD log 48371
function PrintBatchStatement(tblname,lnk,newwin) {
	if (docBillFind) {
		var PrintLetter=docBillFind.getElementById("PrintLetter");
		var LetterType=docBillFind.getElementById("LetterType");

		if ((PrintLetter) && (PrintLetter.checked==false)) {
			if ((LetterType) && (LetterType.value=="")) {
				PrintInvoicesInBatch(tblname,lnk,newwin);
			}
		}		
	}
	return;
}

/**
 *  log 44793
 */
function PrintInvoicesInBatch(tblname,lnk,newwin) {
	var BillRowIDs="";
	var PatientIDs="";
	var Payor="";
	var BillRowID="";
	var PatientID="";
	var EpisodeID="";
	var BillType="";
	var NextBillType="";
	
	if (tblname=="") {
		var eSrc=websys_getSrcElement();
		if(eSrc) var tbl=getTableName(eSrc);
	} else {
		var tbl=document.getElementById(tblname);
	}

	try {
		if (!LinkedEpisodes()) return false;
	} catch(e) {}

	var MABNObj=document.getElementById("ManuBatchNo");
	if((MABNObj)&&(MABNObj.value!="")&&(MABNObj.className=="clsInvalid")) {
		alert(t['BAT_NUM']);
		return false;
	}

	var f = document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var aryfound = CheckedCheckBoxesOrSelectedRow(f,tbl,"SelectBillz");

	if (aryfound.length==0) {
		alert(t['NO_BILL_SELECTED']);
	} else {
		for (i in aryfound) {
			j=aryfound[i];

			BillRowID    = f.elements["BillRowIDz"+j].value;
			PatientID    = f.elements["PatientIDz"+j].value;
			EpisodeID    = f.elements["EpisodeIDz"+j].value;
			NextBillType = f.elements["BillTypez"+j].value;
			if (f.document.getElementById("INSTDescz"+j)) {
				Payor = f.document.getElementById("INSTDescz"+j).innerText;
			}

			if ((NextBillType!="I")&&(NextBillType!="P")) {   //bill type other than invoice has been selected.
				alert(t['PRNT_INVOICES']);
				return false;
			}
			if (BillType=="") {
				BillType = NextBillType;
			}
			if ((BillType!="I")&&(BillType!="P")) {
				alert(t['PRNT_INVOICES']);
				return false;
			}
			
			//concatenate bills delimited by ^
			BillRowIDs = BillRowIDs + BillRowID + "^";
			PatientIDs = PatientIDs + PatientID + "^";

			//47221
			try {
				if (!CheckPayorType(Payor)) return false;
			} catch(e) { }

			try {
				//54041 custom functionality -> payment cannot be allocated unless confirmed they are ready for billing
				if (!CheckReadyForBilling(f.elements["NotReadyForBillingz"+j].value)) return false;
			} catch(e) { }
		}
		//alert("BillRowIDs = " + BillRowIDs + " PatientIDs = " + PatientIDs);

		var ManuBatchNum="";
		var MABNObj=document.getElementById("ManuBatchNo");
		if((MABNObj)&&(MABNObj.value!=""))ManuBatchNum=MABNObj.value;
		
		if (newwin=="TRAK_hidden") {
			var hiddenwin=window.open('',newwin);
			with (hiddenwin) {
 				document.open("text/html");
				document.write('<HTML><HEAD></HEAD><BODY>');
				document.writeln('<FORM name="HFORM" id="HFORM" method="POST" action="' + lnk + '">');
				document.writeln('<INPUT NAME="MULTI" VALUE="1">');
				document.writeln('<INPUT NAME="MULTIITEMS" VALUE="PatientIDs,BillRowIDs,ManuBatchNum">');
				document.writeln('<INPUT NAME="PatientIDs" VALUE="' + PatientIDs + '">');
				document.writeln('<INPUT NAME="BillRowIDs" VALUE="' + BillRowIDs + '">');
				document.writeln('<INPUT NAME="ManuBatchNum" VALUE="' + ManuBatchNum + '">');
				document.writeln('<INPUT NAME="ClassName" VALUE="ARPatientBill">');
				document.writeln('</FORM></BODY></HTML>');
				document.close();
				document.HFORM.submit();
			}
		} else {
			PassReportParametersForPreview(lnk,newwin,BillRowIDs,PatientIDs);
		}
	}
	return false;
}

/**
 *
 */
function CreateEDI() {

	var BillType="";
	var EDIBillRowIDs="";
	var PatientIDs="";
	var EpisodeIDs="";
	var aryfound="";
	var PaperBillRowIDs="";

	var tbl=document.getElementById("tARPatientBill_ListAll");
	var f=document.getElementById("fARPatientBill_ListAll");
	aryfound=CheckedCheckBoxesOrSelectedRow(f,tbl,"SelectBillz");

	if (aryfound.length==0) {
		alert(t['NO_BILL_SELECTED']);
		return false;
	}

	for (i in aryfound) {
		j=aryfound[i];
		var BillRowID=f.elements["BillRowIDz"+j].value;
		var PatientID=f.elements["PatientIDz"+j].value;
		var EpisodeID=f.elements["EpisodeIDz"+j].value;
		var NextBillType=f.elements["BillTypez"+j].value;
		var EDIStatus=f.elements["EDIStatusz"+j].value;
		var EDIOverriden=f.elements["EDIOverridenz"+j].value;

		if (EDIStatus!="Y") {
			alert(t['NON_EDI']);  //Some, or all of the selected invoices are not for an EDI payer
			return false;
		}

		if ((NextBillType!="I")&&(NextBillType!="P")) {   //bill type other than invoice has been selected.
			alert(t['PRNT_INVOICES']);
			return false;
		}
		if (BillType=="") {
			BillType=NextBillType;
		}
		if ((BillType!="I")&&(BillType!="P")) {
			alert(t['PRNT_INVOICES']);
			return false;
		}
		
		//check if it's an EDI invoice or not.
		//the report routine will use these diff. IDs to either produce EDI file or paper invoice

		if (EDIOverriden=="Y") {
			PaperBillRowIDs = PaperBillRowIDs + BillRowID + "^";
		}
		else {
			EDIBillRowIDs = EDIBillRowIDs + BillRowID + "^";
		}
		
		PatientIDs = PatientIDs + PatientID + "^";
	}

	var url="arpatientbill.edicreation.csp?runudf=1&EDIBillRowIDs="+EDIBillRowIDs+"&PaperBillRowIDs="+PaperBillRowIDs+"&PatientIDs="+PatientIDs;

	websys_createWindow(url,"TRAK_hidden");

	return false;
}


/*
  KK 23/May/2003 Log 35938 - Had to use a new function for printing selected rows for this report. 
  Since this report needs only EpisodeID and the Normal PrintSelectedRowsHandler checks for Invoices and BillRowIds and Bill Types
*/
function PrintMedUsageSelectedRowsHandler(tblname,lnk,newwin) {

	var found=0;
	var EpisodeID="";
	var count=0;
	if (tblname=="") {
		var eSrc=websys_getSrcElement();
		if(eSrc) var tbl=getTableName(eSrc);
	} else {
		var tbl=document.getElementById(tblname);
	}
	var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var aryfound=checkedCheckBoxes(f,tbl,"SelectBillz");
	// HitCount is only required for reports when data is not being refresh automatically due to problems with
	// the Crystal Web Server. See Crystal KnowledgeBase Article c2002771.
	var HitCount=Math.round(Math.random() * 1000);
	if (aryfound.length==0) {
		alert(t['NO_BILL_SELECTED']);
	} else {
		if (newwin=="TRAK_hidden") {
			for (i in aryfound) {
				j=aryfound[i];
				EpisodeID=f.elements["EpisodeIDz"+j].value;
				if (EpisodeID==""){
					alert(t['PRNT_ADM']);
					return false;	
				}
				count=count+1;
				if (count>1){
					alert(t['ONE_ROW']);
					return false;
				}
			}
			var hiddenwin=window.open('',newwin);
			var row=0;
			var DStr="";	
			DStr='<HTML><HEAD></HEAD><BODY>';
			DStr+='<FORM name="HFORM" id="HFORM" method="POST" action="' + lnk + '">';
			DStr+='<INPUT NAME="MULTI" VALUE="1">';
                  DStr+='<INPUT NAME="MULTIITEMS" VALUE="PatientID,EpisodeID">';
			for (i in aryfound) {
				row=aryfound[i];
				if (!f.elements["PatientIDz"+row]) continue;
				if (!f.elements["EpisodeIDz"+row]) continue;
				if ((f.elements["EpisodeIDz"+row].value!="")&&(f.elements["PatientIDz"+row].value!="")) {
					DStr+='<INPUT NAME="PatientID" VALUE="' + f.elements["PatientIDz"+row].value + '">';
					DStr+='<INPUT NAME="EpisodeID" VALUE="' + f.elements["EpisodeIDz"+row].value + '">';
				}
			}
			DStr+='</FORM>';
			DStr+='</BODY></HTML>';
			hiddenwin.document.write(DStr);
			hiddenwin.document.HFORM.submit();
			hiddenwin.document.close;
		} else {
			// for each row selected
			for (i in aryfound) {
				var row=aryfound[i];
				//if (!f.elements["PatientIDz"+row]) continue;
				if (!f.elements["EpisodeIDz"+row]) continue;
				if ((f.elements["EpisodeIDz"+row].value!="")&&(f.elements["PatientIDz"+row].value!="")) {
					// when the report is crystal and will be previewed pass these parameters so they can
					// be converted to prompt(n) variables.
					PassReportParametersForPreview(lnk,newwin,f.elements["EpisodeIDz"+row].value,f.elements["PatientIDz"+row].value);
				}
			}
		}
	}
}

function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);

	if (el.disabled||el.id=="") return false;

	return true;
}

function PatientBillNoBuilder(sBillNo) {
	var tbl=document.getElementById("tARPatientBill_ListAll");
	var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));

	if (f && tbl) {

		var aryPatBillNo=new Array(); var aryStat=new Array(); var n=0;
		for (var i=1;i<tbl.rows.length;i++) {
			if (f.elements["SelectBillz"+i] && f.elements["SelectBillz"+i].checked) {
				aryPatBillNo[n]=document.getElementById(sBillNo+'z'+i).innerText;
				n++;
			} else if (tbl.rows[i].className=="clsRowSelected") {
				aryPatBillNo[n]=document.getElementById(sBillNo+'z'+i).innerText;
				n++;
			}
		}
		return aryPatBillNo.join("^");
	}
	return "";
}

// 42792 - for use in batch receipting process
//
function InvoiceForBatchHandler() {

	if (winOpener == null)  return false; // don't proceed if no ref. to BatchReceipting window

	var objPayor = winOpener.document.getElementById("Payor");

	var NextBillRowID="";
	var NewBillRowIDs="";
	var NextNewBillRowID="";
	var BillRowIDs="";
	var SelPayor="";
	
	try {
		
		var i=0;
		var BillType=""

		//SelBillTypes is a global variable
		while (winOpener.mPiece(SelBillTypes,"^",i) && winOpener.mPiece(SelBillTypes,"^",i)!="") {
			BillType = winOpener.mPiece(SelBillTypes,"^",i);
			if (BillType=="P") {
				alert(t['PAT_BILLS_NOT_ALLOWED']);
				return false;
			}
			i++;
		}

		var tbl=document.getElementById("tARPatientBill_ListAll");
		var objSelPayor;
		for (var i=1;i<tbl.rows.length;i++) {
			var objSelectBill=document.getElementById("SelectBillz"+i);
			if (objSelectBill && objSelectBill.checked && !objSelectBill.disabled) {
				//Log 63664 - 22.05.2007 -Dont allow Credit Notes to be added to Batch Receipting. They should use the Deposit.
				objTransType=document.getElementById("TransTypez"+i);
				if (objTransType) TransType = objTransType.innerText;
				if (TransType==t['CREF']) {
					alert(t['NO_CREDITNOTE_FOR BATCH']);
					return false;
				}	
				//End Log 63664				
				objSelPayor=document.getElementById("INSTDescz"+i);
				if (objSelPayor) {
					if (SelPayor!="" && SelPayor!=objSelPayor.innerText) {
						alert("Must select the same Payor");
						return false;
					}
					if (objPayor && objPayor.value!="" && objPayor.disabled && objPayor.value!=objSelPayor.innerText) {
						alert("Cannot add Invoice. Invalid Payor. Batch Receipting list has been set for " + objPayor.value + " invoices only");
						return false;
					}
					SelPayor=objSelPayor.innerText;
				}
			}
		}
	} catch(e) {}

	try {
		//SelBillRowID is a global variable for storing selected bill row ids

		var arbb = SelBillRowID.split("^");

		NewBillRowIDs = arbb.join("|");  // use pipe delimiter

	} catch(e) { alert("Error on InvoiceForBatchHandler " + e.msg); }

	var objBillRowIDs      = winOpener.document.getElementById("BillRowIDs");
	var objReceiptAmt      = winOpener.document.getElementById("ReceiptAmt");
	var objAction          = winOpener.document.getElementById("Action");
	var objDepositRowIDs   = winOpener.document.getElementById("DepositRowIDs");

	if (NewBillRowIDs == "") {
		alert(t['NO_BILL_SELECTED']);

		return false;
	}
	else if (NewBillRowIDs!="" && objBillRowIDs) {
		
		BillRowIDs = objBillRowIDs.value;  // existing bill_IDs on the batch receipting list

		//alert("Current BillRowIDs "+ BillRowIDs + " - NewBillRowIDs " + NewBillRowIDs);

		if (BillRowIDs=="") {
			BillRowIDs = NewBillRowIDs;
		}
		else {
			var i = 0;
			var j = 0;
			var PayorBillNo = PatientBillNoBuilder("PayorBillNo");

			while (winOpener.mPiece(NewBillRowIDs,"|",i) && winOpener.mPiece(NewBillRowIDs,"|",i)!="") {	

				NextNewBillRowID = winOpener.mPiece(NewBillRowIDs,"|",i);
				j = 0; // reset
				while (winOpener.mPiece(BillRowIDs,"|",j) && winOpener.mPiece(BillRowIDs,"|",j)!="" ) {

					NextBillRowID = winOpener.mPiece(BillRowIDs,"|",j);
					if (NextNewBillRowID == NextBillRowID) {
						if (PayorBillNo!="")
							alert(t['INV_NUM'] + " " + winOpener.mPiece(PayorBillNo,"^",i) + " " + t['IN_BATCH_ALREADY']);
						else
							alert(t['INV_NUM'] + " " + t['IN_BATCH_ALREADY']);

						return false;
					}
					j++;
				}
				i++;
			}
			BillRowIDs+= "|" + NewBillRowIDs;
		}

		objBillRowIDs.value = BillRowIDs;
	}

	var ReceiptAmt="";
	var Action="";
	var Payor="";
	var DepositRowIDs="";
	
	//Log 63114 - 02.04.2007 - Get Patient ID
	var objPatID=document.getElementById("PatientID");
	var PatId="";
	if (objPatID) PatId=objPatID.value;
	//End Log 63114
	
	if (objReceiptAmt)    ReceiptAmt    = objReceiptAmt.value;
      if (objAction)        Action        = objAction.value;
      if (objDepositRowIDs) DepositRowIDs = objDepositRowIDs.value;

     	if (objPayor && objPayor.disabled && objPayor.value!="")
		Payor = objPayor.value;
	else
		Payor = SelPayor;

	var CONTEXT = winOpener.session['CONTEXT'];
	var url="";
	
	if (winOpener.name == "BR.ARPatBillFindBatch") {
		//HERE means -> it's opened from Batch Receipting

		var UnselDepositRowIDs=winOpener.document.getElementById("UnselDepositRowIDs").value;
		var UnselBillRowIDs=winOpener.document.getElementById("UnselBillRowIDs").value;
		
		var url = "arpatientbill.batchfind.csp?PageType=Batch&BillRowIDs="+BillRowIDs+"&DepositRowIDs="+DepositRowIDs;
		url+= "&ReceiptAmt="+ReceiptAmt+"&Payor="+websys_escape(Payor)+"&DontClearPayDet=1&Action="+Action+"&GroupType="+GroupType;
		url+= "&CONTEXT="+CONTEXT+"&NewlyAddedBill="+NewBillRowIDs+"&SelectAll=Y";
		url+= "&UnselBillRowIDs="+UnselBillRowIDs+"&UnselDepositRowIDs="+UnselDepositRowIDs;
		url+= "&PatientID="+PatId;		//Log 63114 - 02.04.2007
		
		window.close();
		winOpener.websys_createWindow(url,"TRAK_main");
	}
	else if (winOpener.name == "FRAMEARPatientBillFindBatch") {
		//HERE means -> it's opened from Batch Letter
		
		var patbillfindFrm = winOpener.parent.frames["FRAMEARPatientBillFind"];
		
		objBillRowIDs = patbillfindFrm.document.getElementById("BillRowIDs");
		objBillRowIDs.value = NewBillRowIDs;

		window.close();

		ReloadBatchLetter(patbillfindFrm);
	}
}

/* 
 *  42792
 *  patbillfindFrm refers to ARPatientBill.Find frame, hence ARPatientBill.Find.js
 *  this function pretty similar to FindClickHandlerBatchLetter in ARPatientBill.Find.js
 *  but the one in ARPatientBill.Find.js is best to be left alone.
 *
 */
function ReloadBatchLetter(patbillfindFrm) {

	var BillRowIDs="";
	var SingleBillRowID="";
	var InvoiceNumber="";
	var DateFrom=""; var DateTo="";
	var Plan=""; var Office=""; var BatchNum=""; var PayorGroup="";
	var Payor=""; var Hospital=""; var URN=""; var Surname=""; var AccountClass="";
	var PaymentClass=""; var MinAmount=""; var DaysOverdueFr=""; var DaysOverdueTo="";
	var NextBillRowID="";	

	var CONTEXT = patbillfindFrm.session['CONTEXT'];

	var objPayorGroup=patbillfindFrm.document.getElementById("PayorGroup");
	if (objPayorGroup) PayorGroup=objPayorGroup.value;
	var objPayor=patbillfindFrm.document.getElementById("Payor");
	if (objPayor) Payor=objPayor.value;
	var objOffice=patbillfindFrm.document.getElementById("Office");
	if (objOffice) Office=objOffice.value;
	var objPlan=patbillfindFrm.document.getElementById("Plan");
	if (objPlan) Plan=objPlan.value;
	var objBatchNum=patbillfindFrm.document.getElementById("BatchNum");
	if (objBatchNum) BatchNum=objBatchNum.value;
	var objDateFrom=patbillfindFrm.document.getElementById("DateFrom");
	if (objDateFrom) DateFrom=objDateFrom.value;
	var objDateTo=patbillfindFrm.document.getElementById("DateTo");
	if (objDateTo) DateTo=objDateTo.value;

	var objBillRowIDs=patbillfindFrm.document.getElementById("BillRowIDs");
	if (objBillRowIDs) BillRowIDs=objBillRowIDs.value;
	var objHospital=patbillfindFrm.document.getElementById("Hospital");
	if (objHospital) Hospital=objHospital.value;
	var objURN=patbillfindFrm.document.getElementById("URN");
	if (objURN) URN=objURN.value;
	var objSurname=patbillfindFrm.document.getElementById("Surname");
	if (objSurname) Surname=objSurname.value;
	var objAccountClass=patbillfindFrm.document.getElementById("AccountClass");
	if (objAccountClass) AccountClass=objAccountClass.value;
	var objPaymentClass=patbillfindFrm.document.getElementById("PaymentClass");
	if (objPaymentClass) PaymentClass=objPaymentClass.value;
	var objMinAmountOwing=patbillfindFrm.document.getElementById("MinAmountOwing");
	if (objMinAmountOwing) MinAmount=objMinAmountOwing.value;
	var objNoDaysOverdueFrom=patbillfindFrm.document.getElementById("NoDaysOverdueFrom");
	if (objNoDaysOverdueFrom) DaysOverdueFr=objNoDaysOverdueFrom.value;
	var objNoDaysOverdueTo=patbillfindFrm.document.getElementById("NoDaysOverdueTo");
	if (objNoDaysOverdueTo) DaysOverdueTo=objNoDaysOverdueTo.value;
	
	var url="";
		
	// NOTE: shouldn't pass any Hospital at all!

	url= "arpatientbillbatchletter.csp?BillRowIDs="+BillRowIDs+"&Payor="+Payor+"&PayorGroup="+PayorGroup;
	url= url + "&AccountClass="+AccountClass+"&PaymentClass="+PaymentClass;
	url= url + "&Plan="+Plan+"&Office="+Office+"&BatchNum="+BatchNum+"&DateFrom="+DateFrom+"&DateTo="+DateTo;
	url= url + "&URN="+URN+"&Surname="+Surname+"&MinAmountOwing="+MinAmount+"&NoDaysOverdueFrom="+DaysOverdueFr+"&NoDaysOverdueTo="+DaysOverdueTo;
	url= url + "&CONTEXT="+CONTEXT+"&ChkUnpBillsOnly=Y";

	websys_createWindow(url,"TRAK_main");
}


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

function GetCheckedRows(f,tbl,col) {
	var aryfound=new Array;found=0;
	for (var ic=1;ic<tbl.rows.length;ic++) {
		if (f.elements[col+ic] && f.elements[col+ic].checked && !f.elements[col+ic].disabled) {
			aryfound[found]=ic;found++;
		}
	}
	return aryfound;
}

function DepositBillsEpisodesCheck(DepositEpisodeIDs,BillEpisodeIDs) {
	
	// SA 13.3.03 - log 32197: Episode specific deposits much match the
	// episodes of any bills selected. This function will return false
	// when this is not the case.

	//alert("DepositEpisodeIds**BillEpisodeIDs="+DepositEpisodeIDs+"**"+BillEpisodeIDs);

	var aryDep=DepositEpisodeIDs.split("|");
	var aryBill=BillEpisodeIDs.split("|");

	for (var i=0;i<aryDep.length;i++) {
		for (var j=0;j<aryBill.length;j++) {
			if (aryDep[i] && aryBill[j] && aryDep[i]!=aryBill[j]) return false; //43206 AJI 30/03/04
		}
	}

	return true;
}

//Log 66213
function HospitalCheck(DepHospIds,BillHospIds) {

	// Episode Hospital must match specific deposits hospitals. This function will return false when this is not the case.

	var aryDep=DepHospIds.split("|");
	var aryBill=BillHospIds.split("|");

	for (var i=0;i<aryDep.length;i++) {
		for (var j=0;j<aryBill.length;j++) {
			if (aryDep[i] && aryBill[j] && aryDep[i]!=aryBill[j]) return false; 
		}
	}

	return true;
}

//called from websys.List.js when selecting/deselecting a row
//if there is an EPR window. won't be called if displayed in a new window
//
function BillTypeBuilder(row) {

	return SelBillTypes;
}

//called from websys.List.js when selecting/deselecting a row
//if there is an EPR window. won't be called if displayed in a new window
//
function BillRowIdBuilder(row) {

	return AppendSelBillRowId(row,SelBillRowID);
}

function AppendSelBillRowId(row, strBillRowId) {

	var objBillRowID = document.getElementById('BillRowIDz'+ row);
	if (objBillRowID==null) return "";

	if (strBillRowId=="")
		return objBillRowID.value;

	if (strBillRowId.indexOf(objBillRowID.value)==-1)
		strBillRowId = strBillRowId + "^" + objBillRowID.value;

	return strBillRowId;
}

function DeleteSelBillRowId(row, strBillRowId) {

	var objBillRowID = document.getElementById('BillRowIDz'+ row);
	if (objBillRowID==null) return strBillRowId;

	return DeleteFromHiddenRowIDs(strBillRowId,objBillRowID.value);
}

// called by websys.List.js
//
function ClearOnMultipleSelection(objRow,winf) {

	SelBillRowID = DeleteSelBillRowId(objRow.rowIndex, SelBillRowID);

	try {PatID = PatientIDBuilder();} catch(e) {}
	try {EpiID = EpisodeIDBuilder();} catch(e) {}

	if (winf) {
		try {winf.SetEpisodeDetails(PatID,EpiID,"","","",WLID,"","","","","","",SelBillRowID,SelBillTypes);} catch(e) {}
	}
}

// called by websys.List.js when selecting/deselecting a row
//
function SelectRowHandler(evt) {

	var eSrc=websys_getSrcElement(evt);
	var rowObj=getRow(eSrc);
	var selRow=rowObj.rowIndex;

	var objTbl = getTable(rowObj);
	var frm = getFrmFromTbl(objTbl);

	// 44252 : added this bit to handle row selection in Batch Receipting
	var objBillsAmtTot;
	var objDepositsAmtTot; 
	
	if (docBatchFind) {  // refering to frame "BR.ARPatBillFindBatch", in batch receipting;

		objBillsAmtTot = docBatchFind.getElementById("BillsAmtTot");
		objDepositsAmtTot = docBatchFind.getElementById("DepositsAmtTot");

		if (objBillsAmtTot && objDepositsAmtTot) {
			try {
				if (winBatchFind) winBatchFind.CheckRecoup(selRow);
			} catch(e) { }
		}
	}

	if (eSrc.tagName=="IMG") eSrc=websys_getParentElement(eSrc);
	var eSrcAry=eSrc.id.split("z");

	if (eSrcAry[0]=="SelectBill") {
		
		//update the global SelBillRowID depending on the status of the checkbox

		var chkbox = document.getElementById(eSrcAry[0] + "z" + selRow);
		if (chkbox.checked) {
			SelBillRowID = AppendSelBillRowId(selRow, SelBillRowID);
			//alert("AppendSelBillRowId: " + SelBillRowID);
		}
		else {
			SelBillRowID = DeleteSelBillRowId(selRow, SelBillRowID);
			//alert("DeleteSelBillRowId: " + SelBillRowID);
		}

		if (objAutoSelDeposit.value=="Y") SelectDepositsForBill(selRow);  //54669: added AutoSelDeposit flag
		
		// batch receipting
		if (winBatchFind && objBillsAmtTot && objDepositsAmtTot) {
			try {
				winBatchFind.HandleRowSelectionForBatchReceipting(selRow);  //44252: func. implemented in ARPatientBill.FindBatch
			} catch(e) { }
		}

		// batch letter
		else if (parent.frames["FRAMEARPatientBillFind"]) {

			HandleRowSelectionForBatchLetter(selRow);
		}
	}
}

function HandleRowSelectionForBatchLetter(SelRowNumber) {
	
	if ((SelRowNumber<1) || (docBillFind==null)) return;

	var tbl = document.getElementById("tARPatientBill_ListAll");
	var f = document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var col="SelectBillz";
	var selRow=0;
	var TransType="";

	var objTransType=document.getElementById("TransTypez"+SelRowNumber);
	if (objTransType) TransType = objTransType.innerText;
	
	//alert("TransType  " + TransType);

	if (TransType==t['INV'] && f.elements[col+SelRowNumber] && !f.elements[col+SelRowNumber].disabled) {

		var objBillRowIDs= docBillFind.getElementById("BillRowIDs");
		var objSelBillID = document.getElementById("BillRowIDz" + SelRowNumber);

		//alert("Bill id " + objSelBillID.value + " @ " + SelRowNumber);

		if (f.elements[col+SelRowNumber].checked) {
			for (var i=1;i<tbl.rows.length;i++) {
				objTransType=document.getElementById("TransTypez"+i);
				if (objTransType) TransType = objTransType.innerText;				
				if (TransType==t['INV'] && f.elements[col+i] && f.elements[col+i].checked && !f.elements[col+i].disabled) {
					selRow++;
				}
			}
			if (selRow==1)
				objBillRowIDs.value=objSelBillID.value;
			else
				objBillRowIDs.value += "|" + objSelBillID.value;
		}
		else {
			objBillRowIDs.value = DeleteFromHiddenRowIDs(objBillRowIDs.value,objSelBillID.value);
		}

		//alert("Bill Row Ids " + objBillRowIDs.value );
	}
}

function DeleteFromHiddenRowIDs(HiddenRowIDs,RowID) {

	if ((HiddenRowIDs=="")||(RowID=="")) return HiddenRowIDs;

	var value=HiddenRowIDs; //default value, cannot be empty string or null

	if (HiddenRowIDs.indexOf(RowID)!= -1) {
		var i=HiddenRowIDs.indexOf(RowID);

		if (i==0) { // at beginning
			value = HiddenRowIDs.substring(i + RowID.length + 1,HiddenRowIDs.length);			
		}
		else if ((i + RowID.length)==HiddenRowIDs.length) {  // at end
			value = HiddenRowIDs.substring(0,i-1);
		}
		else { // other
			value = HiddenRowIDs.substring(0,i);
			value = value + HiddenRowIDs.substring(i + RowID.length + 1,HiddenRowIDs.length);
		}
	}
	return value;
}

//log 32860	
function SelectAllRows(evt) {

	var SelectBillRow;
	var selected=true;
	var tbl=document.getElementById("tARPatientBill_ListAll");

	//alert(objSelectAll.value);

	for (var i=1; i<tbl.rows.length; i++) {
		SelectBillRow=document.getElementById("SelectBillz"+i);
		if (SelectBillRow) {
			if ((objSelectAll)&&(objSelectAll.value=="Y")) {
				SelectBillRow.checked=true;
				selected=true;
			} else {
				SelectBillRow.checked=false;
				selected=false;
			}
		}
	}
	
	// Reset for Select / Deselect [SelDeselectAll] Click.
	if (objSelectAll) {
		if (objSelectAll.value=="Y") {
			objSelectAll.value="N";
		} else {
			objSelectAll.value="Y";
		}
	}

	//44252/49774
	if (websys_getType(evt)=="click")  {
		SelectDeselectAllRows(selected, evt);
	}
	else {
		if (!PreserveUnselected()) SelectDeselectAllRows(selected, evt);
	}

	return false;
}

//49774
function PreserveUnselected() {
	if (docBatchFind==null) return false;

	var unselected=false;
	var objSelect;

	var objUnselDepositRowIDs= docBatchFind.getElementById("UnselDepositRowIDs");
	var objUnselBillRowIDs   = docBatchFind.getElementById("UnselBillRowIDs");

	if (objUnselBillRowIDs.value!=null && objUnselBillRowIDs.value!="") {
		var NextUnselBillRowID;
		var i=0;
		//alert("bill*** " + objUnselBillRowIDs.value);
		while (mPiece(objUnselBillRowIDs.value,"|",i) && mPiece(objUnselBillRowIDs.value,"|",i)!="") {
			NextUnselBillRowID=mPiece(objUnselBillRowIDs.value,"|",i);
			i++;
			for (var j=1; j<tbl.rows.length; j++) {
				var objBillRowID=document.getElementById("BillRowIDz"+j);
				objSelect=document.getElementById("SelectBillz"+j);
				if (NextUnselBillRowID==objBillRowID.value) {
					if (objSelect) {
						objSelect.checked=false;
						unselected=true;
					}
				}
			}
		}
	}
	if (objUnselDepositRowIDs.value!=null && objUnselDepositRowIDs.value!="") {
		var NextUnselDepositRowID;
		var i=0;
		//alert("dep*** " + objUnselDepositRowIDs.value);
		while (mPiece(objUnselDepositRowIDs.value,"^",i) && mPiece(objUnselDepositRowIDs.value,"^",i)!="") {
			NextUnselDepositRowID=mPiece(objUnselDepositRowIDs.value,"^",i);
			i++;
			for (var j=1; j<tbl.rows.length; j++) {
				var objDepRowID=document.getElementById("RecAllocIDz"+j);
				objSelect=document.getElementById("SelectBillz"+j);
				if (NextUnselDepositRowID==objDepRowID.value) {
					if (objSelect) {
						objSelect.checked=false;
						unselected=true;
					}
				}
			}
		}
	}
	return unselected;
}

// 44252
function SelectDeselectAllRows(isChecked, evt) {

	if (docBatchFind==null && docBillFind==null) return false;

	var objBillRowIDs;
	var objDepositRowIDs;

	if (docBatchFind) { // batch receipting
		objDepositRowIDs = docBatchFind.getElementById("DepositRowIDs");
		objBillRowIDs    = docBatchFind.getElementById("BillRowIDs");
	}
	else if (docBillFind) { // batch letter
		objBillRowIDs=docBillFind.getElementById("BillRowIDs");
	}
	
	// evaluate if it's initiated from BatchReceipting or not
	if (websys_getType(evt)=="click") {

		if (isChecked==false) {

			if (docBatchFind) {
				var objUnselDepositRowIDs=docBatchFind.getElementById("UnselDepositRowIDs");
				var objUnselBillRowIDs=docBatchFind.getElementById("UnselBillRowIDs");

				if (objDepositRowIDs) {
					if (objDepositRowIDs.value!="")
						objUnselDepositRowIDs.value=objDepositRowIDs.value;

					objDepositRowIDs.value="";
				}
				if (objBillRowIDs) {
					if (objBillRowIDs.value!="")
						objUnselBillRowIDs.value=objBillRowIDs.value;
				
					objBillRowIDs.value="";
				}
			}
		} else {
			var f = document.getElementById("fARPatientBill_ListAll");
			var aryfound = CheckedCheckBoxesOrSelectedRow(f, tbl, "SelectBillz");

			var BillRowIDs="";
			var DepositIDs="";
			var BillType="";
			var j=0;

			for (var i=0; i<aryfound.length; i++)
			{
				j = aryfound[i];
				BillType = f.elements["BillTypez"+j].value;

				var transTypeCol = document.getElementById("TransTypez"+j);
				if (transTypeCol)
					var val = transTypeCol.innerText;

				if (BillType=="D") {
					if (DepositIDs =="")
						DepositIDs = f.elements["RecAllocIDz"+j].value;
					else
						DepositIDs = DepositIDs + "^" + f.elements["ReceiptIDz"+j].value;

				} else if (BillType=="I") {
					if (BillRowIDs =="")
						BillRowIDs = f.elements["BillRowIDz"+j].value;
					else
						BillRowIDs = BillRowIDs + "|" + f.elements["BillRowIDz"+j].value;
				}
			}
			if (objDepositRowIDs) objDepositRowIDs.value=DepositIDs;
			if (objBillRowIDs) objBillRowIDs.value=BillRowIDs;
		} // end if

		if (docBatchFind) {  // only for batch receipting 
			//alert("BillRowIDs " + objBillRowIDs.value);

			objSelectAll.onclick=objSelectAll.onchange;
			objSelectAll.click();
		}
	}

	try {
		if (winBatchFind) winBatchFind.SetRequiredAmount();
	} catch(e) { }

	return false;
}

function SelectDepositsForBill(RowNumber) {

	// 32197: When checking/unchecking an invoice row, if an episode specific
	// deposit exists from the same payor (including "Patient"), this function will automatically 
	// check/uncheck that deposit row. No code will be triggered when the row is highlighted. 
	// No checking/unchecking will occur when the deposit rows are checked/unchecked.

	if (RowNumber=="") return false;

	var objRowTransType=document.getElementById("TransTypez" +RowNumber);
	var objRowBillRowChecked=document.getElementById("SelectBillz" +RowNumber);
	var objRowEpisodeID=document.getElementById("EpisodeIDz" +RowNumber);
	var objRowPayorID=document.getElementById("PayorIDz" +RowNumber);
	var objRowBillType=document.getElementById("BillTypez" +RowNumber);

	var TransType="";
	var BillRowChecked="";
	var EpisodeID="";
	var PayorID="";
	var BillType="";

	if (objRowTransType) TransType=objRowTransType.innerText;
	if (objRowBillRowChecked) BillRowChecked=objRowBillRowChecked.checked;
	if (objRowEpisodeID) EpisodeID=objRowEpisodeID.value;
	if (objRowPayorID) PayorID=objRowPayorID.value;
	if (objRowBillType) BillType=objRowBillType.value;

	if (TransType==t['INV']) {

		var tbl=document.getElementById("tARPatientBill_ListAll");

		for (var i=1; i<tbl.rows.length; i++) {

			var TransTypeRow="";
			var EpisodeIDRow="";
			var PayorIDRow="";

			var objTransTypeRow=document.getElementById("TransTypez"+i);
			var objEpisodeIDRow=document.getElementById("EpisodeIDz"+i);
			var objPayorIDRow=document.getElementById("PayorIDz"+i);

			if (objTransTypeRow) TransTypeRow=objTransTypeRow.innerText;
			if (objEpisodeIDRow) EpisodeIDRow=objEpisodeIDRow.value;
			if (objPayorIDRow) PayorIDRow=objPayorIDRow.value;
			
			// BillType=="P" for Patient Bills.
			if ((TransTypeRow==t['DEP'])&&(EpisodeID==EpisodeIDRow)) {
				if ((PayorID==PayorIDRow)||((BillType=="P")&&(PayorIDRow==""))) {
					var SelectBillRow=document.getElementById("SelectBillz"+i);
					if (SelectBillRow) SelectBillRow.checked=BillRowChecked;
				}
			}
		}
	}
}

function RefreshListTotals(){

	var objPatID=document.getElementById("PatientID")
	var CONTEXT=session['CONTEXT'];
	var objPageType=document.getElementById("PageType")
	var objAction=document.getElementById("Action")
	var objTWKFL=document.getElementById('TWKFL');
	var objTWKFLI=document.getElementById('TWKFLI');
	
	var PageType="";
	var Action="";
	var TWKFL="";
	var TWKFLI="";
	var PatID="";
	
	if (objPatID) PatID=objPatID.value;
	if (objPageType) PageType=objPageType.value;
	if (objAction) Action=objAction.value;
	if (objTWKFL) TWKFL=objTWKFL.value;
	if (objTWKFLI) TWKFLI=objTWKFLI.value;

	//56355 - added hospital
	var Hospital="";
	if (objHosp) {
		if (objHosp.tagName=="LABEL") {
			Hospital=objHosp.innerText;
		} else {
			Hospital=objHosp.value;
		}
	}
	
	//Log 60884 - 13/10/2006
	var AdmDateFrom="";
	if (objAdmDateFrom) { 
		if (objAdmDateFrom.tagName=="LABEL") AdmDateFrom=objAdmDateFrom.innerText;
		else AdmDateFrom=objAdmDateFrom.value;
	}
	var AdmDateTo="";
	if (objAdmDateTo) { 
		if (objAdmDateTo.tagName=="LABEL") AdmDateTo=objAdmDateTo.innerText;
		else AdmDateTo=objAdmDateTo.value;
	}
    //End Log 60884
	
	//Log 60884 - 13/10/2006 - added AdmDateFrom and AdmDateTo to the URL
	var url="websys.default.csp?WEBSYS.TCOMPONENT=ARPatientBill.ListTotals&PatientID="+PatID;
	url += "&TWKFL="+TWKFL+"&TWKFLI="+TWKFLI+"&CONTEXT="+CONTEXT+"&Action="+Action+"&PageType="+PageType+"&Hospital="+Hospital+"&AdmDateFrom="+AdmDateFrom+"&AdmDateTo="+AdmDateTo;

	websys_createWindow(url,'ListTotals');
}

//44252
function SelectAll_changehandler(encmeth) {
	
	if (docBatchFind==null) return;

	var objDepositRowIDs = docBatchFind.getElementById("DepositRowIDs");
	var objBillRowIDs = docBatchFind.getElementById("BillRowIDs");
	try {
		// calling method web.ARPatientBill.GetBatchDepositAndBillTotal()

		var ReturnVal= cspRunServerMethod(encmeth,objDepositRowIDs.value,objBillRowIDs.value);
	
		var objDepositsAmtTot=docBatchFind.getElementById("DepositsAmtTot");
		if (objDepositsAmtTot) objDepositsAmtTot.value = mPiece(ReturnVal,"^",0);

		var objBillsAmtTot=docBatchFind.getElementById("BillsAmtTot");
		if (objBillsAmtTot) objBillsAmtTot.value = mPiece(ReturnVal,"^",1);

		var objBillsSelNo=docBatchFind.getElementById("BillsSelNo");
		if (objBillsSelNo) objBillsSelNo.value = mPiece(ReturnVal,"^",2);
	} catch(e) { }
}

//44252
function HighlightNewlyAddedBill() {
	var objNewBill = document.getElementById("NewlyAddedBill");

	//Log 64077 - 02.07.2007 - if from batch receiting and also if BillRowIds has no values, it probably means its useing a batch. So go trhough the list and assign the rowids to BillRowIDs field.
	//if (objNewBill.value==null || objNewBill.value=="") return;
	if (objNewBill.value==null || objNewBill.value=="") {
		if (docBatchFind) {
			var objBillRowIDs = docBatchFind.getElementById("BillRowIDs");
			if ((objBillRowIDs)&&(objBillRowIDs.value=="")) {
			
				for (var j=1; j<tbl.rows.length; j++) {
					var chked=document.getElementById("SelectBillz"+j);
					if ((chked)&&(chked.checked)) {
						var objBillRowID=document.getElementById("BillRowIDz"+j);
						if ((objBillRowID)&&(objBillRowID.value!="")) {
							if (objBillRowIDs.value=="") objBillRowIDs.value=objBillRowID.value;
							else objBillRowIDs.value=objBillRowIDs.value+"|"+objBillRowID.value;
						}	
					}
				}
			}
		}	
	}
	//End Log 64077 
	
	var NewBill = objNewBill.value;
	//alert("new bill " + NewBill);
	var i=0;
	var NextNewBillRowID;
	//could possibly add > 1 bill from search by patient workflow
	while (mPiece(NewBill,"|",i) && mPiece(NewBill,"|",i)!="") {
		NextNewBillRowID = mPiece(NewBill,"|",i);
		i++;
		for (var j=1; j<tbl.rows.length; j++) {
			var objBillRowID=document.getElementById("BillRowIDz"+j);
			if (NextNewBillRowID==objBillRowID.value) {
				HighlightRow_OnLoad("BillRowIDz"+j); // method in websys.List.js
				break;
			}
		}
	}
}

function HighlightNewlyAddedDeposit() {
	var objNewDep = document.getElementById("NewlyAddedDeposit");

	if (objNewDep.value==null || objNewDep.value=="") return;
	var NewDep = objNewDep.value;

	var tbl=document.getElementById("tARPatientBill_ListAll");
	for (var i=1; i<tbl.rows.length; i++) {
		var objRecID=document.getElementById("RecAllocIDz"+i);
		if (NewDep==objRecID.value) {
			HighlightRow_OnLoad("RecAllocIDz"+i); // method in websys.List.js
			break;
		}
	}
}

//used in batch receipting screen
//
function AssignRemoveClickHandler() {
	var tbl=document.getElementById("tARPatientBill_ListAll");

	for (var i=1; i<tbl.rows.length; i++) {
		var obj=document.getElementById("RemoveRowz"+i)
		if (docBatchFind!=null || winBatchFind!=null) {
			if (obj) obj.onclick = RemoveBillBatchReceipting;
		}
		//else if (docBillFind!=null) {
		//	obj.onclick = RemoveBillBatchLetter;
		//}
		else {
			if (obj) {
				obj.disabled=true;
				obj.onclick=LinkDisable;
			}
		}
	}
}

function RemoveBillBatchReceipting(evt) {

	if (docBatchFind==null || winBatchFind==null) return false;

	if (evtTimer) {
		setTimeout("RemoveBillBatchReceipting()",200);
	} else {

		var eSrc=websys_getSrcElement(evt);
		var rowObj=getRow(eSrc);
		var selRow=rowObj.rowIndex;

		var TransType="";
		var objTransType=document.getElementById("TransTypez"+selRow);
		if (objTransType) TransType = objTransType.innerText;
		
		//get hidden fields from ARPatientBill.FindBatch
		var objBillRowIDs        = docBatchFind.getElementById("BillRowIDs");
		var objDepositRowIDs     = docBatchFind.getElementById("DepositRowIDs");
		var objReceiptAmt        = docBatchFind.getElementById("ReceiptAmt");
		var objAction            = docBatchFind.getElementById("Action");
		var objPayor             = docBatchFind.getElementById("Payor");
		var objGroupType         = docBatchFind.getElementById("GroupType");
		var objUnselBillRowIDs   = docBatchFind.getElementById("UnselBillRowIDs");
		var objUnselDepositRowIDs= docBatchFind.getElementById("UnselDepositRowIDs");

		var selRowId="";
		var BillRowIDs= objBillRowIDs.value;
		var DepositRowIDs= objDepositRowIDs.value;
		var UnselBillRowIDs= objUnselBillRowIDs.value;
		var UnselDepositRowIDs= objUnselDepositRowIDs.value;

		if ((TransType==t['INV'])||(TransType==t['CREF'])||(TransType==t['REF'])) {
			var objBillRowId=document.getElementById("BillRowIDz"+selRow);
			selRowId=objBillRowId.value;

			if (objBillRowIDs.value!="") {
				BillRowIDs=DeleteFromHiddenRowIDs(objBillRowIDs.value,selRowId);
				objBillRowIDs.value=BillRowIDs;
				//alert("Removing Selected Bills " + BillRowIDs);
			}
			else {
				UnselBillRowIDs=DeleteFromHiddenRowIDs(UnselBillRowIDs,selRowId);
				objUnselBillRowIDs.value=UnselBillRowIDs;
				//alert("Removing Un-selected Bills " + UnselBillRowIDs);
			}

			//alert("Sel Row " + selRow + " Bill to remove " + selRowId + " Current BillRowIDs " + BillRowIDs);
			
		} else {
			var objRecRowId=document.getElementById("RecAllocIDz"+selRow);
			selRowId=objRecRowId.value;

			//alert("Sel Row " + selRow + " Deposit to remove " + selRowId + " Current DepositRowIDs " + DepositRowIDs);

			if (DepositRowIDs!="") {
				DepositRowIDs=DeleteFromHiddenRowIDs(objDepositRowIDs.value,selRowId);
				objDepositRowIDs.value=DepositRowIDs;
				//alert("Removing Selected Deposit " + DepositRowIDs);
			}
			else {
				UnselDepositRowIDs=DeleteFromHiddenRowIDs(UnselDepositRowIDs,selRowId);
				objDepositRowIDs.value=UnselDepositRowIDs;
				//alert("Removing Unselected Deposit " + UnselDepositRowIDs);
			}			

		}

		var ReceiptAmt="";
		var Action="";
		var Payor="";

		if (objReceiptAmt) ReceiptAmt=objReceiptAmt.value;
	      if (objAction) Action=objAction.value;
		if (objGroupType) GroupType=objGroupType.value;
 		if (objPayor) Payor=objPayor.value;
		
		var url="arpatientbill.batchfind.csp?PageType=Batch&BillRowIDs="+BillRowIDs+"&DepositRowIDs="+DepositRowIDs+
		"&DontClearPayDet=1&ReceiptAmt="+ReceiptAmt+"&Payor="+websys_escape(Payor)+"&CONTEXT="+session['CONTEXT']+
		"&Action="+Action+"&GroupType="+GroupType+"&SelectAll=Y"+
		"&UnselBillRowIDs="+UnselBillRowIDs+"&UnselDepositRowIDs="+UnselDepositRowIDs;

		//alert(url);
		websys_createWindow(url,"TRAK_main");
	}
}

 
/** 
   This function is called upon when the rolldown tab for
   "Allocate Discretionary Discount" is selected.
   
   The function validates that there is ONLY 1 invoice selected and
   proceeds to open a new window passing in the arguments for the
   discounting component.
 */  

function discretionaryDiscountValidator(e) {

	var tbl=document.getElementById("tARPatientBill_ListAll");
	if (!tbl) tbl=getTableName(window.event.srcElement);
	var f = document.getElementById("f" + tbl.id.substring(1,tbl.id.length));

	var aryCheckedRow = GetCheckedRows(f, tbl, "SelectBillz");
	
	if (aryCheckedRow.length!=1) {
		alert(t["MUSTSELECT_INV_DISC"]);
		return false;
	}

	var row = aryCheckedRow[0]; //there's only one selected row		
	var type=document.getElementById("hidTransTypez"+row).value;
	
	if (type=="INV") { // invoices

		var OSAmt=document.getElementById("HiddenOutsAmtz"+row).value;
		if (OSAmt==0) {
			//only outstanding invoices can be allocated discounts
			alert(t["INV_ONLY_DISC"]);
			return false;
		}
		var EpisodeOnHold=document.getElementById("EpisodeOnHoldz"+row).value;
		if (EpisodeOnHold=="Y") {
			alert(t['NO_ACTION_ALLOWED_FOR_ONHOLD_EPISODE']);
			return false;
		}
	}
	else {
		//only invoices can be selected
		alert(t["INV_ONLY_DISC"]);
		return false;
	}

	var BillRowID = f.elements["BillRowIDz"+row].value;
	var PatientID = f.elements["PatientIDz"+row].value;

	//Log  62387 - 01.02.2007 - "FromMenu" indicates the csp is getting called from the Menu "Allocate Discretionary Discount"
	var url="arpatbill.discalloc.csp?PatientID="+PatientID+"&BillRowID="+BillRowID+"&PatientBanner=1&CONTEXT="+session['CONTEXT']+"&FromMenu=1";

	websys_createWindow(url,'AllocationDiscretionaryDiscount','height=400,width=400,top=150,left=150,resizable=1');

	//do the following, so listTotal will be refreshed when this reloads.
	//see BodyLoadHandler to see when it's reloaded

	var obj=top.frames["TRAK_main"].frames["ListTotals"];
	if (obj) {
		var formtot=obj.document.forms['fARPatientBill_ListTotals'];
		if (formtot) formtot.elements["RefreshCSP"].value=1;
	}

	return true;
}

function PrintTestReload() {
	window.treload('websys.csp');
}

// Log 59287 - 04.07.2006 - function to disable Payor Link of line is not Episode Specific
function DisablePayor() {
	var tbl=document.getElementById("tARPatientBill_ListAll");
	for (var i=1; i<tbl.rows.length; i++) {
		var EpisodeID=document.getElementById("EpisodeIDz"+i);
		if ((EpisodeID) && (EpisodeID.value=="")) {
			var PayorCol=document.getElementById("INSTDescz"+i);
			if (PayorCol) {PayorCol.disabled=true; PayorCol.onclick=LinkDisable;}
		}
	}
}

//Log 66151 - 30.01.2008
function CheckBillPrinted(j,MsgBillsNotPrinted) {
				var MsgSingleBillNotPrinted="";
				var objEpNum=document.getElementById("PAADMADMNoz"+j);
				var objPayorText=document.getElementById("INSTDescz"+j);
				var objInvTot=document.getElementById("InvTotalz"+j);
				var objOutTot=document.getElementById("OutstandAmtz"+j);	//Log 65879 - 20.12.2007
				var EpisodeNumber="";
				var PayorText="";
				var InvoiceTotal="";
				var OutsTotal="";	//Log 65879 - 20.12.2007
	
				if (objEpNum) {
					EpisodeNumber=objEpNum.innerText;
					if (EpisodeNumber!="")
						MsgSingleBillNotPrinted+=t['EP_NUM']+" "+EpisodeNumber+", ";
				}

				if (objPayorText) {
					PayorText=objPayorText.innerText;
					if (PayorText!="")
						MsgSingleBillNotPrinted+=t['PAYOR']+" "+PayorText+", ";
				}

				if (objInvTot) {
					InvoiceTotal=objInvTot.innerText;
					OutsTotal=objOutTot.innerText;	//Log 65879 - 20.12.2007
					if (PayorText!="")
						MsgSingleBillNotPrinted+=t['INV_TOT']+" "+OutsTotal;	//Log 65879 - 20.12.2007
				}
				
				
				if (MsgSingleBillNotPrinted!="")
					MsgBillsNotPrinted+=MsgSingleBillNotPrinted+"\n";
				return 	MsgBillsNotPrinted;
}

/* NOT IN USE

// RQG 12.03.03 L32825 - Disable 'Compensible Detail' if BillType is 'D'
function ARPatBillListAll_DisableCompDetails(e) {
	
	var tbl=document.getElementById("tARPatientBill_ListAll");
	var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	if ((f)&&(tbl)) {

		var aryID=new Array(); var aryStat=new Array(); var n=0;
		var billtype="";
		for (var i=1;i<tbl.rows.length;i++) {
			billtype = f.elements['BillTypez'+i].value;
			if (billtype=='D') {

				var objCD=document.getElementById("CompoDetailsz"+i);
				if (objCD) {
					//alert("detail="+objCD.name);
					objCD.disabled=true;
					objCD.onclick=LinkDisable;
				}
			}
		}
	}
}

*/

document.body.onload=BodyLoadHandler;


