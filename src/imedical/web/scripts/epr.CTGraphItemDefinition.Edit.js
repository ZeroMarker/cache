// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

// this var used to distinguish WHICH colour picker I have chosen, as colorpallette.csp doesn't
var WhichColourPicker = "";

var ObjRepeat=document.getElementById("repeat1");  if (ObjRepeat) ObjRepeat.onclick=RepeatClick;
var ObjUpdate=document.getElementById("update1");  if (ObjUpdate) ObjUpdate.onclick=UpdateClick;
// Log 47569 - AI - 26-11-2004 : New handler for the Delete link.
var ObjDelete=document.getElementById("delete1");  if (ObjUpdate) ObjDelete.onclick=DeleteClick;
var ObjColourPal=document.getElementById("colourpalette");  if (ObjColourPal) ObjColourPal.onclick=OpenColorPalette;
var ObjCTGIColour=document.getElementById("CTGIColour");  if (ObjCTGIColour) ObjCTGIColour.onkeydown=colourpalette_lookuphandler;
var ObjRefColour=document.getElementById("refcolourpalette");  if (ObjRefColour) ObjRefColour.onclick=OpenRefColorPalette;
var ObjLineColour=document.getElementById("CTGIRefLineColour");  if (ObjLineColour) ObjLineColour.onkeydown=refcolourpalette_lookuphandler;
var objOBS=document.getElementById("CTGIObsItem");  if (objOBS) objOBS.onblur=OBSChange;
var objLAB=document.getElementById("CTGILabItem");  if (objLAB) objLAB.onblur=LABChange;
var objORD=document.getElementById("CTGIOrderItem");  if (objORD) objORD.onblur=ORDChange;

var objOBSDR=document.getElementById("CTGIObsItemDR");
var objLABDR=document.getElementById("CTGILabItemDR");
var objORDDR=document.getElementById("CTGIOrderItemDR");

// KK 24/3/05 L:46459
var objLnkOBS=document.getElementById("CTGILinkedObsItem");  if (objLnkOBS) objLnkOBS.onblur=LinkedOBSChange;
var objLnkLAB=document.getElementById("CTGILinkedLabItem");  if (objLnkLAB) objLnkLAB.onblur=LinkedLABChange;
var objLnkORD=document.getElementById("CTGILinkedOrderItem");  if (objLnkORD) objLnkORD.onblur=LinkedORDChange;

var objLnkOBSDR=document.getElementById("CTGILinkedObsItemDR");
var objLnkLABDR=document.getElementById("CTGILinkedLabItemDR");
var objLnkORDDR=document.getElementById("CTGILinkedOrderItemDR");

// PJC 18/07/2007 Log:59780
var objDelRefRange=document.getElementById("DeleteRefRange"); if (objDelRefRange) objDelRefRange.onclick=DeleteSelectedClickHandler;

var objObsOnly=document.getElementById("CTGIObsOnly"); if (objObsOnly) objObsOnly.onclick=ObsOnlyClickHandler;

function DeleteSelectedClickHandler(e) {
	var obj=document.getElementById("ListRefRanges");
	if (obj) ClearSelectedList(obj);
	return false;
}

function RefRangeLookUp(val){
	var objRefRangeList=document.getElementById("ListRefRanges");
	var objRefRange=document.getElementById("CTGINonLinearRefRange");
	objRefRange.value="";
	TransferToList2(objRefRangeList,val)
}

function TransferToList2(obj,val,delim) {
    if ((!delim)||(delim=="")) delim=",";
	var found=0
	ary=val.split("^");
	arytxt=ary[0].split(delim);
	aryval=ary[2].split(delim);
	for (var i=0;i<obj.length;i++) {if (obj.options[i].value==ary[1]) found=1;}
	if (found==0) AddItemToList(obj,arytxt,aryval);
}

// end Log:59780


