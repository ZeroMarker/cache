// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

//pulled out of BodyLoadHandler(), so does this straight away, don't wait till everything loads
SecureAuthorisedNotes();
var keycode;
var isrtf = "";

function CareProvLookUpHandler(str) {
	var lu = str.split("^");
	var obj=document.getElementById("CareProvType");
	if (obj) obj.innerText=lu[4];	
	return false;
}

function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	if (el.disabled) {
		return false;
	}
	return true;
}

function DisableFields() {
	var objRepeat = document.getElementById('Repeat');
	if (objRepeat) {
		objRepeat.disabled=true;
		objRepeat.onclick=LinkDisable;
	}
}

function EnableFields()	{
	var objRepeat = document.getElementById('Repeat');
	if (objRepeat) {
		objRepeat.disabled=false;
		objRepeat.onclick=RepeatClickHandler;
	}
}

function UserNameSelectHandler(str) {
	var lu = str.split("^");
	var obj=document.getElementById("User")
	if (obj) obj.innerText = lu[1];

}

function UserCode_changehandler(encmeth) {	//have to have for broker only!!!
	var obj=document.getElementById('UserCode');
	var p1='';
	if (obj) p1=obj.value;
	var obj=document.getElementById('UserCode');
	if (cspRunServerMethod(encmeth,'','UserNameSelectHandler',p1)=='0') {
		obj.className='clsInvalid';  ///generic name to check all fields. 
		obj.focus();
		return websys_cancel();
	} else {
		obj.className='';
	}
}


//TN:29-May-2002 auditing link
//need to distinguish between nurnisingnote ID and other ID fields (such as on patient banner)
var frmNURN=document.forms['fMRNursingNotes_Edit'];
var objNURNID=frmNURN.elements['ID'];
var objAUD=document.getElementById('AuditTrail');
if ((objAUD)&&(objNURNID)&&(objNURNID.value=='')) {
	objAUD.disabled=true;
	objAUD.onclick=LinkDisable;
}
function BodyLoadHandler() {
    // SB 22/04/02: Log 24544   The code in the ValidateUpdate was causing the page to close even if there was an
    //				invalid pin entered.
    //var obj=document.getElementById('update1');
    //if (obj) obj.onclick = ValidateUpdate;
	//epr_RepeatClickHandler() function lives in epr.js

	/*if (tsc['update1']) {
			websys_sckeys[tsc['update1']]=ValidateUpdate;
	}*/
    var el = document.getElementById('Repeat');
    if (el) el.onclick = RepeatClickHandler;
   	//log26712 if (self==top) websys_reSize();
	// Log 44173 07/06/04 PeterC: Verify PatientID Vs EpisodeID and EpisodeID Vs MRAdm
	var vobj=document.getElementById("VerifyEpisPatID");
	if ((vobj)&&(vobj.value!="Y")) {
		alert(t['MISMATCH_Patient']);
	}

	// Log 50863 JPD
	var GP=document.getElementById('CopyGP');
	if (GP) {
		var GPon=document.getElementById('CopyGPonscreen');
		GPon.value="Y";
	}
	var rec=document.getElementById('OtherRecipient');
	if (rec) {
		var recon=document.getElementById('RecipOn');
		recon.value="Y";
	}

	// Log 56464 21-07-2006 Bo : Handler for the new "Save" button.
	var el = document.getElementById('save1');
	if (el) el.onclick = SaveClickHandler;
    
	//var obj=document.getElementById("NOTRTFNotes");
	//var obj2=document.getElementById("HiddenRTF");
	//if ((obj)&&(obj2)) obj.TextRTF=obj2.value;
	var objID = document.getElementById('ID');
	if ((objID)&&(objID.value!="")) {
		DisableFields();
	}
	else {
		EnableFields();
	}

}
/*
function NOTNotes_onkeydown() {
//required to call this function to override the generic script
//DL : LOG 29062 : 02/Oct/02
}
*/

function RepeatClickHandler(evt) {
	var OK="";
	OK=CheckUpdateDetails();
	if (OK==1) {
		var frm=document.forms['fMRNursingNotes_Edit'];
		return epr_RepeatClickHandler(evt,frm);
	}
	else return false;
}

// Log 56464 21-07-2006 Bo : Handler for the new "Save" button.
function SaveClickHandler(evt) {
	//var OK="";
	//OK=CheckUpdateDetails();
	//if (OK)
	//{
		//var SaveDetails=tkMakeServerCall("web.MRNursingNotes","websysSave",document.getElementById("TEVENT").value,document.getElementById("ID").value);
	//}
	var OK="";
	// Log 56464 21-07-2006 Bo : Remove logic to separate function.
	OK=CheckUpdateDetails();
	if (OK==1) {
		// DAH 04022008 so save doesn't break repeat
		var isSave=document.getElementById('isSave');
		isSave.value=1;
		return save1_click();
		}
	else {
		return false;
		}
}

/*
ahb 17.04.06 - now done by generic canned text
function NOTNotes_keydownhandler(encmeth) {
	var obj=document.getElementById("NOTNotes");
	//lookupqryNURN,jsfuncNURN defined in epr.js
	LocateCode(obj,encmeth,0,lookupqryNURN,jsfuncNURN);
}


function NOTRTFNotes_keydownhandler(encmeth,keyx) {
	if (!keycode) {
		keycode=eval(keyx);
	}
	var obj=document.getElementById("NOTRTFNotes");
	//LocateCode(obj,encmeth,true,lookupqryNURN,"RTFNoteCodes_lookupSelect");
	LocateCode(obj,encmeth,true,lookupqryNURN,"RTFNursingNoteCodes_lookupSelect");
	keycode=""
}


function NOTNotes_lookupsel(value) {
}

function NOTRTFNotes_lookupsel(value) {
}
*/

