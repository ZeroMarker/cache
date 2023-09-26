
function BodyLoadHandler(){	
	InitPage();
}

function InitPage()
{
	var obj=document.getElementById("BOK");
	if (obj) obj.onclick=BOK_Clicked;
	var obj=document.getElementById("BCancel");
	if (obj) obj.onclick=BCancel_Clicked;
}
function BOK_Clicked()
{
	var FileName=GetElementValue("GetFileName")
	if (trim(FileName)=="")
	{
		alertShow(t["01"]);
		return;
	}
	window.returnValue=FileName;
	window.close();
}
function BCancel_Clicked()
{
	window.returnValue="";
	window.close();
}

document.body.onload = BodyLoadHandler;