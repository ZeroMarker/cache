// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

// Log 33798 - AI - 02-06-2005 : File created. Controls for the component, related to the "New Scan" functionality.

// Arrays to store the full Standard Type definitions for each field.

var aryPaperSize = new Array();	 // Paper Sizes
var aryPixelType = new Array();	 // Pixel Types
var aryFileType = new Array();	 // File Types

var PaperSize_ChangeHandler = 0; // Whether function PaperSizeChangeHandler has been called yet.
var PaperSize_LookUp = 0;	 // Whether function PaperSizeLookUp has been called yet.
var PixelType_ChangeHandler = 0; // Whether function PixelTypeChangeHandler has been called yet.
var PixelType_LookUp = 0;	 // Whether function PixelTypeLookUp has been called yet.
var FileType_ChangeHandler = 0;	 // Whether function FileTypeChangeHandler has been called yet.
var FileType_LookUp = 0;	 // Whether function FileTypeLookUp has been called yet.


// Define all of the hidden fields as globals.

var objhiddenPaperSize = document.getElementById('hiddenPaperSize');
var objhiddenWidth = document.getElementById('hiddenWidth');
var objhiddenHeight = document.getElementById('hiddenHeight');
var objhiddenPixelType = document.getElementById('hiddenPixelType');
var objhiddenFileType = document.getElementById('hiddenFileType');


Init();


function Init() {

	var objPaperSize = document.getElementById('sPaperSize');
	if (objPaperSize) objPaperSize.onchange=PaperSizeChangeHandler;

	var objWidth = document.getElementById('iWidth');
	if (objWidth) objWidth.onblur=WidthBlurHandler;

	var objHeight = document.getElementById('iHeight');
	if (objHeight) objHeight.onblur=HeightBlurHandler;

	var objDPI = document.getElementById('iDPI');
	if (objDPI) objDPI.onblur=DPIBlurHandler;

	var objPixelType = document.getElementById('sPixelType');
	if (objPixelType) objPixelType.onchange=PixelTypeChangeHandler;

	var objFileType = document.getElementById('sFileType');
	if (objFileType) objFileType.onchange=FileTypeChangeHandler;

	var objFileQuality = document.getElementById('iFileQuality');
	if (objFileQuality) objFileQuality.onblur=FileQualityBlurHandler;

	NewScan_BodyLoadHandler();

}

// this needs to be called after the captions are dumped
function NewScan_BodyLoadHandler() {

//alert("BodyLoad");

	var j;

	// Load the array strings (built in mrpictures.new.csp) into REAL arrays.
	// Paper Sizes
	var objStrAry=document.getElementById('allPaperSizes');
	var str=objStrAry.value;
	if (str!="") {
		var lu = str.split("|*|");
		for(j=0; j<lu.length; j++) {
			var lu1=lu[j].split("^");
			if (lu1[0]!="") aryPaperSize[j]=new aryRecord(lu1[0],lu1[1],lu1[2]);
		}
	}
	// Pixel Types
	var objStrAry=document.getElementById('allPixelTypes');
	var str=objStrAry.value;
	if (str!="") {
		var lu = str.split("|*|");
		for(j=0; j<lu.length; j++) {
			var lu1=lu[j].split("^");
			if (lu1[0]!="") aryPixelType[j]=new aryRecord(lu1[0],lu1[1],lu1[2]);
		}
	}
	// File Types
	var objStrAry=document.getElementById('allFileTypes');
	var str=objStrAry.value;
	if (str!="") {
		var lu = str.split("|*|");
		for(j=0; j<lu.length; j++) {
			var lu1=lu[j].split("^");
			if (lu1[0]!="") aryFileType[j]=new aryRecord(lu1[0],lu1[1],lu1[2]);
		}
	}

	PaperSizeChangeHandler();
	PixelTypeChangeHandler();
	FileTypeChangeHandler();

}


