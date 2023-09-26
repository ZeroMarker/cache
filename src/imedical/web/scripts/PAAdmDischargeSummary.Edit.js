//Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

//alert(window.parent.parent.name);
//alert(window.parent.name);
//alert(window.name);

// only refresh the epr.chartbook if we are included on it....
var frmDSEdit = document.forms["fPAAdmDischargeSummary_Edit"];
var tblDSEdit=document.getElementById("tPAAdmDischargeSummary_Edit");

if ((window.parent.parent!=top)&&(window.name=="dataframe")) {
	frmDSEdit.elements['TFRAME'].value=window.parent.parent.name;
} else {
	frmDSEdit.elements['TWKFL'].value="";
}


var lstItems=frmDSEdit.elements['DistributedList'];
if (lstItems) {
	lstItems.multiple=false;
	lstItems.onchange = DistributedListChangeHandler;
}
var distAry = new Array();

function PreviewClick(e) {
	//var previewurl = "../custom/TRAKDEV/reports/showparams.rpt?init=actx&prompt0=hello&prompt1=hello&prompt2=hello&prompt3=hello&prompt4=hello&prompt5=hello&prompt6=hello&prompt7=hello&prompt8=hello";
	//alert(previewurl);
        //Log 59598 - BC - 30-06-2006 : remove statusbar variable (status=) to display the status bar.
	//websys_createWindow(previewurl,"REPORTWINDOW","width=460,height=380,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes")
	//return false;
}


