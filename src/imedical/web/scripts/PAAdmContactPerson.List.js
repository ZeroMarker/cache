// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function DocumentLoadHandler() {

	if (self==top) websys_reSizeT();
	obj = document.getElementById("update1")
	obj.onclick = UpdateClickHandler;
	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateClickHandler;
	
}


function ContactPersonClickHandler(e) {
	var eSrc = websys_getSrcElement(e);
	var obj = document.getElementById("find1");
	if (parent.frames["contactlower"]) {
		if (eSrc.name=="find1") {
		//alert(eSrc.innerText)
		return 
		} 
		//if (eSrc.name=="update1") {
		//alert(eSrc.innerText)
		//return 
		//} 
		if (eSrc.tagName=="A") {
			eSrc.target = "contactlower";
			var currentlink=eSrc.href.split("?");
			eSrc.href = "websys.default.csp?WEBSYS.TCOMPONENT=PAAdmContactPerson.Edit&" + currentlink[1];
		//alert(eSrc.href)
		//return false
		}
	}
}

function UpdateClickHandler(e) {
	
	if (parent.frames["contactupper"]) {
		var frm = document.forms["fPAAdmContactPerson_List"];
				
		frm.target = "_parent"
		

		}
	
	return update1_click();
	//return updateNext_click();
}


document.body.onclick =ContactPersonClickHandler;
document.body.onload = DocumentLoadHandler;