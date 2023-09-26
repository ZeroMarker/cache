// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function BodyLoadHandler() {
	objBold=document.getElementById('BoldLinks');
	if (objBold) {
	 	var BoldLink = objBold.value.split("^");
	  obj=document.getElementById('AddService');
  if ((obj) && (BoldLink[0]=="1")) obj.style.fontWeight="bold";
	  obj=document.getElementById('AddClinicians');
	if ((obj) && (BoldLink[1]=="1")) obj.style.fontWeight="bold";
	  obj=document.getElementById('AddInformation');
	if ((obj) && (BoldLink[2]=="1")) obj.style.fontWeight="bold";
	  obj=document.getElementById('AddClient');
	if ((obj) && (BoldLink[3]=="1")) obj.style.fontWeight="bold";
		obj=document.getElementById('ScanDocuments');
	if ((obj) && (BoldLink[3]=="1")) obj.style.fontWeight="bold";

  }
	setLinks();

	//Log 64743 PeterC 28/08/07
	var obj=document.getElementById('AddInformation');
	var idobj=document.getElementById('ID');

	if ((obj)&&(idobj)&&(idobj.value=="")) {
		obj.disabled=true;
		obj.onclick=BlankClickhandler;
	}

	var objID=document.getElementById('ID');
	if (objID.value=="") {
	 	//disable links for new entry
	 	var obj=document.getElementById('ScanDocuments');
	 	if (obj) {
	 		obj.disabled=true;
	 		obj.onclick=LinkDisable;
		}
	 	var objDelete=document.getElementById('delete1');
		if (obj) {
			objDelete.disabled=true;
			objDelete.onclick=LinkDisable;
		}
		var obj=document.getElementById('SERVupdate');
		if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}

		var obj=document.getElementById('CLNTupdate');
		if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}

		var obj=document.getElementById('CLINupdate');
		if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}

	 	var obj=document.getElementById('SERVNew');
		if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}

		var obj=document.getElementById('CLNTNew');
		if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}

		var obj=document.getElementById('CLINNew');
		if (obj) {
			obj.disabled=true;
			obj.onclick=LinkDisable;
		}

	}

}
//Log 64743 PeterC 28/08/07
function BlankClickhandler() {
	return false;
}

function setBoldLinks(el,state) {
	obj=document.getElementById(el);
	if (obj) {
		if (state==1) obj.style.fontWeight="bold";
		else obj.style.fontWeight="normal";
	}
}

function LinkDisable(e) {
	var el = websys_getSrcElement(e);
	if (el.disabled) {
		return false;
	}
	return true;
}

function setLinks() {
	var obj=document.getElementById('hiddenLinks');
	if (obj) obj.value="0";
	obj=document.getElementById('ID')
	if ((obj)&&(obj.value=="")) {
		var obj=document.getElementById('hiddenLinks');
		if (obj) obj.value="1";
	}
}

function PACMStatus_changehandler(str) {
	var lu = str.split("^");
	var d,Today=""
	if (lu[2]=="C") {
		var objDateRes=document.getElementById('PACMDateResolved');
		var d=new Date();
		Today += d.getDate() + "/";
		Today += d.getMonth() + "/";
    Today += d.getYear();
		objDateRes.value=Today;
	}
}

document.body.onload=BodyLoadHandler;