// Perform all the setup and initialisation logic.
function PAAdmDischargeSummaryEdit_BodyLoad() {
	var objUpdate=document.getElementById("PAAdmDischargeSummaryEdit_Update");
	if (objUpdate) objUpdate.onclick=PAAdmDischargeSummaryEdit_UpdateClickHandler;

	// Log 52572 - AI - 30-05-2005 : Remove the component-defined ALT-"U" and replace with a javascript-defined function that is still ALT-"U". Defined in epr.chart.csp.
	websys_sckeys['U']=PAAdmDischargeSummaryEdit_UpdateClickHandler;
	tsc['PAAdmDischargeSummaryEdit_Update']="Update";

	var objUpdatePreview=document.getElementById("UpdatePreview");
	if (objUpdatePreview) objUpdatePreview.onclick=PAAdmDischargeSummaryEdit_UpdatePreviewClickHandler;
	var objdeletedist1=document.getElementById("deletedist1");

	//var objUpdatePrev=document.getElementById("UpdatePreview");
	//if (objUpdatePrev) objUpdatePrev.onclick=PreviewClick;

	// Log 57664 - AI - 13-03-2006 : Define "DeleteDS" button.
	var objDeleteThisDS=document.getElementById("DeleteThisDS");

	var objCanUpdate=frmDSEdit.elements['CanUpdate'];
	var objDisabled=frmDSEdit.elements['DISStatus'];

	if (objUpdate && objDisabled && objDisabled.disabled) {
		objUpdate.disabled = true;
		objUpdate.onclick = LinkDisable;
	}

	if (objCanUpdate) {
		if (objCanUpdate.value!=1) {
			if (objUpdate) {
				objUpdate.disabled = true;
				objUpdate.onclick = LinkDisable;
				DisablePrompts();
			}
			if(UpdatePreview) {
				objUpdatePreview.disabled = true;
				objUpdatePreview.onclick = LinkDisable;
				DisablePrompts();
			}
			if(objdeletedist1) {
				objdeletedist1.disabled = true;
				objdeletedist1.onclick = LinkDisable;
				DisablePrompts();
			}
			iNumElems = frmDSEdit.elements.length;
			for (var i=0; i<iNumElems; i++)	{
				var eElem = frmDSEdit.elements[i];
				if ((eElem.tagName=="INPUT")&&(eElem.type=="text")) {
					eElem.disabled = true;
				}
				if (eElem.type=="textarea") {
					ReadOnly(eElem);
				}
			}
			// Log 49247 YC - Disable lookups when in read only mode
			imgArray = frmDSEdit.getElementsByTagName('img');	//get all imgs in this form
			for(imgs=0; imgs<imgArray.length; imgs++)
			{
				if(imgArray[imgs].id.substring(0,7)=="ld1839i") //is a lookup
				{
					imgArray[imgs].disabled = true;
					imgArray[imgs].onclick = LinkDisable;
				}
			}
			// end Log 49247
			// Log 57664 - AI - 13-03-2006 : Disable "DeleteDS" when in read-only mode.
			if(objDeleteThisDS) {
				objDeleteThisDS.disabled = true;
				objDeleteThisDS.onclick = LinkDisable;
			}
			// end Log 57664
		}
	}

	var objdeletedist1=document.getElementById("deletedist1");
	if (objdeletedist1) objdeletedist1.onclick=DeleteDistClickHandler;

	var objDISDate=frmDSEdit.elements['DISDate'];
	if (objDISDate) objDISDate.onblur = DISDateBlurHandler;

	// Log 48288 - AI - 21-01-2005 : Handlers for the "Status" field and the new "Mode of Separation" field.
	var objStatusDesc=frmDSEdit.elements['DISStatus'];
	if (objStatusDesc) objStatusDesc.onblur=StatusDescBlurHandler;

	var objCTDSPDesc=frmDSEdit.elements['CTDSPDesc'];
	if (objCTDSPDesc) objCTDSPDesc.onblur=CTDSPDescBlurHandler;
	  // There was a call to CheckMandatoryMOS here, but was moved to the custom script because the custom script is not loaded before this code runs on load.
	  //   ie. It works by loading generic script then executing generic script, then loading custom script and executing custom script ...
	// end Log 48288.

	// cjb 24/01/2005 48979 - now done in the component
	/*
	var obj=frmDSEdit.elements['REFDoctorClinic'];
	if (obj) obj.onkeydown=REFDDesc_lookuphandlerCustom;
	var obj=frmDSEdit.elements['ld1839iREFDoctorClinic'];
	if (obj) obj.onclick=REFDDesc_lookuphandlerCustom;
	*/

	var obj=frmDSEdit.elements['CTPCPDesc'];
	if (obj) {
		obj.onblur=CTPCPDescBlurHandler;
		// Log 45645 - AI - 13-04-2005 : If "Contact Doctor" is on the layout, and blank, blank out the CP detail fields.
		var obj2=frmDSEdit.elements['CTPCPDesc2'];
		if ((obj.value=="")&&(!obj2)) {
			var obj1=frmDSEdit.elements['CPTypeDesc'];
			if (obj1) obj1.value="";
			var obj1=frmDSEdit.elements['CTPCPContactNumbers'];
			if (obj1) obj1.value="";
			var obj1=frmDSEdit.elements['CTPCPBestContactTime'];
			if (obj1) obj1.value="";
			var obj1=frmDSEdit.elements['DISResourceDR'];
			if (obj1) obj1.value="";
		}
		// end Log 45645
	}

	// Log 45645 - AI - 13-04-2005 : The handler for the alternate "Contact Resource" lookup.
	var obj=frmDSEdit.elements['CTPCPDesc2'];
	if (obj) {
		obj.onblur=CTPCPDesc2BlurHandler;
		var obj2=frmDSEdit.elements['CTPCPDesc'];
		if (obj.value=="") {
			var obj1=frmDSEdit.elements['CPTypeDesc'];
			if (obj1) obj1.value="";
			var obj1=frmDSEdit.elements['CTPCPContactNumbers'];
			if (obj1) obj1.value="";
			var obj1=frmDSEdit.elements['CTPCPBestContactTime'];
			if (obj1) obj1.value="";
			var obj1=frmDSEdit.elements['DISResourceDR'];
			if (obj1) obj1.value="";
		}
	}
	// end Log 45645

	// Don't allow users to touch the data stored in this field. We need this field enabled so the scrollbars are enabled.
	var obj=frmDSEdit.elements['IndividualDisplay'];
	if (obj) {
		obj.onfocus=DoNotAllow;
		obj.onkeydown=DoNotAllow;
		obj.style.color="gray";
		// stops copying and pasting
		obj.ondragstart=DoNotAllow;
		obj.onselectstart=DoNotAllow;
		obj.oncontextmenu=DoNotAllow;
	}

	// Don't allow users to touch the data stored in this field. We need this field enabled so the scrollbars are enabled.
	var obj=frmDSEdit.elements['CTPCPContactNumbers'];
	if (obj) {
		obj.onfocus=DoNotAllow;
		obj.onkeydown=DoNotAllow;
		obj.style.color="gray";
		// stops copying and pasting
		obj.ondragstart=DoNotAllow;
		obj.onselectstart=DoNotAllow;
		obj.oncontextmenu=DoNotAllow;
	}

	// Load StoredDistList (built in web.PADischargeSummaryRefDoc.GetStoredDistList) into REAL array.
	var objStoredDistList=frmDSEdit.elements['StoredDistList'];
	var str=objStoredDistList.value;

	if (str!="") {
		var lu = str.split("*");
		for(j=0; j<lu.length; j++) {
			var lu1=lu[j].split("^");
			// lu1[0]=childsub; lu1[1]=docid; lu1[2]=docdesc; lu1[3]=clinid; lu1[4]=clindesc.
			// NOTE: The clinid is only the Childsub ID for the javascript - the save forms the RowID.
			distAry[j]=new distRecord(lu1[0],lu1[1],lu1[2],lu1[3],lu1[4]);
			var code=lu1[0]+"^"+lu1[1]+"^"+lu1[3];
			var desc="";
			var ludoc=lu1[2].split("|");
			var luclin=lu1[4].split("|");
			desc=ludoc[0];
			if (ludoc[1]!="") desc=desc+" "+ludoc[1];
			if (ludoc[2]!="") desc=desc+" "+ludoc[2];
			if (ludoc[3]!="") desc=desc+" "+ludoc[3];
			if (luclin[0]!="") desc=desc+", "+luclin[0];
			if (luclin[1]!="") desc=desc+", "+luclin[1];
			if (luclin[2]!="") desc=desc+", "+luclin[2];
			if (luclin[3]!="") desc=desc+", "+luclin[3];
			if (luclin[4]!="") desc=desc+", "+luclin[4];
			if (luclin[4]!="") desc=desc+", "+luclin[5];
			if (lstItems) lstItems[lstItems.length]=new Option(desc,code);
		}
		//KB Log 60248 making a default selection if there are entries in the distribute List
		if (!lstItems.SelectedIndex) lstItems.options[0].selected=true;
		else lstItems.options[lstItems.SelectedIndex].selected=true;
		//end log 60248
	}

	// Log 57664 - AI - 13-03-2006 : The "DeleteDS" Click Handler.
	if (objDeleteThisDS) objDeleteThisDS.onclick=DeleteThisDSClickHandler;
	// end Log 57664

	// Log 64220 YC - Onload to see distribute to details in details box
	DistributedListChangeHandler();
}


function ReadOnly(obj) {
	obj.onfocus=DoNotAllow;
	obj.onkeydown=DoNotAllow;
	obj.style.color="gray";
}

function DoNotAllow() {
	return false;
}

function DisablePrompts() {
	var frmDSEdit = document.forms["fPAAdmDischargeSummary_Edit"];
}

function LinkDisable(e) {
	var el = websys_getSrcElement(e);
	if (el.disabled) {
		return false;
	}
	return true;
}

function CheckMandatoryStatus(statuscode) {
	// Dummy function used in QLD custom script

}

