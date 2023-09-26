// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var lstItems=document.getElementById('HL7NumTypes');
var patAry = new Array();
Init();

function Init() {
	var obj=document.getElementById('HL7PNNumberType'); if (obj) obj.onfocus=HL7PNNumberTypeFocusHandler;
	// NumTypes: OnChange caters for UP and DOWN arrow key presses in a List Box. OnClick does not.
	var obj=document.getElementById('HL7NumTypes'); if (obj) obj.onchange=HL7NumTypesChangeHandler;
	var obj=document.getElementById('HL7PNSegmentType'); if (obj) obj.onblur=HL7PNSegmentTypeBlurHandler;
	var obj=document.getElementById('HL7PNSegmentField'); if (obj) obj.onchange=HL7PNSegmentFieldChangeHandler;
	var obj=document.getElementById('HL7PNAssignType'); if (obj) obj.onblur=HL7PNAssignTypeBlurHandler;
	var obj=document.getElementById('HL7PNAssignCode'); if (obj) obj.onchange=HL7PNAssignCodeChangeHandler;
	var obj=document.getElementById('HL7PNIdentCode'); if (obj) obj.onchange=HL7PNIdentCodeChangeHandler;
	var obj=document.getElementById('HL7PNIdentCodeMRType'); if (obj) obj.onchange=HL7PNIdentCodeMRTypeChangeHandler;
	// Log 39621 - AI - 09-10-2003 : Add handlers for new fields ContainsExpiryDate and ExpiryDateField.
	var obj=document.getElementById('HL7PNExpiryDate'); if (obj) obj.onclick=PNExpiryDateClickHandler;
	var obj=document.getElementById('HL7PNExpiryDateField'); if (obj) obj.onchange=PNExpiryDateFieldChangeHandler;
	// Log 41823 - AI - 15-01-2004 : Add handler for new field HL7PN_Validate.
	var obj=document.getElementById('HL7PNValidate'); if (obj) obj.onchange=PNValidateChangeHandler;
	var obj=document.getElementById('update1'); if (obj) obj.onclick=UpdateClickHandler;
	var obj=document.getElementById('remove1'); if (obj) obj.onclick=RemoveClickHandler;
	//MD
	var obj=document.getElementById('HL7PNExpiryDateFormat'); if (obj) obj.onblur=HL7PNExpiryDateFormatBlurHandler;
	// Log 61484 - ML - 06-11-2006
	var obj=document.getElementById('HL7PNIdentCodeCardType'); if (obj) obj.onclick=HL7PNIdentCodeCardTypeChangeHandler;

	lstItems.multiple=false;
}

// this needs to be called after the captions are dumped
function BodyLoadHandler() {
	if (tsc['Update']) websys_sckeys[tsc['Update']]=UpdateClickHandler;
	if (tsc['Delete']) websys_sckeys[tsc['Delete']]=DeleteClickHandler;
	DisablePNProperties();
	//
	// Load strAry (built in web.SSHL7PatNumbers.getPatNumbers) into REAL array.
	var objStrArry=document.getElementById('strAry');
	var str=objStrArry.value;
	if (str!="") {
		var lu = str.split("^");
		for(j=0; j<lu.length; j++) {
			var lu1=lu[j].split("*");
			// Log 39621 - AI - 09-10-2003 : Add the two new fields ContainsExpiryDate and ExpiryDateField.
			// Log 41823 - AI - 15-01-2004 : Add the new field HL7PN_Validate. - lu1[12]
			//LOG 55819 MD 28-09-2005: Add new filed HL7PN_ExpiryDateFormat lu1[13]
			patAry[j]=new patRecord(lu1[0],lu1[1],lu1[2],lu1[3],lu1[4],lu1[5],lu1[6],lu1[7],lu1[8],lu1[9],lu1[10],lu1[11],lu1[12],lu1[13],lu1[14]);
		}
	}
}

function HL7PNNumberTypeFocusHandler() {
	DisablePNProperties();
	lstItems.selectedIndex=-1;
}

