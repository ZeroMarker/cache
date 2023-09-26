// Copyright (c) 2002 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var evtKey="";

function MRObservationSetInitialFocus() {
	var tbl=document.getElementById('tMRObservations_EditList');
	for (var i=1; i<tbl.rows.length+1; i++) {
		var obj=document.getElementById('OBSValuez'+i);
		if ((obj)&&(obj.readOnly!=true)&&(obj.value=="")) {
			try {
				obj.focus();
				break;
			} catch (e) {
			}
		}
	}
}


function OBSValue_Number_changehandler(evt) {
	var el=websys_getSrcElement(evt);
	var arrElID=el.id.split('z');
	var row=arrElID[arrElID.length-1];
	var desc="";
	var obj=document.getElementById('OBSDescz'+row);
	if (obj) desc="'"+obj.innerHTML+"' ";
	var objType=document.getElementById('OBSInputTypez'+row);
	if ((objType)&&(objType.value=="N")) {
		if (!IsValidNumber(el)) {
			alert( desc + t['XNUMBER'] + "\n");
			el.className='clsInvalid';
			el.value="";
			websys_setfocus(el.id);
			//el.focus();
			//return websys_cancel();
		} else {
			el.className='';
			// Log 48205 - AI - 15-12-2004 : After the OBSValue is entered, default the OBSStatus to be "Authorised".
			//    NOTE: This is a custom script function ( therefore it is NOT in THIS file! ).
			try { 
				if(!AutomaticAuthorise(row)) {
					return false;
				}
			} catch(e) {}
			// end Log 48205
		}
	}
}

//resets the table fields to allow numerics or disabling....
function MRObservation_EditList_ResetTable() {
	var IDObj=document.getElementById('ID');
	var tbl=document.getElementById('tMRObservations_EditList');
	var rows=tbl.rows.length;
	for (var i=1; i<rows+1; i++) {
		var isDisabled=0, ItemType=0;
		var obj=document.getElementById('systemtypez'+i);
		if (obj) isDisabled=(obj.value==1);
		var obj=document.getElementById('OBSItemTypez'+i);
		if (obj) ItemType=obj.value;

		var obj=document.getElementById('OBSValuez'+i);
		if (obj) {
			if (isDisabled) {
				obj.readOnly=true;
				obj.className='disabledField';
			} else if (ItemType=="N") {
				obj.onchange=OBSValue_Number_changehandler;
			}
			var objlen=document.getElementById('OBSLengthz'+i);
			if ((objlen)&&(objlen.value>0)) obj.maxLength=objlen.value;
			
			// ab 8.11.06 54528
			if (ItemType=="C") {
				obj.readOnly=true;
				obj.className="clsReadOnly";
			}
		}
		var obj=document.getElementById('OBSShortDescz'+i);
		if ((obj)&&(isDisabled)) {
			obj.readOnly=true;
			obj.className='disabledField';
		}
		// Log 54801 YC - Don't disable if it is a new observation
		if (IDObj && IDObj.value!="") {
			var obj=document.getElementById('StatusCodez'+i);
			if ((obj)&&(obj.value=="A")) {
				var obj=document.getElementById('OBSValuez'+i);
				if (obj) {
					obj.readOnly=true;
					obj.className='disabledField';
				}
				var obj=document.getElementById('OBSShortDescz'+i);
				if (obj) {
					obj.readOnly=true;
					obj.className='disabledField';
				}
				var obj=document.getElementById('Statusz'+i);
				if (obj) {
					obj.readOnly=true;
					obj.className='disabledField';
				}
			}
		}
		
		// ab 12.04.07 62937 - disable status for totals
		var obj=document.getElementById('systemtypez'+i);
		if ((obj)&&(obj.value==1)) {
			var obj=document.getElementById('Statusz'+i);
			if (obj) {
				obj.disabled=true;
				obj.value="";
				obj.className='disabledField';
			}
		}
	}
}

function LinkDisable(e) {
	var el = websys_getSrcElement(e);
	if (el.disabled) {
		return false;
	}
	return true;
}

function MRObsDocKeydownHandler(evt) {
	var eSrc=websys_getSrcElement(evt);
	var key=websys_getKey(evt);
	evtSrc=eSrc;
	if (eSrc.tagName=="INPUT") {
		// status field not displayed
		if ((eSrc.id)&&(eSrc.id.indexOf("Statusz")==0)) {
			//the status fields
			OBSStatus_lookuphandler(evt);
		}
	}
}

