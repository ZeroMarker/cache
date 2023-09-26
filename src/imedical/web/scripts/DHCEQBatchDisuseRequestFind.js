/// -------------------------------
/// 修    改:ZY  2009-08-24  No.ZY0010
/// 增加函数:BAdd_Clicked()
/// 修改描述:新增报废申请
/// -------------------------------
/// 创    建:ZY  2009-08-16  No.ZY0009
/// 修改描述:设备批量报废查找
/// --------------------------------
function BodyLoadHandler(){
	InitUserInfo();
	fillData();	
	InitPage();
	InitTblEvt();
}

function InitPage()
{
	KeyUp("RequestLoc^EquipType^Status^PurchaseType^Equip^UseLoc","N") //2011-10-27 DJ DJ0097
	Muilt_LookUp("RequestLoc^EquipType^Status^PurchaseType^Equip^UseLoc"); //2011-10-27 DJ DJ0097
	var Type=GetElementValue("Type");
	if (Type!="0")
	{
		DisableBElement("BAdd",true);
		
		//Add by JDL 2011-11-29 JDL0104
		DisableBElement("BAddSimple",true);
	}
	else
	{
		EQCommon_HiddenElement("WaitAD");
		EQCommon_HiddenElement("cWaitAD");
	}
	if (Type!="1")
	{
		EQCommon_HiddenElement("ReplacesAD");
		EQCommon_HiddenElement("cReplacesAD");
	}
	var obj=document.getElementById("WaitAD");
	if (obj) obj.onchange=CheckChange;
	var obj=document.getElementById("ReplacesAD")
	if (obj) obj.onchange=CheckChange;
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Clicked;
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Clicked;
	var obj=document.getElementById("BAddSimple");
	if (obj) obj.onclick=BAddSimple_Clicked;
}
function BAdd_Clicked()
{
    var val="&QXType="+GetElementValue("QXType")
    val=val+"&RequestLocDR="+GetElementValue("RequestLocDR");
    val=val+"&DType="+GetElementValue("DType");
    val=val+"&Type="+GetElementValue("Type");
    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBatchDisuseRequest&RowID=&ApproveSetDR='+val;
}

function CheckChange()
{
	var eSrc=window.event.srcElement;
	if (eSrc.checked)
	{
		if (eSrc.id=="WaitAD") SetChkElement("ReplacesAD","0");
		if (eSrc.id=="ReplacesAD") SetChkElement("WaitAD","0");
	} 
}

function GetRequestLoc (value)
{
    GetLookUpID("RequestLocDR",value);
}
function GetEquipType (value)
{
    GetLookUpID("EquipTypeDR",value);
}
function GetStatus (value)
{
    GetLookUpID("StatusDR",value);
}
function GetPurchaseType (value)
{
    GetLookUpID("PurchaseTypeDR",value);
}
function GetEquip (value)
{
    GetLookUpID("EquipDR",value);
}

function BFind_Clicked()
{
	var val="&vData="
	val=val+GetVData();
	val=val+"&TMENU="+GetElementValue("TMENU");
	window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBatchDisuseRequestFind"+val;
}

function GetVData()
{
	var	val="^ReplacesAD="+GetElementValue("ReplacesAD");
	val=val+"^ApproveRole="+GetElementValue("ApproveRole");
	val=val+"^Type="+GetElementValue("Type");
	val=val+"^StatusDR="+GetElementValue("StatusDR");
	val=val+"^Status="+GetElementValue("Status");
	val=val+"^EquipDR="+GetElementValue("EquipDR");
	val=val+"^RequestLocDR="+GetElementValue("RequestLocDR");
	val=val+"^EquipTypeDR="+GetElementValue("EquipTypeDR");
	val=val+"^PurchaseTypeDR="+GetElementValue("PurchaseTypeDR");	
	val=val+"^StartDate="+GetElementValue("StartDate");
	val=val+"^EndDate="+GetElementValue("EndDate");
	val=val+"^WaitAD="+GetElementValue("WaitAD");
	val=val+"^QXType="+GetElementValue("QXType");
	val=val+"^Name="+GetElementValue("Name");
	val=val+"^UseLocDR="+GetElementValue("UseLocDR");
	val=val+"^RequestNo="+GetElementValue("RequestNo");
	val=val+"^EquipName="+GetElementValue("EquipName");
	val=val+"^MinValue="+GetElementValue("MinValue");
	val=val+"^MaxValue="+GetElementValue("MaxValue");
	val=val+"^StartInDate="+GetElementValue("StartInDate");
	val=val+"^EndInDate="+GetElementValue("EndInDate");
	val=val+"^EquipNo="+GetElementValue("EquipNo");		//20141202  Mozy0147
	return val;
}

