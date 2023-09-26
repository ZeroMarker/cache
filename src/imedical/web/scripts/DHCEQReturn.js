var isReturn;

function BodyLoadHandler() 
{
	document.body.scroll="no";
	KeyUp("ReturnLoc^Provider^EquipType^StatCat","N");
	InitUserInfo();
	InitPage();
	FillData();
	SetEnabled();
	Muilt_LookUp("ReturnLoc^Provider^EquipType^StatCat");
	isReturn=GetElementValue("IsReturn");
}
function SetEnabled()
{
	var Status=GetElementValue("Status");
	var Type=GetElementValue("Type");
	var ReadOnly=GetElementValue("ReadOnly");
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
		//DisableLookup("RejectReason",true)
		DisableBElement("BBillAudit",true);
	}
	if (Status=="1")
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BAudit",true);
	}
	if (Status=="2")
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BCancelSubmit",true);
		DisableBElement("BBillAudit",true);
		DisableBElement("BSubmit",true);
		//DisableLookup("RejectReason",true)
	}
	if (Status=="3")
	{
		DisableBElement("BBillAudit",true);
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BCancelSubmit",true);
		DisableBElement("BAudit",true);
		DisableBElement("BSubmit",true);
		//DisableLookup("RejectReason",true)
	}
	if (Status=="")
	{
		DisableBElement("BBillAudit",true);
		DisableBElement("BDelete",true);
		DisableBElement("BCancelSubmit",true);
		DisableBElement("BAudit",true);
		DisableBElement("BSubmit",true);
		//DisableLookup("RejectReason",true)
	}
	var BElementEnableVal=GetElementValue("ElementEnableVal");
	BElementEnableByVal(BElementEnableVal);
	if (Type!="0") DisableBElement("BClear",true);
	/*
	if (Type=="0")
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
		DisableBElement("BAudit",true);
	}*/
}
function FillData()
{
	var obj=document.getElementById("RowID");
	var RowID=obj.value;
	if ((RowID=="")||(RowID<1)){
		return;
	}
	var obj=document.getElementById("GetData");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var ReturnList=cspRunServerMethod(encmeth,RowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	list=ReturnList.split("^");
	//var sort=16;
	var sort=21;
	SetElement("ReturnNo",list[0]);
	SetElement("ReturnLocDR",list[1]);
	SetElement("ReturnLoc",list[sort+0]);
	SetElement("ProviderDR",list[2]);
	SetElement("Provider",list[sort+1]);
	SetElement("ReturnDate",list[3]);
	SetElement("MakerDR",list[4]);
	SetElement("Maker",list[sort+2]);
	SetElement("MakeDate",list[5]);
	SetElement("AckUserDR",list[6]);
	SetElement("AckUser",list[sort+3]);
	SetElement("AckDate",list[7]);
	SetElement("AckTime",list[8]);
	SetElement("BillAckUserDR",list[9]);
	SetElement("BillAckUser",list[sort+4]);
	SetElement("BillAckDate",list[10]);
	SetElement("BillAckTime",list[11]);
	SetElement("Status",list[12]);
	SetElement("Remark",list[13]);
	SetElement("EquipTypeDR",list[14]);
	SetElement("EquipType",list[sort+5]);
	SetElement("StatCatDR",list[15]);
	SetElement("StatCat",list[sort+6]);
	
	SetElement("OutTypeDR",list[16]);
	SetElement("OutType",list[sort+7]);
	SetElement("ToDeptDR",list[17]);
	SetElement("ToDept",list[sort+8]);
	SetElement("Hold1",list[18]);
	SetElement("Hold2",list[19]);
	SetElement("Hold3",list[20]);
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
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_Clicked;
	var obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_Clicked;
}
function BPrint_Clicked()
{
	var ID=GetElementValue("RowID")
	PrintReturn(ID)
}
function BClear_Clicked()
{
	var ElementEnableVal=GetElementValue("ElementEnableVal");
	var QXType=GetElementValue("QXType");
	parent.location.href="dhceqreturn.csp?Type=0&ElementEnableVal="+ElementEnableVal+"&QXType="+QXType;
}
function BDelete_Clicked()
{
	var truthBeTold = window.confirm(t["02"]);
	if (!truthBeTold) return;
	var RowID=GetElementValue("RowID")
	var Return=UpdateReturn(RowID,"4");
	if (Return>0)
    {
	    var ElementEnableVal=GetElementValue("ElementEnableVal");
		parent.location.href="dhceqreturn.csp?Type=0&ElementEnableVal="+ElementEnableVal+"&QXType="+GetElementValue("QXType");
	}
    else
    {
	    alertShow(Return+"   "+t["01"]);
    }
}
function BCancelSubmit_Clicked() // 反提交
{
	var combindata=GetValueList();
	var Return=UpdateReturn(combindata,"5");
    if (Return>0)
    {
	    //parent.DHCEQReturnListAdd.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQReturnListAdd&ReturnDR="+GetElementValue("RowID")
	    if (isReturn=="N")
	    {
		    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQOutStock&RowID='+Return+"&Type="+GetElementValue("Type")+"&ElementEnableVal="+GetElementValue("ElementEnableVal")+"&QXType="+GetElementValue("QXType");
	    }
	    else
	    {
	    	window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQReturn&RowID='+Return+"&Type="+GetElementValue("Type")+"&ElementEnableVal="+GetElementValue("ElementEnableVal")+"&QXType="+GetElementValue("QXType");
	    }
	}
    else
    {
	    alertShow(Return+"   "+t["01"]);
    }
}
function BSubmit_Clicked()
{
	var Return=ReturnListIsVaild();
	if (Return!=0)
	{
		alertShow(Return);
		return;
	}
	var combindata=GetValueList();
	var Return=UpdateReturn(combindata,"1");
	if (Return>0)
    {
	    if (isReturn=="N")
	    {
		    parent.DHCEQOutStockListAdd.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQOutStockListAdd&ReturnDR="+GetElementValue("RowID")
	    	window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQOutStock&RowID='+Return+"&Type="+GetElementValue("Type")+"&ElementEnableVal="+GetElementValue("ElementEnableVal")+"&QXType="+GetElementValue("QXType");
	    }
	    else
	    {
	    	parent.DHCEQReturnListAdd.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQReturnListAdd&ReturnDR="+GetElementValue("RowID")
	    	window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQReturn&RowID='+Return+"&Type="+GetElementValue("Type")+"&ElementEnableVal="+GetElementValue("ElementEnableVal")+"&QXType="+GetElementValue("QXType");
	    }
	}
    else
    {
	    alertShow(Return+"   "+t["01"]);
    }
}
function BAudit_Clicked()
{
	var Return=ReturnListIsVaild();
	if (Return!=0)
	{
		alertShow(Return);
		return;
	}
	var combindata=GetValueList();
	var Return=UpdateReturn(combindata,"3");
    if (Return>0)
    {
	    //parent.DHCEQReturnListAdd.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQReturnListAdd&ReturnDR="+GetElementValue("RowID")
	    window.location.reload() //= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQReturn&RowID='+Return+"&Type="+GetElementValue("Type")
	}
    else
    {
	    alertShow(Return+"   "+t["01"]);
    }
}
function BUpdate_Clicked()
{
	if (CheckNull()) return;
	var combindata=GetValueList();
	var Return=UpdateReturn(combindata,"0");
    if (Return>0)
    {
	    if (isReturn=="N")
	    {
		    parent.DHCEQOutStockList.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQOutStockList&ReturnDR="+Return
	    	parent.DHCEQOutStockListAdd.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQOutStockListAdd&ReturnDR="+Return
	    	window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQOutStock&RowID='+Return+"&Type="+GetElementValue("Type")+"&ElementEnableVal="+GetElementValue("ElementEnableVal")+"&QXType="+GetElementValue("QXType");
	    }
	    else
	    {
	    	parent.DHCEQReturnList.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQReturnList&ReturnDR="+Return
	    	parent.DHCEQReturnListAdd.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQReturnListAdd&ReturnDR="+Return
	    	window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQReturn&RowID='+Return+"&Type="+GetElementValue("Type")+"&ElementEnableVal="+GetElementValue("ElementEnableVal")+"&QXType="+GetElementValue("QXType");
	    }
	}
    else
    {
	    alertShow(Return+"   "+t["01"]);
    }
}
function GetValueList()
{
	var combindata="";
  	combindata=GetElementValue("RowID") ;
  	combindata=combindata+"^"+GetElementValue("ReturnNo") ;
  	combindata=combindata+"^"+GetElementValue("ReturnLocDR") ;
  	combindata=combindata+"^"+GetElementValue("ProviderDR") ;
  	combindata=combindata+"^"+GetElementValue("ReturnDate") ;
  	combindata=combindata+"^"+GetElementValue("MakerDR") ;
  	combindata=combindata+"^"+GetElementValue("MakeDate") ;
  	combindata=combindata+"^"+GetElementValue("AckUserDR") ;
  	combindata=combindata+"^"+GetElementValue("AckDate") ;
  	combindata=combindata+"^"+GetElementValue("AckTime") ;
  	combindata=combindata+"^"+GetElementValue("BillAckUserDR") ;
  	combindata=combindata+"^"+GetElementValue("BillAckDate") ;
  	combindata=combindata+"^"+GetElementValue("BillAckTime") ;
  	combindata=combindata+"^"+GetElementValue("Status") ;
  	combindata=combindata+"^"+GetElementValue("Remark") ;
  	combindata=combindata+"^"+GetElementValue("EquipTypeDR") ;
  	combindata=combindata+"^"+GetElementValue("StatCatDR") ;  	
  	combindata=combindata+"^"+GetElementValue("OutTypeDR") ;
  	combindata=combindata+"^"+GetElementValue("ToDeptDR") ;
  	combindata=combindata+"^"+GetElementValue("Hold1") ;
  	combindata=combindata+"^"+GetElementValue("Hold2") ;
  	combindata=combindata+"^"+GetElementValue("Hold3") ;
  	return combindata;
}
function ReturnListIsVaild()
{
	var RowID=GetElementValue("RowID");
	var encmeth=GetElementValue("ReturnListIsVaild");
	var ReturnValue=cspRunServerMethod(encmeth,RowID);
	return ReturnValue;
}
function BBillAudit_Click() 
{
	var combindata=GetElementValue("RowID");
	var InvoiceNo=GetInvoiceNo();
	combindata=combindata+InvoiceNo;
	var Return=UpdateReturn(combindata,"2");
	if (Return>0)
    {
	    //parent.DHCEQReturnListAdd.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQReturnListAdd&ReturnDR="+GetElementValue("RowID")
	    window.location.reload() //href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQReturn&RowID='+Return+"&Type="+GetElementValue("Type")
	}
    else
    {
	    alertShow(Return+"   "+t["01"]);
    }
}
function GetInvoiceNo()
{	var Type=GetElementValue("Type");
	if (isReturn=="N")
	{
		var objtbl=parent.DHCEQOutStockList.document.getElementById('tDHCEQOutStockList');
	}
	else
	{
		if (Type=="2")
		{
			var objtbl=parent.DHCEQReturnList.document.getElementById('tDHCEQReturnListUpdate');
		}
		else
		{
			var objtbl=parent.DHCEQReturnList.document.getElementById('tDHCEQReturnList');
		}
	}
	var rows=objtbl.rows.length;
	var InvoiceList=""
	var RowID=""
	var Invoice=""
	var doc;
	if (isReturn=="N")
	{
		doc=parent.DHCEQOutStockList.document;
	}
	else
	{
		doc=parent.DHCEQReturnList.document;
	}
	for (var i=1;i<rows;i++)
	{
		InvoiceList=InvoiceList+"^";
		var obj=doc.getElementById('TRowIDz'+i);
		if (obj) RowID=obj.value
		var obj=doc.getElementById('TInvoiceNoz'+i);
		if (obj) Invoice=obj.value
		InvoiceList=InvoiceList+RowID+","+Invoice
	}	
	return InvoiceList
}

function UpdateReturn(ValueList,AppType)
{
	var encmeth=GetElementValue("GetUpdate")
	var ReturnValue=cspRunServerMethod(encmeth,"","",ValueList,AppType);
	return ReturnValue;
}
function CheckNull()
{
	if (CheckMustItemNull()) return true;
	/*
	if (CheckItemNull(2,"ReturnDate")) return true;
	if (CheckItemNull(1,"ReturnLoc")) return true;
	if (CheckItemNull(1,"Provider")) return true;
	if (CheckItemNull(1,"EquipType")) return true;
	if (CheckItemNull(1,"StatCat")) return true;
	if (CheckItemNull(2,"MoveType")) return true;
	*/
	return false;
}
function ProviderDR (value)
{
    GetLookUpID("ProviderDR",value);
}
function ReturnLocDR (value)
{
    GetLookUpID("ReturnLocDR",value);
}
function GetStatCat (value)
{
    GetLookUpID("StatCatDR",value);
}
function GetEquipType (value)
{
    GetLookUpID("EquipTypeDR",value);
}

function GetToDept(value)
{
	GetLookUpID("ToDeptDR",value);
}

function GetOutType(value)
{
	GetLookUpID("OutTypeDR",value);
}

document.body.onload = BodyLoadHandler;