function BodyLoadHandler() {
	// Log 47569 - AI - 26-11-2004 : Disable the appropriate links.
	var objID=document.getElementById("ID");
	var objDelete=document.getElementById("delete1");
	var objRepeat=document.getElementById("repeat1");
	if (((objID)&&(objID.value==""))&&(objDelete)) {
		objDelete.disabled=true;
		objDelete.onClick="";
	}
	if (((objID)&&(objID.value!=""))&&(objRepeat)) {
		objRepeat.disabled=true;
		objRepeat.onClick="";
	}
	var objGraphType=document.getElementById("GraphType");
	var objObsOnly=document.getElementById("CTGIObsOnly");
	if ( objObsOnly && objGraphType ) {
		if (objGraphType.value=="PG") {
			objObsOnly.disabled=false;
			objObsOnly.className="";
		} else {
			objObsOnly.checked=false;
			objObsOnly.disabled=true;
			objObsOnly.className="disabledField";
		}
		ObsOnlyClickHandler();
	}
	document.focus();
	// end Log 47569
}

// Log 47569 - AI - 26-11-2004 : New handler for the Delete link.
function DeleteClick(e) {
	var objDelete=document.getElementById("delete1");
	if ((objDelete)&&(objDelete.disabled==true)) {
		return false;
	}
	return delete1_click();
}
// end Log 47469

function RepeatClick(e) {
	var objRepeat=document.getElementById("repeat1");
	if ((objRepeat)&&(objRepeat.disabled==true)) {
		return false;
	}

	// whichever item is selected, set the other 2 to null
	var val;
	alertme=true;
	if ((objLAB)&&(objLAB.value!="")) alertme=false;
	if ((objORD)&&(objORD.value!="")) alertme=false;
	if ((objOBS)&&(objOBS.value!="")) alertme=false;
	if (alertme) {
		alert("One of: 'Observation, Lab Item, Order Item' MUST be chosen");
		val = false;
	} else {
		val =  repeat1_click();
		window.opener.treload('websys.csp');
	}
	return val;
}

function UpdateClick(e) {
	// whichever item is selected, set the other 2 to null
	alertme=true;
	if ((objLAB)&&(objLAB.value!="")) alertme=false;
	if ((objORD)&&(objORD.value!="")) alertme=false;
	if ((objOBS)&&(objOBS.value!="")) alertme=false;
	if (alertme) {
		alert("One of: 'Observation, Lab Item, Order Item' MUST be chosen");
		return false;
	} else {
		// PJC 18/07/2007 Log:59780
		var objRefRangeList=document.getElementById("ListRefRanges");
		var objRefRange=document.getElementById("CTGINonLinearRefRange");
		if (objRefRangeList) {
			var ary=returnValues(objRefRangeList);
			objRefRange.value=ary.join(",");
		}

		return update1_click();
	}

}

function ItemTypeChange(e) {
	// whichever item is selected, set the other 2 to null
	if ((e=="OBS")&&(objOBS.value!="")) {
		if (objLAB) objLAB.value="";
		if (objLABDR) objLABDR.value="";
		if (objORD) objORD.value="";
		if (objORDDR) objORDDR.value="";
	} else if ((e=="LAB")&&(objLAB.value!="")) {
		if (objOBS) objOBS.value="";
		if (objOBSDR) objOBSDR.value="";
		if (objORD) objORD.value="";
		if (objORDDR) objORDDR.value="";
	} else if ((e=="ORD")&&(objORD.value!="")) {
		if (objLAB) objLAB.value="";
		if (objLABDR) objLABDR.value="";
		if (objOBS) objOBS.value="";
		if (objOBSDR) objOBSDR.value="";
	}
	//ClearLinkedItems();
	//alert("lab: " + objLABDR.value + "\norder: " + objORDDR.value + "\nobs: " + objOBSDR.value);
}

function ColorPicker(color) {
	var obj = "";
	var colourarr = color.split(",")
	if (WhichColourPicker=='MainColour') {
		obj = document.getElementById("CTGIColour");
	} else if (WhichColourPicker=='RefColour'){
		obj = document.getElementById("CTGIRefLineColour");
	}
	if (obj) {
		obj.value=colourarr[1];
	}

}


