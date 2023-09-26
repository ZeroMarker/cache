/// Modified By HZY 2012-11-29 HZY0036. 
/// 修改描述:在入库明细中允许有设备项重复的,只要型号不同时重复就行
/// 修改函数:GetModel() , GetMasterItem()
/// 新增函数:Model_Change()
/// ----------------------------------
/// Modified By HZY 2012-01-17 HZY0021
/// 修改函数:  SetEnabled , SetTableItem
/// 新增函数: FundsClickHandler ,
/// ----------------------------------
/// 创    建:ZY  2009-12-02  No.ZY0018
/// 修改描述:批量入库
/// --------------------------------
var selectrow=0;


///记录 设备 RowID?处理重复选择RowID的问题
var ObjSources=new Array();

//最后一行数据元素的名字的后缀序号
var LastNameIndex;
//新增一行数据元素的名字的后缀序号
var NewNameIndex;

document.body.onload = BodyLoadHandler;

function BodyLoadHandler() 
{
	KeyUp("OpenCheck^Loc^Provider^FromDept^Origin^BuyLoc^BuyUser^EquipType^StatCat","N");
	InitUserInfo();
	InitPage();	
	FillData();
	SetEnabled();
	InitEditFields(GetElementValue("ApproveSetDR"),GetElementValue("CurRole"));
	InitApproveButton();
	SetTableItem('','','');
	SetDisplay();
	SetElementEnabled();	//Mozy0064	2011-10-24
	SetFocus("OpenCheck");
	Muilt_LookUp("OpenCheck^Loc^Provider^FromDept^Origin^BuyLoc^BuyUser^EquipType^StatCat")
}

///Modified By HZY 2012-01-31 HZY0021
function SetEnabled()
{
	var Status=GetElementValue("Status");
	var WaitAD=GetElementValue("WaitAD");
	SetElement("ReadOnly",0);	//初始不为只读.Add By HZY 2012-01-31 HZY0021
	//状态为新增时,方可提交或删除
	//状态小于1时?方可增删改
	if (Status!="0")
	{
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		if (Status!="")
		{
			DisableBElement("BUpdate",true);
			DisableBElement("BAdd",true);
			DisableBElement("BClear",true);
			SetElement("ReadOnly",1);	//Add By HZY 2012-01-31 HZY0021
		}
	}
	//审核后才可打印及生成转移单
	if (Status!="2")
	{
		DisableBElement("BToMove",true);
		DisableBElement("BPrint",true);
		DisableBElement("BPrintBar",true);
	}
	//非建单据菜单,不可更新等操作单据
	if (WaitAD!="off")
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BAdd",true);
		DisableBElement("BClear",true);
		SetElement("ReadOnly",1);	//非建单据菜单,设为只读.Add By HZY 2012-01-31 HZY0021
	}
	DisableBElement("BCancel",true);
	if (Status=="2")
	{
		var CancelOper=GetElementValue("CancelOper")
		if (CancelOper=="Y")
		{
			DisableBElement("BCancel",false);
			var obj=document.getElementById("BCancel");
			if (obj) obj.onclick=BCancel_Clicked;
		}
	}
}

