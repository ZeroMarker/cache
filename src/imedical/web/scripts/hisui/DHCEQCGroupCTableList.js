//��ȫ������豸����	add by wjt 2019-02-19
function BodyLoadHandler() 
{
	InitUserInfo();
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
}
function BUpdate_Click() 
{
	var eSrc=window.event.srcElement;
	//var objtbl=document.getElementById('tDHCEQCGroupCTableList');//+����� ������������ʾ Query ����Ĳ���
	//var rows=objtbl.rows.length;
	//var lastrowindex=rows - 1;
	var objtbl=$('#tDHCEQCGroupCTableList').datagrid('getRows')
	var rows=objtbl.length
	for (i=0;i<rows;i++)
	{
		var RowID=GetElementValue("RowID")
		var Codetable=objtbl[i].TRowID
		var Depre=getColumnValue(i,"TPutIn")
		if (Depre==1)
		{
			var isDel="1"
			var Returninfo=SetData(RowID,Codetable,isDel);//���ú���	
		}
		if (Depre==0)
		{
			var isDel="2"
			var Returninfo=SetData(RowID,Codetable,isDel)
		}
	}
	if (Returninfo>0)
	{
		//alertShow("����ɹ�!")
		messageShow("","","",t["02"]);
		location.reload();
	}
	else
	{
		//alertShow("����ʧ��!")
		messageShow("","","",t["01"]);
		return
	}	
}	
function SetData(RowID,Codetable,isDel)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',RowID,Codetable,isDel);
	return gbldata
	//var plist=gbldata.split("^");
	//alertShow("plist"+plist)
}	

document.body.onload = BodyLoadHandler;	