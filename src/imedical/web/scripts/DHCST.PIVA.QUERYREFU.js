/// DHCST.PIVA.QUERYREFU
function BodyLoadHandler()
{
	var obj=document.getElementById("bClose");
	if (obj) obj.onclick=CloseWin;
}
/// �ر�
function CloseWin()
{
	window.close();
}

document.body.onload=BodyLoadHandler;