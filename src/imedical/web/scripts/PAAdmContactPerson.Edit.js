// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 



function DocumentLoadHandler() {

	if (self==top) websys_reSizeT();

	setMandatoryFields();

	//obj=document.getElementById('CTZIPCode')
	//if (obj) obj.onchange= ZipChangeHandler;
	
	//obj=document.getElementById('CTCITDesc')
	//if (obj) obj.onchange= CityChangeHandler;

	obj=document.getElementById('CONTDateFrom');
	if (obj) obj.onchange=CodeTableValidationDate;

	obj=document.getElementById('CONTDateTo');
	if (obj) obj.onchange=CodeTableValidationDate;

	obj=document.getElementById('PAPEREmail')
	if (obj) obj.onchange= isEmail;

	var obj=document.getElementById('Clear')
	if (obj) obj.onclick=clearFormHandler;

	var obj=document.getElementById('delete1')
	if (obj) obj.onclick=deleteFormHandler;

	obj=document.getElementById('NGODesc')
	//if (obj) obj.onchange=nonGovOrgHandler;
	if (obj) obj.onblur=nonGovOrgHandler;

	obj=document.getElementById('PAPERDob')
	if (obj) obj.onchange = DOBChangeHandler;

	obj = document.getElementById("update1")
	obj.onclick = UpdateClickHandler;
	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateClickHandler;

}
function UpdateClickHandler(e) {
	validateCONTDateTo()
	return update1_click();
}

/*function UpdateClickHandler(e) {
	
	if (parent.frames["contactlower"]) {
		var frm = document.forms["fPAAdmContactPerson_Edit"];
		var twkfl= document.getElementById("TWKFLI")
		//alert("TWK" + twkfl.value)
		if (!(fPAAdmContactPerson_Edit_submit())) {
			return
			}
		twkfl.value -= 1
		frm.target = "_parent"
		}	
	obj=document.getElementById("PatientID")
	obj.value=""
	return update1_click();
}*/

function Name5LookupSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById("PAPERName")
	if (obj) obj.value = lu[2];
 	var obj=document.getElementById("PAPERName5")
	if (obj) obj.value = lu[0];
	}
function Name6LookupSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById("PAPERName2")
	if (obj) obj.value = lu[2];
 	var obj=document.getElementById("PAPERName6")
	if (obj) obj.value = lu[0];
	}
function Name7LookupSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById("PAPERName3")
	if (obj) obj.value = lu[2];
 	var obj=document.getElementById("PAPERName7")
	if (obj) obj.value = lu[0];
	}
function Name8LookupSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById("PAPERName4")
	if (obj) obj.value = lu[2];
 	var obj=document.getElementById("PAPERName8")
	if (obj) obj.value = lu[0];
	}

// Geographic Information


function CityAreaLookupSelect(str) {

 	var lu = str.split("^");
	var obj=document.getElementById("CTCITDesc")
	if (obj) obj.value = lu[0];
 	obj=document.getElementById("CTZIPCode")
	if (obj) obj.value = lu[1];
 	obj=document.getElementById("CITAREADesc")
	if (obj) obj.value = lu[2];
 	obj=document.getElementById("PROVDesc")
	if (obj) obj.value = lu[3];
}

function CityLookupSelect(str) {
	
 	var lu = str.split("^");
	var obj=document.getElementById("CTZIPCode")
	if (obj) obj.value = lu[0];
 	var obj1=document.getElementById("CTCITDesc")
	if (obj1) obj1.value = lu[1];
	var obj=document.getElementById("PROVDesc")
	if (obj) obj.value = lu[2];
	//CTCITDescAndCTZIPCode_BlurHandler2(obj1)

}


function ZipLookupSelect(str) {
	//zipcode^suburb^state^address
	var lu = str.split("^");
	var obj1=document.getElementById("CTZIPCode")
	if (obj1) obj1.value = lu[0];
 	var obj=document.getElementById("CTCITDesc")
	if (obj) obj.value = lu[1];
	var obj=document.getElementById("PROVDesc")
	if (obj) obj.value = lu[2];
	var obj=document.getElementById("CITAREADesc")
	if (obj) obj.value = lu[3];
	
	//CTCITDescAndCTZIPCode_BlurHandler2(obj1)
}

function ProvinceLookupSelect(str) {
 	var lu = str.split("^");
 	var obj=document.getElementById("PROVDesc")
	if (obj) obj.value = lu[0];
	//CTCITDescAndCTZIPCode_BlurHandler2(obj);
}

