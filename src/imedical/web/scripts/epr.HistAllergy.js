// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.


var df=document.forms;
var ltbl=document.getElementById("t"+df[df.length-1].id.substring(1,df[df.length-1].id.length));
var frm=document.getElementById("f"+ltbl.id.substring(1,ltbl.id.length));

function DoColour() {
	var Altbl=document.getElementById("tepr_HistAllergy");
	var Alfrm=document.getElementById("fepr_HistAllergy");
	if (Altbl&&Alfrm) {
		for (var curr_row=1; curr_row<Altbl.rows.length; curr_row++) {
			var RowHexColour=Alfrm.elements["RowHexColourz" + curr_row].value;
			var InActiveFlag=Alfrm.elements["InActiveHiddenz" + curr_row].value;
			if (InActiveFlag=="Y") {
				Altbl.rows[curr_row].className="EMRAllergyInactive"
			} else if (RowHexColour!="") {
				Altbl.rows[curr_row].style.backgroundColor=RowHexColour;
			} 		

		}
	}
	/*	
	for (var curr_row=1; curr_row<Altbl.rows.length; curr_row++) {
		var RowHexColour=frm.elements["RowHexColourz" + curr_row].value;
		for (var CurrentCell=0; CurrentCell<Altbl.rows[curr_row-1].cells.length; CurrentCell++) {
			alert(curr_row+'\n'+CurrentCell+'\n'+RowHexColour+'\n'+InActiveFlag);
			if (InActiveFlag=="Y") {
				alert("inactive");
				Altbl.rows[curr_row-1].cells[CurrentCell].className="EMRAllergyInactive"
			} else if (RowHexColour!="") {
				alert("colour");
				Altbl.rows[curr_row-1].cells[CurrentCell].bgColor=RowHexColour;
			}
		}
	}
	*/
}

var objOnsetDate=document.getElementById("ALGOnsetDate");
var objDateOfBirth=document.getElementById("DateOfBirth");

function AllergyBodyLoadHandler() {
	assignClickHandler();
	
	obj=document.getElementById("new1")
	if (obj) obj.onclick=ClearFields;
	
	DoColour();
	CheckReasonForChange();
	var update = document.getElementById('update1');
	if (update) update.onclick = UpdateClickHandler;

	DisableFields();
}


function ClearFields() {
	var field=document.getElementById("ID")
	if (field) field.value="";
	
	var field=document.getElementById("MRCATDesc")
	if (field) field.value="";
	
	var field=document.getElementById("ALGDescCT")
	if (field) field.value="";
	
	var field=document.getElementById("ALRGSEVDesc")
	if (field) field.value="";
	
	var field=document.getElementById("ALGOnsetDate")
	if (field) field.value="";
	
	var field=document.getElementById("ALGInActive")
	if (field) field.value="";
	
	var field=document.getElementById("ALGComments")
	if (field) field.value="";
	
	var field=document.getElementById("ALRGCATDesc")
	if (field) field.value="";
	
	var field=document.getElementById("table")
	if (field) field.value="";

	// Log 58610 - GC - 27-04-2006 : New Field ALGDSReportFlag
	var field=document.getElementById("ALGDSReportFlag")
	if (field) field.checked=false;
	// End Log 58610
	
	return false;
}


function assignClickHandler() {
	var tbl=document.getElementById("tepr_HistAllergy");
	for (var i=1;i<tbl.rows.length;i++) {
		var objEdit=document.getElementById("Amend1z"+i)
		if (objEdit) objEdit.onclick=ClickHandler;
	}
	return false;
}

