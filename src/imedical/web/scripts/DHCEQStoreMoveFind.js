
/// -------------------------------
/// 修改:ZY  2009-07-06  BugNo.ZY0007
/// 修改描述:增加函数MovType
/// 作用描述:修改设备转移类型的时候?给供给科室和接受科室传递不同的科室类型参数
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
/// 创建:zy 2009-07-15 BugNo.ZY0007
/// 创建函数?MoveType
/// 描述:修改设备转移类型的时候?给供给科室和接受科室传递不同的科室类型参数
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