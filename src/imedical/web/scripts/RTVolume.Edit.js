// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var objExistingTypeVol=document.getElementById("ExistingTypeVol");
var objTYPDesc=document.getElementById("TYPDesc");
var objRTMAVVolDesc=document.getElementById("RTMAVVolDesc");
var strExistingTypeVol;
var updated=0;
var mrobj=document.getElementById("URNumber");
if (mrobj) mrobj.disabled=true;

function UpdateClickHandler() {
	//Log 50353 PeterC 22/02/05
	var CLObj=document.getElementById("CompLock");
	if((CLObj)&&(CLObj.value=="Y")) return false;

	var CanNotUpdateObj=document.getElementById("CanNotUpdate");
	if  ((CanNotUpdateObj)&&(CanNotUpdateObj.value=="Y")) {
		alert(t['InactiveMRN']+"\n"+t['ReactivateMRN']);
		return false;
	}

	var PIN=document.getElementById("PIN");
	var ValidPIN=document.getElementById("ValidPin");

	//jpd added -&&(PIN.value!="")- to IF, in case of blank and non-mandatory PIN log 50775
	if ((PIN)&&(ValidPIN.checked==false)&&(PIN.value!="")) {
		var msg="";
		msg = msg + t['PIN'] + " " + t['XINVALID'] + "\n";
		alert(msg);
		websys_setfocus(PIN.name);
		PIN.className="clsInvalid"
		return false;
	}

	var Allow="";
	var AllowObj=document.getElementById("AllowToCreateMRTypeConfig");
	if (AllowObj) Allow=AllowObj.value;
	if (Allow=="Y") {
		var found=false;
		var CurrentTypeVol;
		var CurrentType;
		var CurrentVol;
		var TYPDesc;
		var VolDesc;
		//alert("strExistingTypeVol "+strExistingTypeVol)
		if ((strExistingTypeVol)&&(strExistingTypeVol!="")&&(objTYPDesc)&&(objTYPDesc.value!="")&&(objRTMAVVolDesc)&&(objRTMAVVolDesc.value!="")) {
			TYPDesc=objTYPDesc.value;
			VolDesc=objRTMAVVolDesc.value;
			var strArray=strExistingTypeVol.split("|");
			var Len=strArray.length;
			//alert("Len="+Len);
			for (var i=0; i<Len; i++) {
			//for (var i=0; mPiece(strExistingTypeVol,"|",i)=""; i++) {
				CurrentTypeVol=mPiece(strExistingTypeVol,"|",i); 
				CurrentType=mPiece(CurrentTypeVol,"^",0);
				CurrentVol=mPiece(CurrentTypeVol,"^",1);
				//alert(CurrentVol);
				if ((TYPDesc.toUpperCase()==CurrentType.toUpperCase())&&(VolDesc.toUpperCase()==CurrentVol.toUpperCase())) {
					alert(t['VOL_DESC_EXISTS']);
					found=true;
					websys_cancel();
					return false;
				}	
			}	
		}
		//Log 52729 PeterC 19/10/2006
		var CrtTempVolObj=document.getElementById("CrtTempVol");
		if((CrtTempVolObj)&&(CrtTempVolObj.value!="")) {
			var choice=confirm(t['TEMP_CRT_INACTIVE']);
			if(choice) {
				var Obj=document.getElementById("TempInactiveVol");
				if(Obj) Obj.value="Y";
			}
		}
		if (found==false) {
			if ((mrobj)&&(mrobj.disabled==false)) {
				var hidmrobj=document.getElementById("hidURNumber");
				if (hidmrobj) hidmrobj.value=mrobj.value;
			}
			updated=1;
			Update1_click();
			//return (0);
		}
	}else {
		alert(t['NotAllowToCreateMRType']);
	}

}

function mPiece(s1,sep,n) {
	//Getting wanted piece, passing (string,separator,piece number)
	//First piece starts from 0
	//Split the array with the passed delimeter
	delimArray = s1.split(sep);
	//If out of range, return a blank string
	if ((n <= delimArray.length-1) && (n >= 0)) return delimArray[n];	
}



var uobj=document.getElementById("Update1");
if (uobj) uobj.onclick=DelayOnUpdate;


if (objExistingTypeVol) {
	strExistingTypeVol=objExistingTypeVol.value;
	//alert("strExistingTypeVol="+strExistingTypeVol);
}

