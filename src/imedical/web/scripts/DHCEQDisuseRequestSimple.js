///记录 设备 RowID?处理重复选择RowID的问题
var ObjSources=new Array();
//最后一行数据元素的名字的后缀序号
var LastNameIndex;
//新增一行数据元素的名字的后缀序号
var NewNameIndex;
//操作行号
var selectrow=0;
var Component;

function BodyLoadHandler() 
{
	Component=GetElementValue("ComponentName");
	if (Component=="") Component="DHCEQBatchDisuseRequest";
	InitStyle("Remark","5");
	InitUserInfo();
	InitPage();
	FillData();
	//单种报废
	if (Component=="DHCEQBatchDisuseRequest")
	{
		var RowIDs=GetElementValue("RowIDs");
		if (RowIDs!="")	SetElement("Amount", RowIDs.split(",").length);
		
		var obj=document.getElementById("KindFlag");
		if (obj)
		{
			obj.onchange=KindFlag_Change;
			//修改报废选择批量报废时,设备明细不能选择的问题
			if (obj.value==0) 
			{
				DisableBElement("EquipList",true);
			}
			else
			{
				var obj=document.getElementById("EquipList");
				if (obj) obj.onclick=EquipListClick;
			}
		}		
	}
	else
	{
		SetTableItem('','');
		SetElement("Job",GetElementValue("TJobz1"))
	}
	SetDisplay();
	SetEnabled();
	//   隐藏合计行checkbox元素 add by csy 2017-08-16 明细勾选报废 需求号：CSY0007   begin 
	var Objtbl=document.getElementById('tDHCEQDisuseRequestSimple');
	var Rows=Objtbl.rows.length;
	var i=Rows-1;
	var TRowID=GetElementValue('TRowIDz'+i)
	if (TRowID==-1)
	{
		HiddenObj('THold2z'+i,1)
	} 
	// 隐藏合计行checkbox元素 // add by csy 2017-08-16 明细勾选报废 需求号：CSY0007   end
	KeyUp("RequestLoc^Loc^Equip^DisuseType^EquipType","N");	//清空选择
	Muilt_LookUp("RequestLoc^Loc^Equip^DisuseType^EquipType"); //回车选择
}

function InitPage()
{
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Clicked;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Clicked;
	var obj=document.getElementById("BSubmit");
	if (obj) obj.onclick=BSubmit_Clicked;
	var obj=document.getElementById("BCancelSubmit");
	if (obj) obj.onclick=BCancelSubmit_Clicked;
	var obj=document.getElementById("BAudit");
	if (obj) obj.onclick=BAudit_Clicked;
	var obj=document.getElementById("BPrint");   
	if (obj) obj.onclick=BPrint_Click;
	
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=AddClickHandler;
	// add by csy 2017-08-16 明细勾选报废 需求号：CSY0007
	var obj=document.getElementById("BDetailAudit");
	if (obj) obj.onclick=BDetailAudit_Click;
	// add by csy 2017-08-16 明细勾选报废 需求号：CSY0007
	var obj=document.getElementById("SelectAll");
	if (obj) obj.onclick=SelectAll_Clicked;
}

function KindFlag_Change()
{
	Clear();
	var KindFlag=GetElementValue("KindFlag")
	if (KindFlag==0)
	{
		DisableBElement("EquipList",true);
	}
	else
	{
		DisableBElement("EquipList",false);
		var obj=document.getElementById("EquipList");
		if (obj) obj.onclick=EquipListClick;
	}
}

/// 更新
function BUpdate_Clicked()
{
	if (CheckNull()) return
	if (CheckInvalidData()) return;
	//add by zy ZY0089
	/*			//Add By DJ 2016-04-25
	if ((GetElementValue("KindFlag")==1))
	{
		if (GetElementValue("RowIDs")=="")
		{
			alertShow("请选择设备明细!")
			return;
		}
	}	
	*/
	if (Component=="DHCEQBatchDisuseRequest")
	{
		var Amount=GetElementValue("Amount")
		if (Amount=="")
		{
			alertShow("请选择设备明细!")
			return
		}
	}
	var ReqVal=CombinData();
	
	var ListVal=GetTableInfo();
  	if (ListVal=="-1")  return;
  	var DelListIDs=tableList.toString();
	
    var rtn=SaveDisuseRequest(ReqVal,ListVal,DelListIDs,"0");
    if (rtn!=-1)
    {
	    window.location.href= "websys.default.csp?WEBSYS.TCOMPONENT="+Component+"&Type=0&RowID="+rtn+"&RowIDs="+GetElementValue("RowIDs");
	}    
}

/// 删除
function BDelete_Clicked()
{
	var truthBeTold = window.confirm(t["-4003"]);
	if (!truthBeTold) return;
	var RowID=GetElementValue("RowID");
	var rtn=SaveDisuseRequest(RowID,"","","1");
	if (rtn!=-1)
    {
	    var val="&RequestLocDR="+GetElementValue("RequestLocDR")
	    val=val+"&RequestLoc="+GetElementValue("RequestLoc");
	    val=val+"&RequestDate="+GetElementValue("RequestDate");
	    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT='+Component+'&Type=0'+val
	}
}

///提交
function BSubmit_Clicked()
{
	SubmitRequest();
}

/// 取消提交
function BCancelSubmit_Clicked()
{
	CancelSubmit();
}

/// 审核
function BAudit_Clicked()
{
	Audit();
}

function CheckAuditNull()
{
	var ApproveRole=GetElementValue("CurRole");
	var CurStep=GetElementValue("RoleStep");
	if (CheckItemNull(2,"Opinion_"+ApproveRole+"_"+CurStep)) return true;
	return false
}

function GetOpinion()
{
	var ApproveRole=GetElementValue("CurRole");
	var CurStep=GetElementValue("RoleStep");
	var combindata=GetElementValue("CurRole") ;
  	combindata=combindata+"^"+GetElementValue("RoleStep") ;
  	combindata=combindata+"^"+GetElementValue("Opinion_"+ApproveRole+"_"+CurStep) ;
  	combindata=combindata+"^"+GetElementValue("OpinionRemark") ;
  	return combindata;
  	
}

