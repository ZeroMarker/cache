// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function BodyLoadHandler() {
	var frm = document.forms["fSSHL7_Edit"];
	
	// cjb 29/03/2005 50272 - disable links for new HL7 settings
	setLinks()
	
	obj=document.getElementById('HL7NationalNumber');
	if (obj) obj.onclick=NationalNoClickHandler;
	
	obj=document.getElementById("HL7QueryInterface");
	if (obj) obj.onclick=HL7QueryInterfaceClickHandler;
	
	obj=document.getElementById('update1');
	if (obj) obj.onclick=UpdateClickHandler;
	
	var obj=document.getElementById('HL7ConnectedToEnsemble');
	if (obj) obj.onclick=EnablePortRange;

	obj=document.getElementById('interfaceParams');
	if (obj) {
		var intRunning=mPiece(obj.value,"^",1);
		var dataDirection=mPiece(obj.value,"^",2);
		if (intRunning=="Y") disableAllFields(frm);

		// Log 44805 - AI - 18-08-2004 : Add "Also Send Messages" - only for Outbound.
		if (dataDirection!="O") {
			var ADTLink=document.getElementById('Messages');
			if (ADTLink) {
				ADTLink.disabled=true;
				ADTLink.onclick=ADTClickHandler;
			}
			var segment=document.getElementById('Segment');
			if (segment) {
				segment.disabled=true;
				segment.onclick=ADTClickHandler;
			}
			var AlsoSendLink=document.getElementById('AlsoSendMessages');
			if (AlsoSendLink) {
				AlsoSendLink.disabled=true;
				AlsoSendLink.onclick=ADTClickHandler;
			}
			// Log 44154 - AI - 24-06-2004 : Add "Use App and Fac against OrdItem in MSH" - only for Outbound.
			var objHL7MSHOutboundExtCodeCheck=document.getElementById('HL7MSHOutboundExtCodeCheck');
			if (objHL7MSHOutboundExtCodeCheck) {
				objHL7MSHOutboundExtCodeCheck.disabled=true;
				objHL7MSHOutboundExtCodeCheck.value="";
			}
			// Log 45173 - AI - 22-06-2004 : HL7LocalApplication and HL7NameOfFacility are no longer Outbound-only.
			/*
			// Log 44154 - AI - 24-06-2004 : HL7LocalApplication and HL7NameOfFacility are now only for Outbound.
			var objHL7LocalApplication=document.getElementById('HL7LocalApplication');
			if (objHL7LocalApplication) {
				objHL7LocalApplication.value="";
				DisableFieldCustom('HL7LocalApplication',1);
			}
			var objHL7NameOfFacility=document.getElementById('HL7NameOfFacility');
			if (objHL7NameOfFacility) {
				objHL7NameOfFacility.value="";
				DisableFieldCustom('HL7NameOfFacility',1);
			}
			*/
			// end Log 45173
			
			// cjb 22/03/2005 51193
			var objHL7AutoStartOutbound=document.getElementById('HL7AutoStartOutbound');
			if (objHL7AutoStartOutbound) {
				objHL7AutoStartOutbound.disabled=true;
				objHL7AutoStartOutbound.value="";
			}
			var HL7QueryInterface=document.getElementById('HL7QueryInterface');
			if (HL7QueryInterface) {
				HL7QueryInterface.disabled=true;
				HL7QueryInterface.value="";
			}
			var HL7ConnectedToEnsemble=document.getElementById('HL7ConnectedToEnsemble');
			if (HL7ConnectedToEnsemble) {
				HL7ConnectedToEnsemble.disabled=true;
				HL7ConnectedToEnsemble.value="";
			}
			var HL7PortRangeLower=document.getElementById('HL7PortRangeLower');
			if (HL7PortRangeLower) {
				HL7PortRangeLower.disabled=true;
				HL7PortRangeLower.value="";
			}
			var HL7PortRangeUpper=document.getElementById('HL7PortRangeUpper');
			if (HL7PortRangeUpper) {
				HL7PortRangeUpper.disabled=true;
				HL7PortRangeUpper.value="";
			}			
			// cjb 09/09/2005 49058 - moved this inside the if (dataDirection!="O")
			// Log 46286 - AI - 17-09-2004 : Make the following 3 fields "required".
			obj=document.getElementById('cHL7DefAdmType');
			if (obj) obj.className="clsRequired";
			obj=document.getElementById('cCTLOCDesc');
			if (obj) obj.className="clsRequired";
			obj=document.getElementById('cREFDDesc');
			if (obj) obj.className="clsRequired";
			
		}

		// Log 40390 - AI - 03-11-2003 : Add "Mark As Read" - only for Inbound.
		// Log 44154 - AI - 24-06-2004 : Add "Use MSH App and Fac to extract OrdItem code" - only for Inbound.
		// 				 Add ACK Sending Application and Facility - both also only for Inbound.
		if (dataDirection!="I") {
			var objMarkAsRead=document.getElementById('HL7MarkAsRead');
			if (objMarkAsRead) {
				objMarkAsRead.disabled=true;
				objMarkAsRead.value="";
			}
			var objHL7MSHInboundExtCodeCheck=document.getElementById('HL7MSHInboundExtCodeCheck');
			if (objHL7MSHInboundExtCodeCheck) {
				objHL7MSHInboundExtCodeCheck.disabled=true;
				objHL7MSHInboundExtCodeCheck.value="";
			}
			var objHL7ACKApplication=document.getElementById('HL7ACKApplication');
			if (objHL7ACKApplication) {
				objHL7ACKApplication.value="";
				DisableFieldCustom('HL7ACKApplication',1);
			}
			var objHL7ACKFacility=document.getElementById('HL7ACKFacility');
			if (objHL7ACKFacility) {
				objHL7ACKFacility.value="";
				DisableFieldCustom('HL7ACKFacility',1);
			}
			var ResultStatus=document.getElementById('ResultStatus');
			if (ResultStatus) {
				ResultStatus.disabled=true;
                		ResultStatus.onclick=LinkDisable;
			}
			var MasterFileSetup=document.getElementById('MasterFileSetup');
			if (MasterFileSetup) {
				MasterFileSetup.disabled=true;
				MasterFileSetup.onclick=LinkDisable;
			}
		}

	    	var HL7ConnectedToEnsemble=document.getElementById('HL7ConnectedToEnsemble');
	
		var HL7PortRangeLower=document.getElementById('HL7PortRangeLower');
		if (HL7PortRangeLower) {
			if (!HL7ConnectedToEnsemble.checked) {
				HL7PortRangeLower.value="";
				DisableFieldCustom('HL7PortRangeLower',1)
			}
		}
		var HL7PortRangeUpper=document.getElementById('HL7PortRangeUpper');
		if (HL7PortRangeUpper) {
			if (!HL7ConnectedToEnsemble.checked) {
				HL7PortRangeUpper.value="";
				DisableFieldCustom('HL7PortRangeUpper',1)
			}
		}

		objBold=document.getElementById('BoldLinks');
		if (objBold) {
			var BoldLink = objBold.value.split("^");
			obj=document.getElementById('Messages');
			if ((obj) && (BoldLink[0]=="1")) obj.style.fontWeight="bold";
			obj=document.getElementById('Segment');
			if ((obj) && (BoldLink[1]=="1")) obj.style.fontWeight="bold";
			if ((obj) && (BoldLink[0]=="0")) DisableFieldCustom('Segment');
			obj=document.getElementById('PatNoSetup');
			if ((obj) && (BoldLink[2]=="1")) obj.style.fontWeight="bold";
			// Log 40498 - AI - 14-11-2003 : Add Order Number logic.
			obj=document.getElementById('OrdNoSetup');
			if ((obj) && (BoldLink[3]=="1")) obj.style.fontWeight="bold";
			obj=document.getElementById('MessageForwarding');
			if ((obj) && (BoldLink[4]=="1")) obj.style.fontWeight="bold";
			if ((!dataDirection) || (dataDirection!="I")) DisableFieldCustom('MessageForwarding');
			obj=document.getElementById('AcknowledgeSetup');
			if ((obj) && (BoldLink[5]=="1")) obj.style.fontWeight="bold";
			if ((!dataDirection) || (dataDirection!="I")) DisableFieldCustom('AcknowledgeSetup');
			// Log 41789 - AI - 02-02-2004 : Add Outbound Tables logic.
			obj=document.getElementById('OutTabSetup');
			if ((obj) && (BoldLink[6]=="1")) obj.style.fontWeight="bold";
			if ((!dataDirection) || (dataDirection!="O")) DisableFieldCustom('OutTabSetup');
			// Log 44852 - AI - 12-07-2004 : Add Miscellaneous Processing Rules logic.
			obj=document.getElementById('MiscProcessingRules');
			if ((obj) && (BoldLink[7]=="1")) obj.style.fontWeight="bold";
			if ((!dataDirection) || (dataDirection!="I")) DisableFieldCustom('MiscProcessingRules');
			// Log 44805 - AI - 18-08-2004 : Add Also Send Messages logic.
			obj=document.getElementById('AlsoSendMessages');
			if ((obj) && (BoldLink[8]=="1")) obj.style.fontWeight="bold";
			// Log 45778 - AI - 30-08-2004 : Add Text Format Codes logic.
			obj=document.getElementById('TextFormatCodes');
			if ((obj) && (BoldLink[9]=="1")) obj.style.fontWeight="bold";
			if ((!dataDirection) || (dataDirection!="I")) DisableFieldCustom('TextFormatCodes');
			obj=document.getElementById('QuerySetup');
			if ((obj) && (BoldLink[10]=="1")) obj.style.fontWeight="bold";
			obj=document.getElementById('ResultStatus');
			if ((obj) && (BoldLink[11]=="1")) obj.style.fontWeight="bold";
		        obj=document.getElementById('MasterFileSetup');
			if ((obj) && (BoldLink[12]=="1")) obj.style.fontWeight="bold";
		}
	}
	NationalNoClickHandler();
	HL7QueryInterfaceClickHandler();
}

