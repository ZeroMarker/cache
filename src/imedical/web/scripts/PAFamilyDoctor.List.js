// Copyright (c) 2003 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var f=document.getElementById("fPAFamilyDoctor_List");
var tbl=document.getElementById('tPAFamilyDoctor_List')
var objMultiActiveGP=document.getElementById("MultiActiveGP");	

function PAFamilyDoctorListLoadHandler(e) {
	var numRows=tbl.rows.length;
 	
 	for (i=1;i<numRows;i++) {
		famdocid=document.getElementById("FamRowIdz"+i);
		famdocidhidden=document.getElementById("famdocrowidhidden");
		famdocdto=document.getElementById("FDdatetoz"+i);
		setdoc=document.getElementById("FAMD_SetDoctorz"+i);		
		
		if ((famdocid)&&(famdocidhidden)&&(famdocidhidden.value==famdocid.value)&&(famdocdto)&&(famdocdto.value=="")) {
			tbl.rows[i].className="clsRowPre";
		}
	}
	var Newlinkobj=document.getElementById("New1");
	if ((Newlinkobj)&&(objMultiActiveGP)&&(objMultiActiveGP.value!="Y")) {
		Newlinkobj.disabled=true;
		Newlinkobj.onclick=LinkDisable;
	}	
	
	//log61979 Tedt
	var obj=document.getElementById("find");
	if(obj) obj.onclick=FindClickHandler;
	
	obj=document.getElementById("type");
	if(obj) obj.onblur=LookUpTypeOnBlur;
	
	
}

function SelectRowHandler(evt) {
	//websys.List.js has already set the selected row into a variable called selectedRowObj
	var url="",objType,objID;
	var eSrc=websys_getSrcElement(evt);
	//alert("TAG "+eSrc.tagName);
	var PatientID=document.getElementById('PatientID').value;
	if (eSrc.tagName=="IMG") eSrc=websys_getParentElement(eSrc);
	if (eSrc.href) {
		var temp1=eSrc.href.split("&TWKFL")
		var temp2=eSrc.href.split("&ID")
		var url = temp1[0] + "&ID" + temp2[1];
	}
	if ((eSrc.tagName=="A")&&(objMultiActiveGP)&&(objMultiActiveGP.value=="Y")) {
		if (eSrc.id.indexOf("FAMD_SetDoctorz")==0) {
			var proceed=confirm(t['SetDoctor'])
			if (proceed) {
				if (!confirm(t['OldGPActive'])) {
					websys_createWindow('pafamdoctoractive.csp?PatientID='+PatientID,'TRAK_hidden','');
				}
				return true;
			}	
			if (!proceed) {
				return false;
			}
			//else {return true;}
		} else if (eSrc.id.indexOf("FAMD_DateFromz")==0) {
			eSrc.target = "lower";
			var currentlink=eSrc.href.split("?");
			//location.href = "pafamdochist.csp?WEBSYS.TCOMPONENT=PACRefDoctor.Edit&" + currentlink[1];
			if ((objMultiActiveGP)&&(objMultiActiveGP.value=="Y")) {
				websys_createWindow("websys.default.csp?WEBSYS.TCOMPONENT=PAFamilyDoctor.Edit&" + currentlink[1] ,"PAFamilyDoctor","toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
			}
		}	
	} else {
		if (eSrc.tagName=="TD") eSrc=eSrc.firstChild;
		var eSrcAry=eSrc.id.split("z");
		if ((eSrc.children.length>0)&&(eSrc.tagName!="A")) var eSrc=eSrc.firstChild;
		var eSrcAry=eSrc.id.split("z");
		if (eSrcAry.length<=1) return false;
		var ID=document.getElementById('FamRowIdz'+eSrcAry[1]).value;
		var Clincode=document.getElementById('cliniccodez'+eSrcAry[1]).value;
		var PatientID=document.getElementById('PatientID').value;
		location.href="pafamdochist.csp?ID="+ID+"&Clincode="+Clincode+"&PatientID="+PatientID
	} //JW 44097 removed +"&viewDr=1" so that fields are editable
	return false;
}

function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	if (el.disabled) {
		return false;
	}
	return true;
}

//log61979 TedT
function LookUpTypeHandler (str) {
	var strArray=str.split("^");
	var obj=document.getElementById("typeCode");
	if(obj) obj.value=strArray[2];
}

function LookUpTypeOnBlur () {
	var obj=document.getElementById("typeCode");
	if(obj && this.value=="") obj.value="";
}

function FindClickHandler() {
	
	var RefDType=document.getElementById("typeCode");
	if (RefDType) this.href+="&typeCode="+RefDType.value;
	
}

window.document.body.onload=PAFamilyDoctorListLoadHandler;