function CombinData()
{
	var combindata="";
  	combindata=GetElementValue("RowID");
	combindata=combindata+"^"+GetElementValue("EquipDR") ;
  	combindata=combindata+"^"+""; //GetElementValue("GroupDR") ;
  	combindata=combindata+"^"+GetElementValue("RequestLocDR") ;
  	combindata=combindata+"^"+GetElementValue("RequestDate") ;
  	combindata=combindata+"^"+GetElementValue("UseState") ;
  	combindata=combindata+"^"+GetElementValue("DisuseTypeDR") ;
  	combindata=combindata+"^"+GetElementValue("ChangeReason") ;
  	combindata=combindata+"^"+""; //GetElementValue("DisureDate") ;
  	combindata=combindata+"^"+GetElementValue("Remark") ;
  	//begin 11 to 33
  	for (var j=11;j<34;j++)
	{
		combindata=combindata+"^"
	}
    combindata=combindata+"^"+GetElementValue("RequestNo") ;//
    combindata=combindata+"^"+GetElementValue("LocDR") ;//
    combindata=combindata+"^"+GetElementValue("TotleTime") ;//
    combindata=combindata+"^"+GetElementValue("Income") ;//
    combindata=combindata+"^"+GetElementValue("CheckResult") ;//
    combindata=combindata+"^"+GetElementValue("TechnicEvaluate") ;//
    combindata=combindata+"^"+GetElementValue("RepairHours") ;//
    combindata=combindata+"^"+GetElementValue("RepairFee") ;//
    combindata=combindata+"^"+GetElementValue("RepairTimes") ;//
    combindata=combindata+"^"+GetElementValue("LimitYears") ;//
    combindata=combindata+"^"+GetElementValue("KindFlag") ;//
    combindata=combindata+"^"+GetElementValue("InStockListDR") ;//
    combindata=combindata+"^"+GetElementValue("RejectReason") ;//
    combindata=combindata+"^"+GetElementValue("RowIDs") ;//
    combindata=combindata+"^"+GetElementValue("EquipTypeDR") ;//48
    combindata=combindata+"^"+GetElementValue("Hold2");	//20150820  Mozy0160
    combindata=combindata+"^"+GetElementValue("Hold3");
    combindata=combindata+"^"+GetElementValue("Hold4");
    combindata=combindata+"^"+GetElementValue("Hold5");
    combindata=combindata+"^"+GetElementValue("Job");		//Add By DJ 2016-04-25
    
  	return combindata;
}
function GetEquipID(value)
{
	Clear()
	// 2012-02-27  Mozy0078
	//	0			1			2			3			4			5				6			7			8		9			10			11		12		13			14				15		16		17			18			19		20				21
	//TEquipDR,TStoreLocDR,TInStockListDR,TModelDR,TEquipCatDR,TEQManufacturerDR,TProviderDR,TEquipTypeDR,TEquip,TStoreLoc,TInStockNo,TQuantityNum,TModel,TEquipCat,TEQManufacturer,TProvider,TInDate,TEquipType,TLimitYearsNum,TNo,TLeaveFactoryNo,TOriginalFee)
	//alertShow(value)
	var val=value.split("^");
	SetElement("EquipDR", val[0]);
	SetElement("LocDR",val[1]);
	SetElement("InStockListDR", val[2]);
	SetElement("ModelDR", val[3]);
	SetElement("EquipCatDR", val[4]);
	SetElement("ManuFactoryDR", val[5]);
	SetElement("ProviderDR", val[6]);
	SetElement("EquipTypeDR",val[7]);
	SetElement("Equip", val[8]);
	SetElement("Loc",val[9]);
	SetElement("InStockList", val[10]);
	//SetElement("Amount", val[11]);
	SetElement("Model", val[12]);
	SetElement("EquipCat", val[13]);
	SetElement("ManuFactory", val[14]);
	SetElement("Provider", val[15]);
	SetElement("InDate", val[16]);
	SetElement("EquipType",val[17]);
	SetElement("LimitYears",val[18]);
	SetElement("No",val[19]);
	SetElement("LeaveFactoryNo",val[20]);
	SetElement("OriginalFee",val[21]);
	var KindFlag=GetElementValue("KindFlag")
	if (KindFlag==0) SetElement("Amount","1");
	SetElement("FileNo",val[23]);	//20150820  Mozy0160
	SetElement("RowIDs", "");
}

function Clear()
{
	SetElement("Equip","");
	SetElement("EquipDR","");
	//SetElement("LocDR","");
	//SetElement("Loc","");
	SetElement("InStockList","");
	SetElement("InStockListDR","");
	SetElement("Model","");
	SetElement("ModelDR","");
	SetElement("EquipCat","");
	SetElement("EquipCatDR","");
	SetElement("ManuFactory","");
	SetElement("ManuFactoryDR","");
	SetElement("Provider","");
	SetElement("ProviderDR","");
	SetElement("InDate","");
	SetElement("LeaveFactoryNo","");
	SetElement("No","");
	SetElement("EquipType","");
	SetElement("EquipTypeDR","");
	SetElement("LimitYears","");
	SetElement("Amount","");
	SetElement("OriginalFee","");
}

function SetEnabled()
{
	var Status=GetElementValue("Status");
	var Type=GetElementValue("Type");
		
	ReadOnlyElement("Opinion_"+GetElementValue("CurRole")+"_"+GetElementValue("RoleStep"),true);
	ReadOnlyElement("RejectReason",true);
	
	/// Mozy0074 2011-12-21
	var ReadOnly=GetElementValue("ReadOnly");
	if (ReadOnly=="1")
	{
		DisableBElement("BDetailAudit",true);// add by csy 2017-08-16 明细勾选报废 需求号：CSY0007
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BCancelSubmit",true);
		DisableBElement("BAudit",true);
		return
	}
	
	if ((Status>0))
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BAdd",true);
		var NextStep=GetElementValue("NextFlowStep");           //modified by czf 需求号：353836
		var CurRole=GetElementValue("CurRole");
		var NextRole=GetElementValue("NextRoleDR");
		var RoleStep=GetElementValue("RoleStep");
		var CancelFlag=GetElementValue("CancelFlag");
		if (Type=="1")
		{
			if ((CurRole==NextRole)&&(NextStep==RoleStep))    //modified by czf CZF0020 审批意见默认同意
			{
				SetElement("Opinion_"+CurRole+"_"+RoleStep,"同意");
			}
			if ((CurRole==NextRole)&&(NextStep==RoleStep)&&(CancelFlag=="Y"))
			{
				var obj=document.getElementById("BCancelSubmit");
				if (obj) obj.onclick=BCancelSubmit_Clicked;
				ReadOnlyElement("RejectReason",false);
				ReadOnlyElement("Opinion_"+GetElementValue("CurRole")+"_"+GetElementValue("RoleStep"),false);
			}
			else
			{
				DisableBElement("BDetailAudit",true);// add by csy 2017-08-16 明细勾选报废 需求号：CSY0007
				DisableBElement("BCancelSubmit",true);
				DisableBElement("BAudit",true);
				ReadOnlyElement("RejectReason",true);
				if(((CurRole==NextRole)&&(NextStep==RoleStep)&&(CancelFlag!="Y")))
				{
					DisableBElement("BAudit",false);
					var obj=document.getElementById("BAudit");
					if (obj) obj.onclick=BAudit_Clicked;
					ReadOnlyElement("Opinion_"+GetElementValue("CurRole")+"_"+GetElementValue("RoleStep"),false);
				}
			}
		}
		if ((Type=="")||(Status>=2))	//制单操作界面查询历史单据或审核后不允许取消提交和审核 Add By DJ 2017-10-23
		{
			DisableBElement("BCancelSubmit",true);
			DisableBElement("BAudit",true);
		}	
	}
	else
	{   
	    DisableBElement("BDetailAudit",true);// add by csy 2017-08-16 明细勾选报废 需求号：CSY0007
		DisableBElement("BAudit",true);
		DisableBElement("BCancelSubmit",true);
		if (Type!="0")
		{
			DisableBElement("BDetailAudit",true);// add by csy 2017-08-16 明细勾选报废 需求号：CSY0007
			DisableBElement("BUpdate",true);
			DisableBElement("BDelete",true);
			DisableBElement("BSubmit",true);
			DisableBElement("BAdd",true);
		}
		else
		{
			if (Status=="")
			{
				DisableBElement("BDetailAudit",true);// add by csy 2017-08-16 明细勾选报废 需求号：CSY0007
				DisableBElement("BDelete",true);
				DisableBElement("BSubmit",true);
			}
		}
	}	
}