// Log 48288 - AI - 21-01-2005 : New custom function for QLD to mark Discharge Destination as mandatory depending on Mode of Separation (Discharge Type).
function CheckMandatoryMOS(MOSCode) {
	// Dummy function used in QLD custom script
}
// end Log 48288

function MandatoryField(fldName) {
	var fld = frmDSEdit.elements[fldName];
	var lbl = document.getElementById("c"+fldName);
	// Log 50651 YC - Don't make a field mandatory if it is disabled
	if (fld && fld.disabled!=true) {
		fld.disabled = false;
		// Log 53282 YC - fld.className holds whether the field is invalid or not
		// we cannot clear it or it will never be clsInvalid.
		//fld.className = "";
		if (lbl) lbl.className = "clsRequired";
	}
}

function UnMandatoryField(fldName) {
	var fld = frmDSEdit.elements[fldName];
	var lbl = document.getElementById("c"+fldName);
	if (fld) {
		if (lbl) lbl.className = "";
	}
}

function DISDateBlurHandler() {
	// invalidflg : 0 if not invalid; 1 if invalid vs admdate; 2 if invalid vs today+7; 3 if invalid vs both 1 and 2.
	var objDISDate=frmDSEdit.elements['DISDate'];
	var invalidflg="";
	invalidflg=IsValidDisDate();
	// shouldn't ever get set to 3, but you never know ...
	if ((invalidflg==1)||(invalidflg==3)) {
		alert(t['InvalidAdmDate']);
	}
	if ((invalidflg==2)||(invalidflg==3)) {
		alert(t['InvalidTodayPlus7']);
	}

	if (invalidflg!=0) {
		objDISDate.className="clsInvalid";
		websys_setfocus('DISDate');
		return false;
	}

	objDISDate.className="";
	return true;
}

// Log 48288 - AI - 21-01-2005 : New Blur Handlers for the "Status" field and the new "Mode of Separation" field.
function StatusDescBlurHandler() {
	var objStatusDesc=frmDSEdit.elements['DISStatus'];
	if ((objStatusDesc)&&(objStatusDesc.value=="")) {
		CheckMandatoryStatus(objStatusDesc.value);
	}
}

function CTDSPDescBlurHandler() {
	var objCTDSPCode=frmDSEdit.elements['CTDSPCode'];
	var objCTDSPDesc=frmDSEdit.elements['CTDSPDesc'];
	if ((objCTDSPCode)&&(objCTDSPCode)) {
		if (objCTDSPDesc.value=="") objCTDSPCode.value="";
		CheckMandatoryMOS(objCTDSPCode.value);
	}
}
// end Log 48288

function IsValidDisDate() {
	// invalidflg : 0 if not invalid; 1 if invalid vs admdate; 2 if invalid vs today+7; 3 if invalid vs both 1 and 2.
	// shouldn't ever get set to 3, but you never know ...
	var objDISDate=frmDSEdit.elements['DISDate'];
	var objtoday=frmDSEdit.elements['today'];
	var objLastAdmDate=frmDSEdit.elements['LastAdmDate'];
	var invalidflg=0;
	var DISDateHval="";

	// objDISDate.value must be greater than or equal to the Admission Date of the last linked Episode.
	// Log 59294 - Admission Date is now a string (changed on component).
	if ((objDISDate)&&(objDISDate.value!="")&&(objLastAdmDate)) {
		if (DateStringCompare(objDISDate.value,objLastAdmDate.value)==-1) {
			invalidflg=1;
		}
	}

	// objDISDate.value must be less than or equal to (today + 7 days).
	// Log 59294 - Component item 'today' is no longer used.
	if ((objDISDate)&&(objDISDate.value!="")) {
		if (DateStringCompareToday(objDISDate.value)==1) {
			var arrdiff=DateStringDifferenceToday(objDISDate.value);
			if (arrdiff['dy']>7) {
				// shouldn't ever get set to 3, but you never know ...
				if (invalidflg==1) invalidflg=3;
				if (invalidflg==0) invalidflg=2;
			}
		}
	}
	// end Log 59294

	return invalidflg;
}

function DISStatusLookUp(str) {
	var lu = str.split("^");
	var objStatusCode=frmDSEdit.elements['StatusCode'];
	if (objStatusCode) objStatusCode.value=lu[1];
	CheckMandatoryStatus(lu[1]);
}

// Log 48288 - AI - 21-01-2005 : Lookup for the new "Mode of Separation" field.
function CTDSPDescLookUp(str) {
	var lu = str.split("^");
	var objCTDSPCode=frmDSEdit.elements['CTDSPCode'];
	if (objCTDSPCode) objCTDSPCode.value=lu[2];
	CheckMandatoryMOS(lu[2]);
}
// end Log 48288.

// Log 52389 - AI - 23-05-2005 : Lookup for the "Discharge Destination" field.
function DDESTDescLookUp(str) {
	var lu = str.split("^");
	var objDDESTCode=frmDSEdit.elements['DDESTCode'];
	if (objDDESTCode) objDDESTCode.value=lu[2];
}
// end Log 48288.

