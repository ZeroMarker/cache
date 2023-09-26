// Copyright (c) 2004 TrakHealth Pty Limited. ALL RIGHTS RESERVED.


function DocumentLoadHandler() {
	var obj = document.getElementById("update1");
	if (obj) {
		obj.onclick = UpdateClickHandler;
		if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateClickHandler;
	}

	obj=document.getElementById('ANAASCareProvType');
	if (obj) obj.onblur=DoCareProvTypeValidation;

	//obj=document.getElementById('ld1927iANAASCareProvType');
	//if (obj) obj.onclick=ANAASCareProvType_lookuphandler;

	DoInitHInternalCode();

	DoInitStatusValidation();

}

//If the status (StatusId) is "D" or "A", then disable all fields.  This is executed on page load.
function DoInitStatusValidation(){
	var objSId = document.getElementById("StatusId");
	if(objSId && (objSId.value == "D" || objSId.value == "A")){
		makeReadOnly();
	}
}

//This function makes fields disabled.
function makeReadOnly() {
	var el=document.forms["fORAnaAdditionalStaff_Edit"].elements;  
	if(!el) {return;}
	
	//disable input fields
	for (var i=0;i<el.length;i++) {
		if (!(el[i].type=="hidden")) {
			el[i].disabled=true;
		}
	}
	//disable image elements (lookup, dates etc. images)
	var arrImgs=document.getElementsByTagName("IMG");
	for (var i=0; i<arrImgs.length; i++) {
		if ((arrImgs[i].id)&&(arrImgs[i].id.charAt(0)=="l")) {
			arrImgs[i].disabled=true;
		}
	}
	//disable links
	var arrLinks=document.getElementsByTagName("A");
	for (var i=0; i<arrLinks.length; i++) {
		if ((arrLinks[i].id)) {
			//if(arrLinks[i].id.indexOf("update1") == -1){
				arrLinks[i].disabled=true;
				arrLinks[i].className="clsDisabled";
				arrLinks[i].onclick=LinkDisabled;
				arrLinks[i].style.cursor='default';
			//}
		}
	}

	//var obj=document.getElementById("UserCode");
	//if (obj) obj.disabled=false;
	//var obj=document.getElementById("PIN");
	//if (obj) obj.disabled=false;
}

function LinkDisabled() {
	return false;
}

function UpdateClickHandler() {
	var frm = document.forms["fORAnaAdditionalStaff_Edit"];
	if (parent.frames["frm_edit"]) {
		frm.elements['TFRAME'].value=window.parent.name;
	}
	var obj=frm.elements['TWKFLI'];
	if (!(fORAnaAdditionalStaff_Edit_submit())) return false
	if (obj.value!="") obj.value-=1;
		
	return update1_click()

}

//If the careprovtype is blanked out, set HCareProvTypeId and HCPInternalCode to blank
//This is executed when page is loaded and everytime value in ANAOPStatus is changed.
function DoCareProvTypeValidation(){
	var objId = document.getElementById("HCareProvTypeId");
	var obj = document.getElementById("ANAASCareProvType");
	var obj2 = document.getElementById("HCPInternalCode");
	var obj3 = document.getElementById("HCPFlag");
	if (objId && obj){ 
		if(obj.value == ""){ 
			objId.value = "";
			if(obj2) obj2.value = "DOCTOR^NURSE";
			if(obj3) obj3.value = "";
		}
	}
}

//When a lookup is done on CareProvType, HCareProvTypeId is populated with the ID.
function ANAASCareProvTypeLookUpHandler(str) {
	var lu=str.split("^");
	var obj=document.getElementById("HCareProvTypeId");
	var obj2=document.getElementById("HCPInternalCode");
	var obj3 = document.getElementById("HCPFlag");
	if (obj && obj2 && obj3) {
		obj.value=lu[1];
		if(lu[1]=="AA" || lu[1]=="SA") obj2.value = "DOCTOR";
		//if(lu[1]=="AA") obj3.value = "^Y^";
		//if(lu[1]=="SA") obj3.value = "^^Y";
		if(lu[1]=="AA") obj3.value = "|Y";
		if(lu[1]=="SA") obj3.value = "||Y";
		if(lu[1]=="SN" || lu[1]=="CN") {
			obj2.value = "NURSE";
			obj3.value="";
		}
		if(lu[1]=="O") {
			obj2.value="DOCTOR^NURSE";
			obj3.value="";
		}
	}
}

//This is run when the page loads.
//HCPInternalCode and HCPFlag are used as parameters for CT_CareProv lookup
function DoInitHInternalCode(){
	var obj=document.getElementById("HCareProvTypeId");
	var obj2=document.getElementById("HCPInternalCode");
	var obj3 = document.getElementById("HCPFlag");
	if (obj && obj2 && obj3) {
		if(obj.value=="AA" || obj.value=="SA") obj2.value = "DOCTOR";
		//if(obj.value=="AA") obj3.value = "^Y^";
		//if(obj.value=="SA") obj3.value = "^^Y";
		if(obj.value=="AA") obj3.value = "|Y";
		if(obj.value=="SA") obj3.value = "||Y";
		if(obj.value=="SN" || obj.value=="CN"){ 
			obj2.value = "NURSE";
			obj3.value = "";
		}
		if(obj.value=="O") {
			obj2.value="DOCTOR^NURSE";
			obj3.value="";
		}
	}
}

//overwrite the method in generated script
/*function ANAASCareProvType_lookuphandler(e) {
	if (evtName=='ANAASCareProvType') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))) {
		var url='websys.lookup.csp';
		url += "?ID=d1927iANAASCareProvType";
		url += "&CONTEXT=Kwebsys.StandardTypeItem:LookUpByType";
		url += "&TLUJSF=ANAASCareProvTypeLookUpHandler";
		url += "&P1=" + 'AnaestOtherStaff';
		var obj=document.getElementById('ANAASCareProvType');
		if (obj) url += "&P2=" + websys_escape(obj.value);
		websys_lu(url,1,'');
		return websys_cancel();
	}
}
*/

function ANAASCareProvDRLookUpHandler(str) {
	//alert(str)
	var lu=str.split("^");
	var obj=document.getElementById("ANAASCareProvDR");
	var obj1=document.getElementById("CareProvType");
	if (lu[0]&&obj)  obj.value=lu[0];
	if (lu[4]&&obj1)  obj1.value=lu[4];
	
	
}


document.body.onload = DocumentLoadHandler;