function fillData()
{
	var vData=GetElementValue("vData")
	if (vData!="")
	{
		var list=vData.split("^");
		for (var i=1; i<list.length; i++)
		{
			Detail=list[i].split("=");
			switch (Detail[0])
			{
				case "ReplacesAD":
					if (Detail[1]=="true")
					{
						SetChkElement(Detail[0],1);
					}
					else
					{
						SetChkElement(Detail[0],0);
					}
					break;
				case "WaitAD":
					if (Detail[1]=="true")
					{
						SetChkElement(Detail[0],1);
					}
					else
					{
						SetChkElement(Detail[0],0);
					}
					break;
				default :
					SetElement(Detail[0],Detail[1]);
					break;
			}
		}
	}
	var val="";
	val=val+"equip=Equip="+GetElementValue("EquipDR")+"^";
	val=val+"equiptype=EquipType="+GetElementValue("EquipTypeDR")+"^";
	val=val+"purchase=PurchaseType="+GetElementValue("PurchaseTypeDR")+"^";
	val=val+"dept=RequestLoc="+GetElementValue("RequestLocDR")+"^";
	val=val+"dept=UseLoc="+GetElementValue("UseLocDR")+"^"; //2011-20-27 DJ DJ0097
	var encmeth=GetElementValue("GetDRDesc");
	var result=cspRunServerMethod(encmeth,val);
	var list=result.split("^");
	for (var i=1; i<list.length; i++)
	{
		var Detail=list[i-1].split("=");
		SetElement(Detail[0],Detail[1]);
	}
}

function RefreshData()
{
	var vdata1=GetElementValue("vData");
	var vdata2=GetVData();
	if (vdata1!=vdata2) BFind_Clicked();
}

///选择表格行触发此方法
function InitTblEvt()
	{
	var objtbl=document.getElementById('tDHCEQBatchDisuseRequestFind');//+组件名 就是你的组件显示 Query 结果的部分
	var rows=objtbl.rows.length;
	
	for (var i=1; i<rows; i++)
	{
		var obj=document.getElementById("TDetailz"+i);
		if (obj) obj.onclick=TDetail_Clicked;
	}
}

function TDetail_Clicked()
{
	var CurRow=GetTableCurRow();
	var val="&RowID="+GetElementValue("TRowIDz"+CurRow);
    val=val+"&CurRole="+GetElementValue("ApproveRole");
    val=val+"&QXType="+GetElementValue("QXType");
    val=val+"&Type="+GetElementValue("Type");
    
    //Modified By JDL 2011-12-02 JDL0104
    var KindFlag=GetElementValue("TKindFlagz"+CurRow);
    var LinkComponentName="DHCEQBatchDisuseRequest";
    if (KindFlag==2)
    {
	    LinkComponentName="DHCEQDisuseRequestSimple";
    }
    var str= 'websys.default.csp?WEBSYS.TCOMPONENT='+LinkComponentName+val  //2011-10-27 DJ DJ0097
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1000,height=680,left=120,top=0') //2011-10-27 DJ DJ0097
}

function GetUseLoc (value) //2011-10-27 DJ DJ0097
{
    GetLookUpID("UseLocDR",value);
}

//Add by JDL 2011-11-29 JDL0104
function BAddSimple_Clicked()
{
    var val="&QXType="+GetElementValue("QXType")
    val=val+"&RequestLocDR="+GetElementValue("RequestLocDR");
    val=val+"&DType="+GetElementValue("DType");
    val=val+"&Type="+GetElementValue("Type");
    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQDisuseRequestSimple&RowID=&ApproveSetDR='+val
}

document.body.onload = BodyLoadHandler;