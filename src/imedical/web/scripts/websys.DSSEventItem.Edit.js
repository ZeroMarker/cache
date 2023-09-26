// Copyright (c) 2002 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var objID=document.getElementById("ID")
//disable the delete link for new actions
var lnk=document.getElementById("delete1")
if ((lnk)&&(objID.value=="")) {
	lnk.disabled=true;
	lnk.className="disabledField";
	lnk.onclick="";
}


//function BodyUnloadHandler(e) {
//	if ((self == top)) {
//			var win=window.opener;
//			if (win) {
//				win.treload('websys.csp');
//			}
//		}
//	}
//}
//we don't need to do this, the update can link to websys.reload.csp
//document.body.onunload=BodyUnloadHandler;

function BodyLoadHandler(e) {
	var update=document.getElementById("update1");
	if (update) update.onclick = UpdateClickHandler;
	var obj=document.getElementById("MedTrakFunction");
	if (obj) obj.onchange=FuncChange;
	var obj=document.getElementById("ItemFriendlyName");
	if (obj) obj.onchange=CondChange;
	var obj=document.getElementById("ConditionalOperator");
	if (obj) obj.onblur=CondChange;
	var obj=document.getElementById("ConditionValue");
	if (obj) obj.onchange=CondChange;
	var obj=document.getElementById("BooleanOperator");
	var objEI=document.getElementById("FirstEventItem");
	if ((objEI)&&(obj)) {
		if (objEI.value==0) obj.value="";
	}
	FuncChange();
	CondChange();
	var obj=document.getElementById("OperHidden");
	if (obj) GroupingEnable(obj.value);
	var obj=document.getElementById("GroupingCount");
	if (obj) obj.onblur=GroupingCountBlurHandler;
	GroupingCountBlurHandler();
	
}

document.body.onload=BodyLoadHandler;

function UpdateClickHandler() {
	if (mandatoryOK()) return update1_click();
}

function mandatoryOK() {
	var msg='';
	var fld=document.getElementsByTagName('INPUT');
	for (var j=0; j<fld.length; j++) {
		if ((fld[j].type!="HIDDEN")&&(fld[j].type!="hidden")&&(fld[j].className=="clsRequired")) {
 			msg+=RequiredMsgObj(fld[j],false);
		}
	}
	if (msg!='') {
    	alert(msg);
  		websys_setfocus(focusat.name);
		return false;
	} else {
		return true;
	}
		
}
function FuncChange() {
	var func=document.getElementById("MedTrakFunction");
	if (func && func.value!="") {
		// make function required and remove condition, operator and value
		func.className='clsRequired';
		var func=document.getElementById("cMedTrakFunction");
		func.className='clsRequired';
		var obj=document.getElementById("ItemFriendlyName");
		if (obj) {
			obj.className='';
			obj.value = "";
		}
		var obj=document.getElementById("cItemFriendlyName");
		if (obj) {
			obj.className='';
			obj.value = "";
		}
		var obj=document.getElementById("ConditionalOperator");
		if (obj) {
			obj.className='';
			obj.value = "";
		}
		var obj=document.getElementById("cConditionalOperator");
		if (obj) {
			obj.className='';
			obj.value = "";
		}
		var obj=document.getElementById("ConditionValue");
		if (obj) {
			obj.className='';
			obj.value = "";
		}
		var obj=document.getElementById("cConditionValue");
		if (obj) {
			obj.className='';
			obj.value = "";
		}
	} else {
		// make condition, operator and value required and remove function
		if (func) {
			func.className='';
			func.value = "";
		}
		var func=document.getElementById("cMedTrakFunction");
		if (func) {
			func.className='';
			func.value = "";
		}
		var obj=document.getElementById("ItemFriendlyName");
		if (obj) obj.className='clsRequired';
		var obj=document.getElementById("cItemFriendlyName");
		if (obj) obj.className='clsRequired';
		var obj=document.getElementById("ConditionalOperator");
		if (obj) obj.className='clsRequired';
		var obj=document.getElementById("cConditionalOperator");
		if (obj) obj.className='clsRequired';
		var obj=document.getElementById("ConditionValue");
		if (obj) obj.className='clsRequired';
		var obj=document.getElementById("cConditionValue");
		if (obj) obj.className='clsRequired';
	}		
	
}

// ab 19.12.06 59802
function ConditionalOperatorLookup(str) {
	var lu=str.split("^");
	GroupingEnable(lu[2]);
}