function FillData()
{
	var obj=document.getElementById("RowID");
	var RowID=obj.value;
	if ((RowID=="")||(RowID<1)){
		return;
	}
	var obj=document.getElementById("fillData");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var ReturnList=cspRunServerMethod(encmeth,RowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	list=ReturnList.split("^");
	var sort=31
	SetElement("InDate",list[0]);
	SetElement("LocDR",list[1]);
	SetElement("Loc",list[sort+0]);
	SetElement("RejectReasonDR",list[2]);
	SetElement("RejectReason",list[sort+1]);
	SetElement("RequestUserDR",list[3]);
	SetElement("RequestUser",list[sort+2]);
	SetElement("RequestDate",list[4]);
	SetElement("AuditUserDR",list[5]);
	SetElement("AuditUser",list[sort+3]);
	SetElement("AuditDate",list[6]);
	SetElement("RejectUserDR",list[7]);
	SetElement("RejectUser",list[sort+4]);
	SetElement("RejectDate",list[8]);
	SetElement("Status",list[9]);
	SetElement("Remark",list[10]);
	SetElement("BillAuditUserDR",list[11]);
	SetElement("BillAuditUser",list[sort+5]);
	SetElement("BillAuditDate",list[12]);
	SetElement("InStockNo",list[13]);
	SetElement("OriginDR",list[14]);
	SetElement("Origin",list[sort+6]);
	SetElement("FromDeptDR",list[15]);
	SetElement("FromDept",list[sort+7]);
	SetElement("ProviderDR",list[16]);
	SetElement("Provider",list[sort+8]);
	SetElement("BuyLocDR",list[17]);
	SetElement("BuyLoc",list[sort+9]);
	SetElement("BuyUserDR",list[18]);
	SetElement("BuyUser",list[sort+10]);
	SetElement("EquipTypeDR",list[19]);
	SetElement("EquipType",list[sort+11]);
	SetElement("StatCatDR",list[20]);
	SetElement("StatCat",list[sort+12]);
	//Mozy0064	2011-10-24
	SetElement("CancelReason",list[25]);
	SetElement("Hold1",list[26]);
	SetElement("Hold2",list[27]);
	SetElement("Hold3",list[28]);
	SetElement("Hold4",list[29]);
	SetElement("Hold5",list[30]);
	//alertShow(list[sort+17])
	SetElement("ApproveSetDR",list[sort+17]);
	SetElement("NextRoleDR",list[sort+18]);
	SetElement("NextFlowStep",list[sort+19]);
	SetElement("ApproveStatu",list[sort+20]);
	SetElement("ApproveRoleDR",list[sort+21]);
	SetElement("CancelFlag",list[sort+22]);
	SetElement("CancelToFlowDR",list[sort+23]);
}


function InitPage()
{
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Clicked;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Clicked;
	var obj=document.getElementById("BSubmit");
	if (obj) obj.onclick=BSubmit_Clicked;
	var obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_Clicked;
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_Clicked;
	var obj=document.getElementById("BPrintBar");
	if (obj) obj.onclick=DHCEQInStockPrintBar;
	var obj=document.getElementById("BToMove");
	if (obj) obj.onclick=BToMove;
	if (opener)
	{
		var obj=document.getElementById("BClose");
		if (obj) obj.onclick=CloseWindow;
	}
	else
	{
		EQCommon_HiddenElement("BClose")	
	}
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=AddClickHandler;
	var GetProviderOperMethod=GetElementValue("GetProviderOperMethod")
	// 0:放大镜选择模式 1:手工录入模式,并自动更新机型表 2:两种均可
	if (GetProviderOperMethod==1) 
	{
		document.getElementById("ld"+GetElementValue("GetComponentID")+"iProvider").removeNode(true)
	}
	var obj=document.getElementById("BCancel");
	if (obj) obj.onclick=BCancel_Clicked;
}

//Mozy0064	2011-10-24
function SetElementEnabled()
{
	var Status=GetElementValue("Status");
	if (Status!="1")
	{
		SetElementsReadOnly("CancelReason",true);
	}
	else
	{
		SetElementsReadOnly("CancelReason",false);
	}
}
function SetElementsReadOnly(val,flag)
{
	var List=val.split("^")
	for(var i = 0; i < List.length; i++)
	{
		DisableElement(List[i],flag);
		ReadOnlyElement(List[i],flag);
		if (document.getElementById(GetLookupName(List[i])))
		{
			DisableElement(GetLookupName(List[i]),flag);
		}
	}
}

///生成出库单,并转到该出库单
function BToMove()
{
	var obj=document.getElementById("BToMove");
	if ((!obj)||(obj.disabled)) return;
	var encmeth=GetElementValue("GetToMove");
	var RowID=GetElementValue("RowID");
	if ((RowID=="")||(encmeth=="")) return;
	var StoreMoveID=cspRunServerMethod(encmeth,RowID,Guser);
	if (StoreMoveID<1)
	{
		alertShow(t["05"]);
	}
	else
	{
		//window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQStoreMoveNew&RowID='+StoreMoveID+"&Type=0&QXType=2&ValEquipType=1";
		var url=window.location.href //GR0026 新窗口打开模态窗口,通过改变参数值解决预缓存问题？
	    if(url.indexOf("killcache=1")!=-1)  window.location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQStoreMoveNew&killcache=0&RowID='+StoreMoveID+"&Type=0&QXType=2&ValEquipType=1";
	    else 								window.location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQStoreMoveNew&killcache=1&RowID='+StoreMoveID+"&Type=0&QXType=2&ValEquipType=1";
	
	}
}
function BUpdate_Clicked()
{
	var GetProviderOperMethod=GetElementValue("GetProviderOperMethod")
	if (GetProviderOperMethod=="") SetElement("GetProviderOperMethod", "0");
	if (CheckNull()) return;
	var combindata="";
  	combindata=GetElementValue("RowID") ;
  	combindata=combindata+"^"+GetElementValue("InDate") ;
  	combindata=combindata+"^"+GetElementValue("LocDR") ;
  	combindata=combindata+"^"+GetElementValue("RejectReasonDR") ;
  	
  	//Modified by jdl 2011-3-2  JDL0071
  	//combindata=combindata+"^"+GetElementValue("RequestUserDR") ;
  	combindata=combindata+"^"+curUserID;
  	
  	combindata=combindata+"^"+GetElementValue("RequestDate") ;
  	combindata=combindata+"^"+GetElementValue("AuditUserDR") ;
  	combindata=combindata+"^"+GetElementValue("AuditDate") ;
  	combindata=combindata+"^"+GetElementValue("RejectUserDR") ;
  	combindata=combindata+"^"+GetElementValue("RejectDate") ;
  	combindata=combindata+"^"+GetElementValue("Status") ;
  	combindata=combindata+"^"+GetElementValue("Remark") ;
  	combindata=combindata+"^"+GetElementValue("BillAuditUserDR") ;
  	combindata=combindata+"^"+GetElementValue("BillAuditDate") ;
  	combindata=combindata+"^"+GetElementValue("InStockNo") ;
  	combindata=combindata+"^"+GetElementValue("OriginDR");
  	combindata=combindata+"^"+GetElementValue("FromDeptDR") ;
  	combindata=combindata+"^"+GetProviderRowID(GetElementValue("GetProviderOperMethod"));
  	combindata=combindata+"^"+curUserID;
  	combindata=combindata+"^"+GetElementValue("BuyLocDR") ;
  	combindata=combindata+"^"+GetElementValue("BuyUserDR") ;
  	combindata=combindata+"^"+GetElementValue("EquipTypeDR");
  	combindata=combindata+"^"+GetElementValue("StatCatDR") ;
  	//Mozy0064	2011-10-24
  	combindata=combindata+"^"+GetElementValue("CancelReason");
  	combindata=combindata+"^"+GetElementValue("Hold1");
  	combindata=combindata+"^"+GetElementValue("Hold2");
  	combindata=combindata+"^"+GetElementValue("Hold3");
  	combindata=combindata+"^"+GetElementValue("Hold4");
  	combindata=combindata+"^"+GetElementValue("Hold5");
  	var valList=GetTableInfo();
  	if (valList=="-1")  return;
  	var DelRowid=tableList.toString()
  	var encmeth=GetElementValue("Update")
  	if (encmeth=="") return;
  	//SetElement("Remark",combindata+"%"+valList+DelRowid);

	var Rtn=cspRunServerMethod(encmeth,combindata,valList,DelRowid);
	
	if (Rtn>0)
    {
	    //add by HHM 20150910 HHM0013
		//添加操作成功是否提示
		ShowMessage();
		//****************************
	    //window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInStockNew&RowID='+Rtn+"&WaitAD=off";
	    var url=window.location.href //GR0026 新窗口打开模态窗口,通过改变参数值解决预缓存问题？
	    if(url.indexOf("killcache=1")!=-1)  window.location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInStockNew&killcache=0&RowID='+Rtn+"&WaitAD=off";
	    else 								window.location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInStockNew&killcache=1&RowID='+Rtn+"&WaitAD=off";
	
	}
    else
    {
	    ///Modified by JDL 2012-2-23 补充Mozy0076
	    alertShow(EQMsg(t["01"],Rtn));
    }
}
function BDelete_Clicked()
{
	var truthBeTold = window.confirm(t["-4003"]);
	if (!truthBeTold) return;
	var combindata=GetValueList();
  	var encmeth=GetElementValue("DeleteData")
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,combindata);
	if (Rtn=="0")
    {
		var WaitAD=GetElementValue("WaitAD");
		var QXType=GetElementValue("QXType");
		//window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInStockNew&WaitAD='+WaitAD+"&QXType="+QXType;
		var url=window.location.href //GR0026 新窗口打开模态窗口,通过改变参数值解决预缓存问题？
	    if(url.indexOf("killcache=1")!=-1)  window.location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInStockNew&killcache=0&WaitAD='+WaitAD+"&QXType="+QXType;
	    else 								window.location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInStockNew&killcache=0&WaitAD='+WaitAD+"&QXType="+QXType;
	
	}
    else
    {
	    alertShow(t[Rtn]+"   "+t["01"]);
    }
}
function BSubmit_Clicked()
{
	if (CheckNull()) return;
	var combindata=GetValueList();
  	var valList=GetTableInfo();
  	if (valList=="-1")  return;
  	if (valList=="")
  	{
	  	alertShow(t["-1003"])
	  	return;
	}
	///add by zy 2011-10-25 zy0083
	var rowid=GetElementValue("RowID");
	var encmeth=GetElementValue("CheckFeeArea");
	var result=cspRunServerMethod(encmeth,"InStock",rowid);
	var list=result.split("^");
	if (list[0]=="-1012")
	{
		alertShow(list[1]+" "+t[list[0]])
		return;
	}
	else if ((list[0]==-1013)||(list[0]==-1014))
	{
		var truthBeTold = window.confirm(list[1]+" "+t[list[0]]);
		if (truthBeTold) return;
	}
	//20170329	自动出库
	var outflag=cspRunServerMethod(GetElementValue("GetAutoInOut"),GetElementValue("RowID")+"^"+GetElementValue("CurRole")+"^"+GetElementValue("RoleStep"));
	if (outflag==1)
	{
		//检测入库单是否满足自动出库条件
		var encmeth=GetElementValue("CheckAutoMoveFlag")
		if (encmeth=="") return;
		var CheckAutoMoveFlag=cspRunServerMethod(encmeth,rowid);
		var CAMInfo=CheckAutoMoveFlag.split("^");
		if ((CAMInfo[0]!="Y")&&(GetElementValue("BuyLocDR")==""))
		{
			alertShow("["+CAMInfo[1]+"]的验收单无使用科室并且本单据申购部门不能办理自动出库!")
			return
		}
	}
	else if (outflag==2)
	{
		truthBeTold = window.confirm("是否进行自动出库操作?");
		if (!truthBeTold)
		{
			outflag=0;
		}
		else
		{
			//检测入库单是否满足自动出库条件
			var encmeth=GetElementValue("CheckAutoMoveFlag")
			if (encmeth=="") return;
			var CheckAutoMoveFlag=cspRunServerMethod(encmeth,rowid);
			var CAMInfo=CheckAutoMoveFlag.split("^");
			if ((CAMInfo[0]!="Y")&&(GetElementValue("BuyLocDR")==""))
			{
				alertShow("["+CAMInfo[1]+"]的验收单无使用科室并且本单据申购部门不能办理自动出库!")
				return
			}
			outflag=1;
		}
	}
  	var encmeth=GetElementValue("SubmitData")
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,combindata,outflag);
	//alertShow(Rtn);
	if (Rtn>0)
    {
		var WaitAD=GetElementValue("WaitAD");
		//window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInStockNew&RowID='+Rtn+"&WaitAD="+WaitAD;
		var url=window.location.href //GR0026 新窗口打开模态窗口,通过改变参数值解决预缓存问题？
	    if(url.indexOf("killcache=1")!=-1)  window.location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInStockNew&killcache=0&RowID='+Rtn+"&WaitAD="+WaitAD;
	    else 								window.location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInStockNew&killcache=1&RowID='+Rtn+"&WaitAD="+WaitAD;
	}
    else
    {
	    alertShow(t[Rtn]+"   "+t["01"]);
    }
}
function BCancelSubmit_Clicked() // 反提交
{
	var combindata=GetValueList();
  	var encmeth=GetElementValue("CancelSubmitData")
  	if (encmeth=="") return;
  	//Mozy0064	2011-10-24
  	var CancelReason=GetElementValue("CancelReason");
  	if (CancelReason=="")
  	{
	  	//alertShow("取消原因为空,不能进行取消.");
	  	//return;
  	}
  	combindata=combindata+"^"+CancelReason;
  	//Modified by jdl 2011-3-2  JDL0071
	var Rtn=cspRunServerMethod(encmeth,combindata,GetElementValue("CurRole"));
    if (Rtn>0)
    {
	    //window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInStockNew&RowID='+Rtn+"&QXType="+GetElementValue("QXType");
	    var url=window.location.href //GR0026 新窗口打开模态窗口,通过改变参数值解决预缓存问题？
	    if(url.indexOf("killcache=1")!=-1)  window.location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInStockNew&killcache=0&RowID='+Rtn+"&WaitAD="+GetElementValue("WaitAD");
	    else 								window.location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInStockNew&killcache=1&RowID='+Rtn+"&WaitAD="+GetElementValue("WaitAD");
	}
    else
    {
	    alertShow(Rtn+"   "+t["01"]);
    }
}

