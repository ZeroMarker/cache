// Copyright (c) 2003 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
// ANA LOG 33237

if (parent.frames["MicroFilmBulkList"])	document.forms['fRTMaster_MicroFilmBulkEdit'].target="MicroFilmBulkList";

function RollNumberSelHandler(str){
	//alert(str);
	var context,TWKFL="",TWKFLI="";
	var lu=str.split("^");
	var Oobj=document.getElementById("OEMFRollDesc");
	if (Oobj) Oobj.value=lu[0];
	var Bobj=document.getElementById("IsBulkEdit");
	var Hobj=document.getElementById("HospitalDR");
	if((Bobj)&&(Bobj.value=="Y")) {
		var Robj=document.getElementById("OEMFRollID");
		var PVObj=document.getElementById("PinVerified");
		var Tobj=document.getElementById("TWKFL");
		if (Tobj) TWKFL=Tobj.value;
		var TIobj=document.getElementById("TWKFLI");
		if (TIobj) TWKFLI=TIobj.value;
		context=session['CONTEXT'];
		var path="rtbulkmicrofilmframes.csp?OEMFRollID="+Robj.value+"&OEMFRollRowId="+Robj.value+"&IsBulkEdit="+"Y"+"&PinVerified="+PVObj.value+"&TWKFL="+TWKFL+"&TWKFLI="+TWKFLI+"&CONTEXT="+context;
		//var path="rtbulkmicrofilmframes.csp?OEMFRollID="+Robj.value+"&IsBulkEdit="+"Y"
		if ((Hobj)&&(Hobj.value!="")) path=path+"&HospitalDR="+Hobj.value;
		window.location=path;
	}
	else{return true;}
}

function OEMFRollID_changehandler(encmeth) {	//have to have for broker only!!!
	var obj=document.getElementById('HospitalDR');
	var p1='';
	if (obj) p1=obj.value;
	var obj=document.getElementById('OEMFRollID');
	var p2='';
	if (obj) p2=obj.value;
	if (cspRunServerMethod(encmeth,'','RollNumberSelHandler',p1,p2)=='0') {
		obj.className='clsInvalid';  ///generic name to check all fields. 
		obj.focus();
		return websys_cancel();
	} else {
		obj.className='';
	}
}

function URSelectHandler(str) {
	var lu=str.split("^");
	var obj=document.getElementById("RegNo");
	if (obj) obj.value=lu[0];
}

function RegNo_changehandler(encmeth) {	//have to have for broker only!!!
	var obj=document.getElementById('RegNo');
	var p1='';
	if (obj) p1=obj.value;
	var obj=document.getElementById('RegNo');
	if (cspRunServerMethod(encmeth,'','URSelectHandler',p1)=='0') {
		obj.className='clsInvalid';  ///generic name to check all fields. 
		obj.focus();
		return websys_cancel();
	} else {
		obj.className='';
	}
}

function POSPosition_changehandler(encmeth) {	//have to have for broker only!!!
	var obj=document.getElementById('OEMFRollID');
	var p1='';
	if (obj) p1=obj.value;
	var obj=document.getElementById('POSPosition');
	var p2='';
	if (obj) p2=obj.value;
	var obj=document.getElementById('HospitalDR');
	var p3='';
	if (obj) p3=obj.value;
	
	if (cspRunServerMethod(encmeth,'','PosNumberSelHandler',p1,p2,p3)=='0') {
		obj.className='clsInvalid';  ///generic name to check all fields. 
		obj.focus();
		return websys_cancel();
	} else {
		obj.className='';
	}
	p2='';
}
function PosNumberSelHandler(str) {
		var lu=str.split("^");
		var obj=document.getElementById('hidPosDupSURName');
		if(obj) obj.value=lu[5];
		var obj=document.getElementById('hidPosDupGIVName');
		if(obj) obj.value=lu[6];
		var obj=document.getElementById('hidPosDupMRN');
		if(obj) obj.value=lu[2];
		var obj=document.getElementById('hidPosDupRoll');
		if(obj) obj.value=lu[9];
		var obj=document.getElementById('hidPosDupPosition');
		if(obj) obj.value=lu[1];
		var obj=document.getElementById('RTMASMRNo');
		if(obj) obj.value=lu[2];
		var obj=document.getElementById('RegNo');
		if(obj) obj.innerText=lu[3];
		var obj=document.getElementById('MRType');
		if(obj) obj.innerText=lu[4];
		var obj=document.getElementById('SURName');
		if(obj) obj.innerText=lu[5];
		var obj=document.getElementById('GIVName');
		if(obj) obj.innerText=lu[6];
		var obj=document.getElementById('DOB');
		if(obj) obj.innerText=lu[7];
		var obj=document.getElementById('POSComment');
		if(obj&&(lu[2]!="")) obj.value=lu[8];
		if(obj&&(lu[2]=="")) obj.value="";
		if (lu[10]=="") {
			alert(t['BLANK_ROLLID']+" "+t['OEMFRollID']);
			var obj=document.getElementById('POSPosition');
			if (obj) obj.value="";
		}
}