function GroupingEnable(code) {
	if (code=="=") {
		EnableField("GroupingCount");
		EnableField("GroupingOperator");
		EnableLookup("ld1221iGroupingOperator");
	} else {
		DisableField("GroupingCount");
		DisableField("GroupingOperator");
		DisableLookup("ld1221iGroupingOperator");
	}
}

function GroupingCountBlurHandler() {
	var obj=document.getElementById("GroupingCount");
	if ((obj)&&(obj.value!="")) {
		DisableField("MeasurementUnit");
		DisableLookup("ld1221iMeasurementUnit");
	} else {
		EnableField("MeasurementUnit");
		EnableLookup("ld1221iMeasurementUnit");
	}
}

function CondChange() {
	var obj=document.getElementById("ItemFriendlyName");
	if (obj && obj.value!="") {
		// make condition, operator and value required and remove function
		var func=document.getElementById("MedTrakFunction");
		if (func) {
			func.className='';
			func.value = "";
		}
		var func=document.getElementById("cMedTrakFunction");
		if (func) {
			func.className='';
			func.value = "";
		}
		var obj=document.getElementById("ItemFriendlyName");
		if (obj) obj.className='clsRequired';
		var obj=document.getElementById("cItemFriendlyName");
		if (obj) obj.className='clsRequired';
		var obj=document.getElementById("ConditionalOperator");
		if (obj) obj.className='clsRequired';
		var obj=document.getElementById("cConditionalOperator");
		if (obj) obj.className='clsRequired';
		var obj=document.getElementById("ConditionValue");
		if (obj) obj.className='clsRequired';
		var obj=document.getElementById("cConditionValue");
		if (obj) obj.className='clsRequired';
	}		
	
}

function LookUpSQLFieldName(str) {
 	var lu = str.split("^");
	var obj;
 	obj=document.getElementById("clsProperty")
	if (obj) obj.value = lu[0];
 	obj=document.getElementById("ClassProperty")
	if (obj) obj.value = lu[1];
}

function LookUpEventItemType(str) {
 	var lu = str.split("^");
	var obj;
 	obj=document.getElementById("EventItemType")
	if (obj) obj.value = lu[0];
	EventItemTypeChangeHandler()
}

//var objET=document.getElementById('EventItemType');
//if (objET) objET.onchange=EventItemTypeChangeHandler;