function REFDoctorClinicLookUp(str) {
	var lu = str.split("^");
	var docid = lu[4];
	var clinid = "";
	if (lu[8]!="") {
		clinidpart = lu[8].split("||");
		// in the javascript, we are only using the Childsub ID. The save forms the RowID.
		clinid = clinidpart[1];
	}
//if (docid!=clinidpart[0]) alert("There is something very wrong with the two IDs");

	if ((lstItems)&&(docid!="")) {
		//Check selected Ref doctor/Clinic not already in Listbox.
		for(i=0; i<distAry.length; i++) {
			if ((distAry[i].docid==docid)&&(distAry[i].clinid==clinid)) {
				alert(t['AlreadyExists']);
				// Clear LookUp.
				var obj=frmDSEdit.elements['REFDoctorClinic'];
				if (obj) obj.value="";
				// Mark the existing list item as the selected one.
				lstItems.selectedIndex=i;
				return false;
			}
		}

		// Build the record fields.
		var doctitle=lu[0];
		var docforename=lu[3];
		var docmiddlename=lu[2];
		var docsurname=lu[1];
		var clinpreferredcontactmethod;
		var clinprefcontactmethodcode;
		var docdesc=doctitle + "|" + docforename + "|" + docmiddlename + "|" + docsurname;
		if ((!clinid)||(clinid=="")) {
			var doctoraddress=lu[28];
			var lu1=doctoraddress.split("|");
			var clinname="";
			var clinaddress1=lu1[0];
			var clinaddress2=lu1[1];
			var clincity=lu1[2];
			if ((clincity=="")&&(lu[25]!="")) clincity=lu[25];
			var clinzipcode=lu1[3];
			if ((clinzipcode=="")&&(lu[21]!="")) clincity=lu[21];
			clinpreferredcontactmethod=lu[27];
			// Log 57128 YC - add contact method code
			clinprefcontactmethodcode=lu[32];
		} else {
			var clinname=lu[17]
			var clinaddress1=lu[10];
			var clinaddress2=lu[23];
			var clincity=lu[18];
			var clinzipcode=lu[19];
			var clinpreferredcontactmethod=lu[24];
			// Log 54011 - AI - 22-07-2005 : If the Clinic's Preferred Contact Method is blank, use the Doctor's Preferred Contact Method. Passed in as a hidden field, 32nd piece.
			if (clinpreferredcontactmethod=="") clinpreferredcontactmethod=lu[31];
			// end Log 54011
			// Log 57128 YC - add contact method code
			clinprefcontactmethodcode=lu[33];
		}

		var num=lstItems.length;

		// Log 57128 YC - add contact method code
		var clindesc=clinname + "|" + clinaddress1 + "|" + clinaddress2 + "|" + clincity + "|" + clinzipcode + "|" + clinpreferredcontactmethod  + "|" + clinprefcontactmethodcode;
		var combinedid=num + "^" + docid + "^" + clinid;
		var combineddesc=doctitle + " " + docforename + " " + docmiddlename + " " + docsurname + ", " + clinname + "," +clinaddress1 + ", " + clinaddress2 + ", " + clincity + ", " + clinzipcode + ", " + clinpreferredcontactmethod;

		// Add selected LookUp item into Listbox.
		lstItems[num]=new Option(combineddesc,combinedid);
		// Add selected LookUp item into Array.
		var childsub=(distAry.length)+1;
		buildAry(childsub,docid,docdesc,clinid,clindesc);

		// Clear LookUp.
		var obj=frmDSEdit.elements['REFDoctorClinic'];
		if (obj) obj.value="";
		// make the new entry the selected one.
		lstItems.selectedIndex=num;

		// Refresh the Individual Distribution Display field with this new entry.
		DistributedListChangeHandler();
	}
}

function CTPCPDescBlurHandler() {
	var obj=frmDSEdit.elements['CTPCPDesc'];
	if ((obj)&&(obj.value=="")) {
		var obj1=frmDSEdit.elements['CPTypeDesc'];
		if (obj1) obj1.value="";
		var obj1=frmDSEdit.elements['CTPCPContactNumbers'];
		if (obj1) obj1.value="";
		var obj1=frmDSEdit.elements['CTPCPBestContactTime'];
		if (obj1) obj1.value="";
	}
}

// Log 45645 - AI - 13-04-2005 : The handler for the alternate "Contact Resource" lookup.
function CTPCPDesc2BlurHandler() {
	var obj=frmDSEdit.elements['CTPCPDesc2'];
	if ((obj)&&(obj.value=="")) {
		var obj1=frmDSEdit.elements['CPTypeDesc'];
		if (obj1) obj1.value="";
		var obj1=frmDSEdit.elements['CTPCPContactNumbers'];
		if (obj1) obj1.value="";
		var obj1=frmDSEdit.elements['CTPCPBestContactTime'];
		if (obj1) obj1.value="";
		var obj1=frmDSEdit.elements['DISResourceDR'];
		if (obj1) obj1.value="";
	}
}
// end Log 45645

function CTPCPDescLookUp(str) {
	var lu = str.split("^");
	var obj=frmDSEdit.elements['CPTypeDesc'];
	if (obj) obj.value=lu[4];
	var obj=frmDSEdit.elements['CTPCPContactNumbers'];
	if (obj) obj.value=t['office'] + lu[5] + String.fromCharCode(13,10) + t['ext'] + lu[6] + String.fromCharCode(13,10) + t['pager'] + lu[7];
	var obj=frmDSEdit.elements['CTPCPBestContactTime'];
	if (obj) obj.value=lu[8];
}

// Log 45645 - AI - 13-04-2005 : The handler for the alternate "Contact Resource" lookup.
function CTPCPDesc2LookUpHandler(str) {
	var lu = str.split("^");
	var obj=frmDSEdit.elements['CPTypeDesc'];
	if (obj) obj.value=lu[10];
	var obj=frmDSEdit.elements['CTPCPContactNumbers'];
	if (obj) obj.value=t['office'] + lu[11] + String.fromCharCode(13,10) + t['ext'] + lu[12] + String.fromCharCode(13,10) + t['pager'] + lu[13];
	var obj=frmDSEdit.elements['CTPCPBestContactTime'];
	if (obj) obj.value=lu[14];
	var obj=frmDSEdit.elements['DISResourceDR'];
	if (obj) obj.value=lu[3];
}
// end Log 45645

