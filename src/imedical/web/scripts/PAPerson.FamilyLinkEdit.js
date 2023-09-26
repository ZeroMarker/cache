// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function DocumentLoadHandler(e) {

	var obj;

	obj=document.getElementById('update')
	if (obj) obj.onclick = UpdateHandler;

	obj=document.getElementById('RelationPatientID');
	if ((obj)&&(obj.value=="")) {
		var objText=document.getElementById('PAPERFamilyLinkText');
		if (objText) objText.disabled=true;
		var objUserCode=document.getElementById('UserCode');
		if (objUserCode) objUserCode.disabled=true;
		var objPIN=document.getElementById('PIN');
		if (objPIN) objPIN.disabled=true;
		var lnk=document.getElementById('update');
		if (lnk) {
			//alert("unmerge");
			lnk.disabled=true;
			lnk.onclick=LinkDisable;
		}
	}

	if ((window.opener)&&(window.opener.opener)) {
		var doc=window.opener.opener.document;
		var objLeave=document.getElementById("PAAdmLeaveDR");
		var objID=doc.getElementById("ID");
		if ((objLeave)&&(objID)) {
			objLeave.value=objID.value;
		}
	}

	if (tsc['update']) websys_sckeys[tsc['update']]=UpdateHandler;
}

function UpdateHandler() {
	// set the variable on PAAdmLeave to link the temp address for new leave
	/*if ((window.opener)&&(window.opener.opener)) {
		var objID=window.opener.opener.document.getElementById("ID");
		var obj=window.opener.opener.document.getElementById("NewTempAddr");
		if ((objID)&&(objID.value=="")&&(obj)) obj.value=1;
	}*/
	if (parent.frames["PAPerson_FamilyLinkEdit"]) {
		var frm = document.forms["fPAPerson_FamilyLinkEdit"];
		//frm.target = "_parent";
		//alert(window.parent.name+" : "+frm.elements['TWKFL'].value)
		//return false
		//if (frm.elements['TWKFL'].value!="") frm.elements['TFRAME'].value="window.parent.name";
		frm.elements['TFRAME'].value=window.parent.name;

		}

		//var obj=document.forms['fPAPerson_FamilyLinkEdit'].elements['TWKFLI'];
		//if (obj.value!="") obj.value-=1;

		return update_click();
}


function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	if (el.disabled) {
		return false;
	}
	return true;
}


window.onload = DocumentLoadHandler;




