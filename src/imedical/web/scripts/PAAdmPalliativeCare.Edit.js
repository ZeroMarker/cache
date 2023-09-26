// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var TDIRTY=0;

function BodyLoadHandler() {
	var obj=""
	var inpat=document.getElementById('PAADMPrevInPatAdmPalliativeCare');
	var noninpat=document.getElementById('PAADMPrevNonInPatPalliativeCare');
	
	if (window.opener) {
		if (window.opener.document.forms['fPAAdm_Edit']) {
			obj=window.opener.document.forms['fPAAdm_Edit'].elements['PAADMPrevInPatAdmPalliativeCare']
			if ((obj)&&(inpat)) {
				inpat.value=obj.value
				TDIRTY=1
			}
			obj=window.opener.document.forms['fPAAdm_Edit'].elements['PAADMPrevNonInPatPalliativeCare']
			if ((obj)&&(noninpat)) {
				noninpat.value=obj.value
				TDIRTY=1
			}
		}
		if (window.opener.document.forms['fPAADMDischarge_Edit']) {
			obj=window.opener.document.forms['fPAADMDischarge_Edit'].elements['PAADMPrevInPatAdmPalliativeCare']
			if ((obj)&&(inpat)) {
				inpat.value=obj.value
				TDIRTY=1
			}
			obj=window.opener.document.forms['fPAADMDischarge_Edit'].elements['PAADMPrevNonInPatPalliativeCare']
			if ((obj)&&(noninpat)) {
				noninpat.value=obj.value
				TDIRTY=1
			}
		}
	}
	var obj = document.getElementById("dischargecheck")
	var objVS=document.getElementById("VisitStatusCode")
	if ((objVS)&&(objVS.value=="D")) {
		var obj1 = document.getElementById("PAADMPrevInPatAdmPalliativeCare");
		if (obj1) labelMandatory("PAADMPrevInPatAdmPalliativeCare");
		var obj2 = document.getElementById("PAADMPrevNonInPatPalliativeCare");
		if (obj2) labelMandatory("PAADMPrevNonInPatPalliativeCare");
		if (obj) obj.value="1";
	}
	var obj = document.getElementById("update1")
	obj.onclick = UpdateClickHandler;
	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateClickHandler;
}

function UpdateClickHandler() {
		if (!CheckMandatoryFields()) { return }
		var frm=document.forms['fPAAdmPalliativeCare_Edit']
		if (window.opener) {
			var doc=window.opener.document;
			var obj=doc.getElementById("PalliativeCare");
			if (window.opener.document.forms['fPAAdm_Edit']) {
		        if (TDIRTY=1) window.opener.document.forms['fPAAdm_Edit'].elements['TDIRTY'].value=2;
				if (frm.elements['PAADMPrevNonInPatPalliativeCare']) window.opener.document.forms['fPAAdm_Edit'].elements['PAADMPrevNonInPatPalliativeCare'].value=frm.elements['PAADMPrevNonInPatPalliativeCare'].value;
				if (frm.elements['PAADMPrevInPatAdmPalliativeCare']) window.opener.document.forms['fPAAdm_Edit'].elements['PAADMPrevInPatAdmPalliativeCare'].value=frm.elements['PAADMPrevInPatAdmPalliativeCare'].value;
				if ((obj)&& ((frm.elements['PAADMPrevNonInPatPalliativeCare'])&&(frm.elements['PAADMPrevNonInPatPalliativeCare'].value!="")||
			   	(frm.elements['PAADMPrevInPatAdmPalliativeCare'])&&(frm.elements['PAADMPrevInPatAdmPalliativeCare'].value!="")))   {
						obj.style.fontWeight="bold";
						} else {
					    obj.style.fontWeight="normal";
				}
			}	
			if (window.opener.document.forms['fPAADMDischarge_Edit']) {
			 	if (TDIRTY=1) window.opener.document.forms['fPAADMDischarge_Edit'].elements['TDIRTY'].value=2;
			 	if (frm.elements['PAADMPrevNonInPatPalliativeCare']) window.opener.document.forms['fPAADMDischarge_Edit'].elements['PAADMPrevNonInPatPalliativeCare'].value=frm.elements['PAADMPrevNonInPatPalliativeCare'].value;
				 if (frm.elements['PAADMPrevInPatAdmPalliativeCare']) window.opener.document.forms['fPAADMDischarge_Edit'].elements['PAADMPrevInPatAdmPalliativeCare'].value=frm.elements['PAADMPrevInPatAdmPalliativeCare'].value;
				 if ((obj)&& ((frm.elements['PAADMPrevNonInPatPalliativeCare'])&&(frm.elements['PAADMPrevNonInPatPalliativeCare'].value!="")||
			   	(frm.elements['PAADMPrevInPatAdmPalliativeCare'])&&(frm.elements['PAADMPrevInPatAdmPalliativeCare'].value!="")))   {
						obj.style.fontWeight="bold";
						} else {
					    obj.style.fontWeight="normal";
				}
			}	
	}
   return update1_click();
}

function labelMandatory(fld) {
	var lbl = document.getElementById('c' + fld)
	if (lbl) {
		lbl.className = "clsRequired";
	}
}
function CheckMandatoryFields() {

	var msg="";

	
	var obj1 = document.getElementById("PAADMPrevInPatAdmPalliativeCare");
	var obj2 = document.getElementById("PAADMPrevNonInPatPalliativeCare");

	
	if ((obj1)&&(obj1.value==""))
	{
	var fld='PAADMPrevInPatAdmPalliativeCare';
	var lbl = document.getElementById('c' + fld)
	if ((lbl)&&(lbl.className == "clsRequired"))
		{		
		msg += "\'" + t['PAADMPrevInPatAdmPalliativeCare'] + "\' " + t['XMISSING'] + "\n";
		}
	}

	if ((obj2)&&(obj2.value==""))
	{
	var fld='PAADMPrevNonInPatPalliativeCare';
	var lbl = document.getElementById('c' + fld)
	if ((lbl)&&(lbl.className == "clsRequired"))
		{		
		msg += "\'" + t['PAADMPrevNonInPatPalliativeCare'] + "\' " + t['XMISSING'] + "\n";
		}
	}
	
			
	if (msg != "") {
		alert(msg)
		return false;
	} else {
		return true;
	}
}

document.body.onload=BodyLoadHandler;
