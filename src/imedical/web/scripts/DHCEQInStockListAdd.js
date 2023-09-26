/// 修改:zy 2009-10-28 BugNo.ZY0016
/// 修改函数GetValueList,InitPage
/// 描述:改进功能,对机型,供应商,生产厂商取RowID.
/// 备注0:放大镜选择模式 1:手工录入模式,并自动更新机型表 2:两种均可
/// -------------------------------
function BodyLoadHandler() 
{
	//document.getElementById(GetLookupName("InvoiceDate")).removeNode(true)
	InitUserInfo();
	InitPage();
	ChangeStatus(false);
	
	DefaultInputFlag();
	
	FillData();
	SetBStatus();
	InitLast();
}

function DefaultInputFlag()
{
	var Inputobj=document.getElementById("InputFlag");
	if (Inputobj)
	{		
		Inputobj.checked=true;
		Batch_Change();
	}
}

function FillData()
{
	var RowID=GetElementValue("RowID");
	if (RowID=="") return;
	var encmeth=GetElementValue("fillData");
	var Value=cspRunServerMethod(encmeth,RowID)
	var list=Value.split("^")
	var sort=23
	SetChkElement("BatchFlag",list[2]);
	SetElement("InStockDR",list[0]);
	SetElement("InStock",list[sort+0]);
	SetElement("EquipDR",list[1]);
	SetElement("Equip",list[4]);
	SetElement("BuyPlanListDR",list[3]);
	SetElement("BuyPlanList",list[sort+2]);
	SetElement("EquipName",list[4]);
	SetElement("ManuFactoryDR",list[5]);
	SetElement("ManuFactory",list[sort+3]);
	SetElement("OriginalFee",list[6]);
	SetElement("QuantityNum",list[7]);
	SetElement("ModelDR",list[8]);
	SetElement("Model",list[sort+4]);
	SetElement("UnitDR",list[9]);
	SetElement("Unit",list[sort+5]);
	SetElement("Hold1",list[10]);
	SetElement("Hold1Desc",list[sort+12]);
	SetElement("Remark",list[11]);
	SetElement("AppendFee",list[12]);
	SetElement("EquipCatDR",list[13]);
	SetElement("EquipCat",list[sort+6]);
	SetElement("UseYearsNum",list[14]);
	SetElement("ItemDR",list[15]);
	SetElement("InvoiceNos",list[sort+7]);
	SetElement("OldInvoice",list[sort+7]);
	SetElement("InvoiceDate",list[sort+8]);
	SetElement("InvoiceFee",list[sort+9]);
	SetChkElement("InputFlag",list[sort+10]);
	
	//add by jdl 2009-04-13 begin
	SetElement("StatCatDR",list[16]);
	SetElement("StatCat",list[sort+11]);
	SetElement("SourceType",list[17]);
	SetElement("SourceID",list[18]);
	SetElement("Hold2",list[19]);
	SetElement("Hold3",list[20]);
	SetElement("Hold4",list[21]);
	SetElement("Hold5",list[22]);
	//add by jdl 2009-04-13 end
	
	SourceType=list[17];
	if (SourceType==1) //设备项
	{
		ElementDisableChange(false)
	}
	else //设备,验收单
	{
		ElementDisableChange(true)
	}
	
	/*
	if (list[2]=="1")
	{
		ElementDisableChange(false);
	}
	else
	{
		if (list[sort+10]=="1")
		{
			ElementDisableChange(false);
			//DisableElement("QuantityNum",true);
		}
		else
		{
			ElementDisableChange(true);
		}
	}
	*/
	InitPage();
	ChangeStatus(true);
	SetBStatus();
}
function InitPage()
{
	
	//EQCommon_HiddenElement(GetLookupName("InvoiceDate"));
	var obj=document.getElementById("Equip");
	if (obj) obj.onkeydown=Equip_KeyDown;
	var GetModelOperMethod=GetElementValue("GetModelOperMethod") //2009-07-10 党军 begin
	if (GetModelOperMethod!=1)
	{
		var obj=document.getElementById("Model");
		if (obj) obj.onkeydown=Model_KeyDown;
	} //2009-07-10 党军 end
	var obj=document.getElementById("Hold1Desc"); 
	if (obj) obj.onkeydown=TechLevel_KeyDown;
	
	var obj=document.getElementById("ManuFactory");
	if (obj) obj.onkeydown=ManuFactory_KeyDown;
	var obj=document.getElementById("SourceType");
	if (obj) obj.onchange=SourceType_Change;	//2009-06-26 党军 end
	var obj=document.getElementById("Unit");
	if (obj) obj.onkeydown=Unit_KeyDown;
	var obj=document.getElementById("EquipCat");
	if (obj) obj.onkeydown=EquipCat_KeyDown;
	var obj=document.getElementById("BatchFlag");
	if (obj) obj.onchange=Batch_Change;
	var obj=document.getElementById("InputFlag");
	if (obj) obj.onchange=Batch_Change;
	var obj=document.getElementById("Equip");
	if (obj) obj.onchange=Equip_Change;
	var BAobj=document.getElementById("BAdd");
	if (BAobj) BAobj.onclick=BUpdate_click;
	var BUobj=document.getElementById("BUpdate");
	if (BUobj)
	{
		var Type=GetElementValue("Type");
		if (Type=="0") BUobj.onclick=BUpdate_click;
		if (Type=="2") BUobj.onclick=BUpdateBill_click;
	}
	var BDobj=document.getElementById("BDelete");
	if (BDobj) BDobj.onclick=BDelete_click;
	var obj=document.getElementById("BClose");
	if (obj) obj.onclick=BClose_Click;	
	KeyUp("Model^ManuFactory^Unit^EquipCat");
	
	//add by jdl 2009-04-13 begin
	var obj=document.getElementById("StatCat");
	if (obj) obj.onkeydown=StatCat_KeyDown;
	KeyUp("StatCat","N");
	//add by jdl 2009-04-13 end
	
	//Mozy 2009-07-13
	var obj=document.getElementById("BMasterItem");
	if (obj) obj.onclick=BMasterItem_Clicked;
	var obj=document.getElementById("BModelInfo");
	if (obj) obj.onclick=BModelInfo_Clicked;
}
function Equip_Change()
{
	SetElement("BuyPlanListDR","");
	SetElement("EquipDR","");
	SetElement("ItemDR","")
}
function Batch_Change()
{
	var obj=document.getElementById("BatchFlag");
	var Inputobj=document.getElementById("InputFlag");
	if (!Inputobj) ValueClear();
	if (obj&&obj.checked)
	{
		ElementDisableChange(false);
	}
	else
	{
		if (Inputobj.checked)
		{
			ElementDisableChange(false);
			//DisableElement("QuantityNum",true);
			//SetElement("QuantityNum",1);
		}
		else
		{
			ElementDisableChange(true);
		}
	}
}
function SourceType_Change() //2009-06-26 党军
{
	var SourceType=GetElementValue("SourceType");
	ValueClear();
	if (SourceType==1) //设备项
	{
		ElementDisableChange(false)
	}
	else //设备,验收单
	{
		ElementDisableChange(true)
	}
}
function ElementDisableChange(value)
{
	ReadOnlyElement("Model",value);
	ReadOnlyElement("ManuFactory",value);
	ReadOnlyElement("Unit",value);
	ReadOnlyElement("QuantityNum",value);
	ReadOnlyElement("OriginalFee",value);
	ReadOnlyElement("AppendFee",value);
}
function ValueClear()
{
	SetElement("EquipDR","");
	SetElement("Equip","");
	SetElement("BuyPlanListDR","");
	SetElement("ModelDR","");
	SetElement("Model","");
	SetElement("ManuFactoryDR","");
	SetElement("ManuFactory","");
	SetElement("QuantityNum","");
	SetElement("UnitDR","");
	SetElement("Unit","");
	SetElement("OriginalFee","");
	SetElement("AppendFee","");
	SetElement("EquipCatDR","");
	SetElement("EquipCat","");
	SetElement("UseYearsNum","");
	SetElement("ItemDR","")
	
	//SetElement("StatCatDR","")
	//SetElement("StatCatDR","")
}
function ManuFactory_KeyDown()
{
	if (event.keyCode==13)
	{
		LookUpManuFactory("GetManuFactory","ManuFactory");
	}
}
function Unit_KeyDown()
{
	if (event.keyCode==13)
	{
		LookUpUnit("GetUnit","Unit,GetEquipUnitType");
	}
}
function EquipCat_KeyDown()
{
	if (event.keyCode==13)
	{
		//LookUpEquipCat("GetEquipCat","EquipCat");
		var CatName=GetElementValue("EquipCat")
		var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCEquipCatTree&Type=SelectTree&CatName="+CatName;
    	window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=360,height=460,left=150,top=150')
	}
}
function SetEquipCat(id,text)
{
	SetElement("EquipCat",text);
	SetElement("EquipCatDR",id);
	var encmeth=GetElementValue("GetUseYearsByCat");
	var UseYears=cspRunServerMethod(encmeth,id);
	if (""!=UseYears) SetElement("UseYearsNum",UseYears);
}
function Equip_KeyDown()
{
	if (event.keyCode==13)
	{
		var SourceType=GetElementValue("SourceType")
		if (SourceType=="")
		{
			alertShow(t["06"]);
			return
		}
		if (SourceType==0) //设备
		{
			LookUpInStockEquip("GetEquip","StatCatDR,EquipTypeDR,Equip,StockStatus,'',DJType,'','',ProviderDR");
		}
		if (SourceType==1) //设备项
		{
			LookUpMasterItem("GetMasterItem","EquipTypeDR,StatCatDR,Equip");
		}
		if (SourceType==2) //订单
		{
			LookUpOpenCheckRequest("GetOpenCheckRequest","InStockDR");
		}
		/*
		var obj=document.getElementById("BatchFlag");
		var inputobj=document.getElementById("InputFlag");
		if (inputobj.checked)
		{
			LookUpMasterItem("GetMasterItem","EquipTypeDR,StatCatDR,Equip");
		}
		else
		{
			if (obj&&obj.checked)
			{
				LookUpBuyPlanListInStock("GetBuyPlanList","StatCatDR,EquipTypeDR,Equip");
			}
			else
			{
				LookUpInStockEquip("GetEquip","StatCatDR,EquipTypeDR,Equip,StockStatus,'',DJType,'','',ProviderDR");
			}
		}
		*/
	}
}
function Model_KeyDown()
{
	if (event.keyCode==13)
	{
		LookUpModel("GetModel","ItemDR,Model");
	}
}

