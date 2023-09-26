// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function ARPatBillMultiPatBillFindAll_BillSelectedAdms(lnk,newwin) {
	//alert("SA: Testing Manual Billing Functionality");
	//alert("lnk="+lnk);

	var tbl=document.getElementById("tARPatientBill_MultiPatBillFindAll");
	var PatientID ="";
	var BillsOK   =true;

	var f = document.getElementById("f" + tbl.id.substring(1,tbl.id.length));
	var aryfound = CheckedCheckBoxesOrSelectedRow(f,tbl,"SelectBillz");

	var objContext = document.getElementById("TWKFL");
	if (objContext) {
		var currContext=objContext.value;
	}

	if (aryfound.length==0) {
		alert(t['NO_BILL_SELECTED']);
		return;
	} else {
		// SA 30.5.02 - no log: I have changed the premise aryfound.length to be greater
		// than zero rather than just equal 1. Not sure why it was written for this menu option.
		// The other menu options only allow one bill to be processed at a time, so it is fine
		// there. Please consult me if there are any problems here.
        
		if (aryfound.length > 0) 
		{
			//if (aryfound.length==0) {
			var BillRowIds="";
			var PatientIds="";
			var EpisodeIds="";
			var BillType="";
			var NextBillType="";
			for (var i=0; i<aryfound.length; i++) {
				j = aryfound[i];
				
				BillRowIds   = BillRowIds + f.elements["BillRowIDz"+j].value;
				PatientIds   = PatientIds + f.elements["PatientIDz"+j].value;
				EpisodeIds   = EpisodeIds + f.elements["EpisodeIDz"+j].value;
				NextBillType = f.elements["BillTypez"+j].value;
				

				if (NextBillType=="D") {
					//Deposit lines may not be selected
					alert(t['DEP_ROW_SEL']+" "+t['NO_DEPS_BILL']);
					BillsOK=false;
					return;				
				}
				if (BillType=="") {
					BillType=NextBillType;	
				} else {
					if (BillType!=NextBillType) {
						alert(t['NO_PAT_INS_BILLS']+"\n"+t['ONLY_SAME_BILLS']);
						BillsOK=false;
						return;	
					}
				}
				if (i<aryfound.length-1) {
					BillRowIds=BillRowIds+"|";
					PatientIds=PatientIds+"|";
					EpisodeIds=EpisodeIds+"|";
				}	
			}		
		}

		var objTWKFL  = document.getElementById('TWKFL');
		var objTWKFLI = document.getElementById('TWKFLI');
		var TWKFL=""; var TWKFLI="";
		if (objTWKFL)  TWKFL  = objTWKFL.value;
		if (objTWKFLI) TWKFLI = objTWKFLI.value;

		lnk += "&PageType=Patient" + "&PatientIDs="+PatientIds+"&EpisodeIDs="+EpisodeIds+"&BillRowIDs="+BillRowIds+"&CONTEXT="+session["CONTEXT"]+"&GroupType="+GroupType;
		lnk += "&TWKFL="+TWKFL+"&TWKFLI="+TWKFLI;
	}
	
	//alert(lnk);
	window.location = lnk;
}