function HL7NumTypesChangeHandler() {
	// When Number Type item is selected from the list display all properties for that item
	if (lstItems.selectedIndex!=-1) {
		var obj=document.getElementById('HL7PNNumberType');
		if (obj) obj.value="";
		var i = lstItems.selectedIndex;
		var obj=document.getElementById('HL7PNSegmentType');
		if (obj) obj.value=patAry[i].segdesc;
		var obj=document.getElementById('HL7PNSegmentField');
		if (obj) obj.value=patAry[i].fldnum;
		var obj=document.getElementById('HL7PNAssignType');
		if (obj) obj.value=patAry[i].assigndesc;
		var obj=document.getElementById('HL7PNAssignCode');
		if (obj) obj.value=patAry[i].assigncode;
		var obj=document.getElementById('HL7PNIdentCode');
		if (obj) obj.value=patAry[i].identcode;
		if (patAry[i].numtype=="HOSP") {
			var obj=document.getElementById('HL7PNIdentCodeMRType');
			if (obj) {
				if ((patAry[i].identcodemrtype=="N")||(patAry[i].identcodemrtype==0)) obj.checked=false;
				if ((patAry[i].identcodemrtype=="Y")||(patAry[i].identcodemrtype==1)) obj.checked=true;
			}
		}
		// Log 39621 - AI - 09-10-2003 : Add the two new fields ContainsExpiryDate and ExpiryDateField.
		var obj=document.getElementById('HL7PNExpiryDate');
		if (obj) {
			if ((patAry[i].containsexpirydate=="N")||(patAry[i].containsexpirydate==0)) obj.checked=false;
			if ((patAry[i].containsexpirydate=="Y")||(patAry[i].containsexpirydate==1)) obj.checked=true;
		}
		var obj=document.getElementById('HL7PNExpiryDateField');
		if (obj) obj.value=patAry[i].expirydatefield;
		//md LOG 55819
		var obj=document.getElementById('HL7PNExpiryDateFormat');
		if (obj) obj.value=patAry[i].expirydateformat;
		//
		// Log 41823 - AI - 15-01-2004 : Add the new field HL7PN_Validate.
		var obj=document.getElementById('HL7PNValidate');
		if (obj) {
			if ((patAry[i].validate=="N")||(patAry[i].validate==0)) obj.checked=false;
			if ((patAry[i].validate=="Y")||(patAry[i].validate==1)) obj.checked=true;
		}
		// Log 61484 - ML - 06-11-2006
		if ((patAry[i].numtype=="DVA")||(patAry[i].numtype=="GOV")) {
			var obj=document.getElementById('HL7PNIdentCodeCardType');
			if (obj) {
				if ((patAry[i].identcodecardtype=="N")||(patAry[i].identcodecardtype==0)) obj.checked=false;
				if ((patAry[i].identcodecardtype=="Y")||(patAry[i].identcodecardtype==1)) obj.checked=true;
			}
		}

		EnablePNProperties();
	}
}