function CTCITDescAndCTZIPCode_BlurHandler2(obj) {
	eSrc=obj;
	if (eSrc.defaultValue!="")	{
		if (!AskedForSaveAddress) {
			if ((eSrc.value!=eSrc.defaultValue)&&(eSrc.value!="")) {
				AskedForSaveAddress=1;
				registeringAddressChange();
			}
		}
	}
}

function ZipChangeHandler(e) {
	var obj;
 	obj=document.getElementById("CTZIPCode")
	if ((obj)&&(obj.value!="")) {
		obj=document.getElementById("CTCITDesc")
		if (obj) obj.value = "";
	}
}


function CityChangeHandler(e) {
	var obj;
	obj=document.getElementById("CTCITDesc")
	if ((obj)&&(obj.value!="")) {
		obj=document.getElementById("CTZIPCode")
		if (obj) obj.value = "";
	}
}

//JW moved to websys.Edit.Tools.js
/*function isEmail() {
	
	var reEmail = /^.+\@.+\..+$/
	var obj=document.getElementById('PAPEREmail')
	
  	if ((obj)&&(obj.value!="")) {
  		if (!(reEmail.test(obj.value))) {
			alert("\'" + t['PAPEREmail'] + "\' " + t['XINVALID'] + "\n");
			obj.focus();
			return false;
	    	}
	}
	return true;
} */

function CONTDateToChangeHandler(e) {
		CONTDateTo_changehandler(e)
		var from=document.getElementById('CONTDateFrom')
		var to=document.getElementById('CONTDateTo')
		var fromdt=DateStringToArray(from.value)
		var todt=DateStringToArray(to.value)
		//alert(to.value)
		var dtto=new Date(todt["yr"], todt["mn"]-1, todt["dy"]);
		var dtfrom=new Date(fromdt["yr"], fromdt["mn"]-1, fromdt["dy"]);
		if ((to)&&(from)) {
			if (dtto< dtfrom) {
			alert("\'" + t['CONTDateTo'] + "\' " + t['XINVALID'] + "\n");
			to.value=""
			}
		}

}


function CONTDateFromChangeHandler(e) {
		CONTDateFrom_changehandler(e)
		var to=document.getElementById('CONTDateTo')
		var from=document.getElementById('CONTDateFrom')
		var fromdt=DateStringToArray(from.value)
		var todt=DateStringToArray(to.value)
		//alert(to.value)
		var dtto=new Date(todt["yr"], todt["mn"]-1, todt["dy"]);
		var dtfrom=new Date(fromdt["yr"], fromdt["mn"]-1, fromdt["dy"]);
		if ((to)&&(from)) {
			if (dtto< dtfrom) {
			alert("\'" + t['CONTDateFrom'] + "\' " + t['XINVALID'] + "\n");
			from.value=""
			}
		}

}

function validateCONTDateTo(e) {
		var from=document.getElementById('CONTDateFrom')
		var to=document.getElementById('CONTDateTo')
		if ((from)&&(from.value!="")&&(to)&&(to.value!="")) {
			var fromdt=DateStringToArray(from.value)
			var todt=DateStringToArray(to.value)
		//alert(to.value)
		var dtto=new Date(todt["yr"], todt["mn"]-1, todt["dy"]);
		var dtfrom=new Date(fromdt["yr"], fromdt["mn"]-1, fromdt["dy"]);
		if ((to)&&(from)) {
			if (dtto< dtfrom) {
			alert("\'" + t['CONTDateTo'] + "\' " + t['XINVALID'] + "\n");
			to.value=""
			}
		}
	}

}


function clearFormHandler() {
	var obj=document.getElementById("ID")
	obj.value=""
	var obj=document.getElementById("CONTPersonDR")
	obj.value=""
	var el=document.forms["fPAAdmContactPerson_Edit"].elements;
		for (var i=0;i<el.length;i++) {
		if ((el[i].type!="hidden")&&(!el[i].disabled)) {
			el[i].value=""					
		}	
	}	
	
	return false
}

function deleteFormHandler() {
	//clearFormHandler()
		if (parent.frames["contactlower"]) {
		var frm = document.forms["fPAAdmContactPerson_Edit"];
		var twkfl= document.getElementById("TWKFLI")
		//alert("TWK" + twkfl.value)
		if (!(fPAAdmContactPerson_Edit_submit())) {
			return
			}
		twkfl.value -= 1
		frm.target = "_parent"
		}	
	//obj=document.getElementById("PatientID")
	//obj.value=""
	return delete1_click();
	//return
}


