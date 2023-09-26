/*

QAS.js - cjb 09/01/2007 59108.

*/

var namelist

function QAS_lookuphandler() {
	if (evtName=='StNameLine1') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))) {
		//To clear the address fields before search
		QAS_ClearAddressFields();
		
		SetNamelist(0);
		
		QAS_lookuphandler2(namelist);
	}
}

function QAS_lookuphandler2(namelist) {
	var url="tkqasinterface.asp?ParamStr="+namelist;
	websys_createWindow(url,"lookup","top=30,left=20,width=300,height=380,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes");
}

function QAS_KeyDown(evt) {
	if (evtName=='StNameLine1') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var charcode
	evt = (evt) ? evt : event;
	var charcode = (evt.which) ? evt.which : evt.keyCode;
	// charcode > 0 = keyboard pressed, 117 = F6
	if ((charcode>0)&&(charcode != 117)) return;
	objaddr1=document.getElementById('PAPERStNameLine1');
	if ((objaddr1)&&(objaddr1.value=='')) {
		alert(t['PAPERStNameLine1'] + ' is required for QAS search.')
		websys_setfocus('PAPERStNameLine1');
		return;
	}
	QAS_lookuphandler();
	return websys_cancel();
}

function QAS_OnChange() {
	evtName='StNameLine1';
	if (doneInit) { evtTimer=window.setTimeout("QAS_OnChangeX();",1000); }
	else { QAS_OnChangeX(); evtTimer=""; }
}

function QAS_OnChangeX() {
	if (evtTimer) {
		window.clearTimeout(evtTimer);
		evtName='';
		evtTimer='';
	}
	
	QAS_ClearAddressFields();
	
	var obj=document.getElementById("PAPERStNameLine1");
	if ((obj)&&(obj.value=="")) { return;}
	
	SetNamelist(1);
	
	// pass window.name as a param because the broker is run in TRAK_hidden, which may be in the parent window in the case of new windows.  The broker then runs the lookup select js in window.name
	var url="tkqasinterface.asp?ParamStr="+namelist+"&QASWIN="+window.name;
	
	// run the QAS interface asp in the hidden frame
	websys_createWindow(url,'TRAK_hidden','');
	
}


function SetNamelist(FromBroker) {
	
	var Address1=""
	
	var obj=document.getElementById('PAPERStNameLine1');
	if (obj) {Address1=obj.value;}
	else {
		var obj1=document.getElementById('ADDRStreet');
		if (obj1) {Address1=obj1.value;}
	}
	
	namelist=Address1+"^";
	
	var obj=document.getElementById('CTCITDesc');
	if (obj) {namelist=namelist+obj.value+"^";}
	else {namelist=namelist+"^";}
	
	var obj=document.getElementById('PROVDesc');
	if (obj) {namelist=namelist+obj.value+"^";}
	else {namelist=namelist+"^";}
	
	var obj=document.getElementById('CTZIPCode');
	if (obj) {namelist=namelist+obj.value+"^";}
	else {namelist=namelist+"^";}
	
	namelist=namelist+"CTCITDesc^"+FromBroker+"^0";
	
}

function QAS_BrokerFail() {
	var obj=document.getElementById('PAPERStNameLine1');
	if (obj) obj.className="clsInvalid";
	else {
		var obj1=document.getElementById('ADDRStreet');
		if (obj1) {obj1.className="clsInvalid";}
	}
}

function QAS_ClearAddressFields() {
	//Clear values 
	var obj=document.getElementById('CTCITDesc');
	if (obj) obj.value='';
	var obj=document.getElementById('PROVDesc');
	if (obj) obj.value='';
	var obj=document.getElementById('CTZIPCode');
	if (obj) obj.value='';
	var obj=document.getElementById("PAPERForeignAddress")
	if (obj) obj.value='';
	var obj=document.getElementById("ADDRStreet2")
	if (obj) obj.value='';
	var obj=document.getElementById("QASCTZIPCode")
	if (obj) obj.value='';
 	var obj=document.getElementById("QASCTCITDesc")
	if (obj) obj.value='';
	var obj=document.getElementById("QASPROVDesc")
	if (obj) obj.value='';
	var obj=document.getElementById("QASHealthCareArea")
	if (obj) obj.value='';
}

