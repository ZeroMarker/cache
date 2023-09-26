// Copyright (c) 2000 TRAK Systems Pty. ALL RIGHTS RESERVED. 


function BodyLoadHandler() {

	//window.focus();

	var objParFrmTrakMain=parent.frames["TRAK_main"];	
	var objValPAAdmCodingID=document.getElementById("ValPAAdmCodingID");	
	var objValidationStatus=document.getElementById("ValidationStatus");

	if (objParFrmTrakMain) {
		// SA 5.9.02 - log 27303: Site has requested that the coding list be refreshed 
		// after Medicode is complete. This will happen regardless of the status returned
		// by Medicode.
		objParFrmTrakMain.treload('websys.csp');
	}

	// SA 5.9.02 - log 27303: SMR Validation (including McKesson UDF) will be called after Medicode
	// update, and the SMR val status is set. If the val status is E,Q, or EQ - the coding id
	// will be set to the hidden field ValPAAdmCodingID, from the update.
	// If a coding id exists, open window.
	if ((objValPAAdmCodingID)&&(objValPAAdmCodingID.value!="")) {

		// SA 16.1.03 - log 31812: If this window has previously been called, and validation made,
		// the refresh will subsequently reload this screen. Now need to check the new validation status
		// and if it is no longer E,Q or EQ - we will quit here altogether
		if (objValidationStatus) {

			//alert("objValidationStatus.value="+objValidationStatus.value);
		
			if ((objValidationStatus.value=="E")||(objValidationStatus.value=="Q")||(objValidationStatus.value=="EQ")) {
				var bShowList="";
				bShowList=confirm(t['COD_ERR_QUERY']+"\n"+t['Q_VIEW_LIST']);
				if (bShowList) {
					var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=PACodingErrors.List&AdmCoding="+objValPAAdmCodingID.value;
					websys_createWindow(lnk,"CodErrList","left=40,top=40,height=400,width=500,scrollbars=auto,resizable=yes");
		
					//websys_windows["CodErrList"].focus();
				}

				//alert("objValPAAdmCodingID.value="+objValPAAdmCodingID.value);
			}
		}
	}

}

document.body.onload=BodyLoadHandler;