function AppointmentLookup(str) {
	var lu = str.split("^");
	var obj;
	obj=document.getElementById("NOTAppointDR")
	if (obj) obj.value = lu[0]
	obj=document.getElementById("AppointmentID")
	if (obj) obj.value = lu[0]
 	obj=document.getElementById("ASDate")
	if (obj) obj.value = lu[1];

}

//BC 5-Feb-2002 Function to disable all the necessary fields on an authorised clinical note
function SecureAuthorisedNotes() {

	var flag="0";
	//Check for Authorised
	var obj=document.getElementById('secured');
	if (obj) {
		if (obj.value=="A") {
			flag = "1";
		}
	}
	if (flag=="1") {
		// Clinical Note Status
		var obj=document.getElementById('NNSDesc')
		if (obj) {
			obj.disabled=true;
			//obj.className = "disabledField";
			var objLU=document.getElementById('ld540iNNSDesc');
			if (objLU) objLU.onclick='';
		}
		// Appointment Date
		var obj=document.getElementById('ASDate')
		if (obj) {
			obj.disabled=true;
			//obj.className = "disabledField";
			var objLU=document.getElementById('ld540iASDate');
			if (objLU) objLU.onclick='';
		}
		// Careprovider
		var obj=document.getElementById('NOTNurseIdDR')
		if (obj) {
			obj.disabled=true;
			//obj.className = "disabledField";
			var objLU=document.getElementById('ld540iNOTNurseIdDR');
			if (objLU) objLU.onclick='';
		}
		//Clinical notes
		var obj=document.getElementById('NOTNotes')
		if (obj) {
			obj.readOnly=true;
		}
		var obj=document.getElementById('NOTRTFNotes')
		if (obj) {
			obj.readOnly=true;
		}
		//Clinical Note Type
		var obj=document.getElementById('CNTDesc')
		if (obj) {
			obj.disabled=true;
			//obj.className = "disabledField";
			var objLU=document.getElementById('ld540iCNTDesc');
			if (objLU) objLU.onclick='';
		}
		//Sensitivity
		var obj=document.getElementById('NOTClinNoteSensDR')
		if (obj) {
			obj.disabled=true;
			var objLU=document.getElementById('ld540iNOTClinNoteSensDR');
			if (objLU) objLU.onclick='';
		}
		//Consent
		var obj=document.getElementById('NOTConsent')
		if (obj) {
			obj.disabled=true;
		}
		//var obj=document.getElementById('update1');
		//if (obj) {
			//obj.disabled=true;
			//obj.className = "disabledField";
		//}
	}
}

function NOTNotesOnBlur() {
	/*
	var obj=document.getElementById("NOTNotes");
	var objDesc=document.getElementById("NOTDesc");
	if (obj && objDesc) {
		objDesc.value = obj.value;
	}
	*/
}
function NOTRTFNotesOnBlur() {
	var objRTF=document.getElementById("NOTRTFNotes");
	var objDesc=document.getElementById("NOTDesc");
	if (objRTF && objDesc) {
		objDesc.value = objRTF.Text;
	}
}

function xEnterKey(e) {
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	if ((websys_getAlt(e)&&keycode!=18)||(keycode==33)||(keycode==34)) {
		try {
			var key=String.fromCharCode(keycode);
				//if (key=="D") DeleteClickHandler();
				if (key=="U") {
					update1.focus();
					setTimeout( "UpdateClickHandler()", 100);
				}
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

// Log 56464 21-07-2006 Bo : Logic now called from numerous places.
function CheckUpdateDetails () {
	var vnobj=document.getElementById("NOTNotes");
	var vfobj=document.getElementById("NOTRTFNotes");
	var OK=1;

	if((vnobj)&&(vnobj.value=="")) {
		var proceed="";
		proceed=confirm(t['NO_NOTES']+"\n"+t['CONTINUE'])
		if (!proceed) {
			return false;
			OK=0;
		}
	}
	else if((vfobj)&&(vfobj.Text=="")) {
		var proceed="";
		proceed=confirm(t['NO_NOTES']+"\n"+t['CONTINUE'])
		if (!proceed) {
			return false;
			OK=0;
		}
	}
	return OK;
}

function UpdateClickHandler() {
	var OK="";
	// Log 56464 21-07-2006 Bo : Remove logic to separate function.
	OK=CheckUpdateDetails();
	if (OK==1) {
		return update1_click();
		}
	else {
		return false;
		}
}

//document.body.onkeydown=EnterKey;
//Log 44173 07/06/04 PeterC: Uncommented below 2 lines to ensure that notes are entered.
var obj=document.getElementById("update1");
if (obj) obj.onclick=UpdateClickHandler;
//Log 63420 PeterC 09/05/07: Uncommented the below two lines.
var objRTFBlur=document.getElementById("NOTRTFNotes");
if (objRTFBlur) objRTFBlur.onblur=NOTRTFNotesOnBlur;
//if (objRTFBlur) objRTFBlur.onkeydown=NOTRTFNotes_keydownhandler;
//if (objRTFBlur) objRTFBlur.onchange=NOTRTFNotes_keydownhandler;

//var objBlur=document.getElementById("NOTNotes");
// cjb 14/06/2006 59651 - no longer need to run the blur handler as the websysSave (generated) used the ValueSet in NOTNotes, rather than the hidden field
//if (objBlur) objBlur.onblur=NOTNotesOnBlur;
//if (objBlur) objBlur.onchange=NOTNotesOnBlur;
// onkeydown does NOT have an 'encmeth' parameter for text area...
//if (objBlur) objBlur.onkeydown=NOTNotes_keydownhandler;
document.body.onload = BodyLoadHandler;
