// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var oldReportKeyDown="";
var oldReportGroupKeyDown="";
var oldLocationKeyDown="";
var oldIPKeyDown="";

var objReport=document.getElementById("Report");
var objReportGroup=document.getElementById("ReportGroup");
var objHospital=document.getElementById("Hospital");
var objLocation=document.getElementById("Location");
var objIP=document.getElementById("IP");

var objReportLookUpIcon=document.getElementById("ld405iReport");
var objReportGroupLookUpIcon=document.getElementById("ld405iReportGroup");
var objHospitalLookUpIcon=document.getElementById("ld405iHospital");
var objLocationLookUpIcon=document.getElementById("ld405iLocation");

function DocumentLoadHandler() {
	
	if (objReport) {
		oldReportKeyDown=objReport.onkeydown;
		objReport.onkeydown=ReportKeyDownHandler;
	}

	if (objReportGroup) {
		oldReportGroupKeyDown=objReportGroup.onkeydown;
		objReportGroup.onkeydown=ReportGroupKeyDownHandler;
	}

	if (objLocation) {
		oldLocationKeyDown=objLocation.onkeydown;
		objLocation.onkeydown=LocationKeyDownHandler;
	}

	if (objIP) {
		oldIPKeyDown=objIP.onkeydown;
		objIP.onkeydown=IPKeyDownHandler;
	}
	var objDeleteDept=document.getElementById('DeletePrinter');
	if (objDeleteDept) objDeleteDept.onclick=ALPListDeleteClickHandler;
	var objUpd=document.getElementById('update1')
	if (objUpd) objUpd.onclick=UpdateAll;

	EnableDisableFields("");
}

function ReportKeyDownHandler() {
	if (typeof oldReportKeyDown!="function") oldReportKeyDown=new Function(oldReportKeyDown);
	if (oldReportKeyDown()==false) return false;
	EnableDisableFields("");
}

function ReportGroupKeyDownHandler() {
	if (typeof oldReportGroupKeyDown!="function") oldReportGroupKeyDown=new Function(oldReportGroupKeyDown);
	if (oldReportGroupKeyDown()==false) return false;
	EnableDisableFields("");
}

function LocationKeyDownHandler() {
	if (typeof oldLocationKeyDown!="function") oldLocationKeyDown=new Function(oldLocationKeyDown);
	if (oldLocationKeyDown()==false) return false;
	EnableDisableFields("");
}

function IPKeyDownHandler() {
	if (typeof oldIPKeyDown!="function") oldIPKeyDown=new Function(oldIPKeyDown);
	if (oldIPKeyDown()==false) return false;
	EnableDisableFields("");
}

	

function EnableField(fldName) {
	var fld = document.getElementById(fldName);
	//var lbl = document.getElementById('c'+fldName);
	if (fld) {
		fld.disabled = false;
		fld.className = "";
	}
}

function DisableField(fldName) {
	var fld = document.getElementById(fldName);
	//var lbl = document.getElementById('c'+fldName);
	if ((fld)&&(fld.tagName=="INPUT")) {
		fld.value = "";
		fld.disabled = true;
		fld.className = "disabledField";
	}
}

function EnableDisableFields(str) {

	if (objReport) {
		if (objReport.value=="") {
			EnableField("ReportGroup");
			if (objReportGroupLookUpIcon) objReportGroupLookUpIcon.style.visibility = "visible";
		} else {
			DisableField("ReportGroup");
			if (objReportGroupLookUpIcon) objReportGroupLookUpIcon.style.visibility = "hidden";
		}
	}

	if (objReportGroup) {
		if (objReportGroup.value=="") {
			EnableField("Report");
			if (objReportLookUpIcon) objReportLookUpIcon.style.visibility = "visible";
		} else {
			DisableField("Report");
			if (objReportLookUpIcon) objReportLookUpIcon.style.visibility = "hidden";
		}
	}

	if (objLocation) {
		if (objLocation.value=="") {
			EnableField("IP");
		} else {
			DisableField("IP");
		}
	}

	if (objIP) {
		if (objIP.value=="") {
			EnableField("Location");
			if (objLocationLookUpIcon) objLocationLookUpIcon.style.visibility = "visible";
			EnableField("Hospital");
			if (objHospitalLookUpIcon) objHospitalLookUpIcon.style.visibility = "visible";
		} else {
			DisableField("Location");
			if (objLocationLookUpIcon) objLocationLookUpIcon.style.visibility = "hidden";
			DisableField("Hospital");
			if (objHospitalLookUpIcon) objHospitalLookUpIcon.style.visibility = "hidden";
		}
	}
	
	// Log 52406 YC - If location is populated, populate hospital field
	if(objLocation && objHospital) {
		if (str!="") {
			var strArr = str.split("^");
			if (strArr[4]) objHospital.value=strArr[4];
		}
	}
	
}

// Log 52406 YC - Clear Location if Hospital is changed
function HospitalLookUpHandler(str) {
	if (objHospital && objLocation) {
		objLocation.value="";
	}
}

//   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
//KK 28/Nov/2002 Log 30023
function AltPrinterLookUpSelect(txt) {
	//Add an item to ALPList when an item is selected from
	//the Lookup, then clears the Item text field.
	//alert(txt);
	var adata=txt.split("^");
	//alert("adata="+adata);
	var obj=document.getElementById("ALPList")
	if (obj) {
		//Need to check if Printer already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == String.fromCharCode(2)+adata[1]) {
				alert("Printer has already been selected");
				var obj=document.getElementById("AltPrinter")//Textbox with lookup for Alternative Printer
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
				alert("Printer has already been selected");
				var obj=document.getElementById("AltPrinter")
				if (obj) obj.value="";
				return;
			}
			//alert(obj.options[i].value+"****"+adata[1])
		}
	}
	AddItemToList(obj,adata[1],adata[0]);
	var obj=document.getElementById("AltPrinter")
	if (obj) obj.value="";
	//alert("adata="+adata);
}

function AddItemToList(list,code,desc) {
	//Add an item to a listbox
	code=String.fromCharCode(2)+code
	list.options[list.options.length] = new Option(desc,code);
}

function ALPListDeleteClickHandler() {
	//Delete items from ALPList listbox when "Delete" button is clicked.
	var obj=document.getElementById("ALPList")
	if (obj)
		RemoveFromList(obj);
	return false;
}

function RemoveFromList(obj) {
	for (var i=(obj.length-1); i>=0; i--) {
		if (obj.options[i].selected)
			obj.options[i]=null;
	}
}

function UpdateAltPrinters() {
	var arrItems = new Array();
	var lst = document.getElementById("ALPList");
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			arrItems[j] = lst.options[j].value;
		}
		var el = document.getElementById("AltPrinterString");
		if (el) el.value = arrItems.join(String.fromCharCode(1));
		//alert(el.value );
	}
}

function UpdateAll(){
	UpdateAltPrinters();
	EnableAllFields();
	return update1_click() 
}
//KK Log 32666 - Enable all fields to save all fileds (including the ones which has got not entries)
function EnableAllFields(){
	EnableField("ReportGroup");
	EnableField("Report");
	EnableField("Location");
	EnableField("IP");
}



document.body.onload = DocumentLoadHandler;