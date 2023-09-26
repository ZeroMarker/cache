//dhcpha.SendToAuto
function BodyLoadHandler()
{
	var obj;
	obj=document.getElementById("bSendAuto");
	if (obj) obj.onclick=bSendAutoClick;
}
function bSendAutoClick()
{
	var objen=document.getElementById('mSend');
	if (objen) {var encmeth=objen.value} else {var encmeth=''};
	var ret=cspRunServerMethod(encmeth);
	if (ret!=0) {alert("发送错误:错误信息"+ret)}
	else {alert("发送成功")};
}
document.body.onload=BodyLoadHandler;