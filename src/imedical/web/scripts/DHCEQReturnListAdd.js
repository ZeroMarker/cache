var isReturn;

function BodyLoadHandler() 
{
	isReturn=GetElementValue("IsReturn");
	InitUserInfo();
	InitPage();
	ChangeStatus(false);
	FillData();
	SetBStatus();	
}
function FillData()
{
	var RowID=GetElementValue("RowID");
	if (RowID=="") return;
	var encmeth=GetElementValue("GetData");
	var Value=cspRunServerMethod(encmeth,RowID);
	var list=Value.split("^");
	//var sort=9
	var sort=13;
	SetElement("ReturnDR",list[0]);
	//SetElement("Return",list[sort+0]);
	//SetChkElement("BatchFlag",list[1]);
	SetElement("InStockListDR",list[2]);
	//SetElement("InStockList",list[sort+1]);
	SetElement("EquipDR",list[3]);
	//SetElement("Equip",list[sort+2]);
	SetElement("ReturnQtyNum",list[4]);
	SetElement("ReturnFee",list[5]);
	SetElement("InvoiceNo",list[6]);
	SetElement("ReturnReasonDR",list[7]);
	SetElement("ReturnReason",list[sort+3]);
	SetElement("Remark",list[8]);
	SetElement("Equip",list[sort+4]);
	SetElement("Model",list[sort+5]);
	SetElement("ManuFactory",list[sort+6]);
	SetElement("MoveMaxQuantity",list[sort+7]);
	if (list[1]=="Y")
	{
		DisableElement("ReturnQtyNum",false);
		//DisableElement("OriginalFee",false);
	}
	ChangeStatus(true);
}
function InitPage()
{
	var obj=document.getElementById("Equip");
	if (obj) obj.onkeydown=Equip_KeyDown;
	var obj=document.getElementById("ReturnReason");
	if (obj) obj.onkeydown=ReturnReason_KeyDown;
	var obj=document.getElementById("BatchFlag");
	if (obj) obj.onchange=Batch_Change;
	var obj=document.getElementById("Equip");
	if (obj) obj.onchange=Equip_Change;
	var BAobj=document.getElementById("BAdd");
	if (BAobj) BAobj.onclick=BUpdate_click;
	var BUobj=document.getElementById("BUpdate");
	if (BUobj) BUobj.onclick=BUpdate_click;
	var BDobj=document.getElementById("BDelete");
	if (BDobj) BDobj.onclick=BDelete_click;
	var obj=document.getElementById("BClose");
	if (obj) obj.onclick=BClose_Click;	
	KeyUp("Model^ManuFactory");
}
function Equip_Change()
{
	var obj=document.getElementById("BatchFlag");
	if (obj&&obj.checked)
	{
		SetElement("InStockListDR","");
	}
	else
	{
		SetElement("EquipDR","");
	}
}
function Batch_Change()
{
	var obj=document.getElementById("BatchFlag");
	ValueClear();
	if (obj&&obj.checked)
	{
		//DisableElement("Model",false);
		//DisableElement("ManuFactory",false);
		//DisableElement("Unit",false);
		DisableElement("ReturnQtyNum",false);
		//DisableElement("OriginalFee",false);
	}
	else
	{
		//DisableElement("Model",true);
		//DisableElement("ManuFactory",true);
		//DisableElement("Unit",true);
		DisableElement("ReturnQtyNum",true);
		//DisableElement("OriginalFee",true);
	}
}
function ValueClear()
{
	SetElement("EquipDR","");
	SetElement("Equip","");
	SetElement("InstockListDR","");
	//SetElement("ModelDR","");
	SetElement("Model","");
	//SetElement("ManuFactoryDR","");
	SetElement("ManuFactory","");
	SetElement("ReturnQtyNum","");
	//SetElement("UnitDR","");
	//SetElement("Unit","");
	SetElement("ReturnFee","");
}
function ReturnReason_KeyDown()
{
	if (event.keyCode==13)
	{
		LookUpReturnReason("GetReturnReason","ReturnReason");
	}
}
function Equip_KeyDown()
{
	if (event.keyCode==13)
	{
		var obj=document.getElementById("BatchFlag");
		if (obj&&obj.checked)
		{
			LookUpInStockList("GetInStockList","StatCatDR,EquipTypeDR,Equip,StockDR");
		}
		else
		{
			SetOutType();
			LookUpInStockEquip("GetEquip","StatCatDR,EquipTypeDR,Equip,StockStatus,StockDR,'',OutTypeDR");
		}
	}
}
function GetInStockList(value)
{
	list=value.split("^");
	SetElement("Equip",list[0]);
	SetElement("InStockListDR",list[1]);
	SetOtherData(list[1],"1")
}
function GetEquip(value)
{
	list=value.split("^");
	SetElement("Equip",list[0]);
	SetElement("EquipDR",list[1]);
	SetOtherData(list[1],"2")
}
function SetOtherData(RowID,Type)
{
	var RRowID=GetElementValue("ReturnDR")
	var encmeth=GetElementValue("SetOtherData");
	var EquipType=GetElementValue("EquipTypeDR");
	var StatCat=GetElementValue("StatCatDR");
	var Stock=GetElementValue("StockDR");
	var value=cspRunServerMethod(encmeth,RowID,Type,EquipType,StatCat,Stock);
	var list=value.split("^");
	SetElement("Model",list[1]);
	//SetElement("ModelDR",list[0]);
	SetElement("ManuFactory",list[3]);
	//SetElement("ManuFactoryDR",list[2]);
	//SetElement("Unit",list[5]);
	//SetElement("UnitDR",list[4]);
	SetElement("ReturnQtyNum",list[6]);
	SetElement("ReturnFee",list[7]);
	SetElement("InStockListDR",list[8]);
	SetElement("MoveMaxQuantity",list[6]);
}
function GetReturnReason(value)
{
	list=value.split("^");
	SetElement("ReturnReason",list[0]);
	SetElement("ReturnReasonDR",list[1]);
}
function ChangeStatus(Value)
{
	InitPage();
	DisableBElement("BUpdate",!Value);
	DisableBElement("BDelete",!Value);
	DisableBElement("BAdd",Value);
	SetBStatus();
}
function SetBStatus()
{
	var obj=document.getElementById("Status");
	var Type=GetElementValue("Type")
	var Status=obj.value;
	if (Status!="0"||Type=="1")
		{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BAdd",true);
		}
}
function BClose_Click() 
{
	window.close();
}
//更新按钮点击函数
function BUpdate_click()
{
	if (CheckNull()) return;
	var MoveQuantity=GetElementValue("ReturnQtyNum");
	if (MoveQuantity=="")
	{
		MoveQuantity=0;
	}
	else
	{
		MoveQuantity=parseFloat(MoveQuantity);
	}
	var MoveMaxQuantity=GetElementValue("MoveMaxQuantity");
	if (MoveMaxQuantity=="")
	{
		MoveMaxQuantity=0;
	}
	else
	{
		MoveMaxQuantity=parseFloat(MoveMaxQuantity);
	}
	if (MoveMaxQuantity<MoveQuantity)
	{
		alertShow(t["04"]+MoveMaxQuantity);
		return
	}
	var encmeth=GetElementValue("MaxMoveNum");
	var LocID=GetElementValue("StockDR");
	var EquipID=GetElementValue("EquipDR");
	var InStockListID=GetElementValue("InStockListDR");
	var EquipType=GetElementValue("EquipTypeDR");
	var StatCat=GetElementValue("StatCatDR");
	var SourceID=GetElementValue("RowID");
	var Return=cspRunServerMethod(encmeth,LocID,EquipID,InStockListID,EquipType,StatCat,MoveQuantity,"1",SourceID)
	if (Return<0)
	{
		if (Return==-3001||Return==-3002||Return==-3003)
		{
			var truthBeTold = window.confirm(t[Return]);
			if (!truthBeTold) return;
		}
		else
		{
			var Num=-Return
			var truthBeTold = window.confirm(t[-3004]+Num+",继续添加吗");
			if (!truthBeTold) return;
		}
	}
	
	UpdateData("0");
}
//删除按钮点击函数
function BDelete_click()
{
	var truthBeTold = window.confirm(t["03"]);
	if (!truthBeTold) return;
	UpdateData("1");
}
function UpdateData(Type)
{
	var encmeth=GetElementValue("GetUpdate");
	var ValueList=GetValueList();
	var Return=cspRunServerMethod(encmeth,"","",ValueList,Type);
	if (Return>0)
	{
		if (isReturn=="N")
		{
			window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQOutStockListAdd&ReturnDR="+GetElementValue("ReturnDR")+"&RowID="
			parent.frames["DHCEQOutStockList"].location.reload() //href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQReturnList&ReturnDR="+GetElementValue("ReturnDR") //reload();
		}
		else
		{
			window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQReturnListAdd&ReturnDR="+GetElementValue("ReturnDR")+"&RowID="
			parent.frames["DHCEQReturnList"].location.reload() //href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQReturnList&ReturnDR="+GetElementValue("ReturnDR") //reload();
		}
	}
	else
	{
		alertShow(Return+"  "+t["01"]);
	}
}
function GetValueList()
{
	var combindata="";
  	combindata=GetElementValue("RowID") ;
  	combindata=combindata+"^"+GetElementValue("ReturnDR") ;
  	var BatchFlag=GetChkElementValue("BatchFlag");
  	if (BatchFlag=="") BatchFlag=false;
  	combindata=combindata+"^"+BatchFlag ;
  	combindata=combindata+"^"+GetElementValue("InStockListDR") ;
  	combindata=combindata+"^"+GetElementValue("EquipDR") ;
  	combindata=combindata+"^"+GetElementValue("ReturnQtyNum") ;
  	combindata=combindata+"^"+GetElementValue("ReturnFee") ;
  	combindata=combindata+"^"+GetElementValue("InvoiceNo") ;
  	combindata=combindata+"^"+GetElementValue("ReturnReasonDR") ;
  	combindata=combindata+"^"+GetElementValue("Remark") ;
  	return combindata
}
function CheckNull()
{
	var obj=document.getElementById("BatchFlag");
	if (obj&&obj.checked)
	{
		if (CheckItemNull(2,"InStockListDR","设备名称")) return true;
		if (CheckItemNull(2,"ReturnQtyNum","数量")) return true;
		var Num=GetElementValue("ReturnQtyNum")
		if (Num<=0)
		{
			alertShow(t["02"])
			return true
		}
	}
	else
	{
		if (CheckItemNull(1,"Equip","设备名称")) return true;
	}
	return false;
}
function LookUpInStockEquip(jsfunction,paras)
{
	LookUp("","web.DHCEQInStockList:GetEquip",jsfunction,paras);
}
function LookUpInStockList(jsfunction,paras)
{
	LookUp("","web.DHCEQStoreMoveList:GetInStockList",jsfunction,paras);
}

function SetOutType()
{
	var obj=parent.frames["DHCEQOutStock"];
	if (obj) 
	{
		obj=obj.document.getElementById("OutTypeDR");
		if (obj)
		{
			SetElement("OutTypeDR",obj.value);
			//alertShow(obj.value);
		}
	}
	
}

document.body.onload = BodyLoadHandler;
