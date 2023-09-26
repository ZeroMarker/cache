function BannerBodyLoadHandler() 
{
	LoadData();
	var obj=document.getElementById("BOK");
	if (obj) obj.onclick=BOK_Click;
	
	var obj=document.getElementById("BCancel");
	if (obj) obj.onclick=BCancel_Click;
}

function LoadData()
{
	var data=GetElementValue("OptionData");
	if (data=="") return;
	var obj=document.getElementById("SelectList");
	
	if (!obj) return;
	var list=data.split("^");
	var len=list.length;
	for (var i=0;i<len;i++)
	{
		var temp=list[i];		
		var templist=temp.split(",");
		obj.options.add(new Option(templist[0],templist[1]));		
	}
}

function BOK_Click()
{
	var result=GetSelect();
	if (result=="") return;
	window.returnValue=result;
	window.close();
}

function BCancel_Click()
{
	window.returnValue="";
	window.close();
}

function GetSelect()
{
	var result="";
	var obj=document.getElementById("SelectList");
	var len=obj.options.length;
	for (var i=0;i<len;i++)
	{
		if (obj.options[i].selected) result=result+"^"+obj.options[i].value;		
	}
	if (result!="") result=result.substring(1);
	return result;	
}

document.body.onload = BannerBodyLoadHandler;