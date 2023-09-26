// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var objBillType=document.getElementById("BillType");
var objWOTransferPayorBill=document.getElementById("WOTransferPayorBill");
var objWOTransferPatBill=document.getElementById("WOTransferPatBill");
var objTransferPayor=document.getElementById("TransferPayor");
var objTransferPayorLUIcon=document.getElementById("ld574iTransferPayor");
var objWOAmount=document.getElementById("WOAmount");
var objPaymAllocOK=document.getElementById("PaymAllocOK");
var objAdjAlloc=document.getElementById("AdjAlloc");
var objPARREF=document.getElementById("PARREF");
var objPatId=document.getElementById("PatientID");
var objAdjDate=document.getElementById("WODate");


function EditBodyLoadHandler() {

	BuildListFromDesc();

	if (objWOAmount) objWOAmount.onchange=WOAmountChangeHandler;

	if (objAdjDate) {
		//objAdjDate.onchange = AdjustmentDateChangeHandler; //44185 Peterc 03/05/04 changed the event from onchange to onblur
		objAdjDate.onblur = AdjustmentDateChangeHandler;
	}
	
	// SA: Enable check WOTransferPatBill when dealing with Payor Bills only.
	if ((objBillType)&&(objBillType.value=="I")) {
		// RQG 29.04.03 L32827: Need to disable the 'Transfer To Payor Bill' checkbox 
		if (objWOTransferPayorBill) {
			objWOTransferPayorBill.checked = false;
			//Log 45984 enabled the checkbox to transfer to payor when the bill type is invoice
			//objWOTransferPayorBill.disabled = true;
			objWOTransferPayorBill.disabled = false;
		}		
	} else {

		if (objWOTransferPatBill) {
			objWOTransferPatBill.checked = false;
			objWOTransferPatBill.disabled = true;
		}
	}

	if (objWOTransferPayorBill) {
		objWOTransferPayorBill.onclick=TransPayorClickHandler;
		TransPayorClickHandler();
	}

	// SA 30.1.03 - log 32193: Refund Invoices have WO's added automatically
	// with comment "CINV" (Cancelled Invoice). Need to translate this here.
	var objWOComments=document.getElementById("WOComments")   
	if ((objWOComments)&&(objWOComments.value=="CINV")) {
		objWOComments.value=t['CINV'];
	}	


	var uobj=document.getElementById("update1")
	if (uobj) uobj.onclick=UpdateClickHandler;

	// RQG 12.05.03 L33282: Delete a plan from the list if clicked
	var objDP=document.getElementById("DeletePlan");
	if(objDP) objDP.onclick=DeletePlanClickHandler;

	var transType  = document.getElementById("TransType");
	if (transType&& transType.value != 'INV') {
		FormDisable();
	}

	if (objAdjAlloc) {
		// SA 4.9.03: Adjustment allocation link implemented for 36922
		objAdjAlloc.onclick = AdjAllocHandler;
	}
}

function UpdateClickHandler() {

	BuildIDsfromList();

	if (AutoAdjAllocRequired()) {
		// SA 5.9.03 - log 36922: QH will require the adjustment allocation screen to appear,
		// if item based adjustment allocations have not been created.
		AdjAllocHandler();
		return true;
	} else {

		//AJI 40604 27.02.04 - wasn't refreshing the ListTotal
		if (window.opener && window.opener.parent.frames[1]){
			var win=window.opener.parent.frames[1];
			if (win) {
				var formtot=win.document.forms['fARPatientBill_ListTotals'];
				if (formtot) {
					formtot.elements["RefreshCSP"].value="1";
				}
			}
		}
		update1_click();
		//Log 64744 - 30.08.2007
		refreshAndClose();	
	}
}

//Log 64744 - 30.08.2007 - refresh ARPatientBill.FindBatch when allocation is updated in Batch Receipting workflow
function refreshAndClose() {
	if (window.opener) {
		if ((window.opener.name!="eprmenu")&&(window.opener.name!="TRAK_menu")) {
			window.opener.treload('websys.csp');
			window.opener.close();
		}
		if (window.opener.parent) {
			if (window.opener.parent.name=="TRAK_main") {
				if (window.opener.parent.frames["BR.ARPatBillFindBatch"]) {
					var frm=window.opener.parent.frames["BR.ARPatBillFindBatch"];
					if (frm) {
						var winBatchFind = frm.window;
						winBatchFind.treload('websys.csp');
						winBatchFind.close();
					}	
				}	
			}	
		}		
	}
}