function BApprove_Clicked()
{
	var combindata=GetValueList();
	var CurRole=GetElementValue("CurRole")
  	if (CurRole=="") return;
	var RoleStep=GetElementValue("RoleStep")
  	if (RoleStep=="") return;
  	//20170329	自动出库
	var outflag=cspRunServerMethod(GetElementValue("GetAutoInOut"),GetElementValue("RowID")+"^"+GetElementValue("CurRole")+"^"+GetElementValue("RoleStep"));
	if (outflag==1)
	{
		//检测入库单是否满足自动出库条件
		var encmeth=GetElementValue("CheckAutoMoveFlag")
		if (encmeth=="") return;
		var CheckAutoMoveFlag=cspRunServerMethod(encmeth,GetElementValue("RowID"));
		var CAMInfo=CheckAutoMoveFlag.split("^");
		if ((CAMInfo[0]!="Y")&&(GetElementValue("BuyLocDR")==""))
		{
			alertShow("["+CAMInfo[1]+"]的验收单无使用科室并且本单据申购部门不能办理自动出库!")
			return
		}
	}
	else if (outflag==2)
	{
		truthBeTold = window.confirm("是否进行自动出库操作?");
		if (!truthBeTold)
		{
			outflag=0;
		}
		else
		{
			//检测入库单是否满足自动出库条件
			var encmeth=GetElementValue("CheckAutoMoveFlag")
			if (encmeth=="") return;
			var CheckAutoMoveFlag=cspRunServerMethod(encmeth,GetElementValue("RowID"));
			var CAMInfo=CheckAutoMoveFlag.split("^");
			if ((CAMInfo[0]!="Y")&&(GetElementValue("BuyLocDR")==""))
			{
				alertShow("["+CAMInfo[1]+"]的验收单无使用科室并且本单据申购部门不能办理自动出库!")
				return
			}
			outflag=1;
		}
	}
	
  	var objtbl=document.getElementById('tDHCEQInStockNew');
	var EditFieldsInfo=ApproveEditFieldsInfo(objtbl);
	if (EditFieldsInfo=="-1") return;
  	var encmeth=GetElementValue("AuditData")
  	if (encmeth=="") return;
  	
	var Rtn=cspRunServerMethod(encmeth,combindata,CurRole,RoleStep,EditFieldsInfo,outflag);
    if (Rtn>0)
    {
	    //window.location.reload();  //GR0026 点击新增后新窗口打开模态窗口
	     var url=window.location.href
	    if(url.indexOf("killcache=1")!=-1)  url=url.replace(/killcache=1/,"killcache=0") //GR0026 新窗口打开模态窗口,通过改变参数值解决预缓存问题？
	    else 								url=url.replace(/killcache=0/,"killcache=1")
	    window.location.href=url 
	}
    else
    {
	    alertShow(t["01"]);
    }
}

function BClear_Clicked()
{
	var QXType=GetElementValue("QXType");
	//window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInStockNew&Type=0&QXType='+QXType+'&WaitAD=off';
	var url=window.location.href //GR0026 新窗口打开模态窗口,通过改变参数值解决预缓存问题？
	if(url.indexOf("killcache=1")!=-1)  window.location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInStockNew&killcache=0&Type=0&QXType='+QXType+'&WaitAD=off';
	else 								window.location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInStockNew&killcache=1&Type=0&QXType='+QXType+'&WaitAD=off';

}
function BPrint_Clicked()
{
	var id=GetElementValue("RowID");
	if (""!=id) PrintInStore(id);
}
function GetValueList()
{
	var ValueList="";
	ValueList=GetElementValue("RowID");
	ValueList=ValueList+"^"+GetElementValue("RejectReasonDR");
	ValueList=ValueList+"^"+curUserID;
	ValueList=ValueList+"^"+GetElementValue("Remark");
	ValueList=ValueList+"^"+GetElementValue("StatCatDR");
	ValueList=ValueList+"^"+GetElementValue("EquipTypeDR");
	ValueList=ValueList+"^"+GetElementValue("CancelToFlowDR");
	ValueList=ValueList+"^"+GetElementValue("ApproveSetDR");
	return ValueList;
}

function CheckNull()
{
	if (CheckMustItemNull("Provider")) return true;
	var obj=document.getElementById("cProvider");
	if ((obj)&&(obj.className=="clsRequired"))
	{
		if (GetElementValue("GetProviderOperMethod")==0)
		{
			if (CheckItemNull(1,"Provider")==true) return true;
		}
		else
		{
			if (CheckItemNull("","Provider")==true) return true;
		}		
	}
	return false;
}

function GetProvider (value)
{
    GetLookUpID("ProviderDR",value);
}
function GetOrigin (value)
{
    GetLookUpID("OriginDR",value);
}
function GetFromDept (value)
{
    GetLookUpID("FromDeptDR",value);
}
function GetLoc (value)
{
    GetLookUpID("LocDR",value);
}
function GetBuyLoc (value)
{
    GetLookUpID("BuyLocDR",value);
}
function GetStatCat (value)
{
    GetLookUpID("StatCatDR",value);
}
function GetEquipType (value)
{
    GetLookUpID("EquipTypeDR",value);
}

function GetBuyUser (value)
{
    GetLookUpID("BuyUserDR",value);
}

function GetRejectReason (value)
{
    GetLookUpID("RejectReasonDR",value);
}

