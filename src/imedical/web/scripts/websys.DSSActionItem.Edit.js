// Copyright (c) 2002 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var LookUpFieldName="";
var objID=document.getElementById("ID")
//disable the delete link for new actions
var lnk=document.getElementById("delete1")
if ((lnk)&&(objID.value=="")) {
	lnk.disabled=true;
	lnk.className="disabledField";
	lnk.onclick="";
}
var objCPButt=document.getElementById('ld1341idispClassProperty');
var objCP=document.getElementById('dispClassProperty');
var objClassName=document.getElementById('ClassName');
var objClassProperty=document.getElementById('ClassProperty');
var objSimpleDSS=document.getElementById('SimpleDSS');

if (objCP) objCP.onchange=UpdateClassProperty;

function AddItem(str) {
	var lu = str.split("^");
	if (LookUpFieldName=="SetField") {
		if (objCP) objCP.value = lu[0];
		if (objClassProperty) objClassProperty.value = lu[1];
	} else if (LookUpFieldName=="MsgText") {

		ClassProperty_lookupSelect(str)
	}
}


function LookUpSQLFldName() {
	var ClassName='';
	var ClassProperty='';
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))) {
		if (objClassName) ClassName=objClassName.value;
		if (objCP) ClassProperty=objCP.value;
		LookUpFieldName="SetField";
		//var url='websys.dssrule.lookup.csp?classname=' + ClassName + '&sqlfieldname=' + ClassProperty;
		var url='websys.dssrule.lookup.csp?classname=' + ClassName + '&sqlfieldname=' + ClassProperty;
		websys_lu(url,true,'');
		return websys_cancel();
	}
}
function BodyLoadHandler() {
	if (objCPButt) objCPButt.onclick=LookUpSQLFldName;

	if (objCP) {
		objCP.onkeydown=LookUpSQLFldName;
		objCP.onchange=UpdateClassProperty;
	}

	var obj=document.getElementById("deleteUser")
	if (obj) obj.onclick=deleteUserHandler;
	var obj=document.getElementById("update1")
	if (obj) obj.onclick=updateHandler;
	if (tsc['update1']) websys_sckeys[tsc['update1']]=updateHandler;

	var obj=document.getElementById("SelectUser")
	if (obj){
		var val=obj.value
		var ary=val.split("#")
		for (i=0;i<ary.length;i++) {
			//alert(ary[i])
			if (ary[i]!="") LookUpUser(ary[i]);
		}
	}

	PresentationTypeChangeHandler();

	var obj=document.getElementById("EmailFrom");
	if (obj) obj.onblur=isEmail;
	var obj=document.getElementById("EmailTo");
	if (obj) obj.onblur=isEmail;
}

function BodyUnloadHandler(e) {
	if ((self == top)) {
		var win=window.opener;
		if (win) {
			win.treload('websys.csp');
		}
	}
}
function LookUpUser(val) {
	//alert(val)
	var obj=document.getElementById("MessageRecipients")
	if (obj) TransferToList(obj,val);
	document.getElementById("SelectUser").value=""
}
function LookUpGroup(val) {
	var ary=val.split("^")
	//gets list of UserIDs and names that eventually get sent to receiveUsers()
	var job=websys_createWindow('ssuser.findbygroup.csp?GroupID='+ary[1], 'TRAK_hidden', 'width=700,height=400,top=20,left=20')
}
function receiveUsers(val,txt) {
	var obj=document.getElementById("MessageRecipients")
	if (obj) {AddItemToList(obj,txt.split("^"),val.split("^"));obj.value=""}
}

