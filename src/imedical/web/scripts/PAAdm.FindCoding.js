// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function BodyLoadHandler(){
	var objAT=document.getElementById('AdmissionType');
	if (objAT) SetAdmissionType();
	var objFind=document.getElementById('find1');
	if (objFind) objFind.onclick=FindClickHandler;
	if (tsc['find1']) websys_sckeys[tsc['find1']]=FindClickHandler;

	// SA 4.9.02 - log 28215: Funcionality requested so that Find Key can be
	// accessed by hitting "Enter" after reg num is keyed in. This code 
	// taken from PAPerson.Find.js
	obj=document.getElementById("RegistrationNo");
	if (obj) obj.onkeydown=RegistrationEnter;
	
	//L32760
	var objDU=document.getElementById("DleteUnit");
	if(objDU) objDU.onclick=DeleteUnitClickHandler;
	var objDW=document.getElementById("DeleteWard");
	if(objDW) objDW.onclick=DeleteWardClickHandler;
	var objDRFU=document.getElementById("DeleteRFU");
	if(objDRFU) objDRFU.onclick=DeleteRFUClickHandler;
	var objDMRL=document.getElementById("DeleteMRLocation");
	if(objDMRL) objDMRL.onclick=DeleteMRLocationClickHandler;
	var AdmType = document.getElementById("AdmissionType");
	if (AdmType) AdmType.onchange=SetSelectedAdmTypes;
	SetSelectedAdmTypes();
	var obj=document.getElementById("HOSPDesc");
	if (obj) obj.onblur=HospBlurHandler;
}

function CareProviderLookup(str) {
 	var lu = str.split("^");
	var obj;
	
	obj=document.getElementById('CareProvider')
	if (obj) obj.value = lu[0]
	
	obj=document.getElementById('CareProviderID');
	if (obj) obj.value = lu[8];	
	
}

function HospBlurHandler() {
	var obj=document.getElementById("HOSPDesc");
	var objid=document.getElementById("HospitalID");
	if ((obj)&&(objid)&&(obj.value=="")) objid.value="";
}

function HOSPDescLookupSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById("HospitalID");
	if (obj) obj.value=lu[1];
}

//KK 26/july/02 Log 26291 
function SetAdmissionType() {
	var lst = document.getElementById("AdmissionType");
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			if (lst.options[j].value=="I") lst.options[j].selected=true;
		}
	}
}

function SetSelectedAdmTypes() {
	var arrItems = new Array();
	var admtypes="";
	var lst = document.getElementById("AdmissionType");
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			if (lst.options[j].selected) {
				admtypes= admtypes+ lst.options[j].value + "|"
			}
		}
		admtypes=admtypes.substring(0,(admtypes.length-1));
		//alert(admtypes);
		var objSel = document.getElementById("SelectedAdmTypes");
		if (objSel) objSel.value=admtypes;
	}
}

function RegistrationEnter(e) {
	// SA 4.9.02 - log 28215: Funcionality requested so that Find Key can be
	// accessed by hitting "Enter" after reg num is keyed in. This code 
	// taken from PAPerson.Find.js
	var key = websys_getKey(e);
	var obj = websys_getSrcElement(e);
	if ((obj)&&(obj.value!="")&&(key==13)) {
		var obj=document.getElementById("find1");
		if (obj) obj.focus();
	}
}


function FindClickHandler(){
	//var objSelectedAdmTypes=document.getElementById("SelectedAdmTypes");
	//alert("SelectedAdmTypes:"+objSelectedAdmTypes.value);
	SetSelectedAdmTypes();
	//alert("SelectedAdmTypes:"+objSelectedAdmTypes.value);

	// L32760
	BuildIDsfromList();

	// RQG 02.04.03 L32760
	//SetRequiresFollowUp();
	SetHiddenFindParam();

	// RQG 17.03.03 L32761 
	SetAdmTypeToInpatient();
	return find1_click();
}

function SetAdmTypeToInpatient() {
	// dummy function. See QH - PAAdm.FindCoding.js custom script file
}