function HL7PNNumberTypeLookUp(str) {
	var lu = str.split("^");
	if (lu[1]!="") {
		//Check selected Number Type not already in Listbox.
		for(i=0; i<patAry.length; i++) {
			if (patAry[i].numtype==lu[1]) {
				alert("'" + lu[0] + "' " + t['AlreadyExists']);
				// Clear LookUp.
				var obj=document.getElementById('HL7PNNumberType');
				if (obj) obj.value="";
				// Mark the existing list item as the selected one.
				lstItems.selectedIndex=i;
				HL7NumTypesChangeHandler();
				websys_setfocus('HL7NumTypes');
				return false;
			}
		}

		// Add selected LookUp item into Listbox.
		var num=lstItems.length;
		lstItems[num]= new Option(lu[0],lu[1]);
		// Add selected LookUp item into Array.
		// Log 39621 - AI - 09-10-2003 : Add space for the two new fields ContainsExpiryDate and ExpiryDateField.
		// Log 41823 - AI - 15-01-2004 : Add the new field HL7PN_Validate. - 13th variable.
		//buildAry(lu[1],lu[0],"","","","","","","","","","","");
		//md
		buildAry(lu[1],lu[0],"","","","","","","","","","","","","");
		//
		// Clear LookUp.
		var obj=document.getElementById('HL7PNNumberType');
		if (obj) obj.value="";
		// make the new entry the selected one.
		lstItems.selectedIndex=num;
		// Clear all Properties for the new Number Type.
		var obj=document.getElementById('HL7PNSegmentType');
		if (obj) obj.value="";
		var obj=document.getElementById('HL7PNSegmentField');
		if (obj) obj.value="";
		var obj=document.getElementById('HL7PNAssignType');
		if (obj) obj.value="";
		var obj=document.getElementById('HL7PNAssignCode');
		if (obj) obj.value="";
		var obj=document.getElementById('HL7PNIdentCode');
		if (obj) obj.value="";
		if (lu[0]=="HOSP") {
			var obj=document.getElementById('HL7PNIdentCodeMRType');
			if (obj) obj.checked=false;
		}
		// Log 39621 - AI - 09-10-2003 : Add the two new fields ContainsExpiryDate and ExpiryDateField.
		var obj=document.getElementById('HL7PNExpiryDate');
		if (obj) obj.checked=false;
		var obj=document.getElementById('HL7PNExpiryDateField');
		if (obj) obj.value="";
		//md
		var obj=document.getElementById('HL7PNExpiryDateFormat');
		if (obj) obj.value="";
		//
		// Log 41823 - AI - 15-01-2004 : Add the new field HL7PN_Validate.
		var obj=document.getElementById('HL7PNValidate');
		if (obj) obj.checked=false;
		if ((lu[0]=="DVA")||(lu[0]=="GOV")) {
			var obj=document.getElementById('HL7PNIdentCodeCardType');
			if (obj) obj.checked=false;
		}

		EnablePNProperties();

		// Set focus to Segment Type field.
		websys_setfocus("HL7PNSegmentType");
	}
}

function HL7PNSegmentTypeBlurHandler() {
	var obj=document.getElementById("HL7PNSegmentType");
	if (obj.value=="") {
		var j=lstItems.selectedIndex;
		patAry[j].segtype="";
		patAry[j].segdesc="";
	}
}

function HL7PNSegmentTypeLookUp(str) {
	var lu = str.split("^");
	var j=lstItems.selectedIndex;
	patAry[j].segtype=lu[1];
	patAry[j].segdesc=lu[0];
}

function HL7PNSegmentFieldChangeHandler() {
	var obj=document.getElementById("HL7PNSegmentField");
	if (obj) {
		if ((isNaN(obj.value))||(obj.value<1)) {
			var cap=document.getElementById("cHL7PNSegmentField");
			alert("'"+cap.innerText + "' " + t['NotNumeric']);
			obj.className="clsInvalid";
			// perform the actual "commit" to the field, so the invalid value is now the "old" value for onchange handler.
			var val=obj.value;
			obj.value=val;
			websys_setfocus("HL7PNSegmentField");
			return false;
		}
		else {
			obj.className="";
			var j=lstItems.selectedIndex;
			patAry[j].fldnum=obj.value;
		}
	}
}

function HL7PNAssignTypeBlurHandler() {
	var obj=document.getElementById("HL7PNAssignType");
	if (obj.value=="") {
		var j=lstItems.selectedIndex;
		patAry[j].assigntype="";
		patAry[j].assigndesc="";
	}
}

function HL7PNExpiryDateFormatBlurHandler() {
	var obj=document.getElementById("HL7PNExpiryDateFormat");
	if (obj.value=="") {
		var j=lstItems.selectedIndex;
		patAry[j].expirydateformat="";
	}
}

function HL7PNAssignTypeLookUp(str) {
	var lu = str.split("^");
	var j=lstItems.selectedIndex;
	patAry[j].assigntype=lu[1];
	patAry[j].assigndesc=lu[0];
}