function ClickHandler(e) {
	var obj=websys_getSrcElement(e);
	if ((obj)&&(obj.tagName=="IMG")) obj=websys_getParentElement(obj);
	if (obj) {
		var rowid=obj.id;
		var rowAry=rowid.split("z");
		var HIDDEN=document.getElementById("HIDDENz"+rowAry[1]).value;
		var temp=HIDDEN.split("^");
		
		var field=document.getElementById("ID")
		if (field) field.value=temp[0];
		
		var field=document.getElementById("MRCATDesc")
		if (field) field.value=temp[1];
		
		var field=document.getElementById("ALGDescCT")
		if (field) field.value=temp[2];
		
		var field=document.getElementById("ALRGSEVDesc")
		if (field) field.value=temp[3];
		
		var field=document.getElementById("ALGOnsetDate")
		if (field) field.value=temp[4];
		
		var field=document.getElementById("ALGInActive")
		if (field) {
			if (temp[5]=="Y") {
				field.checked=true;
			} else {
				field.checked=false;
			}
				
		}
		
		var field=document.getElementById("ALGComments")
		if (field) field.value=temp[6];
		
		var field=document.getElementById("ALRGCATDesc")
		if (field) field.value=temp[7];
		
		var field=document.getElementById("table")
		if (field) field.value=temp[8];
		
		var field=document.getElementById("TagCode")
		if (field) field.value=temp[9];
		
		var field=document.getElementById("CategoryRowId")
		if (field) field.value=temp[10];
		
		var field=document.getElementById("AllergenRowId")
		if (field) field.value=temp[11];
		
		// Log 58610 - GC - 27-04-2006 : New Field ALGDSReportFlag
		var field=document.getElementById("ALGDSReportFlag")
		if (field) {
			field.checked=false;
			if (temp[12]=="Y") field.checked=true;
		}
		// End Log 58610
		
		//alert(field.value);
		
		//alert(unescape(temp[7]));
		//alert(HIDDENType);
		
		return false;
	}
}


function CatBlur() {
	var obj=document.getElementById('MRCATDesc');
	var objId=document.getElementById('CategoryRowId');
	if ((obj)&&(obj.value=="")&&(objId)) objId.value="";
}

function CheckOnsetDateCurrentDate() {
	var OOnsetDate="";
	if (objOnsetDate) {
		if (objOnsetDate.value=="") {
			return 0;
		}
		if ((IsValidDate(objOnsetDate))&&(objOnsetDate.value!="")) {
			OOnsetDate=objOnsetDate.value;
			// DateStringCompareToday is found in websys.DateTime.Tools.js (included in "Other Scripts" in Component Properties).
			var datecheck=DateStringCompareToday(OOnsetDate);
			if (datecheck==1) {
				return -1;
			}
		}
	}
	return 1;
}

function CheckOnsetDateDateOfBirth() {
	var ODateOfBirth="";
	var OOnsetDate="";
	if (objDateOfBirth) {
		if ((IsValidDate(objDateOfBirth))&&(objDateOfBirth.value!="")) {
			ODateOfBirth=objDateOfBirth.value;
		}
	}
	if (objOnsetDate){
		if ((IsValidDate(objOnsetDate))&&(objOnsetDate.value!="")) {
			OOnsetDate=objOnsetDate.value;
		}
	}
	if ((ODateOfBirth!="")&&(OOnsetDate!="")) {
		// DateStringCompare is found in websys.DateTime.Tools.js (included in "Other Scripts" in Component Properties).
		var datecheck=DateStringCompare(ODateOfBirth,OOnsetDate);
		if (datecheck==1) {
			return -1;
		}
	}
	return 1;
}

