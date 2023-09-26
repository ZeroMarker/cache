/// DHCST.PIVA.QUERYREFU
function BodyLoadHandler()
{
	var obj=document.getElementById("bClose");
	if (obj) obj.onclick=CloseWin;
}
/// ¹Ø±Õ
function CloseWin()
{
	window.close();
}

document.body.onload=BodyLoadHandler;