function HL7PNAssignCodeChangeHandler() {
	var obj=document.getElementById("HL7PNAssignCode");
	if (obj) {
		var j=lstItems.selectedIndex;
		patAry[j].assigncode=obj.value;
	}
}

function HL7PNIdentCodeChangeHandler() {
	var obj=document.getElementById("HL7PNIdentCode");
	if (obj) {
		var j=lstItems.selectedIndex;
		patAry[j].identcode=obj.value;
	}
}

function HL7PNIdentCodeMRTypeChangeHandler() {
	var obj=document.getElementById("HL7PNIdentCodeMRType");
	if (obj) {
		var j=lstItems.selectedIndex;
		if (obj.checked) patAry[j].identcodemrtype=1;
		if (!obj.checked) patAry[j].identcodemrtype=0;
	}
}

function HL7PNIdentCodeCardTypeChangeHandler() {
	var obj=document.getElementById("HL7PNIdentCodeCardType");
	if (obj) {
		var j=lstItems.selectedIndex;
		if (obj.checked) {
			patAry[j].identcodecardtype=1;
			DisableField('HL7PNIdentCode',1);
			var obj1 = document.getElementById("cHL7PNAssignType");
			if (obj1) obj1.className="clsRequired";
			var obj1 = document.getElementById("cHL7PNAssignCode");
			if (obj1) obj1.className="clsRequired";
			websys_setfocus("HL7PNAssignType")
		}
		if (!obj.checked) {
			patAry[j].identcodecardtype=0;
			EnableField('HL7PNIdentCode');
			var obj1 = document.getElementById("cHL7PNAssignType");
			if (obj1) obj1.className="";
			var obj1 = document.getElementById("cHL7PNAssignCode");
			if (obj1) obj1.className="";
		}
	}
}

function HL7PNExpiryDateFormatLookUp(str) {
	var lu = str.split("^");
	var j=lstItems.selectedIndex;
	patAry[j].expirydateformat=lu[0];
}

// Log 39621 - AI - 09-10-2003 : Add handlers for new fields ContainsExpiryDate and ExpiryDateField.
function PNExpiryDateClickHandler() {
	var obj=document.getElementById("HL7PNExpiryDate");
	if (obj) {
		var j=lstItems.selectedIndex;
		if (obj.checked) patAry[j].containsexpirydate=1;
		if (!obj.checked) {
			patAry[j].containsexpirydate=0;
			var obj1=document.getElementById("HL7PNExpiryDateField");
			if (obj1) obj1.value="";
			patAry[j].expirydatefield="";
		}
	}
	EnableExpDateFldProperty();
}

// called from both PNExpiryDateClickHandler and EnablePNProperties functions.
function EnableExpDateFldProperty() {
	var obj=document.getElementById('HL7PNExpiryDate');
	if (obj && obj.checked) {
		EnableField('HL7PNExpiryDateField');
		EnableField('HL7PNExpiryDateFormat');
		var objLK=document.getElementById('ld1835iHL7PNExpiryDateFormat')
		if(objLK) {
		//objLK.disabled=false;
		objLK.style.visibility = "";
		}

	} else {
		DisableField('HL7PNExpiryDateField',1);
		DisableField('HL7PNExpiryDateFormat',1);
		var objLK=document.getElementById('ld1835iHL7PNExpiryDateFormat')
		if (objLK) {
		//objLK.disabled=true;
		objLK.style.visibility = "hidden";
		}
	}
}

function PNExpiryDateFieldChangeHandler() {
	var obj=document.getElementById("HL7PNExpiryDateField");
	if ((obj.value)&&((isNaN(obj.value))||(obj.value<1))) {
		var cap=document.getElementById("cHL7PNExpiryDateField");
		alert("'"+cap.innerText + "' " + t['NotNumeric']);
		var obj=document.getElementById("HL7PNExpiryDateField");
		if (obj) obj.className="clsInvalid";
		// perform the actual "commit" to the field, so the invalid value is now the "old" value for onchange handler.
		var val=obj.value;
		obj.value=val;
		websys_setfocus("HL7PNExpiryDateField");
		return false;
	}
	else {
		obj.className="";
		var j=lstItems.selectedIndex;
		patAry[j].expirydatefield=obj.value;
	}
}
// end Log 39621