function DistributedListChangeHandler() {
	if (lstItems) {
		var j=lstItems.selectedIndex;
		if (j!=-1) {
			var objInd=frmDSEdit.elements['IndividualDisplay'];
			if (objInd) {
				var lu1=distAry[j].docdesc;
				var lu2=distAry[j].clindesc;
				var desc="";
				var ludoc=lu1.split("|");
				var luclin=lu2.split("|");
				desc=ludoc[0];
				if (ludoc[1]!="") desc=desc+" "+ludoc[1];
				if (ludoc[2]!="") desc=desc+" "+ludoc[2];
				if (ludoc[3]!="") desc=desc+" "+ludoc[3];
				if (luclin[0]!="") desc=desc+String.fromCharCode(13,10)+luclin[0];
				if (luclin[1]!="") desc=desc+String.fromCharCode(13,10)+luclin[1];
				if (luclin[2]!="") desc=desc+String.fromCharCode(13,10)+luclin[2];
				if (luclin[3]!="") desc=desc+String.fromCharCode(13,10)+luclin[3];
				if (luclin[4]!="") desc=desc+",  "+luclin[4];
				if (luclin[5]!="") desc=desc+String.fromCharCode(13,10)+t['PreferredContactMethod']+" "+luclin[5];
				objInd.value=desc;
			}
		}
	}
}

function buildAry(childsub,docid,docdesc,clinid,clindesc) {
	if (lstItems) {
		tmpAry = new distRecord(childsub,docid,docdesc,clinid,clindesc);
		//var j=lstItems.selectedIndex;
		//if (j==-1) j=lstItems.length-1;
		var j=lstItems.length-1;
		distAry[j] = tmpAry;
	}
}

// The layout of a record
function distRecord(childsub,docid,docdesc,clinid,clindesc) {
	this.childsub=childsub;
	this.docid=docid;
	this.docdesc=docdesc;
	this.clinid=clinid;
	this.clindesc=clindesc;
}

function DeleteDistClickHandler() {
	if (lstItems) {
		var j=lstItems.selectedIndex;
		if (j!=-1) {
			// Remove selected item from Array.
			distAry.splice(j,1);
			// Remove selected item from Listbox.
			lstItems.remove(j);
			// Clear out the Individual Display.
			var objInd=frmDSEdit.elements['IndividualDisplay'];
			if (objInd) objInd.value="";
			websys_setfocus('REFDoctorClinic');
		}
		//KB log 60248
		if (lstItems.length > 0) lstItems.options[0].selected = true;
	}
	DistributedListChangeHandler();
	return false;
}

// Log 57664 - AI - 13-03-2006 : The "DeleteDS" Click Handler.
function DeleteThisDSClickHandler() {
	var objDeleteThisDS=document.getElementById("DeleteThisDS");
	if (objDeleteThisDS.disabled == true) {
		return false;
	}
	var ret=true;
	ret=confirm(t['AreYouSureDeleteThisDS']+"\n"+t['OK_CANCEL']);
	if (ret==false) {
		return false;
	} else {
		return DeleteThisDS_click();
	}
}
// end Log 57664



// Logic performed when User clicks "Update".

// ****************************************************************************************
// NOTE: For now, we have copied ALL of this logic into the Update/Preview function, below.
// ****************************************************************************************

