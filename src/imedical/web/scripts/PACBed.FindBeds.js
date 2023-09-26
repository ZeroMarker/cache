// Copyright (c) 2003 TrakHealth Pty Limited. ALL RIGHTS RESERVED.


function FindClickHandler(e) {
	var objData=document.getElementById("ExtraParams");
	var arrData=new Array(4);
	var obj=document.getElementById("BDDateFrom");
	if (obj) {arrData[0]=obj.value} else {arrData[0]=""}
	var obj=document.getElementById("BDDateTo");
	if (obj) {arrData[1]=obj.value} else {arrData[1]=""}
	//var obj=document.getElementById("Ward");
	//if (obj) {arrData[2]=obj.value} else {arrData[2]=""}
	objData.value=arrData.join("^");
	//alert(objData.value);
	find1_click();
	return false
}
function AddItemToList(list,code,desc) {
	//Add an item to a listbox
	//code=String.fromCharCode(2)+code
	list.options[list.options.length] = new Option(desc,code);
}

function RemoveFromList(obj) {
	for (var i=(obj.length-1); i>=0; i--) {
		if (obj.options[i].selected)
			obj.options[i]=null;
	}
}

function BodyLoadHandler() {
	var obj=document.getElementById("find1");
	if (obj) obj.onclick=FindClickHandler;
	if (tsc['find1']) websys_sckeys[tsc['find1']]=FindClickHandler;
}
document.body.onload=BodyLoadHandler;