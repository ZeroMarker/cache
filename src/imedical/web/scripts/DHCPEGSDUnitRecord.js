function BodyLoadHandler()
{
	var obj=document.getElementById("BClose");
	if (obj) obj.onclick=BClose_click;
}
function BClose_click()
{
	if (opener) opener.location.reload();
	window.close();
}
function CancelUnitRecord(e)
{
	var obj,GSSID="",encmeth="";
	GSSID=e.id;
	obj=document.getElementById("CancelUnitClass");
	if (obj) encmeth=obj.value;
	var ret=cspRunServerMethod(encmeth,GSSID);
	var Arr=ret.split("^");
	if (Arr[0]==0) BClose_click();
}
document.body.onload = BodyLoadHandler;