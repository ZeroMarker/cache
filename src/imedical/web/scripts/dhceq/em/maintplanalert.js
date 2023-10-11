jQuery(document).ready
(
	function()
	{
		setTimeout("initDocument();",50);
	}
);
function initDocument()
{
	initUserInfo();
	initLookUp();
	defindTitleStyle();
	initButton();
	// MZY0124		2022-05-23
	if (getElementValue("PrivateFlag")==1)
	{
		//hiddenObj("cMPMaintUserDR_UserName",1);
		//hiddenObj("MPMaintUserDR_UserName",1);
		disableElement("MPMaintUserDR_UserName",1);
	}
	//显示列表
	createMaintPlan()
}
function BFind_Clicked()
{
	createMaintPlan()
}
function createMaintPlan()
{
	///动态获取datagrid列信息
	var Columns=getCurColumnsInfo('EM.G.Maint.MaintPlanAlert','','','')
	///动态生成datagrid调用查询
	var queryParams={ClassName:"web.DHCEQ.EM.BUSMaintPlan",QueryName:"GetMaintPlanNew"}
	//动态传递参数值修改
	queryParams.BussType=getElementValue("BussType")
	queryParams.Name=getElementValue("MPName")
	queryParams.MaintNo=getElementValue("MPPlanNo")
	queryParams.MaintTypeDR=getElementValue("MaintTypeDR")
	queryParams.MaintLocDR=getElementValue("MPMaintLocDR")
	queryParams.QXType=getElementValue("QXType")
	queryParams.Schedule=getElementValue("MPSchedule")
	queryParams.MaintUserDR=getElementValue("MPMaintUserDR")  //add by lmm 2019-01-12 804709
	queryParams.PrivateFlag=getElementValue("PrivateFlag")		// MZY0121	2022-04-15
	//动态生成datagrid窗口显示数据
	createdatagrid("tMaintPlanAlert",queryParams,Columns)
}
function LoadSuccess()
{
	var rows = $("#tMaintPlanAlert").datagrid('getRows');
    var lastIndex=rows.length-1
    for (var i=0;i<=lastIndex;i++)
    {
	    var curRowObj=$('#tMaintPlanAlert').datagrid('getRows')[i];
	    var MPExeID=curRowObj.TLastPlanExeID
	    if (MPExeID!="")
	    {
		    $("#TNewPlanExez"+i).hide()
	    }
	    else
	    {
		    $("#TLastExSchedulez"+i).hide()
	    }
    }
}
function maintPlanExecute(index)
{
	var curRowObj=$('#tMaintPlanAlert').datagrid('getRows')[index];
	var MPExeID=curRowObj.TLastPlanExeID
	var MPRowID=curRowObj.TRowID
	//add by lmm 2019-01-12 804385 begin
	var MeasureFlag=""
	var BussType=getElementValue("BussType")
	var MaintTypeDR=getElementValue("MaintTypeDR")
	if ((BussType==2)&&(MaintTypeDR==5))
	{
		var MeasureFlag="Y"
	}
	//add by czf 872645 begin
	var PEEQIDs=tkMakeServerCall("web.DHCEQ.EM.BUSMaintPlan","GetMaintEquips",2,MPRowID,MeasureFlag)
	if (PEEQIDs=="")
	{
		alertShow("没有要执行的设备!")
		return;
	}
	//add by czf 872645 end
	//本次未执行时,自动生成计划执行记录
	if (MPExeID=="")
	{
		MPExeID=tkMakeServerCall("web.DHCEQ.EM.BUSMaintPlan","ExecuteMaintPlan",MPRowID,MeasureFlag)
	}
	$('#tMaintPlanAlert').datagrid('reload');	// MZY0093	2021-09-08
	var url="dhceq.em.maintplanexecute.csp?&RowID="+MPExeID+"&MPRowID="+MPRowID+"&BussType="+BussType+"&ReadOnly=&Status=0"+"&MaintTypeDR="+MaintTypeDR //modified by sjh SJH0037 2020-10-16 增加MaintTypeDR传参
	showWindow(url,"计划执行","","","icon-w-paper","modal","","","large");   //modify by lmm 2020-06-05 UI
}

function maintPlanHistoryExeList(index)
{
	var curRowObj=$('#tMaintPlanAlert').datagrid('getRows')[index];
	var MPRowID=curRowObj.TRowID
	var BussType=getElementValue("BussType")
	var url="dhceq.em.historyexecutelist.csp?&MPRowID="+MPRowID+"&BussType="+BussType
	showWindow(url,"执行记录","","","icon-w-paper","modal","","","large");   //modify by lmm 2020-06-05 UI
}
//Modify by zx 2022-06-24 BUG:2744761  去调后台调用
function getAutoPic(row)
{
	var alertType=row.TAlertType;
	//var AutoPicInfo=tkMakeServerCall("web.DHCEQ.EM.BUSMaintPlan","GetWarnIcon",row.TRowID)
	if(alertType=="1") return "../images/websys/sys_warning.gif";
	else if(alertType=="2") return "../images/websys/sys_information.gif";
	else return "";
}
///add by lmm 2019-1-12 804709
///描述：下拉框赋值事件
function setSelectValue(vElementID,item)
{
	var ElementID=vElementID.split("_");
	var len=ElementID.length;
	if(len>1)
	{
		setElement(ElementID[0],item.TRowID);
	}
}
///add by lmm 2019-1-12 804709
///描述：下拉框清除事件
function clearData(vElementID)
{
	var ElementID=vElementID.split("_");
	var len=ElementID.length;
	if(len>1)
	{
		setElement(ElementID[0],"");
	}
}