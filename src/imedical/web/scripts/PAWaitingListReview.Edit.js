// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var HasChgRevDate="";

function BodyLoadHandler() {
	
	// SA 9.7.02: Log 26442. This component is usually loaded with component 
	// PAWaitingListReview.List whose onload overwrites any onload event called
	// via a custom js. PAWaitingListReview.List will call this onload. Will now
	// in turn will try CustomDocumentLoadHandler.
	try {CustomDocumentLoadHandler();} catch(e) {} 

	// RQG 15.01.03 Log31755: Disable form if Patient is admitted or WL status is "Removed"
	Disableform();

	obj=document.getElementById('update1')
	if (obj) obj.onclick = UpdateHandler;
	// alert("Edit");
	var obj;
	obj=document.getElementById('REVPatientRespond');	
	if (obj) obj.onclick=PatRespondClickHandler;
	//if (obj) obj.onchange=PatientRespondChangeHandler;
	

	var objDate=document.getElementById("REVEffDate")
	if (objDate) objDate.onblur=DateChangeHandler;
	
	var obj=document.getElementById("REVRevStatusDR")
	if (obj) obj.onchange();
	//Log 62882 PeterC 07/03/07
	SetReviewDate();
}

function SetReviewDate() {
	var tbl=document.getElementById("tPAWaitingListReview_List");
	var iobj=document.getElementById("ID");
	var CurrMaxDate="";
	var CurrMaxRowID="";
	if ((tbl)&&(iobj)&&(iobj.value=="")){
		for (var i=1;i<tbl.rows.length;i++) {
			var dobj=document.getElementById("HidReviewDateLogicalz"+i);
			if((dobj)&&(dobj.value!="")) {
				if((CurrMaxDate=="")||(parseInt(CurrMaxDate)<parseInt(dobj.value))) {
					CurrMaxDate=dobj.value;
					CurrMaxRowID=i;
				}
			}
		}
		var mobj=document.getElementById("HidReviewDatez"+CurrMaxRowID);
		if ((mobj)&&(mobj.value!="")) {
			var robj=document.getElementById("ReviewDate");
			var rhobj=document.getElementById("ReviewDateHidden");
			if((robj)&&(rhobj)&&(rhobj.value!="")) {
				robj.value=mobj.value;
				var objODate=document.getElementById("OriginalReviewDate");
				if(objODate) objODate.value=mobj.value;
				HasChgRevDate="Y";
				DateChangeHandler();
			}
		}
	}
}


function StatusLookup(str) {
 	var lu = str.split("^");
	var obj;
	obj=document.getElementById("WLRSTDesc");
	if (obj) obj.value = lu[0]
	if (lu[0]="Patient Response") {
		obj=document.getElementById("REVPatientRespond");
		//alert(obj.value);
		if (obj) obj.value = "on"
		//alert(obj.value);
	} else {
		obj=document.getElementById("REVPatientRespond");
		if (obj) obj.value = "off"
	}
	//Log 62639 - 01.08.2007 - do this only if the Reset Review Date is not defined at the Review Outsome level.
	var obj1=document.getElementById("OutcomeResetReview");
	if ((obj1)&&(obj1.value!="1")) {
		obj=document.getElementById("ResetReviewDate");
		if (obj) obj.value = lu[3]
	}	
	
	DateChangeHandler();
}

//Log 62639 - 01.08.2007
function OutcomeLookup(str) {
 	var lu = str.split("^");
	var obj;
	
	obj=document.getElementById("OutcomeResetReview");
	if ((obj)&&(obj.value=="1")) {
		obj=document.getElementById("ResetReviewDate");
		if (obj) obj.value = lu[3]
	}	
	DateChangeHandler();
}

function DateChangeHandler(e) {
	objReset=document.getElementById("ResetReviewDate");
	if (objReset) {
	  if (objReset.value=="Y") {
		var objDate=document.getElementById("REVEffDate")
		var objRD=document.getElementById("ReviewDate")
		var objRC=document.getElementById("ReviewCalc")
		var objRDH=document.getElementById("ReviewDateHidden")
		if (objRD && objDate && objRC && objDate.value!="") {
			objRD.value=AddToDateStrGetDateStr(objDate.value,"D",parseInt(objRC.value));
			if (objRDH) objRDH.value = objRD.value;
		}
	  } else {
	  	var objODate=document.getElementById("OriginalReviewDate")
	  	var objRD=document.getElementById("ReviewDate")
	  	if (objRD && objODate) objRD.value = objODate.value;
		//Log 62882 PeterC 07/03/07
		if (HasChgRevDate=="Y") {
			var objRDH=document.getElementById("ReviewDateHidden")
			if((objRDH)&&(objODate)&&(objODate.value!="")) objRDH.value=objODate.value;
		}
	  }	
	}
}


function PatRespondClickHandler(e) {
 //dummy function
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

function UpdateHandler() {
	
	return update1_click();
}

/*function UpdateHandler() {
	update1_click();
	if (self == top) {
		//alert("closing");
		//var win=window.opener;
		// SA 20.8.03 - log 38085: After update, screen wasn't going anywhere that made sense.
		// Have discussed with Brisbane, and they are happy for the screen to close after update
		// with TRAK_MAIN refreshing.
		var win=top.window.opener.top.frames["TRAK_main"];
		if (win) {
			//alert("reloading");
			//window.opener.frames["TRAK_main"].treload('websys.csp')

			win.treload('websys.csp');
			
			//AJI 24.09.03 log 39040: The following line causes the screen to close straight away
			// This is inappropriate in the situation where wrong password has been entered.
 			// The invalid password popup was prevented from displaying.
			//window.close();
		}

	}
} */

function Disableform() {
	//var objtcistatus = document.getElementById('TCIStatus');
	var objwlstatus = document.getElementById('WLStatus');
	var objupdate1 = document.getElementById('update1');
	var objdelete1 = document.getElementById('delete1');

	//if (((objtcistatus)&&(objtcistatus.value=="A"))||((objwlstatus)&&(objwlstatus.value=="R"))) {
	if ((objwlstatus)&&((objwlstatus.value=="R")||(objwlstatus.value=="D"))) {
		var frm = document.forms['fPAWaitingListReview_Edit'];
		for (i=0; i<frm.elements.length; i++) {
			var el = frm.elements[i];
			var icn= "ld1173i" + el.name 
			//var el = frm.elements[arrElem[i]];
			if (el) {
				el.disabled=true;
				el.className = "disabledField";

				var icon=document.getElementById(icn)
				//alert(icn);
				if (icon) {
					icon.style.visibility = "hidden";
				}
			}
		}
		if (objupdate1) objupdate1.style.visibility="hidden";
		if (objdelete1) objdelete1.style.visibility="hidden";
	}
}

//SA 19.02.02: This code is NEVER to be used.   
//It will give no indication that validation has failed.
//function BodyUnloadHandler(e) {
//	if (self==top) {
//		if (window.opener) {
//			window.close()	
//		}	
//	}
//}


//document.body.onload=Init
document.body.onload=BodyLoadHandler;
//document.body.onunload=BodyUnloadHandler;







