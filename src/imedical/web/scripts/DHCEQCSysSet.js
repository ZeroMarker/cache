//设备系统配置表
function BodyLoadHandler() 
{	
  
	InitUserInfo();
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
}
function BUpdate_Click()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCSysSet');//+组件名 就是你的组件显示 Query 结果的部分
	var rows=objtbl.rows.length;
	var combindata="";
	//alertShow("rows:"+rows)
	for (i=1;i<rows;i++)
		{
	combindata=combindata+"^"+GetElementValue("TRowIDz"+i);
	combindata=combindata+"^"+GetElementValue("TValuez"+i); ;//值
	combindata=combindata+"^"+GetCElementValue("TDescz"+i); ;//描述
	combindata=combindata+"^"+GetElementValue("TRemarkz"+i); ;//备注
	combindata=combindata+"^"+GetElementValue("TAddValuez"+i); ;//值
	combindata=combindata+"^"+";"
		}		
			SetData(combindata,rows);//调用函数	
}
function SetData(combindata,rows)
{
	//alertShow("combindata"+combindata)
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',combindata,rows);
	var plist=gbldata.split("^");
	//alertShow("plist"+plist)
    location.reload();
}
document.body.onload = BodyLoadHandler;