function ADTClickHandler() {
	return false;
}

function NationalNoClickHandler() {
	obj=document.getElementById('HL7NationalNumber');
	if (obj) {
		if (obj.checked) {
			EnableField('HL7NatAssCodeField');
			EnableField('HL7NatAssCode');
			objLU=document.getElementById('ld1097iHL7NatAssCodeField');
			if (objLU) objLU.disabled=false;
		} else {
			DisableFieldCustom('HL7NatAssCodeField',1);
			DisableFieldCustom('HL7NatAssCode',1);
			objLU=document.getElementById('ld1097iHL7NatAssCodeField');
			if (objLU) objLU.disabled=true;
		}
	} 
}

function UpdateClickHandler() {
	var errmsg="";
	
	// cjb 09/09/2005 49058 - added (obj1.className=="clsRequired")
	// Log 46286 - AI - 17-09-2004 : Make the following 3 fields "required".
	obj=document.getElementById('HL7DefAdmType');
	obj1=document.getElementById('cHL7DefAdmType');
	if ((obj)&&(obj.value=="")&&(obj1)&&(obj1.className=="clsRequired")) {
		if (errmsg!="") errmsg=errmsg+"\n"+"'"+t['HL7DefAdmType']+"' "+t['XMISSING'];
		if (errmsg=="") errmsg="'"+t['HL7DefAdmType']+"' "+t['XMISSING'];
		obj.className="clsInvalid";
	} else if (obj) obj.className="";
	obj=document.getElementById('CTLOCDesc');
	obj1=document.getElementById('cCTLOCDesc');
	if ((obj)&&(obj.value=="")&&(obj1)&&(obj1.className=="clsRequired")) {
		if (errmsg!="") errmsg=errmsg+"\n"+"'"+t['CTLOCDesc']+"' "+t['XMISSING'];
		if (errmsg=="") errmsg="'"+t['CTLOCDesc']+"' "+t['XMISSING'];
		obj.className="clsInvalid";
	} else if (obj) obj.className="";
	obj=document.getElementById('REFDDesc');
	obj1=document.getElementById('cREFDDesc');
	if ((obj)&&(obj.value=="")&&(obj1)&&(obj1.className=="clsRequired")) {
		if (errmsg!="") errmsg=errmsg+"\n"+"'"+t['REFDDesc']+"' "+t['XMISSING'];
		if (errmsg=="") errmsg="'"+t['REFDDesc']+"' "+t['XMISSING'];
		obj.className="clsInvalid";
	} else if (obj) obj.className="";

	if (errmsg!="") {
		alert(errmsg);
		return false;
	}
	// end Log 46286

	// Log 35650 - AI - 12-05-2003 : Add Inbound and Outbound Patient Number Types lists.
	SetSelectedCheckedExportedPatNumbers();

	var objCode = document.getElementById('HL7NatAssCodeField');
	var objField = document.getElementById('HL7NatAssCode');

	if (objCode && objCode.className=="disabledField") {
		objCode.disabled=false;
		objCode.value="";
	}
	if (objField && objField.className=="disabledField") {
		objField.disabled=false;
		objField.value="";
	}
	return update1_click();
}

