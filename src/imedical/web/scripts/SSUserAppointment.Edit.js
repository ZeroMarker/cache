//Copyright (c) 2002 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

//ert("js loaded");

function BodyLoadHandler(){
	//alert("SSUserAppointment.Edit.js BodyLoadHandler called")

	var objUpdateAndAdd=document.getElementById("UpdateAndAdd")
	if (objUpdateAndAdd) objUpdateAndAdd.onclick=UpdateAndAddOnClickHandler;
	var objUpdCPAdd=document.getElementById("UpdCPAdd")
	if (objUpdCPAdd) objUpdCPAdd.onclick=UpdateAndLoadCareProvAddr;
	var objCareProvID=document.getElementById("CareProvID")
	if (objCareProvID) {	
		var objUpdCPAdd=document.getElementById("UpdCPAdd");
		if ((objUpdCPAdd)&&(objCareProvID.value=="")) {	
			objUpdCPAdd.disabled=true ;
			objUpdCPAdd.onclick=UpdCPAddClickHandler;
		}
	}
	//rqg,Log23316
	var objUpdate=document.getElementById("update1")
	if (objUpdate) objUpdate.onclick=UpdateClickHandler;

}


function UpdateAndAddOnClickHandler() {
	// SA 12.7.02 - log 23316.
	//alert("hello")

	var SSUserID="";
	var CareProvID="";
	var PARREF="";
	var CONTEXT=session['CONTEXT'];

	var objSSUserID=document.getElementById("SSUserID");
	var objCareProvID=document.getElementById("CareProvID");
	var objPARREF=document.getElementById("PARREF");
	if (objSSUserID) SSUserID=objSSUserID.value;
	if (objCareProvID) CareProvID=objCareProvID.value;
	if (objPARREF) PARREF=objPARREF.value;
	//alert("hello2");

	//rqg,Log23316
	if (!CompareTwoDates('APPTDateFrom','APPTDateTo',t['APPTDATE_ERROR'])) return false;
	//var url="ssuserappointment.csp?SSUserID="+SSUserID+"&CareProvID="+CareProvID+"&PARREF="+PARREF+"&TWKFL="+TWKFL+"&TWKFLI="+TWKFLI+"&CONTEXT="+CONTEXT;
	var url="ssuserappointment.csp?SSUserID="+SSUserID+"&CareProvID="+CareProvID+"&PARREF="+PARREF+"&CONTEXT="+CONTEXT;

	//alert("hello3");
	//alert(url);
	var frm=document.forms["fSSUserAppointment_Edit"];
	if (frm) {
		frm.target="TRAK_hidden";
		UpdateAndAdd_click();
	}
	websys_createWindow(url,"TRAK_main");
	return false;
}

function UpdateAndLoadCareProvAddr() {
	// SA 12.7.02 - log 23316.
	//alert("hello")

	var SSUserID="";
	var CareProvID="";
	var PARREF="";
	var CONTEXT=session['CONTEXT'];

	var objTWKFL=document.getElementById('TWKFL');
	var objTWKFLI=document.getElementById('TWKFLI');
	var TWKFL="";
	var TWKFLI="";
	if (objTWKFL) TWKFL=objTWKFL.value;
	if (objTWKFLI) TWKFLI=new Number(objTWKFLI.value) + 1;
	var NewTWKFLI=TWKFLI;
	//alert("CP1: objTWKFL="+TWKFL+ " objTWKFLI="+TWKFLI);

	var objCareProvID=document.getElementById("CareProvID");
	var objSSUserID=document.getElementById("SSUserID");

	if (objSSUserID) SSUserID=objSSUserID.value;
	if (objCareProvID) CareProvID=objCareProvID.value;
	//alert("Appt3: objTWKFL="+TWKFL+ " objTWKFLI="+TWKFLI);
	PARREF=CareProvID;

	//rqg,Log23316
	if (!CompareTwoDates('APPTDateFrom','APPTDateTo',t['APPTDATE_ERROR'])) return false;
	
	var url="ctcareprovaddress.csp?SSUserID="+SSUserID+"&CareProvID="+CareProvID+"&PARREF="+PARREF+"&TWKFL="+TWKFL+"&TWKFLI="+NewTWKFLI+"&CONTEXT="+CONTEXT;
	//var url="ctcareprovaddress.csp?SSUserID="+SSUserID+"&CareProvID="+CareProvID+"&PARREF="+PARREF+"&CONTEXT="+CONTEXT;


	//alert(url);
	var frm=document.forms["fSSUserAppointment_Edit"];
	if (frm) {
		frm.target="TRAK_hidden";
		UpdCPAdd_click();
	}
	var AppTitle=document.getElementById("USAPTLDesc");
	if ((AppTitle) && (AppTitle.value!="")) websys_createWindow(url,"TRAK_main");
	return false;
}

function UpdCPAddClickHandler() {
	//GR 31/7/02
	var objUpdCPAdd=document.getElementById("UpdCPAdd");
	if (objUpdCPAdd) {
		if (objUpdCPAdd.disabled!=true) { UpdCPAdd_click() }
	}
}

//rqg,log23316
function UpdateClickHandler() {
	if (!CompareTwoDates('APPTDateFrom','APPTDateTo',t['APPTDATE_ERROR'])) return false;
	return update1_click();
}

function CompareTwoDates(date1,date2,msg) {
	var obj1=document.getElementById(date1);
	var obj2=document.getElementById(date2);
	if ((!obj1)||(!obj2)||(obj1.value == '')||(obj2.value == '')) return true;
	var arrDate1 = SplitDateStr(obj1.value);
	var arrDate2 = SplitDateStr(obj2.value);
	var dt1 = new Date(arrDate1["yr"], arrDate1["mn"]-1, arrDate1["dy"]);
	var dt2 = new Date(arrDate2["yr"], arrDate2["mn"]-1, arrDate2["dy"]);
 	if (dt1 > dt2) {
		alert(msg);
		websys_setfocus(date1);
		return false;
	}
	return true;
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
document.body.onload=BodyLoadHandler;