function SetRequiresFollowUp() {
	// RQG 02.04.03 L32760: This sets the selected followup required from the listbox
	var followup="";
	var lst = document.getElementById("RequiresFollowUp");
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			if (lst.options[j].selected) {
				followup= followup+ lst.options[j].value + "|"
			}
		}
		followup=followup.substring(0,(followup.length-1));
		//alert(followup);
		var objSel = document.getElementById("RequiresFollowUpString");
		if (objSel) objSel.value=followup;
		//alert("objSel.value="+objSel.value);
	}
}

function SetHiddenFindParam() {
	var mrc=""; var hosp=""; var rfu=""; var ward=""; var du=""; var admno=""; var mrloc="";
	var objMRC=document.getElementById("MedRecNumber");
	if (objMRC) mrc=objMRC.value;
	var objAdmNo=document.getElementById("AdmNo");
	if (objAdmNo) admno=objAdmNo.value;
	var objHosp=document.getElementById("HOSPDesc");
	if (objHosp) hosp=objHosp.value;
	var objRFU=document.getElementById("RequiresFollowUpString");
	if (objRFU) rfu=objRFU.value;
	//alert(rfu);
	//var objWard=document.getElementById("WARDDesc");
	//if (objWard) ward=objWard.value;
	//var objDU=document.getElementById("DischargeUnit");
	//if (objDU) du=objDU.value;

	var objWardStr=document.getElementById("DischargeWardString");
	if (objWardStr) ward=objWardStr.value;
	var objDUStr=document.getElementById("DischargeUnitString");
	if (objDUStr) du=objDUStr.value;

	//var objMRL=document.getElementById("MedRecLocation");
	var objMRLStr=document.getElementById("MRLocationString");
	if (objMRLStr) mrloc=objMRLStr.value;
	//alert("mrlstring="+mrloc);
	var objFindParam=document.getElementById("HiddenFindParam");
	if (objFindParam) objFindParam.value=mrc+"^"+admno+"^"+hosp+"^"+rfu+"^"+ward+"^"+du+"^"+mrloc;
	//alert("HiddenParam="+objFindParam.value);
	//if (objFindParam) objFindParam.value=objFindParam.value+"^"+"^"+"^"+"^"+"^"+"^"+"^";
	//alert("HiddenParam2="+objFindParam.value);

}

//L32760
function WARDDescLookUpSelect(str) {
	//alert(str);
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

//L32760
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

function MedRecLocationLookUpSelect(str) {
	//alert("str="+str);
	var lu = str.split("^");
	var tmp=lu[1];
	lu[1]=lu[2];
	lu[2]=tmp;
	var obj=document.getElementById('MedRecLocation');
	if (obj) obj.value=lu[0];
	var objList=document.getElementById('MedRecLocationList');
	if (objList) {
		var txtField='MedRecLocation';
		var lstField='MedRecLocationList';
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
	if ((tfield=="MedRecLocation")||(tfield=="DischargeUnit")) {
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

function DeleteWardClickHandler() {
	//Delete items from Entered listbox when "Delete" button is clicked.
	var obj=document.getElementById("WardList");
	if (obj)
		RemoveFromList(obj);
	return false;
}

function DeleteUnitClickHandler() {
	//Delete items from Entered listbox when "Delete" button is clicked.
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

function DeleteMRLocationClickHandler() {
	//Delete items from Entered listbox when "Delete" button is clicked.
	var obj=document.getElementById("MedRecLocationList");
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

function BuildIDsfromList(){
	//Ward
	var objList=document.getElementById('WardList');
	if (objList) {
		var IDfield='DischargeWardString';
		var lstfield='WardList';
		UpdatewithIDs(lstfield,IDfield);
	}
	//Unit
	var objList=document.getElementById('UnitList');
	if (objList) {
		var IDfield='DischargeUnitString';
		var lstfield='UnitList';
		UpdatewithIDs(lstfield,IDfield);
	}
	//RequiresFollowUp
	var objList=document.getElementById('RequiresFollowUpList');
	if (objList) {
		var IDfield='RequiresFollowUpString';
		var lstfield='RequiresFollowUpList';
		UpdatewithIDs(lstfield,IDfield);
	}
	//Medical Record Location
	var objList=document.getElementById('MedRecLocationList');
	if (objList) {
		var IDfield='MRLocationString';
		var lstfield='MedRecLocationList';
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

document.body.onload=BodyLoadHandler;