function QAS_ZipLookupSelect(str) {
	//zipcode^suburb^state^address1^address2^HCA^HCR
 	//alert(str);
 	
	if (!str) {
		websys_setfocus('PAPERStNameLine1');
		return false;
	}
 	
 	var lu = str.split("^");
	
	var obj=document.getElementById("CTZIPCode")
	if ((obj)&&(lu[0])) obj.value = lu[0];
 	var obj=document.getElementById("CTCITDesc")
	if ((obj)&&(lu[1])) obj.value = lu[1];
	var obj=document.getElementById("PROVDesc")
	if ((obj)&&(lu[2])) {
		obj.value = lu[2];
		//obj.className='';
	}
	
	// PAPerson.Edit & PANok.Edit
	var obj=document.getElementById("PAPERStNameLine1")
	if ((obj)&&(lu[3])) {
		obj.value = lu[3];
		obj.className=""
	}
	var obj=document.getElementById("PAPERForeignAddress")
	if ((obj)&&(lu[4])) obj.value = lu[4];
	
	// PATempAddress.Edit
	var obj=document.getElementById("ADDRStreet")
	if ((obj)&&(lu[3])) {
		obj.value = lu[3];
		obj.className=""
	}
	var obj=document.getElementById("ADDRStreet2")
	if ((obj)&&(lu[4])) obj.value = lu[4];
	
	
	//populate hidden fields
	var obj=document.getElementById("QASCTZIPCode")
	if ((obj)&&(lu[0])) obj.value = lu[0];
 	var obj=document.getElementById("QASCTCITDesc")
	if ((obj)&&(lu[1])) obj.value = lu[1];
	var obj=document.getElementById("QASPROVDesc")
	if ((obj)&&(lu[2])) obj.value = lu[2];
	var obj=document.getElementById("QASHealthCareArea")
	if ((obj)&&(lu[5])) obj.value = lu[5];
	var obj=document.getElementById("QASHealthCareRegion")
	if ((obj)&&(lu[6])) obj.value = lu[6];
	
	// QASAskedForSaveAddress set to 1 in custom scripts for PAPerson.Edit.  set to 0 in QAS_PANok.Edit.js & QAS_PATempAddress.Edit.js as these don't have a 'history'
	if (QASAskedForSaveAddress==1) {QAS_AskedForSaveAddress();}
}

function QAS_AskedForSaveAddress() {
	var obj1=document.getElementById("PAPERStNameLine1");
	var obj2=document.getElementById("CTCITDesc");
	var obj3=document.getElementById("CTZIPCode");
	if (((obj1)&&(obj1.defaultValue!=""))||((obj2)&&(obj2.defaultValue!=""))||((obj3)&&(obj3.defaultValue!=""))) {
		if (!AskedForSaveAddress) {
			AskedForSaveAddress=1;
			registeringAddressChange();
		}
	}
}

// Debugging function only. Used to check that QAS fields were being passed to the update correctly
function CheckQASFields() {

	var ziptext="";
	var cittext="";
	var provtext="";
	var qasziptext="";
	var qascittext="";
	var qasprovtext="";

 	var obj=document.getElementById("CTZIPCode")
	if (obj) ziptext=obj.value;
 	var obj=document.getElementById("CTCITDesc")
	if (obj) cittext=obj.value;
	var obj=document.getElementById("PROVDesc")
	if (obj) provtext=obj.value;
	var obj=document.getElementById("QASCTZIPCode")
	if (obj) qasziptext=obj.value;
 	var obj=document.getElementById("QASCTCITDesc")
	if (obj) qascittext=obj.value;
	var obj=document.getElementById("QASPROVDesc")
	if (obj) qasprovtext=obj.value;

	var zipstring="";
	var citstring="";
	var provstring="";
	var ok=1;

	if (ziptext==qasziptext) {
		zipstring= "ZIP=" + ziptext + " EQUALS QASZIP=" + qasziptext;
	} else {
		zipstring= "ZIP=" + ziptext + " DOES NOT EQUAL QASZIP=" + qasziptext;
		ok=0;
	}

	if (cittext==qascittext) {
		citstring= "CIT=" + cittext + " EQUALS QASZIP=" + qascittext;
	} else {
		citstring= "CIT=" + cittext + " DOES NOT EQUAL QASCIT=" + qascittext;
		ok=0;
	}

	if (provtext==qasprovtext) {
		provstring= "PROV=" + provtext + " EQUALS QASPROV=" + qasprovtext;
	} else {
		provstring= "PROV=" + provtext + " DOES NOT EQUAL QASPROV=" + qasprovtext;
		ok=0
	}
	
	alert(zipstring);
	alert(citstring);
	alert(provstring);
	if (ok==1) {
		alert("This QAS address should save to the database ok.")
	} else {
		alert("This QAS address WILL NOT save to the database.")
	}
}

