// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function LoadPatient(evt) {
	var src=websys_getSrcElement(evt);
	
	//To see if the field is there
	if (src.tagName != "A") var src=websys_getParentElement(src);
	if (src.tagName != "A") return;

	//Gets the selected row
	if (src.id.substring(0,7)!="Selectz") return;
	var arry=src.id.split("z");
	rowsel=arry[arry.length-1];

	//Adds ItemData to link expression
	var IDField=document.getElementById("IDz"+rowsel);
	var PatientIDField=document.getElementById("PatientIDz"+rowsel);
	var mradmField=document.getElementById("mradmz"+rowsel);
	var TitleField=document.getElementById("Titlez"+rowsel);
	if (IDField) {
		var ParentWindow = window.opener;
		if (ParentWindow) ParentWindow = ParentWindow.parent;
		ParentWindow.SetEpisodeDetails(PatientIDField.value,IDField.value,mradmField.value,TitleField.value);
		//window.close;
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

function BodyLoadHandler() {	
	var tbl=tPAAdm_ListBookedArea;
	if (document.getElementById("iLISTz1")) imagesShow(tbl);
	if (self==top) reSizeT();

	document.onclick=LoadPatient;
}

document.body.onload = BodyLoadHandler;