function SelectMRTypeHandler(){
	//alert("str: "+str);
	var obj=document.getElementById('RTMASMRNo');
	if (obj) obj.value=""
}

function RTMASMRNoSelectHandler(str) {
	//alert(str)
	var lu=str.split("^");
	//var obj=document.getElementById('MRType');
	//if(obj) obj.innerText=lu[6];
	var obj=document.getElementById('RegNo');
	if(obj) obj.innerText=lu[1];
	var obj=document.getElementById('SURName');
	if(obj) obj.innerText=lu[2];
	var obj=document.getElementById('GIVName');
	if(obj) obj.innerText=lu[3];
	var obj=document.getElementById('DOB');
	if(obj) obj.innerText=lu[4];
	var obj=document.getElementById('POSRTMAS');
	if(obj) {
			obj.value=lu[7];
	}
}

function RTMASMRNo_changehandler(encmeth) {	//have to have for broker only!!!
	var obj=document.getElementById('RTMASMRNo');
	var p1='';
	if (obj) p1=obj.value;
	var obj=document.getElementById('HospitalDR');
	var p2='';
	if (obj) p2=obj.value;
	var obj=document.getElementById('PatientID');
	var p3='';
	if (obj) p3=obj.value;
	var obj=document.getElementById('MRType');
	var p4='';
	if (obj) p4=obj.value;
	var obj=document.getElementById('RTMASMRNo');
	if (cspRunServerMethod(encmeth,'','RTMASMRNoSelectHandler',p1,p2,p3,p4)=='0') {
		obj.className='clsInvalid';  ///generic name to check all fields. 
		obj.focus();
		return websys_cancel();
	} else {
		obj.className='';
	}
}

function UpdateClickHandler(){
	var sobj=document.getElementById("hidPosDupSURName");
	var gobj=document.getElementById("hidPosDupGIVName");
	var mobj=document.getElementById("hidPosDupMRN");
	var robj=document.getElementById("hidPosDupRoll");
	var pobj=document.getElementById("hidPosDupPosition");
	var pinobj=document.getElementById("PIN");
	//Log 44217 PeterC 31/08/05
	var pinverobj=document.getElementById("ValidPin");
	var Valid="Y";
	if((pinverobj)&&(!pinverobj.checked)) Valid="N";
	var errorstr="";
	var OK="Y";

	if (!isMandatory("PIN")){
		alert(t['PIN']+" "+t['XMISSING']);
		return false;
	}

	if((Valid=="N")&&(pinobj)&&(pinobj.value!="")){
		alert(t['PIN']+" "+t['XINVALID']);
		return false;
	}
	
	
	if ((sobj)&&(sobj.value!="")&&(gobj)&&(gobj.value!="")&&(mobj)&&(mobj.value!="")&&(robj)&&(robj.value!="")&&(pobj)&&(pobj.value!="")) {
		//var cont=confirm("Roll:"+robj.value+"\n"+"Position:"+pobj.value+"\n"+"is currently occupied by"+"\n"+gobj.value+" "+sobj.value+"\n"+"UR:"+mobj.value+"\n"+"Do you wish to overwrite?");		
		var cont=confirm(t['OEMFRollID']+":"+robj.value+"\n"+t['POSPosition']+":"+pobj.value+"\n"+t['OCCUPIED']+gobj.value+" "+sobj.value+"\n"+t['RTMASMRNo']+":"+mobj.value+"\n"+t['CONTINUE']);
		//var cont=confirm("Do you wish to overwrite?");
		if (!cont) {
			return false;
		}
	}
	
	var obj=document.getElementById("OEMFRollID");
	if ((obj)&&(obj.value!="")) {
		if (isNaN(obj.value)) {
			alert(t['ROLL_NUMERIC']);
			return false;
		}
	}

	var obj=document.getElementById("POSPosition");
	if ((obj)&&(obj.value!="")) {
		if (isNaN(obj.value)) {
			alert(t['POS_NUMERIC']);
			return false;
		}
	}
	
	if (!isInvalid("OEMFRollID")){
		errorstr=errorstr+t['OEMFRollID']+",";
		OK="N";	
	}

	if (!isInvalid("POSPosition")){
		errorstr=errorstr+t['POSPosition']+",";
		OK="N";
	}
	//alert(document.getElementById("hidMFMRType").value);
	if (!isInvalid("MRType")){
		errorstr=errorstr+t['MRType']+",";
		OK="N";
	}

	if (!isInvalid("RTMASMRNo")){
		errorstr=errorstr+t['RTMASMRNo']+",";
		OK="N";
	}
	
	if(OK!="Y") {
		alert(errorstr+t['XINVALID']);
		return false;
	}
	return Update_click();
}

