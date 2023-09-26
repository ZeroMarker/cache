// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
// Log 60176 PJC
function LookupChangeHandler()
{
	var objGenRtFrm=document.getElementById("MEDGenRtFrmDR");
	var objDrgName=document.getElementById("MEDDrgMastDR");
	var objDrgForm=document.getElementById("MEDDrgFormDR");

	var imageGenRtFrm=document.getElementById("ld1952iMEDGenRtFrmDR");
	var imageDrgName=document.getElementById("ld1952iMEDDrgMastDR");
	var imageDrgForm=document.getElementById("ld1952iMEDDrgFormDR");

	if (objGenRtFrm && objGenRtFrm.value!="") {
		// Disable Drug Name
		if (objDrgName) DisableLookup(objDrgName,imageDrgName);
		//Disable Frug Form
		if (objDrgForm) DisableLookup(objDrgForm,imageDrgForm);
	}
	else if (objDrgName && objDrgName.value!="") {
		// Disable Generic Routed Form
		if (objGenRtFrm) DisableLookup(objGenRtFrm,imageGenRtFrm);
	}
	else if (objDrgForm && objDrgForm.value!="") {
		// Disable Generic Routed Form
		if (objGenRtFrm) DisableLookup(objGenRtFrm,imageGenRtFrm);
	}
	else{
		if (objDrgForm)  EnableLookup( objDrgForm, imageDrgForm );
		if (objDrgName)  EnableLookup( objDrgName, imageDrgName );
		if (objGenRtFrm) EnableLookup( objGenRtFrm, imageGenRtFrm );
	}

} // LookupChangeHandler

function GenericSelectHandler(str) {
	var lu = str.split("^");
	var obj=document.getElementById("MEDGenRtFrmDR")
	if (obj) obj.value = lu[0];
	var obj=document.getElementById("HidGenRouteForm")
	if (obj) obj.value = lu[1];
	var objStr=document.getElementById("PHCForm");
	if (objStr) objStr.innerText = lu[3];
	var objStr=document.getElementById("PHCDrugRoute");
	if (objStr) objStr.innerText = lu[4];
	var objStr=document.getElementById("PHCStrength");
	if (objStr) objStr.innerText = lu[5];
	var obj=document.getElementById("HidDrgForm")
	if (obj) obj.innerText = "";
	
	LookupChangeHandler();
}

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

var objGenRt=document.getElementById("MEDGenRtFrmDR");
if (objGenRt) objGenRt.onblur=GenRtFrmDRLookupChangeHandler;

var objDrgMast=document.getElementById("MEDDrgMastDR");
if (objDrgMast) objDrgMast.onblur=DrgMasterLookupChangeHandler;

var objDrgForm=document.getElementById("MEDDrgFormDR");
if (objDrgForm) objDrgForm.onblur=FormLookupChangeHandler;

function DrgMasterLookupChangeHandler()
{
	var objStr=document.getElementById("MEDDrgMastDR");
	if (objStr.value=="") {
		var objtype=document.getElementById("MEDDrgFormDR")
		if (objtype) { objtype.value="" }	
		var objStr=document.getElementById("PHCForm");
		if (objStr) objStr.innerText = "";
		var objStr=document.getElementById("PHCDrugRoute");
		if (objStr) objStr.innerText = "";
		var objStr=document.getElementById("PHCStrength");
		if (objStr) objStr.innerText = "";
	}
	LookupChangeHandler();
}

function FormLookupChangeHandler()
{
	var objStr=document.getElementById("MEDDrgFormDR")
	if (objStr.value=="") {
		var objStr=document.getElementById("PHCForm");
		if (objStr) objStr.innerText = "";
		var objStr=document.getElementById("PHCDrugRoute");
		if (objStr) objStr.innerText = "";
		var objStr=document.getElementById("PHCStrength");
		if (objStr) objStr.innerText = "";
	}
	LookupChangeHandler();
}

function GenRtFrmDRLookupChangeHandler()
{
	var objStr=document.getElementById("MEDGenRtFrmDR");
	if (objStr.value=="") {
		var objStr=document.getElementById("PHCForm");
		if (objStr) objStr.innerText = "";
		var objStr=document.getElementById("PHCDrugRoute");
		if (objStr) objStr.innerText = "";
		var objStr=document.getElementById("PHCStrength");
		if (objStr) objStr.innerText = "";
	}
	LookupChangeHandler();
}

LookupChangeHandler();

// Log 50518 YC
var frmMedEdit = document.forms["fMRMedication_Edit"];

