
/// -------------------------------
/// 修改:ZY  2009-07-06  BugNo.ZY0007
/// 修改描述:增加函数MovType
/// 作用描述:修改设备转移类型的时候?给供给科室和接受科室传递不同的科室类型参数
/// --------------------------------
///modify by jyp 2018-08-16 Hisui改造：添加initButtonWidth()方法控制按钮长度，BFind绑定点击事件
function BodyLoadHandler(){
	initButtonWidth(); //add by jyp 2018-08-16
	InitUserInfo();	
	InitPage();	
	SetBEnable();
	SetStatus();
	SetElement("MoveType",GetElementValue("MoveTypeID"))
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
	
	// add by ZX 2018-11-03 hisui调整
	var obj=document.getElementById("BAddNew");
	if (obj) obj.onclick=BAdd_Clicked;
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
// add by JYP 2018-08-09 hisui调整
function BFind_Click()
{
	$("#DHCEQStoreMoveFind").datagrid("load");
   return ;	
}

// add by ZX 2018-11-03 hisui调整
//modified by csj 2020-03-23 需求号：1217727
function BAdd_Clicked()
{
	if (!$(this).linkbutton('options').disabled){	
		var val="&RowID=&QXType=&WaitAD=off";
		url="dhceq.em.storemove.csp?"+val;
		showWindow(url,"转移申请单","","","icon-w-paper","modal","","","large");  //modify by lmm 2020-06-04 UI
	}
}
document.body.onload = BodyLoadHandler;