function FillData()
{
	var RowID=GetElementValue("RowID");
	var EquipDR=GetElementValue("EquipDR");
	if (RowID!="")
	{
		//var sort=49
		var sort=53
		if (RowID<1)	return;
		var obj=document.getElementById("filldata");
		if (obj){var encmeth=obj.value} else {var encmeth=""};
		var ReturnList=cspRunServerMethod(encmeth,"","",RowID);		
		ReturnList=ReturnList.replace(/\\n/g,"\n");
		list=ReturnList.split("^");
		//SetElement("RowID", list[sort+16]);
		if (list[0]!="")
		{
			SetElement("EquipDR", list[0]);		
		}else
		{
			SetElement("EquipDR", list[44]);
		}
		SetElement("RequestLoc", list[sort+2]);
		SetElement("RequestLocDR", list[2]);
		SetElement("RequestDate", list[3]);
		SetElement("UseState", list[4]);
		SetElement("DisuseType", list[sort+3]);
		SetElement("DisuseTypeDR", list[5]);
		SetElement("ChangeReason", list[6]);
		SetElement("DisureDate", list[7]);
		SetElement("Remark", list[8]);
		SetElement("Status", list[9]);
		//SetElement("AddUserDR", list[10]);
		//SetElement("AddUser", list[sort+6]);
		//SetElement("AddDate", list[11]);
		//SetElement("AddTime", list[12]);
		//SetElement("UpdateUserDR", list[13]);
		//SetElement("UpdateUser", list[sort+8]);
		//SetElement("UpdateDate", list[14]);
		//SetElement("UpdateTime", list[15]);
		//SetElement("SubmitUserDR", list[16]);
		SetElement("SubmitUser", list[sort+6]);		//20150820  Mozy0160
		//SetElement("SubmitDate", list[17]);
		//SetElement("SubmitTime", list[18]);
		//SetElement("AuditUserDR", list[19]);
		//SetElement("AuditUserDR", list[sort+12]);
		//SetElement("AuditDate", list[20]);
		//SetElement("AuditTime", list[21]);
		SetElement("RejectReason", list[22]);
		//SetElement("RejectUserDR", list[23]);
		//SetElement("RejectUser", list[sort+14]);
		//SetElement("RejectDate", list[24]);
		//SetElement("RejectTime", list[25]);
		SetElement("ApproveSetDR", list[26]);
		SetElement("NextRoleDR", list[27]);
		SetElement("NextFlowStep", list[28]);
		SetElement("ApproveStatu", list[29]);
		SetElement("ApproveRoleDR", list[30]);
		//SetElement("Hold1", list[sort+21]);
		SetElement("RequestNo", list[32]);
		SetElement("Loc", list[sort+12]);
		SetElement("LocDR", list[33]);
		SetElement("TotleTime", list[34]);
		SetElement("Income", list[35]);
		SetElement("CheckResult", list[36]);
		SetElement("TechnicEvaluate", list[37]);
		SetElement("RepairHours", list[38]);
		SetElement("RepairFee", list[39]);
		SetElement("RepairTimes", list[40]);
		SetElement("LimitYears", list[41]);
		SetElement("EquipType", list[sort+14]);
		SetElement("EquipTypeDR", list[42]);
		SetElement("KindFlag", list[43]);
		SetElement("Hold2", list[45]);	//20150820  Mozy0160
		SetElement("Hold3", list[46]);
		SetElement("Hold4", list[47]);
		SetElement("Hold5", list[48]);
		SetElement("InStockList", list[sort+13]);
		SetElement("InStockListDR", list[44]);	
		SetElement("Equip", list[sort+16]);
		SetElement("Model", list[sort+17]);
		SetElement("ModelDR", list[sort+18]);
		SetElement("EquipCat", list[sort+19]);
		SetElement("EquipCatDR", list[sort+20]);
		SetElement("ManuFactory", list[sort+21]);
		SetElement("ManuFactoryDR", list[sort+22]);
		SetElement("Provider", list[sort+23]);
		SetElement("ProviderDR", list[sort+24]);
		SetElement("InDate", list[sort+25]);
		SetElement("RowIDs", list[sort+26]);
		SetElement("No", list[sort+27]);
		SetElement("LeaveFactoryNo", list[sort+28]);
		SetElement("OriginalFee", list[sort+29]);
		SetElement("FileNo",list[sort+47]);	//20150820  Mozy0160
		SetElement("CancelFlag",list[sort+48]);           //modified by czf 2017-03-28   需求号：353835
		var KindFlag=GetElementValue("KindFlag")
		if (KindFlag==2)          //2:多批报废,1:同种批量:,0：同种单台
		{
			SetElement("CancelFlag", list[sort+28]);
		}
	}
	else if (EquipDR!="")
	{
		var sort=EquipGlobalLen
		if (EquipDR<1)	return;
		var obj=document.getElementById("GetEquipInfo");
		if (obj){var encmeth=obj.value} else {var encmeth=""};
		var ReturnList=cspRunServerMethod(encmeth,"","",EquipDR);
		ReturnList=ReturnList.replace(/\\n/g,"\n");
		list=ReturnList.split("^");
		SetElement("RowID", "");
		SetElement("Equip", list[0]);
		SetElement("No",list[70]);
		SetElement("Status", "");
		SetElement("Loc", list[sort+26]);
		SetElement("LocDR", list[66]);
		SetElement("LimitYears", list[30]);
		SetElement("EquipType", list[sort+22]);
		SetElement("EquipTypeDR", list[62]);
		SetElement("InStockList", list[sort+42]);	
		SetElement("InStockListDR", list[69]);
		SetElement("Model", list[sort+0]);
		SetElement("ModelDR", list[2]);
		SetElement("EquipCat", list[sort+1]);
		SetElement("EquipCatDR", list[3]);
		SetElement("ManuFactory", list[sort+13]);
		SetElement("ManuFactoryDR", list[25]);
		SetElement("Provider", list[sort+12]);
		SetElement("ProviderDR", list[24]);
		SetElement("OriginalFee", list[26]);
		if (list[69]=="")
		{
			SetElement("InDate", list[sort+32]);
		}
		else
		{
			SetElement("InDate", list[sort+32]);
		}		
		SetElement("No", list[70]);
		SetElement("LeaveFactoryNo", list[9]);
		SetElement("FileNo",list[84]);	//20150820  Mozy0160
		SetElement("Amount", 1);
	}
}

function CheckNull()
{
	if (CheckMustItemNull()) return true;
	return false;
}
function CheckInvalidData()
{
	if (IsValidateNumber(GetElementValue("TotleTime"),1,0,0,1)==0)
	{
		alertShow("总使用时间异常,请修正.");
		return true;
	}
    if (IsValidateNumber(GetElementValue("Income"),1,1,0,1)==0)
	{
		alertShow("总效益异常,请修正.");
		return true;
	}
    if (IsValidateNumber(GetElementValue("RepairHours"),1,0,0,1)==0)
	{
		alertShow("再修复工时异常,请修正.");
		return true;
	}
    if (IsValidateNumber(GetElementValue("RepairFee"),1,1,0,1)==0)
	{
		alertShow("再修复费用异常,请修正.");
		return true;
	}
    if (IsValidateNumber(GetElementValue("RepairTimes"),1,0,0,1)==0)
	{
		alertShow("已修理次数异常,请修正.");
		return true;
	}
	
	return false;
}
function GetLocID(value)
{
	GetLookUpID('LocDR',value);
}

