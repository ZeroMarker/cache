// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

if (parent.frames["FindMRRequestList"])	document.forms['fRTRequest_Find'].target="FindMRRequestList";
var ChrCode='';
function UROnChangeHandler(evt) {
	ChrCode='';
	if ( ((URobj)&&(URobj.value!="")) || ((Robj)&&(Robj.value!=""))  || ((Vobj)&&(Vobj.value!=""))) {
		find1_click();
	}
	SelectField();
	var Fobj=document.getElementById("find1");
	if (Fobj) Fobj.disabled=false;
	return true;
}
//websys_sckeys[tsc['find1']]=UROnChangeHandler;

function SelectField() {
	var URobj=document.getElementById("UR");
	//if (URobj) URobj.select();
}

function URSelectHandler(str) {
	//alert(str);
	var lu=str.split("^");
	var obj=document.getElementById("UR");
	if (obj) obj.value=lu[0];
	
}

function UR_changehandler(encmeth) {	//have to have for broker only!!!
	UROnChangeHandler();
	var obj=document.getElementById('UR');
	var p1='';
	if (obj) p1=obj.value;
	var obj=document.getElementById('UR');
	if (cspRunServerMethod(encmeth,'','URSelectHandler',p1)=='0') {
		obj.className='clsInvalid';  ///generic name to check all fields. 
		obj.focus();
		return websys_cancel();
	} else {
		obj.className='';
	}
}

var URobj=document.getElementById("UR");
//if (URobj) URobj.onchange=UROnChangeHandler;
//if (URobj) URobj.onblur=SelectField;

var Robj=document.getElementById("RequestID");
if (Robj) Robj.onchange=UROnChangeHandler;


var Vobj=document.getElementById("VolDesc");
if (Vobj) Vobj.onchange=UROnChangeHandler;








