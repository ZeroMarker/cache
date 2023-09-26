
function BodyLoadHandler() 
{
	InitPage();
	InitUserInfo(); //系统参数 //2011-02-17 DJ
}

function InitPage()
{
	var obj=document.getElementById("BDetail");
	if (obj) obj.onclick=BDetail_Click;
	
	var obj=document.getElementById("BCancel");
	if (obj) obj.onclick=BCancel_Click;
	
	var obj=document.getElementById("BOK");
	if (obj) obj.onclick=BOK_Click;
	
	var obj=document.getElementById("EquipNo");
	if (obj) obj.onkeydown=EquipNo_KeyDown;
	
	GetDisabledElement();
	
	websys_setfocus("EquipNo");
}

function BDetail_Click()
{
	var EquipDR=GetElementValue("ActerEquipDR")
	if (EquipDR=="") return;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQEquip";
	lnk=lnk+"&ReadOnly=1&RowID="+EquipDR;
	window.open(lnk,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=910,height=700,left=100,top=0')
}

function Clear()
{
	SetElement("BillEquipDR","");
	SetElement("ActerEquipDR","");
	SetElement("BillStoreLocDR","");
	SetElement("BillUseLocDR","");
	///SetElement("ActerStoreLocDR","");
	SetElement("ActerUseLocDR","");
	SetElement("BillStoreLoc","");
	//SetElement("ActerStoreLoc",""); //2011-02-17 DJ
	SetElement("EquipNo","");
	SetElement("Model","");
	SetElement("EquipName","");
	SetElement("OriginalFee","");
}

function FillInfo()
{
	var EquipNo=GetElementValue("EquipNo");
	if (EquipNo=="") return;
	
	var InventoryDR=GetElementValue("InventoryDR");
	if (InventoryDR=="") return;
	
	var encmeth=GetElementValue("GetInfoByEquipNo");
	if (encmeth=="")
	{
		alertShow(t['NoMethod']);
		return;
	}
	
	var StoreLocDR=GetElementValue("ActerStoreLocDR");
	var UseLocDR=GetElementValue("ActerUseLocDR");
	
	var result=cspRunServerMethod(encmeth,InventoryDR, EquipNo,StoreLocDR,UseLocDR);
	///alertShow(result);
	if (result!="")
	{
		var list=result.split("^");

		SetElement("EquipName",list[1]);
		SetElement("Model",list[2]);
		SetElement("BillStoreLocDR",list[3]);
		SetElement("BillUseLocDR",list[4]);
		//SetElement("ActerStoreLocDR",list[5]); //2011-02-17 DJ
		SetElement("ActerUseLocDR",list[6]);
		
		SetElement("OriginalFee",list[7]);
		SetElement("BillNetFee",list[8]);
		SetElement("BillDepreTotalFee",list[9]);
		
		SetElement("BillStoreLoc",list[10]);
		SetElement("BillUseLoc",list[11]);
		///SetElement("ActerStoreLoc",list[12]);
		///SetElement("ActerUseLoc",list[13]);
		SetElement("BillEquipDR",list[14]);
		SetElement("ActerEquipDR",list[14]);
		
		if (list[0]=="0")
		{	alertShow('设备台帐中没有此设备!');	}
		else if (list[0]=="1")
			{	alertShow('该设备已经盘点!');	}
		else if (list[0]=="3")
			{	alertShow('盘点帐中没有此设备!');	}
		else if (list[0]=="4")
			{	alertShow('盘点帐中没有此设备,且已经盘点过该设备!');	}
		if ((list[0]>="0")&&(list[0]<="4")&&(list[0])!="2") //2011-02-17 DJ
		{
			SetElement("EquipNo","")
			websys_setfocus("EquipNo");
		}
	}
}

function EquipNo_KeyDown()
{
	if (event.keyCode==13)
	{
		FillInfo();
	}
}

function BCancel_Click()
{
	window.close();
}

function GetStoreLocID(value)
{
	GetLookUpID('ActerStoreLocDR',value);	
}

function BOK_Click()
{
	if (CheckMustItemNull()) return; //2011-02-17 DJ
	var EquipNo=GetElementValue("EquipNo");
	
	var InventoryDR=GetElementValue("InventoryDR");
	if (InventoryDR=="") return;
	
	var encmeth=GetElementValue("AuditActerEquip");
	if (encmeth=="")
	{
		alertShow(t['NoMethod']);
		return;
	}
	var BillStoreLocDR=GetElementValue("BillStoreLocDR"); //2011-02-17 DJ
	if (BillStoreLocDR=="")
	{
		alertShow("台帐库房不能为空.");
		return;
	}
	var StoreLocDR=GetElementValue("ActerStoreLocDR");
	var UseLocDR=GetElementValue("ActerUseLocDR");
	
	var result=cspRunServerMethod(encmeth,InventoryDR, StoreLocDR, UseLocDR, EquipNo);
	///alertShow(result);
	if (result=="0")
	{
		alertShow(t['AuditSuccess']);
		Clear(); //2011-02-17 DJ
	}
	else
	{
		alertShow(t['AuditFailed']);
	}
	websys_setfocus("EquipNo");
}

document.body.onload = BodyLoadHandler;