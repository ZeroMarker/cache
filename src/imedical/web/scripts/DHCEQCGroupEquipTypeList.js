//��ȫ������豸����
function BodyLoadHandler() 
{
	InitUserInfo();
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
}
function BUpdate_Click() 
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCGroupEquipTypeList');//+����� ������������ʾ Query ����Ĳ���
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var Flag=false;
	for (var j=1;j<rows;j++)
	{
		var Default=GetChkElementValue("TDefaultz"+j);
		if ((Default)&&(Flag))
		{
			alertShow(t["01"]);
			return;
		}
		if (Default) Flag=true;
	}
	for (var i=1;i<rows;i++)
	{
		var RowID=GetElementValue("RowID")
		var Codetable=GetElementValue("TRowIDz"+i);
		var Depre=GetChkElementValue("TPutInz"+i);
		var Default=GetChkElementValue("TDefaultz"+i);
		if (Default)
		{
			Default="Y";
		}
		else
		{
			Default="N";
		}
		if (Depre==true)
		{
			var isDel="1";
			var ReturnInfo=SetData(RowID,Codetable,isDel,Default);//���ú���	
		}
		if(Depre==false)
		{
			var isDel="2";
			var ReturnInfo=SetData(RowID,Codetable,isDel,Default);
		}
	}
	if (ReturnInfo>0)
	{
		alertShow("����ɹ�!")
		location.reload();
	}
	else
	{
		alertShow("����ʧ��!")
		return
	}	
}	
function SetData(RowID,Codetable,isDel,Default)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',RowID,Codetable,isDel,Default);
	return gbldata
}	

document.body.onload = BodyLoadHandler;	