///修改: ZY 2009-11-17 ZY0017
///修改函数BPrint_Click
///描述:导出时保存路径的设置
/// -------------------------------
/// 修改:ZY  2009-07-06  BugNo.ZY0007
/// 修改描述:增加函数MovType
/// 作用描述:修改设备转移类型的时候??给供给科室和接受科室传递不同的科室类型参数
/// --------------------------------
function BodyLoadHandler(){	
	InitPage();	
	//SetElement("MoveType",GetElementValue("MoveTypeID"));
}

function InitPage()
{
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
}

function BFind_Click()
{
	var val="&SourceType="+GetElementValue("SourceType")
	val=val+"&NameStr="+GetElementValue("NameStr")
	val=val+"&StrDate="+GetElementValue("StrDate")
	val=val+"&EndDate="+GetElementValue("EndDate")
	window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCheckResultFind"+val;
}
document.body.onload = BodyLoadHandler;
