//Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var lstItems=document.getElementById("Items");
var lstLeft=document.getElementById("LeftItems");

function ChartLookUpSelect(txt) {
	var obj=document.getElementById('Chart');
	if (obj) obj.value="";
	TransferToList(lstItems,txt);
}
function UpClickHandler() {
	UpClick(lstItems);
	UpClick(lstLeft);
	return false;
}
function DownClickHandler() {
	DownClick(lstItems);
	DownClick(lstLeft);
	return false;
}
function DeleteItemClickHandler() {
	ClearSelectedList(lstItems);
	ClearSelectedList(lstLeft);
	return false;
}
function SwitchClickHandler() {
	for (var i=0; i<lstItems.length; i++) {
		var txt="";
		if (lstItems.options[i].selected) {
			txt += lstItems.options[i].text + "^" + lstItems.options[i].value;
			TransferToList(lstLeft,txt);
		}
	}
	ClearSelectedList(lstItems);
	for (var i=0; i<lstLeft.length; i++) {
		var txt="";
		if (lstLeft.options[i].selected) {
			txt += lstLeft.options[i].text + "^" + lstLeft.options[i].value;
			TransferToList(lstItems,txt);
		}
	}
	ClearSelectedList(lstLeft);
	return false;
}
function DetailsClickHandler(e) {
	if ((lstItems.selectedIndex<0)&&(lstLeft.selectedIndex<0)) {
		alert(t['noChartItem']);
		return false;
	}
	for (var i=0; i<lstItems.length; i++) {
		if (lstItems.options[i].selected) {
			var lnk = "epr.chart.edit.csp?ChartID=" + lstItems.options[i].value;
			websys_lu(lnk,false);
		}
	}
	for (var i=0; i<lstLeft.length; i++) {
		if (lstLeft.options[i].selected) {
			var lnk = "epr.chart.edit.csp?ChartID=" + lstLeft.options[i].value;
			websys_lu(lnk,false);
		}
	}
	return false;
}
function UpdateClickHandler() {
	var arrItems = returnValues(lstItems);
	var obj=document.getElementById('ChartList');
	if (obj) obj.value = arrItems.join(String.fromCharCode(1));
	var arrItems = returnValues(lstLeft);
	var obj=document.getElementById('LeftChartList');
	if (obj) obj.value = arrItems.join(String.fromCharCode(1));
	return update1_click();
}
var obj=document.getElementById("Up");
if (obj) obj.onclick=UpClickHandler;
var obj=document.getElementById("Down");
if (obj) obj.onclick=DownClickHandler;
var obj=document.getElementById("deleteItem");
if (obj) obj.onclick=DeleteItemClickHandler;
var obj=document.getElementById("Details");
if (obj) obj.onclick=DetailsClickHandler;
var obj=document.getElementById("SwitchList");
if (obj) obj.onclick=SwitchClickHandler;
var obj=document.getElementById("update1");
if (obj) obj.onclick=UpdateClickHandler;

function DocumentLoadHandler() {
	var obj=document.getElementById("ID");
	var objcopy=document.getElementById("CopyChartbook");
	if ((obj)&&(obj.value=="")&&(objcopy)) DisableLink("CopyChartbook");
}

function DisableLink(field) {
	var obj=document.getElementById(field);
	if (obj) {
		obj.disabled=true;
		obj.onclick = LinkDisable;
	}
}

document.body.onload=DocumentLoadHandler;