function GetRequestLocID(value)
{
	GetLookUpID('RequestLocDR',value);
}

function GetDisuseTypeID(value)
{
	GetLookUpID('DisuseTypeDR',value);
}

///???
function GetInStockListID(value)
{
	GetLookUpID('InStockListDR',value);
}
///Modified by zc 2015-04-09 zc0022
///描述:修改单台报废与多批次报废打印模版及程序的不区分
function BPrint_Click()
{
	var disuseid=GetElementValue("RowID");
	if (disuseid=="") return;
	if (GetElementValue("Status")=="0") return
	var encmeth=GetElementValue("filldata");	
	if (encmeth=="") return;
	var RequestData=cspRunServerMethod(encmeth,'','',disuseid);
	RequestData=RequestData.replace(/\\n/g,"\n");
	var lista=RequestData.split("^");
	//alertShow(lista);
	if((lista[43]==0)||(lista[43]==1))
	{
		try {
        	var xlApp,xlsheet,xlBook;
			var	TemplatePath=GetElementValue("GetRepPath");	
	    	var Template=TemplatePath+"DHCEQDisuse.xls";
	    	xlApp = new ActiveXObject("Excel.Application");
			xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	xlsheet.PageSetup.TopMargin=0;
	    	//医院名称替换 Add By DJ 2011-07-14
	    	xlsheet.cells.replace("[Hospital]",GetElementValue("GetHospitalDesc"))
	    	xlsheet.cells(3,3)=lista[32];//报废单号
	    	xlsheet.cells(3,6)=GetShortName(lista[65],"-");  //使用科室
	    	xlsheet.cells(3,9)=FormatDate(lista[11]);  //报废日期
	    	xlsheet.cells(4,3)=lista[69];  //设备名称
	    	xlsheet.cells(4,7)=GetElementValue("Model");  //规格型号
	    	xlsheet.cells(5,3)=lista[74];  //生产厂商
	    	//alertShow(lista[94]);
	    	xlsheet.cells(5,7)=FormatDate(lista[94]);  //验收日期
	    	xlsheet.cells(6,3)=lista[88];  //原值
	    	xlsheet.cells(6,7)=GetElementValue("Amount");  //数量
	    	xlsheet.cells(7,3)=lista[93];  //单位
	    	xlsheet.cells(7,7)=GetElementValue("Amount")*lista[88];  //金额
	    	xlsheet.cells(8,3)=lista[96];  //累计折旧
	    	xlsheet.cells(8,7)=FormatDate(lista[95]);  //入库日期           *
	    	xlsheet.cells(9,3)=lista[80];  //设备编号
	    	xlsheet.cells(10,3)=lista[6];  //报废原因
	    	xlsheet.cells(12,3)=lista[37];  //鉴定原因
	    	xlsheet.cells(18,3)=lista[8];  //备注  *

	   	 	/*
	    	xlsheet.cells(2,2)=FormatDate(lista[11]);
	    	xlsheet.cells(2,4)=GetShortName(lista[62],"-");  //使用科室
	    	xlsheet.cells(2,10)=lista[32];
	    	xlsheet.cells(4,1)=lista[66];  //设备名称
	    	xlsheet.cells(4,3)=GetElementValue("Model");  //规格型号
	    	xlsheet.cells(4,4)=lista[89];  //单位
	    	xlsheet.cells(4,5)=GetElementValue("Amount");  //数量
	    	xlsheet.cells(4,6)=lista[84];  //原值
	    	xlsheet.cells(4,7)=GetElementValue("Amount")*lista[84];  //金额
	    	xlsheet.cells(4,8)=lista[90];  //验收日期
	    	xlsheet.cells(4,9)=lista[91];  //入库日期
	    	xlsheet.cells(4,10)=lista[92];  //累计折旧
	    	xlsheet.cells(4,11)=lista[93];  //净值
	    	xlsheet.cells(5,3)=lista[73];  //供应商
	    	xlsheet.cells(6,3)=lista[71];  //生产厂商
	    	xlsheet.cells(7,3)=lista[77];  //设备编号
	    	xlsheet.cells(8,3)=lista[6];  //报废原因
	    	xlsheet.cells(8,10)=lista[53];  //经办人
	    	xlsheet.cells(10,3)=lista[37];  //鉴定原因
	    	//xlsheet.cells(13,3)="";  //后勤原因
	    	xlsheet.cells(15,10)="制单人:"+lista[53];  //制单人*/
	    	var obj = new ActiveXObject("PaperSet.GetPrintInfo");
	    	var size=obj.GetPaperInfo("letter");
	    	if (0!=size) xlsheet.PageSetup.PaperSize = size;
	    	xlsheet.printout; //打印输出
	    	xlBook.Close (savechanges=false);	    
	    	xlsheet.Quit;
	    	xlsheet=null;
	    	xlApp=null;
		}
		catch(e)
		{
			alertShow(e.message);
		}
	}
	else if(lista[43]==2)
	{
		var encmeth=GetElementValue("GetList");
		if (encmeth=="") return;
		var gbldata=cspRunServerMethod(encmeth,disuseid);
		var list=gbldata.split(GetElementValue("SplitNumCode"));
		var Listall=list[0];
		rows=list[1];
		var PageRows=6;
		var Pages=parseInt(rows / PageRows); //总页数?1  3为每页固定行数
		var ModRows=rows%PageRows; //最后一页行数
		if (ModRows==0) {Pages=Pages-1;}
        var xlApp,xlsheet,xlBook;
		var	TemplatePath=GetElementValue("GetRepPath");	
	    var Template=TemplatePath+"DHCEQDisuse11.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    for (var i=0;i<=Pages;i++)
	    {
			xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	//医院名称替换 Add By DJ 2011-07-14
	    	xlsheet.cells.replace("[Hospital]",GetElementValue("GetHospitalDesc"))
	    	xlsheet.cells(2,2)="报废单号:"+lista[32];//报废单号
	    	xlsheet.cells(2,6)=FormatDate(lista[11]);  //报废日期
	    	xlsheet.cells(2,9)=GetShortName(lista[55],"-");  //申请科室
	    	xlsheet.cells(3,2)="类  组:"+lista[67]; //类组
			xlsheet.cells(3,9)=GetShortName(lista[65],"-");  //使用科室
			var OnePageRow=PageRows;
	   		if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
	   		for (var j=1;j<=OnePageRow;j++)
			{
				var Lists=Listall.split(GetElementValue("SplitRowCode"));
				var Listl=Lists[i*PageRows+j];
				var List=Listl.split("^");
				var Row=4+j;
				if ((List[0]=='合计')&&(i==Pages))
				{
					//xlsheet.cells(10,2)=List[0];//设备名称
					//xlsheet.cells(10,6)=List[4];//数量
					//xlsheet.cells(10,8)=List[6];//金额
				}
				else
				{
					xlsheet.cells(Row,2)=List[0];//设备名称
					xlsheet.cells(Row,3)=List[1];//机型
					xlsheet.cells(Row,4)=List[2];//单位
					xlsheet.cells(Row,5)=List[3];//生产厂商
					xlsheet.cells(Row,6)=List[4];//入库日期
					xlsheet.cells(Row,7)=List[5];//数量
					xlsheet.cells(Row,8)=List[6];//原值
					xlsheet.cells(Row,9)=List[7];//金额		
				}
					var Row=Row+1;
				
	    	}
	    	var obj = new ActiveXObject("PaperSet.GetPrintInfo");
	    	var size=obj.GetPaperInfo("DHCEQInStock");
	    	if (0!=size) xlsheet.PageSetup.PaperSize = size;
	    	xlsheet.printout; //打印输出
	    	xlBook.Close (savechanges=false);	    
	    	xlsheet.Quit;
	    	xlsheet=null;
		}
		xlApp=null;
	}	
}

