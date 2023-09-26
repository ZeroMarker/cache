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
	initButtonWidth();
	//��ʾ�б�
	createMaintPlan()
}
function BFind_Clicked()
{
	createMaintPlan()
}
function createMaintPlan()
{
	///��̬��ȡdatagrid����Ϣ
	var Columns=getCurColumnsInfo('EM.G.Maint.MaintPlanAlert','','','')
	///��̬����datagrid���ò�ѯ
	var queryParams={ClassName:"web.DHCEQ.EM.BUSMaintPlan",QueryName:"GetMaintPlanNew"}
	//��̬���ݲ���ֵ�޸�
	queryParams.BussType=getElementValue("BussType")
	queryParams.Name=getElementValue("MPName")
	queryParams.MaintNo=getElementValue("MPPlanNo")
	queryParams.MaintTypeDR=getElementValue("MaintTypeDR")
	queryParams.MaintLocDR=getElementValue("MPMaintLocDR")
	queryParams.QXType=getElementValue("QXType")
	queryParams.Schedule=getElementValue("MPSchedule")
	queryParams.MaintUserDR=getElementValue("MPMaintUserDR")  //add by lmm 2019-01-12 804709
	//��̬����datagrid������ʾ����
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
		alertShow("û��Ҫִ�е��豸!")
		return;
	}
	//add by czf 872645 end
	//����δִ��ʱ,�Զ����ɼƻ�ִ�м�¼
	if (MPExeID=="")
	{
		MPExeID=tkMakeServerCall("web.DHCEQ.EM.BUSMaintPlan","ExecuteMaintPlan",MPRowID,MeasureFlag)
	}
	//add by lmm 2019-01-12 804385 end
	var url="dhceq.em.maintplanexecute.csp?&RowID="+MPExeID+"&MPRowID="+MPRowID+"&BussType="+BussType+"&ReadOnly=&Status=0"
	showWindow(url,"�ƻ�ִ��","","","icon-w-paper","modal","","","large");   //modify by lmm 2020-06-05 UI
}

function maintPlanHistoryExeList(index)
{
	var curRowObj=$('#tMaintPlanAlert').datagrid('getRows')[index];
	var MPRowID=curRowObj.TRowID
	var BussType=getElementValue("BussType")
	var url="dhceq.em.historyexecutelist.csp?&MPRowID="+MPRowID+"&BussType="+BussType
	showWindow(url,"ִ�м�¼","","","icon-w-paper","modal","","","large");   //modify by lmm 2020-06-05 UI
}
function getAutoPic(row)
{
	var sourceID=row.TRowID
	var AutoPicInfo=tkMakeServerCall("web.DHCEQ.EM.BUSMaintPlan","GetWarnIcon",sourceID)
	return AutoPicInfo
}
///add by lmm 2019-1-12 804709
///������������ֵ�¼�
function setSelectValue(vElementID,item)
{
	var ElementID=vElementID.split("_")
	var len=ElementID.length
	if(len>1)
	{
		setElement(ElementID[0],item.TRowID)
	}
	
}
///add by lmm 2019-1-12 804709
///����������������¼�
function clearData(vElementID)
{
	var ElementID=vElementID.split("_")
	var len=ElementID.length
	if(len>1)
	{
		setElement(ElementID[0],"")
		
	}
}