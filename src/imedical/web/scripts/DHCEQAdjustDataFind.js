///----------------------------------------------
/// add by zy 2011-09-25 ZY0080
/// Description:数据调整
var Component="DHCEQAdjustDataA"
function BodyLoadHandler()
{
    InitElementValue();
	InitUserInfo(); //系统参数
	InitEvent();
}
function InitEvent()
{
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
}

function InitElementValue()
{
	var UserFlag=GetElementValue("UserFlag")
	if (UserFlag=="true")
	{
		SetElement("Type","1")
	}
	else
	{
		Component="DHCEQAdjustDataB"
	}
	var TypeDR=GetElementValue("TypeDR")
	SetElement("Type",TypeDR)
}
function BFind_Click()
{
	var val="";
    val="&UserFlag="+GetElementValue("UserFlag") ;
    val=val+"&TypeDR="+GetElementValue("Type");
    val=val+"&BeginDate="+GetElementValue("BeginDate") ;
    val=val+"&EndDate="+GetElementValue("EndDate") ;
    val=val+"&ReportFlag="+GetChkElementValue("ReportFlag") 
    val=val+"&RequestUser="+GetElementValue("RequestUser") 
	val='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQAdjustDataFind'+val;
    window.location.href=val
}
document.body.onload = BodyLoadHandler;