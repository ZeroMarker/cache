// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var alltestsconval="";
var alltestscontxt="";

function LookUpProfileName(val) {
	ary=val.split("^");
	f.ID.value=ary[1];
	completeForm(ary[3].split("|"),ary[4]);
}
function LookUpCategory(val) {
	f.Category.value="";
	// Log 59477 YC - checks if CategorySelected is on the page
	if(f.CategorySelected) TransferToList(f.CategorySelected,val);
}
function LookUpOrderItem(val) {
	f.OrderItem.value="";
	// Log 59477 YC - checks if OrderItemSelected is on the page
	if(f.OrderItemSelected) TransferToList(f.OrderItemSelected,val)
}

// Log 41352 - AI - 29-01-2004 : Add new Subcategory LookUp. Also store on selsubcattxt, selsubcatval, and selsubcatcode variables.
function LookUpSubcategory(val) {
	f.Subcategory.value="";
	var ary=val.split("^");
	// check to make sure this selected item isn't already in the list, before adding it to selsubcat... variables.
	var obj=f.SubcategorySelected;
	// Log 59477 YC - check if obj is there first!
	if (obj) {
		var found=0;
		for (var i=0;i<obj.length;i++) {if (obj.options[i].value==ary[1]) found=1;}
		if (found==0) {
			if (selsubcattxt!="") selsubcattxt=selsubcattxt + "," + ary[0];
			if (selsubcattxt=="") selsubcattxt=ary[0];
			if (selsubcatval!="") selsubcatval=selsubcatval + "," + ary[1];
			if (selsubcatval=="") selsubcatval=ary[1];
			if (selsubcatcode!="") selsubcatcode=selsubcatcode + "," + ary[2];
			if (selsubcatcode=="") selsubcatcode=ary[2];
			// Now finally add it to the SubcategorySelected Listbox on the form.
			TransferToList(obj,val);
		}
	}
}
// end Log 41352
function LookUpTransfusionStatus(val) {
	ovals=val.split("^");
	ovals[1]=loopArrayForMatches(allstattxt,allstatval,ovals[0].split("^"));
	f.TransfusionStatus.value="";
	// Log 59477 YC - checks if StatusSelected is on the page
	if(f.StatusSelected) TransferToList(f.StatusSelected,ovals.join("^"))
}
function LookUpStatus(val) {
	ovals=val.split("^");
	ovals[1]=loopArrayForMatches(allstattxt,allstatval,ovals[0].split("^"));
	f.Status.value="";
	// Log 59477 YC - checks if StatusSelected is on the page
	if(f.StatusSelected) TransferToList(f.StatusSelected,ovals.join("^"))
}
// Log 60604 - PJC - Result Status added to Result and Tabular Result Profiles
function LookUpResultStatus(val) {
	//selstatustxt+"*"+selstatusval+"*"+selstatuscode
	ovals=val.split("^");
	ovals[1]=loopArrayForMatches(allresstattxt,allresstatval,ovals[0].split("^"));
	f.ResultStatus.value="";
 	if(f.ResultStatusSelected) TransferToList(f.ResultStatusSelected,ovals.join("^"))
}
function LookUpHospital(val) {
	ovals=val.split("^");
	ovals[1]=loopArrayForMatches(allhosptxt,allhospval,ovals[0].split("^"));
	f.Hospital.value="";
	// Log 59477 YC - checks if HospitalSelected is on the page
	if(f.HospitalSelected) TransferToList(f.HospitalSelected,ovals.join("^"))
}
// Log 55627 YC - Changing hospital lookups to location lookups
function LookUpLocation(val) {
	ovals=val.split("^");
	ovals[1]=loopArrayForMatches(allloctxt,alllocval,ovals[0].split("^"));
	f.Location.value="";
	// Log 59477 YC - checks if LocationSelected is on the page
	if(f.LocationSelected) TransferToList(f.LocationSelected,ovals.join("^"))
}
function LookUpBloodProduct(val) {
	ovals=val.split("^");
	ovals[1]=loopArrayForMatches(allbloodprodtxt,allbloodprodval,ovals[0].split("^"));
	f.BloodProduct.value="";
	// Log 59477 YC - checks if BloodProductSelected is on the page
	if(f.BloodProductSelected) TransferToList(f.BloodProductSelected,ovals.join("^"))
}
function LookUpQues(val) {
	f.Questionnaire.value="";
	ovals=val.split("^");
	ovals[1]=loopArrayForMatches(allquestxt,allquesval,ovals[0].split("^"));
	// Log 59477 YC - checks if QuestionnaireSelected is on the page
	if(f.QuestionnaireSelected) TransferToList(f.QuestionnaireSelected,ovals.join("^"));
}
function LookUpOrderPriority(val) {
	ovals=val.split("^");
	ovals[1]=loopArrayForMatches(allordpriotxt,allordprioval,ovals[0].split("^"));
	f.OrderPriority.value="";
	// Log 59477 YC - checks if OrderPrioritySelected is on the page
	if(f.OrderPrioritySelected) TransferToList(f.OrderPrioritySelected,ovals.join("^"))
}
function AddAll(obj,arytxt,aryval) {
	ClearAllList(obj);
	AddItemToList(obj,arytxt,aryval);
	return false;
}
function AddAllCategClickHandler(e) {
	// Log 59477 YC - check if CategorySelected exists first!
	if (f.CategorySelected) AddAll(f.CategorySelected,allcattxt,allcatval);
	return false;
}
function DeleteCategClickHandler(e) {
	// Log 59477 YC - check if CategorySelected exists first!
	if (f.CategorySelected) ClearSelectedList(f.CategorySelected);
	return false;
}
function DeleteOrdItemClickHandler(e) {
	// Log 59477 YC - check if OrderItemSelected exists first!
	if (f.OrderItemSelected) ClearSelectedList(f.OrderItemSelected);
	return false;
}
function DeleteObsItemClickHandler(e) {
	// Log 59477 YC - check if ObsItemSelected exists first!
	if (f.ObsItemSelected) ClearSelectedList(f.ObsItemSelected);
	return false;
}
function DeleteTestItemsClickHandler(e) {
	// Log 59477 YC - check if TestItemSelected exists first!
	if (f.TestItemSelected) ClearSelectedList(f.TestItemSelected);
	return false;
}