function MRObsDocClickHandler(e) {
	var eSrcAry=window.event.srcElement.id.split("z");
	if (eSrcAry.length>0) {
		var f=document.getElementById('fMRObservations_EditList');
		var objStatus=f.elements['Statusz'+eSrcAry[1]];
		var objValue=f.elements['OBSValuez'+eSrcAry[1]];
		var eSrc=websys_getSrcElement(e);
		evtSrc=eSrc;
		if ((eSrc.tagName=="IMG")&&(objStatus.readOnly==false)&&(objValue.value!="")) {
			// status field not displayed
			if ((eSrc.id)&&(eSrc.id.indexOf("lt1362iStatusz")==0)) {
				//the lookup icons for status fields
				OBSStatus_lookuphandler(e);

				var key=websys_getKey(e);
				var type=websys_getType(e);
				evtKey=type+"^"+key+"^"+eSrc.tagName;

				return;
			}  else {
				eSrc=websys_getParentElement(eSrc);
			}
		}
		if ((eSrc.tagName=="IMG")&&(objValue.value=="")) {
			alert(t['INVALID_STATUS']);
			objValue.focus(objValue.sourceIndex)
		}
	}
}

function Status_changehandler(encmeth,e) {
	var eSrcAry=window.event.srcElement.id.split("z");
	var frm=document.getElementById('fMRObservations_EditList');
	var obj=websys_getSrcElement(e);
	var p1='ResultType';	//Standard Type
	var p2='';
	if (obj) {
		lu_obj=obj;
		p2=obj.value;
	}
	if ((p2!='')&&(cspRunServerMethod(encmeth,'OBSStatus_lookupsel','StatusLookUpSelect',p1,p2)=='0')) {
		if (obj) {
			obj.className='clsInvalid';
			if (eSrcAry.length>0) {
				var objVal=frm.elements['OBSValuez'+eSrcAry[1]];
				if ((objVal)&&(objVal.value=="")) {
					alert(t['INVALID_STATUS']);
					frm.elements['Statusz'+eSrcAry[1]].value="";
				}
			}
			//obj.focus();
			return websys_cancel();
		}
	} else if (p2!='') {
		if (eSrcAry.length>0) {
			var objVal=frm.elements['OBSValuez'+eSrcAry[1]];
			if ((objVal)&&(objVal.value=="")) {
				alert(t['INVALID_STATUS']);
				frm.elements['Statusz'+eSrcAry[1]].value="";
			} else {
				if (obj) obj.className='';
			}
		}
	}
}

//override the functions from scripts_gen folder
function OBSStatus_lookuphandler(evt) {
	var eSrcAry=window.event.srcElement.id.split("z");
	var frm=document.getElementById('fMRObservations_EditList');
	var type=websys_getType(evt);
	var obj=window.event.srcElement;
	var key=websys_getKey(evt);
	var p1="ResultType";	//Standard Type
	var p2="";
	var p3="A,E";					//value restrictions
	if ((type=='click')||((type=='keydown')&&(key==117)&&((obj)&&(obj.readOnly!=true)))) {
		var objVal=frm.elements['OBSValuez'+eSrcAry[1]];
		if ((objVal)&&(objVal.value=="")) {
			alert(t['INVALID_STATUS']);
			frm.elements['Statusz'+eSrcAry[1]].value="";
			websys_setfocus(obj.id);
			return websys_cancel();
		} else {
			var url='websys.lookup.csp?ID=d1362iOBSStatus';
			lu_obj=websys_getSrcElement(evt);
			if ((lu_obj)&&(lu_obj.tagName=="IMG")) lu_obj=lu_obj.previousSibling;
			if (lu_obj) url += "&P1=" + p1 + "&P2=" + p2 + "&P3=" + p3
			if (lu_obj) url += "&CONTEXT=Kweb.MRCObservationStatus:LookUpByTypeRestrict"  //&TLUJSF=StatusLookUpSelect"
			var tmp=url.split('%');
			url=tmp.join('%25');
			websys_lu(url,1,'');
			return websys_cancel();
		}
	}
}

function StatusLookUpSelect(str) {
	var lu=str.split("^");
	if (lu_obj) {
		var objrow=lu_obj;
		while (objrow.tagName!="TR") {objrow=objrow.parentElement}
		var arrfld=objrow.getElementsByTagName('INPUT');
		for (var i=0; i<arrfld.length; i++) {
			if (arrfld[i]==lu_obj) {
				arrfld[i].value = lu[0];
			} else if (arrfld[i].id.indexOf("OBSStatusz")!=-1) {
				arrfld[i].value = lu[2];
			}
		}
	//alert(lu_obj.name);
	if ((lu_obj)&&(lu_obj.value=="")) websys_setfocus(lu_obj.id);
	}
}