function TechLevel_KeyDown()
{
	if (event.keyCode==13)
	{
		LookUpTechLevel("GetTechLevel","");
	}
}

function GetMasterItem(value)
{
	list=value.split("^");
	SetElement("Equip",list[0]);
	SetElement("ItemDR",list[1]);
	SetElement("SourceID",list[1]); //2009-06-26 党军
	SetOtherData(list[1],"3")
}

function GetOpenCheckRequest(value) //2009-06-26 党军
{
	list=value.split("^");
	var ISLStatus=list[1];
	var ISNo=list[2];
	if (ISLStatus=="Y")
	{
		alertShow("当前设备已在入库单" + ISNo + "中存在!");
		return;
	}
	SetElement("Equip", list[0]);
	SetOtherData(list[6],"1");
}
function GetBuyPlanList(value)
{
	list=value.split("^");
	SetElement("Equip",list[0]);
	SetElement("BuyPlanListDR",list[1]);
	SetOtherData(list[1],"1")
}
function GetEquip(value)
{
	list=value.split("^");
	SetElement("Equip",list[0]);
	SetElement("EquipDR",list[1]);
	SetElement("SourceID",list[1]); //2009-06-26 党军
	SetOtherData(list[1],"2")
}
function SetOtherData(RowID,Type)
{
	var encmeth=GetElementValue("SetOtherData");
	var SourceType=GetElementValue("SourceType")
	var obj=document.getElementById("BatchFlag")
	var inputobj=document.getElementById("InputFlag")
	var value=cspRunServerMethod(encmeth,RowID,Type);
	var list=value.split("^");
	//modified by jdl 2009-10-29 JDL0037
	//if (!inputobj.checked)
	if (SourceType!=1)
	{
		SetElement("Model",list[1]);
		SetElement("ModelDR",list[0]);
		SetElement("ManuFactory",list[3]);
		SetElement("ManuFactoryDR",list[2]);
		SetElement("Unit",list[5]);
		SetElement("UnitDR",list[4]);
		SetElement("QuantityNum",list[6]);
		SetElement("OriginalFee",list[7]);
		SetElement("AppendFee",list[8]);
		SetElement("EquipCatDR",list[9]);
		SetElement("EquipCat",list[10]);
		SetElement("UseYearsNum",list[11]);
		SetElement("ItemDR",list[12]);		
	}
	else
	{
		if (""!=list[9])
		{
			SetElement("EquipCatDR",list[9]);
			SetElement("EquipCat",list[10]);
		}
		if (""!=list[11])
		{
			SetElement("UseYearsNum",list[11]);
		}
		if (""!=list[0])
		{
			SetElement("Model",list[1]);
			SetElement("ModelDR",list[0]);
		}
		if (""==GetElementValue("QuantityNum"))
		{
			SetElement("QuantityNum",1);
		}
		SetElement("Unit",list[5]);
		SetElement("UnitDR",list[4]);
		SetElement("ItemDR",list[12]);
	}
	SetElement("StatCat",list[13]);
	//add by jdl 2009-04-13
	SetElement("StatCatDR",list[14]);
	//add by jdl 2009-10-29 JDL0037
	SetElement("SourceID",list[15]);
}
function GetUnit(value)
{
	list=value.split("^");
	SetElement("Unit",list[0]);
	SetElement("UnitDR",list[1]);
}
function GetEquipCat(value)
{
	list=value.split("^");
	SetElement("EquipCat",list[0]);
	SetElement("EquipCatDR",list[1]);
}
function GetModel(value)
{
	list=value.split("^");
	SetElement("Model",list[0]);
	SetElement("ModelDR",list[1]);
}
function GetManuFactory(value)
{
	list=value.split("^");
	SetElement("ManuFactory",list[0]);
	SetElement("ManuFactoryDR",list[1]);
}
function ChangeStatus(Value)
{
	InitPage();
	DisableBElement("BUpdate",!Value);
	DisableBElement("BDelete",!Value);
	DisableBElement("BAdd",Value);
	//SetBStatus();
}
function SetBStatus()
{
	var Status=GetElementValue("Status");
	var Type=GetElementValue("Type");
	var ReadOnly=GetElementValue("ReadOnly");
	if (ReadOnly=="1")
	{
		DisableBElement("BDelete",true);
		DisableBElement("BAdd",true);
		DisableBElement("BUpdate",true);
		return
	}
	var obj=parent.frames["DHCEQInStock"].document.getElementById("EquipHasIn");
	var EquipHasIn="";
	if (obj) EquipHasIn=obj.value;
	
	if (Status!="0")
	{
		DisableBElement("BDelete",true);
		DisableBElement("BAdd",true);
		DisableElement("BatchFlag",true);
		DisableElement("InputFlag",true);
		ReadOnlyElement("Equip",true);
		ReadOnlyElement("Unit",true);
		ReadOnlyElement("Model",true);
		ReadOnlyElement("ManuFactory",true);
		ReadOnlyElement("QuantityNum",true);
		ReadOnlyElement("OriginalFee",true);
		ReadOnlyElement("EquipCat",true);
		ReadOnlyElement("UseYearsNum",true);
		ReadOnlyElement("Remark",true);
		ReadOnlyElement("AppendFee",true);
		ReadOnlyElement("InvoiceNos",false);
		ReadOnlyElement("InvoiceDate",false);
		ReadOnlyElement("InvoiceFee",false);
		
		
		if (EquipHasIn!="1")
		{
			ReadOnlyElement("EquipCat",false);
			ReadOnlyElement("UseYearsNum",false);
			//DisableElement("OriginalFee",false);
			//DisableElement("AppendFee",false);
		}
	}
	if (Type!="2"&&(Status!="0"))
	{
		DisableBElement("BUpdate",true);
	}
	if (Type!="0")
	{
		DisableBElement("BAdd",true);
	}
}
function BUpdateBill_click()
{
	var encmeth=GetElementValue("billupd");
	var val=GetElementValue("RowID");
	val=val+"^"+GetElementValue("EquipCatDR");
	val=val+"^"+GetElementValue("UseYearsNum");
	val=val+"^"+GetElementValue("OriginalFee");
	val=val+"^"+GetElementValue("InvoiceNos");
	val=val+"^"+GetElementValue("InvoiceDate");
	val=val+"^"+GetElementValue("InvoiceFee");
	val=val+"^"+GetElementValue("AppendFee");
	var UpdAll="N"
	if (GetElementValue("InvoiceNos")!=GetElementValue("OldInvoice"))
	{
		var objtbl=parent.DHCEQInStockList.document.getElementById('tDHCEQInStockList');
		var rows=objtbl.rows.length;
		var truthBeTold=false;
		if (rows>2) truthBeTold = window.confirm(t["05"]);
		if (truthBeTold) UpdAll="Y"
	}
	val=val+"^"+UpdAll
	var Return=cspRunServerMethod(encmeth,val);
	if (Return>0)
	{
		window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInStockListAdd&InStockDR="+GetElementValue("InStockDR")+"&RowID="+"&Type="+GetElementValue("Type")
		parent.frames["DHCEQInStockList"].location.reload() //href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInStockList&InStockDR="+GetElementValue("InStockDR") //reload();
	}
	else
	{
		alertShow(t[Return]+"  "+t["01"]);
	}
}
function BClose_Click() 
{
	window.close();
}
function EquipIsAudit()
{
	var obj=document.getElementById("BatchFlag")
	var BatchFlag="N"
	if (obj&&obj.checked) BatchFlag="Y"
	var EquipID=GetElementValue("EquipDR")
	var Fee=GetElementValue("OriginalFee")
	var encmeth=GetElementValue("EquipIsAudit")
	var Return=cspRunServerMethod(encmeth,BatchFlag,Fee,EquipID)
	return Return
}
//更新按钮点击函数
function BUpdate_click()
{
	if (CheckNull()) return;
	
	var Return=EquipIsAudit()
	if (Return<0)
	{
		var truthBeTold = window.confirm(t[Return]+t["03"]);
		if (!truthBeTold) return;
	}
	UpdateData("0");
}
//删除按钮点击函数
function BDelete_click()
{
	var truthBeTold = window.confirm(t["02"]);
	if (!truthBeTold) return;
	UpdateData("1");
}
function UpdateData(Type)
{
	var encmeth=GetElementValue("upd");
	var ValueList=GetValueList();
	var Return=cspRunServerMethod(encmeth,"","",ValueList,Type);
	if (Return>0)
	{
		window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInStockListAdd&InStockDR="+GetElementValue("InStockDR")+"&RowID="+"&Type="+GetElementValue("Type")
		parent.frames["DHCEQInStockList"].location.reload() //href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInStockList&InStockDR="+GetElementValue("InStockDR") //reload();
	}
	else
	{
		alertShow(t[Return]+"  "+t["01"]);
	}
}
function GetValueList()
{
	var ModelOperMethod=GetElementValue("GetModelOperMethod")
	var GetManuFactoryOperMethod=GetElementValue("GetManuFactoryOperMethod")
	var combindata="";
  	combindata=GetElementValue("RowID") ;
  	combindata=combindata+"^"+GetElementValue("InStockDR") ;
  	combindata=combindata+"^"+GetElementValue("EquipDR") ;
  	var Flag=GetChkElementValue("BatchFlag");
  	var InputFlag=GetChkElementValue("InputFlag");
  	var Quantity=GetElementValue("QuantityNum") ;
  	if (Flag==false&&InputFlag==true&&Quantity>1) {Flag=true;}
  	if (Flag==true&&InputFlag==true&&Quantity=="1") {Flag=false;}
  	combindata=combindata+"^"+Flag ;
  	combindata=combindata+"^"+GetElementValue("BuyPlanListDR") ;
  	combindata=combindata+"^"+GetElementValue("Equip") ;
  	combindata=combindata+"^"+GetManuFactoryRowID(GetManuFactoryOperMethod);   ////2009-11-11 zy ZY0016 GetElementValue("ManuFactoryDR") ;
  	combindata=combindata+"^"+GetElementValue("OriginalFee") ;
  	combindata=combindata+"^"+GetElementValue("QuantityNum") ;
  	combindata=combindata+"^"+GetModelRowID(ModelOperMethod) ; //2009-07-10 党军 //2009-11-11 zy ZY0016
  	combindata=combindata+"^"+GetElementValue("UnitDR") ;
  	combindata=combindata+"^"+GetElementValue("Hold1") ;
  	combindata=combindata+"^"+GetElementValue("Remark") ;
  	combindata=combindata+"^"+GetElementValue("AppendFee") ;
  	combindata=combindata+"^"+GetElementValue("EquipCatDR");
  	combindata=combindata+"^"+GetElementValue("UseYearsNum");
  	combindata=combindata+"^"+GetElementValue("ItemDR");
	combindata=combindata+"^"+GetElementValue("InvoiceNos");
  	combindata=combindata+"^"+GetElementValue("InvoiceDate");
  	combindata=combindata+"^"+GetElementValue("InvoiceFee");
  	
  	//add by jdl 2009-04-13
  	combindata=combindata+"^"+GetElementValue("StatCatDR");
  	combindata=combindata+"^"+GetElementValue("SourceType");
  	combindata=combindata+"^"+GetElementValue("SourceID");
  	combindata=combindata+"^"+GetElementValue("Hold2");
  	combindata=combindata+"^"+GetElementValue("Hold3");
  	combindata=combindata+"^"+GetElementValue("Hold4");
  	combindata=combindata+"^"+GetElementValue("Hold5");
  	
  	return combindata
}
function CheckNull()
{
	/*
	var obj=document.getElementById("BatchFlag");
	var inputobj=document.getElementById("InputFlag");
	if (obj&&obj.checked)
	{
		if (CheckItemNull(2,"Equip","设备名称")) return true;
		//if (CheckItemNull(2,"ModelDR","设备型号")) return true;
		//if (CheckItemNull(2,"ManuFactoryDR","生产厂商")) return true;
		if (CheckItemNull(2,"QuantityNum","数量")) return true;
		if (CheckItemNull(2,"UnitDR","设备单位")) return true;
	}
	else
	{
		if (inputobj.checked)
		{
			if (CheckItemNull(2,"Equip","设备名称")) return true;
			//if (CheckItemNull(2,"ModelDR","机型")) return true;
			//if (CheckItemNull(2,"ManuFactoryDR","生产厂商")) return true;
			if (CheckItemNull(2,"QuantityNum","数量")) return true;
			if (CheckItemNull(2,"UnitDR","设备单位")) return true;
		}
		else
		{
			if (CheckItemNull(1,"Equip","设备名称")) return true;
		}
	}
	*/
	if (CheckItemNull(2,"SourceType","设备来源类型")) return true;
	if (CheckItemNull(2,"Equip","设备名称")) return true;
	if (CheckItemNull(2,"QuantityNum","数量")) return true;
	if (CheckItemNull(2,"UnitDR","设备单位")) return true;
	if (CheckItemNull(2,"SourceID","设备名称")) return true;
	var Fee=GetElementValue("OriginalFee")
	if ((Fee<0)||(Fee==""))
	{
		alertShow(t["04"]);
		return true
	}
	return false;
}
function LookUpInStockEquip(jsfunction,paras)
{
	LookUp("","web.DHCEQInStockList:GetEquip",jsfunction,paras);
}
function LookUpOpenCheckRequest(jsfunction,paras) //2009-06-26 党军
{
	LookUp("","web.DHCEQInStock:GetOpenCheck",jsfunction,paras);
}
function LookUpBuyPlanListInStock(jsfunction,paras)
{
	LookUp("","web.DHCEQInStockList:GetBPList",jsfunction,paras);
}