function WOAmountChangeHandler() {

	WOAmount_changehandler();

	// SA 36922: Reset payment allocation flag if amount is adjusted after payment allocation is made.
	if ((objPaymAllocOK)&&(objPaymAllocOK.value=="Y")) objPaymAllocOK.value="";
}

//44185
function AdjustmentDateChangeHandler(e) {
	WODate_changehandler(e);
}

function LinkDisable() {
	return false;
}

function AdjAllocHandler() {

	var BillRowID=""; var GroupType="I"; var PayAmt=""
	var PatientID="";

	if ((objAdjAlloc)&&(objAdjAlloc.disabled)) return false;

	if (objWOAmount) PayAmt=MedtrakCurrToJSMath(objWOAmount.value);
	if (objPARREF) BillRowID=objPARREF.value;
	if (objPatId) PatientID=objPatId.value;

	var url="websys.default.csp?WEBSYS.TCOMPONENT=ARReceipts.ListPayAlloc&BillRowID="+BillRowID;
	url += "&PayAmt="+PayAmt+"&Mode=Adjustment&CONTEXT=S2";
	url += "&PatientID="+ PatientID + "&PatientBanner=1";

	//alert(url);
        //Log 59598 - BC - 29-06-2006 : remove statusbar variable (status=) to display the status bar.
	websys_createWindow(url,'child3','width=750,height=500,top=50,left=50,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes');

}

function AutoAdjAllocRequired() {
	//dummy function
	//function in custom scripts - QH - Log 36922
	return false;
}

function FormDisable() {
	var uobj =document.getElementById("update1")
	var objDP=document.getElementById("DeletePlan");
	var objAdjAlloc=document.getElementById("AdjAlloc");

	var frm = document.forms['fARPatBillWriteOff_Edit'];
	for (i=0; i<frm.elements.length; i++) {
		var el = frm.elements[i];
		var icn= "ld574i" + el.name 
		//var el = frm.elements[arrElem[i]];
		if (el) {
			el.disabled=true;
			//alert(icn);
			icon=document.getElementById(icn)
			if (icon) icon.style.visibility = "hidden";
		}
	}
	if (uobj) {
		uobj.disabled=true;
		uobj.onclick=LinkDisable;
	}

	if (objDP) {
		objDP.disabled=true;
		objDP.onclick=LinkDisable;
	}

	if (objAdjAlloc) {
		objAdjAlloc.disabled=true;
		objAdjAlloc.onclick=LinkDisable;
	}
}

function PlanLookUpSelect(str) {
	// RQG 12.05.03 L33282
	var lu = str.split("^");
	var obj=document.getElementById('Plan');
	if (obj) {
		if (lu[0]) obj.value=lu[0];
		if ((!lu[1])||(lu[1]=="")) return false;
	}
	var objList=document.getElementById('PlanList');
	if (objList) {
		var txtField='Plan';
		var lstField='PlanList';
		LookupSelectforList(txtField,lstField,str);
	}
}

function DeletePlanClickHandler() {
	//Delete items from Entered listbox when "Delete" button is clicked.
	var obj=document.getElementById("PlanList");
	if (obj) {
		RemoveFromList(obj);
		UpdatePlans();
	}
	return false;
}

function UpdatePlans() {
	//alert("update");
	var arrItems = new Array();
	var lst = document.getElementById("PlanList");
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			arrItems[j] = lst.options[j].value;
		}
		var el = document.getElementById("PlanCodeStr");
		if (el) el.value = arrItems.join(String.fromCharCode(1));
	}
	//alert("list="+lst.value);
}

function LookupSelectforList(tfield,lfield,txt) {
	//Add an item to List when an item is selected from
	//the Lookup, then clears the text field.
	var adata=txt.split("^");
	var obj=document.getElementById(lfield);  //Listbox
	if (obj) {
		//Need to check if text already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == String.fromCharCode(2)+adata[1]) {
				alert( adata[0] + " has already been selected");
				var obj=document.getElementById(tfield);  //Textbox with lookup 
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
				alert( adata[0] + " has already been selected");
				var obj=document.getElementById(tfield);
				if (obj) obj.value="";
				return;
			}
		}
	}
	AddItemToList(obj,adata[1],adata[0]);
	var obj=document.getElementById(tfield);
	if (obj) obj.value="";
	UpdatePlans();
}