function GetOpenCheck(value)  //设备验收已审核单据,未入库设备
{
	var Status=GetElementValue("Status")
	if (Status!=="" && Status!=="0") //入库单提交之后不可增加明细
	{
		alertShow("当前入库单已提交,需增加明细,请先取消提交!")
		return
	}
	
	//填充数据
	var OpenCheckInfo=value.split("^")
	// Mozy0076 2012-02-21	调整入库单处验收单信息弹出页的验收单Id和验收明细Id的输出位置到前列
	var ISLStatus=OpenCheckInfo[3]
	var ISNo=OpenCheckInfo[4]
	if (ISLStatus=="Y") //入库明细表中已存在改设备
	{
		alertShow("当前设备已在入库单" + ISNo + "中存在!")
		SetElement("OpenCheck","")    //Modefied by zc 2014-9-23  ZC0007
		return
	}
	else
	{
		//数据库增加记录,有RowID则只增加明细表,否则:设备入库主表和明细表同时增加
		//// Mozy0076 2012-02-21	调整入库单处验收单信息弹出页的验收单Id和验收明细Id的输出位置到前列
		var plist=OpenCheckInfo[0]+"^"+OpenCheckInfo[1]+"^"+GetElementValue("RowID")+"^"+GetElementValue("LocDR")+"^"+Guser;
		var encmeth=GetElementValue("SaveDataFromOpenCheck");
		if (encmeth=="") return;
		var result=cspRunServerMethod(encmeth,plist);
		if(result>0) 
		{
			//window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInStockNew&RowID='+result+"&WaitAD=off";
			var url=window.location.href //GR0026 新窗口打开模态窗口,通过改变参数值解决预缓存问题？
			if(url.indexOf("killcache=1")!=-1)  window.location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInStockNew&killcache=0&RowID='+result+"&WaitAD=off";
			else 								window.location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInStockNew&killcache=0&RowID='+result+"&WaitAD=off";

		}
		else
		{
			alertShow(EQMsg("存储数据失败! ",result));
			return
		}
	}
}

///Modified By HZY 2012-02-01 HZY0021
///OK
function SetTableItem(RowNo,SourceType,selectrow)
{
	var objtbl=document.getElementById('tDHCEQInStockNew');
	var rows=objtbl.rows.length-1;
	if (RowNo=="")
	{
		for (var i=1;i<=rows;i++)
		{
			var TSourceID=document.getElementById("TSourceIDz"+i).value;
			var TSourceType=GetElementValue("TSourceTypeDRz"+i);
			ObjSources[i]=new SourceInfo(TSourceType,TSourceID);
			tableList[i]=0;
			var TRowID=document.getElementById("TRowIDz"+i).value;
			var TotalFlag=GetElementValue("TotalFlag")
			if (TRowID==-1)
			{
				if ((TotalFlag==1)||(TotalFlag==2))
				{
					obj=document.getElementById("TRowz"+i);
					if (obj) obj.innerText="合计:"
					obj=document.getElementById("BDeleteListz"+i);
					if (obj) obj.innerText=""
					//Function:Funds	2012-2-16 生成资金来源信息
					obj=document.getElementById("TFundsz"+i);	//去掉合计行中的'资金来源'.Add By HZY 2012-02-01 HZY0021
					if (obj) obj.innerText=""
					obj=document.getElementById("TInvoiceIDsz"+i);
					if (obj) obj.innerText=""
					
					tableList[i]=-1;
					continue;
				}
			}
			ChangeRowStyle(objtbl.rows[i],SourceType);		///改变一行的内容显示
		}
	}
	else
	{
		if (selectrow=='') selectrow=RowNo
		tableList[RowNo]=0;
		ChangeRowStyle(objtbl.rows[selectrow],SourceType);		///改变一行的内容显示
	}
}