function SetTXTStatus(obj,blnStatus) {
	if (!blnStatus) {
		obj.value='';
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

/*var objCV=document.getElementById('ConditionValue');
if (objCV) objCV.onblur=cmdExecuteValidation;

function cmdExecuteValidation() {
	var objCV=document.getElementById('ConditionValue');

	var s=objCV.value

	if (s.match(/^\${2}/)) {
		if (!isFunction(s)) {
			alert('Invalid format for Cache function call.')
			objCV.focus()
		}
	}
}
function isFunction(str)
{	//This pattern matches :
	//$$CalAge^DSSFunc()
	//$$CalAge^DSSFunc('a'[,'b']*)"
	var patFunc=/^\${2}\w+\^\w+\(((\'\w+\')(\,\'\w+\')*)?\)/
	return str.match(patFunc);
}
*/
function LookUpViewRule(str) {
	//alert(str);
 	var lu = str.split("^");
 	var objNI=document.getElementById('ItemFriendlyName');
 	var objET=document.getElementById('EventItemType');

 	var objCI=document.getElementById('ComponentItem');
	var objCP=document.getElementById('ClassProperty');
	var objRU=document.getElementById('Rule');

	if (objET) objET.value = lu[2];
	if (objNI) objNI.value = lu[3];

	//window.alert(str);

	switch (lu[2]){
	case 'R':
		if (objCI) SetTXTStatus(objCI,false);
		if (objCP) SetTXTStatus(objCP,false);
		if (objRU) SetTXTStatus(objRU,true);
		if (objRU) objRU.value = lu[4];
		break;
	case 'L':
		if (objCI) SetTXTStatus(objCI,false);
		if (objCP) SetTXTStatus(objCP,true);
		if (objRU) SetTXTStatus(objRU,false);
		if (objCP) objCP.value = lu[4];
		break;
	case 'C':
		if (objCI) SetTXTStatus(objCI,true);
		if (objCP) SetTXTStatus(objCP,false);
		if (objRU) SetTXTStatus(objRU,false);
		if (objCI) objCI.value = lu[4];
		break;
	}
}


function LookUpEventItem(str) {

 	//window.alert(str);

	var lu = str.split("^");
 	var objEventItem=document.getElementById('dspEventItem');
 	var objEventItemID=document.getElementById('EventItemID');


	if (objEventItemID) objEventItemID.value = lu[0];
	if (objEventItem) objEventItem.value = lu[1]+lu[2]+lu[3];

}

var objEventItem=document.getElementById('dspEventItem');
if (objEventItem) objEventItem.onchange=UpdateEventItem;

function UpdateEventItem()
{	var objEventItem=document.getElementById('dspEventItem');
 	var objEventItemID=document.getElementById('EventItemID');

	if (objEventItem) {
		str=objEventItem.value
		if (str.length == 0){
			if (objEventItemID) objEventItemID.value = "";
		}
	}
	//alert(str);
}


/*
function EventItemTypeChangeHandler() {

	var objET=document.getElementById('EventItemType');
	var objCI=document.getElementById('compItem');
	var objCP=document.getElementById('clsProperty');
	var objRU=document.getElementById('Rule');
	var objCIButt=document.getElementById('ld1221icompItem');
	var objCPButt=document.getElementById('ld1221iclsProperty');
	var objRUButt=document.getElementById('ld1221iRule');

	if (objET) {
		//alert(objET.value)
		switch (objET.value){
		case 'R':
		case 'Rule':
			if (objCI) SetTXTStatus(objCI,false);
			if (objCIButt) SetCMDStatus(objCIButt,false);
			if (objCP) SetTXTStatus(objCP,false);
			if (objCPButt) SetCMDStatus(objCPButt,false);
			if (objRU) SetTXTStatus(objRU,true);
			if (objRUButt) SetCMDStatus(objRUButt,true);
			break;
		case 'C':
		case 'Component Item':
		case 'ComponentItem':
			if (objCI) SetTXTStatus(objCI,true);
			if (objCIButt) SetCMDStatus(objCIButt,true);
			if (objCP) SetTXTStatus(objCP,false);
			if (objCPButt) SetCMDStatus(objCPButt,false);
			if (objRU) SetTXTStatus(objRU,false);
			if (objRUButt) SetCMDStatus(objRUButt,false);
			break;
		case 'L':
		case 'Class Property':
		case 'ClassProperty':
			if (objCI) SetTXTStatus(objCI,false);
			if (objCIButt) SetCMDStatus(objCIButt,false);
			if (objCP) SetTXTStatus(objCP,true);
			if (objCPButt) SetCMDStatus(objCPButt,true);
			if (objRU) SetTXTStatus(objRU,false);
			if (objRUButt) SetCMDStatus(objRUButt,false);
			break;
		default :
			if (objCI) SetTXTStatus(objCI,false);
			if (objCIButt) SetCMDStatus(objCIButt,false);
			if (objCP) SetTXTStatus(objCP,false);
			if (objCPButt) SetCMDStatus(objCPButt,false);
			if (objRU) SetTXTStatus(objRU,false);
			if (objRUButt) SetCMDStatus(objRUButt,false);
		}
	}
}


function LookUpComponentItem(str) {
	var lu = str.split("^");
	var obj;
 	obj=document.getElementById("compItem")
	if (obj) obj.value = lu[0];
 	obj=document.getElementById("ComponentItem")
	if (obj) obj.value = lu[1];
}

var obj=document.getElementById('compItem');
if (obj) obj.onchange=UpdateComponentItem;

function UpdateComponentItem() {
	var obj;
	var str="";
	obj=document.getElementById("compItem")
	if (obj){
		str=obj.value
		if (str.length == 0){
			obj=document.getElementById("ComponentItem");
			if (obj) obj.value = "";
		}
	}
}

function LookUpRule(str) {
 	var lu = str.split("^");
	var obj;
 	obj=document.getElementById("Rule")
	if (obj) obj.value = lu[1];
}

var obj=document.getElementById('clsProperty');
if (obj) obj.onchange=UpdateClassProperty;

function UpdateClassProperty() {
	var obj;
	var str="";
	obj=document.getElementById("clsProperty")
	if (obj){
		str=obj.value
		if (str.length == 0){
			obj=document.getElementById("ClassProperty");
			if (obj) obj.value = "";
		}
	}
}

*/