function contactLookUp(str) {
	//alert(str)
	var lu = str.split("^");
	var obj
	//alert(obj.value)
	obj=document.getElementById('CONTTPDesc');
	if (obj) obj.value = lu[0];
	try{
		CustomNOKContactType(lu[0]);
	}catch(e){}
	obj=document.getElementById('CTRLTDesc');
	if (obj) obj.value = lu[3];
	

}

function NonGovOrgLookUp(str) {
	var lu = str.split("^");
	var obj;
	//alert(str);
	obj=document.getElementById("NGODesc")
	if (obj) obj.value = lu[1]
	obj=document.getElementById("NGOAddress")
	if (obj) obj.value = lu[3]
	obj=document.getElementById("CTCITDesc2");
	if (obj) obj.value = lu[4];
	obj=document.getElementById("CTZIPCode2");
	if (obj) obj.value = lu[5];
	obj=document.getElementById("NGOContactMethod");
	if (obj) obj.value = lu[6];
	obj=document.getElementById("NGOEmail");
	if (obj) obj.value = lu[7];
	obj=document.getElementById("NGOFax");
	if (obj) obj.value = lu[8];
	obj=document.getElementById("NGOPhone");
	if (obj) obj.value = lu[9];
	obj=document.getElementById("PROVDesc2");
	if (obj) obj.value = lu[10];

	nonGovOrgHandler();
}


function nonGovOrgHandler() {
	var obj=document.getElementById('NGODesc');
		
	if ((obj)&&(obj.value!="")) {
		labelNormal('PAPERName');
		labelNormal('PAPERName2');
		labelNormal('CTSEXDesc');
		
	}

}

function DOBChangeHandler(e) {
	PAPERDob_changehandler(e);
	var obj = document.getElementById('PAPERDob');
	var age = document.getElementById('PAPERAge');
	if ((obj)&&(age)) {
		age.value=""
	}
}


/*JW moved to websys.Edit.Tools.js - delete post 10/5/04
function DisableField(fldName) {
	var fld = document.getElementById(fldName);
	if ((fld)&&(fld.tagName=="INPUT")) {
		fld.disabled = true;
	}
}

function labelMandatory(fld) {
	var lbl = document.getElementById('c' + fld)
	if (lbl) {
		lbl=lbl.className = "clsRequired";
	}
}

function labelNormal(fld) {
	var lbl = document.getElementById('c' + fld)
	if (lbl) {
		lbl=lbl.className = "";
	}
}*/

function setMandatoryFields() {
	var obj=document.getElementById('NGODesc');
		
	if ((obj)&&(obj.value=="")) {
		labelMandatory('PAPERName');
		labelMandatory('PAPERName2');
		labelMandatory('CTSEXDesc');
	}
} 

// cjb 11/09/2003 39073
function CodeTableValidationDate(e) {
	
	var eSrc=websys_getSrcElement(e);
	if (eSrc.id=="CONTDateFrom") {CONTDateFromChangeHandler(e);}
	if (eSrc.id=="CONTDateTo") {CONTDateToChangeHandler(e);}
	
	var CONTDateFrom = "";
	var CONTDateTo = "";
	
	var obj=document.getElementById('CONTDateFrom');
	if ((obj)&&(obj.value!="")) {
		var CONTDateFrom=DateStringTo$H(obj.value);
	}
	obj=document.getElementById('CONTDateTo');
	if ((obj)&&(obj.value!="")) {
		var CONTDateTo=DateStringTo$H(obj.value);
	}
	
	obj=document.getElementById('CodeTableValidationDate');
	//have to initiate CTVdate to $h in case of clearing values in target date fields
	if (obj) { obj.value=DateStringTo$HToday() };
	if ((obj)&&(obj.value!="")) {
		if ((CONTDateFrom)&&(CONTDateFrom.value!="")) {
			obj.value=CONTDateFrom;
		}
		if ((CONTDateTo)&&(CONTDateTo.value!="")) {
			obj.value=CONTDateTo;
		}
	}
	/*
	obj=document.getElementById('CTCITDesc')
	if (obj) obj.onchange();
	obj=document.getElementById('CTZIPCode')
	if (obj) obj.onchange();
	obj=document.getElementById('NGODesc')
	if (obj) obj.onchange();
	obj=document.getElementById('CONTTPDesc')
	if (obj) obj.onchange();
	*/
}


document.body.onload = DocumentLoadHandler;