// Log 35650 - AI - 12-05-2003 : Add Inbound and Outbound Patient Number Types lists.
function SetSelectedCheckedExportedPatNumbers() {
	var patnoList="";
	var lst = document.getElementById("PatientNumberTypesCheckedAndExported");
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			if (lst.options[j].selected) {
				if (patnoList!="") patnoList = patnoList + "," + lst.options[j].value;
				if (patnoList=="") patnoList = lst.options[j].value;
			}
		}
		var objSelInb = document.getElementById("HL7PatNumbersCheckedExported");
		if (objSelInb) objSelInb.value=patnoList;
	}
}
// end Log 35650

// ab 20.04.05
var objlnk=document.getElementById("QuerySetup");
if (objlnk) var QueryLink=objlnk.onclick;
function HL7QueryInterfaceClickHandler() {
    var obj=document.getElementById("HL7QueryInterface");
    var objlnk=document.getElementById("QuerySetup");
    if ((obj)&&(objlnk)) {
        if (obj.checked) {
            objlnk.disabled=false;
            objlnk.onclick=QueryLink;
        } else {
            objlnk.disabled=true;
            objlnk.onclick=LinkDisable;
        }
    }
}


function EnablePortRange() {
    	var obj=document.getElementById('HL7ConnectedToEnsemble');
	if (obj) {
		if (obj.checked) {
			EnableField('HL7PortRangeLower');
			EnableField('HL7PortRangeUpper');
			websys_setfocus('HL7PortRangeLower');
		}
		else {
			var obj1=document.getElementById('HL7PortRangeLower');
			obj1.value="";
			DisableFieldCustom('HL7PortRangeLower',1);
			var obj2=document.getElementById('HL7PortRangeUpper');
			obj2.value="";
			DisableFieldCustom('HL7PortRangeUpper',1);
		}
	}
}

