///Created By HZY 2013-7-15
///房屋改建,扩建
var Component="DHCEQBuildingChange"
function BodyLoadHandler() 
{
	InitUserInfo();
	InitPage();	
	FillData();
	SetEnabled();
	//SetDisplay();	
}

function InitPage()
{
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;	
	var obj=document.getElementById("BSubmit");
	if (obj) obj.onclick=BSubmit_Click;	
	var obj=document.getElementById("BCancelSubmit");
	if (obj) obj.onclick=BCancelSubmit_Click;	
}

function FillData()
{
	var RowID=GetElementValue("RowID");
  	if ((RowID=="")||(RowID==null)) return;
	var encmeth=GetElementValue("fillData");
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,RowID);
	Rtn=Rtn.replace(/\\n/g,"\n");
	list=Rtn.split("^");
	var sort=42;
	SetElement("EquipDR",list[0]);
	SetElement("ChangeType",list[1]);
	SetElement("Equip",list[sort+1]);
	SetElement("ChangeDate",list[sort+2]);
	SetElement("ProjectItem",list[3]);
	SetElement("StartDate",list[sort+3]);
	SetElement("FinishedDate",list[sort+4]);
	SetElement("Company",list[6]);
	SetElement("ProjectFee",list[7]);
	SetElement("CheckDate",list[sort+5]);
	SetElement("CheckUser",list[9]);
	SetElement("FromStructDR",list[10]);
	SetElement("FromStruct",list[sort+6]);
	SetElement("ToStructDR",list[11]);
	SetElement("ToStruct",list[sort+6]);
	SetElement("FromBuildingArea",list[12]);
	SetElement("ToBuildingArea",list[13]);
	SetElement("FromUtilizationArea",list[14]);
	SetElement("ToUtilizationArea",list[15]);
	SetElement("FromSubArea",list[16]);
	SetElement("ToSubArea",list[17]);
	SetElement("FromFloorNum",list[18]);
	SetElement("ToFloorNum",list[19]);
	SetElement("FromUnderFloorNum",list[20]);
	SetElement("ToUnderFloorNum",list[21]);
	SetElement("FromLandArea",list[22]);
	SetElement("ToLandArea",list[23]);
	SetElement("Hold1",list[24]);
	SetElement("Hold2",list[25]);
	SetElement("Hold3",list[26]);
	SetElement("Hold4",list[27]);
	SetElement("Hold5",list[28]);
	SetElement("Status",list[29]);
	SetElement("CreateUserDR",list[30]);
	SetElement("CreateDate",list[31]);
	SetElement("CreateTime",list[32]);
	SetElement("SubmitUserDR",list[33]);
	SetElement("SubmitDate",list[34]);
	SetElement("SubmitTime",list[35]);
	SetElement("AuditUserDR",list[36]);
	SetElement("AuditDate",list[37]);
	SetElement("AuditTime",list[38]);
	SetElement("DropUserDR",list[39]);
	SetElement("DropDate",list[40]);
	SetElement("DropTime",list[41]);
}

function SetEnabled()
{
	var Status=GetElementValue("Status");
	if (Status=="")
	{
		DisableBElement("BCancelSubmit",true);
		DisableBElement("BSubmit",true);
	}
	else if (Status=="0")
	{
		DisableBElement("BCancelSubmit",true);
	}	
	else if (Status=="2")
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BSubmit",true);
	}
	else if (Status=="3")
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BCancelSubmit",true);
	}
}

