// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var returnSelected="";
var obj=document.getElementById("returnSelected");
if (obj) returnSelected=obj.value;


function DocumentLoadHandler() {
	document.onclick=RefreshPatientSelected;
}

//used when another screen opens the patient search in a new window and
//needs to return back to that screen with the patient selected
//must select the registration link to be considered selected
//JW:modifed to display deceased message.
//Log 41976 Chandana 11/2/05 - This is copied from PAPerson.List.js and modified.
function RefreshPatientSelected(evt) {
	var eSrc = websys_getSrcElement(evt);
	if (eSrc.tagName=="IMG") eSrc = websys_getParentElement(eSrc);
	if ((eSrc.id)&&(eSrc.id.indexOf("RegistrationNoz")==0)) {
		var eSrcAry=eSrc.id.split("z");
		var row=eSrcAry[eSrcAry.length-1];
		var objID=document.getElementById("IDz"+row);
		if (document.getElementById("Deadz"+row)) {
			if (document.getElementById("Deadz"+row).value=="Y") {
				var dec=confirm(t['PatDead'])
				if (!dec) {
					return false
				}
			}
		}

		if (objID) {
			var PatientID=objID.value;
			var RegNo=eSrc.innerText;
			var re = /(\s)+/g ;	//regular expr for removing all spaces
			RegNo=RegNo.replace(re,'');
			if (window.opener) {
				var obj=window.opener.document.getElementById('RegistrationNo');
				if (obj) obj.value=RegNo;
				window.close();
			}
		}

	}
}


document.body.onload = DocumentLoadHandler;