function AddItemToList(list,id,desc) {
	//Add an item to a listbox
	//code=String.fromCharCode(2)+code
	//alert("list="+list.id+"  id="+id+"  desc="+desc);
	list.options[list.options.length] = new Option(desc,id);
}

function RemoveFromList(obj) {
	for (var i=(obj.length-1); i>=0; i--) {
		if (obj.options[i].selected)
			obj.options[i]=null;
	}
}

function BuildIDsfromList(){
	//Plan
	var objList=document.getElementById('PlanList');
	if (objList) {
		var IDfield='PlanCodeStr';
		var lstfield='PlanList';
		UpdatewithIDs(lstfield,IDfield);
	}
}

function UpdatewithIDs(lstfield,IDfield) {
	//alert("Inside UpdatewithIDs");
	var arrItems = new Array();
	var lst = document.getElementById(lstfield);
	var SlectedIDs="";
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
		//for (var j=1; j<lst.options.length; j++) {
			if (lst.options[j].value!="") SlectedIDs=SlectedIDs + lst.options[j].value + "|";
		}
		SlectedIDs=SlectedIDs.substring(0,(SlectedIDs.length-1));
		var el = document.getElementById(IDfield);
		if (el) el.value = SlectedIDs;
		//alert("SlectedIDs="+SlectedIDs);
	}
}

function BuildListFromDesc() {
	//alert("Inside BuildListFromDesc");
	var plan="";
	var lst = document.getElementById('PlanList');
	var objPlanDesc = document.getElementById("WOAuxInsType");
	var objPlanID = document.getElementById("WOAuxInsTypeID");

	if (objPlanDesc) {
		if (objPlanDesc.value!="") {
			 plan=objPlanDesc.value;
		} else {
			return false;
		}
	}

	//alert("plan="+plan);
	if (plan.indexOf(",") != -1) {
		var arrItems = objPlanDesc.value.split(",");
		//alert("here1");

		var arrIDItems = objPlanID.value.split("|");
		//alert("Plandesc=" + objPlanDesc.value + " arrItems.length=" + arrItems.length);
		if ((objPlanDesc)&&(objPlanDesc.value!="")) {
			for (var j=0; j<arrItems.length; j++) {
				//lst.options[j]=arrItems[j];
				lst.options[j]=new Option(arrItems[j],arrIDItems[j]);
				//lst.options[j].value=arrItems[j];
			}
		}
	} else {
		//alert("plan="+plan+"  id="+objPlanID.value);
		//lst.options[0].value=plan;
		lst.options[0]=new Option(plan,objPlanID.value);
	}
}

function TransPayorClickHandler() {
	//alert("TransPayorClickHandler");
	if ((objWOTransferPayorBill)&&(objWOTransferPayorBill.checked)) {
		if (objTransferPayor) {
			EnableMandatoryField("TransferPayor");
			if (objTransferPayorLUIcon) objTransferPayorLUIcon.style.visibility = "visible";
			if (objWOTransferPatBill) {objWOTransferPatBill.disabled=true;objWOTransferPatBill.checked=false;}
		}
	} else {
		if (objTransferPayor) {
			DisableField("TransferPayor");
			if (objTransferPayorLUIcon) objTransferPayorLUIcon.style.visibility = "hidden";
			if (objWOTransferPatBill) {objWOTransferPatBill.disabled=false;}
		}
	}
}

function EnableMandatoryField(fldName) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if (fld) {
		fld.disabled = false;
		fld.className = "";
		if (lbl) lbl = lbl.className = "clsRequired";
	}
}

function EnableNonMandatoryField(fldName) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if (fld) {
		//alert("fld")
		fld.disabled = false;
		fld.className = "";
		if (lbl) lbl = lbl.className = "";
	}
}

function DisableField(fldName) {
	//alert("Disabling fldName="+fldName);
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if ((fld)&&(fld.tagName=="INPUT")) {
		//alert("ok Disabling fldName="+fldName);
		fld.value = "";
		fld.disabled = true;
		fld.className = "disabledField";
		if (lbl) lbl = lbl.className = "";
	}
}

document.body.onload=EditBodyLoadHandler;
