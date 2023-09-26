
/// -------------------------------
/// 修改:ZY  2009-07-06  BugNo.ZY0007
/// 修改描述:增加函数MovType
/// 作用描述:修改设备转移类型的时候?给供给科室和接受科室传递不同的科室类型参数
/// --------------------------------
function BodyLoadHandler() 
{
	document.body.scroll="no";
	KeyUp("FromLoc^ToLoc^Reciver^EquipType^StatCat");
	InitUserInfo();
	SetElement("FromLocType",1);
	SetElement("ToLocType","");
	InitPage();
	SetElement("MoveType","0")
	FillData();
	SetEnabled();
	Muilt_LookUp("FromLoc^ToLoc^Reciver^EquipType^StatCat");
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
		DisableBElement("BOutAudit",true);
		DisableBElement("BCancelSubmit",true);
		DisableBElement("BInAudit",true);
		DisableBElement("BClear",true);
		DisableBElement("BBAudit",true);
		return;
	}
	if (Status=="0")
	{
		DisableBElement("BOutAudit",true);
		DisableBElement("BCancelSubmit",true);
		//DisableLookup("RejectReason",true)
		DisableBElement("BInAudit",true);
		DisableBElement("BBAudit",true);
	}
	if (Status=="1")
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BInAudit",true);
		if (GetElementValue("BillAckStep")==1)
		{
			DisableBElement("BBAudit",true);
		}
		else
		{
			DisableBElement("BOutAudit",true);
		}
	}
	if (Status=="2")
	{
		///DisableBElement("BInAudit",true);
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BCancelSubmit",true);
		DisableBElement("BOutAudit",true);
		DisableBElement("BSubmit",true);
		if (GetElementValue("BillAckStep")==1)
		{
			DisableBElement("BInAudit",true);
		}
		else
		{
			DisableBElement("BBAudit",true);
		}
		//DisableLookup("RejectReason",true)
	}
	if (Status=="3")
	{
		DisableBElement("BInAudit",true);
		DisableBElement("BBAudit",true);
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BCancelSubmit",true);
		DisableBElement("BOutAudit",true);
		DisableBElement("BSubmit",true);
		//DisableLookup("RejectReason",true)
	}
	if (Status=="9")
	{
		DisableBElement("BBAudit",true);
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		//DisableBElement("BOutAudit",true);
		DisableBElement("BSubmit",true);
		if (GetElementValue("BillAckStep")==1)
		{
			DisableBElement("BOutAudit",true);
			DisableBElement("BCancelSubmit",true);
		}
		else
		{
			DisableBElement("BInAudit",true);			
		}
		//DisableLookup("RejectReason",true)
	}
	if (Status=="")
	{
		DisableBElement("BInAudit",true);
		DisableBElement("BDelete",true);
		DisableBElement("BCancelSubmit",true);
		DisableBElement("BOutAudit",true);
		DisableBElement("BSubmit",true);
		//DisableLookup("RejectReason",true)
		DisableBElement("BBAudit",true);
	}
	if (Status!="3")
	{
		DisableBElement("BPrintBar",true);
	}
	var BElementEnableVal=GetElementValue("ElementEnableVal");
	///alertShow(BElementEnableVal);
	BElementEnableByVal(BElementEnableVal);
	////alertShow('b');
	if (Type!="0") DisableBElement("BClear",true);
	if (Type=="0") DisableBElement("BCancelSubmit",true);	
	/*
	if (Type=="0")
	{
		DisableBElement("BInAudit",true);
		DisableBElement("BOutAudit",true);
		DisableBElement("BCancelSubmit",true);
	}
	if (Type=="1")
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BInAudit",true);
	}
	if (Type!="1")
	{
		DisableLookup("Reciver",true)
	}
	else
	{
		DisableLookup("Reciver",false)
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
	//var sort=17;
	var sort=23;
	SetElement("StoreMoveNo",list[0]);
	SetElement("FromLocDR",list[1]);
	SetElement("FromLoc",list[sort+0]);
	SetElement("ToLocDR",list[2]);
	SetElement("ToLoc",list[sort+1]);
	SetElement("MakerDR",list[3]);
	SetElement("Maker",list[sort+2]);
	SetElement("MakeDate",list[4]);
	SetElement("AckUserDR",list[5]);
	SetElement("AckUser",list[sort+3]);
	SetElement("AckDate",list[6]);
	SetElement("AckTime",list[7]);
	SetElement("InAckUserDR",list[8]);
	SetElement("InAckUser",list[sort+4]);
	SetElement("InAckDate",list[9]);
	SetElement("InAckTime",list[10]);
	SetElement("MoveType",list[11]);
	SetElement("Status",list[12]);
	SetElement("Remark",list[13]);
	SetElement("ReciverDR",list[14]);
	SetElement("Reciver",list[sort+5]);
	SetElement("EquipTypeDR",list[15]);
	SetElement("EquipType",list[sort+6]);
	SetElement("StatCatDR",list[16]);
	SetElement("StatCat",list[sort+7]);
}

function InitPage()
{
	var obj=document.getElementById("BInAudit"); //账物审核
	if (obj) obj.onclick=BInAudit_Click;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Clicked;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Clicked;
	var obj=document.getElementById("BCancelSubmit"); //反提交
	if (obj) obj.onclick=BCancelSubmit_Clicked;
	var obj=document.getElementById("BOutAudit");
	if (obj) obj.onclick=BOutAudit_Clicked;
	var obj=document.getElementById("BSubmit");
	if (obj) obj.onclick=BSubmit_Clicked;
	var obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_Clicked;
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_Clicked;
	var obj=document.getElementById("BPrintBar");
	if (obj) obj.onclick=BPrintBar_Clicked;
	
	var obj=document.getElementById("BBAudit");
	if (obj) obj.onclick=BBAudit_Clicked;
	///zy 2009-07-15 BugNo.ZY0007
	var obj=document.getElementById("MoveType");
	if (obj) obj.onchange=MoveType;
	////////////////////
}
function BClear_Clicked()
{
	var ElementEnableVal=GetElementValue("ElementEnableVal");
	parent.location.href="dhceqstoremove.csp?Type=0&ElementEnableVal="+ElementEnableVal+"&QXType="+GetElementValue("QXType");
}
function BDelete_Clicked()
{
	var truthBeTold = window.confirm(t["02"]);
	if (!truthBeTold) return;
	var RowID=GetElementValue("RowID")
	var Return=UpdateStoreMove(RowID,"4");
	if (Return>0)
    {
	    var ElementEnableVal=GetElementValue("ElementEnableVal");
		parent.location.href="dhceqstoremove.csp?Type=0&ElementEnableVal="+ElementEnableVal+"&QXType="+GetElementValue("QXType");
	}
    else
    {
	    alertShow(Return+"   "+t["01"]);
    }
}

function BPrint_Clicked()
{
	var id=GetElementValue("RowID")
	if (""!=id) PrintStoreMove(id);
}

function BCancelSubmit_Clicked() 
{
	var combindata=GetValueList();
	var Return=UpdateStoreMove(combindata,"5");
    if (Return>0)
    {
	    //parent.DHCEQStoreMoveListAdd.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQStoreMoveListAdd&StoreMoveDR="+GetElementValue("RowID")
	    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQStoreMove&RowID='+Return+"&Type="+GetElementValue("Type")+"&ElementEnableVal="+GetElementValue("ElementEnableVal")+"&QXType="+GetElementValue("QXType");
	}
    else
    {
	    alertShow(Return+"   "+t["01"]);
    }
}
function BSubmit_Clicked()
{
	//add by jdl 2009-06-05 JDL0015
	if (CheckNull()) return;
	var Return=StoreMoveListIsVaild();
	if (Return!=0)
	{
		alertShow(Return);
		return;
	}
	var combindata=GetValueList();
	var Return=UpdateStoreMove(combindata,"1");
	if (Return>0)
    {
	    parent.DHCEQStoreMoveListAdd.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQStoreMoveListAdd&StoreMoveDR="+GetElementValue("RowID")
	    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQStoreMove&RowID='+Return+"&Type="+GetElementValue("Type")+"&ElementEnableVal="+GetElementValue("ElementEnableVal")+"&QXType="+GetElementValue("QXType");
	}
    else
    {
	    alertShow(Return+"   "+t["01"]);
    }
}
function BOutAudit_Clicked()
{
	//if (CheckItemNull(1,"Reciver")) return true;
	var Return=StoreMoveListIsVaild();
	if (Return!=0)
	{
		alertShow(Return);
		return;
	}
	var combindata=GetValueList();
	var Return=UpdateStoreMove(combindata,"2");
    if (Return>0)
    {
	    //parent.DHCEQStoreMoveListAdd.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQStoreMoveListAdd&StoreMoveDR="+GetElementValue("RowID")
	    window.location.reload() //= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQStoreMove&RowID='+Return+"&Type="+GetElementValue("Type")
	}
    else
    {
	    alertShow(Return+"   "+t["01"]);
    }
}

function BBAudit_Clicked()
{
	var combindata=GetValueList();
	var Return=UpdateStoreMove(combindata,"9");
    if (Return>0)
    {
	    //parent.DHCEQStoreMoveListAdd.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQStoreMoveListAdd&StoreMoveDR="+GetElementValue("RowID")
	    window.location.reload() //= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQStoreMove&RowID='+Return+"&Type="+GetElementValue("Type")
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
    var Return=UpdateStoreMove(combindata,"0");
    if (Return>0)
    {
	    parent.DHCEQStoreMoveList.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQStoreMoveList&StoreMoveDR="+Return;
	    parent.DHCEQStoreMoveListAdd.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQStoreMoveListAdd&StoreMoveDR="+Return;
	    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQStoreMove&RowID='+Return+"&Type="+GetElementValue("Type")+"&ElementEnableVal="+GetElementValue("ElementEnableVal")+"&QXType="+GetElementValue("QXType");
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
  	combindata=combindata+"^"+GetElementValue("StoreMoveNo") ;
  	combindata=combindata+"^"+GetElementValue("FromLocDR") ;
  	combindata=combindata+"^"+GetElementValue("ToLocDR") ;
  	combindata=combindata+"^"+GetElementValue("MakerDR") ;
  	combindata=combindata+"^"+GetElementValue("MakeDate") ;
  	combindata=combindata+"^"+GetElementValue("AckUserDR") ;
  	combindata=combindata+"^"+GetElementValue("AckDate") ;
  	combindata=combindata+"^"+GetElementValue("AckTime") ;
  	combindata=combindata+"^"+GetElementValue("InAckUserDR") ;
  	combindata=combindata+"^"+GetElementValue("InAckDate") ;
  	combindata=combindata+"^"+GetElementValue("InAckTime") ;
  	combindata=combindata+"^"+GetElementValue("MoveType") ;
  	combindata=combindata+"^"+GetElementValue("Status") ;
  	combindata=combindata+"^"+GetElementValue("Remark") ;
	combindata=combindata+"^"+curUserID;
	combindata=combindata+"^"+GetElementValue("ReciverDR") ;
	combindata=combindata+"^"+GetElementValue("EquipTypeDR") ;
  	combindata=combindata+"^"+GetElementValue("StatCatDR") ;
	return combindata
}
function StoreMoveListIsVaild()
{
	var RowID=GetElementValue("RowID");
	var encmeth=GetElementValue("StoreMoveListIsVaild");
	var ReturnValue=cspRunServerMethod(encmeth,RowID);
	return ReturnValue;
}
function BInAudit_Click() 
{
	var combindata=GetValueList();
	var Return=UpdateStoreMove(combindata,"3");
	if (Return>0)
    {
	    //parent.DHCEQStoreMoveListAdd.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQStoreMoveListAdd&StoreMoveDR="+GetElementValue("RowID")
	    window.location.reload() //href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQStoreMove&RowID='+Return+"&Type="+GetElementValue("Type")
	}
    else
    {
	    alertShow(Return+"   "+t["01"]);
    }
}


function UpdateStoreMove(ValueList,AppType)
{
	var encmeth=GetElementValue("upd")
	var ReturnValue=cspRunServerMethod(encmeth,ValueList,AppType);
	return ReturnValue;
}
function CheckNull()
{
	if (CheckMustItemNull()) return true;
	/*
	if (CheckItemNull(2,"StoreMoveNo")) return true;
	if (CheckItemNull(1,"FromLoc")) return true;
	if (CheckItemNull(1,"ToLoc")) return true;
	if (CheckItemNull(2,"MoveType")) return true;
	if (CheckItemNull(1,"EquipType")) return true;
	if (CheckItemNull(1,"StatCat")) return true;
	*/
	return false;
}
function GetFromLoc (value)
{
    GetLookUpID("FromLocDR",value);
}
function GetToLoc (value)
{
    GetLookUpID("ToLocDR",value);
}
function GetReciver (value)
{
    GetLookUpID("ReciverDR",value);
}
function GetStatCat (value)
{
    GetLookUpID("StatCatDR",value);
}
function GetEquipType (value)
{
    GetLookUpID("EquipTypeDR",value);
}

function BPrintBar_Clicked()
{
	DHCEQStoreMovePrintBar()
}
/// 创建:zy 2009-07-15 BugNo.ZY0007
/// 创建函数?MoveType
/// 描述:修改设备转移类型的时候?给供给科室和接受科室传递不同的科室类型参数
/// -------------------------------
function MoveType()
{
	var value=GetElementValue("MoveType")
	if (value==0)
	{
		SetElement("FromLocType",1);
		SetElement("ToLocType","");
	}else if (value==3)
	{
		SetElement("FromLocType","");
		SetElement("ToLocType",1);
	}else
	{
		SetElement("FromLocType","");
		SetElement("ToLocType","");
	}
}
//////////

document.body.onload = BodyLoadHandler;

