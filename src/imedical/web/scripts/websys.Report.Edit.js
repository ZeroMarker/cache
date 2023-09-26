// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

//var originalonchange = "";

function DocumentLoadHandler() {
	//var obj=document.getElementById("Type");
	//if (obj)
	//{
   	//	originalonchange = obj.onchange; 	//copy the existing handler
    	//	obj.onchange = crystalChangeHandler; 	// set the new handler
	//}
	//obj=document.getElementById('Type');
	//if (obj) obj.onchange=crystalChangeHandler;
	crystalChangeHandlerCode()
	/*
	for (var i=1; i<10; i++) {
		var PCheck="CheckP"+i;
		EnableCheck(PCheck);
		obj=document.getElementById(PCheck);
		if (obj) obj.onclick=checkboxChangehandler;
	}
	*/
}

// required to populate field for use in crystalChangeHandler
function typeByLookUp(str) {
	var lu = str.split("^");	
	var obj
	obj=document.getElementById('Type')
	crystalChangeHandler(null);
	if (obj) obj.value = lu[0];
}

function EnableField(fldName) {
	var fld = document.getElementById(fldName);
	//var lbl = document.getElementById('c'+fldName);
	if (fld) {
		fld.disabled = false;
		fld.className = "";
		//if (lbl) lbl = lbl.className = "clsRequired";
	}
}
function DisableField(fldName) {
	var fld = document.getElementById(fldName);
	//var lbl = document.getElementById('c'+fldName);
	if ((fld)&&(fld.tagName=="INPUT")) {
		fld.value = "";
		fld.disabled = true;
		fld.className = "disabledField";
		//if (lbl) lbl = lbl.className = "";
	}
}
function crystalChangeHandlerCode()
{
	var obj = document.getElementById('Type');
	if ((obj)&&(obj.value.toUpperCase()=="CRYSTAL")) {			
		//Disables all PName fields and default value with promptn
		for (var i=1; i<10; i++) {
			var PName="P"+i+"Name";
			//var PCheck="CheckP"+i;
			DisableField(PName);			
			//EnableCheck(PCheck);
			//GR need to have it disabled unless there is a cache expression
			var Pobj = document.getElementById(PName);
			var j=i-1;
			if (Pobj) Pobj.value = "Prompt"+j;
		}
		//MK - L: 28639
		EnableField("ReportUrl");
		EnableField("DSN");
		DisableField("Expression");
	} else {
		for (var i=1; i<10; i++) {
			//var PCheck="CheckP"+i;
			var PName="P"+i+"Name";
			//DisableField(PCheck);
			EnableField(PName);	
			//KK 19/Dec/2002 Log 31401 Commented the following lines as it was clearing the values in the paramter fields.
			//var Pobj = document.getElementById(PName);
			//if (Pobj) Pobj.value = "";
		}
		//MK - L: 28639
		//alert(obj.value.toUpperCase());
		if ((obj)&&(obj.value.toUpperCase()=="CACHE+CRYSTAL"))
		{
			EnableField("ReportUrl");
			EnableField("DSN");
			EnableField("Expression");				
		}
		else	//Cache or other
		{
			DisableField("ReportUrl");
			DisableField("DSN");
			EnableField("Expression");
		}
	}
}

//function crystalChangeHandler() {
	//if (typeof originalonchange != "function") originalonchange = new Function(originalonchange);
	//originalonchange();
	//crystalChangeHandlerCode();
//}

/*
function EnableCheck(fldName) {
	var fld = document.getElementById(fldName);
	var expr = document.getElementById("Expression");
	var obj = document.getElementById('Type');
	if ((fld)&&(expr)&&(obj)&&(obj.value=="Crystal")) {
		if (expr.value=="") {
			fld.disabled = true;
		} else {
			fld.disabled = false;
		}
	}
}
function checkboxChangehandler() {
	alert ("change");
	for (var i=1; i<10; i++) {
		var Chkname="CheckP"+i;
		var Chkobj=document.getElementById(Chkname);
		var PName="P"+i+"Name";	
		var Pobj=document.getElementById(PName);
		if ((Chkobj)&&(Chkobj.checked==true)) {
			if (Pobj) {
				EnableField(PName);
				Pobj.value="";
				Pobj.focus();
			}
		} else {
			var j=i-1;
			if (Pobj) {
				DisableField(PName);
				Pobj.value = "Prompt"+j;
			}
		}
	}
}
function ExpressionChangeHandler(){
	for (var i=1; i<10; i++) {
		var PCheck="CheckP"+i;
		EnableCheck(PCheck);
		//GR need to have it disabled unless there is a cache expression
	}
}
expobj=document.getElementById('Expression');
if (expobj) expobj.onchange=ExpressionChangeHandler;
*/
document.body.onload = DocumentLoadHandler;