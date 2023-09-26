// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var validate=0;
var frm = document.forms["fPANok_Edit"];

function DocumentLoadHandler() {
	var obj=document.getElementById('NOKDateFrom');
	if (obj) obj.onchange=CodeTableValidationDate;

	obj=document.getElementById('NOKDateTo');
	if (obj) obj.onchange=CodeTableValidationDate;
	
	// LOG 23670 Defaulting in the address of the patient to the NOK
	obj=document.getElementById('AsAbove');
	if (obj) obj.onclick=NOKAsAboveChangeHandler;

	obj=document.getElementById('PAPEREmail');
	if (obj) obj.onchange= isEmail;
	
	obj=document.getElementById('NOKEmail');
	if (obj) obj.onblur= isEmail;
	
	//KK 28-Feb-2002 Log:23140
	//Address1 QAS
	obj=document.getElementById('ld1002iPAPERStNameLine1');	
	if (obj) obj.style.visibility = "hidden";
	
	obj=document.getElementById('PAPERStNameLine1');		
	if (obj) obj.onkeydown='';
	
	// cjb 15/02/2006 56793 - disable the fields when the page loads (enabled after searching for patient)
	obj=document.getElementById('RECIPROCALContactType');
	if (obj) {
		DisableFieldVisiable("RECIPROCALContactType");
		DisableLookup("ld1002iRECIPROCALContactType");
	}
	
	obj=document.getElementById('RECIPROCALRelation');
	if (obj) {
		DisableFieldVisiable("RECIPROCALRelation");
		DisableLookup("ld1002iRECIPROCALRelation");
	}
	
	obj=document.getElementById("ID");
	if ((obj)&&(obj.value!="")) {
		obj=document.getElementById("find1");
		if (obj) obj.onclick=LinkDisable;
	}
	
	// cjb 23/02/2006 56793 - if one of the reciprocal fields fails the validation
	obj=document.getElementById("ID");
	if ((obj)&&(obj.value=="")) {
		obj=document.getElementById("NOKPAPERDR");
		if ((obj)&&(obj.value!="")) {
			obj=document.getElementById('RECIPROCALContactType');
			if (obj) {
				EnableField("RECIPROCALContactType");
				EnableLookup("ld1002iRECIPROCALContactType");
			}
			obj=document.getElementById('RECIPROCALRelation');
			if (obj) {
				EnableField("RECIPROCALRelation");
				EnableLookup("ld1002iRECIPROCALRelation");
			}
		}
	}
	
	// cjb 10/08/2006 60478 - nasty hack to increment TWKFLI after an error message (UpdateClickHandler decreases by 1 if in workflow, so the page refreshes.  If you hit update after an error message, ends up decreased twice so you go back to the previous w/flow item...)
	var obj=frm.elements['TDIRTY'];
	if ((obj) && (obj.value==2)) {
		var obj=frm.elements['TWKFLI'];
		if (obj.value!="") obj.value++;
	}
	
	obj = document.getElementById("update1");
	if (obj) {
		obj.onclick = UpdateClickHandler;
		if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateHotKeyClickHandler;
	}

	//Log 60322 BoC: set ID, ContactType, Relation to Patient, update details to blank if copy
	var CopyFlag=document.getElementById("CopyFlag");
	if ((CopyFlag)&&(CopyFlag.value=="Y")){
		var ID=document.getElementById("ID");
		if (ID) ID.value="";
		var ContactType=document.getElementById("NOKContactType");
		if (ContactType) ContactType.value="";
		var relation=document.getElementById("NOKRelation");
		if (relation) relation.value="";
		var LastUpdateUserID=document.getElementById("SSUSRInitials");
		if (LastUpdateUserID) LastUpdateUserID.innerHTML="&nbsp;";
		var LastUpdateUserName=document.getElementById("SSUSRName");
		if (LastUpdateUserName) LastUpdateUserName.innerHTML="&nbsp;";
		var UpdateDate=document.getElementById("NOKUpdateDate");
		if (UpdateDate) UpdateDate.innerHTML="&nbsp;";
		var UpdateTime=document.getElementById("NOKUpdateTime");
		if (UpdateTime) UpdateTime.innerHTML="&nbsp;";
		var LastUpdateHospital=document.getElementById("HOSPDesc");
		if (LastUpdateHospital) LastUpdateHospital.innerHTML="&nbsp;";
	}
}

