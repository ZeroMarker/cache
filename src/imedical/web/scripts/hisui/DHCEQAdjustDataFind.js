///----------------------------------------------
/// add by zy 2011-09-25 ZY0080
/// Description:���ݵ���
var Component="DHCEQAdjustDataA"
function BodyLoadHandler()
{
    InitElementValue();
	InitUserInfo(); //ϵͳ����
	InitEvent();
}
function InitEvent()
{
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
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
	val='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQAdjustDataFind'+val;  //hisui ���� add by wy 2019-10-28
    window.location.href=val
}
//hisui���� add wy 2019-10-30
function BAdd_Click()
{
	var Component="DHCEQAdjustDataA"
	var UserFlag=GetElementValue("UserFlag")
	var vType=GetElementValue("vType")
	if (GetElementValue("UserFlag")=="false")
	{
		Component="DHCEQAdjustDataB"
		if (GetElementValue("vType")=="5")
		{
			Component="DHCEQAdjustDataC"
		}
	}
	url="websys.default.hisui.csp?WEBSYS.TCOMPONENT="+Component+"&UserFlag="+UserFlag+"&vType="+vType
	showWindow(url,"���ݵ���","","9row","icon-w-paper","modal","","","large");
	
}
document.body.onload = BodyLoadHandler;