// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function SelectRowHandler(e){
	var src=websys_getSrcElement(e);
	rowsel=selectedRowObj.rowIndex;
	var IDField=document.getElementById("IDz"+rowsel);
	var PatientIDField=document.getElementById("PatientIDz"+rowsel);
	var mradmField=document.getElementById("mradmz"+rowsel);
	var TitleField=document.getElementById("Titlez"+rowsel);
	if (IDField) {
		var ParentWindow = window.opener;
		if (ParentWindow) ParentWindow = ParentWindow.parent;
		ParentWindow.SetEpisodeDetails(PatientIDField.value,IDField.value,mradmField.value,TitleField.value);
	}
}

function reSizeT() {
	var w=0;var h=0;
	var arrTABLES=document.getElementsByTagName("TABLE");
	for (var i=0; i<arrTABLES.length; i++) {
		if (arrTABLES[i].offsetWidth>w) w=arrTABLES[i].offsetWidth;
		h += arrTABLES[i].offsetHeight + arrTABLES[i].offsetTop;
	}
	w+=32;h+=32;
	if (w>eval(window.screen.Width-window.screenLeft)) w=eval(window.screen.Width-window.screenLeft)-40;
	if (w<282) w=282;
	if (h>eval(window.screen.Height-window.screenTop)) h=eval(window.screen.Height-window.screenTop);
	this.resizeTo(w,h);
}

function BodyUnloadHandler() {
	var winf = window.opener;
	//if (winf) winf.focus();
}
function BodyLoadHandler() {	
	var tbl=tPAAdm_ListWaitingEmergArea;
	if (document.getElementById("iLISTz1")) imagesShow(tbl);
	if (self==top) reSizeT();
	//this is now called from websys.List.js
	//document.onclick=SelectRowHandler;
}

var rowsel=0;
document.body.onload = BodyLoadHandler;
//document.body.onunload = BodyUnloadHandler;