function UpdateClickHandler() {

	if (validateNOKDateTo()) {
		if (parent.frames["panok_edit"]) {
			frm.elements['TFRAME'].value=window.parent.name;
		}
		// ab 28.07.04 45190
		if (!parent.frames["panok_edit"]) {
			var objMulti=document.getElementById("MultiContactFrame");
			if (objMulti) objMulti.value=1;
		}
		
		var obj=frm.elements['TWKFLI'];
		if (!(fPANok_Edit_submit())) return false;
		if (obj.value!="") obj.value-=1;
		
		return update1_click();
	}
}

function UpdateHotKeyClickHandler() {
	var validate=1;
	UpdateClickHandler();
	validate=0;
}

/*
function DisableField(fldName) {
	var fld = document.getElementById(fldName);
	if ((fld)&&(fld.tagName=="INPUT")) {
		fld.disabled = true;
	}
}
*/

function Name5LookupSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById("PAPERName")
	if (obj) obj.value = lu[2];
 	var obj=document.getElementById("PAPERName5")
	if (obj) obj.value = lu[0];
}
function Name6LookupSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById("PAPERName2")
	if (obj) obj.value = lu[2];
 	var obj=document.getElementById("PAPERName6")
	if (obj) obj.value = lu[0];
}
function Name7LookupSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById("PAPERName3")
	if (obj) obj.value = lu[2];
 	var obj=document.getElementById("PAPERName7")
	if (obj) obj.value = lu[0];
}
function Name8LookupSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById("PAPERName4")
	if (obj) obj.value = lu[2];
 	var obj=document.getElementById("PAPERName8")
	if (obj) obj.value = lu[0];
}


// Geographic Information

function ZipLookupSelect(str) {
 	var lu = str.split("^");
 	var obj=document.getElementById("CTZIPCode")
	if (obj) obj.value = lu[0];
 	var obj=document.getElementById("CTCITDesc")
	if (obj) obj.value = lu[1];
	var obj=document.getElementById("PROVDesc")
	if (obj) obj.value = lu[2];
	var obj=document.getElementById("CITAREADesc")
	if (obj) obj.value = lu[3];
	var obj=document.getElementById("CTZIPDesc")
	if (obj) obj.value = lu[5];
}

function NOKZipLookupSelect(str) {
 	var lu = str.split("^");
 	var obj=document.getElementById("NOKCTZIPCode")
	if (obj) obj.value = lu[0];
 	var obj=document.getElementById("NOKCTCITDesc")
	if (obj) obj.value = lu[1];
	var obj=document.getElementById("NOKPROVDesc")
	if (obj) obj.value = lu[2];
	var obj=document.getElementById("NOKCityAreaDR")
	if (obj) obj.value = lu[3];
	var obj=document.getElementById("NOKCTZIPDesc")
	if (obj) obj.value = lu[5];
}

function NOKPayoyZipLookupSelect(str) {
 	var lu = str.split("^");
 	var obj=document.getElementById("NOKPayorCTCITDesc")
	if (obj) obj.value = lu[1];
	
}


function NOKDateToChangeHandler(e) {
	NOKDateTo_changehandler(e)
	var from=document.getElementById('NOKDateFrom')
	var to=document.getElementById('NOKDateTo')
	var fromdt=DateStringToArray(from.value)
	var todt=DateStringToArray(to.value)
	var dtto=new Date(todt["yr"], todt["mn"]-1, todt["dy"]);
	var dtfrom=new Date(fromdt["yr"], fromdt["mn"]-1, fromdt["dy"]);
	if ((to)&&(from)) {
		if (dtto< dtfrom) {
			alert("\'" + t['NOKDateTo'] + "\' " + t['XINVALID'] + "\n");
		}
	}

}

