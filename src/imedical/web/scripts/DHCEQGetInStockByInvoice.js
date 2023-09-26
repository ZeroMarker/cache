
function BodyLoadHandler(){	
	InitPage();
}

function InitPage()
{
	var obj=document.getElementById("BOK");
	if (obj) obj.onclick=BOK_Clicked;
	var obj=document.getElementById("BCancel");
	if (obj) obj.onclick=BCancel_Clicked;
	var Type=GetElementValue("Type")
	if (Type=="0") DisableBElement("BOK",true);
}
function BOK_Clicked()
{
	window.returnValue="1";
	window.close();
}
function BCancel_Clicked()
{
	window.returnValue="";
	window.close();
}

document.body.onload = BodyLoadHandler;