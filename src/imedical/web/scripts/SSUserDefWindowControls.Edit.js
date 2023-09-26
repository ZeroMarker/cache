// Copyright (c) 2006 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
// ab 4.05.06 52166

var CONT_CLICK="";
var obj=document.getElementById("ControlResp");
if (obj) CONT_CLICK=obj.onclick;

function BodyLoadHandler(e) {
	
	EnableDisableFields();
	SetBoldLink();
	
	var obj=document.getElementById("CONControlType");
	if (obj) obj.onblur=CONControlTypeBlurHandler;
	
	// if control has been generated, disable these fields
	var obj=document.getElementById("CONGenerated");
	if ((obj)&&(obj.value=="Y")) {
		var obj=document.getElementById("CONCode");
		if (obj) obj.disabled=true;
		var obj=document.getElementById("CONControlType");
		if (obj) {
			obj.disabled=true;
			DisableLookup("ld2192iCONControlType");
		}
		var obj=document.getElementById("CONCodeTable");
		if (obj) {
			obj.disabled=true;
			DisableLookup("ld2192iCONCodeTable");
		}
		var obj=document.getElementById("delete1");
		if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}
		var obj=document.getElementById("ITMDesc");
		if (obj) {
			obj.disabled=true;
			DisableLookup("ld2192iITMDesc");
		}
		
		// ab 19.09.06 60995
		/*var obj=document.getElementById("CONCalculation");
		if (obj) {
			obj.disabled=true;
		}
		*/
		// ab 29.08.06 60717
		var obj=document.getElementById("CONScore");
		if (obj) {
			obj.disabled=true;
		}
		var obj=document.getElementById("PICDesc");
		if (obj) {
			obj.disabled=true;
			DisableLookup("ld2192iPICDesc");
		}
	}
	var objID=document.getElementById("ID");
	var objRepeat=document.getElementById("repeat1");
	if (objRepeat) {
		if ((objID)&&(objID.value!="")) {
			objRepeat.disabled=true;
			objRepeat.onclick="";
		}
		objRepeat.onclick = RepeatClickHandler;
	}
	var objSave=document.getElementById("save1");
	if (objSave) objSave.onclick=SaveClickHandler;
	if ((objSave)&&(objID)&&(objID.value!="") ) {
		objSave.disabled=true;
		objSave.onclick="";
	}
	var obj=document.getElementById("update1");
	if (obj) {
		obj.onclick=OnUpdate;
		if (tsc['update1']) websys_sckeys[tsc['update1']]=OnUpdate;
	}	
	//bring me to front, in case of websys_reload error
	document.focus();
	
	CheckLocked();
	
	var TotalControls = document.getElementById('TotalControls');
	if (TotalControls.value>328) {
		var objRepeat=document.getElementById("repeat1");
		if (objRepeat) {
			objRepeat.disabled=true;
			objRepeat.onclick="";
		}
	}
	
	// Log 62559 YC - If invalid code is changed, remove the clsInvalid
	var obj=document.getElementById("CONCode");
	if (obj) {
		if (obj.className=="clsInvalid") obj.onchange=ClearInvalid;
	}
}

function ClearInvalid() {
	var obj=document.getElementById("CONCode");
	if (obj) obj.className="";
}

// ab 10.08.06 60241
function CheckLocked() {
	var obj=document.getElementById("ID");
	if ((obj)&&(obj.disabled)) {
		DisableAllFields();
	}
}

function RepeatClickHandler() {
	var objRepeat=document.getElementById("repeat1");
	if ((objRepeat)&&(objRepeat.disabled==true)) {
		return false;
	}
	if (!CheckMandatory()) return false;
	
	if (fSSUserDefWindowControls_Edit_submit()) {
	// Causes the list to be always one behind so lets get rid of this
	//	window.opener.treload('ssuserdefwindow.frame.csp');
		return repeat1_click();
	}
	return false;
}

function SetBoldLink() {
	var objbold=document.getElementById("RespBold");
	var objlink=document.getElementById("ControlResp");
	if ((objbold)&&(objlink)&&(objbold.value==1)) objlink.style.fontWeight="bold";
}