function OpenPalette() {
	var url = "websys.colorpalette.csp?";
        //Log 59598 - BC - 30-06-2006 : remove statusbar variable (status=) to display the status bar.
	websys_createWindow(url,"Palette","top=70,left=440,width=150,height=350,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes")
	return false;
}
function OpenColorPalette() {
	WhichColourPicker = 'MainColour';
	OpenPalette();
}
function OpenRefColorPalette() {
	WhichColourPicker = 'RefColour';
	OpenPalette();
}
function OBSChange (str) {
	// put the hidden obs ROWID somewhere
	if (str) {
		//alert(str);
		var arr=str.split("^");
		var ObjObsCode=document.getElementById("CTGIObsItemDR");
		if (ObjObsCode) {ObjObsCode.value=arr[2]};
		var ObjObsType=document.getElementById("CTGIObsItemType");
		if (ObjObsType) {ObjObsType.value=arr[3]};
	}
	ItemTypeChange("OBS");
}
function LABChange (str) {
	// put the hidden labcode somewhere
	if (str) {
		var arr=str.split("^");
		var ObjLabCode=document.getElementById("CTGILabItemDR")
		if (ObjLabCode) {ObjLabCode.value=arr[1]};
	}
	ItemTypeChange("LAB");

}
function ORDChange (str) {
	// put the hidden order code somewhere
	if (str) {
		//alert(str);
		var arr=str.split("^");
		var ObjOrdCode=document.getElementById("CTGIOrderItemDR")
		if (ObjOrdCode) {ObjOrdCode.value=arr[1]};
	}

	ItemTypeChange("ORD");
}
function colourpalette_lookuphandler(e) {
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='keydown')&&(key==117)) {
		OpenColorPalette();
		return websys_cancel();
	}
}

function refcolourpalette_lookuphandler(e) {
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='keydown')&&(key==117)) {
		OpenRefColorPalette();
		return websys_cancel();
	}
}

//KK 30/3/05 L:46459
function LinkedOBSChange(str) {
	// put the hidden obs ROWID somewhere
	if ((objOBS)&&(objOBS.value=="")){
		if (objLnkOBS) objLnkOBS.value="";
		if (objLnkOBSDR) objLnkOBSDR.value="";
		return true;
	}
	if (str) {
		//alert(str);
		var arr=str.split("^");
		var ObjLnkObsCode=document.getElementById("CTGILinkedObsItemDR")
		if (ObjLnkObsCode) {ObjLnkObsCode.value=arr[2]};
	}else{
		var ObjLnkObsCode=document.getElementById("CTGILinkedObsItemDR")
		if (ObjLnkObsCode) ObjLnkObsCode.value="";
	}
	LinkedItemTypeChange("OBS");
}
function LinkedLABChange(str) {
	// put the hidden labcode somewhere
	if ((objLAB)&&(objLAB.value=="")){
		if (objLnkLAB) objLnkLAB.value="";
		if (objLnkLABDR) objLnkLABDR.value="";
		return true;
	}
	if (str) {
		var arr=str.split("^");
		var ObjLnkLabCode=document.getElementById("CTGILinkedLabItemDR");
		if (ObjLnkLabCode) {ObjLnkLabCode.value=arr[1]};
	}else{
		var ObjLnkLabCode=document.getElementById("CTGILinkedLabItemDR");
		if (ObjLnkLabCode) ObjLnkLabCode.value="";
	}
	LinkedItemTypeChange("LAB");

}
function LinkedORDChange(str) {
	// put the hidden order code somewhere
	if ((objORD)&&(objORD.value=="")){
		if (objLnkORD) objLnkORD.value="";
		if (objLnkORDDR) objLnkORDDR.value="";
		return true;
	}
	if (str) {
		var arr=str.split("^");
		var ObjLnkOrdCode=document.getElementById("CTGILinkedOrderItemDR");
		if (ObjLnkOrdCode) {ObjLnkOrdCode.value=arr[1]};
	}else{
		var ObjLnkOrdCode=document.getElementById("CTGILinkedOrderItemDR");
		if (ObjLnkOrdCode) ObjLnkOrdCode.value="";
	}
	LinkedItemTypeChange("ORD");
}

