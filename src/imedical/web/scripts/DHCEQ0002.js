function BPrint1_Clicked()
{
	UserDefinedPrint("DHCEQ0002","DHCEQArgumentation2.xls")
}
function BPrint2_Clicked()
{
	UserDefinedPrint("DHCEQ0003","DHCEQFeasibilityReport.xls")
}
function BPrint3_Clicked()
{
	UserDefinedPrint("DHCEQ0004","DHCEQLocDiscuss.xls")
}
function OtherSet()
{
	var obj=document.getElementById("B_LocIsYesFlag");
	if (obj) obj.onclick=LocIsYesFlag_Clicked;
	var obj=document.getElementById("B_LocIsNoFlag");
	if (obj) obj.onclick=LocIsNoFlag_Clicked;
	var obj=document.getElementById("B_HospIsYesFlag");
	if (obj) obj.onclick=HospIsYesFlag_Clicked;
	var obj=document.getElementById("B_HospIsNoFlag");
	if (obj) obj.onclick=HospIsNoFlag_Clicked;
	//其他资金来源
	var obj=document.getElementById("FundsOrigin4");
	if (obj.checked)
	{
		DisableElement("B_OFundsTypeName",false);
	}
	else
	{
		DisableElement("B_OFundsTypeName",true);
		SetElement("B_OFundsTypeName","");
	}
	//本科存在同类设备
	LocIsYesFlag_Clicked()
	//本科不存在同类设备
	LocIsNoFlag_Clicked()
	//本院存在同类设备
	HospIsYesFlag_Clicked()
	//本院不存在同类设备
	HospIsNoFlag_Clicked()
}

function LocIsYesFlag_Clicked()
{
	var obj=document.getElementById("B_LocIsYesFlag");
	if (obj.checked)
	{
		DisableElement("B_LocIsYesNum",false);
		SetChkElement("B_LocIsNoFlag",0)
	}
	else
	{
		DisableElement("B_LocIsYesNum",true);
		SetElement("B_LocIsYesNum","");
	}
}
function LocIsNoFlag_Clicked()
{
	var obj=document.getElementById("B_LocIsNoFlag");
	if (obj.checked)
	{
		SetChkElement("B_LocIsYesFlag",0)
		DisableElement("B_LocIsYesNum",true);
		SetElement("B_LocIsYesNum","");
	}
}
function HospIsYesFlag_Clicked()
{
	var obj=document.getElementById("B_HospIsYesFlag");
	if (obj.checked)
	{
		DisableElement("B_HospIsYesLocName",false);
		SetChkElement("B_HospIsNoFlag",0)
	}
	else
	{
		DisableElement("B_HospIsYesLocName",true);
		SetElement("B_HospIsYesLocName","");
	}
}
function HospIsNoFlag_Clicked()
{
	var obj=document.getElementById("B_HospIsNoFlag");
	if (obj.checked)
	{
		SetChkElement("B_HospIsYesFlag",0)
		DisableElement("B_HospIsYesLocName",true);
		SetElement("B_HospIsYesLocName","");
	}
}

function CheckData()
{
	var LocIsYesNum=GetElementValue("B_LocIsYesNum");
	if  (LocIsYesNum!="")
	{
		if (isNaN(LocIsYesNum)||(LocIsYesNum<=0))
		{
			alertShow("本科室同类设备存在台数录入有误!")
			return 1
		}
		LocIsYesNum=LocIsYesNum*1
		var LocNum=LocIsYesNum.toFixed(0);
		if (LocIsYesNum!=LocNum)
		{
			alertShow("本科室同类设备存在台数只能录入整数!")
			return 1
		}
	}
	var HospPrice1=GetElementValue("B_HospPrice1");
	if  (HospPrice1!="")
	{
		if (isNaN(HospPrice1)||(HospPrice1<=0))
		{
			alertShow("国内同类设备价格录入有误!")
			return 1
		}
	}
	var HospPrice2=GetElementValue("B_HospPrice2");
	if  (HospPrice2!="")
	{
		if (isNaN(HospPrice2)||(HospPrice2<=0))
		{
			alertShow("国内同类设备价格录入有误!")
			return 1
		}
	}
	var HospPrice3=GetElementValue("B_HospPrice3");
	if  (HospPrice3!="")
	{
		if (isNaN(HospPrice3)||(HospPrice3<=0))
		{
			alertShow("国内同类设备价格录入有误!")
			return 1
		}
	}
	var FHospPrice1=GetElementValue("B_FHospPrice1");
	if  (FHospPrice1!="")
	{
		if (isNaN(FHospPrice1)||(FHospPrice1<=0))
		{
			alertShow("国外同类设备价格录入有误!")
			return 1
		}
	}
	var FHospPrice2=GetElementValue("B_FHospPrice2");
	if  (FHospPrice2!="")
	{
		if (isNaN(FHospPrice2)||(FHospPrice2<=0))
		{
			alertShow("国外同类设备价格录入有误!")
			return 1
		}
	}
	var FHospPrice3=GetElementValue("B_FHospPrice3");
	if  (FHospPrice3!="")
	{
		if (isNaN(FHospPrice3)||(FHospPrice3<=0))
		{
			alertShow("国外同类设备价格录入有误!")
			return 1
		}
	}
	return 0
}