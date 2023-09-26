// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var robj=document.getElementById("Refill");
if (robj) robj.onclick=RefillClickHandler;

if (tsc['Refill']) websys_sckeys[tsc['Refill']]=RefillClickHandler;

//// 59215 ////
var raobj=document.getElementById("RefillAll");
var orobj=document.getElementById("Override");

if (raobj && orobj && (orobj.value==1)) { 
	raobj.onclick=RefillAllClickHandler; 
	if (tsc['RefillAll']) websys_sckeys[tsc['RefillAll']]=RefillAllClickHandler;
}
else {if (raobj) {raobj.disabled; raobj.onclick="";}}

function RefillClickHandler() {
	if (ValidUpdate()) { return Refill_click(); }
	return false;
}

function RefillAllClickHandler() {
	if (ValidUpdate()) { return RefillAll_click(); }
	return false;
}

function ValidUpdate() {
	var MaxRepeat="";
	var HidCurrRepeat="";
	var CurrRepeat="";
	var HidMRObj=document.getElementById("HidMaxRepeat");
	if ((HidMRObj)&&(HidMRObj.value!="")) MaxRepeat=HidMRObj.value;

	var HidCRObj=document.getElementById("HidCurrRepeat");
	if ((HidCRObj)&&(HidCRObj.value!="")) HidCurrRepeat=HidCRObj.value;

	var CRObj=document.getElementById("CurrRepeat");
	if ((CRObj)&&(CRObj.value!="")) CurrRepeat=CRObj.value;

	if(CurrRepeat!="") {
		if ((MaxRepeat!="")&&(parseInt(CurrRepeat)>parseInt(MaxRepeat))) { alert(t["MAXEXCEED"]); return false;}
		if ((HidCurrRepeat!="")&&(parseInt(CurrRepeat)<=parseInt(HidCurrRepeat))) { alert(t["REFILLED"]); return false;}
	}
	return true;
}