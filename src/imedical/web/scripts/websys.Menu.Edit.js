// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
// KK 21/Jan/2003 Log:31573
var fnWKFL_CHANGE=null;
function DocumentLoadHandler() {
	var objRT=document.getElementById('ReportType');
	var objpreview=document.getElementById('PrintPreview');
	//Enable/Disable PrintPreview checkbox depending upon the report type
	if ((objRT) && (objpreview)){
		if ((objRT.value=="")||(objRT.value=="Crystal")||(objRT.value=="Cache+Crystal")){
			objpreview.disabled=false;
		}else{
			objpreview.checked=false;
			objpreview.disabled=true;
		}
	}
	var obj=document.getElementById('delete1');
	if (obj) obj.onclick=delete1ClickHandler;
    
    DisableWorkFields();
    
    var obj=document.getElementById("WorkFlow");
	if (obj) {
		fnWKFL_CHANGE=obj.onchange;
		obj.onchange=WorkFlowChangeHandler;
	}
    //if (obj) obj.onblur=DisableWorkFields;
    var obj=document.getElementById("Worklist");
    if (obj) obj.onblur=DisableWorkFields;
    
    CheckTrakOptions();
}

// ab 8.03.07 62951 - disable all fields on screen for TRAK menus if "Enable Trak Options" is not checked
function CheckTrakOptions() {
	var objid=document.getElementById("ID");
	var obj=document.getElementById("EnableTrakOptions");
	if ((obj)&&(obj.value!=1)&&(objid)&&(objid.value!="")&&(objid.value<50000)) {
		DisableAllFields(0,",update1,PrintPreview,",0)
		
		var obj=document.getElementById("PrintPreview");
		if (obj) obj.onclick=DisableCheck;
	}
}

function DisableCheck() {
	return false;
}



function WorkFlowChangeHandler() {
	if (typeof fnWKFL_CHANGE=="function") fnWKFL_CHANGE();
	DisableWorkFields();
}

// ab 14.10.04 46566
function DisableWorkFields() {
    var objWF=document.getElementById("WorkFlow");
    var objWL=document.getElementById("Worklist");
    if ((objWF)&&(objWL)) {
        if (objWF.value!="") ReadonlyField("Worklist","ld4iWorklist");
        if (objWL.value!="") ReadonlyField("WorkFlow","ld4iWorkFlow");
        if (objWF.value=="") EnableField("Worklist","ld4iWorklist");
        if (objWL.value=="") EnableField("WorkFlow","ld4iWorkFlow");
    }
}

function WorkflowLookup(str) {
    DisableWorkFields();
}

function WorklistLookup(str) {
    DisableWorkFields();
}

function EnableField(fldname,lookupname) {
	if (fldname) {
		var elem = document.getElementById(fldname);
		if (elem) {
			elem.readOnly = false;
			elem.disabled = false;
			elem.className = "";
		}
		if (lookupname) {
			var elem = document.getElementById(lookupname);
			if (elem) elem.disabled = false;
		}
	}
}
function ReadonlyField(fldname,lookupname) {
	if (fldname) {
		var elem = document.getElementById(fldname);
		if (elem) {
			elem.readOnly = true;
			elem.className = "disabledField";
		}
		if (lookupname) {
			var elem = document.getElementById(lookupname);
			if (elem) elem.disabled = true;
		}
	}
}

//Select from lookup
function LookUpByReportSelect(str) {
	//alert(str);
	var lu = str.split("^");
	var obj=document.getElementById('LinkReport');
	if (obj) obj.value=lu[2];
	var objpreview=document.getElementById('PrintPreview');
	if (objpreview) {	
		if (lu[3]=="Crystal") {
			objpreview.disabled=false;
			objpreview.checked=false;
		}else{
			objpreview.checked=false;
			objpreview.disabled=true;
		}
	}
}
function delete1ClickHandler() {
	//check before deleting entire menu
	if (confirm(t["DELETE"])) {return true;} else {return false;}
}
document.body.onload=DocumentLoadHandler;
