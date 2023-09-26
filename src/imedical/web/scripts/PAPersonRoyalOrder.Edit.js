// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
// ab 11.11.04

var frm = document.forms["fPAPersonRoyalOrder_Edit"];

if (parent.frames["PAPersonRoyalOrder_Edit"]) {
    frm.elements['TFRAME'].value=window.parent.name;
}
    
function DocumentLoadHandler() {
    
    setCheckBoxFlag();		
    var obj = document.getElementById("update1");
	if (obj) {
		obj.onclick = UpdateClickHandler;
		if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateClickHandler;
	}
    
    var obj = document.getElementById("delete1");
	if (obj) {
		obj.onclick = DeleteClickHandler;
		if (tsc['delete1']) websys_sckeys[tsc['delete1']]=DeleteClickHandler;
	}
    
    var obj=document.getElementById("ExempLink");
    var objID=document.getElementById("ID");
    if ((obj)&&(objID)&&(objID.value=="")) {
        obj.onclick=LinkDisable;
        obj.disabled=true;
    }
	
    var obj=document.getElementById("ROHistory");
    var objID=document.getElementById("ID");
    if ((obj)&&(objID)&&(objID.value=="")) {
        obj.onclick=LinkDisable;
        obj.disabled=true;
    }	
    
    var objBold=document.getElementById('BoldLinks');
    if (objBold) {
    var BoldLink = objBold.value.split("^");
    obj=document.getElementById('ExempLink');
    if ((obj) && (BoldLink[0]=="1")) obj.style.fontWeight="bold";
    obj=document.getElementById('ROHistory');
    if ((obj) && (BoldLink[1]=="1")) obj.style.fontWeight="bold";
    } 	
    
    
    var obj=document.getElementById("ROYALDateValidFrom");
    	if (obj) obj.onblur=StartDateBlurHandler;
   	
}

function DeleteClickHandler() {
  
    var obj=frm.elements['TWKFLI'];
    if (obj.value!="") obj.value-=1;
    
    return delete1_click();
}

function UpdateClickHandler(e) {

    var eSrc = websys_getSrcElement(e);
	if (eSrc.tagName=="IMG") {
		eSrc=websys_getParentElement(eSrc);
	}
    
    if (parent.frames["PAPersonRoyalOrder_List"]) {
        var obj=frm.elements['TWKFLI'];
        var objdirty=document.getElementById("TDIRTY");
	if ((frm)&&(websys_isDirty(frm))) {
	if (!ShowAllInfoMessages()) return false;
	}
	if (!(fPAPersonRoyalOrder_Edit_submit())) return false;
        if ((objdirty)&&(objdirty.value!=2)&&(obj.value!="")) obj.value-=1;
    }
        
    return update1_click();
}

function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	if (el.disabled) { 
		return false;
	}
	return true;
}

function StartDateBlurHandler(e) {
	var eobj=websys_getSrcElement(e);
	if (eobj) {
		var obj=document.getElementById("ROYALDateValidFromH");
		if ((obj)&&(eobj.value!="")) obj.value=DateStringTo$H(eobj.value);
		if ((obj)&&(eobj.value=="")) obj.value=obj.defaultValue;
	}
}

function ShowAllInfoMessages() {
	var objPU=document.getElementById("ROYALPaysUntil");
	var objHidAmt=document.getElementById("hiddenAmounts");
	var objHidAmtArray=objHidAmt.value.split("^");
	var objAU=objHidAmtArray[2]
	var objRebill=document.getElementById("Rebill");
	if  (objRebill) { objRebill.value="";}
	var objmsg=""
	//alert("parseFloat(objAU)="+parseFloat(objAU));
	if ((objPU)&&(objPU.value!="")&&(objPU.value)<(parseFloat(objAU))) {
		if (objmsg!="") {objmsg +=t['ROUpdateIM1'] +  "\n";}
		if (objmsg=="") {objmsg=t['ROUpdateIM1'] + "\n";}
	}
	if ((objAU!="")&&(parseFloat(objAU)!=0)) {
		if (objmsg!="") {objmsg +=t['ROUpdateIM2'] +  "\n";}
		if (objmsg=="") {objmsg=t['ROUpdateIM2'] + "\n";}
	}
	if (objmsg!="") {
	if (!(confirm(objmsg))) return false;
	if (objRebill) { objRebill.value=1; }
	}
	//alert(objRebill.value);	
	return true;

}

function setCheckBoxFlag() {
	var str=new Array();
	var IsOnForm=document.getElementById('HiddenCheckbox');
	var obj=document.getElementById('ROYALExclusion');
	if (obj) { str[0]="Y" } 
	if (IsOnForm) { IsOnForm.value=str.join("^"); }
	//alert(IsOnForm.value);
	
}


document.body.onload=DocumentLoadHandler;