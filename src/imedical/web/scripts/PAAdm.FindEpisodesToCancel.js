// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function DocumentLoadHandler() {

	//SB 12/06/02: Change handlers overwrite brokers, change handler now called from broker.
	obj=document.getElementById('CTLOCDesc');
	if (obj) obj.onblur = LocTextBlurHandler;

	obj=document.getElementById('RESDesc');
	if (obj) obj.onblur = ResTextBlurHandler;


}



function CTLOCDescLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById('CTLOCDesc');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('LocationID');
	if (obj) obj.value=lu[1];
	//var obj=document.getElementById('RESDesc');
	//if ((obj) && (lu[3]!="")) obj.value=lu[3]
	var obj=document.getElementById('ResourceID');
	if ((obj) && (lu[4])) obj.value=lu[4]
//alert(str);
}



function RESDescLookUpSelect(str) {
	//alert(str);
	var lu = str.split("^");
	var objres=document.getElementById('RESDesc');
	if (objres) objres.value=lu[0];
	var obj=document.getElementById('ResourceID');
	if (obj) {
		if (lu[2]=="") {
			if (objres) objres.value=""
			obj.value=""
		} else {
			obj.value=lu[3];
		}
	}
	
	var obj=document.getElementById('CTLOCDesc');
	if (obj) obj.value=lu[2];
	var obj=document.getElementById('LocationID');
	if (obj) obj.value=lu[4];
	//alert(lu[2]);
	//var obj=document.getElementById('CTLOCDesc');
	//if (obj) obj.value=lu[3]
	//var obj=document.getElementById('LocationID');
	//if (obj) obj.value=lu[4]

}


function LocTextBlurHandler(e) {
	var eSrc=websys_getSrcElement(e)
	if ((eSrc) && (eSrc.value=="")) {
		var obj=document.getElementById('LocationID');
		if (obj) obj.value=""
	}
}

function ResTextBlurHandler(e) {
	var eSrc=websys_getSrcElement(e)
	if ((eSrc) && (eSrc.value=="")) {
		var obj=document.getElementById('ResourceID');
		if (obj) obj.value="";
	}
}



document.body.onload = DocumentLoadHandler;

