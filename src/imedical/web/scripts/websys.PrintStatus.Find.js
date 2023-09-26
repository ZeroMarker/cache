function StatusLookUpSelect(str) {
	var lu = str.split("^");
	var el = document.getElementById("Status");
	if (el) el.value = lu[0];
	var el = document.getElementById("StatusID");
	if (el) el.value = lu[2];
}

function FindHandler(e){

	var Status=""; var SearchDesc=""; var DateFrom=""; var BatchOnly="";
	var DateTo=""; var Computer=""; var Printer=""; var User="";
	var Report=""; var DSN=""; var Location=""; var Hospital="";

	var objStatus=document.getElementById("Status");
	var objStatusID=document.getElementById("StatusID");
	var objSearchDesc=document.getElementById("SearchDesc");
	var objDateFrom=document.getElementById("DateFrom");
	var objBatchOnly=document.getElementById("BatchOnly");
	var objDateTo=document.getElementById("DateTo");
	var objComputer=document.getElementById("Computer");
	var objPrinter=document.getElementById("Printer");
	var objUser=document.getElementById("User");
	var objReport=document.getElementById("Report");
	var objDSN=document.getElementById("DSN");
	var objLocation=document.getElementById("Location");
	var objHospital=document.getElementById("Hospital");

	// Log 58510 - AI - 27-03-2006 : Change Handler to blank out StatusID if Status is blanked out.
	if ((objStatus) && (objStatusID)) {
		if (objStatus.value=="") {
			objStatusID.value="";
		}
	}
	// end Log 58510

	var component = "websys.PrintStatus.ListAll";
	if (objStatusID){
		Status=objStatus.value;
		if (objStatusID.value == "W") component = "websys.PrintStatus.ListWait";
		if (objStatusID.value == "I") component = "websys.PrintStatus.ListInProgress";
		if (objStatusID.value == "P") component = "websys.PrintStatus.ListPrinted";
		if (objStatusID.value == "E") component = "websys.PrintStatus.ListError";
		//rqg,Log28787: Add new component for deferred status
		if (objStatusID.value == "D") component = "websys.PrintStatus.ListDeferred";
	}

	if (objBatchOnly) {
		if (objBatchOnly.checked) {
			BatchOnly=1;  //value=On
		} else {
			BatchOnly=0;  //value=Off
		}

		if (BatchOnly==1) {
			component = "websys.PrintStatus.ListBatSummary";
		}
	}

	if (objSearchDesc) SearchDesc=objSearchDesc.value;

	// SA 12.6.03 - log 36397: Ampersands is search descriptions were not being picked up by query code
	// escape function below converts "&" to ascii.
	SearchDesc = escape(SearchDesc);

	if ((objDateFrom)&&(objDateFrom.value!="")) {
		if (!IsValidDate(objDateFrom)) {
			objDateFrom.className='clsInvalid';
			websys_setfocus('DateFrom');
			return  websys_cancel();
		} else {
			objDateFrom.className='';
		}
		DateFrom=objDateFrom.value;
	}
	if ((objDateTo)&&(objDateTo.value!="")) {
		if (!IsValidDate(objDateTo)) {
			objDateTo.className='clsInvalid';
			websys_setfocus('DateTo');
			return  websys_cancel();
		} else {
			objDateTo.className='';
		}
		DateTo=objDateTo.value;

		if ((objDateFrom)&&(objDateFrom.value!="")) {

			var fromdt=SplitDateStr(objDateFrom.value)
			var todt=SplitDateStr(objDateTo.value)
			var dtto=new Date(todt["yr"], todt["mn"]-1, todt["dy"]);
			var dtfrom=new Date(fromdt["yr"], fromdt["mn"]-1, fromdt["dy"]);
			if (dtto< dtfrom) {
				alert(t['DATE_RANGE_INVALID']);
				objDateFrom.className='clsInvalid';
				websys_setfocus('DateFrom');
				return false;
			}
		}
	}
	if (objComputer) Computer=objComputer.value;
	if (objPrinter) Printer=objPrinter.value;
	Printer = escape(Printer); // SA 12.6.03 - log 36397: See note above
	if (objUser) User=objUser.value;
	if (objReport) Report=objReport.value;
	Report = escape(Report); // SA 12.6.03 - log 36397: See note above
	if (objDSN) DSN=objDSN.value;
	if (objLocation) Location=objLocation.value;
	Location = escape(Location); // SA 12.6.03 - log 36397: See note above
	if (objHospital) Hospital=objHospital.value;
	Hospital = escape(Hospital);

	var str = "&Status="+Status+"&SearchDesc="+SearchDesc+"&DateFrom="+DateFrom+"&BatchOnly="+BatchOnly;
	str += "&DateTo="+DateTo+"&Computer="+Computer+"&Printer="+Printer+"&User="+User;
	str += "&Report="+Report+"&DSN="+DSN+"&Location="+Location+"&Hospital="+Hospital;
	window.open("websys.default.csp?WEBSYS.TCOMPONENT="+component+str,"PrintList","");
	return false;
}

function docLoadHandler() {
	var obj = document.getElementById("find");
	if (obj) obj.onclick=FindHandler;
	if (tsc['find']) websys_sckeys[tsc['find']]=FindHandler;
	EnableForPrintSecurityLevel();
}

function EnableForPrintSecurityLevel() {

	// SA 15.11.02 - log 28790: The Print History search will be restricted depending the
	// the SSUSRPrintSecurityLevel field against SSUser. This field can have 4 values:
	// - S/System => Display ALL Print History entries
	// - D/Department => Display only Print History entries associated with the user's logon location
	// - U/User => Display only Print History entries printed by the user
	// - ""/Blank => defaults to U/User level
	// In the case of U/D, user/location fields will be defaulted to the respective
	// logon usercode/location and become disabled.

	var PrintSecLevel=""
	var objSSUSRPrintSecurityLevel=document.getElementById("SSUSRPrintSecurityLevel");
	var objLogonUserCode=document.getElementById("LogonUserCode");
	var objLogonLocationDesc=document.getElementById("LogonLocationDesc");
	var objUser=document.getElementById("User");
	var objLocation=document.getElementById("Location");
	var objUserLU=document.getElementById("ld1253iUser");
	var objLocationLU=document.getElementById("ld1253iLocation");
	var objHospitalLU=document.getElementById("ld1253iHospital");

	if (objSSUSRPrintSecurityLevel) PrintSecLevel=objSSUSRPrintSecurityLevel.value

	if (PrintSecLevel=="D") {
		if ((objLogonLocationDesc)&&(objLocation)) {
			objLocation.value=objLogonLocationDesc.value
			objLocation.disabled = true;
			objLocation.className = "disabledField";
			if (objLocationLU) objLocationLU.style.visibility = "hidden"
			if (objHospital) {
				objHospital.disabled = true;
				objHospital.className = "disabledField";
				if (objHospitalLU) objHospitalLU.style.visibility = "hidden"
			}
		}
	} else if (PrintSecLevel=="S") {
		// no defaults or disabling
	} else {
		if ((objLogonUserCode)&&(objUser)) {
			objUser.value=objLogonUserCode.value
			objUser.disabled = true;
			objUser.className = "disabledField";
			if (objUserLU) objUserLU.style.visibility = "hidden"
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

function HospitalLookUpHandler(str) {
	var objLocation=document.getElementById("Location");
	if (objLocation) objLocation.value="";
}

document.body.onload=docLoadHandler;