function LookUpTechLevel(jsfunction,paras)
{
	LookUp("","web.DHCEQCTechLevel:LookUp",jsfunction,paras);
}

function GetTechLevel(value)
{
	list=value.split("^");
	SetElement("Hold1Desc",list[0]);	
	SetElement("Hold1",list[1]);
}

//add by jdl 2009-04-13 begin
function StatCat_KeyDown()
{
	if (event.keyCode==13)
	{
		LookUp("","web.DHCEQCStatCat:LookUp","GetStatCat","StatCat,EquipTypeDR");
	}
}

function GetStatCat(value)
{
	list=value.split("^");
	SetElement("StatCat",list[0]);	
	SetElement("StatCatDR",list[1]);
}
//add by jdl 2009-04-13 end

//Mozy	2009-7-13
//链接设备项维护页面?可传递设备项(汉字)描述参数
//按钮元素BMasterItem
function BMasterItem_Clicked()
{
	var Desc=GetElementValue("Equip");
	var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCMasterItem&Desc="+Desc;
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=850,height=630,left=0,top=0')
}
//Mozy	2009-7-13
//链接设备规格型号维护页面?可传递设备项参数和机型描述
//按钮元素BModelInfo
function BModelInfo_Clicked()
{
	var Desc=GetElementValue("Model");
	var ItemDR=GetElementValue("ItemDR");
	if(ItemDR!="") ItemDR="&ItemDR="+ItemDR+"&Item="+GetElementValue("Equip");
	var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCModel&Desc="+Desc+ItemDR;
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=850,height=630,left=0,top=0')
}

document.body.onload = BodyLoadHandler;
