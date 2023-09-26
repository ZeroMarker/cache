//INSUBZInfo.js
function BodyLoadHandler() {
	Guser=session['LOGON.USERID']
	//var obj=document.getElementById("AdmDr");
	//if(obj)
	//{
	//	var AdmDr=obj.value
	//}
	var obj=document.getElementById("TarDr");
	if(obj){TarDr=obj.value}
	
	var Ins=document.getElementById('getybbzInfo');
	if (Ins) {var encmeth=Ins.value} else {var encmeth=''};
	var Demo=cspRunServerMethod(encmeth,TarDr);
	var obj=document.getElementById("Tybbz");
	obj.value=Demo
}
document.body.onload = BodyLoadHandler;