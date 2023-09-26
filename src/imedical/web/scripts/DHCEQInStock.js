/// 修改:zy 2009-10-28 BugNo.ZY0016
/// 修改函数BUpdate_Clicked,InitPage,CheckNull
/// 描述:改进功能,对机型,供应商,生产厂商取RowID?
/// 备注0:放大镜选择模式 1:手工录入模式,并自动更新机型表 2:两种均可
/// -------------------------------
/// 修    改:zy 2009-11-03  BugNo ZY0015
/// 增加函数:BClose_Click()
/// 描述:增加关闭按钮
/// -------------------------------
///增加按钮BToMove?生成出库单? 2009/2/25 jdl
///DHCEQInStock.JS
///
function BodyLoadHandler() 
{
	document.body.scroll="no";
	KeyUp("Loc^Provider^FromDept^Origin^BuyLoc^BuyUser^EquipType^StatCat^ProviderDR","N");
	InitUserInfo();
	InitPage();
	FillData();
	SetEnabled();
	Muilt_LookUp("Loc^Provider^FromDept^Origin^BuyLoc^BuyUser^EquipType^StatCat")
}

///增加按钮BToMove?生成出库单? 2009/2/25 jdl
function SetEnabled()
{
	var Status=GetElementValue("Status");
	var Type=GetElementValue("Type");
	var InsertStep=GetElementValue("InsertStep");
	var EquipHasIn=GetElementValue("EquipHasIn");
	var ReadOnly=GetElementValue("ReadOnly");
	///2009/2/25 jdl
	DisableElement("BToMove",true);
	
	if (ReadOnly=="1")
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BAudit",true);
		DisableBElement("BCancelSubmit",true);
		DisableBElement("BBillAudit",true);
		DisableBElement("BClear",true);		
		return;
	}
	if (Status=="0")
	{
		DisableBElement("BAudit",true);
		DisableBElement("BCancelSubmit",true);
		DisableLookup("RejectReason",true);
		DisableBElement("BBillAudit",true);
	}
	if (Status=="1")
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BBillAudit",true);
	}
	if (Status=="2")
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		if (InsertStep=="0") DisableBElement("BCancelSubmit",true);
		if (EquipHasIn=="1") DisableBElement("BCancelSubmit",true);
		if (Type<2) DisableBElement("BCancelSubmit",true);
		DisableBElement("BAudit",true);
		DisableBElement("BSubmit",true);
		DisableLookup("RejectReason",true);
	}
	if (Status=="3")
	{
		DisableBElement("BBillAudit",true);
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BCancelSubmit",true);
		DisableBElement("BAudit",true);
		DisableBElement("BSubmit",true);
		DisableLookup("RejectReason",true);
		///2009/2/25 jdl
		DisableElement("BToMove",false);
	}
	if (Status=="")
	{
		DisableBElement("BBillAudit",true);
		DisableBElement("BDelete",true);
		DisableBElement("BCancelSubmit",true);
		DisableBElement("BAudit",true);
		DisableBElement("BSubmit",true);
		DisableLookup("RejectReason",true);
	}
	var BElementEnableVal=GetElementValue("ElementEnableVal");
	BElementEnableByVal(BElementEnableVal);
	if (Type!="0") DisableBElement("BClear",true);
	/*if (Type=="0")
	{
		DisableBElement("BBillAudit",true);
		DisableBElement("BAudit",true);
		DisableBElement("BCancelSubmit",true);
	}
	if (Type=="1")
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BBillAudit",true);
	}*/
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
	var sort=21
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
}

function InitPage()
{
	var obj=document.getElementById("BBillAudit"); //账物审核
	if (obj) obj.onclick=BBillAudit_Click;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Clicked;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Clicked;
	var obj=document.getElementById("BCancelSubmit"); //反提交
	if (obj) obj.onclick=BCancelSubmit_Clicked;
	var obj=document.getElementById("BAudit");
	if (obj) obj.onclick=BAudit_Clicked;
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
	if ((opener)||((parent.opener)))
	{
		var obj=document.getElementById("BClose")
		if (obj) obj.onclick=CloseWindow;
	}
	else
	{
		EQCommon_HiddenElement("BClose")
	}
	//Modified by zy 2009-11-11 ZY0016
	var GetProviderOperMethod=GetElementValue("GetProviderOperMethod")
	// 0:放大镜选择模式 1:手工录入模式,并自动更新机型表 2:两种均可
	if (GetProviderOperMethod==1) 
	{
		document.getElementById("ld"+GetElementValue("GetComponentID")+"iProvider").removeNode(true)
	}
	//2009-11-11 end ZY ZY0016 
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
		parent.location.href="dhceqstoremove.csp?"+"&QXType=2&RowID="+StoreMoveID+"&ElementEnableVal=8^9&ValEquipType=1&Type=0";
	}	
}

