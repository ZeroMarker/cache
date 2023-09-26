// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

//TN:23-May-2002:when used in workflows, can't use "|" in transition expressions,
// passed LocType with "," delimiter instead so need to convert back for lookups, etc
var obj=document.getElementById("LocType")
if ((obj)&&(obj.value!="")) {
	var arr=obj.value.split(",");
	obj.value=arr.join("|");
}
if (obj.value=="") obj.value="E|EM";

function ClinicalSessionlookup(str) {
 	var lu = str.split("^");
	var obj;
	
	obj=document.getElementById('ClinicalSession')
	if (obj) obj.value = lu[0]
	
	obj=document.getElementById('ClinsessID');
	if (obj) obj.value = lu[3];	
	//alert (lu[0]+", "+lu[3]);
}

function BodyLoadHandler(){
	Uobj=document.getElementById("find1")
	if (Uobj) Uobj.onclick=SelectFind;
	if (tsc['find1']) {
		websys_sckeys[tsc['find1']]=SelectFind;
	}
}

function SelectFind(){
	window.setTimeout(find1_click,200)
}

document.body.onload=BodyLoadHandler;