function PAAdmDischargeSummaryEdit_UpdateClickHandler() {
	var objUpdate=document.getElementById("PAAdmDischargeSummaryEdit_Update");
	if (objUpdate.disabled == true) {
		return false;
	}

	var msg="";
	var field;
	var lblDISDate=document.getElementById("cDISDate");
	if ((lblDISDate)&&(lblDISDate.className == "clsRequired")) {
		var obj=frmDSEdit.elements['DISDate'];
		if (obj.value=="") {
			msg=t['DISDate_Status_A'];
			if(!field) field="DISDate";
		}
	}

	// Log 48288 - AI - 21-01-2005 : Check the new "Mode of Separation" field before updating.
	var lblCTDSPDesc=document.getElementById("cCTDSPDesc");
	if ((lblCTDSPDesc)&&(lblCTDSPDesc.className == "clsRequired")) {
		var obj=frmDSEdit.elements['CTDSPDesc'];
		if (obj.value=="") {
			if (msg!="") msg=msg + String.fromCharCode(13,10) + t['CTDSPDesc_Status_A'];
			if (msg=="") msg=t['CTDSPDesc_Status_A'];
			if(!field) field="CTDSPDesc";
		}
	}
	// end Log 48288

	var lblDDESTDesc=document.getElementById("cDDESTDesc");
	if ((lblDDESTDesc)&&(lblDDESTDesc.className == "clsRequired")) {
		var obj=frmDSEdit.elements['DDESTDesc'];
		if (obj.value=="") {
			if (msg!="") msg=msg + String.fromCharCode(13,10) + t['DDESTDesc_Status_A'];
			if (msg=="") msg=t['DDESTDesc_Status_A'];
			if(!field) field="DDESTDesc";
		}
	}
	var lblDISPrincipalDiagnosis=document.getElementById("cDISPrincipalDiagnosis");
	if ((lblDISPrincipalDiagnosis)&&(lblDISPrincipalDiagnosis.className == "clsRequired")) {
		var obj=frmDSEdit.elements['DISPrincipalDiagnosis'];
		if (obj.value=="") {
			if (msg!="") msg=msg + String.fromCharCode(13,10) + t['DISPrincipalDiagnosis_Status_A'];
			if (msg=="") msg=t['DISPrincipalDiagnosis_Status_A'];
			field="DISPrincipalDiagnosis";
		}
	}

	//RTFs L:65739 --DAH
	//Treating Clinicians RTF
	var DISTreatingCliniciansRTFx=document.getElementById("DISTreatingCliniciansRTFx");
	var DISTreatingClinicians=document.getElementById("DISTreatingClinicians");
	var DISTreatingCliniciansRTF=document.getElementById("DISTreatingCliniciansRTF");
	if (DISTreatingCliniciansRTFx) {
		DISTreatingCliniciansRTF.value=DISTreatingCliniciansRTFx.TextRTF;
		DISTreatingClinicians.value=DISTreatingCliniciansRTFx.Text;
	}

	//Comment01 RTF
	var DISComment01RTFx=document.getElementById("DISComment01RTFx");
	var DISComment01RTF=document.getElementById("DISComment01RTF");
	var DISComment01=document.getElementById("DISComment01");
	if (DISComment01RTFx) {
		DISComment01RTF.value=DISComment01RTFx.TextRTF;
		DISComment01.value=DISComment01RTFx.Text;
	}

	//Comment02 RTF
	var DISComment02RTFx=document.getElementById("DISComment02RTFx");
	var DISComment02RTF=document.getElementById("DISComment02RTF");
	var DISComment02=document.getElementById("DISComment02");
	if (DISComment02RTFx) {
		DISComment02RTF.value=DISComment02RTFx.TextRTF;
		DISComment02.value=DISComment02RTFx.Text;
	}

	//Comment03 RTF
	var DISComment03RTFx=document.getElementById("DISComment03RTFx");
	var DISComment03RTF=document.getElementById("DISComment03RTF");
	var DISComment03=document.getElementById("DISComment03");
	if (DISComment03RTFx) {
		DISComment03RTF.value=DISComment03RTFx.TextRTF;
		DISComment03.value=DISComment03RTFx.Text;
	}

	//Comment04 RTF
	var DISComment04RTFx=document.getElementById("DISComment04RTFx");
	var DISComment04RTF=document.getElementById("DISComment04RTF");
	var DISComment04=document.getElementById("DISComment04");
	if (DISComment04RTFx) {
		DISComment04RTF.value=DISComment04RTFx.TextRTF;
		DISComment04.value=DISComment04RTFx.Text;
	}

	//Comment05 RTF
	var DISComment05RTFx=document.getElementById("DISComment05RTFx");
	var DISComment05RTF=document.getElementById("DISComment05RTF");
	var DISComment05=document.getElementById("DISComment05");
	if (DISComment05RTFx) {
		DISComment05RTF.value=DISComment05RTFx.TextRTF;
		DISComment05.value=DISComment05RTFx.Text;
	}

	if (msg!="") {
		alert(msg);
		// Log 53282 YC - Focus on mandatory field
		if(field!="") {
			var obj=frmDSEdit.elements[field];
			if(obj) obj.focus();
		}
		return false;
	}

	if (!DISDateBlurHandler()) return false;

	// Re-build the StoredDistList component item - used in Class web.PADischargeSummaryRefDoc, method websysSaveDisSumRefDocs.
	var strBuffer="";
	for(j=0; j<distAry.length; j++) {
		if (strBuffer!="") strBuffer=strBuffer + "*" + distAry[j].childsub + "^" + distAry[j].docid + "^" + distAry[j].docdesc + "^" + distAry[j].clinid + "^" + distAry[j].clindesc;
		if (strBuffer=="") strBuffer=distAry[j].childsub + "^" + distAry[j].docid + "^" + distAry[j].docdesc + "^" + distAry[j].clinid + "^" + distAry[j].clindesc;
	}
	var obj = frmDSEdit.elements['StoredDistList'];
	if (obj) obj.value=strBuffer;

	return PAAdmDischargeSummaryEdit_Update_click();
}

// Logic performed when User clicks "Update/Preview".

// ***************************************************************************
// NOTE: For now, this is a copy of the logic from the Update function, above.
// ***************************************************************************

function PAAdmDischargeSummaryEdit_UpdatePreviewClickHandler() {
	var objUpdate=document.getElementById("UpdatePreview");
	if (objUpdate.disabled == true) {
		return false;
	}

	var msg=""
	var lblDISDate=document.getElementById("cDISDate");
	if ((lblDISDate)&&(lblDISDate.className == "clsRequired")) {
		var obj=frmDSEdit.elements['DISDate'];
		if (obj.value=="") {
			msg=t['DISDate_Status_A'];
		}
	}

	var lblDDESTDesc=document.getElementById("cDDESTDesc");
	if ((lblDDESTDesc)&&(lblDDESTDesc.className == "clsRequired")) {
		var obj=frmDSEdit.elements['DDESTDesc'];
		if (obj.value=="") {
			if (msg!="") msg=msg + String.fromCharCode(13,10) + t['DDESTDesc_Status_A'];
			if (msg=="") msg=t['DDESTDesc_Status_A'];
		}
	}
	var lblDISPrincipalDiagnosis=document.getElementById("cDISPrincipalDiagnosis");
	if ((lblDISPrincipalDiagnosis)&&(lblDISPrincipalDiagnosis.className == "clsRequired")) {
		var obj=frmDSEdit.elements['DISPrincipalDiagnosis'];
		if (obj.value=="") {
			if (msg!="") msg=msg + String.fromCharCode(13,10) + t['DISPrincipalDiagnosis_Status_A'];
			if (msg=="") msg=t['DISPrincipalDiagnosis_Status_A'];
		}
	}
	if (msg!="") {
		alert(msg);
		return false;
	}

	if (!DISDateBlurHandler()) return false;

	// Re-build the StoredDistList component item - used in Class web.PADischargeSummaryRefDoc, method websysSaveDisSumRefDocs.
	var strBuffer="";
	for(j=0; j<distAry.length; j++) {
		if (strBuffer!="") strBuffer=strBuffer + "*" + distAry[j].childsub + "^" + distAry[j].docid + "^" + distAry[j].docdesc + "^" + distAry[j].clinid + "^" + distAry[j].clindesc;
		if (strBuffer=="") strBuffer=distAry[j].childsub + "^" + distAry[j].docid + "^" + distAry[j].docdesc + "^" + distAry[j].clinid + "^" + distAry[j].clindesc;
	}
	var obj = frmDSEdit.elements['StoredDistList'];
	if (obj) obj.value=strBuffer;

	return UpdatePreview_click();
}

