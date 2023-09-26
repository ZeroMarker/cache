// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var objY1Type=document.getElementById('GRPHY1AxisType');
var objY1Profile=document.getElementById('GRPHY1AxisProfile');
var objY1ProfileLUIcon=document.getElementById('ld432iGRPHY1AxisProfile');
var objY2Type=document.getElementById('GRPHY2AxisType');
var objY2Profile=document.getElementById('GRPHY2AxisProfile');
var objY2ProfileLUIcon=document.getElementById('ld432iGRPHY2AxisProfile');

function BodyLoadHandler() {
	if (objY1Type) {
	  objY1Type.onchange=AxisType1FieldHandler;
	  AxisType1FieldHandler(); //to initialise field
	}
	if (objY2Type) {
	  objY2Type.onchange=AxisType2FieldHandler;
	  AxisType2FieldHandler(); //to initialise field
	}
}

function AxisType1LookUpSelect() {
	AxisType1FieldHandler();
}

function AxisType2LookUpSelect() {
	AxisType2FieldHandler();
}

function AxisType1FieldHandler() {
	//alert(objY1Type.value)
	if ((objY1Type.value=="")&&(objY1Profile)) {
	  //Disable Y1 Profile field and lookup
	  objY1Profile.value="";
	  objY1Profile.disabled=true;
	  objY1Profile.className = "disabledField";
	  if (objY1ProfileLUIcon) objY1ProfileLUIcon.onclick='';
	} else {
	  //Enable Y1 Profile field and lookup
	  objY1Profile.disabled=false;
	  objY1Profile.className = "";
	  if (objY1ProfileLUIcon) objY1ProfileLUIcon.onclick=GRPHY1AxisProfile_lookuphandler;
	}
}

function AxisType2FieldHandler() {
	//alert(objY2Type.value)
	if ((objY2Type.value=="")&&(objY2Profile)) {
	  //Disable Y2 Profile field and lookup
	  objY2Profile.value="";
	  objY2Profile.disabled=true;
	  objY2Profile.className = "disabledField";
	  if (objY2ProfileLUIcon) objY2ProfileLUIcon.onclick='';
	} else {
	  //Enable Y2 Profile field and lookup
	  objY2Profile.disabled=false;
	  objY2Profile.className = "";
	  if (objY2ProfileLUIcon) objY2ProfileLUIcon.onclick=GRPHY2AxisProfile_lookuphandler;
	}
}

document.body.onload=BodyLoadHandler;