// Log 41737 - AI - 28-01-2004 : Create function to make Repeat Handler work! (never has worked until now).
// 				 RepeatClickHandler calls epr_RepeatClickHandler, which calls ValidateUpdate.
function ValidateUpdate() {
	// Log 37489 - AI - 15-08-2003 : Add handler for InValid flag toggle and Reason For Change field logic.
	var obj = document.getElementById('cReasForChange');
	if ((obj)&&(obj.className=="clsRequired")) {
		var obj = document.getElementById('ReasForChange');
		if ((obj)&&(obj.value=="")) {
			alert("'" + t['ReasForChange'] + "' " + t['XMISSING']);
			return false;
		}
	}
	// end Log 37489

	// Log 41737 - AI - 20-01-2004 : Logic for Log 37392 moved to here - from web class PAAllergy websysSaveAllergen method.
	// LOG 37392 RC 15/08/03 Check to see if the OnsetDate is valid (i.e. greater than the patient's DOB and less than or equal to today's date)

	if (objOnsetDate) {
		isvalid1=CheckOnsetDateCurrentDate();
		if (isvalid1==-1) {
			alert(t["OnsetVToday"]);
			return false;
		}
	}
	if ((objOnsetDate)&&(objDateOfBirth)) {
		isvalid2=CheckOnsetDateDateOfBirth();
		if (isvalid2==-1) {
			alert(t["OnsetVDOB"]);
			return false;
		}
	}
	
	
	var objCat=document.getElementById("MRCATDesc");
	var objTag=document.getElementById("MRCATTagDescription");
	var objAl=document.getElementById("ALGDescCT");
	if ((objAl)&&(objAl.className=="clsInvalid")) {
		alert("'" + t['ALGDescCT'] + "' " + t['XINVALID']);
		return false;
	}
	
	if ((objTag)&&(objTag.value!="")) {
		if (((objCat)&&(objCat.value==""))&&((objAl)&&(objAl.value==""))) {
			alert(t["ONLY_TAG"]);
			return false;
		}
	
	}
	
	
	return true;
}

// Log 41737 - AI - 28-01-2004 : Rearrange function to call ValidateUpdate.
function UpdateClickHandler() {
	
	if (ValidateUpdate()) {
		return update1_click();
	}
	return false;
}

// Log 41737 - AI - 28-01-2004 : Rearrange function to call ValidateUpdate.
function RepeatClickHandler(evt) {
	var elem = document.getElementById('Repeat');
	if ((elem)&&(elem.disabled)) return false;

	if (ValidateUpdate()) {
		var frm=document.forms['fPAAllergy_EditEMR'];
		return epr_RepeatClickHandler(evt,frm);
	}
	return false;
}

function InitAllergen() {
	var Aller = document.getElementById('ALGDescCT');
	if (Aller) Aller.value = "";
}

function DisableFields() {
	// Disable REPEAT when opening an EXISTING allergy
	// Disable DELETE when opening a NEW allergy
	var objID = document.getElementById('ID');
	var objRepeat = document.getElementById('Repeat');
	var objDelete = document.getElementById('Delete');
	var objCanMarkID = document.getElementById('OnlyDoctorCanMarkInactive');
	var objInactive = document.getElementById('ALGInActive');
	var objAuditLink=document.getElementById('AuditTrailData');
	if (objID) {
		if (objID.value!="") {
			// existing allergy
			if (objRepeat) {
				objRepeat.disabled=true;
				objRepeat.onclick=LinkDisable;
			}
			if (objDelete) {
				if (objCanMarkID && objCanMarkID.value != "1") {
					objDelete.disabled=true;
					objDelete.onclick = LinkDisable;
				} else {
					objDelete.disabled=false;
					objDelete.onclick=Delete_click;
				}
			}
		} else {
			// new allergy
			if (objRepeat) {
				objRepeat.disabled=false;
				objRepeat.onclick=RepeatClickHandler;
			}
			if (objDelete) {
				objDelete.disabled=true;
				objDelete.onclick=LinkDisable;
			}
			// Log 53061 YC - Disable audit trail when adding new
			if (objAuditLink) {
				objAuditLink.disabled=true;
				objAuditLink.onclick=LinkDisable;
			}
		}
	}
	if (objCanMarkID && objInactive) {
		if (objCanMarkID.value != "1") {
			objInactive.disabled=true;
			objInactive.onclick = LinkDisable;
		} else {
			objInactive.disabled=false;
			objInactive.onclick = InActiveClickHandler;
		}
	}
	DrugOnly();
}

function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	if (el.disabled==true) {
		return false;
	}
	return true;
}

/*function MRCATDesc_changehandler(encmeth) {
	evtName='MRCATDesc';
  evtTimer=window.setTimeout("MRCATDesc_changehandlerX('"+encmeth+"');",200);
  var Aller = document.getElementById('ALGDescCT');
	if (Aller) Aller.value = "";
}*/

