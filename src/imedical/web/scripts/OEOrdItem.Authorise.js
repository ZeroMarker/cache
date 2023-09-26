
function DisableAll_Handler() {
	
	DisableField("OEORIAuthorisedDate","");
	DisableField("OEORIAuthorisedTime","");
	DisableField("OEORIAuthComments","");
	DisableField("UserCode","");
	DisableField("PIN","");
	DisableField("update1","");
}

function UserNameSelectHandler(str) {
	var lu = str.split("^");
	var obj=document.getElementById("UserName")
	if (obj) obj.innerText = lu[1];

}

function UserCode_changehandler(encmeth) {	//have to have for broker only!!!
	var obj=document.getElementById('UserCode');
	var p1='';
	if (obj) p1=obj.value;
	var obj=document.getElementById('UserCode');
	if (cspRunServerMethod(encmeth,'','UserNameSelectHandler',p1)=='0') {
		obj.className='clsInvalid';  ///generic name to check all fields. 
		obj.focus();
		return websys_cancel();
	} else {
		obj.className='';
	}
}


function DisableField(fldName,icN) {
	var fld = document.getElementById(fldName);
	if (fld) {
		fld.disabled = true;
	}
	if (icN) {
		var objIcon=document.getElementById(icN);
		if (objIcon) objIcon.style.visibility = "hidden";
	}

}

function UpdateClickHandler() {

}

function EPR_getTopWindow() {
	var winf = null;
	if (window.top != window.self) winf = window.top;
	return winf
}

function LoadHandler() {
	//var alobj=document.getElementById("OS");
	//	if (alobj) alert("OS" + alobj.value);

	
	var ReadOnly=document.getElementById("ReadOnly");
	
	
	if (ReadOnly && (ReadOnly.value=="1")) {

		DisableAll_Handler()
	
		var UPDATE=document.getElementById("update1");
		if (UPDATE) UPDATE.onclick=UpdateClickHandler;
	}

	
}

document.body.onload=LoadHandler;