// cjb 24/01/2005 48979 - now done in the component
/*
// Copied from PAAdm.Edit.js ...
// KM 20-Nov-2001: over-writes one from SCRIPTS_GEN so that it can pass in the WEBSYS.TCOMPONENT value:
function REFDDesc_lookuphandlerCustom(e) {
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))) {
		var namevaluepairs="&P1=&P2=&P3=&P5";
		var obj=frmDSEdit.elements['REFDoctorClinic'];
		if (obj) {namevaluepairs="&P1="+obj.value;}
		REFDDesc_lookuphandlerCustom2(namevaluepairs);
	}
}

function REFDDesc_lookuphandlerCustom2(namevaluepairs) {
	var url='websys.lookup.csp';
	//url += "?ID=d1839iREFDoctorClinic&WEBSYS.TCOMPONENT=PACRefDoctor.CustomFind"+namevaluepairs;
	url += "?ID=d1839iREFDoctorClinic&WEBSYS.TCOMPONENT=PACRefDoctor.CustomFind&CONTEXT=Kweb.PACRefDoctor:LookUpDoctor&TLUJSF=REFDoctorClinicLookUp"+namevaluepairs;
	var tmp=url.split('%');
	url=tmp.join('%25');
        //Log 59598 - BC - 30-06-2006 : remove statusbar variable (status=) to display the status bar.
	websys_createWindow(url,"lookup","top=30,left=20,width=620,height=420,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
	return websys_cancel();
}
*/

// as the BodyLoadHandler function won't be called, call an initial function...
// Log 52572 - AI - 30-05-2005 : The body load is now called by epr.chart.csp (in the function eprLoadHandler).
//PAAdmDischargeSummaryEdit_BodyLoad;

