function TYPDescLookUpHandler(str) {
	//alert(str);
	var lu = str.split("^");
	var vobj=document.getElementById("RTMAVVolDesc");
	if (vobj) {
		vobj.value = lu[2];
	}
	var mobj=document.getElementById("CreatingLoc");
	if (mobj) {
		mobj.value = lu[3];
	}

	var mrobj=document.getElementById("MRLocation");
	if (mrobj) {
		mrobj.value = lu[3];
	}

	var mrobj=document.getElementById("URNumber");
	if (mrobj) {
		var CanNotUpdateObj=document.getElementById("CanNotUpdate");
		if (lu[4]!="INACTIVE")	{ 
			mrobj.innerText = lu[4]; 
			mrobj.value = lu[4];
			if (CanNotUpdateObj) CanNotUpdateObj.value="";
		}
		else {
			mrobj.innerText = ""; 
			mrobj.value = "";
			alert(t['InactiveMRN']+"\n"+t['ReactivateMRN']);
			if (CanNotUpdateObj) CanNotUpdateObj.value="Y";
		}
	}


}

function docLoaded() {
	var newtypeobj=document.getElementById("NewMRType");
	var DefaultTYPDescobj=document.getElementById("DefaultTYPDesc");
	if (DefaultTYPDescobj&&(DefaultTYPDescobj.value=="Y")&&newtypeobj) {
		if (newtypeobj.value!="") {
			var typdescobj=document.getElementById("TYPDesc");
			if (typdescobj) typdescobj.value=newtypeobj.value;
			var vobj=document.getElementById("RTMAVVolDesc");
			if (vobj) {
				var dvobj=document.getElementById("DefaultVolumeDesc");
				if (dvobj&&dvobj.value!="") vobj.value=dvobj.value;
				else vobj.value="1";
			}
		}
	}
	var NextVolumeObj=document.getElementById("NextVolume");
	if ((NextVolumeObj)&&(NextVolumeObj.value!="")) {
		var volObj=document.getElementById("RTMAVVolDesc");
		if (volObj) {
			volObj.value=NextVolumeObj.value;
			volObj.disabled=true;
			var VolumeDescMessageObj=document.getElementById("VolumeDescMessage");
			if (VolumeDescMessageObj) VolumeDescMessageObj.innerText=t['AutoReqNextVol1']+t['AutoReqNextVol2'];
			var typdescobj=document.getElementById("TYPDesc");
			if (typdescobj) {
				typdescobj.disabled=true;
				typdescobj.onchange();
			}
		}
	}
	SetVolIncrememtonLoad();
	if (tsc['Update1']) websys_sckeys[tsc['Update1']]=DelayOnUpdate;
	var PIN=document.getElementById("PIN");
	if (PIN) PIN.onblur=ValidatePIN;
	//Log 52729 PeterC 19/10/2006
	var CrtTempVolObj=document.getElementById("CrtTempVol");
	if((CrtTempVolObj)&&(CrtTempVolObj.value!="")) {
		var typdescobj=document.getElementById("TYPDesc");
		if ((typdescobj)&&(typdescobj.onchange)) typdescobj.onchange();
		DisableEl("TYPDesc");
	}

}

function DisableEl(str){
	var Obj=document.getElementById(str);
	var lObj=document.getElementById("ld1027i"+str);
	var cObj=document.getElementById("c"+str);
	if (Obj) Obj.disabled=true;
	if (lObj) lObj.disabled=true;
	if (cObj) cObj.disabled=true;
	if (cObj) cObj.className="";
	return;
}


//Log 49959 PeterC 20/02/05
function ValidatePIN(){
	var UserCode=document.getElementById("UserCode");
	var PIN=document.getElementById("PIN");
	var ValidPIN=document.getElementById("ValidPin");
	ValidPIN.checked=false;
	var path="arreceipts.validpin.csp?UserCode="+UserCode.value+"&PIN="+PIN.value+"&WINNAME="+window.name;
	websys_createWindow(path,"TRAK_hidden");
	
	return false;
}

//Log 49959 PeterC 20/02/05
function DelayOnUpdate(){
	setTimeout("UpdateClickHandler()",1000);
	return false;
}

function BodyUnLoadHandler() {
	var par_win = window.opener;
	if((par_win.parent.frames[1])&&(par_win.parent.frames[1].document.forms['fRTVolume_FindMultiPatientReqList'])) {
		var win=par_win.parent.frames[1].document.forms['fRTVolume_FindMultiPatientReqList'];
		if (win) {
			window.opener.treload('websys.csp');
		}
	}
}	
//function in QH custom script.
function SetVolIncrememtonLoad() {
	return;
}

document.body.onload=docLoaded;
document.body.onunload = BodyUnLoadHandler;
var tobj=document.getElementById("TYPDesc");
if ((tobj)&&(tobj.onfocus)) tobj.focus();

