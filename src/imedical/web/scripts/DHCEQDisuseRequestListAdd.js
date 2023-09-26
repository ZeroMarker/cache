
function BodyLoadHandler() 
{
	InitUserInfo();
	InitPage();	
	FillData();
	SetBStatus();
}

function FillData()
{
	var RowID=GetElementValue("RowID");
	if (RowID=="") return;
	var encmeth=GetElementValue("GetData");
	var Value=cspRunServerMethod(encmeth,"","",RowID);
	var list=Value.split("^");
	var sort=13;
	SetElement("DisuseRequestDR",list[0]);
	SetElement("EquipDR",list[1]);
	SetElement("EquipName",list[sort+1]);
	SetElement("EquipNo",list[sort+2]);
	SetElement("InStockDate",list[sort+3]);
	
	SetElement("UseState",list[2]);
	SetElement("DisuseTypeDR",list[3]);
	SetElement("DisuseType",list[sort+4]);
	SetElement("ChangeReason",list[4]);
	SetElement("DisureDate",list[5]);
	SetElement("Remark",list[6]);
	SetElement("UpdateUserDR",list[7]);
	SetElement("UpdateDate",list[8]);
	SetElement("UpdateTime",list[9]);
	SetElement("Hold1",list[10]);
	SetElement("Hold2",list[11]);
	SetElement("Hold3",list[12]);
}

function InitPage()
{
	Muilt_LookUp("EquipName");
	var obj=document.getElementById("EquipName");
	if (obj) obj.onchange=EquipName_Change;
	var BAobj=document.getElementById("BAdd");
	if (BAobj) BAobj.onclick=BAdd_click;
	var BUobj=document.getElementById("BUpdate");
	if (BUobj) BUobj.onclick=BUpdate_click;
	var BDobj=document.getElementById("BDelete");
	if (BDobj) BDobj.onclick=BDelete_click;
}

function SetEquipInfo(value)
{
	if (value&&value!="")
	{
		var obj=document.getElementById("EquipDR");
		var val=value.split("^");	
		if (obj) obj.value=val[1];

		var equipid=GetElementValue("EquipDR");
		if (equipid=="") return;
		var encmeth=GetElementValue("GetEquip");
		if (encmeth=="")	{
			alertShow('GetEquip is null');
			return;
		}
		var gbldata=cspRunServerMethod(encmeth,'','',equipid);
		var list=gbldata.split("^");
		var sort=EquipGlobalLen;
		SetElement("EquipName",list[0]);
		SetElement("EquipNo",list[70]);
		SetElement("InStockDate",list[sort+32]);
	}
}


function EquipName_Change()
{
	SetElement("EquipDR","");
	SetElement("EquipNo","");
	SetElement("InStockDate","");
}

function ValueClear()
{
	SetElement("EquipDR","");
	SetElement("Equip","");
	SetElement("EquipNo","");
	SetElement("InStockDate","");
	
	SetElement("UseState","");
	SetElement("ChangeReason","");
	SetElement("Remark","");
}

function SetBStatus()
{
	var obj=document.getElementById("Status");
	var Type=GetElementValue("Type")
	var Status=obj.value;
	DisableElement("BUpdate",true);
	DisableElement("BDelete",true);
	DisableElement("BAdd",true);		
	if (Status=="0"&&Type=="0")
	{
		var RowID=GetElementValue("RowID");
		if (RowID=="")
		{	DisableElement("BAdd",false);		}
		else
		{	DisableElement("BUpdate",false);
			DisableElement("BDelete",false);	
		}		
	}
}

function BClose_Click() 
{
	window.close();
}

//更新按钮点击函数
function BUpdate_click()
{
	var eSrc=window.event.srcElement;
	if (eSrc.disabled) return;
	if (CheckNull()) return;
	UpdateData("1");
}

//删除按钮点击函数
function BDelete_click()
{
	var eSrc=window.event.srcElement;
	if (eSrc.disabled) return;
	var truthBeTold = window.confirm(t["03"]);
	if (!truthBeTold) return;
	UpdateData("2");
}

function UpdateData(Type)
{
	var encmeth=GetElementValue("GetUpdate");
	var ValueList=GetValueList();
	var Return=cspRunServerMethod(encmeth,"","",ValueList,Type);
	if (Return==0)
	{
		parent.frames["DHCEQDisuseRequestList"].location.reload();
		window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQDisuseRequestListAdd&DisuseRequestDR="+GetElementValue("DisuseRequestDR")+"&RowID="+"&RequestLocDR="+GetElementValue("RequestLocDR")+"&Status="+GetElementValue("Status")+"&Type="+GetElementValue("Type");
		 //href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQReturnList&ReturnDR="+GetElementValue("ReturnDR") //reload();
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
  	combindata=combindata+"^"+GetElementValue("DisuseRequestDR") ;
  	combindata=combindata+"^"+GetElementValue("EquipDR") ;
  	combindata=combindata+"^"+GetElementValue("UseState") ;
  	combindata=combindata+"^"+GetElementValue("DisuseTypeDR") ;
  	combindata=combindata+"^"+GetElementValue("ChangeReason") ;
  	combindata=combindata+"^"+GetElementValue("DisureDate") ;
  	combindata=combindata+"^"+GetElementValue("Remark") ;
  	combindata=combindata+"^^^" ;
  	combindata=combindata+"^"+GetElementValue("Hold1") ;
  	combindata=combindata+"^"+GetElementValue("Hold2") ;
  	combindata=combindata+"^"+GetElementValue("Hold3") ;
  	return combindata
}

function CheckNull()
{
	if (CheckMustItemNull()) return true;
	return false;	
}

//Creator:Mozy
//CreatDate:2009-02-24
//增加按钮点击函数
function BAdd_click()
{
	var eSrc=window.event.srcElement;
	if (eSrc.disabled) return;
	if (CheckNull()) return;
	UpdateData("0");
}

document.body.onload = BodyLoadHandler;
