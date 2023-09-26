///Modified by HZY 2011-07-13
///修改函数? BFind_Clicked
///描述： Bug号：HZY0001  --增加按申请单号查询的功能
///-------------------------------------------------
///modified by HZY0066 2014-09-30 
///修复'设备采购申请查找'里，点击项目名称后没有判断单种与批量的问题
///新增TDetail_Clicked()，InitTblEvt()方法，BodyLoadHandler()中增加调用过程
///------------------------------------------------------
///modified 20191012 by zy 采购申请通过一个界面，控制年度和临时采购申请的按钮来控制功能。
var BuyTimeModel=getElementValue("BuyTimeModel");
var Year=new Date();
Year=Year.getFullYear();
var YearBuyReqSDate=Year+getElementValue("YearBuyReqSDate");
var YearBuyReqEDate=Year+getElementValue("YearBuyReqEDate");
var CurrentDate=GetCurrentDate()
CurrentDate=CurrentDate.replace(/-/g,"");
var InYearBuyTimeFlag=0
if ((CurrentDate>YearBuyReqSDate)&(CurrentDate<YearBuyReqEDate)) InYearBuyTimeFlag=1

function BodyLoadHandler(){	
	//document.body.scroll="no"		需求号:264101
	
	InitUserInfo();
	InitPage();
	SetEnabled();
	InitTblEvt(); //2014-9-30 HZY0066
	initButtonWidth();  //hisui改造 add by lmm 2018-08-20
}

function SetEnabled()
{
	//add 20191012 by zy 判断哪儿个按钮隐藏
	if (BuyTimeModel==1)
	{
		if (InYearBuyTimeFlag==1)
		{
			hiddenObj("BAdd",true);
		}
		else
		{
			hiddenObj("BAddNew",true);
		}
	}
	
	var Type=GetElementValue("Type");
	if (Type!="0")
	{
		DisableBElement("BAdd",true);
		DisableBElement("BAddNew",true);
	}
	else
	{
//		EQCommon_HiddenElement("WaitAD");
		EQCommon_HiddenElement("cWaitAD");
		$("#WaitAD").parent().empty()	//Mozy	1012982	2019-9-14
		//HiddenCheckBox("WaitAD");  //hisui改造 add by lmm 2018-08-18
	}
}
///add by lmm 2018-08-18
///描述：hisui改造 隐藏勾选框
///入参：name 勾选框id
function HiddenCheckBox(name)
{
	//modify by lmm 2019-09-20
	//$("#"+name).parent(".hischeckbox_square-blue").css("display","none");
	$("#"+name).next(".checkbox").css("display","none");
}
function InitPage()
{

	KeyUp("Status^RequestLoc^UseLoc")
	Muilt_LookUp("Status^RequestLoc^UseLoc");
	
	var yearflag=GetElementValue("GetYearFlag");
	if (yearflag!="") SetElement("YearFlag",yearflag);
	var obj=document.getElementById("BFind");	//gen文件写有此查询方法
	if (obj) obj.onclick=BFind_Clicked;
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Clicked;
	
	// Mozy0041	2011-2-14
	var obj=document.getElementById("BAddNew");
	if (obj) obj.onclick=BAddNew_Clicked;
	var obj=document.getElementById("BAddNN");
	if (obj) obj.onclick=BAddNN_Clicked;
}
///modified by ZY0217 2020-04-08
function BAdd_Clicked()
{
	if ((BuyTimeModel==2)&&(InYearBuyTimeFlag==1))
	{
		messageShow("confirm","","","年度申购申请期间禁止填报常规申购申请,是否继续填报?","",confirmFun,"")
	}
	else
	{
		confirmFun()
	}
}
///modified by ZY0215 2020-04-02
function confirmFun()
{
	var url="dhceq.em.buyrequest.csp?&WaitAD="+getElementValue("WaitAD")+"&YearFlag=N"; //add by zx 2019-09-16
	showWindow(url,"采购申请单","","","icon-w-paper","modal","","","large",refreshWindow)  //modify by lmm 2020-06-04
}
///modified by ZY0217 2020-04-08
function BAddNew_Clicked()
{
	if ((BuyTimeModel==2)&&(InYearBuyTimeFlag==0))
	{
		if (InYearBuyTimeFlag==0)
		{
			messageShow("confirm","","","年度申购申请时间已过,是否继续填报?","",confirmFunNew,"")
		}
	}
	else
	{
		confirmFunNew()
	}
}
///modified by ZY0215 2020-04-02
function confirmFunNew()
{
	var url="dhceq.em.buyrequest.csp?&WaitAD="+getElementValue("WaitAD")+"&YearFlag=Y";
	showWindow(url,"采购申请单","","","icon-w-paper","modal","","","large",refreshWindow)  //modify by lmm 2020-06-04
}
// modified by csj 20190201 UI评审弹窗调整
function BAddNN_Clicked()
{
	var url="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQBuyRequestNN&RequestDate="+GetElementValue("EndDate")+"&RequestLocDR="+"&Status=&WaitAD=off&QXType="+GetElementValue("QXType")+"&YearFlag="+GetElementValue("YearFlag");
	showWindow(url,"采购申请单","","","icon-w-paper","modal","","","large",refreshWindow)  //modify by lmm 2019-06-02

}
///modify by lmm 2018-08-18
///描述：hisui改造 重写查询方法 更改勾选框入参变量
function BFind_Clicked()
{
	if (!$(this).linkbutton('options').disabled){
		var WaitAD="0";	
		if (GetElementValue("WaitAD")) WaitAD="checked";
			$('#tDHCEQBuyRequestFind').datagrid('load',{ComponentID:getValueById("GetComponentID"),QXType:getValueById("QXType"),ApproveRole:getValueById("ApproveRole"),WaitAD:WaitAD,Type:getValueById("Type"),RequestLocDR:getValueById("RequestLocDR"),YearFlag:getValueById("YearFlag"),StartDate:$('#StartDate').datebox("getValue"),EndDate:$('#EndDate').datebox("getValue"),StatusDR:getValueById("StatusDR"),RequestNo:getValueById("RequestNo"),InvalidFlag:getValueById("InvalidFlag")});
		}
}
function GetStatus (value)
{
    GetLookUpID("StatusDR",value);
}
function GetRequestLoc (value)
{
    GetLookUpID("RequestLocDR",value);
}
function GetUseLoc (value)
{
    GetLookUpID("UseLocDR",value);
}