function isMandatory(fldName)
{
	var fld = document.getElementById(fldName)
	var lbl = document.getElementById("c"+fldName);
	if ((lbl)&&(lbl.className=="clsRequired")) {
		if ((fld)&&(fld.value==""))	return false;
	}
	return true;
}

function isInvalid(fldName) {
	var fld = document.getElementById(fldName);
	if ((fld)&&(fld.tagName=="INPUT")) {
		if (fld.className == "clsInvalid")	return false;
	}
	return true;
}

function BodyLoadHandler() {
	var UCobj=document.getElementById("UserCode");
	if (UCobj) UCobj.onchange=UserCodeChangeHandler;
	var PVObj=document.getElementById("PinVerified");
	var PObj=document.getElementById("PIN");
	var CPObj=document.getElementById("cPIN");
	if ((PVObj)&&(PVObj.value!="Y")){
		if(CPObj) CPObj.className = "clsRequired";
	}

	var MFobj=document.getElementById("MFMRType");
	var hMFobj=document.getElementById("hidMFMRType");
	if((MFobj)&&(hMFobj)) {
		hMFobj.value=MFobj.value
		//alert(hMFobj.value)
	}

	MFTypeByHosp();
	//Log 44217 PeterC 26/08/05
	var obj=document.getElementById("RTMASMRNo");
	if(obj) obj.onchange();

	//Log 44217 PeterC 31/08/05
	var PIN=document.getElementById("PIN");
	if (PIN) PIN.onblur=ValidatePIN;
}

function MFTypeByHosp() {

}

function UserCodeChangeHandler() {
	//alert("Here");
	var PVObj=document.getElementById("PinVerified");
	if (PVObj) PVObj.value="";
	var CPObj=document.getElementById("cPIN");
	if ((PVObj)&&(PVObj.value!="Y")){
		if(CPObj) CPObj.className = "clsRequired";
	}
}

function DeleteClickHandler() {

	var pinobj=document.getElementById("PIN");
	var errorstr="";
	var OK="Y";

	if (!isMandatory("PIN")){
		alert(t['PIN']+" "+t['XMISSING']);
		return false;
	}
	
	var obj=document.getElementById("OEMFRollID");
	if ((obj)&&(obj.value!="")) {
		if (isNaN(obj.value)) {
			alert(t['ROLL_NUMERIC']);
			return false;
		}
	}

	var obj=document.getElementById("POSPosition");
	if ((obj)&&(obj.value!="")) {
		if (isNaN(obj.value)) {
			alert(t['POS_NUMERIC']);
			return false;
		}
	}
	
	if (!isInvalid("OEMFRollID")){
		errorstr=errorstr+t['OEMFRollID']+",";
		OK="N";	
	}

	if (!isInvalid("POSPosition")){
		errorstr=errorstr+t['POSPosition']+",";
		OK="N";
	}
	
	if(OK!="Y") {
		alert(errorstr+t['XINVALID']);
		return false;
	}
	
	return Delete_click();
}

function UpdateDetailClickHandler() {
	var Eobj=document.getElementById("ExitPage");
	var Pobj=document.getElementById("PIN");
	if((Pobj)&&(Pobj.value=="")) {
		alert(t['PIN']+" "+ t['UPDATE_NOPSWD']+" "+t['Update']);
		return false;
	}
	if (Eobj) Eobj.value="Y";
	DelayUpdateClickHandler();
}

//var Robj=document.getElementById("OEMFRollID");
//if (Robj) Robj.onchange=RollNumberSelHandler;

var Uobj=document.getElementById("Add");
if (Uobj) Uobj.onclick=DelayUpdateClickHandler;

var UPobj=document.getElementById("Update");
if (UPobj) UPobj.onclick=UpdateDetailClickHandler;

var Dobj=document.getElementById("Delete");
if (Dobj) Dobj.onclick=DeleteClickHandler;
document.body.onload=BodyLoadHandler;

//Log 44217 PeterC 31/08/05
function ValidatePIN(){
	var UserCode=document.getElementById("UserCode");
	var PIN=document.getElementById("PIN");
	var ValidPIN=document.getElementById("ValidPin");
	ValidPIN.checked=false;
	var path="arreceipts.validpin.csp?UserCode="+UserCode.value+"&PIN="+PIN.value+"&WINNAME="+window.name;
	websys_createWindow(path,"TRAK_hidden");
	return false;
}

function DelayUpdateClickHandler(){
	setTimeout("UpdateClickHandler()",200);
	return false;
}