function BClear_Clicked()
{
	var ElementEnableVal=GetElementValue("ElementEnableVal");
	var QXType=GetElementValue("QXType");
	parent.location.href="dhceqinstock.csp?Type=0&ElementEnableVal="+ElementEnableVal+"&QXType="+QXType;
}
function BPrint_Clicked()
{
	var id=GetElementValue("RowID");
	if (""!=id) PrintInStore(id);
}

function BDelete_Clicked()
{
	var truthBeTold = window.confirm(t["02"]);
	if (!truthBeTold) return;
	var RowID=GetElementValue("RowID");
	var Return=UpdateInStock(RowID,"4");
	if (Return>0)
    {
	    var ElementEnableVal=GetElementValue("ElementEnableVal");
		var Type=GetElementValue("Type");
		var QXType=GetElementValue("QXType");
		parent.location.href="dhceqinstock.csp?Type="+Type+"&ElementEnableVal="+ElementEnableVal+"&QXType="+QXType;
	}
    else
    {
	    alertShow(t[Return]+"   "+t["01"]);
    }
}
function BCancelSubmit_Clicked() // 反提交
{
	var combindata=GetValueList();
	var Return=UpdateInStock(combindata,"3");
    if (Return>0)
    {
	    if (parent.DHCEQInStockListAdd) parent.DHCEQInStockListAdd.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInStockListAdd&InStockDR="+GetElementValue("RowID")
	    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInStock&RowID='+Return+"&Type="+GetElementValue("Type")+"&ElementEnableVal="+GetElementValue("ElementEnableVal")+"&QXType="+GetElementValue("QXType");
	}
    else
    {
	    alertShow(Return+"   "+t["01"]);
    }
}
function EquipHaveInStocked()
{
	var encmeth=GetElementValue("EquipHaveInStocked");
	var RowID=GetElementValue("RowID");
	return cspRunServerMethod(encmeth,RowID);
}
function BSubmit_Clicked()
{
	var count=EquipHaveInStocked();
	if (count>0)
	{
		alertShow(t["04"]);
		return;
	}
	var Return=ISHaveDetail();
	if (Return!=0)
	{
		alertShow(Return+"  "+t["03"]);
		return;
	}
	var combindata=GetValueList();
	var Return=UpdateInStock(combindata,"1");
	if (Return>0)
    {
	    parent.DHCEQInStockListAdd.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInStockListAdd&InStockDR="+GetElementValue("RowID")+"&ElementEnableVal="+GetElementValue("ElementEnableVal")+"&QXType="+GetElementValue("QXType");
	    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInStock&RowID='+Return+"&Type="+GetElementValue("Type")+"&ElementEnableVal="+GetElementValue("ElementEnableVal");
	}
    else
    {
	    alertShow(t[Return]+"   "+t["01"]);
    }
}
function BAudit_Clicked()
{
	if (CheckItemNull(1,"StatCat")) return ;
	var count=EquipHaveInStocked();
	if (count>0)
	{
		alertShow(t["04"]);
		return;
	}
	var combindata=GetValueList();
	var Return=UpdateInStock(combindata,"2");
    if (Return>0)
    {
	    //parent.DHCEQInStockListAdd.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInStockListAdd&InStockDR="+GetElementValue("RowID")
	    window.location.reload(); //= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInStock&RowID='+Return+"&Type="+GetElementValue("Type")
	}
    else
    {
	    alertShow(Return+t[Return]+"   "+t["01"]);
    }
}
function BUpdate_Clicked()
{
	var GetProviderOperMethod=GetElementValue("GetProviderOperMethod")
	if (CheckNull()) return;
	var combindata="";
  	combindata=GetElementValue("RowID") ;
  	combindata=combindata+"^"+GetElementValue("InDate") ;
  	combindata=combindata+"^"+GetElementValue("LocDR") ;
  	combindata=combindata+"^"+GetElementValue("RejectReasonDR") ;
  	combindata=combindata+"^"+GetElementValue("RequestUserDR") ;
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
  	combindata=combindata+"^"+GetElementValue("OriginDR") ;
  	combindata=combindata+"^"+GetElementValue("FromDeptDR") ;
  	combindata=combindata+"^"+GetProviderRowID(GetProviderOperMethod);//   2009-10-26  ZY  ZY0013 GetElementValue("ProviderDR") ;
  	combindata=combindata+"^"+curUserID;
  	combindata=combindata+"^"+GetElementValue("BuyLocDR") ;
  	combindata=combindata+"^"+GetElementValue("BuyUserDR") ;
  	combindata=combindata+"^"+GetElementValue("EquipTypeDR") ;
  	combindata=combindata+"^"+GetElementValue("StatCatDR") ;	
    var Return=UpdateInStock(combindata,"0");
    if (Return>0)
    {
	    parent.DHCEQInStockList.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInStockList&InStockDR="+Return+"&Type="+GetElementValue("Type");
	    if (parent.DHCEQInStockListAdd) parent.DHCEQInStockListAdd.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInStockListAdd&InStockDR="+Return+"&Type="+GetElementValue("Type");
	    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInStock&RowID='+Return+"&Type="+GetElementValue("Type")+"&ElementEnableVal="+GetElementValue("ElementEnableVal");
	}
    else
    {
	    alertShow(Return+"   "+t["01"]);
    }
}
function GetValueList()
{
	var ValueList="";
	ValueList=GetElementValue("RowID");
	ValueList=ValueList+"^"+GetElementValue("RejectReasonDR");
	ValueList=ValueList+"^"+curUserID;
	ValueList=ValueList+"^"+GetElementValue("Remark");
	ValueList=ValueList+"^"+GetElementValue("StatCatDR");
	return ValueList;
}
function ISHaveDetail()
{
	var RowID=GetElementValue("RowID");
	var encmeth=GetElementValue("ISHaveDetail");
	var ReturnValue=cspRunServerMethod(encmeth,RowID);
	return ReturnValue;
}
function BBillAudit_Click() 
{
	if (CheckItemNull(1,"StatCat")) return ;
	var combindata=GetValueList();
	//var InvoiceNo=GetInvoiceNo();
	//combindata=combindata+InvoiceNo;
	var Return=UpdateInStock(combindata,"5");
	if (Return>0)
    {
	    //parent.DHCEQInStockListAdd.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInStockListAdd&InStockDR="+GetElementValue("RowID")
	    window.location.reload(); //= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInStock&RowID='+Return+"&Type="+GetElementValue("Type")
	}
    else
    {
	    //alertShow(Return);
	    alertShow(t[Return]+"   "+t["01"]);
    }
}
function GetInvoiceNo()
{	var objtbl=parent.DHCEQInStockList.document.getElementById('tDHCEQInStockListUpdate');
	var rows=objtbl.rows.length;
	var InvoiceList="";
	var RowID="";
	var Invoice="";
	for (var i=1;i<rows;i++)
	{
		InvoiceList=InvoiceList+"^";
		var obj=parent.DHCEQInStockList.document.getElementById('TRowIDz'+i);
		if (obj) RowID=obj.value;
		var obj=parent.DHCEQInStockList.document.getElementById('TInvoiceNosz'+i);
		if (obj) Invoice=obj.value;
		InvoiceList=InvoiceList+RowID+","+Invoice;
	}	
	return InvoiceList;
}

