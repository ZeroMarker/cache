// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function DocumentLoadHandler() {
	
	
	obj=document.getElementById('CONTDateFrom');
	if (obj) obj.onchange=CodeTableValidationDate;
	
	obj=document.getElementById('CONTDateTo');
	if (obj) obj.onchange=CodeTableValidationDate;
	
	
	var obj=document.getElementById('CTZIPCode')
	//if (obj) obj.onchange= ZipChangeHandler;
	
	var obj=document.getElementById('CTCITDesc')
	//if (obj) obj.onchange= CityChangeHandler;

	
	obj=document.getElementById('update1')
	if (obj) obj.onclick = UpdateHandler;
	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateHandler;
}

function UpdateHandler() {
	var frm = document.forms["fPATrafficAccidentContact_Edit"];
	if (parent.frames["traffic_contact_edit"]) {
		var frm = document.forms["fPATrafficAccidentContact_Edit"];
		frm.elements['TFRAME'].value=window.parent.name;
		}
	
		var obj=document.forms['fPATrafficAccidentContact_Edit'].elements['TWKFLI'];
		if (obj.value!="") obj.value-=1;
				
		return update1_click();
}

// Geographic Information

function CityLookUpSelect(str) {
 	var lu = str.split("^");
	var obj;
	obj=document.getElementById("CTZIPCode")
	if (obj) obj.value = lu[0];
 	obj=document.getElementById("CTCITDesc")
	if (obj) obj.value = lu[1];
}


function ZipLookUpSelect(str) {
 	var lu = str.split("^");
	var obj;
 	obj=document.getElementById("CTZIPCode")
	if (obj) obj.value = lu[0]; 
 	obj=document.getElementById("CTCITDesc")
	if (obj) obj.value = lu[1];
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

function contactLookUpSelect(str) {
	//dummy function
}


function CodeTableValidationDate(e) {
	
	var eSrc=websys_getSrcElement(e);
	if (eSrc.id=="CONTDateFrom") {CONTDateFrom_changehandler(e);}
	if (eSrc.id=="CONTDateTo") {CONTDateTo_changehandler(e);}
	
	
	var CONTDateFrom;
	var CONTDateTo;
	var obj;
	
	obj=document.getElementById('CONTDateFrom');
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
	obj=document.getElementById('CTZIPCode')
	obj.onchange();
	obj=document.getElementById('CTCITDesc')
	obj.onchange();
	obj=document.getElementById('PCTDesc')
	obj.onchange();
    */ 
	
}


document.body.onload = DocumentLoadHandler;