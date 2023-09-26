// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
// Log 60176 PJC
function LookupChangeHandler()
{
	var objGenRtFrm=document.getElementById("GenRtFrm");
	var objDrgName=document.getElementById("Name");
	var objDrgForm=document.getElementById("Form");

	var imageGenRtFrm=document.getElementById("ld2147iGenRtFrm");
	var imageDrgName=document.getElementById("ld2147iName");
	var imageDrgForm=document.getElementById("ld2147iForm");

	if (objDrgForm)  EnableLookup( objDrgForm, imageDrgForm );
	if (objDrgName)  EnableLookup( objDrgName, imageDrgName );
	if (objGenRtFrm) EnableLookup( objGenRtFrm, imageGenRtFrm );
	if (objGenRtFrm && !objGenRtFrm.value=="") {
		// Disable Drug Name
		if (objDrgName) DisableLookup(objDrgName,imageDrgName);
		//Disable Frug Form
		if (objDrgForm) DisableLookup(objDrgForm,imageDrgForm);
	}
	else if (objDrgName && !objDrgName.value=="") {
		// Disable Generic Routed Form
		if (objGenRtFrm) DisableLookup(objGenRtFrm,imageGenRtFrm);
	}
	else if (objDrgForm && !objDrgForm.value=="") {
		// Disable Generic Routed Form
		if (objGenRtFrm) DisableLookup(objGenRtFrm,imageGenRtFrm);

	}
	else{
	}

} // LookupChangeHandler

function DisableLookup( objLookUp, imgLookup )
{
	objLookUp.disabled = true;
	objLookUp.value="";
	imgLookup.disabled = true;
	//imgLookup.onclick = LinkDisable;
}  // DisableLookup

function EnableLookup( objLookUp, imgLookup )
{
	objLookUp.disabled = false;
	imgLookup.disabled = false;
	//imgLookup.onclick = LinkDisable;
}  // EnableLookup


function DocumentLoadHandler() {
	var obj;
	assignClickHandler();

	obj=document.getElementById("new1")
	if (obj) obj.onclick=ClearFields;

	obj=document.getElementById("update1")
	if (obj) obj.onclick=UpdateHandler;

	obj=document.getElementById("GenRtFrm");
	if (obj) obj.onblur=GenRtFrmDRLookupChangeHandler;

	obj=document.getElementById("Name");
	if (obj) obj.onblur=DrgMasterLookupChangeHandler;

	obj=document.getElementById("Form");
	if (obj) obj.onblur=FormLookupChangeHandler;
}

function DrgMasterLookupChangeHandler()
{
	var objStr=document.getElementById("Name");
	if (objStr.value=="") {
		var objtype=document.getElementById("Form")
		if (objtype) { objtype.value="" }	
		var objStr=document.getElementById("PHCFormDR");
		if (objStr) objStr.innerText = "";
		var objStr=document.getElementById("PHCDrugRouteDR");
		if (objStr) objStr.innerText = "";
		var objStr=document.getElementById("PHCStrength");
		if (objStr) objStr.innerText = "";
	}
	LookupChangeHandler();
}

function FormLookupChangeHandler()
{
	var objStr=document.getElementById("Form")
	if (objStr.value=="") {
		var objStr=document.getElementById("PHCFormDR");
		if (objStr) objStr.innerText = "";
		var objStr=document.getElementById("PHCDrugRouteDR");
		if (objStr) objStr.innerText = "";
		var objStr=document.getElementById("PHCStrength");
		if (objStr) objStr.innerText = "";
	}
	LookupChangeHandler();
}

function GenRtFrmDRLookupChangeHandler()
{
	var objStr=document.getElementById("GenRtFrm");
	if (objStr.value=="") {
		var objStr=document.getElementById("PHCFormDR");
		if (objStr) objStr.innerText = "";
		var objStr=document.getElementById("PHCDrugRouteDR");
		if (objStr) objStr.innerText = "";
		var objStr=document.getElementById("PHCStrength");
		if (objStr) objStr.innerText = "";
	}
	LookupChangeHandler();
}


function UpdateHandler() {
	/*
	var drug=document.getElementById("Drug")
	var drgName=document.getElementById("Name")

	if (drug.value=="" && drgName.value=="")
	{
		alert("You need to enter a Drug.");
		return false;
	}
	*/
	return update1_click();
}