/* pre-April 2004 : Existing code commented out, as no longer valid.

function LookUpEpisodesHandler(str) {
	var lu=str.split("^");
	var obj=document.getElementById("EpisodeNo");
	if (obj) obj.value=lu[0];
	var obj=document.getElementById("DISCTLOCDR");
	if (obj) obj.value=lu[1];
	var obj=document.getElementById("EpisodeID");
	if (obj) obj.value=lu[2];
}

function LookUpDischSummTypeHandler(str) {
	var lu=str.split("^");
	var obj=document.getElementById("DISDischargeSummaryTypeDR");
	if (obj) obj.value=lu[1];
	var obj=document.getElementById("docType");
	if (obj) {
		obj.value=lu[2];
		if (obj.value=="W") {
			var obj=document.getElementById("TemplateName");
			if (obj) obj.value=lu[3];
			var obj=document.getElementById('DischargeReport');
			if (obj) obj.disabled=false; obj.onclick=UpdateDischargeDoc;
		} else {
			var obj=document.getElementById("TemplateName");
			if (obj) obj.value="";
			var obj=document.getElementById('DischargeReport');
			if (obj) obj.disabled=true; obj.onclick="";
		}
	}
}

function UpdateDischargeDoc() {
	DischargeReport_click();
	var objDisApp = new ActiveXObject("Word.Application");
	objDisApp.visible=true;
	if (objDisApp) {
		var objTemplatePath=document.getElementById('TemplatePath');
		if (objTemplatePath) {
			var strTemplatePath = objTemplatePath.value+"/"
			//if there is a word document already saved for this order item then show that document otherwise show template
			var objSavedFileName=document.getElementById('SavedFileName');
			if ((objSavedFileName) && (objSavedFileName.value!="")) {
				strSavedFileName=objSavedFileName.value;
				var objSaveFilePath=document.getElementById('SaveFilePath');
				if (objSaveFilePath) var strSaveFilePathArray=objSaveFilePath.value;
				var strSaveFilePath = mPiece(strSaveFilePathArray,";",0);
				var objDisDoc = objDisApp.Documents.Add(strSaveFilePath+strSavedFileName);
				if (objDisDoc) {
					var FileSavePath=FilePathAndName();
					try{
						objDisDoc.Variables.Delete("FileSavePath");
					} catch(e) {}
					try{
						objDisDoc.Variables.Add("FileSavePath",FileSavePath);
					} catch(e) {}
					try {
						objDisApp.Run("OpenDocument");
					} catch(e){}
				}
				return false;
			} else {
				var objTemplateName=document.getElementById('TemplateName');
				if (objTemplateName) {
					var strTemplateName=objTemplateName.value;
					if (strTemplateName=="") {
						return false;
					}
				}
				var objDisDoc = objDisApp.Documents.Add(strTemplatePath+strTemplateName);
				if (objDisDoc) {
					var objEpisodeID=document.getElementById("EpisodeID");
					if ((objEpisodeID)&&(objEpisodeID.value!="")) {
						var strEpisodeID=objEpisodeID.value;
						var strID="";
						var objDSN=document.getElementById('DSN');
						if (objDSN) var strDSN=objDSN.value
						var objID=document.getElementById("ID");
						if (objID) strID=objID.value;
						var objEpisodeNo=document.getElementById("EpisodeNo");
						if (objEpisodeNo) var strEpisodeNo=objEpisodeNo.value;
						var objDischDate=document.getElementById("DISDate");
						if (objDischDate) var strDischDate=objDischDate.value;
						var objPrincDiag=document.getElementById("DISPrincipalDiagnosis");
						if (objPrincDiag) var strPrincDiag=objPrincDiag.value;
						var objPatientID=document.getElementById("PatientID");
						if (objPatientID) var strPatientID=objPatientID.value;
						var objStatus=document.getElementById("DISStatus");
						if (objStatus) var strStatus=objStatus.value;

						var FileSavePath=FilePathAndName();
						// LOG 36629 RC 11/07/03
						//SaveFileName now gets the current document counter instead of the next one. This is because we only
						//want to update the document counter if the document is saved. So we have to dummy the save file name
						//by adding 1 to it so the document will save with the right file name.

						objSaveFileSubDir=document.getElementById('SaveFileSubDir');
						if (objSaveFileSubDir) var strSaveFileSubDir1=objSaveFileSubDir.value;
						objSaveFileName=document.getElementById('SaveFileName');
						if (objSaveFileName) var strSaveFileName1=objSaveFileName.value;
						var strSaveFileName1=parseInt(strSaveFileName1)
						strSaveFileName1=strSaveFileName1+1
						var strSubDirAndName=strSaveFileSubDir1+strSaveFileName1+".rtf";

						objDisDoc.Variables.Add("EpisodeID",strEpisodeID);
						objDisDoc.Variables.Add("ID",strID);
						objDisDoc.Variables.Add("EpisodeNo",strEpisodeNo);
						objDisDoc.Variables.Add("DischDate",strDischDate);
						objDisDoc.Variables.Add("PrincDiag",strPrincDiag);
						objDisDoc.Variables.Add("PatientID",strPatientID);
						objDisDoc.Variables.Add("Status",strStatus);
						objDisDoc.Variables.Add("FileSavePath",FileSavePath);
						objDisDoc.Variables.Add("SubDirAndName",strSubDirAndName);
						objDisDoc.Variables.Add("DSN",strDSN);
						try {
							objDisApp.Run("Medtrak");
						} catch(e){}
					}
					return false;
				}
			}
		}
	}
}

function FilePathAndName() {

	//SA: SaveFilePath is an delimited string of Paths separated by a semicolon (;)
	//The first path is the primary which will be saved via the code here
	//(in function "OpenWordDoc"). All other paths will be passed to the document
	//template to be saved on the Document_Close event.

	obj=document.getElementById('SaveFilePath');
	if (obj) var strSaveFilePathArray=obj.value

	obj=document.getElementById('SaveFileSubDir');
	if (obj) var strSaveFileSubDir=obj.value

	// LOG 36629 RC 11/07/03
	//SaveFileName now gets the current document counter instead of the next one. This is because we only want
	//to update the document counter if the document is saved. So we have to dummy the save file name by adding
	//1 to it so the document will save with the right file name.
	//
	obj=document.getElementById('SaveFileName');
	if (obj) var strSaveFileName=obj.value;
	strSaveFileName=parseInt(strSaveFileName);
	strSaveFileName=strSaveFileName+1;

	//not actually an array, but delimited string of paths separated by ";"
	//just easier to name this way to distinguish from single path.
	var FileSavePathsArray=""
	var i=0
	while (mPiece(strSaveFilePathArray,";",i)!="") {
		var strSaveFilePath = mPiece(strSaveFilePathArray,";",i)

		if ((strSaveFilePath!="") && (strSaveFileSubDir!="") && (strSaveFileName!="")) {
			// .doc/.rtf extension hardcoded to be saved for word documents only
			strFilePathAndName = strSaveFilePath+strSaveFileSubDir+strSaveFileName+".rtf";
				// .doc extension not used anymore.
				//strFilePathAndName = strSaveFilePath+strSaveFileSubDir+strSaveFileName+".doc";
			strFilePath = strSaveFilePath+strSaveFileSubDir;
		}
		CreateFilePath(strFilePath)
		FileSavePathsArray=FileSavePathsArray+strFilePathAndName
		i=i+1
	}
	//setting the hidden field in the form that will save the file name
	//(eg. "\20010327\1201.rtf") to OEORDResult.RESFileName
	var objFileName=document.getElementById('FilePathAndName');
	if (objFileName) {
		objFileName.value=strSaveFileSubDir+strSaveFileName+".rtf"
			// .doc extension not used anymore.
			//objFileName.value=strSaveFileSubDir+strSaveFileName+".doc"
	}
	return FileSavePathsArray
}

function CreateFilePath(FilePath) {
	var objFileSys = new ActiveXObject("Scripting.FileSystemObject");

	// SA: Check if directory for document to be saved exists. If not,create it.
	// A single backslash is a specific character in JS, so directory path must
	// have a second backslash for each backslash. Comparison also requires "\\"
	// when comparing "\"
	try {
		for (var i=0; i<FilePath.length; i++) {
			strFilePath+=FilePath.charAt(i);
			if (FilePath.charAt(i)=="\\") strFilePath+="\\";
		}
		if (!objFileSys.FolderExists(FilePath)) {
			objFileSys.CreateFolder(FilePath);
		}
	} catch(e) {
		alert("You do not have permission to create Folder "+e);
	}

}

function mPiece(s1,sep,n) {
	//Split the array with the passed delimeter
    var delimArray ="";
	delimArray = s1.split(sep);
	  //If out of range, return a blank string
    if ((n <= delimArray.length-1) && (n >= 0)) {
        return delimArray[n];
	} else {
	  return ""
    }
}

var obj=document.getElementById('DischargeReport');
var DSTobj=document.getElementById("DISDischargeSummaryTypeDR");
if ((obj)&&(DSTobj)) {
	var DTobj=document.getElementById("docType");
	if (DTobj) {
		if (DTobj.value=="W") {
			obj.disabled=false; obj.onclick=UpdateDischargeDoc;
		}
		else {
			obj.disabled=true; obj.onclick="";
			var TPLobj=document.getElementById("TemplateName");
			if (TPLobj) TPLobj.value="";
			var DISobj=document.getElementById("DISDischargeSummaryTypeDR");
			if (DISobj) DISobj.value="";
		}
	}
}

end of commented code */