function disableAllFields(frm) {
	var fld=document.getElementsByTagName('INPUT');
	//alert(fld.id);
	var i=1
	while (frm[i]) {
		if (frm[i].id) {
			obj=document.getElementById(frm[i].id);
			if (obj) DisableFieldCustom(frm[i].id);
		}
		i++;
	}

	// no log ref - AI - 03-09-2004 : Disable all of the LookUp icons as well.
	objLU=document.getElementById('ld1097iHL7Version');
	if (objLU) objLU.disabled=true;
	objLU=document.getElementById('ld1097iHL7NameFields');
	if (objLU) objLU.disabled=true;
	objLU=document.getElementById('ld1097iHL7DefAdmType');
	if (objLU) objLU.disabled=true;
	objLU=document.getElementById('ld1097iCTLOCDesc');
	if (objLU) objLU.disabled=true;
	objLU=document.getElementById('ld1097iREFDDesc');
	if (objLU) objLU.disabled=true;
	objLU=document.getElementById('ld1097iHL7VerifUserCode');
	if (objLU) objLU.disabled=true;
	objLU=document.getElementById('ld1097iHL7SendProcessingMode');
	if (objLU) objLU.disabled=true;
}

// cjb 20/04/2005 51624 - renamed DisableField to DisableFieldCustom, so it doesn't get overwritten with websys.Edit.Tools.js
function DisableFieldCustom(fldName,vGray) {
	var fld = document.getElementById(fldName);
	if ((fld)&&((fld.tagName=="INPUT")||(fld.tagName=="A"))&&(fld.type!="hidden")) {
		fld.disabled = true;
		if (vGray) fld.className = "disabledField";
		if (fld.tagName=="A") fld.onclick=ADTClickHandler;
	}
}

function EnableField(fldName) {
	var fld = document.getElementById(fldName);
	if ((fld)&&((fld.tagName=="INPUT")||(fld.tagName=="A"))&&(fld.type!="hidden")) {
		fld.disabled = false;
		fld.className = "";
	}
}

function mPiece(s1,sep,n) {
	//Split the array with the passed delimeter
	n--;
	delimArray = s1.split(sep);

	//If out of range, return a blank string
	if ((n <= delimArray.length-1) && (n >= 0)) {
        	return delimArray[n];
	} else {
		return "";
	}
}

// cjb 29/03/2005 50272 - disable links for new HL7 settings
function setLinks() {
	var objID=document.getElementById('ID');
	if ((objID)&&(objID.value=="")) {
		SetupHiddenLink("AcknowledgeSetup");
		SetupHiddenLink("OutTabSetup");
		SetupHiddenLink("Messages");
		SetupHiddenLink("Segment");
		SetupHiddenLink("PatNoSetup");
		SetupHiddenLink("MessageForwarding");
		SetupHiddenLink("OrdNoSetup");
		SetupHiddenLink("MiscProcessingRules");
		SetupHiddenLink("AlsoSendMessages");
		SetupHiddenLink("TextFormatCodes");
	}
}

function SetupHiddenLink(link) {
	var obj=document.getElementById(link);
	if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}
}


document.body.onload=BodyLoadHandler;
