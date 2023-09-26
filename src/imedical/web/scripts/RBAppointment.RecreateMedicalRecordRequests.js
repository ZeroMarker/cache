// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function CTLOCDescLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById('RESDesc');
	if ((obj="")&&(lu[5]!="")) obj.value=lu[5].split("*")[0];
	var obj=document.getElementById('ResID');
	if ((obj="")&&(lu[5]!="")) obj.value=lu[5].split("*")[1];
	var obj=document.getElementById('CTLOCDesc');
	if (obj) obj.value=lu[0];
}

function ResourceLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById('RESDesc');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('ResID');
	if (obj) obj.value=lu[2];
	//alert(lu[2]);
	var obj=document.getElementById('CTLOCDesc');
	if (obj="") obj.value=lu[4];
}

function LocTextBlurHandler(e) {
	var eSrc=websys_getSrcElement(e)
	if (eSrc && eSrc.value=="") {
		var obj=document.getElementById('LocId');
		if (obj) obj.value=""
	}
}

function ResTextBlurHandler(e) {
	var eSrc=websys_getSrcElement(e)
	if (eSrc && eSrc.value=="") {
		var obj=document.getElementById('ResId');
		if (obj) obj.value="";
	}
}

function ResourceChangeHandler() {
	var obj=document.getElementById('CTLOCDesc')
	var res=document.getElementById('RESDesc')
	if ((obj) && (res)) {
		res.value=""
	}
}

function LocationChangeHandler() {
	var obj=document.getElementById('CTLOCDesc')
	var res=document.getElementById('RESDesc')
	var ser=document.getElementById('SERDesc')
	if ((obj) && (res)) {
		res.value=""
	}
    obj=document.getElementById("RESDesc")
    if (obj) obj.value=""
}

function BodyLoadHandler() {

    obj=document.getElementById('CTLOCDesc');
	if (obj) obj.onblur = LocTextBlurHandler;


	obj=document.getElementById('RESDesc');
	if (obj) obj.onblur = ResTextBlurHandler;

}

document.body.onload = BodyLoadHandler;