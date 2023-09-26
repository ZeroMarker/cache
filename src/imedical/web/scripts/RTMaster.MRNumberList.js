// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 


function SelectRowHandler() {
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var eSrcAry=eSrc.id.split("z");
	var rowObj=getRow(eSrc);
	var row=rowObj.rowIndex;
	// CJB 32430 needed for pamergepatient.editcopyadmission.csp
	var CopyAdmission=top.frames["TRAK_main"].frames['CopyAdmission'];
	if (eSrcAry.length>0) {
		//alert(eSrcAry[0])
		// CJB 32430 needed for pamergepatient.editcopyadmission.csp
		var MRNumberString=CopyAdmission.document.getElementById("MRNumberString");
		var MRNumberInactiveString=CopyAdmission.document.getElementById("MRNumberInactiveString");
		if (eSrcAry[0]=="select"){
			if (CopyAdmission) {
				
				if (MRNumberString) {
					var mrn=document.getElementById("rowidz"+row);
					if (frm.elements["selectz"+row].checked) {
						AddToString(MRNumberString,mrn.value)
						if ((frm.elements["MoveAndInactivatez"+row])&&(MRNumberInactiveString)) {
							frm.elements["MoveAndInactivatez"+row].checked=false
							RemoveFromString1(MRNumberInactiveString,mrn.value)
						}
						//alert(MRNumberString.value);
					} else {
						RemoveFromString(MRNumberString,mrn.value)
						//alert("uncheck "+mrn.value);
					}
				}
			}
		}
		// cjb 13/10/2003 39399
		if (eSrcAry[0]=="MoveAndInactivate"){
			if (CopyAdmission) {
				
				if (MRNumberInactiveString) {
					var mrn=document.getElementById("rowidz"+row);
					if (frm.elements["MoveAndInactivatez"+row].checked) {
						AddToString1(MRNumberInactiveString,mrn.value)
						// cjb if you tick one box, untick the other
						if ((frm.elements["selectz"+row])&&(MRNumberString)) {
							frm.elements["selectz"+row].checked=false
							RemoveFromString(MRNumberString,mrn.value)
						}
						//alert(MRNumberInactiveString.value);
					} else {
						RemoveFromString1(MRNumberInactiveString,mrn.value)
						//alert("uncheck "+mrn.value);
					}
				}
			}
		}
	}
}

function AddToString(MRNumberString,newvar) {
	
	var AlreadyGotIt=0
	var lu = MRNumberString.value.split("^");
	if ((MRNumberString)&&(MRNumberString.value!="")) {
		for (var i=1;i<lu.length;i++) {
			if (lu[i]==newvar) AlreadyGotIt=1;
		}
	}
	
	if (AlreadyGotIt==0) MRNumberString.value=MRNumberString.value+"^"+newvar
	//alert("MRNumberString.value "+MRNumberString.value);
}

function AddToString1(MRNumberInactiveString,newvar) {
	
	var AlreadyGotIt=0
	var lu = MRNumberInactiveString.value.split("^");
	if ((MRNumberInactiveString)&&(MRNumberInactiveString.value!="")) {
		for (var i=1;i<lu.length;i++) {
			if (lu[i]==newvar) AlreadyGotIt=1;
		}
	}
	
	if (AlreadyGotIt==0) MRNumberInactiveString.value=MRNumberInactiveString.value+"^"+newvar
	//alert("MRNumberInactiveString.value "+MRNumberInactiveString.value);
}


function RemoveFromString(MRNumberString,oldvar) {
	
	var lu = MRNumberString.value.split("^");
	if ((MRNumberString)&&(MRNumberString.value!="")) {
		for (var i=1;i<lu.length;i++) {
			if (lu[i]==oldvar) delete lu[i];
		}
	}
	
	MRNumberString.value=lu.join("^")
	//alert("MRNumberString.value "+MRNumberString.value);
}

function RemoveFromString1(MRNumberInactiveString,oldvar) {
	
	var lu = MRNumberInactiveString.value.split("^");
	if ((MRNumberInactiveString)&&(MRNumberInactiveString.value!="")) {
		for (var i=1;i<lu.length;i++) {
			if (lu[i]==oldvar) delete lu[i];
		}
	}
	
	MRNumberInactiveString.value=lu.join("^")
	//alert("MRNumberInactiveString.value "+MRNumberInactiveString.value);
}


function getRow(eSrc) {
	while(eSrc.tagName != "TR") {
		if (eSrc.tagName == "TH") break;
		eSrc=eSrc.parentElement;
	}
	return eSrc;
}
//alert("cjb");

var frm=document.forms["fRTMaster_MRNumberList"];
var tbl=document.getElementById("tRTMaster_MRNumberList");


try {if (tbl) tbl.onclick=SelectRowHandlerMRN;} catch(e) {}
try {if (tbl) tbl.onKeyPress=SelectRowHandlerMRN;} catch(e) {}



	