function updateHandler() {
	var obj=document.getElementById("MessageRecipients");
	if (obj) {
		var ary=returnValues(obj);
		document.getElementById("MedTrakRecipient").value=ary.join("^");
	}
	var objPTHidden=document.getElementById('PresentationTypeHidden');
	if (objPTHidden.value!="A") {
		//check mandatory Time and TimeUnit
		var oktoupdate=1;
		var obj=document.getElementById("TimeOffset");
		if (!obj) oktoupdate=0;
		if ((obj)&&(obj.value=="")) oktoupdate=0;
		var obj=document.getElementById("TimeUnit");
		if (!obj) oktoupdate=0;
		if ((obj)&&(obj.value=="")) oktoupdate=0;
		if (!oktoupdate) {
			alert(t['NOTimeFields']);
			return false;
		}
	}
	/*var obj=document.getElementById("PresentationType");
	if ((obj) && (obj.value=="By Prefer Contact Method")) {
		var obj = document.getElementById("EpisodeRecipient");
		if ((obj) && (obj.value=="")) {
			alert(t['NoEpisRecipient']);
			//return false;
		}
	}
	*/
	return update1_click();
}

function deleteUserHandler() {
	var obj=document.getElementById("MessageRecipients")
	if (obj) ClearSelectedList(obj)
	return false;
}

function deleteUser_click() {
	var obj=document.getElementById('deleteUser');
	if (obj) obj.click();
}

websys_sckeys['R']=deleteUser_click;

window.document.body.onload=BodyLoadHandler;

//function LookUpSQLFieldName(str) {
// 	var lu = str.split("^");
//	var obj;
// 	obj=document.getElementById("dispClassProperty")
//	if (obj) obj.value = lu[0];
// 	obj=document.getElementById("ClassProperty")
//	if (obj) obj.value = lu[1];
//}

//var obj=document.getElementById('dispClassProperty');
//if (obj) obj.onchange=UpdateClassProperty;

function UpdateClassProperty() {

	var obj;
	var str="";
	obj=document.getElementById("dispClassProperty")
	if (obj){
		str=obj.value

		if (str.length == 0){
			obj=document.getElementById("ClassProperty");
			if (obj) obj.value = "";
		}
	}
}


function LookUpComponentItem(str) {
	var lu = str.split("^");
	var obj;
 	obj=document.getElementById("dispCompItem")
	if (obj) obj.value = lu[0];
 	obj=document.getElementById("ComponentItem")
	if (obj) obj.value = lu[1];
}

var obj=document.getElementById('dispCompItem');
if (obj) obj.onchange=UpdateComponentItem;

function UpdateComponentItem() {
	var obj;
	var str="";
	obj=document.getElementById("dispCompItem")
	if (obj){
		str=obj.value
		if (str.length == 0){
			obj=document.getElementById("ComponentItem");
			if (obj) obj.value = "";
		}
	}
}


function LookUpPresentationType(str) {
 	var lu = str.split("^");
	var obj=document.getElementById("PresentationType")
	if (obj) obj.value = lu[0];
	var obj2=document.getElementById("PresentationTypeHidden")
	if (obj2) obj2.value = lu[2];
	
	// must have an episode to add an order
	var objClassName=document.getElementById("ClassName");
	if ((lu[2]=="R")&&(objClassName)&&((objClassName.value=="User.PAPerson")||(objClassName.value=="User.PAPatMas"))) {
		alert(t["OrderEp"]);
		obj.value="";
		obj2.value="";
	}
	
	PresentationTypeChangeHandler();
}

function LookUpSetField(str) {
 	var lu = str.split("^");
	var obj;
 	obj=document.getElementById('SetFieldType')
	if (obj) obj.value = lu[0];
	SetFieldTypeChangeHandler()
}
var obj=document.getElementById('PresentationType');
if (obj) obj.onblur=PresentationTypeChangeHandler;
var objST=document.getElementById('SetFieldType');
if (objST) objST.onchange=SetFieldTypeChangeHandler;

