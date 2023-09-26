// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var billFrozen = document.getElementById('IsBillFrozen').value;

function BodyLoadHandler(){
	obj = document.getElementById("update1");
	obj.onclick = UpdateClickHandler;
	dobj = document.getElementById("delete1");
	dobj.onclick = DeleteClickHandler;

	obj = document.getElementById("COVPrice");
	obj.onchange=COVPriceChangeHandler;
}

function COVPriceChangeHandler(e) {
	//skip changehandler if empty value, to avoid being changed to zero.
	var eSrc=websys_getSrcElement(e);
	if (eSrc.value!="") COVPrice_changehandler(e);
}

function UpdateClickHandler() {

	if (billFrozen=="1") {
		alert(t["CANT_OVERRIDE"]);
		self.close();
		return;
	}

	return update1_click();
}

function DeleteClickHandler() {

	if (billFrozen=="1") {
		alert(t["CANT_DELETE"]);
		self.close();
		return;
	}

	return delete1_click();
}

function COVInsTypeDRLookupSelect(str) {
	
 	var lu = str.split("^");
	var obj;
	obj=document.getElementById("COVInsTypeDR")

	if ((obj)&&(lu[0]))obj.value = lu[0];
	var obj=document.getElementById("COVAuxInsTypeDR")
	if (obj) obj.value="";
	obj=document.getElementById("COVInsAssocDR")
	if (obj) obj.value="";

}

function COVAuxInsTypeDRLookupSelect(str) {
	
 	var lu = str.split("^");
	var obj;
 	obj=document.getElementById("COVAuxInsTypeDR")
	if ((obj)&&(lu[0])) obj.value = lu[0];
	obj=document.getElementById("COVInsTypeDR")
	if ((obj)&&(lu[1])) obj.value = lu[1];
	
}

//log60223 TEdT
function GroupNumberLookupHandler(str) {
	var lu=str.split("^");
	var obj;
	obj=document.getElementById("COVInsTypeDR")
	if ((obj)&&(lu[2]))obj.value = lu[2];
 	obj=document.getElementById("COVAuxInsTypeDR")
	if ((obj)&&(lu[3])) obj.value = lu[3];
}

document.body.onload=BodyLoadHandler;