function PaperSizeChangeHandler() {
	// When Paper Size is changed, set values and enable/disable width and height fields
	//alert("PaperSizeChange");

	var objPaperSize = document.getElementById('sPaperSize');
	var objWidth = document.getElementById('iWidth');
	var objHeight = document.getElementById('iHeight');

	if (objPaperSize) {
		// Fake the LookUpBroker, because it doesn't fire when both a ChangeHandler and LookUpHandler are defined.
		if ((!PaperSize_LookUp)&&(objPaperSize.value != "")) {
		//alert("fake broker for Paper Size");
				for (var j=0; j<aryPaperSize.length; j++) {
				if ((objPaperSize.value.toUpperCase()==aryPaperSize[j].code.toUpperCase())||(objPaperSize.value.toUpperCase()==aryPaperSize[j].desc.toUpperCase())) {
					objhiddenPaperSize.value=aryPaperSize[j].storedval;
					objPaperSize.value=aryPaperSize[j].desc;
					PaperSize_LookUp=1;
				}
			}
		}

		PaperSize_ChangeHandler=1;
		if ((!PaperSize_LookUp)&&(objPaperSize.value!="")) PaperSizeLookUp("");

		if (objWidth) {
			objWidth.disabled = ((objhiddenPaperSize.value != "Custom") && (objPaperSize.value != ""));
		}
		if (objHeight) {
			objHeight.disabled = ((objhiddenPaperSize.value != "Custom") && (objPaperSize.value != ""));
		}
		if (objPaperSize.value=="") {
			objhiddenPaperSize.value="";
			objhiddenWidth.value="";
			if (objWidth) objWidth.value="";
			objhiddenHeight.value="";
			if (objHeight) objHeight.value="";
		}
		if (objhiddenPaperSize.value == "A4") {
			objhiddenWidth.value=21;
			if (objWidth) objWidth.value=21;
			objhiddenHeight.value=29.7;
			if (objHeight) objHeight.value=29.7;
		}
		if (objhiddenPaperSize.value == "Letter") {
			objhiddenWidth.value=21.59;
			if (objWidth) objWidth.value=21.59;
			objhiddenHeight.value=27.94;
			if (objHeight) objHeight.value=27.94;
		}
		if (objhiddenPaperSize.value == "Custom") {
			objhiddenWidth.value=21;
			if (objWidth) objWidth.value=21;
			objhiddenHeight.value=21;
			if (objHeight) objHeight.value=21;
		}
	}

	PaperSize_ChangeHandler=0;
	PaperSize_LookUp=0;

}

function PixelTypeChangeHandler() {
	// When Pixel Type is changed, it affects what can be set in the file type field

	//alert("PixelTypeChange");
	var objPixelType = document.getElementById('sPixelType');
	var objFileType = document.getElementById('sFileType');

	if (objPixelType) {
		// Fake the LookUpBroker, because it doesn't fire when both a ChangeHandler and LookUpHandler are defined.
		//alert("fake broker for Pixel Type");
		if ((!PixelType_LookUp)&&(objPixelType.value != "")) {
			for (var j=0; j<aryPixelType.length; j++) {
				if ((objPixelType.value.toUpperCase()==aryPixelType[j].code.toUpperCase())||(objPixelType.value.toUpperCase()==aryPixelType[j].desc.toUpperCase())) {
					objhiddenPixelType.value=aryPixelType[j].storedval;
					objPixelType.value=aryPixelType[j].desc;
					PixelType_LookUp=1;
				}
			}
		}

		PixelType_ChangeHandler=1;
		if ((!PixelType_LookUp)&&(objPixelType.value!="")) PixelTypeLookUp("");

		if ((objPixelType)&&(objPixelType.value=="")) {
			objhiddenPixelType.value="";
		}

	/* JPG File Type can now handle Black and White Pixel Type.
	if ((objhiddenPixelType.value == "0")&&(objhiddenFileType.value == "JPG")) {
		objhiddenFileType.value="TIF";
		if (objFileType) {
			for (var j=0; j<aryFileType.length; j++) {
				if (aryFileType[j].storedval.toUpperCase()=="TIF") {
					objFileType.value=aryFileType[j].desc;
				}
			}
		}
	}
	*/

		if ((objhiddenPixelType.value == "2")&&(objhiddenFileType.value == "GIF")) {
			objhiddenFileType.value="TIF";
			if (objFileType) {
				for (var j=0; j<aryFileType.length; j++) {
					if (aryFileType[j].storedval.toUpperCase()=="TIF") {
						objFileType.value=aryFileType[j].desc;
					}
				}
			}
		}
	}

	PixelType_ChangeHandler=0;
	PixelType_LookUp=0;

}