function GetEquipType (value)
{
    GetLookUpID("EquipTypeDR",value);
}

function SetEquipIDs(EquipIDs,LeaveFactoryNos,Nos,Qty,RowNo)
{
	if (Component=="DHCEQDisuseRequestSimple")
	{
		SetElement('TEquipIDsz'+RowNo,EquipIDs);
		SetElement('TQtyNumz'+RowNo,Qty);
		var TotalFee=0;
		TotalFee=Qty*GetElementValue("TOriginalFeez"+RowNo);
		TotalFee=TotalFee.toFixed(2);
		SetElement('TTotalFeez'+RowNo,TotalFee);
		SumList_Change()
	}
	else
	{
		SetElement("RowIDs",EquipIDs);
		SetElement("LeaveFactoryNo",LeaveFactoryNos);
		SetElement("No",Nos);
		SetElement("Amount",Qty);		
	}
}

function SourceType_Change()
{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var objtbl=document.getElementById('tDHCEQDisuseRequestSimple'); //得到表格   t+组件名称
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	
	selectrow=rowObj.rowIndex;								//当前选择行
	
	RowNo=GetTableCurRow();
	var TSourceType=GetElementValue("TSourceTypez"+RowNo)
	SetElement("TSourceTypeDRz"+RowNo,TSourceType);
	SetTableItem(RowNo,selectrow);		///改变一行的内容显示
	
	selectrow=RowNo;
	ClearValue();
	SetFocusColumn("TSourceTypez",selectrow);
}

function SetTableItem(RowNo,selectrow)
{
  	var objtbl=document.getElementById('t'+Component);
	var rows=objtbl.rows.length-1;
	if (RowNo=="")
	{
		for (var i=1;i<=rows;i++)
		{
			ObjSources[i]=new SourceInfo(GetElementValue("TSourceTypeDRz"+i),GetElementValue("TSourceIDz"+i));  //0,设备;1,入库单
			
			if(tableList[i]!="0") tableList[i]=0;
			var TRowID=GetElementValue("TRowIDz"+i);
			if (TRowID==-1)
			{
				obj=document.getElementById("BDeleteListz"+i);
				if (obj) obj.innerText=""
				obj=document.getElementById("TEquipListz"+i);
				if (obj)
				{
					obj.innerText=""
					DisableBElement("TEquipListz"+i,true);
					HiddenObj("TEquipListz"+i,1)
				}
				tableList[i]=-1;
				continue;
			}
			else
			{
				ChangeRowStyle(objtbl.rows[i]);		///改变一行的内容显示
			}
		}
	}
	else
	{
		if (selectrow=='') selectrow=RowNo
		tableList[RowNo]=0;
		ChangeRowStyle(objtbl.rows[selectrow]);		///改变一行的内容显示
	}
}

///改变一行的内容显示
function ChangeRowStyle(RowObj)
{
  	var objtbl=document.getElementById('t'+Component);
	var Status=GetElementValue("Status");
	for (var j=0;j<RowObj.cells.length;j++)
	{
		var html="";
		var value="";
    	if (!RowObj.cells[j].firstChild) {continue}
		var Id=RowObj.cells[j].firstChild.id;
		var offset=Id.lastIndexOf("z");
		var objindex=Id.substring(offset+1);
		var colName=Id.substring(0,offset);
		var objwidth=RowObj.cells[j].style.width;
		var objheight=RowObj.cells[j].style.height;
		if (colName=="TSource")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetCElementValue(Id);
         	html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpEquip","","","KeyUpEquip")
		}
		else if (colName=="TSourceType")
		{
			value=GetElementValue("TSourceTypeDRz"+objindex);	
			if (CheckUnEditField(Status,colName))
			{
				html=CreatElementHtml(4,Id,objwidth,objheight,"","","0^单台&1^批量","")
				RowObj.cells[j].innerHTML=html;
				DisableElement("TSourceTypez"+objindex,true);
				SetElement("TSourceTypez"+objindex,value);
				continue;
			}
			else
			{			
				//0^设备&1^入库明细&2^设备树
				html=CreatElementHtml(4,Id,objwidth,objheight,"KeyDown_Tab","SourceType_Change","0^单台&1^批量","")
			}
		}
		else if (colName=="TRemark")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetElementValue(Id);
			html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		else if (colName=="TUseState")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetElementValue(Id);
			html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		else if (colName=="TDisuseReason")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetElementValue(Id);
			html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		else if (colName=="BDeleteList")
		{
			if (Status>0)
			{
				HiddenObj(colName+"z"+objindex,1)
				continue;
			}
			RowObj.cells[j].onclick=DeleteClickHandler;
		}
		else if (colName=="TEquipList")
		{
			value=GetElementValue("TSourceTypeDRz"+objindex);
			//Begin add by jyp 2018-03-12 544929
			if(value!="1")
			{
				HiddenObj(colName+"z"+objindex,1)	
			}
			else
			{
				HiddenObj(colName+"z"+objindex,0)
			}
			//end add by jyp 2018-03-12 544929
			RowObj.cells[j].onclick=EquipListClick;
		}
		// add by csy 2017-08-16 begin 只有处于提交状态才显示  明细勾选报废 需求号：CSY0007
		else if (colName=="THold2")
		{
			if (Status!=1)
			{
				//DisableElement(colName+"z"+objindex,true);
				HiddenObj(colName+"z"+objindex,1)
				continue;
			}
		}
		// add by csy 2017-08-16 end  只有处于提交状态才显示 明细勾选报废 需求号：CSY0007
		if (html!="")
		{
			//RowObj.cells[j].firstChild.outerHTML=html;
			RowObj.cells[j].innerHTML=html;
		}
		if (value!="")
		{
         	value=trim(value);
		    if (RowObj.cells[j].firstChild.tagName=="LABEL")
		    {
			    RowObj.cells[j].firstChild.innerText=value;
			}
			else if (RowObj.cells[j].firstChild.tagName=="checkbox")
		    {
			    RowObj.cells[j].firstChild.checked=value;
			}
			else
		    {
			    RowObj.cells[j].firstChild.value=value;
		    }
         	RowObj.cells[j].firstChild.value=trim(value);
		}
	}
}

