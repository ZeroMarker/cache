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
	//�����ʽ���Դ
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
	//���ƴ���ͬ���豸
	LocIsYesFlag_Clicked()
	//���Ʋ�����ͬ���豸
	LocIsNoFlag_Clicked()
	//��Ժ����ͬ���豸
	HospIsYesFlag_Clicked()
	//��Ժ������ͬ���豸
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
			alertShow("������ͬ���豸����̨��¼������!")
			return 1
		}
		LocIsYesNum=LocIsYesNum*1
		var LocNum=LocIsYesNum.toFixed(0);
		if (LocIsYesNum!=LocNum)
		{
			alertShow("������ͬ���豸����̨��ֻ��¼������!")
			return 1
		}
	}
	var HospPrice1=GetElementValue("B_HospPrice1");
	if  (HospPrice1!="")
	{
		if (isNaN(HospPrice1)||(HospPrice1<=0))
		{
			alertShow("����ͬ���豸�۸�¼������!")
			return 1
		}
	}
	var HospPrice2=GetElementValue("B_HospPrice2");
	if  (HospPrice2!="")
	{
		if (isNaN(HospPrice2)||(HospPrice2<=0))
		{
			alertShow("����ͬ���豸�۸�¼������!")
			return 1
		}
	}
	var HospPrice3=GetElementValue("B_HospPrice3");
	if  (HospPrice3!="")
	{
		if (isNaN(HospPrice3)||(HospPrice3<=0))
		{
			alertShow("����ͬ���豸�۸�¼������!")
			return 1
		}
	}
	var FHospPrice1=GetElementValue("B_FHospPrice1");
	if  (FHospPrice1!="")
	{
		if (isNaN(FHospPrice1)||(FHospPrice1<=0))
		{
			alertShow("����ͬ���豸�۸�¼������!")
			return 1
		}
	}
	var FHospPrice2=GetElementValue("B_FHospPrice2");
	if  (FHospPrice2!="")
	{
		if (isNaN(FHospPrice2)||(FHospPrice2<=0))
		{
			alertShow("����ͬ���豸�۸�¼������!")
			return 1
		}
	}
	var FHospPrice3=GetElementValue("B_FHospPrice3");
	if  (FHospPrice3!="")
	{
		if (isNaN(FHospPrice3)||(FHospPrice3<=0))
		{
			alertShow("����ͬ���豸�۸�¼������!")
			return 1
		}
	}
	return 0
}