// Copyright (c) 2004 TrakHealth Pty Limited. ALL RIGHTS RESERVED.


function DocumentLoadHandler() {
	var obj = document.getElementById("update1");
	if (obj) {
		obj.onclick = UpdateClickHandler;
		if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateClickHandler;
	}
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
	var el=document.forms["fORAnOperPosition_Edit"].elements;  
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
			arrLinks[i].disabled=true;
			arrLinks[i].className="clsDisabled";
			arrLinks[i].onclick=LinkDisabled;
			arrLinks[i].style.cursor='default';
		}
	}

}

function LinkDisabled() {
	return false;
}

function UpdateClickHandler() {
	var frm = document.forms["fORAnOperPosition_Edit"];
	if (parent.frames["frm_pos_edit"]) {
		frm.elements['TFRAME'].value=window.parent.name;
	}
	var obj=frm.elements['TWKFLI'];
	if (!(fORAnOperPosition_Edit_submit())) return false
	if (obj.value!="") obj.value-=1;
		
	return update1_click()

}

document.body.onload = DocumentLoadHandler;

