///----------------------------------------------
/// add by zy 2011-09-25 ZY0080
/// Description:数据调整
var Component="DHCEQAdjustDataA"
function BodyLoadHandler()
{
    InitElementValue();
	InitUserInfo(); //系统参数
	InitEvent();
	initPanelHeaderStyle();
	initButtonColor();//cjc 2023-01-18 设置极简积极按钮颜色
	hidePanelTitle();//cjc 2023-02-01 隐藏标题面版
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
    val=val+"&vType="+GetElementValue("vType");   //add by wy 2021-3-8 1790838
	val='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQAdjustDataFind'+val;  //hisui 改造 add by wy 2019-10-28
    if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		val += "&MWToken="+websys_getMWToken()
	}
    window.location.href=val
}
//hisui改造 add wy 2019-10-30
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
	//modify by cjc 20230215 3193878
	if(Component="DHCEQAdjustDataA"){
		showWindow(url,"数据调整","","7row","icon-w-paper","modal","","","large");
	}else{
		showWindow(url,"数据调整","","9row","icon-w-paper","modal","","","large");
	}
	
}
document.body.onload = BodyLoadHandler;