function ClearFields() {

	var field=document.getElementById("HistID")
	if (field) field.value="";

	var field=document.getElementById("MEDType")
	if (field) field.value="";

	var field=document.getElementById("Details")
	if (field) field.value="";

	var field=document.getElementById("Drug")
	if (field) field.value="";

	var field=document.getElementById("GenRtFrm")
	if (field) field.value="";

	var field=document.getElementById("Name")
	if (field) field.value="";

	var field=document.getElementById("Form")
	if (field) field.value="";

	var field=document.getElementById("Dose")
	if (field) field.value="";

	var field=document.getElementById("UOM")
	if (field) field.value="";

	var field=document.getElementById("Freq")
	if (field) field.value="";

	var field=document.getElementById("Duration")
	if (field) field.value="";

	var field=document.getElementById("DurationFree")
	if (field) field.value="";

	var field=document.getElementById("Condition")
	if (field) field.value="";

	var field=document.getElementById("Ceased")
	if ( field ) field.checked=false;

	// Log 58610 - GC - 26-04-2006 : New field MEDDSReportFlag
	var field=document.getElementById("MEDDSReportFlag")
	if ( field ) field.checked=false;
	// End Log 58610

	var field=document.getElementById("PHCStrength");
	if (field) field.innerText = "";

	LookupChangeHandler();

	return false;
}

function assignClickHandler() {
	var tbl=document.getElementById("tepr_HistMedication");
	for (var i=1;i<tbl.rows.length;i++) {
		var objEdit=document.getElementById("Amend1z"+i)
		if (objEdit) objEdit.onclick=ClickHandler;
	}
	return false;
}

function GenericSelectHandler(str) {
	var lu = str.split("^");
	var obj=document.getElementById("GenRtFrm")
	if (obj) obj.value = lu[0];
	var obj=document.getElementById("HidGenRouteForm")
	if (obj) obj.value = lu[1];
	var obj=document.getElementById("HidDrgForm")
	if (obj) obj.innerText = "";
	var objStr=document.getElementById("PHCFormDR");
	if (objStr) objStr.innerText = lu[3];
	var objStr=document.getElementById("PHCDrugRouteDR");
	if (objStr) objStr.innerText = lu[4];
	var objStr=document.getElementById("PHCStrength");
	if (objStr) objStr.innerText = lu[5];
	
	LookupChangeHandler();
}

function DrgFormSelectHandler(str) {
	var lu = str.split("^");
	var obj=document.getElementById("HidDrgForm")
	if (obj) obj.innerText = lu[1];
	var objStr=document.getElementById("PHCFormDR");
	if (objStr) objStr.innerText = lu[0];
	var objStr=document.getElementById("PHCDrugRouteDR");
	if (objStr) objStr.innerText = lu[3];
	var objStr=document.getElementById("PHCStrength");
	if (objStr) objStr.innerText = lu[4];
	var obj=document.getElementById("HidGenRouteForm")
	if (obj) obj.value = "";

	LookupChangeHandler();
}

function ClickHandler(e) {

	var obj=websys_getSrcElement(e);
	if ((obj)&&(obj.tagName=="IMG")) obj=websys_getParentElement(obj);
	if (obj) {
		var rowid=obj.id;
		var rowAry=rowid.split("z");
		var HIDDEN=document.getElementById("HIDDENz"+rowAry[1]).value;
		var temp=HIDDEN.split("^");

		var field=document.getElementById("HistID")
		if (field) field.value=temp[0];

		var field=document.getElementById("MEDType")
		if (field) field.value=temp[2];

		var field=document.getElementById("Details")
		if (field) field.value=temp[1];

		var field=document.getElementById("Drug")
		if (field) field.value=temp[3];

		var field=document.getElementById("GenRtFrm")
		if (field) field.value=temp[4];

		var field=document.getElementById("Name")
		if (field) field.value=temp[5];

		var field=document.getElementById("Form")
		if (field) field.value=temp[6];

		var field=document.getElementById("Dose")
		if (field) field.value=temp[7];

		var field=document.getElementById("UOM")
		if (field) field.value=temp[8];

		var field=document.getElementById("Freq")
		if (field) field.value=temp[9];

		var field=document.getElementById("Duration")
		if (field) field.value=temp[10];

		var field=document.getElementById("DurationFree")
		if (field) field.value=temp[11];

		var field=document.getElementById("Condition")
		if (field) field.value=temp[12];

		var field=document.getElementById("Ceased")
		if ( field ) {
			field.checked=false;
			if (temp[13]=="Y") field.checked=true;
		}

		// Log 58610 - GC - 26-04-2006 : New field MEDDSReportFlag
		var field=document.getElementById("MEDDSReportFlag")
		if ( field ) {
			field.checked=false;
			if (temp[14]=="Y") field.checked=true;
		}
		// Log 58610

		var field=document.getElementById("HidDrgForm")
		if (field) field.value=temp[15];

		var field=document.getElementById("PHCStrength");
		if (field) field.innerText=temp[16];

		var field=document.getElementById("HidGenRouteForm")
		if (field) field.value=temp[17];

		var field=document.getElementById("PHCFormDR")
		if (field) field.innerText=temp[18];

		var field=document.getElementById("PHCDrugRouteDR")
		if (field) field.innerText=temp[19];
	}
	LookupChangeHandler();

	return false;
}

document.body.onload = DocumentLoadHandler;