///改变一行的内容显示
function ChangeRowStyle(RowObj,SourceType)
{
	var Status=GetElementValue("Status");
	var WaitAD=GetElementValue("WaitAD"); //Modefied by zc 2014-10-9 ZC0009
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
		if (colName=="TSourceType")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetElementValue("TSourceTypeDRz"+objindex);
			html=CreatElementHtml(4,Id,objwidth,objheight,"KeyDown_Tab","SourceType_Change","2^验收单","")	//20150914  Mozy0165	只保留验收单办理入库业务
			//html=CreatElementHtml(4,Id,objwidth,objheight,"KeyDown_Tab","SourceType_Change","1^设备项&2^验收单&3^计划单","")	//Old
		}
		else if (colName=="TEquip")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText
         	html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpEquip","","","SourceIDKeyUp")
		}
		else if (colName=="TInvoiceNos")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText;
			html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		else if (colName=="TRemark")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText;
			html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		else if (colName=="TModel")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText;
			if ((GetElementValue("TSourceTypez"+objindex)==2))
			{
         		html=CreatElementHtml(0,Id,objwidth,objheight,"","","","","")
			}
			else
			{
         		html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpModelNew","Model_Change","","Standard_TableKeyUp")
			}		
		}
		else if (colName=="TManuFactory")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText;
			if ((GetElementValue("TSourceTypez"+objindex)==2))
			{				
         		html=CreatElementHtml(0,Id,objwidth,objheight,"","","","")
			}
			else
			{
         		html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpManuFactoryNew","","","Standard_TableKeyUp")
			}		
		}
		// add by csy 2017-07-21 CSY0006 begin
		else if (colName=="THold5Desc")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText;
         	html=CreatElementHtml(2,Id,objwidth,objheight,"LookUpExpendituresNew","","","Standard_TableKeyUp")
		}
		// add by csy 2017-07-21 CSY0006 end
		else if (colName=="TOriginalFee")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText;
			if ((GetElementValue("TSourceTypez"+objindex)==2))
			{
         		html=CreatElementHtml(0,Id,objwidth,objheight,"","","","")
			}
			else
			{
         		html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","TotalFee_Change")	
			}
			var objTSourceType=document.getElementById(Id);
			if(objTSourceType)
			{
				objTSourceType.onkeypress=NumberPressHandler
			}
		}
		else if (colName=="TQuantityNum")
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=document.getElementById(Id).innerText;
			if ((GetElementValue("TSourceTypez"+objindex)==2))
			{
         		html=CreatElementHtml(0,Id,objwidth,objheight,"","","","")
			}
			else
			{
         		html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","TotalFee_Change")	
			}			
			//数量
			var objTQuantityNum=document.getElementById(Id);
			if(objTQuantityNum)
			{
				objTQuantityNum.onkeypress=NumberPressHandler
			}
		}
		else if (colName=="BDeleteList")
		{
			//Modefied by zc 2014-10-9 ZC0009  begin
			if(WaitAD!="off")
			{
				HiddenObj(colName+"z"+objindex,1)
				continue;
			}
			//Modefied by zc 2014-10-9 ZC0009  end 
			if (Status>0)
			{
				HiddenObj(colName+"z"+objindex,1)
				continue;
			}
			RowObj.cells[j].onclick=DeleteClickHandler;
		}
		else if (colName=="TFunds")	//'资金来源'列的点击事件的定义.Add By HZY 2012-01-17 HZY0021
		{
			//Function:Funds	2012-2-16 生成资金来源信息
			if (Status>0)
			{
				SetElement("ReadOnly",1);
			}
			RowObj.cells[j].onclick=FundsClickHandler;
		}
		else if (colName=="TCommonName") //2013-06-24 DJ0118
		{
			if (CheckUnEditField(Status,colName)) continue;
			value=GetCElementValue(Id)
		    html=CreatElementHtml(1,Id,objwidth,objheight,"KeyDown_Tab","","","")
		}
		else if (colName=="TInvoiceIDs")
		{
			RowObj.cells[j].onclick=InvoiceClickHandler;
		}
		if (html!="")
		{
			///Modified by JDL 20151014
			RowObj.cells[j].firstChild.outerHTML=html;
			//RowObj.cells[j].innerHTML=html;
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


function TotalFee_Change()
{
	selectrow=GetTableCurRow();
	var TOriginalFee=GetElementValue("TOriginalFeez"+selectrow)
	var TQuantityNum=GetElementValue("TQuantityNumz"+selectrow)
	if ((""==TOriginalFee)||(""==TQuantityNum))
	{
		SetElement('TTotalFeez'+selectrow,'');
	}
	else
	{
		var TMaxInStickNum=parseInt(GetElementValue("TMaxInStickNumz"+selectrow))
		if((TQuantityNum>TMaxInStickNum)||(TQuantityNum<1))
		{
			alertShow("入库数量无效或超过最大数量!")
			SetElement('TQuantityNumz'+selectrow,'');
			TQuantityNum="";
		}
	
		var TotalFee=TOriginalFee*TQuantityNum
		if (TotalFee<=0)
		{
			SetElement('TTotalFeez'+selectrow,'');
		}
		else
		{
			SetElement('TTotalFeez'+selectrow,TotalFee.toFixed(2));
		}
	}
	SumList_Change()
}

function SumList_Change()
{	
	var length=tableList.length
	var Num=0
	var Fee=0
	for (var i=1;i<length;i++)
	{
		if (tableList[i]=="0")
		{
			var TOriginalFee=parseFloat(GetElementValue("TOriginalFeez"+i))
			var TQuantityNum=parseInt(GetElementValue("TQuantityNumz"+i))
			if ((isNaN(TOriginalFee))||(isNaN(TQuantityNum))) continue;
			var TotalFee=TOriginalFee*TQuantityNum
			Num=Num+TQuantityNum
			Fee=Fee+TotalFee
		}
		else if (tableList[i]==-1)
		{
			var index=i
		}
	}
	SetElement('TQuantityNumz'+index,Num);
	SetElement('TTotalFeez'+index,Fee.toFixed(2));
}

function SourceType_Change()
{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var objtbl=document.getElementById('tDHCEQInStockNew'); //得到表格   t+组件名称
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	selectrow=rowObj.rowIndex;								//当前选择行
	RowNo=GetTableCurRow();
	var TSourceType=GetElementValue("TSourceTypez"+RowNo)
	SetElement("TSourceTypeDRz"+RowNo,TSourceType);
	if (TSourceType==1)
	{
		SetTableItem(RowNo,"1",selectrow);		///改变一行的内容显示
	}
	if (TSourceType==2)
	{
		SetTableItem(RowNo,"2",selectrow);		///改变一行的内容显示
	}
	if (TSourceType==3)
	{
		SetTableItem(RowNo,"1",selectrow);		///改变一行的内容显示
	}
	selectrow=RowNo;
	Clear();
	SetFocusColumn("TSourceType",selectrow)
}

function Clear()
{
	SetElement('TEquipz'+selectrow,"");
	SetElement('TModelz'+selectrow,"");
	SetElement('TModelDRz'+selectrow,"");
	SetElement('TManuFactoryz'+selectrow,"");
	SetElement('TManuFactoryDRz'+selectrow,"");
	SetElement('TQuantityNumz'+selectrow,"");
	SetElement('TEquipCatDRz'+selectrow,"");
	SetElement('TEquipCatz'+selectrow,"");
	SetElement('TStatCatDRz'+selectrow,"");
	SetElement('TStatCatz'+selectrow,"");
	SetElement('TInvoiceNosz'+selectrow,"");
	SetElement('TRemarkz'+selectrow,"");
	SetElement('TMaxInStickNumz'+selectrow,"");
	SetElement('TOriginalFeez'+selectrow,"");
	SetElement('TUserYearsNumz'+selectrow,"");
	SetElement('TTotalFeez'+selectrow,"");
	SetElement('TUnitDRz'+selectrow,"");
	SetElement('TUnitz'+selectrow,"");
	SetElement('TItemDRz'+selectrow,"");
	SetElement('TSourceIDz'+selectrow,"");
	SetElement('TCommonNamez'+selectrow,""); 	//2013-06-24 DJ0118
	SetElement('THold5z'+selectrow,""); // add by csy 2017-07-21 CSY0006
	SetElement('THold5Descz'+selectrow,"");
}

function LookUpEquip(vClickEventFlag)
{
	if (event.keyCode==13||event.keyCode==0||vClickEventFlag==1)
	{
		if (CheckNull()) return;
		selectrow=GetTableCurRow();
		var ObjTSourceType=document.getElementById('TSourceTypez'+selectrow);
		if (ObjTSourceType)
		{
			var TSourceType=ObjTSourceType.value
			if (TSourceType==1)
			{
				LookUpMasterItemNew();
			}
			else if (TSourceType==2)
			{
				LookUpOpenCheck();
			}
			else if (TSourceType==3)
			{
				LookUpBuyPlanList();
			}	
		}
	}
}
function LookUpMasterItemNew()
{
	LookUpMasterItem("GetMasterItem","EquipTypeDR,StatCatDR,TEquipz"+selectrow);
}

function GetMasterItem(value)
{
	Clear()
	var TotalFlag=GetElementValue("TotalFlag")
	var list=value.split("^")
	var Length=ObjSources.length

	//Start Modified By HZY 2012-11-29 HZY0036 .不能同时有 设备项和型号 重复的明细.
	for (var i=1;i<Length;i++)
	{
		//alertShow(ObjSources[i].SourceType+"&"+ObjSources[i].SourceID+"&"+list[1]);
		if ((tableList[i]=="0")&&(ObjSources[i].SourceType=="1")&&(ObjSources[i].SourceID==list[1])&&(selectrow!=i)&&(GetModelRowID(GetElementValue("GetModelOperMethod"),i)==GetModelRowID(GetElementValue("GetModelOperMethod"),selectrow)))
		{
			alertShow("选择的设备项,型号与第"+GetCElementValue("TRowz"+i)+"行重复!")
			return;
		}
	}
	//End Modified .
	
	SetElement('TEquipz'+selectrow,list[0]);
	SetElement('TItemDRz'+selectrow,list[1]);
	SetElement('TEquipCatDRz'+selectrow,list[3]);
	SetElement('TEquipCatz'+selectrow,list[4]);
	SetElement('TUnitDRz'+selectrow,list[5]);
	SetElement('TUnitz'+selectrow,list[6]);
	SetElement('TEquipTypeDRz'+selectrow,list[7]);
	SetElement('TEquipTypez'+selectrow,list[8]);
	SetElement('TStatCatDRz'+selectrow,list[9]);
	SetElement('TStatCatz'+selectrow,list[10]);
	SetElement('TUserYearsNumz'+selectrow,list[13]);
	SetElement('TSourceIDz'+selectrow,list[1]);
	SetElement('TCommonNamez'+selectrow,list[0]);	//2013-06-24 DJ0118
	ObjSources[selectrow]=new SourceInfo("1",list[1]);
	var obj=document.getElementById("TEquipz"+selectrow);
	if (obj) websys_nextfocusElement(obj);
}

function LookUpOpenCheck()
{	
	//LookUp("","web.DHCEQInStockNew:GetOpenCheckList","GetOpenCheckNew","EquipTypeDR,StatCatDR,ProviderDR,OriginDR,TEquipz"+selectrow);
	LookUp("","web.DHCEQInStockNew:GetOpenCheckList","GetOpenCheckNew","EquipTypeDR,,ProviderDR,OriginDR,TEquipz"+selectrow);
}

function GetOpenCheckNew(value)
{	
	// Mozy0076 2012-02-21	调整入库单处验收单信息弹出页的验收单Id和验收明细Id的输出位置到前列
	var TotalFlag=GetElementValue("TotalFlag")
	var list=value.split("^")
	var Flag=list[3]
	var ISNo=list[4]
	var InStockNo=GetElementValue("InStockNo")
	if (ISNo!=InStockNo)
	{
		if (Flag=="Y") //入库明细表中已存在改设备
		{
			alertShow("当前设备已在入库单" + ISNo + "中存在!")
			return
		}
	}
	var OCRRowID=list[0];
	var OCLRowID=list[1];
	var Length=ObjSources.length
	for (var i=1;i<Length;i++)
	{
		//alertShow(ObjSources[i].SourceID+"&"+OCLRowID);
		if ((tableList[i]=="0")&&(ObjSources[i].SourceType=="2")&&(ObjSources[i].SourceID==OCLRowID)&&(selectrow!=i))
		{
			alertShow("选择的设备与第"+GetCElementValue("TRowz"+i)+"行重复!")
			return;
		}
	}
	//alertShow(OCRRowID);
	var encmeth=GetElementValue("GetOpenCheckInfo");
	var rtn=cspRunServerMethod(encmeth,OCRRowID);
	var list=rtn.split("^")
	
	var sort=76;	/// 20150327  Mozy0153
	SetElement('TSourceIDz'+selectrow,list[0]);
	ObjSources[selectrow]=new SourceInfo("2",list[0]);
	SetElement('TEquipz'+selectrow,list[sort+6]);	//2013-06-24 DJ0118
	SetElement('TModelDRz'+selectrow,list[5]);
	SetElement('TModelz'+selectrow,list[sort+1]);
	SetElement('TEquipCatDRz'+selectrow,list[6]);
	SetElement('TItemDRz'+selectrow,list[9]);        //add by jyp 2017-11-20 JYP0008
	SetElement('TEquipCatz'+selectrow,list[sort+2]);	
	SetElement('TUnitDRz'+selectrow,list[7]);
	SetElement('TUnitz'+selectrow,list[sort+3]);
	SetElement('TManuFactoryDRz'+selectrow,list[15]);
	SetElement('TManuFactoryz'+selectrow,list[sort+4]);
	SetElement('TStatCatDRz'+selectrow,list[28]);
	SetElement('TStatCatz'+selectrow,list[sort+5]);
	SetElement('TMaxInStickNumz'+selectrow,list[16]);
	SetElement('TQuantityNumz'+selectrow,list[16]);
	SetElement('TOriginalFeez'+selectrow,list[17]);
	SetElement('TUserYearsNumz'+selectrow,list[19]);
	SetElement('TTotalFeez'+selectrow,(list[16]*list[17]).toFixed(2));
	SetElement('TCommonNamez'+selectrow,list[2]);	//2013-06-24 DJ0118
	SetElement('THold5z'+selectrow,list[59]);	//add by csy 2017-07-21 CSY0006
	SetElement('THold5Descz'+selectrow,list[sort+7]);	// add by csy 2017-07-21 CSY0006
	//modified by zy 2011-10-10  zy0081
	if (TotalFlag!=0)
	{
		SumList_Change();
	}
	var obj=document.getElementById("TEquipz"+selectrow);
	if (obj) websys_nextfocusElement(obj);
}

function LookUpModelNew(vClickEventFlag)
{
	selectrow=GetTableCurRow();
	if (event.keyCode==13||event.keyCode==0||vClickEventFlag==1)
	{
		LookUpModel("GetModel","TItemDRz"+selectrow+",TModelz"+selectrow);
	}
}

function GetModel(value)
{
	var list=value.split("^")
	var Length=ObjSources.length
	//Start Add By HZY 2012-11-29 HZY0036. 不能同时有 设备项和型号 重复的明细.
	for (var i=1;i<Length;i++)
	{
		//alertShow(ObjSources[i].SourceType+"&"+ObjSources[i].SourceID+"&"+list[1]);
		if ((tableList[i]=="0")&&(ObjSources[i].SourceType=="1")&&(ObjSources[i].SourceID==GetElementValue("TItemDRz"+selectrow))&&(selectrow!=i)&&(GetModelRowID(GetElementValue("GetModelOperMethod"),i)==list[1]))
		{
			alertShow("选择的设备项,型号与第"+GetCElementValue("TRowz"+i)+"行重复!");
			return;
		}
	}
	//End Add.
	
	SetElement('TModelz'+selectrow,list[0]);
	SetElement('TModelDRz'+selectrow,list[1]);
	var obj=document.getElementById("TModelz"+selectrow);
	if (obj) websys_nextfocusElement(obj);
}


function LookUpManuFactoryNew(vClickEventFlag)
{
	selectrow=GetTableCurRow();
	if (event.keyCode==13||event.keyCode==0||vClickEventFlag==1)
	{
		LookUpManuFactory("GetManuFactory","TManuFactoryz"+selectrow);
	}
}

function GetManuFactory(value)
{
	var list=value.split("^")
	SetElement('TManuFactoryz'+selectrow,list[0]);
	SetElement('TManuFactoryDRz'+selectrow,list[1]);
	var obj=document.getElementById("TManuFactoryz"+selectrow);
	if (obj) websys_nextfocusElement(obj);
}

function LookUpEquipCatNew()
{
	LookUpEquipCat("GetEquipCat","");
}

function GetEquipCat(value)
{
	var list=value.split("^")
	SetElement('TEquipCatz'+selectrow,list[0]);
	SetElement('TEquipCatDRz'+selectrow,list[1]);
	var obj=document.getElementById("TEquipCatz"+selectrow);
	if (obj) websys_nextfocusElement(obj);
}
function AddClickHandler() {
	try 
	{
		var objtbl=document.getElementById('tDHCEQInStockNew');
		var ret=CanAddRow(objtbl);
		if (ret)
		{
			NewNameIndex=tableList.length;
	    	AddRowToList(objtbl,LastNameIndex,NewNameIndex);
	    	
			//设置默认的来源类型与上一行一致
			var PreSourceType=GetElementValue("TSourceTypez"+LastNameIndex);
			SetElement("TSourceTypez"+NewNameIndex,PreSourceType);
			//新增行隐藏附件图标
			var TAffix=document.getElementById("TAffixz"+NewNameIndex);
			if (TAffix) TAffix.removeNode(true);
	    }
	    //begin add by jyp 2018-03-12 544949
	    else
	    {
		    alertShow("上一行设备名称为空!")      
		}
		//end add by jyp 2018-03-12 544949
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
	var TSourceType=document.getElementById('TSourceTypez'+LastNameIndex).value
	if  (GetElementValue('TSourceTypez'+LastNameIndex)=="")
	{
		SetFocusColumn("TSourceType",LastNameIndex);
		return false;
		
	}
	if  (GetElementValue('TSourceIDz'+LastNameIndex)=="")
	{
		SetFocusColumn("TEquip",LastNameIndex);
	 	return false;
	}
	return true;
}

///OK
function DeleteClickHandler() {
	var truthBeTold = window.confirm(t["-4003"]);
	if (!truthBeTold) return;
	try
	{
		var objtbl=document.getElementById('tDHCEQInStockNew');
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
			Clear();			 
		} 
		else
		{
	    	var eSrc=window.event.srcElement;
			var rowObj=getRow(eSrc);
			objtbl.deleteRow(rowObj.rowIndex);
		}
		ResetNo(selectrow,delNo);
	    SumList_Change();
	} 
	catch(e) 
	{};
}
///Function:Funds	2012-2-16 生成资金来源信息
///Add By HZY 2012-02-01 HZY0021
///Desc:'资金来源'列的点击事件的定义
function FundsClickHandler()
{
	selectrow=GetTableCurRow();	//得到表格当前行号
	var SourceType="";
	var SourceID="";
	var ReadOnly=GetElementValue("ReadOnly");
	var TRowID=GetElementValue('TRowIDz'+selectrow);
	if (TRowID=="") return;
	var FundsAmount=GetElementValue('TTotalFeez'+selectrow);
	var TSourceTypeDR=GetElementValue('TSourceTypeDRz'+selectrow);	//来源类型
	var TSourceID=GetElementValue('TSourceIDz'+selectrow);			//来源ID
	var Status=GetElementValue("Status");
	SourceType=3;		//入库明细
	SourceID=TRowID;	//入库明细ID
	/*if (ReadOnly!="1")
	{
		if (TSourceTypeDR==2)	//验收单
		{
			ReadOnly=1;
		}
		if ((Status!="")&&(Status!="0"))
		{
			ReadOnly=1;
		}
	}*/
	// 资金来源入库最终审核前可以修改  add by csy 2017-06-01 start  需求号：CSY0004
	if (Status!="2")
	{
		if (TSourceTypeDR=="2")
		{
		var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQFunds&FromType='+0+'&FromID='+TSourceID+'&ReadOnly='+0+'&FundsAmount='+FundsAmount;
	    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0');	//
		}
		else 
		{
		var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQFunds&FromType='+SourceType+'&FromID='+SourceID+'&ReadOnly='+0+'&FundsAmount='+FundsAmount;
	    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0');	//
			}
	}
	else 
	{
	    var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQFunds&FromType='+SourceType+'&FromID='+SourceID+'&ReadOnly='+1+'&FundsAmount='+FundsAmount;
        window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0');	//
	}
}
function InvoiceClickHandler()
{
	var selectrow=GetTableCurRow();
	var TRowID=GetElementValue('TRowIDz'+selectrow);
	if (TRowID=="")
	{
		alertShow("请先保存入库单")
		return
	}
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInvoiceCertificate&SourceType=1&SourceID='+TRowID
	window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0');	//
}
///Modified by JDL 2010-8-4
///整理该方法
function GetTableInfo()
{
	var obj=document.getElementById("CheckInvoiceNo");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
    var objtbl=document.getElementById('tDHCEQInStockNew');
	var rows=tableList.length
	var valList="";
	for(var i=1;i<rows;i++)
	{
		if (tableList[i]=="0")
		{
			var TRow=GetCElementValue("TRowz"+i);
			var TRowID=GetElementValue("TRowIDz"+i);
			var TEquip=GetElementValue("TEquipz"+i);
			var TEquipDR=GetElementValue("TEquipDRz"+i);			
			var TManuFactoryDR=GetManuFactoryRowID(GetElementValue("GetManuFactoryOperMethod"),i)			
			var TModelDR=GetModelRowID(GetElementValue("GetModelOperMethod"),i)
			var TUnitDR=GetElementValue("TUnitDRz"+i);
			var TRemark=GetElementValue("TRemarkz"+i);
			var TEquipCatDR=GetElementValue("TEquipCatDRz"+i);
			var result=CheckEqCatIsEnd(TEquipCatDR)
			if ((result=="0")||(result=="2"))
			{
				alertShow("第"+TRow+"行,设备分类不是最末级!请您修改设备项设置")
				if (result=="0") return "-1"
			}
			var TItemDR=GetElementValue("TItemDRz"+i);
			var TStatCatDR=GetElementValue("TStatCatDRz"+i);
			var TSourceID=GetElementValue("TSourceIDz"+i);
			
			if ((TEquip=="")||(TSourceID==""))
			{
				alertShow("第"+TRow+"行,请选择正确的设备或设备项")
				SetFocusColumn("TEquip",i)
				return "-1"
			}
			
			var TInvoiceNos=GetElementValue("TInvoiceNosz"+i);
			//Add By DJ 2013-06-21 DJ0117 begin
			var ISRowID=GetElementValue("RowID")
			var ProviderDR=GetElementValue("ProviderDR")
			var CheckReturn=cspRunServerMethod(encmeth,TInvoiceNos,ISRowID,ProviderDR,1);
			if (CheckReturn>0)
			{
				var RetrunMsg=window.confirm("发票号["+TInvoiceNos+"]已经使用!是否继续?")
				if (!RetrunMsg) return "-1"
			}
			//DJ0117 end
			var TInvoiceDate=GetElementValue("TInvoiceDatez"+i);
			var TInvoiceFee=GetElementValue("TInvoiceFeez"+i);
			var TUserYearsNum=trim(GetElementValue("TUserYearsNumz"+i));
			var TSourceType=GetElementValue("TSourceTypez"+i);
			///设备项
			/*
			if (TSourceType==1)
			{
				var TQuantityNum=GetElementValue("TQuantityNumz"+i);
				var TOriginalFee=GetElementValue("TOriginalFeez"+i);
			}
			else if (TSourceType==2)	///验收单
			{
				var TQuantityNum=GetCElementValue("TQuantityNumz"+i);
				var TOriginalFee=GetCElementValue("TOriginalFeez"+i);				
			}			
			*/
			//Modified 2012-09-04
			var TQuantityNum=GetElementValue("TQuantityNumz"+i);
			var TOriginalFee=GetElementValue("TOriginalFeez"+i);
			/*var TInvoiceNos=GetElementValue("TInvoiceNosz"+i);
			if (TInvoiceNos=="")
			{
				alertShow("第"+TRow+"行发票号为空!");
				SetFocusColumn("TInvoiceNos",i)
				return "-1";
			}*/
			if ((TQuantityNum=="")||(parseInt(TQuantityNum)<=0))
			{
				alertShow("第"+TRow+"行数量不正确!");
				SetFocusColumn("TQuantityNum",i)
				return "-1";
			}
			//Modified by JDL 2011-12-15  JDL0105 数量不能为小数
			if (parseInt(TQuantityNum)!=TQuantityNum)
			{
				alertShow("第"+TRow+"行数量不正确,不能为小数!");
				SetFocusColumn("TQuantityNum",i)
				return "-1";
			}
			// Mozy0152	2015-2-9
			if ((TOriginalFee=="")||(parseFloat(TOriginalFee)<0))
			{
				alertShow("第"+TRow+"行原值不正确!");
				SetFocusColumn("TOriginalFee",i)
				return "-1";
			}
			if (GetCheckQuantityNum(TQuantityNum,TRow)) return -1;	// Mozy0117	2014-1-27
			var THold1=GetElementValue("THold1z"+i);
			var THold2=GetElementValue("THold2z"+i);
			var THold3=GetElementValue("THold3z"+i);
			var THold4=GetElementValue("THold4z"+i);
			var THold5=GetElementValue("THold5z"+i);
			var TCommonName=GetElementValue("TCommonNamez"+i);	//2013-06-24 DJ0118
			if(valList!="") {valList=valList+"&";}			
			valList=valList+TRow+"^"+TRowID+"^"+TEquipDR+"^"+TEquip+"^"+TManuFactoryDR+"^"+TOriginalFee+"^"+TQuantityNum+"^"+TModelDR+"^"+TUnitDR+"^"+TRemark+"^"+TEquipCatDR+"^"+TUserYearsNum+"^"+TItemDR+"^"+TStatCatDR+"^"+TSourceType+"^"+TSourceID+"^"+TInvoiceNos+"^"+TInvoiceDate+"^"+TInvoiceFee;
			valList=valList+"^"+THold1+"^"+THold2+"^"+THold3+"^"+THold4+"^"+THold5+"^"+TCommonName;	//2013-06-24 DJ0118
		}
	}
	return  valList
}

function SetDisplay()
{
	ReadOnlyCustomItem(GetParentTable("OpenCheck"),GetElementValue("Status"));
	ReadOnlyElements("InStockNo",true)
}

function SourceIDKeyUp()
{
	var eSrc=window.event.srcElement;
	if (!eSrc) return;
	var Id=eSrc.id
	var offset=Id.lastIndexOf("z");
	var index=Id.substring(offset+1);
	SetElement("TSourceIDz"+index,"");
}

function LookUpBuyPlanList()
{
	LookUp("","web.DHCEQInStockNew:GetBPList","GetBuyPlanListNew","EquipTypeDR,TEquipz"+selectrow);
}
function GetBuyPlanListNew(value)
{
	// Mozy0076 2012-02-21	调整入库单处验收单信息弹出页的验收单Id和验收明细Id的输出位置到前列
	var TotalFlag=GetElementValue("TotalFlag")
	var list=value.split("^")
	var Flag=list[3]
	var ISNo=list[4]
	var InStockNo=GetElementValue("InStockNo")
	if (ISNo!=InStockNo)
	{
		if (Flag=="Y") //入库明细表中已存在改设备
		{
			alertShow("当前计划已在入库单" + ISNo + "中存在!")
			return
		}
	}
	var BPRowID=list[0];
	var BPLRowID=list[1];
	var Length=ObjSources.length
	for (var i=1;i<Length;i++)
	{
		//alertShow(ObjSources[i].SourceID+"&"+OCLRowID);
		if ((tableList[i]=="0")&&(ObjSources[i].SourceType=="3")&&(ObjSources[i].SourceID==BPLRowID)&&(selectrow!=i))
		{
			alertShow("选择的设备与第"+GetCElementValue("TRowz"+i)+"行重复!")
			return;
		}
	}
	//alertShow(OCRRowID);
	var encmeth=GetElementValue("GetBuyPlanListInfo");
	var rtn=cspRunServerMethod(encmeth,BPLRowID);
	var list=rtn.split("^")	
	var sort=26;
	SetElement('TSourceIDz'+selectrow,BPLRowID);
	ObjSources[selectrow]=new SourceInfo("3",BPLRowID);
	SetElement('TEquipz'+selectrow,list[sort+15]);	//2013-06-24 DJ0118
	SetElement('TModelDRz'+selectrow,list[2]);
	SetElement('TModelz'+selectrow,list[sort+1]);
	SetElement('TManuFactoryDRz'+selectrow,list[3]);
	SetElement('TManuFactoryz'+selectrow,list[sort+2]);
	SetElement('TEquipCatDRz'+selectrow,list[sort+5]);
	SetElement('TEquipCatz'+selectrow,list[sort+6]);
	SetElement('TStatCatDRz'+selectrow,list[sort+7]);
	SetElement('TStatCatz'+selectrow,list[sort+8]);
	SetElement('TUnitDRz'+selectrow,list[sort+9]);
	SetElement('TUnitz'+selectrow,list[sort+10]);
	SetElement('TOriginalFeez'+selectrow,list[5]);
	SetElement('TQuantityNumz'+selectrow,list[6]);
	SetElement('TMaxInStickNumz'+selectrow,list[sort+14]);
	
	SetElement('TUserYearsNumz'+selectrow,list[sort+11]);
	SetElement('TTotalFeez'+selectrow,(list[5]*list[6]).toFixed(2));
	SetElement('TCommonNamez'+selectrow,list[1]); //2013-06-24 DJ0118
	//modified by zy 2011-10-10  zy0081
	if (TotalFlag!=0)
	{
		SumList_Change();
	}
	var obj=document.getElementById("TEquipz"+selectrow);
	if (obj) websys_nextfocusElement(obj);
	
}

function GetBuyPlanList(value)  //设备验收已审核单据,未入库设备
{
	var Status=GetElementValue("Status")
	if (Status!=="" && Status!=="0") //入库单提交之后不可增加明细
	{
		alertShow("当前入库单已提交,需增加明细,请先取消提交!")
		return
	}
	
	//填充数据
	var BuyPlanListInfo=value.split("^")
	// Mozy0076 2012-02-21	调整入库单处验收单信息弹出页的验收单Id和验收明细Id的输出位置到前列
	var ISLStatus=BuyPlanListInfo[3]
	var ISNo=BuyPlanListInfo[4]
	if (ISLStatus=="Y") //入库明细表中已存在改设备
	{
		alertShow("当前设备已在入库单" + ISNo + "中存在!")
		return
	}
	else
	{
		//数据库增加记录,有RowID则只增加明细表,否则:设备入库主表和明细表同时增加
		//// Mozy0076 2012-02-21	调整入库单处验收单信息弹出页的验收单Id和验收明细Id的输出位置到前列
		var plist=BuyPlanListInfo[0]+"^"+BuyPlanListInfo[1]+"^"+GetElementValue("RowID")+"^"+GetElementValue("LocDR")+"^"+Guser;
		var encmeth=GetElementValue("SaveDataFromOpenCheck");
		if (encmeth=="") return;
		var result=cspRunServerMethod(encmeth,plist,3);
		if(result>0) 
		{
			//window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInStockNew&RowID='+result+"&WaitAD=off";
			var url=window.location.href //GR0026 新窗口打开模态窗口,通过改变参数值解决预缓存问题？
			if(url.indexOf("killcache=1")!=-1)  window.location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInStockNew&killcache=0&RowID='+result+"&WaitAD=off";
			else 								window.location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInStockNew&killcache=1&RowID='+result+"&WaitAD=off";

		}
		else
		{
			alertShow(EQMsg("存储数据失败! ",result));
			return
		}
	}
}

///Add By HZY 2012-11-29 HZY0036
function Model_Change()
{
	var Length=ObjSources.length;
	for (var i=1;i<Length;i++)
	{
		if ((tableList[i]=="0")&&(ObjSources[i].SourceType=="1")&&(ObjSources[i].SourceID==GetElementValue("TItemDRz"+selectrow))&&(selectrow!=i)&&(GetElementValue("TModelz"+selectrow).toUpperCase()==GetElementValue("TModelz"+i).toUpperCase()))
		{
			alertShow("选择的设备项,型号与第"+GetCElementValue("TRowz"+i)+"行重复!");
			SetElement('TModelz'+selectrow,"");
			SetElement('TModelDRz'+selectrow,"");
			SetFocusColumn("TModel",selectrow);
			return;
		}
	}
}
// Mozy0117	2014-1-27
function GetCheckQuantityNum(QuantityNum,TRow)
{
	if (QuantityNum=="") QuantityNum=0;
	QuantityNum=parseInt(QuantityNum);
	var encmeth=GetElementValue("GetCheckQuantityNum");
	var result=cspRunServerMethod(encmeth,"201007");
	if (result!="")
	{
		list=result.split(",");
		if (list[0]=="") list[0]=0;
		if (list[1]=="") list[1]=0;
		list[0]=parseInt(list[0]);
		list[1]=parseInt(list[1]);
		if (list[0]>list[1])
		{
			alertShow("系统参数设置错误--(代码201007),请联系管理员!");
			return true;
		}
		if (QuantityNum>=list[1])
		{
			alertShow("第"+TRow+"行的设备数量大于系统限制数量,系统禁止提交该单据!");
			return true;
		}
		else if (QuantityNum>=list[0])
		{
			var truthBeTold = window.confirm("第"+TRow+"行的设备数量大于"+list[0]+",是否继续操作?");
			if (!truthBeTold) return true;
		}
	}
	return false;
}
function BCancel_Clicked()
{
	var encmeth=GetElementValue("CheckBuss");
	if (encmeth=="") return;
	var results=cspRunServerMethod(encmeth,2,GetElementValue("RowID"));
	var result=results.split("^")
	if (result[0]!=="0")
	{
		alertShow(result[1])
	}
	else
	{
		var truthBeTold = window.confirm("相关的验收,出库,台账也一起作废!是否继续？");
	    if (!truthBeTold) return;
		var encmeth=GetElementValue("CancelBuss");
		if (encmeth=="") return;
		var results=cspRunServerMethod(encmeth,2,GetElementValue("RowID"));
		var result=results.split("^")
		if (result[0]!=="0")
		{
			if (result[1]!="")
			{
				alertShow("操作失败:"+result[1])
			}
			else
			{
				alertShow("操作失败:"+result[0])
			}
		}
		else
		{
			alertShow("成功作废!")
		    var url=window.location.href
		    if(url.indexOf("killcache=1")!=-1)  window.location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInStockNew&killcache=0&RowID='+GetElementValue("RowID")+"&WaitAD=off";
		    else 								window.location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInStockNew&killcache=1&RowID='+GetElementValue("RowID")+"&WaitAD=off";
		}
	}
}
// add by csy 2017-07-21 CSY0006 begin 
function GetExpenditures(value)
{
	var list=value.split("^")
	SetElement('THold5Descz'+selectrow,list[0]);
	SetElement('THold5z'+selectrow,list[1]);
	var obj=document.getElementById("THold5Descz"+selectrow);
	if (obj) websys_nextfocusElement(obj);
}

function LookUpExpendituresNew(vClickEventFlag)
{
	selectrow=GetTableCurRow();
	LookUpExpenditures("GetExpenditures","THold5Descz"+selectrow);
    
}
// add by csy 2017-07-21 CSY0006 end 