function DeleteClinPathClickHandler(e) {
	if (f.ClinPathSelected) ClearSelectedList(f.ClinPathSelected);
	return false;
}


// Log 41352 - AI - 29-01-2004 : Add new Subcategory Delete handler. Also remove from selsubcattxt, selsubcatval, and selsubcatcode variables.
function DeleteSubcategClickHandler(e) {
	var seltxtAry=selsubcattxt.split(",");
	var selvalAry=selsubcatval.split(",");
	var selcodeAry=selsubcatcode.split(",");

	var obj=f.SubcategorySelected;

	// Log 59477 YC - Check that object exists first!
	if (obj) {
		// Go backwards UP the listbox, as splicing reduces the Ary length by 1 each time.
		for (var i=obj.options.length-1; i>=0; i--) {
			if (obj.options[i].selected) {
				// check to make sure this selected item is actually in the list, before removing it from selsubcat... variables.
				var found=0;
				for (var j=0;j<obj.length;j++) {if (obj.options[j].value==selvalAry[i]) found=1;}
				if (found==1) {
					// Remove selected Subcategory from selAry Array.
					seltxtAry.splice(i,1);
					selvalAry.splice(i,1);
					selcodeAry.splice(i,1);
				}
			}
		}
		selsubcattxt=seltxtAry.join(",");
		selsubcatval=selvalAry.join(",");
		selsubcatcode=selcodeAry.join(",");

		// Now finally remove the selected options from the SubcategorySelected Listbox on the form.
		ClearSelectedList(obj);
	}

	return false;
}
// end Log 41352
function AddAllHospClickHandler(e) {
	// Log 59477 YC - Check if HospitalSelected exists first!
	if (f.HospitalSelected) AddAll(f.HospitalSelected,allhosptxt,allhospval);
	return false;
}
function DeleteHospClickHandler(e) {
	// Log 59477 YC - Check if HospitalSelected exists first!
	if (f.HospitalSelected) ClearSelectedList(f.HospitalSelected);
	return false;
}
// Log 55627 YC - Changing hospital handlers to location handlers
function AddAllLocClickHandler(e) {
	// Log 59477 YC - Check if LocationSelected exists first!
	if (f.LocationSelected) AddAll(f.LocationSelected,allloctxt,alllocval);
	return false;
}
function DeleteLocClickHandler(e) {
	// Log 59477 YC - Check if LocationSelected exists first!
	if (f.LocationSelected) ClearSelectedList(f.LocationSelected);
	return false;
}
// END Log 55627
function AddAllBloodProdClickHandler(e) {
	// Log 59477 YC - Check if BloodProductSelected exists first!
	if (f.BloodProductSelected) AddAll(f.BloodProductSelected,allbloodprodtxt,allbloodprodval);
	return false;
}
function DeleteBloodProdClickHandler(e) {
	// Log 59477 YC - Check if BloodProductSelected exists first!
	if (f.BloodProductSelected) ClearSelectedList(f.BloodProductSelected);
	return false;
}
function AddAllStatsClickHandler(e) {
	// Log 59477 YC - Check if StatusSelected exists first!
	if (f.StatusSelected) AddAll(f.StatusSelected,allstattxt,allstatval);
	return false;
}
function DeleteStatsClickHandler(e) {
	// Log 59477 YC - Check if StatusSelected exists first!
	if (f.StatusSelected) ClearSelectedList(f.StatusSelected);
	return false;
}
function AddAllQuesClickHandler(e) {
	// Log 59477 YC - Check if QuestionnaireSelected exists first!
	if (f.QuestionnaireSelected) AddAll(f.QuestionnaireSelected,allquestxt,allquesval);
	return false;
}
function DeleteQuesClickHandler(e) {
	// Log 59477 YC - Check if QuestionnaireSelected exists first!
	if (f.QuestionnaireSelected) ClearSelectedList(f.QuestionnaireSelected);
	return false;
}
function AddAllTestItemsClickHandler(e) {
	// Log 59477 YC - Check if TestItemSelected exists first!
	if (f.TestItemSelected) AddAll(f.TestItemSelected,alltestscontxt,alltestsconval);
	EnableUpdate();
	return false;
}
// Log 52540 - YC Order Priority (for Order Profile)
function AddAllOrdPrioClickHandler(e) {
	// Log 59477 YC - Check if OrderPrioritySelected exists first!
	if (f.OrderPrioritySelected) AddAll(f.OrderPrioritySelected,allordpriotxt,allordprioval);
	return false;
}
function DeleteOrdPrioClickHandler(e) {
	// Log 59477 YC - Check if OrderPrioritySelected exists first!
	if (f.OrderPrioritySelected) ClearSelectedList(f.OrderPrioritySelected);
	return false;
}
// END 52540
// Log 60604 - PJC
function DeleteResultStatusClickHandler(e) {
	// Log 59477 YC - Check if OrderPrioritySelected exists first!
	if (f.ResultStatusSelected) ClearSelectedList(f.ResultStatusSelected);
	return false;
}