function SetFieldTypeChangeHandler()
{
	var objST=document.getElementById('SetFieldType');
	var objSTButt=document.getElementById('ld1341iSetFieldType');

	var objCI=document.getElementById('dispCompItem');
	var objCIButt=document.getElementById('ld1341idispCompItem');

	var objCP=document.getElementById('dispClassProperty');
	var objCPButt=document.getElementById('ld1341idispClassProperty');

	var objCE=document.getElementById('CommandExecute');
	var objSV=document.getElementById('SetFieldValue');

	if (objST) {
		//alert(objST.value)
		switch (objST.value){
		case 'Command Execute':
		case 'Command':
			if (objCI) SetTXTStatus(objCI,false);
			if (objCIButt) SetCMDStatus(objCIButt,false);
			if (objCP) SetTXTStatus(objCP,false);
			if (objCPButt) SetCMDStatus(objCPButt,false);

			if (objCE) SetTXTStatus(objCE,true);

			if (objSV) SetTXTStatus(objSV,false);
			break;
		case 'Component':
			if (objCI) SetTXTStatus(objCI,true);
			if (objCIButt) SetCMDStatus(objCIButt,true);
			if (objCP) SetTXTStatus(objCP,false);
			if (objCPButt) SetCMDStatus(objCPButt,false);
			if (objCE) SetTXTStatus(objCE,false);

			if (objSV) SetTXTStatus(objSV,true);
			break;
		case 'Class':
		case 'Class Field':
			if (objCI) SetTXTStatus(objCI,false);
			if (objCIButt) SetCMDStatus(objCIButt,false);

			if (objCP) SetTXTStatus(objCP,true);
			if (objCPButt) SetCMDStatus(objCPButt,true);

			if (objCE) SetTXTStatus(objCE,false);

			if (objSV) SetTXTStatus(objSV,true);

			break;
		default :
			if (objCI) SetTXTStatus(objCI,false);
			if (objCIButt) SetCMDStatus(objCIButt,false);
			if (objCP) SetTXTStatus(objCP,false);
			if (objCPButt) SetCMDStatus(objCPButt,false);
			if (objCE) SetTXTStatus(objCE,false);

			if (objSV) SetTXTStatus(objSV,false);
			break;
		}
	}
}

function SetTXTStatus(obj,blnStatus) {
	if (!blnStatus) {
		if (obj.multiple) {
			for (var i=obj.options.length-1; i>=0; i--) {
				obj.options[i] = null;
			}
		}
		else{
			obj.value='';
		}
		obj.readOnly=!blnStatus;
		obj.className='disabledField';
	}
	else{
		obj.readOnly=!blnStatus;
		obj.className='enabledField';
	}

}

function SetCMDStatus(obj,blnStatus) {
	obj.disabled=!blnStatus
}

