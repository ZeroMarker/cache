
/// -------------------------------
/// �޸�:ZY  2009-07-06  BugNo.ZY0007
/// �޸�����:���Ӻ���MovType
/// ��������:�޸��豸ת�����͵�ʱ��?���������Һͽ��ܿ��Ҵ��ݲ�ͬ�Ŀ������Ͳ���
/// --------------------------------
function BodyLoadHandler(){
	InitUserInfo();	
	InitPage();	
	SetBEnable();
	SetStatus();
	SetElement("MoveType",GetElementValue("MoveTypeID"))
}

function SetStatus()
{
	SetElement("Status",GetElementValue("GetStatu"))
}
function InitPage()
{
	KeyUp("FromLoc^ToLoc");
	Muilt_LookUp("FromLoc^ToLoc");
	///zy 2009-07-15 BugNo.ZY0007
	var obj=document.getElementById("MoveType");
	if (obj) obj.onchange=MoveType;
	////////////////////

}
function GetFromLoc(value)
{
	GetLookUpID("FromLocDR",value);
}
function GetToLoc(value)
{
	GetLookUpID("ToLocDR",value);
}
function SetBEnable()
{
	var WaitAD=GetElementValue("WaitAD");
	if (WaitAD!="off")
	{
		DisableBElement("BAddNew",true);
	}
}
/// ����:zy 2009-07-15 BugNo.ZY0007
/// ��������?MoveType
/// ����:�޸��豸ת�����͵�ʱ��?���������Һͽ��ܿ��Ҵ��ݲ�ͬ�Ŀ������Ͳ���
/// -------------------------------
function MoveType()
{
	var value=GetElementValue("MoveType")
	if (value=="0")
	{
		SetElement("FromLocType","0101");
		SetElement("ToLocType","0102");
	}else if (value=="3")
	{
		SetElement("FromLocType","0102");
		SetElement("ToLocType","0101");
	}else
	{
		SetElement("FromLocType","0102");
		SetElement("ToLocType","0102");
	}
}
//////////

document.body.onload = BodyLoadHandler;