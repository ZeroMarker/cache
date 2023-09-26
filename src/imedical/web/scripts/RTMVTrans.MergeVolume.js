// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var MergeMessage=false;
var VolnonExistant=false;
var MVREQUIRED=false;
var SameVolume=false;
var REQEXISTS=false;
function UpdateClickHandler() {
	var AllowToUpdate=true;
	var AllowToUpdate=ValidateField(); //ANA LOG 333212

	if (AllowToUpdate) AllowToUpdate=CheckMRType_VolDesc();
	//alert("allow 2update 1 "+AllowToUpdate);
	if (AllowToUpdate) AllowToUpdate=CheckSame_VolDesc();
	//alert("allow 2update 2 "+AllowToUpdate);
	if (AllowToUpdate) AllowToUpdate=CheckExist_VolDesc();
	if (AllowToUpdate) AllowToUpdate=CheckExist_Requests();
	//alert("allow 2update 3 "+AllowToUpdate);
	//if (AllowToUpdate) && (mvobj.value!==") AllowToUpdate=MultiCheck(mvobj.value,);
	
	if (AllowToUpdate) {
		//alert("REQEXISTS "+REQEXISTS)
		if (REQEXISTS) {
			if (confirm(t['Vol_HasRequests'])) {
				return Update_click();
				//Log 31638 PeterC 06/03/03 now calls websys.close.csp
				//window.close();
			}
		} else {
			return Update_click();
		}
	} else {
		if (MVREQUIRED) {
				alert(t['MV_REQUIRED']);
				MVREQUIRED=false;
		}	
		if ((MergeMessage)||(SameVolume)) {
				alert(t['Merge_Message']);
				if ((mvobj) && (mvobj.value!="")) mvobj.select();
				MergeMessage=false;
				SameVolume=false;
		}
		if(VolnonExistant) {
				alert(t['Vol_nonExistant']);
				if ((mvobj) && (mvobj.value!="")) mvobj.select();
				VolnonExistant=false;
		}
	}

}
function CheckExist_Requests(){
	var reqobj=document.getElementById("RequestID")
	if ((reqobj)&&(reqobj.value!="")) REQEXISTS=true;
	return true;
}
function Check_VolDesc(){
	var found=false;
	if ((mvobj)&&(mvobj.value=="")) {
		//alert("MVREQUIRED=true");
		MVREQUIRED=true;
		found=true;
	}
	return found;
}
function MultiCheck(val,obj) {
	//alert("in mult check fn");
	var num="";
	var found=false;
	match1=0;
	if (obj) num=obj.value.toUpperCase();
	//alert("passed: "+val);
	//alert("num: "+num);
	val="^"+val;
	match1 = val.indexOf("^"+num+"^");	
	if (match1>=0) found=true;

	return found;
}
function CheckSame_VolDesc(){
	var VolumeFrom="";
	var VolumeTo="";
	var vfobj=document.getElementById("MergeVolDescFrom");
	if (vfobj) VolumeFrom=vfobj.value;
	var mtobj=document.getElementById("MergeReqToVol");
	if (mtobj) VolumeTo=mtobj.value;

	var tfobj=document.getElementById("TypeFrom");
	//alert("HERE" + mtobj.value + " " + vfobj.value );
	if (tobj) {
		if ((VolumeFrom==VolumeTo)) {
			if ((tobj.value=="")||(tobj.value==tfobj.value)){
				SameVolume=true;
				return false;
			}
		}
	}
	return true;
}
function  CheckExist_VolDesc() {
	var found=true;
	var vols=cvobj.value+"^";
	
	//alert("mvobj.value 1 "+mvobj.value+" vols "+vols);
	if ((mvobj)&&(mvobj.value!="")) {
		matchfound=vols.indexOf("^"+mvobj.value+"^");
		if (matchfound>=0) {
			found=true;
		}
		else{
			VolnonExistant=true;
			//alert("cannont merge volume with a volume not present on list.");
		}
	}
	return found;
}
function CheckMRType_VolDesc() {
	//alert("check");
	var found=true;
	var tobj=document.getElementById("typeID");
	var tfobj=document.getElementById("TypeFrom");
	var dobj=document.getElementById("MergeVolumeDesc");
	var dfobj=document.getElementById("MergeVolDescFrom");
	//alert("curtype:"+tobj.value+"typefrom:"+tfobj.value);
	//alert("currdesc:"+dobj.value+"fromdesc:"+dfobj.value);

	if ((tobj) && (tobj.value!="")) {
		if ((tfobj) && (tfobj.value!="")) {
			if (tobj.value==tfobj.value) {
				if ((dobj) && (dobj.value!="")) {
					if ((dfobj) && (dfobj.value!="")) {
						if (dobj.value==dfobj.value) {
							found=false;
							MergeMessage=true;							
						}
					}
				
				}
			}
		}
	}
	return found;

}

function SetField() {

	var lbl=document.getElementById("cMergeVolumeDesc");
	if ((tobj) && (tobj.value=="")) {
		var mvobj=document.getElementById("MergeVolumeDesc");
		if (mvobj) if (lbl) lbl = lbl.className = "";			
	}

}

function ValidateField() {
	var found=true;
	var mrObj=document.getElementById("MergeReqToVol")
	var lbl=document.getElementById("cMergeVolumeDesc");
	var mvobj=document.getElementById("MergeVolumeDesc");
	if ((mrObj)&&(mrObj.value!="")&&(mvobj) && (mvobj.value=="")) {
		MVREQUIRED=true;
		if ((tobj) && (tobj.value!="")) {
			if (lbl) lbl = lbl.className = "clsRequired";	
		}
		found=false;
	}
	//alert("found "+found);
	return found;
}
//AmiN log 24739  02 May, 2002  I commented this out and add to BodyLoadHandler
//function WindowSize() {
	//this.resizeTo(400,160)

//}

function LookUpTypeSelect(str) {
	//alert(str);
	var lu=str.split("^");
	var tidobj=document.getElementById("typeID");

	if (tidobj) tidobj.value=lu[1];
}



function BodyUnLoadHandler() {
	//Log 31638 PeterC 06/03/03 now calls websys.close.csp
	//window.close();
}

function LookSelectVolume(str) {
	//alert(str);
	var lu=str.split("^");
	var volobj=document.getElementById("MergeReqToVol");
	if (volobj) volobj.value=lu[1];
	var volidobj=document.getElementById("MergeReqToVolID");
	if (volidobj) volidobj.value=lu[2];
	

}
function LookUpMergeVolumeDesc(str) {
	//alert(str);
	var lu=str.split("^");
	var volobj=document.getElementById("MergeVolumeDesc");
	if (volobj) volobj.value=lu[0];
	
}

function BodyLoadHandler() {
	if (tsc['Update']) websys_sckeys[tsc['Update']]=UpdateClickHandler;
	//AmiN log 24739  02 May, 2002;
	//alert("At the BodyLoadHandler");
	//if (self==top) websys_reSizeT();
}

document.body.onload=BodyLoadHandler;
//if (self==top) WindowSize();
var uobj=document.getElementById("Update");
if (uobj) uobj.onclick=UpdateClickHandler;
var mvobj=document.getElementById("MergeVolumeDesc");
//if (mvobj) mvobj.onblur=ValidateField;
var tobj=document.getElementById("type");
if (tobj) tobj.onblur=SetField;
if (tobj) tobj.focus();
var cmobj=document.getElementById("CURRENTMRTYPE")
var cvobj=document.getElementById("CURRENTVOLDESC")
document.body.onunload=BodyUnLoadHandler;