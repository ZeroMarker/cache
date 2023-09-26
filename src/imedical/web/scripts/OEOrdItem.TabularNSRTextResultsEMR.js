// Copyright (c) 2002 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
f=document.fOEOrdItem_TabularNSRTextResultsEMR;
document.body.onload = BodyLoadHandler;

function LinkDisable(e) {
	var el = websys_getSrcElement(e);
	if (el.disabled) {
		return false;
	}
	return true;
}

function BodyLoadHandler() {
	UpdateBodyLoadHandler();
}
function TickTaggedResults() {
// don't need to tick tagged results but need function here so that we dont get an error when 
// it has been called from OEOrdItemTabularResultsUpdate.js
}
function TagResults() {
// don't need to tag results but need function here so that we dont get an error when 
// it has been called from OEOrdItemTabularResultsUpdate.js
}
