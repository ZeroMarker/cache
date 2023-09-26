//设备计数器
function BodyLoadHandler() 
{  
	InitUserInfo();
	InitEvent();
	SetDisable();
}

function InitEvent()
{
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCCounter');//+组件名 就是你的组件显示 Query 结果的部分
	var rows=objtbl.rows.length;
	for (i=1;i<rows;i++)
	{		
		var obj=document.getElementById("TGroupFlagz"+i);
		if (obj) obj.onclick=BGroupFlag_Click;
	}
	
}
function BUpdate_Click()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCCounter');//+组件名 就是你的组件显示 Query 结果的部分
	var rows=objtbl.rows.length;
	var combindata="";
	for (i=1;i<rows;i++)
	{
		combindata=combindata+"^"+GetElementValue("TRowIDz"+i);
		combindata=combindata+"^"+GetElementValue("TCounterNumz"+i); ;//值
		combindata=combindata+"^"+GetElementValue("TypeDRz"+i); ;//描述
		combindata=combindata+"^"+GetElementValue("TLengthz"+i); ;//备注
		combindata=combindata+"^"+GetElementValue("TPrefixz"+i); ;//前缀
		combindata=combindata+"^"+GetElementValue("TSuffixz"+i); ;//后缀
		combindata=combindata+"^"+GetChkElementValue("TGroupFlagz"+i); ;//是否分组
		combindata=combindata+"^"+GetElementValue("TGroupz"+i); ;//分组字符串
		combindata=combindata+"^"+GetElementValue("THold1z"+i); ;//保留1
		combindata=combindata+"^"+GetElementValue("THold2z"+i); ;//保留2
		combindata=combindata+"^"+GetElementValue("THold3z"+i); ;//保留3
		combindata=combindata+"^"+";"
	}
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',combindata);
	if (gbldata!=0)
	{
		alertShow(t[-2201])
		return
	}
	else
	{
		location.reload();
	}
}
function BGroupFlag_Click()
{
	var i=GetTableCurRow();
	var obj=document.getElementById("TGroupFlagz"+i);
	if (obj.checked==true)
	{
		DisableElement("TCounterNumz"+i,true)
		DisableElement("TGroupz"+i,false)
	}
	else
	{
		DisableElement("TCounterNumz"+i,false)
		DisableElement("TGroupz"+i,true)
	}
	
}
function SetDisable()
{	
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCCounter');//+组件名 就是你的组件显示 Query 结果的部分
	var rows=objtbl.rows.length;
	var combindata="";
	for (i=1;i<rows;i++)
	{		
		var GroupFlag=GetChkElementValue("TGroupFlagz"+i)
		if (GroupFlag==true)
		{
			DisableElement("TCounterNumz"+i,true)
		}
		else
		{
			DisableElement("TGroupz"+i,true)
		}
	}
}
document.body.onload = BodyLoadHandler;