function ClearValue()
{
	selectrow=GetTableCurRow();
	SetElement('TSourcez'+selectrow,"");
	SetElement('TSourceIDz'+selectrow,"");
	SetElement('TModelz'+selectrow,"");
	SetElement('TManuFactoryz'+selectrow,"");
	SetElement('TProviderz'+selectrow,"");
	SetElement('TInDatez'+selectrow,"");
	SetElement('TLimitYearsz'+selectrow,"");
	
	SetElement('TQtyNumz'+selectrow,"");	
	SetElement('TOriginalFeez'+selectrow,"");
	SetElement('TTotalFeez'+selectrow,"");
	SetElement('TUnitz'+selectrow,"");
	SetElement('TUseStatez'+selectrow,"");	
	SetElement('TDisuseReasonz'+selectrow,"");
	SetElement('TDisuseDatez'+selectrow,"");
	SetElement('TEquipIDsz'+selectrow,"");	
	SetElement('TRemarkz'+selectrow,"");	
	
	// SetElement('THold2z'+selectrow,"");
	SetChkElement('THold2z'+selectrow,"");// add by csy 2017-08-16 明细勾选报废 需求号：CSY0007
	SetElement('THold3z'+selectrow,"");
	SetElement('THold4z'+selectrow,"");
	SetElement('THold5z'+selectrow,"");
	if (GetElementValue("TotalFlag")!=0)
	{
		SumList_Change();
	}
}
function LookUpEquip(vClickEventFlag)
{
	if (event.keyCode==13||event.keyCode==0||vClickEventFlag==1)
	{
		if (CheckNull()) return;
		selectrow=GetTableCurRow();
		var TSourceType=GetElementValue('TSourceTypez'+selectrow);
		if (TSourceType=="") return;
		GetExcludeIDs();
		//Add By DJ 2017-11-20 获取当前页当前行的行标,Job及所有明细清单.
		var AllListInfo=selectrow+"="+GetElementValue("Job")+"="+GetAllListInfo()
		SetElement("AllListInfo",AllListInfo)
		LookUp("","web.DHCEQBatchDisuseRequest:Equip","GetSourceID","LocDR,TSourceTypez"+selectrow+",TSourcez"+selectrow+",QXType,RowID,EquipTypeDR,ExcludeIDs,AllListInfo");
	}
}
///Modify By DJ 2012-12-14  DJ0109
///描述:多批选择记录时位置错位修改 
function GetSourceID(value)
{
	var list=value.split("^")
	var Length=ObjSources.length
	
	var LastSourceType=ObjSources[selectrow].SourceType //变动之前的SourceType
	var LastSourceID=ObjSources[selectrow].SourceID //变动之前的SourceID
	SetElement('TSourceTypeDRz'+selectrow,list[22]);
	if (list[22]==0)
	{
		for (var i=0;i<Length;i++)
		{
			if ((tableList[i]=="0")&&(ObjSources[i].SourceType=="0")&&(ObjSources[i].SourceID==list[0])&&(selectrow!=i))
			{
				var TRow=GetElementValue("TRowz"+i);
				alertShow("选择行与第"+(TRow)+"行是重复的设备!")
				return;
			}
		}
		ObjSources[selectrow]=new SourceInfo("0",list[0]);
	}
	else
	{
		for (var i=0;i<Length;i++)
		{
			if ((tableList[i]=="0")&&(ObjSources[i].SourceType=="1")&&(ObjSources[i].SourceID==list[2])&&(selectrow!=i))
			{
				var TRow=GetElementValue("TRowz"+i);
				alertShow("选择行与第"+(TRow)+"行是重复的入库单!")
				return;
			}
		}
		ObjSources[selectrow]=new SourceInfo("1",list[2]);
	}	
	
	SetElement('TSourcez'+selectrow,list[8]);
	if (list[22]==0)
	{
		//EquipTypeDR
		SetElement('TSourceIDz'+selectrow,list[0]);
		SetElement('TNoz'+selectrow,list[19]);
		SetElement('TQtyNumz'+selectrow,"1");
		SetElement('TTotalFeez'+selectrow,(list[21]*1).toFixed(2));
	}
	else
	{
		//InStockListDR
		SetElement('TSourceIDz'+selectrow,list[2]);
		//TInStockNo
		SetElement('TNoz'+selectrow,list[10]);
		SetElement('TQtyNumz'+selectrow,"");
		SetElement('TTotalFeez'+selectrow,"");
	}
	SetElement('TModelz'+selectrow,list[12]);
	SetElement('TManuFactoryz'+selectrow,list[14]);
	
	//单位?	
	//SetElement('TUnitz'+selectrow,list[9]);
	
	SetElement('TOriginalFeez'+selectrow,list[21]);
	SetElement('TInDatez'+selectrow,list[16]);
	SetElement('TLimitYearsz'+selectrow,list[18]);
	SetElement('TProviderz'+selectrow,list[15]);

	SumList_Change()
	var obj=document.getElementById("TSourcez"+selectrow);
	if (obj) websys_nextfocusElement(obj); 
}

function AddClickHandler() {
	try 
	{
  		var objtbl=document.getElementById('tDHCEQDisuseRequestSimple');
  		//增加新明细前，先检测是否现有明细已选择具体设备Add By DJ 2017-11-20
		var rows=tableList.length
		for(var i=1;i<rows;i++)
		{
			if (tableList[i]=="0")
			{
				var TRow=GetElementValue("TRowz"+i);
				var TQtyNum=GetElementValue("TQtyNumz"+i);
				if (TQtyNum=="")
				{
					alertShow("请先选择第"+TRow+"行需报废的设备明细!")
					return
				}
			}
		}
		
		var ret=CanAddRow(objtbl);
		if (ret)
		{
			NewNameIndex=tableList.length;
	    	AddRowToList(objtbl,LastNameIndex,NewNameIndex);
	    	ObjSources[NewNameIndex]=new SourceInfo("","");
	    	SetElement("TSourceTypeDRz"+NewNameIndex,GetElementValue("TSourceTypez"+NewNameIndex));
	    }
        return false;
	}
	catch(e)
	{};
}
function CanAddRow(objtbl)
{
	var rows=objtbl.rows.length;
    if (rows==1) return false;
	var TotalFlag=GetElementValue("TotalFlag")
	if (TotalFlag==2) rows=rows-1
	LastNameIndex=GetRowIndex(objtbl.rows[rows-1]);
	if  (GetElementValue('TSourcez'+LastNameIndex)=="")
	{
		SetFocusColumn("TSource",LastNameIndex);
		return false;
	}
	return true;
}

function DeleteClickHandler() {
	var truthBeTold = window.confirm(t["-4003"]);
	if (!truthBeTold) return;
	try
	{
  		var objtbl=document.getElementById('t'+Component);
		var rows=objtbl.rows.length;
		selectrow=GetTableCurRow();
		
		var TotalFlag=GetElementValue("TotalFlag")
		
		var TRowID=GetElementValue('TRowIDz'+selectrow);
		tableList[selectrow]=TRowID;
		var delNo=GetElementValue("TRowz"+selectrow);
		
		if (((TotalFlag==0)&&(rows<=2))||((rows<=3)&&((TotalFlag==1)||(TotalFlag==2))))
		{
			//Modified by jdl 2011-01-28 JDL0068
			//修改删除仅剩的一行后?编辑保存数据异常?无法保存的问题
			tableList[selectrow]=0;
			if (TRowID!="")
			{
				SetElement('TRowIDz'+selectrow,"");				
				tableList[tableList.length]=TRowID;
			}
			ClearValue()
			//SetElement("Job","")		Modify DJ 2015-09-10 DJ0163
		} 
		else
		{
	    	var eSrc=window.event.srcElement;
			var rowObj=getRow(eSrc);
			objtbl.deleteRow(rowObj.rowIndex);
		}
		ResetNo(selectrow,delNo);
	    SumList_Change();
	} catch(e) {};
}


