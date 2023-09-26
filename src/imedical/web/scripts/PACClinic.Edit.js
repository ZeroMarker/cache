// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function BodyLoadHandler() {
	var obj=document.getElementById('CLNCityDR');
	if (obj) obj.onblur = CityChangeHandler;
	
	var obj=document.getElementById('CLNEmail');
	if (obj) obj.onchange = isEmail;							// cjb 24/10/2006 50857 - using standard functionality
	//if (obj) obj.onchange = EmailChangeHandler;

	//var obj=document.getElementById('update1');
	//if (obj) obj.onclick = UpdateClickHandler;
	
	obj=document.getElementById('CLNDateFrom');
	if (obj) obj.onchange=CodeTableValidationDate

	obj=document.getElementById('CLNDateTo');
	if (obj) obj.onchange=CodeTableValidationDate

}

function UpdateClickHandler(evt) {
	// cjb 24/10/2006 50857 - using standard functionality
	/*
	var msg="";
	var obj = document.getElementById('CLNEmail'); 
	if ((obj)&&(!ValidateEmail(obj))) {
		msg += "\'" + t['CLNEmail'] + "\' " + t['XINVALID'] + "\n";
	}
	if (msg != "") {
		alert(msg);
		return false;
	}
	*/
	return update1_click();
}


function CityZipLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById('CLNZipDR');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('CLNCityDR');
	if (obj) obj.value=lu[1];
	//md 28/10/2003
	var obj=document.getElementById('provdesc');
	if (obj) obj.value=lu[2];
}
/*
function ZipChangeHandler(evt) {
	var eSrc = websys_getSrcElement(evt);
	if ((eSrc) && (eSrc.value=="")) return;
	var obj=document.getElementById('CLNCityDR');
	if (obj) obj.value="";
}
*/
function CityChangeHandler(evt) {
	var eSrc = websys_getSrcElement(evt);
	if ((eSrc) && (eSrc.value=="")) {
	var obj=document.getElementById('CLNZipDR');
	if (obj) obj.value="";
	var obj=document.getElementById('provdesc');
	if (obj) obj.value="";
	}
}

// cjb 24/10/2006 50857 - using standard functionality
/*
function EmailChangeHandler(evt) {
	var eSrc = websys_getSrcElement(evt);
	var lbl = document.getElementById('c' + eSrc.id);
	if ((eSrc)&&(!ValidateEmail(eSrc))) {
		alert("\'" + t[eSrc.id] + "\' " + t['XINVALID'] + "\n");
		eSrc.focus();
	}
}
function ValidateEmail(fld) {
	var reEmail = /^.+\@.+\..+$/
	if ((fld)&&(fld.value!="")) {
  		if (!(reEmail.test(fld.value))) {
			return false;
	    	}
	}
	return true;
}
*/

// cjb 11/09/2003 39073
function CodeTableValidationDate(e) {
	
	var eSrc=websys_getSrcElement(e);
	if (eSrc.id=="CLNDateFrom") {CLNDateFrom_changehandler(e);}
	if (eSrc.id=="CLNDateTo") {CLNDateTo_changehandler(e);}
	
	var CLNDateFrom;
	var CLNDateTo;
	var obj;
	
	obj=document.getElementById('CLNDateFrom');
	if ((obj)&&(obj.value!="")) CLNDateFrom=DateStringTo$H(obj.value);
	
	obj=document.getElementById('CLNDateTo');
	if ((obj)&&(obj.value!="")) CLNDateTo=DateStringTo$H(obj.value);
	
	obj=document.getElementById('CodeTableValidationDate');
	//have to initiate CTVdate to $h in case of clearing values in target date fields
	if (obj) { obj.value=DateStringTo$HToday() };
	if ((obj)&&(obj.value!="")) {
		if ((CLNDateFrom)&&(CLNDateFrom.value!="")) obj.value=CLNDateFrom;
		if ((CLNDateTo)&&(CLNDateTo.value!="")) obj.value=CLNDateTo;
	}
	
}

document.body.onload = BodyLoadHandler;