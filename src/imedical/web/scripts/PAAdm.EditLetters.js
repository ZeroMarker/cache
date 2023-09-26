// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var TDIRTY=0;

function BodyLoadHandler() {
	
	var obj=""
	var PatLetter=document.getElementById('PAADMPatientLetterNotes');
	var DocLetter=document.getElementById('PAADMDoctorLetterNotes');
	
	
	if (window.opener) {
		if (window.opener.document.forms['fPAAdm_Edit']) {
			
			obj=window.opener.document.forms['fPAAdm_Edit'].elements['PAADMPatientLetterNotes']
			if ((obj)&&(PatLetter)) {
				PatLetter.value=obj.value
				TDIRTY=1
				
			}
			
			obj=window.opener.document.forms['fPAAdm_Edit'].elements['PAADMDoctorLetterNotes']
			if ((obj)&&(DocLetter)) {
				DocLetter.value=obj.value
				TDIRTY=1
			}
			
		}
	}
	
	
		
	var obj = document.getElementById("update1")
	obj.onclick = UpdateClickHandler;
	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateClickHandler;
}


function UpdateClickHandler() {
	var frm=document.forms['fPAAdm_EditLetters']
	if (window.opener) {
	   var doc=window.opener.document;
	   var obj=doc.getElementById("LetterNotes");
		if (window.opener.document.forms['fPAAdm_Edit']) {
			if (TDIRTY=1) window.opener.document.forms['fPAAdm_Edit'].elements['TDIRTY'].value=2;
			if (frm.elements['PAADMPatientLetterNotes']) window.opener.document.forms['fPAAdm_Edit'].elements['PAADMPatientLetterNotes'].value=frm.elements['PAADMPatientLetterNotes'].value;
			if (frm.elements['PAADMDoctorLetterNotes']) window.opener.document.forms['fPAAdm_Edit'].elements['PAADMDoctorLetterNotes'].value=frm.elements['PAADMDoctorLetterNotes'].value;
	  	    if ((obj)&& ((frm.elements['PAADMPatientLetterNotes'])&&(frm.elements['PAADMPatientLetterNotes'].value!="")||
			(frm.elements['PAADMDoctorLetterNotes'])&&(frm.elements['PAADMDoctorLetterNotes'].value!="")))   {
					obj.style.fontWeight="bold";
					} else {
					obj.style.fontWeight="normal";
			}	
		}
	}
	return update1_click();
} 

document.body.onload=BodyLoadHandler;