/*
function isFunction(str)
{	//This pattern matches :
	//$$CalAge^DSSFunc()
	//$$CalAge^DSSFunc('a'[,'b']*)"
	var patFunc=/^\${2}\w+\^\w+\(((\'\w+\')(\,\'\w+\')*)?\)/
	return str.match(patFunc);
}
var objCE=document.getElementById('CommandExecute');
if (objCE) objCE.onblur=cmdExecuteValidation;

function cmdExecuteValidation() {
	var objCE=document.getElementById('CommandExecute');

	var s=objCE.value

	if (s.match(/^\${2}/)) {
		if (!isFunction(s)) {
			alert('Invalid format for Cache function call.')
			objCE.focus()
		}
	}
}
*/
function PresentationTypeChangeHandler() {

	var objPT=document.getElementById('PresentationType');
	var objAT=document.getElementById('ActionType');
	var objATButt=document.getElementById('ld1341iActionType');
	var objNR=document.getElementById('Recipient');
	var objNRButt=document.getElementById('ld1341iRecipient');

	var objET=document.getElementById('EmailTo');
	var objEF=document.getElementById('EmailFrom');
	var objES=document.getElementById('EmailSubject');

	var objFT=document.getElementById('FaxTo');

	var objSU=document.getElementById('SelectUser');
	var objMG=document.getElementById('MedTrakGroupID');
	var objMR=document.getElementById('MessageRecipients');
	var objMRHidden=document.getElementById('MedTrakRecipient')
	var objSUButt=document.getElementById('ld1341iSelectUser');
	var objMGButt=document.getElementById('ld1341iMedTrakGroupID');

	var objPA=document.getElementById('PageTo');

	var objST=document.getElementById('SetFieldType');
	var objCI=document.getElementById('dispCompItem');
	var objCP=document.getElementById('dispClassProperty');
	var objCE=document.getElementById('CommandExecute');
	var objSV=document.getElementById('SetFieldValue');

	var objSTButt=document.getElementById('ld1341iSetFieldType');
	var objCIButt=document.getElementById('ld1341idispCompItem');
	var objCPButt=document.getElementById('ld1341idispClassProperty');
	var objEP=document.getElementById("EpisodeRecipient");
	var objEPLU=document.getElementById('ld1341iEpisodeRecipient');
	var objORD=document.getElementById("OrderItem");
	var objORDLU=document.getElementById('ld1341iOrderItem');
	var objMSG=document.getElementById("MessageTo");
	var Component="";
	var objComponent=document.getElementById("Component");
	if (objComponent) Component=objComponent.value;
	var objTimeOff=document.getElementById("TimeOffset");
	var objTimeUnit=document.getElementById("TimeUnit");
	var objTimeUnitLU=document.getElementById("ld1341iTimeUnit");
	
	var objClassName=document.getElementById("ClassName");

	var objPTHidden=document.getElementById('PresentationTypeHidden');
	if ((objPT)&&(objPTHidden)&&(objPT.value=="")) objPTHidden.value="";

	var EventType=document.getElementById("EventType");
	if (EventType) EventType=EventType.value;
	
	if (objPTHidden.value=="O") {
		if (objEP) SetTXTStatus(objEP,true);
		if (objEPLU) SetCMDStatus(objEPLU,true);
		labelMandatory("EpisodeRecipient");
	} else {
		if (objEP) SetTXTStatus(objEP,false);
		if (objEPLU) SetCMDStatus(objEPLU,false);
		labelNormal("EpisodeRecipient");
	}
	if ((EventType!="C")&&(objPTHidden.value=="A")) {
		labelMandatory("ActionType");
	} else {
		labelNormal("ActionType");
	}
	
	if (objPTHidden.value=="A") {
		if (objTimeOff) SetTXTStatus(objTimeOff,false);
		if (objTimeUnit) SetTXTStatus(objTimeUnit,false);
		if (objTimeUnitLU) objTimeUnitLU.disabled=true;
		var obj=document.getElementById("cTimeOffset");
		if (obj) obj.className="";
		var obj=document.getElementById("cTimeUnit");
		if (obj) obj.className="";
	} else {
		if (objTimeUnit) SetTXTStatus(objTimeUnit,true);
		if (objTimeOff) SetTXTStatus(objTimeOff,true);
		if (objTimeUnitLU) objTimeUnitLU.disabled=false;
		var obj=document.getElementById("cTimeOffset");
		if (obj) obj.className="clsRequired";
		var obj=document.getElementById("cTimeUnit");
		if (obj) obj.className="clsRequired";
	}
	
	if (objPTHidden.value=="R") {
		if (objORD) SetTXTStatus(objORD,true);
		if (objORDLU) SetCMDStatus(objORDLU,true);
		labelMandatory("OrderItem");
		if (objMSG) {
			objMSG.value="";
			objMSG.disabled=true;
			objMSG.className="disabledField";
		}
	} else {
		if (objORD) SetTXTStatus(objORD,false);
		if (objORDLU) SetCMDStatus(objORDLU,false);
		labelNormal("OrderItem");
		if (objMSG) {
			objMSG.className="";
			objMSG.disabled=false;
		}
	}
	
	if (objPTHidden.value=="E") {
		labelMandatory("EmailTo");
		labelMandatory("EmailFrom");
	} else {
		labelNormal("EmailTo");
		labelNormal("EmailFrom");
	}

	if (objPTHidden) {
		switch (objPTHidden.value){
			case 'A':
				if (objAT) {
					// ab 4.02.08 66194
					if (objClassName.value=="User.OEOrdItem") {
						var objNotif=document.getElementById("PopupTypeNotif");
						if (objNotif) {
							SetTXTStatus(objAT,true);
							objAT.value=objNotif.value;
							objAT.readOnly=true;
						}
					} else {
						SetTXTStatus(objAT,true);
					}
				}
				if (EventType!="C") {
					if (objATButt) SetCMDStatus(objATButt,true);
				} else {
					//if (objAT) SetTXTStatus(objAT,false);
					objAT.disabled=true;
					var objErr=document.getElementById("PopupTypeErr");
					if (objErr) objAT.value=objErr.value;
					if (objATButt) SetCMDStatus(objATButt,false);
				}
				if (objNR) SetTXTStatus(objNR,false);
				if (objNRButt) SetCMDStatus(objNRButt,false);
				if (objET) SetTXTStatus(objET,false);
				if (objEF) SetTXTStatus(objEF,false);
				if (objES) SetTXTStatus(objES,false);
				if (objFT) SetTXTStatus(objFT,false);
				if (objSU) SetTXTStatus(objSU,false);
				if (objSUButt) SetCMDStatus(objSUButt,false);
				if (objMG) SetTXTStatus(objMG,false);
				if (objMGButt) SetCMDStatus(objMGButt,false);
				if (objMR) SetTXTStatus(objMR,false);
				if (objMRHidden) SetTXTStatus(objMRHidden,false);
				if (objPA) SetTXTStatus(objPA,false);
				if (objST) SetTXTStatus(objST,false);
				if (objSTButt) SetCMDStatus(objSTButt,false);
				if (objCI) SetTXTStatus(objCI,false);
				if (objCIButt) SetCMDStatus(objCIButt,false);
				if (objCP) SetTXTStatus(objCP,false);
				if (objCPButt) SetCMDStatus(objCPButt,false);
				if (objCE) SetTXTStatus(objCE,false);
				if (objSV) SetTXTStatus(objSV,false);
				break;

			case 'E':
				if (objAT) SetTXTStatus(objAT,false);
				if (objATButt) SetCMDStatus(objATButt,false);
				if (objNR) SetTXTStatus(objNR,true);
				if (objNRButt) SetCMDStatus(objNRButt,true);
				if (objET) SetTXTStatus(objET,true);
				if (objEF) {
					SetTXTStatus(objEF,true);
					if (objEF.value=="") objEF.value="support@trakhealth.com";
				}
				if (objES) SetTXTStatus(objES,true);
				if (objFT) SetTXTStatus(objFT,false);
				if (objSU) SetTXTStatus(objSU,false);
				if (objSUButt) SetCMDStatus(objSUButt,false);
				if (objMG) SetTXTStatus(objMG,false);
				if (objMGButt) SetCMDStatus(objMGButt,false);
				if (objMR) SetTXTStatus(objMR,false);
				if (objMRHidden) SetTXTStatus(objMRHidden,false);
				if (objPA) SetTXTStatus(objPA,false);
				if (objST) SetTXTStatus(objST,false);
				if (objSTButt) SetCMDStatus(objSTButt,false);
				if (objCI) SetTXTStatus(objCI,false);
				if (objCIButt) SetCMDStatus(objCIButt,false);
				if (objCP) SetTXTStatus(objCP,false);
				if (objCPButt) SetCMDStatus(objCPButt,false);
				if (objCE) SetTXTStatus(objCE,false);
				if (objSV) SetTXTStatus(objSV,false);
				break;

			case 'F':
				if (objAT) SetTXTStatus(objAT,false);
				if (objATButt) SetCMDStatus(objATButt,false);
				if (objNR) SetTXTStatus(objNR,false);
				if (objNRButt) SetCMDStatus(objNRButt,false);
				if (objET) SetTXTStatus(objET,false);
				if (objEF) SetTXTStatus(objEF,false);
				if (objES) SetTXTStatus(objES,false);
				if (objFT) SetTXTStatus(objFT,true);
				if (objSU) SetTXTStatus(objSU,false);
				if (objSUButt) SetCMDStatus(objSUButt,false);
				if (objMG) SetTXTStatus(objMG,false);
				if (objMGButt) SetCMDStatus(objMGButt,false);
				if (objMR) SetTXTStatus(objMR,false);
				if (objMRHidden) SetTXTStatus(objMRHidden,false);
				if (objPA) SetTXTStatus(objPA,false);
				if (objST) SetTXTStatus(objST,false);
				if (objSTButt) SetCMDStatus(objSTButt,false);
				if (objCI) SetTXTStatus(objCI,false);
				if (objCIButt) SetCMDStatus(objCIButt,false);
				if (objCP) SetTXTStatus(objCP,false);
				if (objCPButt) SetCMDStatus(objCPButt,false);
				if (objCE) SetTXTStatus(objCE,false);
				if (objSV) SetTXTStatus(objSV,false);
				break;
			case 'P':
				if (objAT) SetTXTStatus(objAT,false);
				if (objATButt) SetCMDStatus(objATButt,false);
				if (objNR) SetTXTStatus(objNR,false);
				if (objNRButt) SetCMDStatus(objNRButt,false);
				if (objET) SetTXTStatus(objET,false);
				if (objEF) SetTXTStatus(objEF,false);
				if (objES) SetTXTStatus(objES,false);
				if (objFT) SetTXTStatus(objFT,false);
				if (objSU) SetTXTStatus(objSU,false);
				if (objSUButt) SetCMDStatus(objSUButt,false);
				if (objMG) SetTXTStatus(objMG,false);
				if (objMGButt) SetCMDStatus(objMGButt,false);
				if (objMR) SetTXTStatus(objMR,false);
				if (objMRHidden) SetTXTStatus(objMRHidden,false);
				if (objPA) SetTXTStatus(objPA,true);
				if (objST) SetTXTStatus(objST,false);
				if (objSTButt) SetCMDStatus(objSTButt,false);
				if (objCI) SetTXTStatus(objCI,false);
				if (objCIButt) SetCMDStatus(objCIButt,false);
				if (objCP) SetTXTStatus(objCP,false);
				if (objCPButt) SetCMDStatus(objCPButt,false);
				if (objCE) SetTXTStatus(objCE,false);
				if (objSV) SetTXTStatus(objSV,false);
				break;
			case 'S':
				if (objAT) SetTXTStatus(objAT,false);
				if (objATButt) SetCMDStatus(objATButt,false);
				if (objNR) SetTXTStatus(objNR,false);
				if (objNRButt) SetCMDStatus(objNRButt,false);
				if (objET) SetTXTStatus(objET,false);
				if (objEF) SetTXTStatus(objEF,false);
				if (objES) SetTXTStatus(objES,false);
				if (objFT) SetTXTStatus(objFT,false);
				if (objSU) SetTXTStatus(objSU,false);
				if (objSUButt) SetCMDStatus(objSUButt,false);
				if (objMG) SetTXTStatus(objMG,false);
				if (objMGButt) SetCMDStatus(objMGButt,false);
				if (objMR) SetTXTStatus(objMR,false);
				if (objMRHidden) SetTXTStatus(objMRHidden,false);
				if (objPA) SetTXTStatus(objPA,false);

				if (objST) SetTXTStatus(objST,true);
				if (objSTButt) SetCMDStatus(objSTButt,true);
				SetFieldTypeChangeHandler()
				/*
				if (objCI) SetTXTStatus(objCI,true);
				if (objCIButt) SetCMDStatus(objCIButt,true);
				if (objCP) SetTXTStatus(objCP,true);
				if (objCPButt) SetCMDStatus(objCPButt,true);
				if (objCE) SetTXTStatus(objCE,true);
				if (objSV) SetTXTStatus(objSV,true);
				*/
				break;
			case 'M':
				if (objAT) SetTXTStatus(objAT,false);
				if (objATButt) SetCMDStatus(objATButt,false);
				if (objNR) SetTXTStatus(objNR,false);
				if (objNRButt) SetCMDStatus(objNRButt,false);
				if (objET) SetTXTStatus(objET,false);
				if (objEF) SetTXTStatus(objEF,false);
				if (objES) SetTXTStatus(objES,false);
				if (objFT) SetTXTStatus(objFT,false);
				if (objSU) SetTXTStatus(objSU,true);
				if (objSUButt) SetCMDStatus(objSUButt,true);
				if (objMG) SetTXTStatus(objMG,true);
				if (objMGButt) SetCMDStatus(objMGButt,true);
				if (objMR) SetTXTStatus(objMR,true);
				if (objMRHidden) SetTXTStatus(objMRHidden,true);
				if (objPA) SetTXTStatus(objPA,false);
				if (objST) SetTXTStatus(objST,false);
				if (objSTButt) SetCMDStatus(objSTButt,false);
				if (objCI) SetTXTStatus(objCI,false);
				if (objCIButt) SetCMDStatus(objCIButt,false);
				if (objCP) SetTXTStatus(objCP,false);
				if (objCPButt) SetCMDStatus(objCPButt,false);
				if (objCE) SetTXTStatus(objCE,false);
				if (objSV) SetTXTStatus(objSV,false);
				break;
			default :
				if (objAT) SetTXTStatus(objAT,false);
				if (objATButt) SetCMDStatus(objATButt,false);
				if (objNR) SetTXTStatus(objNR,false);
				if (objNRButt) SetCMDStatus(objNRButt,false);
				if (objET) SetTXTStatus(objET,false);
				if (objEF) SetTXTStatus(objEF,false);
				if (objES) SetTXTStatus(objES,false);
				if (objFT) SetTXTStatus(objFT,false);
				if (objSU) SetTXTStatus(objSU,false);
				if (objSUButt) SetCMDStatus(objSUButt,false);
				if (objMG) SetTXTStatus(objMG,false);
				if (objMGButt) SetCMDStatus(objMGButt,false);
				if (objMR) SetTXTStatus(objMR,false);
				if (objMRHidden) SetTXTStatus(objMRHidden,false);
				if (objPA) SetTXTStatus(objPA,false);
				if (objST) SetTXTStatus(objST,false);
				if (objSTButt) SetCMDStatus(objSTButt,false);
				if (objCI) SetTXTStatus(objCI,false);
				if (objCIButt) SetCMDStatus(objCIButt,false);
				if (objCP) SetTXTStatus(objCP,false);
				if (objCPButt) SetCMDStatus(objCPButt,false);
				if (objCE) SetTXTStatus(objCE,false);
				if (objSV) SetTXTStatus(objSV,false);

				break;
		}
	}
}

var COMPstartDelim="{";
var COMPendDelim="}";
function MessageTo_keydownhandler(encmeth) {

	var obj=document.getElementById("MessageTo");
	var arr=new Array();
	arr[0]=document.getElementById("ClassName").value;
	LookUpFieldName="MsgText";
	//LocateCode(obj,encmeth);
	var SimpleDSS='';
	if (objSimpleDSS) SimpleDSS=objSimpleDSS.value;

	COMPLocateCode(obj,encmeth,arr,SimpleDSS);
}
function MessageTo_lookupsel(str) {
}

function ClassProperty_lookupSelect(str) {
	var lu=str.split("^");
	//var txt=lu[0];
	var txt=lu[1];
	var arrtxt=txt.split(" | ");
	txt=arrtxt.join("\n");
	LookupCode_replace_withToken(txt);
}

function labelMandatory(fld) {
	var lbl = document.getElementById('c' + fld)
	if (lbl) {
		lbl.className = "clsRequired";
	}
}
function labelNormal(fld) {
	var lbl = document.getElementById('c' + fld)
	if (lbl) {
		lbl.className = "";
	}
}