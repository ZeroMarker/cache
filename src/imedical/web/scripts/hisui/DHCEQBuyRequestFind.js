///Modified by HZY 2011-07-13
///�޸ĺ���? BFind_Clicked
///������ Bug�ţ�HZY0001  --���Ӱ����뵥�Ų�ѯ�Ĺ���
///-------------------------------------------------
///modified by HZY0066 2014-09-30 
///�޸�'�豸�ɹ��������'������Ŀ���ƺ�û���жϵ���������������
///����TDetail_Clicked()��InitTblEvt()������BodyLoadHandler()�����ӵ��ù���
///------------------------------------------------------
///modified 20191012 by zy �ɹ�����ͨ��һ�����棬������Ⱥ���ʱ�ɹ�����İ�ť�����ƹ��ܡ�
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
	//document.body.scroll="no"		�����:264101
	
	InitUserInfo();
	InitPage();
	SetEnabled();
	InitTblEvt(); //2014-9-30 HZY0066
	initButtonWidth();  //hisui���� add by lmm 2018-08-20
}

function SetEnabled()
{
	//add 20191012 by zy �ж��Ķ�����ť����
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
		//HiddenCheckBox("WaitAD");  //hisui���� add by lmm 2018-08-18
	}
}
///add by lmm 2018-08-18
///������hisui���� ���ع�ѡ��
///��Σ�name ��ѡ��id
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
	var obj=document.getElementById("BFind");	//gen�ļ�д�д˲�ѯ����
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
		messageShow("confirm","","","����깺�����ڼ��ֹ������깺����,�Ƿ�����?","",confirmFun,"")
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
	showWindow(url,"�ɹ����뵥","","","icon-w-paper","modal","","","large",refreshWindow)  //modify by lmm 2020-06-04
}
///modified by ZY0217 2020-04-08
function BAddNew_Clicked()
{
	if ((BuyTimeModel==2)&&(InYearBuyTimeFlag==0))
	{
		if (InYearBuyTimeFlag==0)
		{
			messageShow("confirm","","","����깺����ʱ���ѹ�,�Ƿ�����?","",confirmFunNew,"")
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
	showWindow(url,"�ɹ����뵥","","","icon-w-paper","modal","","","large",refreshWindow)  //modify by lmm 2020-06-04
}
// modified by csj 20190201 UI���󵯴�����
function BAddNN_Clicked()
{
	var url="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQBuyRequestNN&RequestDate="+GetElementValue("EndDate")+"&RequestLocDR="+"&Status=&WaitAD=off&QXType="+GetElementValue("QXType")+"&YearFlag="+GetElementValue("YearFlag");
	showWindow(url,"�ɹ����뵥","","","icon-w-paper","modal","","","large",refreshWindow)  //modify by lmm 2019-06-02

}
///modify by lmm 2018-08-18
///������hisui���� ��д��ѯ���� ���Ĺ�ѡ����α���
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
///ѡ�����д����˷���
function InitTblEvt()
{
	var objtbl=document.getElementById('tDHCEQBuyRequestFind');//+����� ������������ʾ Query ����Ĳ���
	var rows=objtbl.rows.length;
	for (var i=1; i<rows; i++)
	{
		var obj=document.getElementById("TDetailz"+i);
		if (obj) obj.onclick=TDetail_Clicked;
	}
}

///add by lmm 2018-08-18
///������hisui���� �����ϸ�а�ť�������
///��Σ�rowData ѡ����json����
///      rowIndex �к�
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
	showWindow(str,"�ɹ����뵥","","","icon-w-paper","modal","","","large",refreshWindow);   //modify by lmm 2019-02-16
}
document.body.onload = BodyLoadHandler;