//װ��ҳ��  �������ƹ̶�
function BodyLoadHandler() {
	InitUserInfo();
	InitEvent();	//��ʼ��
	FillData()
}

function InitEvent() //��ʼ��
{
	var obj=document.getElementById("BOK");
	if (obj) obj.onclick=BOK_Click;
	var obj=document.getElementById("BCancel");
	if (obj) obj.onclick=BCancel_Click;
}

function FillData()
{
	var InventoryDR=GetElementValue("InventoryDR")
	var FilterInfo=GetElementValue("FilterInfo")
	if (InventoryDR!="")
	{
		var encmeth=GetElementValue("FillData");
		var result=cspRunServerMethod(encmeth,InventoryDR);
		SetData(result)
	}
	if (FilterInfo!="")
	{
		SetData(FilterInfo)
	}

}

function SetData(value)
{
	var list=value.split("|");
	for (var i=1;i<=list.length;i++)
	{
		var listinfo=list[i-1].split(":")
		if (listinfo[0]=="0")
		{
			if (listinfo[1]>0)
			{
				DisableBElement("BOK",true);
			}
		}
		else
		{
			SetElement(listinfo[0],listinfo[1]);
		}
	}
}

function BOK_Click()
{
	var FilterInfo=""
	FilterInfo=FilterInfo+"EquipName:"+GetElementValue("EquipName");
	FilterInfo=FilterInfo+"|OriginalFeeStart:"+GetElementValue("OriginalFeeStart");
	FilterInfo=FilterInfo+"|OriginalFeeEnd:"+GetElementValue("OriginalFeeEnd");
	FilterInfo=FilterInfo+"|StartDate:"+GetElementValue("StartDate");
	FilterInfo=FilterInfo+"|EndDate:"+GetElementValue("EndDate");
	var obj=opener.document.getElementById("FilterInfo");
	if (obj) obj.value=FilterInfo
	window.close()
}

function BCancel_Click() 
{
	window.close()
}
//����ҳ����ط���
document.body.onload = BodyLoadHandler;