function SetDisplay()
{
	
	var Status=GetElementValue("Status");
	ReadOnlyCustomItem(GetParentTable("RequestNo"),Status);
	ReadOnlyElement("RequestNo",true)
	TransDisableToReadOnly("input");
	TransDisableToReadOnly("textarea");
}

function SumList_Change()
{
	var SumIndex=0
	var SumFee=0
	var SumQty=0
	var length=tableList.length
	for (var i=1;i<=length;i++)
	{
		if (tableList[i]=="0")
		{
			if (GetElementValue("TQtyNumz"+i)=="") continue;
			var TotalFee=GetElementValue("TQtyNumz"+i)*GetElementValue("TOriginalFeez"+i);		//Add By DJ 2016-04-25
			TotalFee=TotalFee.toFixed(2);
			SetElement('TTotalFeez'+i,TotalFee);
			var TTotalFee=parseFloat(GetElementValue("TTotalFeez"+i))
			var TQtyNum=parseInt(GetElementValue("TQtyNumz"+i))
			if ((isNaN(TTotalFee))||(isNaN(TQtyNum))) continue;
			SumFee=SumFee+TTotalFee;
			SumQty=SumQty+TQtyNum;
		}
		else if (tableList[i]==-1)
		{
			var SumIndex=i
		}
	}
	SetElement('TTotalFeez'+SumIndex,SumFee.toFixed(2));
	SetElement('TQtyNumz'+SumIndex,SumQty);
}

