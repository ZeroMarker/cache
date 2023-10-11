// DHCEQBuyPlanFind.js
/// ----------------------------------------------
/// Modified By HZY 2011-10-18 HZY0016
/// 修改函数:SetEnabled
/// Desc:当Type!="0"时,屏蔽?新增(New)?按钮
/// ---------------------------------------------- 
function BodyLoadHandler()
{
	InitUserInfo();		
	InitPage();
	SetEnabled();
	SetElement("PlanTypeList",GetElementValue("PlanTypeListDR"))
	initButtonWidth()  //hisui改造 add by lmm 2018-08-20
	initPanelHeaderStyle();
	if ((typeof(HISUIStyleCode)!='undefined')&&(HISUIStyleCode=="lite")){
		// 极简版
		$("#BAddNew").css({"background-color":"#28ba05","color":"#ffffff"})
	}
}


function GetRowByColName(colname)
{
	var offset=colname.lastIndexOf("z");
	var row=colname.substring(offset+1);
	return row;
}

function SetEnabled()
{
	var Type=GetElementValue("Type");
	if (Type!="0")
	{
		DisableBElement("BAdd",true);
		DisableBElement("BAddNew",true);	//屏蔽"新增(New)"按钮. Add By HZY 2011-10-18 HZY0016.
	}
	else
	{
//		EQCommon_HiddenElement("WaitAD");   //hisui改造 modify by lmm 2018-08-18
		//hisui改造 modify by lmm 2019-09-20  隐藏勾选框
		//$(".hischeckbox_square-blue").css("display","none")  //hisui改造 modify by lmm 2018-08-18
		$(".checkbox").css("display","none") 
		EQCommon_HiddenElement("cWaitAD");
		$("#WaitAD").parent().empty()	//Mozy	1012982	2019-9-14
	}
	if (Type!="1")
	{
		EQCommon_HiddenElement("ReplacesAD");
		EQCommon_HiddenElement("cReplacesAD");
	}
	EQCommon_HiddenElement("PlanTypeList");
	EQCommon_HiddenElement("cPlanTypeList");
}
function InitPage()
{
	KeyUp("Status");
	Muilt_LookUp("Status");
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Clicked;
	var obj=document.getElementById("ReplacesAD")
	if (obj) obj.onchange=CheckChange;
	// Mozy0041	2011-2-14
	var obj=document.getElementById("BAddNew");
	if (obj) obj.onclick=BAddNew_Clicked;
	//add by csj 20181113
	var obj=document.getElementById("BFind");	//gen文件写有此查询方法
	if (obj) obj.onclick=BFind_Clicked;
}

//add by csj 20181113
function BFind_Clicked(){
	if (!$(this).linkbutton('options').disabled){
		var WaitAD="0";
		if (GetElementValue("WaitAD")) WaitAD="checked";
		///modified by ZY0197  增加管理部门参数
		$('#tDHCEQBuyPlanFind').datagrid('load',{ComponentID:51045,QXType:getValueById("QXType"),ApproveRole:getValueById("ApproveRole"),WaitAD:WaitAD,PlanName:getValueById("PlanName"),Type:getValueById("Type"),PlanType:getValueById("PlanType"),PlanTypeList:getValueById("PlanTypeList"),StartDate:getValueById("StartDate"),EndDate:getValueById("EndDate"),StatusDR:getValueById("StatusDR"),PlanNo:getValueById("PlanNo"),InvalidFlag:getValueById("InvalidFlag"),ManageLocDR:getValueById("ManageLocDR")});
	}
}
function BAdd_Clicked()
{
	var PlanType=GetElementValue("PlanType")
	var url="";
	if (PlanType==0)
	{
		
		url= 'dhceq.em.buyplan.csp?Type=0'+'&PlanType='+PlanType
	}
	else if (PlanType==1)
	{
		url= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBuyPlanYear&Type=0'+'&PlanType='+PlanType  //hisui改造 modify by lmm 2018-08-18
	}
	else
	{
		url= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBuyPlanYearDeal&Type=0'+'&PlanType='+PlanType  //hisui改造 modify by lmm 2018-08-18
	}
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
	window.location.href=url;
}
// Mozy0045	2011-3-14
function BAddNew_Clicked()
{
//	url="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBuyPlanNew&WaitAD=off&Type=0&PlanType="+GetElementValue("PlanType");  //hisui改造 modify by lmm 2018-08-18
	var url="dhceq.em.buyplan.csp?WaitAD=off&Type=0&PlanType="+GetElementValue("PlanType"); 
	showWindow(url,"采购计划单","","","icon-w-paper","modal","","","large",BFind_Clicked)	//modified by lmm 2020-06-04 UI
//	location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQBuyPlanNew&WaitAD=off&Type=0&PlanType="+GetElementValue("PlanType");  //hisui改造 modify by lmm 2018-08-18
}
function GetStatus (value)
{
    GetLookUpID("StatusDR",value);
}


document.body.onload = BodyLoadHandler;
