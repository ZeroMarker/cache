// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.


// update to reload in the parent frame
if ((parent)&&(parent.frames)&&(parent.frames["MRPsychDetailsEdit"])) {
    var frame=document.getElementById("TFRAME");
    if (frame) frame.value=window.parent.name;
}

function Init() {
	var obj;
	
	obj=document.getElementById('PSYCHDateFrom');
	if (obj) obj.onchange=CodeTableValidationDate;
	
	obj=document.getElementById('PSYCHDateTo');
	if (obj) obj.onchange=CodeTableValidationDate;
	
	obj = document.getElementById("update1")
	if (obj) obj.onclick = UpdateClickHandler;
	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateClickHandler;
	
	obj = document.getElementById("delete1")
	if (obj) obj.onclick = DeleteClickHandler;
	if (tsc['delete1']) websys_sckeys[tsc['delete1']]=DeleteClickHandler;
    
    // ab 31.01.05 - 49082 et al: disable or bold links as appropriate
    var obj=document.getElementById("ID");
    var objlink=document.getElementById("MRPsychTribunal");
    var objlink2=document.getElementById("MentalCategory");
    var objlink3=document.getElementById("TreatmentForm");
    var objbold=document.getElementById("BoldLinks");
    if ((obj)&&(obj.value=="")) {
        if (objlink) {
            objlink.disabled=true;
            objlink.onclick=Disabled;
        }
        if (objlink2) {
            objlink2.disabled=true;
            objlink2.onclick=Disabled;
        }
        if (objlink3) {
            objlink3.disabled=true;
            objlink3.onclick=Disabled;
        }
    }

    if ((objbold)&&(objbold.value!="")) {
        var BoldLink = objbold.value.split("^");
        if ((objlink)&&(BoldLink[0]!="")) objlink.style.fontWeight="bold";
        if ((objlink2)&&(BoldLink[1]!="")) objlink2.style.fontWeight="bold";
        if ((objlink3)&&(BoldLink[2]!="")) objlink3.style.fontWeight="bold";
    }
	
}


function CodeTableValidationDate(e) {
	
	var eSrc=websys_getSrcElement(e);
	if (eSrc.id=="PSYCHDateFrom") {PSYCHDateFrom_changehandler(e);}
	if (eSrc.id=="PSYCHDateTo") {PSYCHDateTo_changehandler(e);}
	
	var PSYCHDateFrom;
	var PSYCHDateTo;
	var obj;
	
	obj=document.getElementById('PSYCHDateFrom');
	if ((obj)&&(obj.value!="")) {
		var PSYCHDateFrom=DateStringTo$H(obj.value);
	}
	obj=document.getElementById('PSYCHDateTo');
	if ((obj)&&(obj.value!="")) {
		var PSYCHDateTo=DateStringTo$H(obj.value);
	}
	
	obj=document.getElementById('CodeTableValidationDate');
	//have to initiate CTVdate to $h in case of clearing values in target date fields
	if (obj) { obj.value=DateStringTo$HToday() };
	if ((obj)&&(obj.value!="")) {
		if ((PSYCHDateFrom)&&(PSYCHDateFrom.value!="")) {
			obj.value=PSYCHDateFrom;
		}
		if ((PSYCHDateTo)&&(PSYCHDateTo.value!="")) {
			obj.value=PSYCHDateTo;
		}
		
	}
	/*
	obj=document.getElementById('LSDesc')
	obj.onchange();
	obj=document.getElementById('MCDesc')
	obj.onchange();
	obj=document.getElementById('PENSTDesc')
	obj.onchange();
	obj=document.getElementById('RFCAREDesc')
	obj.onchange();
	obj=document.getElementById('USACCDesc')
	obj.onchange();
	obj=document.getElementById('EMPLSTDesc')
	obj.onchange();
	*/
	
}

function UpdateClickHandler(e) {
	//var frm = document.forms["fMRPsychDetails_Edit"];
	//if (parent.frames["MRPsychDetailsEdit"]) {
	//	frm.elements['TFRAME'].value=window.parent.name;
	//}
	var obj=document.forms['fMRPsychDetails_Edit'].elements['TWKFLI'];
	if (!(fMRPsychDetails_Edit_submit())) return false;
	// ab 22.06.04 - 44743 - enabled this again
	if (obj.value!="") obj.value-=1;
		
	return update1_click();
}

function DeleteClickHandler(e) {
	if (parent.frames["MRPsychDetailsEdit"]) {
		var frm = document.forms["fMRPsychDetails_Edit"];
		frm.target = "_parent"
		//if (frm.elements['TWKFL']!="") frm.elements['TFRAME'].value=window.parent.name;
	}
		var obj=document.forms['fMRPsychDetails_Edit'].elements['TWKFLI'];
		if (!(fMRPsychDetails_Edit_submit())) return false
		if (obj.value!="") obj.value-=1;
		
		return delete1_click()
}

function Disabled() {
    return false;
}

function LSDescLookupSelect(str) {
    var lu=str.split("^");
    var obj=document.getElementById("LEGSTDays");
    if (obj) obj.value=lu[3];
}


document.body.onload=Init;


