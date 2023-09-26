// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 


function DocumentLoadHandler() {

	obj=document.getElementById('TRFAccidentDate');
	if (obj) obj.onchange=TrafficDateChangeHandler;

	//Log 51515 EZ 7-11-2006 Time validation
	var acctimeobj=document.getElementById('TRFAccidentTime');
	if (acctimeobj) acctimeobj.onchange=TrafficTimeChangeHandler;
	
	var obj=document.getElementById('Clear')
	if (obj) obj.onclick=clearFormHandler;

	obj = document.getElementById("update1")
	obj.onclick = UpdateClickHandler;
	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateClickHandler;

	//obj = document.getElementById("delete1")
	//obj.onclick = deleteClickHandler;
	//if (tsc['delete1']) websys_sckeys[tsc['delete1']]=deleteClickHandler;

}

function TrafficDateChangeHandler(e) {
		TRFAccidentDate_changehandler(e)
		var trf=document.getElementById('TRFAccidentDate')
		var adm=document.getElementById('admissiondate')
		var dob=document.getElementById('PAPERDob')
		
		
		if (DateStringCompareToday(trf.value)==1) {
			alert("\'" + t['TRFAccidentDate'] + "\' " + t['XINVALID'] + "\n");
			trf.value=""
			return false
		}
		if (DateStringCompare(trf.value,adm.value)==1) {
			alert(t['DatePriorAdmission'] + "\n");
			trf.value=""
			return false
		}
		if (DateStringCompare(dob.value,trf.value)==1) {
			alert(t['DateBeforeDOB'] + "\n");
			trf.value=""
			return false
		}		
		
		CodeTableValidationDate();
		
}


//Log 51515 EZ 7-11-2006 Time validation
function TrafficTimeChangeHandler(e) {
		TRFAccidentTime_changehandler(e)
		var trf=document.getElementById('TRFAccidentDate')
		var trft=document.getElementById('TRFAccidentTime')
		
		if (DateTimeStringCompareToday(trf.value,trft.value)==1) {
			alert("\'" + t['TRFAccidentTime'] + "\' " + t['XINVALID'] + "\n");
			trft.value=""
			return false
		}
		
		
}


function UpdateClickHandler(e) {
    
	if (parent.frames["lower"]) {
		var frm = document.forms["fPATrafficAccident_Edit"];
		//frm.target = "_parent"
		if (frm.elements['TWKFL']!="") frm.elements['TFRAME'].value=window.parent.name;
	}
	
	//alert(frm.action)
	return update1_click();
}

function deleteClickHandler(e) {
	lnk=document.getElementById("delete1")
	if (parent.frames["lower"]) {
		var frm = document.forms["fPATrafficAccident_Edit"];
		lnk.target = "_parent"
	}
	return delete1_click();
}

function clearFormHandler() {
	var obj=document.getElementById("trafficID")
	obj.value=""
	var obj=document.getElementById("ID")
	obj.value=""
	var el=document.forms["fPATrafficAccident_Edit"].elements;
	//var el=frm.elements
		for (var i=0;i<el.length;i++) {
		if ((el[i].type!="hidden")&&(!el[i].disabled)) {
			el[i].value=""					
		}	
	}	
	
	return false
}

function contactLookUpSelect(str) {
	//dummy function
}




function CodeTableValidationDate(e) {
	
	
	
	var TRFAccidentDate;
	var obj;
	
	obj=document.getElementById('TRFAccidentDate');
	if ((obj)&&(obj.value!="")) {
		var TRFAccidentDate=DateStringTo$H(obj.value);
	}
	
	obj=document.getElementById('CodeTableValidationDate');
	//have to initiate CTVdate to $h in case of clearing values in target date fields
	if (obj) { obj.value=DateStringTo$HToday() };
	if ((obj)&&(obj.value!="")) {
		if ((TRFAccidentDate)&&(TRFAccidentDate.value!="")) {
			obj.value=TRFAccidentDate;
		}
		
	}
	/*
	obj=document.getElementById('TRFDesc')
	if (obj) obj.onchange();
	obj=document.getElementById('PATROLDesc')
	if (obj) obj.onchange();
	obj=document.getElementById('assignBill')
	if (obj) obj.onchange();
	obj=document.getElementById('LOCINJDesc')
	if (obj) obj.onchange();
	*/
	
}


document.body.onload = DocumentLoadHandler;

//////////////////////////////////////////////////////

/*JW moved to websys.Edit.Tools.js

function DisableField(fld) {
	var lbl = ('c'+fld);
	if (fld) {
		fld.value = "";
		fld.disabled = true;
		fld.className = "disabledField";
		if (lbl) lbl = lbl.className = "";
	}
}

function EnableField(fld) {
	var lbl = ('c'+fld);
	if (fld) {
		fld.disabled = false;
		fld.className = "";
		if (lbl) lbl = lbl.className = "";
	}
}

function labelMandatory(fld) {
	var lbl = document.getElementById('c' + fld);
	if (lbl) {
		lbl=lbl.className = "clsRequired";
	}
}

function labelNormal(fld) {
	var lbl = document.getElementById('c' + fld)
	if (lbl) {
		lbl=lbl.className = "";
	}
}

*/
