// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
//Log 61112 28-09-2006 BoC: default the order category field when order subcategory is selected

function LookUpSubCatSelect(txt) {
	var adata=txt.split("^");
	var subCatID=adata[1];
	var subcatobj=document.getElementById("subCatID");
	if (subcatobj) subcatobj.value=subCatID;
	if (subCatID!="") {
		var CatDesc=""
		CatDesc = tkMakeServerCall("web.ARCOrdSets","GetCategory",subCatID);
		//alert (CatDesc);
		var catObj = document.getElementById("ORCATDesc");
		if (catObj) catObj.value=CatDesc
	}
}

//Log 61111 28-09-2006 BoC: default the bill group field when bill sub group is selected
function LookUpBillSubCatSelect(txt) {
	var adata=txt.split("^");
	var bcatObj = document.getElementById("ARCBGDesc");
	if (bcatObj) bcatObj.value=adata[3];
}

//Log 61565 30-01-2007 BoC: add date change handler and float field change handler
function ARCOSEffDateToChangeHandler(e) {
		ARCOSEffDateTo_changehandler(e) 
		var from=document.getElementById('ARCOSEffDateFrom')
		var to=document.getElementById('ARCOSEffDateTo')
		var fromdt=DateStringToArray(from.value)
		var todt=DateStringToArray(to.value)
		var dtto=new Date(todt["yr"], todt["mn"]-1, todt["dy"]);
		var dtfrom=new Date(fromdt["yr"], fromdt["mn"]-1, fromdt["dy"]);
		if ((to)&&(from)) {
			if (dtto< dtfrom) {
			alert("\'" + t['ARCOSEffDateTo'] + "\' " + t['XINVALID'] + "\n");
			to.value=""
			}
		}
	
}


function ARCOSEffDateFromChangeHandler(e) {
		ARCOSEffDateFrom_changehandler(e)
		var to=document.getElementById('ARCOSEffDateTo')
		var from=document.getElementById('ARCOSEffDateFrom')
		var fromdt=DateStringToArray(from.value)
		var todt=DateStringToArray(to.value)
		var dtto=new Date(todt["yr"], todt["mn"]-1, todt["dy"]);
		var dtfrom=new Date(fromdt["yr"], fromdt["mn"]-1, fromdt["dy"]);
		if ((to)&&(from)) {
			if (dtto< dtfrom) {
			alert("\'" + t['ARCOSEffDateFrom'] + "\' " + t['XINVALID'] + "\n");
			from.value=""
			}
		}
	
}

function Float_changehandler() {
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var isValid=0;
	if (IsValidNumber(eSrc)) {
		isValid=1;
		if (!IsPositiveNumber(eSrc)) isValid=0;
	}
	if (!isValid) {
		eSrc.className='clsInvalid';
	} else {
		eSrc.className=""
	}
}

var ARCOSEffDateFromObj=document.getElementById("ARCOSEffDateFrom");
if (ARCOSEffDateFromObj) ARCOSEffDateFromObj.onchange=ARCOSEffDateFromChangeHandler;
var ARCOSEffDateToObj=document.getElementById("ARCOSEffDateTo");
if (ARCOSEffDateToObj) ARCOSEffDateToObj.onchange=ARCOSEffDateToChangeHandler;
var ARCOSDaysObj=document.getElementById("ARCOSDays");
if (ARCOSDaysObj) ARCOSDaysObj.onchange=Float_changehandler;
var ARCOSMinutesObj=document.getElementById("ARCOSMinutes");
if (ARCOSMinutesObj) ARCOSMinutesObj.onchange=Float_changehandler;