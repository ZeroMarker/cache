

function BodyLoadHandler() 
{
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
	var encmeth=GetElementValue("fillData");
	var Value=cspRunServerMethod(encmeth,RowID)
	var list=Value.split("^")
	var sort=11
	SetElement("StoreMoveDR",list[0]);
	SetElement("StoreMove",list[sort+0]);
	SetElement("EquipDR",list[1]);
	//SetElement("Equip",list[sort+1]);
	SetChkElement("BatchFlag",list[2]);
	SetElement("InStockListDR",list[3]);
	//SetElement("InStockList",list[sort+2]);
	SetElement("Equip",list[4]);
	SetElement("ManuFactoryDR",list[5]);
	SetElement("ManuFactory",list[sort+3]);
	SetElement("OriginalFee",list[6]);
	SetElement("QuantityNum",list[7]);
	SetElement("ModelDR",list[8]);
	SetElement("Model",list[sort+4]);
	SetElement("UnitDR",list[9]);
	SetElement("Unit",list[sort+5]);
	SetElement("Remark",list[10]);
	SetElement("MoveMaxQuantity",list[sort+6]);
	if (list[2]=="1")
	{
		//DisableElement("Model",false);
		//DisableElement("ManuFactory",false);
		//DisableElement("Unit",false);
		DisableElement("QuantityNum",false);
		//DisableElement("OriginalFee",false);
	}
	ChangeStatus(true);
}
function InitPage()
{
	var obj=document.getElementById("Equip");
	if (obj) obj.onkeydown=Equip_KeyDown;
	var obj=document.getElementById("Model");
	if (obj) obj.onkeydown=Model_KeyDown;
	var obj=document.getElementById("ManuFactory");
	if (obj) obj.onkeydown=ManuFactory_KeyDown;
	var obj=document.getElementById("Unit");
	if (obj) obj.onkeydown=Unit_KeyDown;
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
	KeyUp("Model^ManuFactory^Unit");
}
function Equip_Change()
{
	var obj=document.getElementById("BatchFlag");
	if (obj.checked)
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
	if (obj.checked)
	{
		//DisableElement("Model",false);
		//DisableElement("ManuFactory",false);
		//DisableElement("Unit",false);
		DisableElement("QuantityNum",false);
		//DisableElement("OriginalFee",false);
	}
	else
	{
		//DisableElement("Model",true);
		//DisableElement("ManuFactory",true);
		//DisableElement("Unit",true);
		DisableElement("QuantityNum",true);
		//DisableElement("OriginalFee",true);
	}
}
function ValueClear()
{
	SetElement("EquipDR","");
	SetElement("Equip","");
	SetElement("InstockListDR","");
	SetElement("ModelDR","");
	SetElement("Model","");
	SetElement("ManuFactoryDR","");
	SetElement("ManuFactory","");
	SetElement("QuantityNum","");
	SetElement("UnitDR","");
	SetElement("Unit","");
	SetElement("OriginalFee","");
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
function Equip_KeyDown()
{
	if (event.keyCode==13)
	{
		var MoveType=GetElementValue("MoveType");
		var obj=document.getElementById("BatchFlag");
		
		if ((obj.checked)&&(MoveType!=2))
		{
			LookUpInStockList("GetInStockList","StatCatDR,EquipTypeDR,Equip,StockDR");
		}
		else
		{
			if (MoveType==2) SetElement("EQStatus","3");
			LookUpInStockEquip("GetEquip","StatCatDR,EquipTypeDR,Equip,StockStatus,StockDR,'','',EQStatus");
		}
	}
}
function Model_KeyDown()
{
	if (event.keyCode==13)
	{
		LookUpModel("GetModel","ItemDR,Model");
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
	var SMRowID=GetElementValue("StoreMoveDR");
	var encmeth=GetElementValue("SetOtherData");
	var EquipType=GetElementValue("EquipTypeDR");
	var StatCat=GetElementValue("StatCatDR");
	var Stock=GetElementValue("StockDR");
	var value=cspRunServerMethod(encmeth,RowID,Type,EquipType,StatCat,Stock);
	var list=value.split("^");
	SetElement("Model",list[1]);
	SetElement("ModelDR",list[0]);
	SetElement("ManuFactory",list[3]);
	SetElement("ManuFactoryDR",list[2]);
	SetElement("Unit",list[5]);
	SetElement("UnitDR",list[4]);
	SetElement("QuantityNum",list[6]);
	SetElement("OriginalFee",list[7]);
	SetElement("InStockListDR",list[8]);
	SetElement("MoveMaxQuantity",list[6]);
}
function GetUnit(value)
{
	list=value.split("^");
	SetElement("Unit",list[0]);
	SetElement("UnitDR",list[1]);
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
	var MoveQuantity=GetElementValue("QuantityNum");
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
	var Return=cspRunServerMethod(encmeth,LocID,EquipID,InStockListID,EquipType,StatCat,MoveQuantity,"2",SourceID)
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
		window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQStoreMoveListAdd&StoreMoveDR="+GetElementValue("StoreMoveDR")+"&RowID="
		parent.frames["DHCEQStoreMoveList"].location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQStoreMoveList&StoreMoveDR="+GetElementValue("StoreMoveDR") //reload();
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
  	combindata=combindata+"^"+GetElementValue("StoreMoveDR") ;
  	combindata=combindata+"^"+GetElementValue("EquipDR") ;
  	combindata=combindata+"^"+GetChkElementValue("BatchFlag") ;
  	combindata=combindata+"^"+GetElementValue("InStockListDR") ;
  	combindata=combindata+"^"+GetElementValue("Equip") ;
  	combindata=combindata+"^"+GetElementValue("ManuFactoryDR") ;
  	combindata=combindata+"^"+GetElementValue("OriginalFee") ;
  	combindata=combindata+"^"+GetElementValue("QuantityNum") ;
  	combindata=combindata+"^"+GetElementValue("ModelDR") ;
  	combindata=combindata+"^"+GetElementValue("UnitDR") ;
  	combindata=combindata+"^"+GetElementValue("Remark") ;
	return combindata
}
function CheckNull()
{
	var obj=document.getElementById("BatchFlag");
	if (obj.checked)
	{
		//if (CheckItemNull(2,"InStockListDR","入库明细"))
		if (CheckItemNull(2,"InStockListDR","设备名称")) return true;
		//if (CheckItemNull(2,"ModelDR","设备型号")) return true;
		//if (CheckItemNull(2,"ManuFactoryDR","生产厂商")) return true;
		if (CheckItemNull(2,"QuantityNum","数量")) return true;
		var Num=GetElementValue("QuantityNum");
		if (Num<=0)
		{
			alertShow(t["03"]);
			return true;
		}
		//if (CheckItemNull(2,"UnitDR","设备单位")) return true;
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
document.body.onload = BodyLoadHandler;
