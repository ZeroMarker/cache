// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var frm;
var lstItems;
var WorkflowItems=new Array();

frm=document.forms['fwebsys_MenuGroup_Edit'];
lstSelItems=frm.elements['Items'];
lstAllItems=frm.elements['AvailItems'];

function RemoveClickHandler() {
	SwapToList(lstSelItems,lstAllItems,0);
	return false;
}
function AddClickHandler() {
	SwapToList(lstAllItems,lstSelItems,0);
	return false;
}
function UpdateClickHandler() {
	var ids='';
	for (var j=0; j<lstSelItems.options.length; j++) {
		ids += lstSelItems.options[j].value + "|";
	}
	frm.elements['HMENULIST'].value=ids;
	return update1_click();
}
function delete1ClickHandler() {
	//check before deleting entire group
	if (confirm(t["DELETEALL"])) {return delete1_click()} else {return false;}
}

function LoadSelectedList() {
	var selected = frm.elements['HMENULIST'].value;
	var arrSelected = new Array();
	for (var j=0; j<lstAllItems.options.length; j++) {
		var opt = lstAllItems.options[j];
		if (selected.indexOf("|"+opt.value+"|")!=-1) {
			lstSelItems.options[lstSelItems.options.length] = new Option(opt.text,opt.value);
			arrSelected[arrSelected.length] = j;
		}
	}
	for (j=arrSelected.length-1; j>=0; j--) {
		lstAllItems.remove(arrSelected[j]);
	}
}

function BodyLoadHandler() {
	LoadSelectedList();

	var obj=document.getElementById('update1');
	if (obj) obj.onclick=UpdateClickHandler;
	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateClickHandler;

	var obj=document.getElementById('Remove');
	if (obj) obj.onclick=RemoveClickHandler;
	if (tsc['Remove']) websys_sckeys[tsc['Remove']]=RemoveClickHandler;
	var obj=document.getElementById('Add');
	if (obj) obj.onclick=AddClickHandler;
	if (tsc['Add']) websys_sckeys[tsc['Add']]=AddClickHandler;
}
document.body.onload=BodyLoadHandler;