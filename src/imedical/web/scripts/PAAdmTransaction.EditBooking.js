//Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
function PAAdmTransactionEditBookingBodyLoadHandler() {
   	if (self==top) websys_reSizeT();
	//var objward=document.getElementById('TRANSWardDR');
	//if (objward) objward.onblur=WardDeptChangeHandler;
	//var objdept=document.getElementById('TRANSDeptDR');
	//if (objdept) objdept.onblur=WardDeptChangeHandler;
	
	var obj=document.getElementById('TRANSStartDate');
	if (obj) obj.onblur=StartDateBlurHandler;
	
	var obj=document.getElementById('update1')
	if (obj) obj.onclick = UpdateHandler;
	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateHandler;
	LoadPTypeVStat(); 
}

function UpdateHandler(e) {
	var msg="";
	//alert("UPDATE");
	var objward=document.getElementById('TRANSWardDR');
	var objdept=document.getElementById('TRANSDeptDR');
	
	//if ((((objward)&&(objward.value==""))&&((objdept)&&(objdept.value=="")))||(((objward)&&(objward.value==""))&&(!objdept))||(((objdept)&&(objdept.value==""))&&((!objward))) {
	if (((objward)&&(objward.value==""))&&((objdept)&&(objdept.value==""))) {
		msg += "" + t['WARDORDEPT'] + "\n";
	}
	var eSrc=websys_getSrcElement(e);
	
	// ab 3.09.03 - return to the same workflow item
	// ab 42069 28.06.03 - moved this into workflow transition expr
	//var twkfli=document.forms["fPAAdmTransaction_EditBooking"].TWKFLI;
	//var tdirty=document.forms["fPAAdmTransaction_EditBooking"].TDIRTY;
	//if ((tdirty)&&(tdirty.value!=2)&&(twkfli)) twkfli.value=eval(twkfli.value)-1;
	
	if (msg!="") {alert(msg);return false;}
	return update1_click();

}

function WardDeptChangeHandler(e) {
	
	var objward=document.getElementById('TRANSWardDR');
	var objdept=document.getElementById('TRANSDeptDR');

		
	if ((objward)&&(objward.value!="")) {if (objdept) objdept.className="";}
	if ((objdept)&&(objdept.value!="")) {if (objward) objward.className="";}	
}

function StartDateBlurHandler(e) {
	var eobj=websys_getSrcElement(e);
	if (eobj) {
		var obj=document.getElementById("TRANSStartDateH");
		if ((obj)&&(eobj.value!="")) obj.value=DateStringTo$H(eobj.value);
		if ((obj)&&(eobj.value=="")) obj.value=obj.defaultValue;
	}
}

function DeptChangeHandler(str) {
	var lu = str.split("^");
	var obj=document.getElementById("TRANSDeptDR");
	if (obj) obj.value=lu[1];
	var obj=document.getElementById("HOSPDesc");
	if (obj) obj.value=lu[6];
}

function LoadPTypeVStat() {
	try {
		Custom_LoadPTypeVStat();
	} catch(e) { 
		}	finally  {
	}

}

document.body.onload=PAAdmTransactionEditBookingBodyLoadHandler;