// disable prompts if created by HL7...
var objHL7=document.getElementById("MEDHL7Number")
if (objHL7 && (objHL7.value!="")) {
	var objdets=document.getElementById("MEDDetails")
	if (objdets) {
		// Log 50869 YC - if disabled this field will not save on update
		//objdets.disabled=true;
		ReadOnly(objdets);
	}

	var objtype=document.getElementById("MEDType")
	if (objtype) {
		// Log 50869 YC - if disabled this field will not save on update
		//objtype.disabled=true;
		ReadOnly(objtype);
	}

	var objtypelook=document.getElementById("ld1952iMEDType")
	if (objtypelook) {
		objtypelook.disabled = true;
		objtypelook.onclick=LinkDisable;
	}

	var objdelete=document.getElementById("delete1")
	if (objdelete) {
			objdelete.disabled=true;
			objdelete.onclick=LinkDisable;
	}

}

var objID = document.getElementById('ID');
if(objID && (objID.value != ""))
{
	// disable Add Next when Updating Entry
	var objAddNext = document.getElementById('AddNext');
	if (objAddNext) {
		objAddNext.disabled = true;
		objAddNext.onclick=LinkDisable;
	}
}
else
{
	// disable delete when Adding Entry
	var objDelete = document.getElementById('delete1');
	if (objDelete) {
		objDelete.disabled = true;
		objDelete.onclick=LinkDisable;
	}
	// Log 53061 YC - Disable audit trail when adding new
	var objAuditLink=document.getElementById('AuditTrailData');
	if (objAuditLink) {
		objAuditLink.disabled=true;
		objAuditLink.onclick=LinkDisable;
	}
}

// Log 50518 YC - Readonly for ALL elements in the form if "CanAddDSMedication" is unchecked in security settings for this user group
var objCanAddDSMeds = document.getElementById('CanAddDSMedications');
if (objCanAddDSMeds && objCanAddDSMeds.value==0 && objCanAddDSMeds.value!="")
{
	// Disable all text, checkbox and password elements
	iNumElems = frmMedEdit.elements.length;
	for (var i=0; i<iNumElems; i++)	{
		var eElem = frmMedEdit.elements[i];
		if ((eElem.tagName=="INPUT")&&((eElem.type=="text")||(eElem.type=="checkbox")||(eElem.type=="password"))) {
			eElem.disabled = true;
		}
		if ((eElem.type=="textarea")) {
			ReadOnly(eElem);
		}
	}
	// Disable all lookups
	imgArray = frmMedEdit.getElementsByTagName('img');	//get all imgs in this form
	for(imgs=0; imgs<imgArray.length; imgs++)
	{
		if(imgArray[imgs].id.substring(0,7)=="ld1952i") //is a lookup
		{
			imgArray[imgs].disabled = true;
			imgArray[imgs].onclick = LinkDisable;
		}
	}

	// Disable Update
	var objupdate=document.getElementById("update1");
	if (objupdate)
	{
		objupdate.disabled = true;
		objupdate.onclick = LinkDisable;
	}
	// Disable Add Next
	objAddNext = document.getElementById('AddNext');
	if (objAddNext)
	{
		objAddNext.disabled = true;
		objAddNext.onclick = LinkDisable;
	}
	// Disable Delete
	objdelete = document.getElementById('delete1');
	if (objdelete)
	{
		objdelete.disabled = true;
		objdelete.onclick = LinkDisable;
	}
}

function ReadOnly(obj) {
	obj.onfocus=DoNotAllow;
	obj.onkeydown=DoNotAllow;
	obj.style.color="gray";
	// stops copying and pasting
	obj.ondragstart=DoNotAllow;
	obj.onselectstart=DoNotAllow;
	obj.oncontextmenu=DoNotAllow;
}

function DrgFormSelectHandler(str) {
	var lu = str.split("^");
	var obj=document.getElementById("HidDrgForm");
	if (obj) obj.innerText = lu[1];
	var objStr=document.getElementById("PHCForm");
	if (objStr) objStr.innerText = lu[0];
	var objStr=document.getElementById("PHCDrugRoute");
	if (objStr) objStr.innerText = lu[3];
	var objStr=document.getElementById("PHCStrength");
	if (objStr) objStr.innerText = lu[4];
	
	LookupChangeHandler();
}


function DoNotAllow() {
	return false;
}
// END Log 50518 YC


function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	if (el.disabled) {
		return false;
	}
	return true;
}