function FileTypeChangeHandler() {
	// When File Type is changed, it affects what can be set for file quality and MultiPage

//alert("FileTypeChange");

	var objFileType = document.getElementById('sFileType');
	var objFileQuality = document.getElementById('iFileQuality');
	var objMultiPage = document.getElementById('bMultiPage');
	var objPixelType = document.getElementById('sPixelType');

	// Fake the LookUpBroker, because it doesn't fire when both a ChangeHandler and LookUpHandler are defined.
	if (objFileType) {
	if ((!FileType_LookUp)&&(objFileType.value != "")) {
//alert("fake broker for File Type");
		for (var j=0; j<aryFileType.length; j++) {
			if ((objFileType.value.toUpperCase()==aryFileType[j].code.toUpperCase())||(objFileType.value.toUpperCase()==aryFileType[j].desc.toUpperCase())) {
				objhiddenFileType.value=aryFileType[j].storedval;
				objFileType.value=aryFileType[j].desc;
				FileType_LookUp=1;
			}
		}
	}
	FileType_ChangeHandler=1;
	if ((!FileType_LookUp)&&(objFileType.value!="")) FileTypeLookUp("");

	if ((objFileType)&&(objFileType.value=="")) {
		objhiddenFileType.value="";
	}
	if (objFileQuality) {
		if (objhiddenFileType.value!="JPG") objFileQuality.value="";
		objFileQuality.disabled = (objhiddenFileType.value!="JPG");
		if (objFileQuality.disabled) {
			objFileQuality.className = "disabledField";
		} else {
			objFileQuality.className = "";
		}
	}
	if (objMultiPage) {
		if (objhiddenFileType.value!="TIF") objMultiPage.checked=false;
		objMultiPage.disabled = (objhiddenFileType.value!="TIF");
	}

	if ((objhiddenPixelType.value == "2")&&(objhiddenFileType.value == "GIF")) {
		objhiddenPixelType.value="1";
		if (objPixelType) {
			for (var j=0; j<aryPixelType.length; j++) {
				if (aryPixelType[j].storedval=="1") {
					objPixelType.value=aryPixelType[j].desc;
				}
			}
		}
	}

	}
	FileType_ChangeHandler=0;
	FileType_LookUp=0;

}

function WidthBlurHandler() {
	// function only called when object exists and the field is left.
	var objWidth = document.getElementById('iWidth');

	var val=objWidth.value;
	val=parseFloat(val);
//	if ((val=="")||(isNaN(val))) val=21.0;
	if ((val=="")||(isNaN(val))) val="";
	objhiddenWidth.value=val;
	objWidth.value=val;
}

function HeightBlurHandler() {
	// function only called when object exists and the field is left.
	var objHeight = document.getElementById('iHeight');

	var val=objHeight.value;
	val=parseFloat(val);
//	if ((val=="")||(isNaN(val))) val=21.0;
	if ((val=="")||(isNaN(val))) val="";
	objhiddenHeight.value=val;
	objHeight.value=val;
}

function DPIBlurHandler() {
	// function only called when object exists and the field is left.
	var objDPI = document.getElementById('iDPI');
	var val=objDPI.value;
	if (!(isNaN(val))) {
		objDPI.className="";
	}
	val=parseInt(val);
	if ((val=="")||(val<100)||(val>3600)||(isNaN(val))) val=100;
	objDPI.value=val;
}

function FileQualityBlurHandler() {
	// function only called when object exists and the field is left.
	var objFileQuality = document.getElementById('iFileQuality');
	var val=objFileQuality.value;
	if (!(isNaN(val))) {
		objFileQuality.className="";
	}
	val=parseInt(val);
	if ((val=="")||(val<50)||(val>100)||(isNaN(val))) val=50;
	objFileQuality.value=val;
}


function aryRecord(storedval,code,desc) {

//alert("Record : " + storedval + " * " + code + " * " + desc);

	this.storedval=storedval;
	this.code=code;
	this.desc=desc;
}


// Function fired by the lookup of item sPaperSize on the component.
function PaperSizeLookUp(str) {

//alert("PaperSizeLookUp");
//alert(str);

	var objPaperSize = document.getElementById('sPaperSize');

	// str is desc^storedval^code^
	var lu = str.split("^");
	if (lu[0]) if (objPaperSize) objPaperSize.value=lu[0];
	if (lu[1]) objhiddenPaperSize.value=lu[1];

	PaperSize_LookUp=1;
	if (!PaperSize_ChangeHandler) PaperSizeChangeHandler();

	PaperSize_LookUp=0;

}

// Function fired by the lookup of item sPixelType on the component.
function PixelTypeLookUp(str) {

//alert("PixelTypeLookUp");
//alert(str);

	var objPixelType = document.getElementById('sPixelType');

	// str is desc^storedval^code^
	var lu = str.split("^");
	if (lu[0]) if (objPixelType) objPixelType.value=lu[0];
	if (lu[1]) objhiddenPixelType.value=lu[1];

	PixelType_LookUp=1;
	if (!PixelType_ChangeHandler) PixelTypeChangeHandler();

	PixelType_LookUp=0;

}

// Function fired by the lookup of item sFileType on the component.
function FileTypeLookUp(str) {

//alert("FileTypeLookUp");
//alert(str);

	var objFileType = document.getElementById('sFileType');

	// str is desc^storedval^code^
	var lu = str.split("^");
	if (lu[0]) if (objFileType) objFileType.value=lu[0];
	if (lu[1]) objhiddenFileType.value=lu[1];

	FileType_LookUp=1;
	if (!FileType_ChangeHandler) FileTypeChangeHandler();

	FileType_LookUp=0;

}

// We don't want to overwrite the BodyLoadHandler in the .csp, so call the "BodyLoadHandler" from the Init function, at top.
//document.body.onload=BodyLoadHandler;