function LinkedItemTypeChange(e) {
	// whichever item is selected, set the other 2 to null
	if ((e=="OBS")&&(objLnkOBS.value!="")) {
		if (objLnkLAB) objLnkLAB.value="";
		if (objLnkLABDR) objLnkLABDR.value="";
		if (objLnkORD) objLnkORD.value="";
		if (objLnkORDDR) objLnkORDDR.value="";
	} else if ((e=="LAB")&&(objLnkLAB.value!="")) {
		if (objLnkOBS) objLnkOBS.value="";
		if (objLnkOBSDR) objLnkOBSDR.value="";
		if (objLnkORD) objLnkORD.value="";
		if (objLnkORDDR) objLnkORDDR.value="";
	} else if ((e=="ORD")&&(objLnkORD.value!="")) {
		if (objLnkLAB) objLnkLAB.value="";
		if (objLnkLABDR) objLnkLABDR.value="";
		if (objLnkOBS) objLnkOBS.value="";
		if (objLnkOBSDR) objLnkOBSDR.value="";
	}
	//alert("lab: " + objLnkLABDR.value + "\norder: " + objLnkORDDR.value + "\nobs: " + objLnkOBSDR.value);
}

function ObsOnlyClickHandler() {
	var obsOnly=document.getElementById("CTGIObsOnly");
	if ( obsOnly ) {
		EnableDisable("CTGIColour",obsOnly.checked);
		EnableDisable("CTGILegendSequence",obsOnly.checked);
		EnableDisable("CTGILowerRange",obsOnly.checked);
		EnableDisable("CTGIMarker",obsOnly.checked);
		EnableDisable("CTGIMarker",obsOnly.checked);
		EnableDisable("CTGINormalLineType",obsOnly.checked);
		EnableDisable("CTGIUpperRange",obsOnly.checked);
		EnableDisable("CTGIVariableLineType",obsOnly.checked);
		EnableDisable("CTGIYAxis",obsOnly.checked);
		EnableDisable("CTGIRefLineColour",obsOnly.checked);
		EnableDisable("CTGIMarkerSize",obsOnly.checked);
		EnableDisable("CTGINonLinearRefRange",obsOnly.checked);
		EnableDisable("ListRefRanges",obsOnly.checked);
		EnableDisable("DeleteRefRange",obsOnly.checked);
		
		var ObsItemTypes=document.getElementById("ObsItemTypes");
		if(objOBS && ObsItemTypes) {
			if(obsOnly.checked) {
				// set it to numeric and text
				ObsItemTypes.value="NT";
			}
			else {
				ObsItemTypes.value="N";
				var thisobsitmtype=document.getElementById("CTGIObsItemType");
				if(thisobsitmtype) {
					// if not obsonly, don't let user add obs of type text
					if(thisobsitmtype.value=="T") {
						objOBS.value=""; 
						objOBSDR.value="";
					}
				}
			}
		}
	}
}

function EnableDisable(objName,disable)
{
	var obj=document.getElementById(objName);
	var objLookUp=document.getElementById("ld1803i"+objName);
	var ObjColourPal=document.getElementById("colourpalette");
	var ObjRefColour=document.getElementById("refcolourpalette");
	if (obj) {
		if(disable==true) {
			obj.value=""
			obj.disabled=true;
			obj.className="disabledField";
			if (objLookUp){
				objLookUp.disabled=true;
			}
			if (ObjColourPal) ObjColourPal.disabled=true; ObjColourPal.onclick="";
			if (ObjRefColour) ObjRefColour.disabled=true; ObjRefColour.onclick="";
		}
		else {
	 		obj.disabled=false;
			obj.className="";
			if (objLookUp){
				objLookUp.disabled=false;
			}
			if (ObjColourPal) ObjColourPal.disabled=false; ObjColourPal.onclick=OpenColorPalette;
			if (ObjRefColour) ObjRefColour.disabled=false; ObjRefColour.onclick=OpenRefColorPalette;
		}
	}
}

document.body.onload=BodyLoadHandler;