function GetBuildingChangeList()
{
	var combindata="";	
	combindata=GetElementValue("RowID") ; //1
	combindata=combindata+"^"+GetElementValue("EquipDR") ; //2
	combindata=combindata+"^"+GetElementValue("ChangeType") ; //3
	combindata=combindata+"^"+GetElementValue("ChangeDate") ; //4
	combindata=combindata+"^"+GetElementValue("ProjectItem") ; //5
	combindata=combindata+"^"+GetElementValue("StartDate") ; //6
	combindata=combindata+"^"+GetElementValue("FinishedDate") ; //7
	combindata=combindata+"^"+GetElementValue("Company") ; //8
	combindata=combindata+"^"+GetElementValue("ProjectFee") ; //9
	combindata=combindata+"^"+GetElementValue("CheckDate") ; //10
	combindata=combindata+"^"+GetElementValue("CheckUser") ; //11
	combindata=combindata+"^"+GetElementValue("FromStructDR") ; //12
	combindata=combindata+"^"+GetElementValue("ToStructDR") ; //13
	combindata=combindata+"^"+GetElementValue("FromBuildingArea") ; //14
	combindata=combindata+"^"+GetElementValue("ToBuildingArea") ; //15
	combindata=combindata+"^"+GetElementValue("FromUtilizationArea") ; //16
	combindata=combindata+"^"+GetElementValue("ToUtilizationArea") ; //17
	combindata=combindata+"^"+GetElementValue("FromSubArea") ; //18
	combindata=combindata+"^"+GetElementValue("ToSubArea") ; //19
	combindata=combindata+"^"+GetElementValue("FromFloorNum") ; //20
	combindata=combindata+"^"+GetElementValue("ToFloorNum") ; //21
	combindata=combindata+"^"+GetElementValue("FromUnderFloorNum") ; //22
	combindata=combindata+"^"+GetElementValue("ToUnderFloorNum") ; //23
	combindata=combindata+"^"+GetElementValue("FromLandArea") ; //24
	combindata=combindata+"^"+GetElementValue("ToLandArea") ; //25
	combindata=combindata+"^"+GetElementValue("Hold1") ; //26
	combindata=combindata+"^"+GetElementValue("Hold2") ; //27
	combindata=combindata+"^"+GetElementValue("Hold3") ; //28
	combindata=combindata+"^"+GetElementValue("Hold4") ; //29
	combindata=combindata+"^"+GetElementValue("Hold5") ; //30
	combindata=combindata+"^"+GetElementValue("Status") ; //31
	
	combindata=combindata+"^"+GetElementValue("CreateUserDR") ; //31
	combindata=combindata+"^"+GetElementValue("CreateDate") ; //31
	combindata=combindata+"^"+GetElementValue("CreateTime") ; //31
	combindata=combindata+"^"+GetElementValue("SubmitUserDR") ; //31
	combindata=combindata+"^"+GetElementValue("SubmitDate") ; //31
	combindata=combindata+"^"+GetElementValue("SubmitTime") ; //31
	combindata=combindata+"^"+GetElementValue("AuditUserDR") ; //31
	combindata=combindata+"^"+GetElementValue("AuditDate") ; //31
	combindata=combindata+"^"+GetElementValue("AuditTime") ; //31
	combindata=combindata+"^"+GetElementValue("DropUserDR") ; //31
	combindata=combindata+"^"+GetElementValue("DropDate") ; //31
	combindata=combindata+"^"+GetElementValue("DropTime") ; //31
	combindata=combindata+"^"+curUserID;
	return combindata;
}

function BUpdate_Click() 
{
	SaveData(2);
}

function BSubmit_Click() 
{
	SaveData(3);
}

function BCancelSubmit_Click()
{
	SaveData(1);
}

function SaveData(type)
{
	if (CheckNull()) return;
	if (CheckInvalidData()) return;
	var combindata=GetBuildingChangeList();
	var encmeth=GetElementValue("UpdateData");
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,combindata,type);
	if (Rtn<0) 
	{
		alertShow(t["04"]);
		return;	
	}
	//add by HHM 20150910 HHM0013
	//添加操作成功是否提示
	ShowMessage();
	//****************************	
	window.location.href='websys.default.csp?WEBSYS.TCOMPONENT='+Component+'&RowID='+Rtn;
}

function CheckNull()
{
	if (CheckMustItemNull()) return true;
	return false;
}

function CheckInvalidData()
{
	if (IsValidateNumber(GetElementValue("ProjectFee"),1,1,0,1)==0)
	{
		alertShow("总工程款数据异常,请修正.");
		return true;
	}
	return false;
}

function GetEquip(value) 
{
	//TRowID,TBuildingName,TStructDR,TStruct,TBuildingArea,TUtilizationArea,TSubArea,TFloorNum,TUnderFloorNum
	var list=value.split("^");
	SetElement('EquipDR',list[0]);
	SetElement('Equip',list[1]);
	SetElement('FromStructDR',list[2]);
	SetElement('FromStruct',list[3]);	
	SetElement('FromBuildingArea',list[4]);
	SetElement('FromUtilizationArea',list[5]);
	SetElement('FromSubArea',list[6]);
	SetElement('FromFloorNum',list[7]);
	SetElement('FromUnderFloorNum',list[8]);
}

function GetFromStruct(value)
{
	GetLookUpID("FromStructDR",value);
}

function GetToStruct(value)
{
	GetLookUpID("ToStructDR",value);
}

document.body.onload = BodyLoadHandler;