// Log 41823 - AI - 15-01-2004 : Add handler for new field HL7PN_Validate.
function PNValidateChangeHandler() {
	var obj=document.getElementById("HL7PNValidate");
	if (obj) {
		var j=lstItems.selectedIndex;
		if (obj.checked) patAry[j].validate=1;
		if (!obj.checked) patAry[j].validate=0;
	}
}

function RemoveClickHandler() {
	var j=lstItems.selectedIndex;
	if (j!=-1) {
		// Remove selected item from Array.
		patAry.splice(j,1);
		// Remove selected item from Listbox.
		lstItems.remove(j);
		DisablePNProperties();
	}
	return false;
}

// Log 41823 - AI - 15-01-2004 : Add the new field HL7PN_Validate. - 13th variable.
function buildAry(numtype,numdesc,segtype,segdesc,fldnum,assigntype,assigndesc,assigncode,identcode,identcodemrtype,containsexpirydate,expirydatefield,validate,expirydateformat,identcodecardtype) {
	tmpAry = new patRecord(numtype,numdesc,segtype,segdesc,fldnum,assigntype,assigndesc,assigncode,identcode,identcodemrtype,containsexpirydate,expirydatefield,validate,expirydateformat,identcodecardtype);
	var j=lstItems.selectedIndex;
	if (j==-1) j=lstItems.length-1;
	patAry[j] = tmpAry;
}

// The layout of a record
// Log 41823 - AI - 15-01-2004 : Add the new field HL7PN_Validate. - 13th variable.
function patRecord(numtype,numdesc,segtype,segdesc,fldnum,assigntype,assigndesc,assigncode,identcode,identcodemrtype,containsexpirydate,expirydatefield,validate,expirydateformat,identcodecardtype) {
	this.numtype=numtype;
	this.numdesc=numdesc;
	this.segtype=segtype;
	this.segdesc=segdesc;
	this.fldnum=fldnum;
	this.assigntype=assigntype;
	this.assigndesc=assigndesc;
	this.assigncode=assigncode;
	this.identcode=identcode;
	this.identcodemrtype=identcodemrtype;
	// Log 39621 - AI - 09-10-2003 : Add the two new fields ContainsExpiryDate and ExpiryDateField.
	this.containsexpirydate=containsexpirydate;
	this.expirydatefield=expirydatefield;
	// Log 41823 - AI - 15-01-2004 : Add the new field HL7PN_Validate.
	this.validate=validate;
	//md
	this.expirydateformat=expirydateformat;
	this.identcodecardtype=identcodecardtype;
}

