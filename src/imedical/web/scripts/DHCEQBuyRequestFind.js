///Modified by HZY 2011-07-13
///�޸ĺ���? BFind_Clicked
///������ Bug�ţ�HZY0001  --���Ӱ����뵥�Ų�ѯ�Ĺ���
///-------------------------------------------------
///modified by HZY0066 2014-09-30 
///�޸�'�豸�ɹ��������'������Ŀ���ƺ�û���жϵ���������������
///����TDetail_Clicked()��InitTblEvt()������BodyLoadHandler()�����ӵ��ù���
///------------------------------------------------------
function BodyLoadHandler(){	
	//document.body.scroll="no"		�����:264101
	InitUserInfo();
	InitPage();
	SetEnabled();
	InitTblEvt(); //2014-9-30 HZY0066
}

function SetEnabled()
{
	var Type=GetElementValue("Type");
	if (Type!="0")
	{
		DisableBElement("BAdd",true);
		DisableBElement("BAddNew",true);
	}
	else
	{
		EQCommon_HiddenElement("WaitAD");
		EQCommon_HiddenElement("cWaitAD");
	}
}
function InitPage()
{
	KeyUp("Status^RequestLoc^UseLoc")
	Muilt_LookUp("Status^RequestLoc^UseLoc");
	var yearflag=GetElementValue("GetYearFlag");
	if (yearflag!="") SetElement("YearFlag",yearflag);
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Clicked;
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Clicked;
	
	// Mozy0041	2011-2-14
	var obj=document.getElementById("BAddNew");
	if (obj) obj.onclick=BAddNew_Clicked;
	var obj=document.getElementById("BAddNN");
	if (obj) obj.onclick=BAddNN_Clicked;
}
function BAdd_Clicked()
{
	parent.location.href="dhceqbuyrequest.csp?Type=0";
}
// Mozy0041	2011-2-14
function BAddNew_Clicked()
{
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBuyRequestNew&WaitAD=off"+"&YearFlag="+GetElementValue("YearFlag"); //modified by  ZY 2015-09-28 ZY0144   ���YearFlag����
}

function BAddNN_Clicked()
{
	//location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBuyRequestNew&WaitAD=off";
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBuyRequestNN&RequestDate="+GetElementValue("EndDate")+"&RequestLocDR="+"&Status=&WaitAD=off&QXType="+GetElementValue("QXType")+"&YearFlag="+GetElementValue("YearFlag"); //modified by  ZY 2015-09-28 ZY0144   ���YearFlag����
}

function BFind_Clicked()
{
	var GetDate=GetElementValue("GetDateNumByString");
	var Type=GetElementValue("Type");
	var RequestLocDR=GetElementValue("RequestLocDR");
	var StatusDR=GetElementValue("StatusDR");
	var YearFlag=GetElementValue("YearFlag");
	var obj=document.getElementById("WaitAD");
	var WaitAD="0";
	if (obj.checked) WaitAD="on";
	var StartDate=GetElementValue("StartDate");
	var EndDate=GetElementValue("EndDate");
	var ApproveRole=GetElementValue("ApproveRole");
	var QXType=GetElementValue("QXType");
	
	var RequestNo=GetElementValue("RequestNo");		//2011-07-13 ��֮�� --�õ�����Ԫ�����뵥�ŵ�ֵ; Bug�ţ�HZY0001
	
	//var StartDate2=cspRunServerMethod(GetDate,StartDate,"date");
	//var EndDate2=cspRunServerMethod(GetDate,EndDate,"date");
	var Listlnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBuyRequestList";
	var lnkvar="&WaitAD="+WaitAD;
	lnkvar=lnkvar+"&Type="+Type;
	lnkvar=lnkvar+"&RequestLocDR="+RequestLocDR;
	lnkvar=lnkvar+"&YearFlag="+YearFlag;
	lnkvar=lnkvar+"&StatusDR="+StatusDR;
	lnkvar=lnkvar+"&ApproveRole="+ApproveRole;
	var lnkvar2=lnkvar+"&StartDate="+GetElementValue("StartDate")	//StartDate2;
	lnkvar2=lnkvar2+"&EndDate="+GetElementValue("EndDate")			//EndDate2;
	lnkvar2=lnkvar2+"&QXType="+QXType;
	
	lnkvar2=lnkvar2+"&RequestNo="+RequestNo;  //2011-07-11 ��֮��  --������Ԫ�����뵥�ŵ�ֵ��ӵ����Ӵ�β��;  Bug�ţ�HZY0001
	lnkvar2=lnkvar2+"&InvalidFlag="+GetElementValue("InvalidFlag"); //2011-10-31 DJ DJ0098
	lnkvar2=lnkvar2+"&TMENU="+GetElementValue("TMENU");
	//window.location.href=Findlnk+lnkvar1;
	//parent.DHCEQBuyRequestList.location.href=Listlnk+lnkvar2;
	//alertShow(lnkvar2)
	window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBuyRequestFind"+lnkvar2;
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

//2014-9-30 HZY0066
function TDetail_Clicked()
{
	//"&RowID="_rs.GetDataByName("TRowID")_"&QXType="_%request.Get("QXType")_"&CurRole="_%request.Get("ApproveRole")_"&WaitAD="_%request.Get("WaitAD")
	var CurRow=GetTableCurRow();
	var val="&RowID="+GetElementValue("TRowIDz"+CurRow);
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
    var batchFlag=GetElementValue("THold1z"+CurRow);
    var LinkComponentName="DHCEQBuyRequestNew";
    if (batchFlag=="Y")
    {
	    LinkComponentName="DHCEQBuyRequestNN";
    }
    var str= 'websys.default.csp?WEBSYS.TCOMPONENT='+LinkComponentName+val ; 
    SetWindowSize(str,1);   //add By HHM 20150824 HHM0001
    //window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=980,height=730,left=120,top=0') ;		
}
document.body.onload = BodyLoadHandler;