function DeletePictTypeClickHandler(e) {
	// Log 63927 - KB 
	if (f.PictTypeSelected) ClearSelectedList(f.PictTypeSelected);
	return false;
}

function CTProfileParamsLoadHandler() {

	//if (self==top) websys_reSizeT();
	if (document.getElementById('addAllCat')) {
		document.getElementById('addAllCat').onclick = AddAllCategClickHandler;
		allcatval=allcatval.split(",");
		allcattxt=allcattxt.split("^");
	}
	if (document.getElementById('deleteCat')) document.getElementById('deleteCat').onclick = DeleteCategClickHandler;

	// Log 41352 - AI - 29-01-2004 : Add new Subcategory Delete handler.
	if (document.getElementById('deleteSubcat')) document.getElementById('deleteSubcat').onclick = DeleteSubcategClickHandler;
	// end Log 41352
	if (document.getElementById('addAllHosp')) {
		document.getElementById('addAllHosp').onclick = AddAllHospClickHandler;
		allhospval=allhospval.split(",");
		allhosptxt=allhosptxt.split("^");
	}
	if (document.getElementById('deleteHosp')) document.getElementById('deleteHosp').onclick = DeleteHospClickHandler;

	// Log 55627 YC - Changing hospital handlers to location handlers for BT profile
	if (document.getElementById('addAllLoc')) {
		document.getElementById('addAllLoc').onclick = AddAllLocClickHandler;
		alllocval=alllocval.split(",");
		allloctxt=allloctxt.split("^");
	}
	if (document.getElementById('deleteLoc')) document.getElementById('deleteLoc').onclick = DeleteLocClickHandler;

	if (document.getElementById('addAllBloodProd')) {
		document.getElementById('addAllBloodProd').onclick = AddAllBloodProdClickHandler;
		allbloodprodval=allbloodprodval.split(",");
		allbloodprodtxt=allbloodprodtxt.split("^");
	}
	if (document.getElementById('deleteBloodProd')) document.getElementById('deleteBloodProd').onclick = DeleteBloodProdClickHandler;

	if (document.getElementById('addAllStat')) {
		document.getElementById('addAllStat').onclick = AddAllStatsClickHandler;
		allstatval=allstatval.split(",");
		allstattxt=allstattxt.split("^");
	}
	if (document.getElementById('deleteStat')) document.getElementById('deleteStat').onclick = DeleteStatsClickHandler;

	if (document.getElementById('deleteTestItems')) document.getElementById('deleteTestItems').onclick = DeleteTestItemsClickHandler;
	
	if (document.getElementById('deleteClinPath')) document.getElementById('deleteClinPath').onclick = DeleteClinPathClickHandler;
	
	if (document.getElementById('addAllTestItems')) {
		//document.getElementById('addAllTestItems').onclick = AddAllTestItemsClickHandler;
		// Log 49041 - AI - 09-02-2005 : Build alltestsconval and alltestscontxt (con=concatenated) are built, because alltestsval and allteststxt have been broken up in epr.ctprofileparams.edit.csp.
		for (var i=1;i<testslen+1;i++) {
			if (i==1) {
				alltestsconval=alltestsval[i];
				alltestscontxt=allteststxt[i];
			}
			else {
				alltestsconval=alltestsconval+"^"+alltestsval[i];
				alltestscontxt=alltestscontxt+"^"+allteststxt[i];
			}
		}
		alltestsconval=alltestsconval.split("^");
		alltestscontxt=alltestscontxt.split("^");
		// end Log 49041
	}
	if (document.getElementById('addAllQues')) {
		document.getElementById('addAllQues').onclick = AddAllQuesClickHandler;
		allquesval=allquesval.split("^");
		allquestxt=allquestxt.split("^");
	}
	if (document.getElementById('deleteQues')) document.getElementById('deleteQues').onclick = DeleteQuesClickHandler;

	// Log 52540 YC - Order Priority (for Order Profile)
	if (document.getElementById('addAllOrderPriorities')) {
		document.getElementById('addAllOrderPriorities').onclick = AddAllOrdPrioClickHandler;
		allordprioval=allordprioval.split(",");
		allordpriotxt=allordpriotxt.split("^");
	}
	if (document.getElementById('deleteOrderPriority')) document.getElementById('deleteOrderPriority').onclick = DeleteOrdPrioClickHandler;

	// END Log 52540

	// Log 60604 - PJC
	allresstatval=allresstatval.split(",");
  allresstattxt=allresstattxt.split("^");
	if (document.getElementById('deleteResultStatus')) document.getElementById('deleteResultStatus').onclick = DeleteResultStatusClickHandler

	// ab 22.03.06
	if (document.getElementById('deleteOrderItem')) document.getElementById('deleteOrderItem').onclick = DeleteOrdItemClickHandler;

	if (document.getElementById('deleteObsItem')) document.getElementById('deleteObsItem').onclick = DeleteObsItemClickHandler;

	if (document.getElementById('update1')) document.getElementById('update1').onclick = UpdateClickHandler;
	if (f.ID.value!="") {
	  if (document.getElementById('PPGraphDefinitionDR')) {var graph=f.PPGraphDefinitionDR.value} else {var graph=""}
		completeForm(f.PPParameters.value.split("|"),graph);
	}
	// Log 63927 - KB
	if (document.getElementById('deletePictType')) document.getElementById('deletePictType').onclick = DeletePictTypeClickHandler;
  // END Log 63927
	f.PPDesc.focus();
}
window.document.body.onload=CTProfileParamsLoadHandler;
