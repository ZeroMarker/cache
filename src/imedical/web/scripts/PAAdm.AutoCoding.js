// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
// KK 11/Apr/2003 Log 32794 


var objEpisodeCount=document.getElementById("EpisodeCount");

function BodyLoadHandler(){
	//var obj=document.getElementById("AutoCode");
	//if(obj) obj.onclick=BuildIDsfromList;
	var objDU=document.getElementById("DleteUnit");
	if(objDU) objDU.onclick=DeleteUnitClickHandler;
	var objDW=document.getElementById("DeleteWard");
	if(objDW) objDW.onclick=DeleteWardClickHandler;
	var objAtuoCode=document.getElementById("AutoCode");
	if(objAtuoCode) objAtuoCode.onclick=AtuoCodeClickHandler;
	if ((objEpisodeCount) && (objEpisodeCount.value!="")) {
		var EpiCount=objEpisodeCount.value;
		var lu=EpiCount.split("^");
		//alert("Number of Episodes Succesfully coded = " + lu[0] + "\n" +	"Number of Episodes rejected Episodes = " + lu[1] + "\n" +  "Number of Episodes with ICD Edit Warnings = " + lu[2] + "\n" + "Number of Episodes rejected by ICD Edits = " + lu[3]);
		alert( t['CODED_EPISODES'] + " = " + lu[0] + "\n" +  t['REJECTED_EPISODES'] + " = " + lu[1] + "\n" + t['ICD_WARN_EPISODES'] + " = " + lu[2] + "\n" + t['ICD_REJECT_EPISODES'] + " = " + lu[3]);
		objEpisodeCount.value="";
	}
	var objDRFU=document.getElementById("DeleteRFU");
	if(objDRFU) objDRFU.onclick=DeleteRFUClickHandler;
}

function AtuoCodeClickHandler(){
	BuildIDsfromList();
	//SetRequiresFollowUp();
	var ReadyToBatch=1;
	ReadyToBatch=confirm(t['TIME_WARNING']+"\n"+t['OK_START']);
	if (!ReadyToBatch) {		
		return false;
	}
	var diagfld=document.getElementById("DiagFields");
	//if (diagfld) alert("Diagfields " + diagfld.value); 
	var procfld = document.getElementById("ProcFields");
	//if (procfld) alert("Procfields" + procfld.value); 
	if(objEpisodeCount) objEpisodeCount.value="";
	return AutoCode_click();
}

function WARDDescLookUpSelect(str) {
	//alert("str="+str);
	var lu = str.split("^");
	var obj=document.getElementById('WARDDesc');
	if (obj) obj.value=lu[0];
	var objList=document.getElementById('WardList');
	if (objList) {
		var txtField='WARDDesc';
		var lstField='WardList';
		LookupSelectforList(txtField,lstField,str);
	}
}

function DischargeUnitLookUpSelect(str) {
	var lu = str.split("^");
	var tmp=lu[1];
	lu[1]=lu[2];
	lu[2]=tmp;
	var obj=document.getElementById('DischargeUnit');
	if (obj) obj.value=lu[0];
	var objList=document.getElementById('UnitList');
	if (objList) {
		var txtField='DischargeUnit';
		var lstField='UnitList';
		LookupSelectforList(txtField,lstField,str);
	}
}

function RFULookUpSelect(str) {
	//alert("str="+str);
	var lu = str.split("^");
	var obj=document.getElementById('RequiresFollowUp');
	if (obj) obj.value=lu[0];
	var objList=document.getElementById('RequiresFollowUpList');
	if (objList) {
		var txtField='RequiresFollowUp';
		var lstField='RequiresFollowUpList';
		LookupSelectforList(txtField,lstField,str);
	}
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
			if  ((adata[2] != "") && (obj.options[i].text == adata[0])) {
				alert( adata[0] + " has already been selected");
				var obj=document.getElementById(tfield);
				if (obj) obj.value="";
				return;
			}
		}
	}
	//AddItemToList(obj,adata[2],adata[0]);
	//KK 07/02/05 L:47920
	if (tfield=="DischargeUnit") {
		//alert(adata[1] + " ^ " + adata[0]);
		AddItemToList(obj,adata[1],adata[0]);
	} else {
		//alert(adata[2] + " ^ " + adata[0]);
		AddItemToList(obj,adata[2],adata[0]);
	}
	var obj=document.getElementById(tfield);
	if (obj) obj.value="";
}

function AddItemToList(list,code,desc) {
	//Add an item to a listbox
	//code=String.fromCharCode(2)+code
	list.options[list.options.length] = new Option(desc,code);
}

function BuildIDsfromList(){
	//Ward
	var objList=document.getElementById('WardList');
	if (objList) {
		var IDfield='DischargeWardString';
		var lstfield='WardList';
		UpdatewithIDs(lstfield,IDfield);
	}
	var objList=document.getElementById('UnitList');
	if (objList) {
		var IDfield='DischargeUnitString';
		var lstfield='UnitList';
		UpdatewithIDs(lstfield,IDfield);
	}
	var objList=document.getElementById('RequiresFollowUpList');
	if (objList) {
		var IDfield='RequiresFollowUpString';
		var lstfield='RequiresFollowUpList';
		UpdatewithIDs(lstfield,IDfield);
	}
}

function UpdatewithIDs(lstfield,IDfield) {
	var arrItems = new Array();
	var lst = document.getElementById(lstfield);
	var SlectedIDs="";
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			SlectedIDs=SlectedIDs + lst.options[j].value + "|";
		}
		SlectedIDs=SlectedIDs.substring(0,(SlectedIDs.length-1));
		var el = document.getElementById(IDfield);
		if (el) el.value = SlectedIDs;
		//alert(SlectedIDs);
	}
}

function DeleteWardClickHandler() {
	//Delete items from DPTEntered listbox when "Delete" button is clicked.
	var obj=document.getElementById("WardList");
	if (obj)
		RemoveFromList(obj);
	return false;
}
function DeleteUnitClickHandler() {
	//Delete items from DPTEntered listbox when "Delete" button is clicked.
	var obj=document.getElementById("UnitList");
	if (obj)
		RemoveFromList(obj);
	return false;
}
function DeleteRFUClickHandler() {
	//Delete items from Entered listbox when "Delete" button is clicked.
	var obj=document.getElementById("RequiresFollowUpList");
	if (obj)
		RemoveFromList(obj);
	return false;
}

function RemoveFromList(obj) {
	for (var i=(obj.length-1); i>=0; i--) {
		if (obj.options[i].selected)
			obj.options[i]=null;
	}
}

function SetRequiresFollowUp() {
	var followup="";
	var lst = document.getElementById("RequiresFollowUpList");
	if (lst) {
		if ((lst.options)&&(lst.options.length!=0)) {
			for (var j=0; j<lst.options.length; j++) {
				if (lst.options[j].selected) {
					followup= followup+ lst.options[j].value + "|"
				}
			}
		}
		followup=followup.substring(0,(followup.length-1));
		var objSel = document.getElementById("RequiresFollowUpString");
		if (objSel) objSel.value=followup;
		//alert("objSel.value="+objSel.value);
	}
}

function LookUpDRGCodeSetSelect(str){
	//alert(str);
	var lu = str.split("^");
	var obj=document.getElementById("DRGCodeSet");
	if (obj) obj.value=lu[0];
	var objDiag=document.getElementById("DiagFields");
	if (objDiag) objDiag.value=lu[2];
	var objProc=document.getElementById("ProcFields");
	if (objProc) objProc.value=lu[3];
	//alert(objProc.value);
	//alert(objDiag.value);
}
document.body.onload=BodyLoadHandler;