//LOG 23670 defaulting Address, Address 2, Suburb, Postcode, State and Home Phone
function NOKAsAboveChangeHandler(e) {
	
	var strobj=document.getElementById('PatAddrDetails');
	var AsAbove=document.getElementById('AsAbove');
	var addr1=document.getElementById('PAPERStNameLine1');
	var foreign=document.getElementById('PAPERForeignAddress');
	var addr2=document.getElementById('PAPERAddress2');
	var state=document.getElementById('PROVDesc');
	var pcode=document.getElementById('CTZIPCode');
	var zipdesc=document.getElementById('CTZIPDesc');
	var suburb=document.getElementById('CTCITDesc')
	var phone=document.getElementById('PAPERTelH')
	var nokaddr1=document.getElementById('NOKStNameLine1');
	var nokforeign=document.getElementById('NOKForeignAddress');
	var nokaddr2=document.getElementById('NOKAddress2');		
	var nokstate=document.getElementById('NOKPROVDesc');
	var nokpcode=document.getElementById('NOKCTZIPCode');
	var nokzipdesc=document.getElementById('NOKCTZIPDesc');
	var noksuburb=document.getElementById('NOKCTCITDesc');
	var nokphone=document.getElementById('NOKTelH');
	var cityarea=document.getElementById('CITAREADesc');
	var nokcityarea=document.getElementById('NOKCityAreaDR');
	
	if (strobj) {
		if (AsAbove.checked==true) {
			var str=strobj.value;
			var addr=str.split("^");
			if (nokaddr1) {nokaddr1.value= addr[0];}
			if (nokforeign) {nokforeign.value= addr[1];}
			if (noksuburb) {noksuburb.value= addr[2];}
			if (nokpcode) {nokpcode.value= addr[3];}
			if (nokzipdesc) {nokzipdesc.value= addr[6];}
			if (nokstate) {nokstate.value= addr[4];}
			if (nokphone) {nokphone.value= addr[5];}
			if (nokcityarea) {nokcityarea.value= addr[7];}
			if (addr1) {addr1.value= addr[0];}
			if (foreign) {foreign.value= addr[1];}
			if (suburb) {suburb.value= addr[2];}
			if (pcode) {pcode.value= addr[3];}
			if (state) {state.value= addr[4];}
			if (phone) {phone.value= addr[5];}
			if (zipdesc) {zipdesc.value= addr[6];}
			if (cityarea) {cityarea.value= addr[7];}
			if (addr2) {addr2.value= addr[8];}
			if (nokaddr2) {nokaddr2.value= addr[8];}
		} 
		if (AsAbove.checked==false) {
			if (nokaddr1) {nokaddr1.value="";}
			if (nokforeign) {nokforeign.value="";}
			if (noksuburb) {noksuburb.value="";}
			if (nokpcode) {nokpcode.value="";}
			if (nokzipdesc) {nokzipdesc.value="";}
			if (nokstate) {nokstate.value="";}
			if (nokphone) {nokphone.value="";}
			if (addr1) {addr1.value="";}
			if (addr2) {addr2.value="";}
			if (suburb) {suburb.value="";}
			if (pcode) {pcode.value="";}
			if (zipdesc) {zipdesc.value="";}
			if (state) {state.value="";}
			if (phone) {phone.value="";}
			if (cityarea) {cityarea.value="";}
			if (nokcityarea) {nokcityarea.value="";}
			if (addr2) {addr2.value= "";}
			if (nokaddr2) {nokaddr2.value= "";}
		}
	} 
	
}

function NOKDateFromChangeHandler(e) {
		NOKDateFrom_changehandler(e)
		var to=document.getElementById('NOKDateTo')
		var from=document.getElementById('NOKDateFrom')
		var fromdt=DateStringToArray(from.value)
		var todt=DateStringToArray(to.value)
		var dtto=new Date(todt["yr"], todt["mn"]-1, todt["dy"]);
		var dtfrom=new Date(fromdt["yr"], fromdt["mn"]-1, fromdt["dy"]);
		if ((to)&&(from)) {
			if (dtto< dtfrom) {
			alert("\'" + t['NOKDateFrom'] + "\' " + t['XINVALID'] + "\n");
			}
		}

}

function validateNOKDateTo(e) {
	var from=document.getElementById('NOKDateFrom')
	var to=document.getElementById('NOKDateTo')
	var valid=true
	if ((from)&&(from.value!="")&&(to)&&(to.value!="")) {
		var fromdt=DateStringToArray(from.value)
		var todt=DateStringToArray(to.value)
		var dtto=new Date(todt["yr"], todt["mn"]-1, todt["dy"]);
		var dtfrom=new Date(fromdt["yr"], fromdt["mn"]-1, fromdt["dy"]);
		if ((to)&&(from)) {
			if (dtto< dtfrom) {
				valid=false
				if (validate==0) alert("\'" + t['NOKDateTo'] + "\' " + t['XINVALID'] + "\n");
			}
		}
	} return valid

}

function contactLookUp(str) {
	var lu = str.split("^");
	var obj

	obj=document.getElementById('NOKContactType');
	if (obj) obj.value = lu[0];
	try{
		CustomNOKContactType(lu[0]);
	}catch(e){}
	// cjb 14/09/2005 55448 - don't put the default in if this is an existing NOK
	objID=document.getElementById('ID');
	obj=document.getElementById('NOKRelation');
	if ((obj)&&(objID)&&(objID.value=="")) obj.value = lu[3];
}