//2014-9-30 HZY0066
///选择表格行触发此方法
function InitTblEvt()
{
	var objtbl=document.getElementById('tDHCEQBuyRequestFind');//+组件名 就是你的组件显示 Query 结果的部分
	var rows=objtbl.rows.length;
	for (var i=1; i<rows; i++)
	{
		var obj=document.getElementById("TDetailz"+i);
		if (obj) obj.onclick=TDetail_Clicked;
	}
}

///add by lmm 2018-08-18
///描述：hisui改造 点击详细列按钮弹框界面
///入参：rowData 选中行json数据
///      rowIndex 行号
function TDetailHandler(rowData,rowIndex)
{
	//"&RowID="_rs.GetDataByName("TRowID")_"&QXType="_%request.Get("QXType")_"&CurRole="_%request.Get("ApproveRole")_"&WaitAD="_%request.Get("WaitAD")
	var CurRow=rowIndex;
	var val="&RowID="+rowData.TRowID;
    val=val+"&CurRole="+GetElementValue("ApproveRole");
    val=val+"&QXType="+GetElementValue("QXType");
    val=val+"&Type="+GetElementValue("Type");
    //val=val+"&WaitAD="+GetElementValue("WaitAD");	/// 20150327  Mozy0153
    if (GetElementValue("WaitAD"))
    {
    	val=val+"&WaitAD=on";
    }
    else
    {
    	val=val+"&WaitAD=off";
    }
    
    val=val+"&YearFlag="+GetElementValue("YearFlag");
    var batchFlag=rowData.THold;
    var LinkComponentName="DHCEQBuyRequestNew";
    if (batchFlag=="Y")
    {
	    LinkComponentName="DHCEQBuyRequestNN";
    }
    var str= 'websys.default.hisui.csp?WEBSYS.TCOMPONENT='+LinkComponentName+val ; 
	showWindow(str,"采购申请单","","","icon-w-paper","modal","","","large",refreshWindow);   //modify by lmm 2019-02-16
}
document.body.onload = BodyLoadHandler;