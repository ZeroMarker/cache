//INSUDiagnosInfo.js
function BodyLoadHandler() {
	Guser=session['LOGON.USERID']
	var obj=document.getElementById("AdmDr");
	if(obj)
	{
		var AdmDr=obj.value
		//alert(obj.value);
	}
	
}
document.body.onload = BodyLoadHandler;