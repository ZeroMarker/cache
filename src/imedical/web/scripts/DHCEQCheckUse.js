
function BodyLoadHandler() 
{
	InitPage();
	FillData();
	SetEnabled();
	KeyUp("UseLoc^DepreMethod");
	Muilt_LookUp("Equip^UseLoc^DepreMethod");
	InitUserInfo();
}
function SetEnabled()
{
	var Status=GetElementValue("Status")
	if (Status=="0")
	{
		DisableBElement("BAudit",true);
	}
	if (Status=="1")
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
	}
	if (Status=="2")
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BAudit",true);
	}
	if (Status=="")
	{
		DisableBElement("BCheckItem",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BAudit",true);
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
	var ReturnList=cspRunServerMethod(encmeth,"","",RowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	list=ReturnList.split("^");
	var sort=19;
	SetElement("EquipDR",list[0]);
	SetElement("Equip",list[sort+0]);
	SetElement("UseDate",list[1]);
	SetElement("OriginalFee",list[2]);
	SetElement("NetRemainFee",list[3]);
	SetElement("LimitYearsNum",list[4]);
	SetElement("UseLocDR",list[5]);
	SetElement("UseLoc",list[sort+1]);
	SetElement("Status",list[6]);
	SetElement("Remark",list[7]);
	SetElement("DepreMethodDR",list[8]);
	SetElement("DepreMethod",list[sort+2]);
	SetElement("TransAssetDate",list[9]);
	/*SetElement("AddUserDR",list[10]);
	SetElement("AddUser",list[sort+3]);
	SetElement("AddDate",list[11]);
	SetElement("AddTime",list[12]);
	SetElement("UpdateUserDR",list[13]);
	SetElement("UpdateUser",list[sort+4]);
	SetElement("UpdateDate",list[14]);
	SetElement("UpdateTime",list[15]);
	SetElement("AuditUserDR",list[16]);
	SetElement("AuditUser",list[sort+5]);
	SetElement("AuditDate",list[17]);
	SetElement("AuditTime",list[18]);*/
}

function InitPage()
{
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Clicked;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Clicked;
	var obj=document.getElementById("BSubmit");
	if (obj) obj.onclick=BSubmit_Clicked;
	var obj=document.getElementById("BAudit");
	if (obj) obj.onclick=BAudit_Clicked;
	var obj=document.getElementById("Equip");
	if (obj) obj.onchange=ValueClear;
		
}
function BDelete_Clicked()
{
	var truthBeTold = window.confirm(t["02"]);
	if (!truthBeTold) return;
	var Return=UpdateCheckUse("","3");
	if (Return=="")
    {
	    parent.frames["DHCEQCheckUse"].location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCheckUse&RowID='+Return
	    parent.frames["DHCEQBanner"].location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBanner&RowIDB='+"";
	}
    else
    {
	    alertShow(Return+"   "+t["01"]);
    }
}
function BSubmit_Clicked()
{
	var Return=UpdateCheckUse("","1");
    if (Return>0)
    {
	    parent.frames["DHCEQCheckUse"].location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCheckUse&RowID='+Return
	}
    else
    {
	    alertShow(Return+"   "+t["01"]);
    }
}
function BAudit_Clicked()
{
	var combindata="";
	combindata=GetElementValue("UseDate") ;
	combindata=combindata+"^"+GetElementValue("UseLocDR") ;
	combindata=combindata+"^"+GetElementValue("LimitYearsNum") ;
	combindata=combindata+"^"+GetElementValue("OriginalFee") ;
	combindata=combindata+"^"+GetElementValue("NetRemainFee") ;
	combindata=combindata+"^"+GetElementValue("DepreMethodDR") ;
	combindata=combindata+"^"+GetElementValue("TransAssetDate") ;
	var Return=UpdateCheckUse(combindata,"2");
    if (Return>0)
    {
	    parent.frames["DHCEQCheckUse"].location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCheckUse&RowID='+Return
	    parent.frames["DHCEQBanner"].location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBanner&RowIDB='+GetElementValue("EquipDR");
	}
    else
    {
	    alertShow(Return+"   "+t["01"]);
    }
}
function BUpdate_Clicked()
{
	if (CheckNull()) return;
	var combindata="";
  	combindata=GetElementValue("RowID") ;
  	combindata=combindata+"^"+GetElementValue("EquipDR") ;
  	combindata=combindata+"^"+GetElementValue("UseDate") ;
  	combindata=combindata+"^"+GetElementValue("OriginalFee") ;
  	combindata=combindata+"^"+GetElementValue("NetRemainFee") ;
  	combindata=combindata+"^"+GetElementValue("LimitYearsNum") ;
  	combindata=combindata+"^"+GetElementValue("UseLocDR") ;
  	combindata=combindata+"^"+GetElementValue("Status") ;
  	combindata=combindata+"^"+GetElementValue("Remark") ;
  	combindata=combindata+"^"+GetElementValue("DepreMethodDR") ;
  	combindata=combindata+"^"+GetElementValue("TransAssetDate") ;
  	/*combindata=combindata+"^"+GetElementValue("AddUserDR") ;
  	combindata=combindata+"^"+GetElementValue("AddDate") ;
  	combindata=combindata+"^"+GetElementValue("AddTime") ;
  	combindata=combindata+"^"+GetElementValue("UpdateUserDR") ;
  	combindata=combindata+"^"+GetElementValue("UpdateDate") ;
  	combindata=combindata+"^"+GetElementValue("UpdateTime") ;
  	combindata=combindata+"^"+GetElementValue("AuditUserDR") ;
  	combindata=combindata+"^"+GetElementValue("AuditDate") ;
  	combindata=combindata+"^"+GetElementValue("AuditTime") ;*/
    var Return=UpdateCheckUse(combindata,"0");
    if (Return>0)
    {
	   	//add by HHM 20150910 HHM0013
		//添加操作成功是否提示
		ShowMessage();
		//**************************** 
	    parent.frames["DHCEQCheckUse"].location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCheckUse&RowID='+Return
	}
    else
    {
	    alertShow(Return+"   "+t["01"]);
    }
}

function UpdateCheckUse(ValueList,AppType)
{
	var RowID=GetElementValue("RowID");
	var encmeth=GetElementValue("upd");
	var EquipDR=GetElementValue("EquipDR");
	var user=curUserID;
	var ReturnValue=cspRunServerMethod(encmeth,"","",ValueList,AppType,RowID,EquipDR,user);
	return ReturnValue;
}
function CheckNull()
{
	if (CheckMustItemNull()) return true;
	/*
	if (CheckItemNull(1,"Equip")) return true;
	if (CheckItemNull(2,"UseDate")) return true;
	if (CheckItemNull(1,"UseLoc")) return true;
	*/
	return false;
}
function ValueClear()
{
	var obj=document.getElementById("EquipDR");
	obj.value="";
	parent.frames["DHCEQBanner"].location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBanner&RowIDB='+"";
}

function GetEquip (value)
{
    var user=value.split("^");
	var obj=document.getElementById('EquipDR');
	obj.value=user[1];
	parent.frames["DHCEQBanner"].location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBanner&RowIDB='+user[1];
}
function GetUseLoc (value)
{
    GetLookUpID("UseLocDR",value);
}
function GetDepreMethod (value)
{
    GetLookUpID("DepreMethodDR",value);
}
document.body.onload = BodyLoadHandler;

