// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. w6.50

var origcode="";
var tcistatus=""
dateobj=document.getElementById("WLEffectiveRemovalDate");
var CustomStatus="zz"

function BodyLoadHandler() {

	var obj;
	//SA 25.5.02 - fixed log 25366
	obj=document.getElementById("READesc");
	if (obj) {
		origcode=obj.onchange; //copy the existing handler
		obj.onchange=ReasonChangeHandler; // set the new handler
	}
	objWLStatus=document.getElementById("StatusNow");
	apptobj=document.getElementById("apptpresent");
	var apptpresent=0
	if (apptobj) apptpresent=apptobj.value
	TCIStat=document.getElementById("TCIStatus");
	cdateobj=document.getElementById("cWLEffectiveRemovalDate");
	obj=document.getElementById("ActiveTCIDate");
	if (obj) {
		// RQG 17.12.02 - Log31240: Disable fields if WLStatus is "Done"
		if ( (obj.value=="") && ( ((objWLStatus.value!="D")&&(apptpresent!=1))||( (objWLStatus.value==CustomStatus) && (TCIStat.value=="") ) ) ) {
		//if (obj.value=="") {
			if (cdateobj) cdateobj.className="clsRequired";
		} else {		
			DisableField("newStatus");
			var obj=document.getElementById("ld1159inewStatus");
			if ((obj)) obj.style.visibility = "hidden";
			var obj=document.getElementById("newStatus");
			if (obj) obj.onkeydown='';
			DisableField("WLRGDesc");
			DisableField("READesc");
			DisableField("WLEffectiveRemovalDate");

			var obj=document.getElementById("ld1159iWLRGDesc");
			if ((obj)) obj.style.visibility = "hidden";
			var obj=document.getElementById("WLRGDesc");
			if (obj) obj.onkeydown='';
		
			var obj=document.getElementById("ld1159iREADesc");
			if ((obj)) obj.style.visibility = "hidden";
			var obj=document.getElementById("READesc");
			if (obj) obj.onkeydown='';

			// need to take of required field for date
			if (cdateobj) cdateobj.className="";
		}
	}
	//var uobj=document.getElementById("Update1")
	//if (uobj) uobj.onclick=UpdateClickHandler;
	if (dateobj) dateobj.onchange=DateChangeHandler;
}

function ReasonLookup(str) {
	//alert("str="+str);
 	var lu = str.split("^");
	var obj;
	obj=document.getElementById("READesc")
	if (obj) obj.value = lu[0]
	obj=document.getElementById("WLRGDesc")
	if (obj) obj.value = lu[2]
	//rqg,log24528
	obj=document.getElementById("ReasonCode")
	if (obj) obj.value = lu[1];
	TransDestHandler();
}

function NewStatusLookup(str) {
 	var lu = str.split("^");
	//alert(lu[0]+", "+lu[1]);
	var obj;
	obj=document.getElementById("newStatus")
	if (obj) obj.value = lu[0]
	obj=document.getElementById("remove")
	if (obj) obj.value = lu[1]
}

function InitatorLookUp(str) {

 	var lu = str.split("^");
	var obj;
	obj=document.getElementById("WLRGDesc")
	if (obj) obj.value = lu[0]
	obj=document.getElementById("READesc")
	if (obj) obj.value = ""
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
function DisableField(fldName) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if ((fld)&&(fld.tagName=="INPUT")) {
		fld.value = "";
		fld.disabled = true;
		fld.className = "disabledField";
		if (lbl) lbl = lbl.className = "";
	}
}


function labelMandatory(fld) {
	var lbl = document.getElementById('c' + fld) 
	if (lbl) {
		lbl=lbl.className = "clsRequired";
	}
}

function labelNormal(fld) {
	var lbl = document.getElementById('c' + fld) 
	if (lbl) {
		lbl=lbl.className = "";
	}
} 


//SA 25.5.02 - fixed log 25366
function ReasonChangeHandler() {
      if (typeof origcode!="function") origcode=new Function(origcode);
      //call the function i.e. the original handler
      if (origcode()==false) return false;

      //this could probably be rewritten as follows
     	//return origcode();

	obj=document.getElementById("READesc")
	if ((obj) && (obj.value=="")) {
		obj=document.getElementById("WLRGDesc")
		if (obj) obj.value ='';
	}
}

//KK 27/May/2002 Log 25366
function READesc_ChangeHandler(encmeth) {
	obj=document.getElementById("READesc")
	if ((obj) && (obj.value=="")) {
		obj=document.getElementById("WLRGDesc")
		if (obj) obj.value ='';
	}	
}

//rqg,log24528
function TransDestHandler() {
	//dummy
}

//function BodyUnloadHandler(e) {
//	
//	if (window.opener) {
//		window.close()	
//		window.opener.location.reload(true);	
//	}
//}


function DateChangeHandler(e) {
	WLEffectiveRemovalDate_changehandler(e);
	//GR log 32725
	if (dateobj) {
		var wldate=SplitDateStr(dateobj.value);	
		var today,todaystr,wldatestr
		objtoday=document.getElementById('DateToday');
		if (objtoday) {	today=SplitDateStr(objtoday.value); }
		if (wldate!="") wldatestr=new Date(wldate["yr"], wldate["mn"]-1, wldate["dy"]);
		if (today!="") todaystr=new Date(today["yr"], today["mn"]-1, today["dy"]);
		if (wldatestr>todaystr) {
			alert(t['WLFUTUREDATE_ERR']);
			dateobj.value="";
		}
	}
}
function SplitDateStr(strDate) {
 	var arrDateComponents = new Array(3);
 	var arrDate = strDate.split(dtseparator);
 	switch (dtformat) {
  	case "YMD":
   	arrDateComponents["yr"] = arrDate[0];
   	arrDateComponents["mn"] = arrDate[1];
   	arrDateComponents["dy"] = arrDate[2];
   	break;
  	case "MDY":
   	arrDateComponents["yr"] = arrDate[2];
   	arrDateComponents["mn"] = arrDate[0];
   	arrDateComponents["dy"] = arrDate[1];
   	break;
  	default:
   	arrDateComponents["yr"] = arrDate[2];
   	arrDateComponents["mn"] = arrDate[1];
   	arrDateComponents["dy"] = arrDate[0];
   	break;
 	}
 	return arrDateComponents;
}

//document.body.onunload=BodyUnloadHandler;

//document.body.onload=Init
document.body.onload=BodyLoadHandler;
//document.body.onunload=BodyUnloadHandler;