function EquipListClick()
{
	var InStockListDR=""
	var EquipDR=""
	if (Component=="DHCEQBatchDisuseRequest")
	{
		InStockListDR=GetElementValue("InStockListDR")
		if (InStockListDR=="")
		{
			alertShow("请先选择设备!")
			return
		}
		EquipDR=""
		selectrow="1"
		var QuantityNum=GetElementValue("Amount")
		var Job=GetElementValue("Job")
		var MXRowID=GetElementValue("RowID")
		var Type=6
	}
	else
	{
		selectrow=GetTableCurRow();
		var SourceType=GetElementValue("TSourceTypez"+selectrow)
		if (SourceType!="1")
		{
			alertShow(t[-1007]);
			return;
		}
		if (GetElementValue("TSourceIDz"+selectrow)=="")
		{
			alertShow(t[-1012]);
			return;
		}	
		if (SourceType=="1")	//批量
		{
			InStockListDR=GetElementValue("TSourceIDz"+selectrow);
		}
		else					//单台
		{
			EquipDR=GetElementValue("TSourceIDz"+selectrow);
		}
		if ((InStockListDR=="")&&(EquipDR=="")) return
		var QuantityNum=GetElementValue("TQtyNumz"+selectrow)
		var Job=GetElementValue("Job")
		var MXRowID=GetElementValue("TRowIDz"+selectrow)
		var Type=5
	}
	if (Job=="") //270333  Add BY BRB 2016-11-02 
	{
		return;
	}
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQUpdateEquipsByList";
	lnk=lnk+"&SourceID="+InStockListDR
	lnk=lnk+"&QuantityNum="+QuantityNum
	lnk=lnk+"&Job="+Job
	lnk=lnk+"&index="+selectrow
	lnk=lnk+"&MXRowID="+MXRowID
	lnk=lnk+"&StoreLocDR="+GetElementValue("LocDR")
	lnk=lnk+"&Status="+GetElementValue("Status")
	lnk=lnk+"&Type="+Type
	lnk=lnk+"&EquipID="+EquipDR
   	window.open(lnk,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
	/*
	var InStockListDR;
	var ExcludeIDs="";
	var RowIDs="";
	if (Component=="DHCEQBatchDisuseRequest")
	{
		var EquipDR=GetElementValue("EquipDR")
		if (EquipDR=="")
		{
			alertShow(t[-1004]);
			return;
		}
		InStockListDR=GetElementValue("InStockListDR");
		RowIDs=GetElementValue("RowIDs");
	}
	else
	{
		selectrow=GetTableCurRow();
		var SourceType=GetElementValue("TSourceTypez"+selectrow)
		if (SourceType!="1")
		{
			alertShow(t[-1007]);
			return;
		}
		if (GetElementValue("TSourceIDz"+selectrow)=="")
		{
			alertShow(t[-1012]);
			return;
		}
		InStockListDR=GetElementValue("TSourceIDz"+selectrow);
		//ExcludeIDs=GetExcludeIDs();
		//RowIDs=GetElementValue("TEquipIDsz"+selectrow);
	}
	
	var val="&LocDR="+GetElementValue("LocDR");
	val=val+"&InStockListDR="+InStockListDR;	
	val=val+"&RowID="+GetElementValue("RowID")
	val=val+"&Status="+GetElementValue("Status")
	val=val+"&SelectRow="+selectrow;
	val=val+"&ExcludeIDs="+ExcludeIDs;
	val=val+"&RowIDs="+RowIDs;
	var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQDisuseEquipList"+val;
   	window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
   	*/
}

function KeyUpEquip()
{
	selectrow=GetTableCurRow();
	SetElement('TSourceIDz'+selectrow,"");	
}

///保存或删除报废单
function SaveDisuseRequest(ReqVal, ListVal, DelListIDs, IsDel)
{
	var encmeth=GetElementValue("GetSaveData");
	
	var rtn=cspRunServerMethod(encmeth,ReqVal, ListVal, DelListIDs, IsDel);
	var list=rtn.split("^");
	if (list[0]!=0)
	{
		alertShow(EQMsg(list[1],list[0]));
		//失败 返回SQLCODE
		return -1;
	}
	//成功返回 RowID
	return list[1];
}

///提交报废单
function SubmitRequest()
{
	//midified by zy 2015-7-1 ZY0134
	var RowID=GetElementValue("RowID");
	if (RowID=="")  return;
	var GetStopEquipFlag=GetElementValue("GetStopEquipFlag")
	if (GetStopEquipFlag==1)
	{
		var truthBeTold = window.confirm("当前报废设备是否停用?");
		if (truthBeTold) GetStopEquipFlag=2
	}
	if (GetStopEquipFlag==2)
	{
		var encmeth=GetElementValue("StopFlag");
		var result=cspRunServerMethod(encmeth,"34",RowID,"1");
		if (result!=0)
		{
			alertShow("设备停用失败!")
			return;
		}
	}
	var encmeth=GetElementValue("GetSubmit");
	if (encmeth=="")  return;
	//end by zy 2015-7-1
	var rtn=cspRunServerMethod(encmeth,RowID);
	if (rtn==0)
    {	    
	    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT='+Component+'&Type=1&RowID='+RowID
    }
    else
    {
	    var list=rtn.split("^");
	    alertShow(EQMsg(list[1],list[0]));
    }	
}


///取消提交报废单
function CancelSubmit()
{
	//midified by zy 2015-7-1 ZY0134
	var RowID=GetElementValue("RowID");
	if (RowID=="")  return;
	
	var GetStopEquipFlag=GetElementValue("GetStopEquipFlag")
	if (GetStopEquipFlag==1)
	{
		var truthBeTold = window.confirm("当前报废设备是否取消停用?");
		if (truthBeTold) GetStopEquipFlag=2;
	}
	if (GetStopEquipFlag==2)
	{
		var encmeth=GetElementValue("StopFlag");
		var result=cspRunServerMethod(encmeth,"34",RowID,"0");
		if (result!=0)
		{
			alertShow("设备取消停用失败!")
			return;
		}
	}
	var RejectReason=GetElementValue("RejectReason")
	if (RejectReason=="")
	{
		alertShow(t[-1003])
		SetFocus("RejectReason") 	//2011-02-19 ZY0062
		return
	}
	
	var combindata=RowID+"^"+RejectReason+"^"+GetElementValue("CurRole");
	var encmeth=GetElementValue("GetCancelSubmit");
	if (encmeth=="")  return;
	var rtn=cspRunServerMethod(encmeth,combindata);
	
	if (rtn==0)
    {
	    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT='+Component+'&Type=1&RowID='+RowID
    }
    else
    {
	    var list=rtn.split("^");
	    alertShow(EQMsg(list[1],list[0]));
    }	
}

///审批报废单
function Audit()
{	
	var RowID=GetElementValue("RowID");
	if (RowID=="")  return;
	var Type=GetElementValue("Type");

	if (CheckAuditNull()) return;		
	var combindata=RowID+"^"+GetOpinion();
	var encmeth=GetElementValue("GetAudit");
	var rtn=cspRunServerMethod(encmeth,combindata);
    if (rtn==0)
    {
	    window.location.reload();
	}
    else
    {
	    var list=rtn.split("^");
	    alertShow(EQMsg(list[1],list[0]));
    }    
}


function GetTableInfo()
{
    var objtbl=document.getElementById('tDHCEQDisuseRequestSimple');
	var rows=tableList.length
	var ListVal="";
	for(var i=1;i<rows;i++)
	{
		if (tableList[i]=="0")
		{
			var TRow=GetElementValue("TRowz"+i);
			var TRowID=GetElementValue("TRowIDz"+i);
			var TSourceType=GetElementValue("TSourceTypeDRz"+i);
			var TSourceID=GetElementValue("TSourceIDz"+i);
			var TQtyNum=GetElementValue("TQtyNumz"+i);
			var TUseState=GetElementValue("TUseStatez"+i);			
			var TDisuseReason=GetElementValue("TDisuseReasonz"+i);
			var TDisuseDate=GetElementValue("TDisuseDatez"+i);
			var TRemark=GetElementValue("TRemarkz"+i);
			var THold1=GetElementValue("TOriginalFeez"+i);
			// var THold2=GetElementValue("THold2z"+i);
			var THold2=GetChkElementValue("THold2z"+i); // add by csy 2017-08-16 明细勾选报废 需求号：CSY0007
			var THold3=GetElementValue("THold3z"+i);
			var THold4=GetElementValue("THold4z"+i);
			var THold5=GetElementValue("THold5z"+i);
			var TEquipIDs=GetElementValue("TEquipIDsz"+i);
			var TJob=GetElementValue("Job");		//Add By DJ 2016-04-25
			if ((TSourceType==""))
			{
				alertShow("第"+TRow+"行,请选择正确的类型")
				SetFocusColumn("TSourceType",i)
				return "-1"
			}
			if ((TSourceID==""))
			{
				alertShow("第"+TRow+"行,请选择正确的设备信息")
				SetFocusColumn("TSourceID",i)
				return "-1"
			}
			//add by zy ZY0089
			if ((TSourceType==1)&&(TQtyNum==""))		//Modify DJ 2016-04-25
			{				
				alertShow("第"+TRow+"行,请选择要报废的设备")
				return "-1"
			}
						
			if(ListVal!="") {ListVal=ListVal+"&";}			
			ListVal=ListVal+TRow+"^"+TRowID+"^"+TSourceType+"^"+TSourceID+"^"+TQtyNum+"^"+TUseState+"^"+TDisuseReason+"^"+TDisuseDate+"^"+TRemark;
			ListVal=ListVal+"^"+THold1+"^"+THold2+"^"+THold3+"^"+THold4+"^"+THold5+"^"+TEquipIDs+"^"+i+"^"+TJob;
		}
	}
	return  ListVal;
}

function GetExcludeIDs()
{
	return ""		//Modify DJ 2016-04-25
	var length=tableList.length
	var ExcludeIDs="";
	for (var i=1;i<=length;i++)
	{
		if (i==selectrow) continue;
		if (tableList[i]=="0")
		{			
			var SourceType=GetElementValue("TSourceTypeDRz"+i);
			if (ObjSources[i].SourceType==0)
			{
				if (ObjSources[i].SourceID!="")
				{
					if (ExcludeIDs!="") ExcludeIDs=ExcludeIDs+",";
					ExcludeIDs=ExcludeIDs+ObjSources[i].SourceID;
				}
			}
			else if (ObjSources[i].SourceType==1)
			{
				if (GetElementValue("TEquipIDsz"+i)!="")
				{
					if (ExcludeIDs!="") ExcludeIDs=ExcludeIDs+",";
					ExcludeIDs=ExcludeIDs+GetElementValue("TEquipIDsz"+i);
				}
			}
			else
			{
			}			
		}
		else
		{
		}
	}
	SetElement("ExcludeIDs",ExcludeIDs);
	return ExcludeIDs;
}
// // add by csy 2017-08-16 明细勾选报废 需求号：CSY0007  begin
function BDetailAudit_Click()
{
	var objtbl=document.getElementById('tDHCEQDisuseRequestSimple');//+组件名
	var rows=objtbl.rows.length-1;
	var valList="";
	for (var i=1;i<=rows;i++)
	{
		var TRowID=GetElementValue("TRowIDz"+i);
		var THold2=GetChkElementValue("THold2z"+i);
		if (TRowID!=-1){
		if(valList!="") {valList=valList+"&";}			
		valList=valList+TRowID+"^"+THold2;
		}
	}
	var RowID=GetElementValue("RowID");
	if (RowID=="")  return;
	var encmeth=GetElementValue("DetailAudit");
	var result=cspRunServerMethod(encmeth,valList,RowID);
	var Type=GetElementValue("Type");
	var list=result.split("^")
	if (list[0]==0)
	{
		alertShow("操作成功,勾选的设备新生成的审核状态的报废单号为"+list[2]);
		var str='websys.default.csp?WEBSYS.TCOMPONENT='+Component+'&Type='+Type+'&RowID='+list[1]
		window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0');
	}
	else
	{
		alertShow(EQMsg(list[1],list[0]));
	}
	window.location.reload();
}

function SelectAll_Clicked()
{
	var valRowIDs=""
	var eSrc=window.event.srcElement;
	var obj=document.getElementById("SelectAll");
	var Objtbl=document.getElementById('tDHCEQDisuseRequestSimple');
	var Rows=Objtbl.rows.length;
	for (var i=1;i<Rows;i++)
	{
		var selobj=document.getElementById('THold2z'+i);
		selobj.checked=obj.checked;
		if (selobj.checked==true)
		{
			var Select=document.getElementById("THold2z"+i);
			var Select=Select.checked
		}
	}
}
//Add By DJ 2017-11-20
function GetAllListInfo()
{
  	var objtbl=document.getElementById('tDHCEQDisuseRequestSimple');
	var rows=tableList.length
	var valList="";
	for(var i=1;i<rows;i++)
	{
		if (tableList[i]=="0")
		{
			var TRowID=GetElementValue('TRowIDz'+i);
			if(valList!="")	{valList=valList+"&";}
			valList=valList+i+"^"+TRowID;
		}
	}
	return valList
}
// add by csy 2017-08-16 明细勾选报废 需求号：CSY0007  end
document.body.onload = BodyLoadHandler;