// cjb 15/02/2006 56793
function ReciprocalcontactLookUp(str) {
	var lu = str.split("^");
	var obj

	obj=document.getElementById('RECIPROCALContactType');
	if (obj) obj.value = lu[0];
	
	objID=document.getElementById('ID');
	obj=document.getElementById('RECIPROCALRelation');
	if ((obj)&&(objID)&&(objID.value=="")) obj.value = lu[3];
}

function nonGovOrgLookUp(str) {
	//:code,:desc,:id,:addr,:city,:zip,:contact,:email,:fax,:phone 
	//  0	  1	2   3	   4	5     6        7     8     9
	//alert(str);			
	var lu = str.split("^");
	var obj;
	obj=document.getElementById("NGODesc")
	if (obj) obj.value = lu[1];
	obj=document.getElementById("NGOId")
	if (obj) obj.value = lu[2];
	obj=document.getElementById("NGOAddress")
	if (obj) obj.value = lu[3];
	obj=document.getElementById("CTCITDesc2");
	if (obj) obj.value = lu[4];
	obj=document.getElementById("CTZIPDesc2");
	if (obj) obj.value = lu[5];
	obj=document.getElementById("NGOContactMethod");
	if (obj) obj.value = lu[6];
	obj=document.getElementById("NGOEmail");
	if (obj) obj.value = lu[7];
	obj=document.getElementById("NGOFax");
	if (obj) obj.value = lu[8];
	obj=document.getElementById("NGOPhone");
	if (obj) obj.value = lu[9];
}


function CodeTableValidationDate(e) {
	
	var eSrc=websys_getSrcElement(e);

	if (eSrc.id=="NOKDateFrom") {NOKDateFrom_changehandler(e);}
	if (eSrc.id=="NOKDateTo") {NOKDateTo_changehandler(e);}
	
	var NOKDateFrom;
	var NOKDateTo;
	var obj;
	
	obj=document.getElementById('NOKDateFrom');
	if ((obj)&&(obj.value!="")) {
		var NOKDateFrom=DateStringTo$H(obj.value);
	}
	obj=document.getElementById('NOKDateTo');
	if ((obj)&&(obj.value!="")) {
		var NOKDateTo=DateStringTo$H(obj.value);
	}
	
	obj=document.getElementById('CodeTableValidationDate');
	//have to initiate CTVdate to $h in case of clearing values in target date fields
	if (obj) { obj.value=DateStringTo$HToday() };
	if ((obj)&&(obj.value!="")) {
		if ((NOKDateFrom)&&(NOKDateFrom.value!="")) {
			obj.value=NOKDateFrom;
		}
		if ((NOKDateTo)&&(NOKDateTo.value!="")) {
			obj.value=NOKDateTo;
		}
	}
	
	/* obj=document.getElementById('CTZIPCode')
	if (obj) obj.onchange();
	obj=document.getElementById('CTCITDesc')
	if (obj) obj.onchange();
	obj=document.getElementById('NOKCTZIPCode')
	if (obj) obj.onchange();
	obj=document.getElementById('NOKCTCITDesc')
	if (obj) obj.onchange();
	obj=document.getElementById('NGODesc')
	if (obj) obj.onchange();
	obj=document.getElementById('NOKContactType')
	if (obj) obj.onchange(); */
	

	
}

function CityAreaLookupSelect(str) {
 	var lu = str.split("^");
	var obj=document.getElementById("CTCITDesc")
	if (obj) obj.value = lu[0];
 	obj=document.getElementById("CTZIPCode")
	if (obj) obj.value = lu[1];
 	obj=document.getElementById("CITAREADesc")
	if (obj) obj.value = lu[2];
 	obj=document.getElementById("PROVDesc")
	if (obj) obj.value = lu[3];
}

function NOKCityAreaLookupSelect(str) {
 	var lu = str.split("^");
	var obj=document.getElementById("NOKCTCITDesc")
	if (obj) obj.value = lu[0];
 	obj=document.getElementById("NOKCTZIPCode")
	if (obj) obj.value = lu[1];
 	obj=document.getElementById("NOKCityAreaDR")
	if (obj) obj.value = lu[2];
 	obj=document.getElementById("NOKPROVDesc")
	if (obj) obj.value = lu[3];
}

function NOKCTCOUDescSelect() {
//dummy function	
		
}
function PROVDescSelect() {
//dummy function	
}

function NOKPROVDescSelect() {
//dummy function	
}

document.body.onload = DocumentLoadHandler;