function CategoryLookup(str) {
	try {
		CustomCategoryLookup();
		} catch(e) { }
	finally {
	
	var lu=str.split("^");
	
	var obj=document.getElementById("CategoryRowId");
	
	if ((obj)&&(obj.value==lu[1])) return;
	
	
	// ab 20.04.05 - 50874
	var obj=document.getElementById("ALGDescCT");
	if (obj) obj.value="";
	
	var obj=document.getElementById("MRCATTagDescription");
	if (obj) obj.value=lu[3];
	//if (obj) alert("MRCATTagDescription"+obj.value);
	var obj=document.getElementById("CategoryRowId");
	if (obj) obj.value=lu[1];
	//if (obj) alert("CategoryRowId"+obj.value);
	var obj=document.getElementById("TagCode");
	if (obj) obj.value=lu[4];
	//if (obj) alert("TagCode"+obj.value);
	
    
	//DrugOnly();
	
	}
}

function AllergenLookup(str) {
	//alert(str)
	//get category for use in websysSaveAllergen
	try {
		CustomAllergenLookup(str);
		} catch(e) { }
	finally {
	
	var lu=str.split("^");
	
	var obj=document.getElementById("AllergenCat");
	if (obj) obj.value=lu[3];
	
	/*
	// cjb 07/02/2005 49286
	var obj=document.getElementById("MRCATDesc");
	//md 23/03/2005 51223
	if ((obj)&&(obj.value=="")) obj.value=lu[3];
	*/
	
	var obj=document.getElementById("MRCATDesc");
	if ((obj)&&(obj.value=="")) obj.value=lu[3];
	var obj=document.getElementById("MRCATTagDescription");
	if (obj) obj.value=lu[4];
	var obj=document.getElementById("CategoryRowId");
	if ((obj)&&(obj.value=="")) obj.value=lu[5];
	var obj=document.getElementById("TagCode");
	if (obj) obj.value=lu[6];
	var obj=document.getElementById("AllergenRowId");
	if (obj) obj.value=lu[1];
	var obj=document.getElementById("table");
	if (obj) obj.value=lu[7];

	CheckReasonForChange();
	
	//DrugOnly();
	
	}
}

function TagLookup(str) {
	//alert(str);
	var lu=str.split("^");
	var objTagCode=document.getElementById("TagCode");
	
	if ((objTagCode)&&(objTagCode.value==lu[2])) return;
	
	var obj=document.getElementById("MRCATDesc");
	if (obj) obj.value="";
	var obj=document.getElementById("CategoryRowId");
	if (obj) obj.value="";
	var obj=document.getElementById("ALGDescCT");
	if (obj) obj.value="";
	var obj=document.getElementById("AllergenRowId");
	if (obj) obj.value="";
	
	
	if (objTagCode) objTagCode.value=lu[2];
	
	DrugOnly();
	
}


function InActiveClickHandler() {
	CheckReasonForChange();
}

function CheckReasonForChange() {
	// Reason for change is mandatory if:
	//  InActive,
	//  (unless allergen is 'Nil Allergy')

	var objInAct = document.getElementById('ALGInActive');
	var objNilAller = document.getElementById('NilAllergy');
	var objAllergen = document.getElementById('ALGDescCT');
	var objReason = document.getElementById('cReasForChange');
	//alert(objInAct.checked + '\n' + objReason + '\n' + objAllergen.value + '\n' + objNilAller.value);

	if (objInAct && objReason && objAllergen && objNilAller) {
		if ( objInAct.checked && (objAllergen.value != objNilAller.value) ) {
			objReason.className = "clsRequired";
		} else {
			objReason.className = "";
		}
	}
}

// cjb 26/04/2005 51228 - only enable the ALGDrugSpecific checkbox if the TagCode is P
function DrugOnly() {
	
	var objTagCode=document.getElementById('TagCode');
	var objDrugOnly=document.getElementById('ALGDrugSpecific');
	
	
	if (objTagCode && objDrugOnly) {
		
		if (objTagCode.value!="P") {
			
			DisableField("ALGDrugSpecific")
			
		} else {
			EnableField("ALGDrugSpecific")
			
		}
		
	}
}

document.body.onload = AllergyBodyLoadHandler;