function UpdateInStock(ValueList,AppType)
{
	var encmeth=GetElementValue("upd");
	var ReturnValue=cspRunServerMethod(encmeth,ValueList,AppType);
	return ReturnValue;
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
	} /// 2009-10-26  ZY  ZY0013
	/*
	if (CheckItemNull(1,"Loc")) return true;
	if (CheckItemNull(2,"InDate")) return true;
	if (CheckItemNull(1,"EquipType")) return true;
	//if (CheckItemNull(1,"StatCat")) return true;
	if (CheckItemNull(1,"Provider")) return true;
	*/
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
    var val=value.split("^");    
    ///alertShow(value);
    ///SetElement("EquipTypeCode",val[2]);
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
	//填充数据
	var OpenCheckID=value.split("^")
	var AvailableQty=OpenCheckID[2]
	var ISStatus=GetElementValue("Status")
	if (ISStatus!=="" && ISStatus!=="0") //入库单提交之后不可增加明细
	{
		alertShow("当前入库单已提交,需增加明细,请先取消提交!")
		return
	}
	//数据库增加记录,1:设备入库主表和明细表同时增加 2:只增加明细表
	ISNo=GetElementValue("InStockNo");
	if (ISNo=="") //主表和明细表同时增加记录
	{
		var plist=OpenCheckID[6]+"^"+"1"+"^"+GetElementValue("LocDR")
	}
	else //只增加明细记录
	{
		var plist=OpenCheckID[6]+"^"+"2"+"^"+GetElementValue("RowID")
	}
	var encmeth=GetElementValue("SaveData");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,plist,AvailableQty);
	if(result=="") 
	{
		alertShow("存储数据失败!");
		return
	}
	//刷新界面
	if (GetElementValue("RowID")=="")
	{
		window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInStock&RowID="+ result +"&Type=0"+"&ElementEnableVal="+GetElementValue("ElementEnableVal")+"&QXType="+GetElementValue("QXType");;
		parent.frames["DHCEQInStockList"].location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInStockList&InStockDR="+ result +"&Type=0"
		parent.frames["DHCEQInStockListAdd"].location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInStockListAdd&InStockDR="+ result +"&Type=0"
	}
	else
	{
		parent.frames["DHCEQInStockList"].location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInStockList&InStockDR="+ GetElementValue("RowID") +"&Type=0"
		parent.frames["DHCEQInStockListAdd"].location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInStockListAdd&InStockDR="+ GetElementValue("RowID") +"&Type=0"
	}
}

document.body.onload = BodyLoadHandler;

