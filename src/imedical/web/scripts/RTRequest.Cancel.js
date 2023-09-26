// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var updated=0;

function UpdateClickHandler() {
	var RDMobj=document.getElementById("ReqDateMandatory");
	var arrDateDiff = new Array(4);
	if((RDMobj)&&(RDMobj.value=="Y")) {
		var RDTobj=document.getElementById("RequestDateTo");	
		if((RDTobj)&&(RDTobj.value=="")){
			alert(t['CANCEL_MAN']);
			return false;
		}
		else {
			var CD=document.getElementById("CurrentDate");
			var RD=document.getElementById("RequestDateTo");

			var res=DateStringCompare(CD.value,RD.value);
			if (res==-1) {
				alert(t['INVALID_CANDATE']);
				return false;
			}
			var SOBJ=document.getElementById("Restrict7Days");
			var arrDateDiff=DateStringDifference(CD.value,RD.value);
			if((arrDateDiff["dy"]>7)&&(SOBJ.value=="Y")) {
				alert(t['INVALID_SEVENDAY']);
				return false;
			}	
			else {updated=1;}

		}
	}
	else {getVolRowIds();}	if (updated) {
		var OKToCancel=confirm(t['CAN_WARNING']+"\n"+t['CONTINUE']);
		if (!OKToCancel) {
			return false;
		}
		return Update_click();
	}
}
function getVolRowIds() {
	var eTABLE=document.getElementById("tRTRequest_Cancel");
	var MasVolID="";
	var ReqVolumeID="";
	var flag=1
	if (eTABLE) {
	for (var i=1; i<eTABLE.rows.length; i++) {
		var SelectObj=document.getElementById("Selectz"+i);
		if (SelectObj.checked) {
			var sobj=document.getElementById("Statusz"+i);
			if (sobj&&sobj.innerText=="X") {
				updated=0;
				flag=0;
				alert(t['AlreadyCancelled']);
				//window.close();

			}
			if (flag) {
				updated=1;
				var MasObj=document.getElementById("MasVolIDz"+i);
				var ReqObj=document.getElementById("ReqVolIDz"+i);
				if ((MasObj)&&(ReqObj)) {
					if (MasVolID=="") {
						MasVolID=MasObj.value;
						ReqVolumeID=ReqObj.value;
					} else {
						MasVolID=MasVolID+"^"+MasObj.value;
						ReqVolumeID=ReqVolumeID+"^"+ReqObj.value;
					}
				}			
			}
		}
	}
	if (flag&&MasVolID=="") {
		alert("Please Select a volume before update.");
	}
	//alert("MasVolID="+MasVolID)
	var MasVolObj=document.getElementById("MasVolIDs");
	if (MasVolObj) MasVolObj.value=MasVolID;
	//alert("ReqVolumeID="+ReqVolumeID);
	var ReqVolObj=document.getElementById("ReqVolumeIDs");
	if (ReqVolObj) ReqVolObj.value=ReqVolumeID;
	}else {updated=1;}
}
function BodyUnloadHandler(e) {
	if ((self == top)&&(updated)) {
		var win=window.opener;
		if (win) {
			win.treload('websys.csp');
		}
	}
}

function BodyLoadHandler(){
	var RDMobj=document.getElementById("ReqDateMandatory");
	if((RDMobj)&&(RDMobj.value=="Y")) EnableField("RequestDateTo");
	else DisableField("RequestDateTo");
	
	if (tsc['Update']) {
		websys_sckeys[tsc['Update']]=UpdateClickHandler;
	}
	
}

function EnterKey(e) {
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	if ((websys_getAlt(e)&&keycode!=18)||(keycode==33)||(keycode==34)) {
		try {	
			var key=String.fromCharCode(keycode);
				//if (key=="D") DeleteClickHandler();
				if (key=="U") UpdateClickHandler();
				//if (key=="A") AddClickHandler();
				//if (key=="F") AddToFavClickHandler();
				//if (key=="O") OrderDetailsClickHandler();				
				//websys_sckeys[key]();
				//websys_cancel();
		}
		//catch and ignore
		catch(e) {}
	}
	
}

document.body.onkeydown=EnterKey;
document.body.onload=BodyLoadHandler;
var uobj=document.getElementById("Update");
if (uobj) uobj.onclick=UpdateClickHandler;
//document.body.onunload=BodyUnloadHandler;
var cobj=document.getElementById("RTREQComments");
if (cobj) cobj.select();

//function UpdateClickHandler() {
///	var currStatus="";
///	var flag=1
//	var sobj=document.getElementById("ReqStatus");
//	if (sobj) {
//		statusAry=sobj.value.split(",");
//		alert("statusAry "+statusAry.length);
//		//currStatus=statusAry[0];
//	}
//
//	if (sobj) {
//		for (var j=1; j<statusAry.length; j++) {
//			currStatus=statusAry[j];
//			if (currStatus=="X") {
//				flag=0;
//				alert(t['AlreadyCancelled']);
//				window.close();
//			}
//		}	
//		 else {
//		if (flag){
//			getVolRowIds();			
//			updated=1;		
//			return Update_click();
//		}
//	}
//}*// */

function DisableField(fldName) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	var icn = document.getElementById('ld1067i'+fldName);
	if ((fld)&&(fld.tagName=="INPUT")) {
		fld.value = "";
		fld.disabled = true;
		if (icn) icn.style.visibility="hidden"
		fld.className = "disabledField";
		if (lbl) lbl = lbl.className = "";
	}
}

function EnableField(fldName) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if (fld) {
		fld.disabled = false;
		fld.className = "";
		if (lbl) lbl = lbl.className = "clsRequired";
	}
}

function VerifyDateformat(obj) {

	var date="";
	date=obj.value;	
	
	var dateArr = date.split(dtseparator);
	
	if(dtformat=="YMD")
	{
		dateArr[1]=dateArr[1]-1;
		date = new Date(dateArr[0],dateArr[1],dateArr[2]);
	}
			
	else if(dtformat=="MDY")
	{
		dateArr[0]=dateArr[0]-1;
		date = new Date(dateArr[2],dateArr[0],dateArr[1]);
	}

	else
	{
		dateArr[1]=dateArr[1]-1;
		date = new Date(dateArr[2],dateArr[1],dateArr[0]);
	}
	
	return date;
}