function OBSStatus_lookupsel(value) {
	try {
		if (lu_obj) {
  		lu_obj.value=unescape(value);
			lu_obj.className='';
			websys_nextfocus(lu_obj.sourceIndex);
		}
	} catch(e) {};
}

function mPiece(s1,sep,n) {
	//Split the array with the passed delimeter
  delimArray = s1.split(sep);

	//If out of range, return a blank string
  if ((n <= delimArray.length-1) && (n >= 0)) {
    return delimArray[n];
	} else {
	  return ""
  }
}

var tblMRObs=document.getElementById("tMRObservations_EditList")
if (tblMRObs) {
	tblMRObs.onkeydown=MRObsDocKeydownHandler;
	tblMRObs.onclick=MRObsDocClickHandler;
}

MRObservation_EditList_ResetTable();
MRObservationSetInitialFocus();

// Log 62480 YC - Rearranged update since the update click was being set twice to different functions
// Do we need to disable the update and delete buttons?
var objreadonly=document.getElementById('ReadOnly');
var objUpdate = document.getElementById('update1');
if ( (objreadonly) && (objreadonly.value==1) ) {
	if (objUpdate) {
		objUpdate.disabled=true;
		objUpdate.onclick=LinkDisable;
	}
	var objDelete = document.getElementById('Delete');
	if (objDelete) {
		objDelete.disabled=true;
		objDelete.onclick=LinkDisable;
	}

}

// LOG 49989 - YC - Second Signature required when Overseer Flag is set to 'Y' against Order Item Subcategory
if (objUpdate && objUpdate.disabled==false) objUpdate.onclick=Update1ClickHandler;

var ovsMand = document.getElementById("isOverSeerMandatory");
var ovsUser = document.getElementById("OverseerUser");
var ovsPass = document.getElementById("OverseerPassword");
if (ovsUser) {
	// read only if overseer user has previously been entered
	if ((ovsUser.value != "") && (document.getElementById("isOverseerReadOnly").value != 0)) {
		ovsUser.disabled = true;
		ovsUser.className='disabledField';
		ovsPass.disabled = true;
		ovsPass.className='disabledField';
		ovsMand.value = "N";
	}
	// mandatory if entering details for the first time and flag is "Y"
	else if (ovsMand && (ovsMand.value == "Y")) {
		EnableMandatoryField("OverseerUser");
		EnableMandatoryField("OverseerPassword");
	}
}

// Log 60333 - disable audit footprint link if we are creating a new obs
var idobj=document.getElementById("ID");
var auditfootobj=document.getElementById("auditfootprint");
if(idobj && auditfootobj) {
	if (idobj.value=="") {
		auditfootobj.disabled=true;
		auditfootobj.onclick=LinkDisable;
	}
}

/*
 * Simple function which inserts the OverSeer User's code rather than
 * Description
 */
function UserLookUpSelect(str) {
	var userLookUpVals = str.split("^");
	document.getElementById("OverseerUser").value=userLookUpVals[2];
}


function IsValidNumber(p)  {
 var theNumber=p.value;
 // Log 59562 YC - if we are using comma decimals, we convert commas to decimal points before checking isNaN
 var DecimalSymbol=document.getElementById("DecimalSymbol");
 if(DecimalSymbol) {
 	if(DecimalSymbol.value==",") {
 		if(theNumber.indexOf(".")!=-1) return false;
 		theNumber=theNumber.replace(",",".");
 	}
 }
 if (isNaN(theNumber)) return false;
 return true;
}

function Update1ClickHandler() {
	try { 
		var ovsMand = document.getElementById("isOverSeerMandatory");
		var ovsUser = document.getElementById("OverseerUser");
		var ovsPass = document.getElementById("OverseerPassword");

		if (ovsMand && ovsMand.value == "Y") { 
			if (ovsUser && (ovsUser.value == "")) {
				alert(t['OverseerUser']+": "+t['IS_MANDATORY']);
				return false;
			}

			if (ovsPass && (ovsPass.value == "")) {
				alert(t['OverseerPassword']+": "+t['IS_MANDATORY']);
				return false;
			}
		}

		// Now extract the Usercode and ensure that it differs with ovsUser
		var userCode = document.getElementById("UserCode");
		if (userCode) {
			if (userCode.value == ovsUser.value) {
				alert(t['UserCode']+": "+t['NOT_SAME']+" "+t['OverseerUser']);
				return false;
			}
		}		
	} catch(e) {}
	
	return update1_click();
}

function EnableMandatoryField(fldName) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if (fld) {
		fld.disabled = false;
		if (lbl) lbl = lbl.className = "clsRequired";
	}
}

// END Log 49989 - YC