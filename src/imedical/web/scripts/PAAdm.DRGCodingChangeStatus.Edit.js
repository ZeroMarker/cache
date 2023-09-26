//Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var objUpdate=document.getElementById("update1");
var objNewStatus=document.getElementById("NewStatus");
var objNewStatusCode=document.getElementById("NewStatusCode");

function BodyLoadHandler() {

	//alert("BodyLoadHandler called");

	if (objUpdate) {
		objUpdate.onclick=UpdateClickHandler;
	}

	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateClickHandler;

}

function NewStatusLookUpHandler(str) {
	//alert("str="+str);
 	var lu = str.split("^");
	if (objNewStatus) {
		objNewStatus.value=lu[0];
		if (objNewStatusCode) {
			objNewStatusCode.value=lu[2];
		}
	} 
}

function UpdateClickHandler() {

	//alert("objNewStatusCode.value="+objNewStatusCode.value);

	if (!(PreUpdateCheck)) {
		return false;
	}

	if ((objNewStatusCode)&&(objNewStatusCode.value=="S")) {
		alert(t['NO_S_STATUS']);
		return false;
	}
	
	return update1_click();
}

function PreUpdateCheck() {
	// SA 5.9.02 - log 24627: Dummy function here
	// ARMC custom javascripts holds update check.
	return true;
}

document.body.onload=BodyLoadHandler;
