//安全组访问配件代码
function BodyLoadHandler() 
{
	InitUserInfo();
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
}
function BUpdate_Click() 
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCGroupATableList');//+组件名 就是你的组件显示 Query 结果的部分
	var rows=objtbl.rows.length;
	var lastrowindex=rows-1;
	for (i=1;i<rows;i++)
		{
		var RowID=GetElementValue("RowID")
		var Codetable=GetElementValue("TRowIDz"+i);
		var Depre=GetChkElementValue("TPutInz"+i)
		if (Depre==true)
			{
				var isDel="1"
			SetData(RowID,Codetable,isDel);//调用函数	
			}
		if(Depre==false)
			{
				var isDel="2"
				SetData(RowID,Codetable,isDel)
			}
		}
	location.reload();	
	}	
function SetData(RowID,Codetable,isDel)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',RowID,Codetable,isDel);
	var plist=gbldata.split("^");
	//alertShow("plist"+plist)
}	

document.body.onload = BodyLoadHandler;	