function UpdateClickHandler() {
	var obj=document.getElementById('HL7PNSegmentField');
	if (obj.className=="clsInvalid") {
		alert("'" + t['HL7PNSegmentField'] + "' " + t['NotNumeric']);
		websys_setfocus("HL7PNSegmentField");
		return false;
	}

	for(j=0; j<patAry.length; j++) {
		if ((patAry[j].numtype=="")||(patAry[j].numdesc=="")) {
			alert("'" + t['HL7PNNumberType'] + "' " + t['IsMandatory'] + " '" + t['HL7PNNumberType'] + "' " +  patAry[j].numtype);
			return false;
		}
		if ((patAry[j].segtype=="")||(patAry[j].segdesc=="")) {
			alert("'" + t['HL7PNSegmentType'] + "' " + t['IsMandatory'] + " '" + t['HL7PNNumberType'] + "' " +  patAry[j].numtype);
			return false;
		}
		if (patAry[j].fldnum=="") {
			alert("'" + t['HL7PNSegmentField'] + "' " + t['IsMandatory'] + " '" + t['HL7PNNumberType'] + "' " +  patAry[j].numtype);
			return false;
		}
		if ((patAry[j].identcodecardtype=="Y")||(patAry[j].identcodecardtype==1)) {
			if (patAry[j].assigntype=="") {
				alert("'" + t['HL7PNAssignType'] + "' " + t['IsMandatory'] + " '" + t['HL7PNNumberType'] + "' " + patAry[j].numtype);
				websys_setfocus("HL7PNAssignType");
				return false;
			}
			if (patAry[j].assigncode=="") {
				alert("'" + t['HL7PNAssignCode'] + "' " + t['IsMandatory'] + " '" + t['HL7PNNumberType'] + "' " + patAry[j].numtype);
				websys_setfocus("HL7PNAssignCode");
				return false;
			}
		}
	}
	var strBuffer="";
	for(j=0; j<patAry.length; j++) {
		// Log 39621 - AI - 09-10-2003 : Add the two new fields ContainsExpiryDate and ExpiryDateField.
		// Log 41823 - AI - 15-01-2004 : Add the new field HL7PN_Validate. - 13th variable.
		//if (strBuffer!="") strBuffer=strBuffer + "^" + (patAry[j].numtype) + "*" + patAry[j].numdesc + "*" + patAry[j].segtype + "*" + patAry[j].segdesc + "*" + patAry[j].fldnum + "*" + patAry[j].assigntype + "*" + patAry[j].assigndesc + "*"+ patAry[j].assigncode + "*" + patAry[j].identcode + "*" + patAry[j].identcodemrtype + "*" + patAry[j].containsexpirydate + "*" + patAry[j].expirydatefield + "*" + patAry[j].validate;
		//md
		if (strBuffer!="") strBuffer=strBuffer + "^" + (patAry[j].numtype) + "*" + patAry[j].numdesc + "*" + patAry[j].segtype + "*" + patAry[j].segdesc + "*" + patAry[j].fldnum + "*" + patAry[j].assigntype + "*" + patAry[j].assigndesc + "*"+ patAry[j].assigncode + "*" + patAry[j].identcode + "*" + patAry[j].identcodemrtype + "*" + patAry[j].containsexpirydate + "*" + patAry[j].expirydatefield + "*" + patAry[j].validate + "*" + patAry[j].expirydateformat + "*" + patAry[j].identcodecardtype;
		if (strBuffer=="") strBuffer=(patAry[j].numtype) + "*" + patAry[j].numdesc + "*" + patAry[j].segtype + "*" + patAry[j].segdesc + "*" + patAry[j].fldnum + "*" + patAry[j].assigntype + "*" + patAry[j].assigndesc + "*"+ patAry[j].assigncode + "*" + patAry[j].identcode + "*" + patAry[j].identcodemrtype + "*" + patAry[j].containsexpirydate + "*" + patAry[j].expirydatefield + "*" + patAry[j].validate + "*" + patAry[j].expirydateformat + "*" + patAry[j].identcodecardtype;
	}
	var obj = document.getElementById('strAry');
	if (obj) obj.value=strBuffer;
	return update1_click();
}

function DisableField(fldName,vGray) {
	var fld = document.getElementById(fldName);
	if ((fld)&&(fld.tagName=="INPUT")&&(fld.type!="hidden")) {
		fld.disabled = true;
		if (fld.type=="checkbox") fld.checked=false
		fld.value = "";
		if (vGray) fld.className = "disabledField";
	}
}

function EnableField(fldName) {
	var fld = document.getElementById(fldName);
	if ((fld)&&(fld.tagName=="INPUT")&&(fld.type!="hidden")) {
		fld.disabled = false;
		fld.className = "";
	}
}