function EnableDisableFields() {
	var type="";
	var obj=document.getElementById("ControlType");
	if (obj) type=obj.value;
	var ID=document.getElementById("ID");
	if (ID) ID=ID.value;
	
	if (type=="") {
		DisableField("CONSignificantLevel");
		DisableLookup("ld2192iCONSignificantLevel");
	} else {
		EnableField("CONSignificantLevel");
		EnableLookup("ld2192iCONSignificantLevel");
	}
	
	if (type!="CodeTable") {
		NormalField("CONCodeTable");
		DisableField("CONCodeTable");
		DisableLookup("ld2192iCONCodeTable");
	} else {
		EnableField("CONCodeTable");
		MandatoryField("CONCodeTable");
		EnableLookup("ld2192iCONCodeTable");
	}

	if (type!="CalcField") {
		NormalField("CONCalculation");
		DisableField("CONCalculation");
		DisableField("CONDecPlaces");
	} else {
		EnableField("CONCalculation");
		MandatoryField("CONCalculation");
		EnableField("CONDecPlaces");
	}
	
	if (type!="ObsItem") {
		NormalField("ITMDesc");
		DisableField("ITMDesc");
		DisableLookup("ld2192iITMDesc");
	} else {
		EnableField("ITMDesc");
		MandatoryField("ITMDesc");
		EnableLookup("ld2192iITMDesc");
	}
	
	if (type!="Image") {
		NormalField("PICDesc");
		DisableField("PICDesc");
		DisableLookup("ld2192iPICDesc");
		EnableField("CONDisplayAnswer");
		EnableField("CONDefaultLastQnAns");
	} else {
		EnableField("PICDesc");
		MandatoryField("PICDesc");
		EnableLookup("ld2192iPICDesc");
		// ab 19.07.06 - 55903
		DisableField("CONDisplayAnswer");
		DisableField("CONDefaultLastQnAns");
	}
	
	/*
	if ((type!="ComboBox")&&(type!="ListBox"))  {
		DisableField("CONComboScores");
		var obj=document.getElementById("CONValues");
		if (obj) {
			obj.disabled=true;
			obj.value="";
			obj.className="clsDisabled";
		}
	} else {
		EnableField("CONComboScores");
		var obj=document.getElementById("CONValues");
		if (obj) {
			obj.disabled=false;
			obj.className="";
		}
	}
	*/
	
	if ((type=="Extended_Combo")||(type=="Extended_ListBox")||(type=="CalcField")||(type=="Image")||(type=="Label")) {
		DisableField("CONScore");
	} else {
		EnableField("CONScore");
	}
	
	// don't allow labels to have significance - as they are not a compiled property
	if ((type=="Image")||(type=="Label")) {
		DisableField("CONSignificantLevel");
		DisableLookup("ld2192iCONSignificantLevel")
	} else {
		EnableField("CONSignificantLevel");
		EnableLookup("ld2192iCONSignificantLevel")
	}
		

	if ((ID=="")||((type!="Extended_Combo")&&(type!="Extended_ListBox")))  {
		var obj=document.getElementById("ControlResp");
		if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}
	} else {
		var obj=document.getElementById("ControlResp");
		if (obj) {
			obj.disabled=false;
			obj.onclick=CONT_CLICK;
		}	
	}
	
}

function CONControlTypeLookup(str) {
	var lu=str.split("^");
	var obj=document.getElementById("ControlType");
	if (obj) obj.value=lu[2];
	EnableDisableFields();
}

function CONControlTypeBlurHandler() {
	var obj=document.getElementById("CONControlType");
	var objid=document.getElementById("ControlType");
	if ((obj)&&(obj.value=="")&&(objid)) {
		objid.value="";
	}
	EnableDisableFields();
}

function MandatoryField(fld) {
	var lbl = document.getElementById('c' + fld)
	if (lbl) {
		lbl.className = "clsRequired";
	}
	var field = document.getElementById(fld)
	if (field) {
		field.className = "clsRequired";
	}
}
function NormalField(fld) {
	var lbl = document.getElementById('c' + fld)
	if (lbl) {
		lbl.className = "";
	}
	var field = document.getElementById(fld)
	if (field) {
		field.className = "";
	}
}

function OnUpdate() {
	if (!CheckMandatory()) return false;
	
	update1_click();
}

function SaveClickHandler() {
	if (!CheckMandatory()) return false;
	
	save1_click();
}

function CheckMandatory() {
	var obj=document.getElementById("ControlType");
	if (obj) type=obj.value;
	
	// check if calculation field required
	var obj=document.getElementById("CONCalculation");
	if ((type=="CalcField")&&(obj)&&(obj.value=="")) {
		alert("\'" +t['CONCalculation']+ "\' " + t['XMISSING']);
		return false;
	}
	
	var obj=document.getElementById("ITMDesc");
	if ((type=="ObsItem")&&(obj)&&(obj.value=="")) {
		alert("\'" +t['ITMDesc']+ "\' " + t['XMISSING']);
		return false;
	}
	
	var obj=document.getElementById("PICDesc");
	if ((type=="Image")&&(obj)&&(obj.value=="")) {
		alert("\'" +t['PICDesc']+ "\' " + t['XMISSING']);
		return false;
	}
	
	var obj=document.getElementById("CONCodeTable");
	if ((obj)&&(obj.className=="clsInvalid")) {
			alert("\'" +t['CONCodeTable']+ "\' " + t['XINVALID']);
		return false;
	}
	if ((type=="CodeTable")&&(obj)&&(obj.value=="")) {
		alert("\'" +t['CONCodeTable']+ "\' " + t['XMISSING']);
		return false;
	}
	
	// Log 62466 YC - checks that decimal places field is a valid integer above 0
	var obj=document.getElementById("CONDecPlaces");
	var objint=parseInt(obj.value);
	if ((obj)&&((obj.className=="clsInvalid")||(objint<0))) {
			obj.className="clsInvalid";
			alert("\'" +t['CONDecPlaces']+ "\' " + t['XINVALID']);
		return false;
	}
	
	return true;
}

document.body.onload = BodyLoadHandler;

