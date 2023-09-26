// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

// Log 46798 YC - Tumour Body Site Fields
var LIBSItems=document.getElementById('LymphInvasBodySiteList');
var DMBSItems=document.getElementById('DistalMetaBodySiteList');

function ValidateUpdate() {
//document.forms[0].target=setTargetWindow(document.getElementById('ChartID').value);
//alert(document.forms[0].target);
//alert(document.getElementById('ChartID').value);

  // Log 46798 YC - Creating array for Lymph Invasion Body Site
  var LIBSArray="";
  if (LIBSItems) {
  	for(i=0;i<LIBSItems.length;i++) {
  		if(LIBSArray!="")
  		  LIBSArray+="^";
  		LIBSArray+=LIBSItems[i].innerText;
  	}
  	var obj=document.getElementById('LIBSArray');
  	if (obj)
    	obj.value=LIBSArray;
	}

  // Log 46798 YC - Creating array for Distal Metastasis Body Site
  var DMBSArray="";
  if (DMBSItems) {
  	for(i=0;i<DMBSItems.length;i++) {
  		if(DMBSArray!="")
  		  DMBSArray+="^";
  		DMBSArray+=DMBSItems[i].innerText;
  	}
  	var obj=document.getElementById('DMBSArray');
  	if (obj)
    	obj.value=DMBSArray;
	}

	return update1_click();
}

//function RepeatClickHandler(evt) {
//	var el=document.getElementById('TWKFLI');
//	if ((el)&&(el.value!="")) el.value = el.defaultValue - 1;
//	ValidateUpdate();
//}

function BodyLoadHandler() {
	var obj=document.getElementById('update1');
	if (obj) obj.onclick = ValidateUpdate;
	//var obj=document.getElementById('Repeat');
	//if (obj) obj.onclick = RepeatClickHandler;
	//if (self==top) websys_reSizeT();

	// Log 46798 YC - Delete selected from Lymph Invasion and Distal Metastasis Body Site Listboxes
	var obj=document.getElementById('DeleteLIBS');
	if (obj) obj.onclick = DeleteLIBSClickHandler;
	var obj=document.getElementById('DeleteDMBS');
	if (obj) obj.onclick = DeleteLIBSClickHandler;

}

// Log 46798 YC - Add to Lymph Invasion Body Site Listbox
function LymphInvasBodySiteLookUp(str) {
	TransferToList(LIBSItems,str);
	var obj=document.getElementById('LymphInvasBodySite');
	obj.value="";
	// Set focus back to LookUp.
	websys_setfocus('LymphInvasBodySite');
}

// Log 46798 YC - Add to Distal Metastasis Body Site Listbox
function DistalMetaBodySiteLookUp(str) {
	TransferToList(DMBSItems,str);
	var obj=document.getElementById('DistalMetaBodySite');
	obj.value="";
	// Set focus back to LookUp.
	websys_setfocus('DistalMetaBodySite');
}

// Log 46798 YC - Delete selected from Lymph Invasion Body Site Listbox
function DeleteLIBSClickHandler(e) {
	ClearSelectedList(LIBSItems);
	return false;
}

// Log 46798 YC - Delete selected from Distal Metastasis Body Site Listbox
function DeleteDMBSClickHandler(e) {
	ClearSelectedList(DMBSItems);
	return false;
}

document.body.onload = BodyLoadHandler;