function DisablePNProperties() {
	DisableField('HL7PNSegmentType',1);
	var obj = document.getElementById("ld1835iHL7PNSegmentType");
	if (obj) obj.disabled=true;
	var obj = document.getElementById("cHL7PNSegmentType");
	if (obj) obj.className="";
	DisableField('HL7PNSegmentField',1);
	var obj = document.getElementById("cHL7PNSegmentField");
	if (obj) obj.className="";
	DisableField('HL7PNAssignType',1);
	var obj = document.getElementById("ld1835iHL7PNAssignType");
	if (obj) obj.disabled=true;
	DisableField('HL7PNAssignCode',1);
	DisableField('HL7PNIdentCode',1);
	var obj = document.getElementById("HL7PNIdentCodeMRType");
	if (obj) {
		obj.checked=false;
		obj.disabled=true;
	}
	var obj = document.getElementById("HL7PNIdentCodeCardType");
	if (obj) {
		obj.checked=false;
		obj.disabled=true;
	}
	// Log 39621 - AI - 09-10-2003 : Add the two new fields ContainsExpiryDate and ExpiryDateField.
	var obj = document.getElementById("HL7PNExpiryDate");
	if (obj) {
		obj.checked=false;
		obj.disabled=true;
	}

	EnableExpDateFldProperty();
	// Log 41823 - AI - 15-01-2004 : Add the new field HL7PN_Validate.
	var obj = document.getElementById("HL7PNValidate");
	if (obj) {
		obj.checked=false;
		obj.disabled=true;
	}

	websys_setfocus('HL7PNNumberType');
}

function EnablePNProperties() {
	EnableField('HL7PNSegmentType');
	var obj = document.getElementById("ld1835iHL7PNSegmentType");
	if (obj) obj.disabled=false;
	var obj = document.getElementById("cHL7PNSegmentType");
	if (obj) obj.className="clsRequired";
	EnableField('HL7PNSegmentField');
	var obj = document.getElementById("cHL7PNSegmentField");
	if (obj) obj.className="clsRequired";
	EnableField('HL7PNAssignType');
	var obj = document.getElementById("ld1835iHL7PNAssignType");
	if (obj) obj.disabled=false;
	EnableField('HL7PNAssignCode');
	EnableField('HL7PNIdentCode');
	var i = lstItems.selectedIndex;
	if (patAry[i].numtype=="HOSP") EnableField('HL7PNIdentCodeMRType');
	if (patAry[i].numtype!="HOSP") DisableField('HL7PNIdentCodeMRType');
	if ((patAry[i].numtype=="DVA")||(patAry[i].numtype=="GOV")) EnableField('HL7PNIdentCodeCardType');
	if ((patAry[i].numtype!="DVA")&&(patAry[i].numtype!="GOV")) DisableField('HL7PNIdentCodeCardType');

	if ((patAry[i].identcodecardtype=="Y")||(patAry[i].identcodecardtype==1)) {
		DisableField("HL7PNIdentCode",1);
		var obj1 = document.getElementById("cHL7PNAssignType");
		if (obj1) obj1.className="clsRequired";
		var obj1 = document.getElementById("cHL7PNAssignCode");
		if (obj1) obj1.className="clsRequired";
	}
	else {
		var obj1 = document.getElementById("cHL7PNAssignType");
		if (obj1) obj1.className="";
		var obj1 = document.getElementById("cHL7PNAssignCode");
		if (obj1) obj1.className="";
	}

	// Log 39621 - AI - 09-10-2003 : Call the function to enable or disable the ExpiryDateField based on ContainsExpiryDate.
	EnableField('HL7PNExpiryDate');
	EnableExpDateFldProperty();
	// Log 41823 - AI - 15-01-2004 : Add the new field HL7PN_Validate. Enable only if Inbound.
	var obj=document.getElementById('interfaceParams');
	if (obj) {
		var intRunning=mPiece(obj.value,"^",1);
		var dataDirection=mPiece(obj.value,"^",2);
		if (dataDirection=="I") EnableField('HL7PNValidate');
	}
}

// Log 41823 - AI - 15-01-2004 : Function added to get the interfaceParams for EnablePNProperties, above.
function mPiece(s1,sep,n) {
	//Split the array with the passed delimeter
	n--;
      	delimArray = s1.split(sep);

	//If out of range, return a blank string
	if ((n <= delimArray.length-1) && (n >= 0)) {
        	return delimArray[n];
	} else {
		return "";
	}
}

document.body.onload=BodyLoadHandler;

