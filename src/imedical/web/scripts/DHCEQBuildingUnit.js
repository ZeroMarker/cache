///Created By HZY 2012-10-15

var SelectedRow = 0;
var rowid=0;

function BodyLoadHandler() 
{	
	InitUserInfo();
	if ("1"==GetElementValue("ReadOnly"))
	{
		DisableBElement("BAdd",true);
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BDepreAllot",true);
	}
	DisableElement("Building",true);
	InitButton(false);
	KeyUp("Building^UseLoc^LendType^Purpose^User","N"); 
	Muilt_LookUp("Building^UseLoc^LendType^Purpose^User","N"); 
}

function InitButton(isselected)
{
	var obj=document.getElementById("BClose");
	if (obj) obj.onclick=BClose_Click;
	
	if ("1"==GetElementValue("ReadOnly")) return;
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;	
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;	
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	var obj=document.getElementById("BDepreAllot");
	if (obj) obj.onclick=BDepreAllot_Click;		
	DisableBElement("BAdd",isselected);
	DisableBElement("BUpdate",!isselected);
	DisableBElement("BDelete",!isselected);
}

function Selected(selectrow)
{
	if (SelectedRow==selectrow)	{	
		Clear();	
		SelectedRow=0;
		rowid=0;
		SetElement("RowID","");
		InitButton(false);
		}
	else{
		SelectedRow=selectrow;
		rowid=GetElementValue("TRowIDz"+SelectedRow);
		if (rowid=="") return;
		SetElement("RowID",rowid);
		SetData(rowid);
		InitButton(true);
		}
}

function BAdd_Click() 
{
	SaveData();
}

function BUpdate_Click() 
{
	SaveData();
}

function BDelete_Click() 
{
	rowid=GetElementValue("RowID");
	if (rowid=="")	{
		alertShow(t['-3002']);
		return;
	}
	var truthBeTold = window.confirm(t['-3001']);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return;
	}
	var result=cspRunServerMethod(encmeth,rowid,'1'); 
	if (result>0)
	{	
		location.reload();	
	}
	else{
		alertShow(result);
	}
}

function BClose_Click() 
{
	//window.close();
	CloseWindow();
}

function CombinData()
{
	//RowID^BuildingDR^Desc^Floor^DoorNo^Place^BuildingArea^UtilizationArea^Stuct^UseLocDR^LendTypeDR^
	//Company^ContractPerson^PurposeDR^OriginalFee^RentFee^RentFeeType^BeginDate^EndDate^UserDR^Date^
	//SubmitUserDR^AuditUserDR^Status^Hold1^Hold2^Hold3^Hold4^Hold5
	var combindata="";
  	combindata=GetElementValue("RowID") ;
  	combindata=combindata+"^"+GetElementValue("BuildingDR") ;
  	combindata=combindata+"^"+GetElementValue("Desc") ;
  	combindata=combindata+"^"+GetElementValue("Floor") ;
  	combindata=combindata+"^"+GetElementValue("DoorNo") ;
  	combindata=combindata+"^"+GetElementValue("Place") ;
  	combindata=combindata+"^"+GetElementValue("BuildingArea") ;
  	combindata=combindata+"^"+GetElementValue("UtilizationArea") ;
  	combindata=combindata+"^"+GetElementValue("Stuct") ;
  	combindata=combindata+"^"+GetElementValue("UseLocDR") ;
  	combindata=combindata+"^"+GetElementValue("LendTypeDR") ;
  	combindata=combindata+"^"+GetElementValue("Company") ;
  	combindata=combindata+"^"+GetElementValue("ContractPerson") ;
  	combindata=combindata+"^"+GetElementValue("PurposeDR") ;
	combindata=combindata+"^"+GetElementValue("OriginalFee") ; 
	combindata=combindata+"^"+GetElementValue("RentFee") ; 
	combindata=combindata+"^"+GetElementValue("RentFeeType") ; 
	combindata=combindata+"^"+GetElementValue("BeginDate") ; 
	combindata=combindata+"^"+GetElementValue("EndDate") ; 
	combindata=combindata+"^"+GetElementValue("UserDR") ; 
	combindata=combindata+"^"+GetElementValue("Date") ; 
	combindata=combindata+"^"+GetElementValue("SubmitUserDR") ; 
	combindata=combindata+"^"+GetElementValue("SubmitDate") ; 
	combindata=combindata+"^"+GetElementValue("SubmitTime") ; 
	combindata=combindata+"^"+GetElementValue("AuditUserDR") ; 
	combindata=combindata+"^"+GetElementValue("AuditDate") ; 
	combindata=combindata+"^"+GetElementValue("AuditTime") ; 
	combindata=combindata+"^"+GetElementValue("Status") ; 
	combindata=combindata+"^"+GetElementValue("Hold1") ; 
	combindata=combindata+"^"+GetElementValue("Hold2") ; 
	combindata=combindata+"^"+GetElementValue("Hold3") ; 
	combindata=combindata+"^"+GetElementValue("Hold4") ; 
	combindata=combindata+"^"+GetElementValue("Hold5") ; 

  	return combindata;
}

function SaveData()
{
	if (CheckMustItemNull()) return;
	if (1==JudgeAreaReasonable()) return; //错误,返回.
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return;
	}
	var plist=CombinData();
	//alertShow(plist);
	var result=cspRunServerMethod(encmeth,plist,'0'); 
	if (result>0)
	{	location.reload();	}
	else
	{
		alertShow(t[result]+" SQLCODE="+result);
	}
}

function JudgeAreaReasonable()
{
	var rtn=0;
	var RowID=GetElementValue("RowID");
	var encmeth=GetElementValue("JudgeAreaReasonable");
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return 1;
	}
	var BuildingDR=GetElementValue("BuildingDR") ;
	var BuildingArea=GetElementValue("BuildingArea") ;
	var UtilizationArea=GetElementValue("UtilizationArea") ; 
	if (BuildingArea<=0)
	{
		alertShow("建筑面积设置错误!");
		rtn=1;
	}
	if (UtilizationArea<=0)
	{
		alertShow("使用面积设置错误!");
		rtn=1;
	}
	var result=cspRunServerMethod(encmeth,BuildingDR,RowID,BuildingArea,UtilizationArea); 
	if (""!=result)
	{	
		alertShow(result);
		rtn=1;	
	}
	return rtn;
}

function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return;
	}
	var gbldata=cspRunServerMethod(encmeth,rowid);
	var list=gbldata.split("^");
	//RowID^BuildingDR^Desc^Floor^DoorNo^Place^BuildingArea^UtilizationArea^Stuct^UseLocDR^LendTypeDR^
	//Company^ContractPerson^PurposeDR^OriginalFee^RentFee^RentFeeType^BeginDate^EndDate^UserDR^Date^
	//SubmitUserDR^AuditUserDR^Status^Hold1^Hold2^Hold3^Hold4^Hold5
	var sort=32;
	SetElement("RowID",list[0]);
	SetElement("BuildingDR",list[1]);
	SetElement("Desc",list[2]);
	SetElement("Floor",list[3]);
	SetElement("DoorNo",list[4]);
	SetElement("Place",list[5]);
	SetElement("BuildingArea",list[6]);
	SetElement("UtilizationArea",list[7]);
	SetElement("Stuct",list[8]);
	SetElement("UseLocDR",list[9]);
	SetElement("LendTypeDR",list[10]);
	SetElement("Company",list[11]);
	SetElement("ContractPerson",list[12]);
	SetElement("PurposeDR",list[13]);
	SetElement("OriginalFee",list[14]);
	SetElement("RentFee",list[15]);
	SetElement("RentFeeType",list[16]);
	SetElement("BeginDate",list[17]);
	SetElement("EndDate",list[18]);
	SetElement("UserDR",list[19]);
	SetElement("Date",list[20]);
	SetElement("SubmitUserDR",list[21]); 
	SetElement("SubmitDate",list[22]);
	SetElement("SubmitTime",list[23]);
	SetElement("AuditUserDR",list[24]);
	SetElement("AuditDate",list[25]);
	SetElement("AuditTime",list[26]);
	SetElement("Status",list[27]);
	SetElement("Hold1",list[28]);
	SetElement("Hold2",list[29]);
	SetElement("Hold3",list[30]);
	SetElement("Hold4",list[31]);
	SetElement("Hold5",list[32]);
	SetElement("Building",list[sort+1]);
	SetElement("UseLoc",list[sort+2]);
	SetElement("LendType",list[sort+3]);
	SetElement("Purpose",list[sort+4]);
	SetElement("User",list[sort+5]);
	SetElement("SubmitUser",list[sort+6]);
	SetElement("AuditUser",list[sort+7]);
}

function SelectRowHandler()	
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQBuildingUnit');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	Selected(selectrow);
}

function Clear()
{
	SetElement("RowID","");
	//SetElement("BuildingDR","");
	SetElement("Desc","");
	SetElement("Floor","");
	SetElement("DoorNo","");
	SetElement("Place","");
	SetElement("BuildingArea","");
	SetElement("UtilizationArea","");
	SetElement("Stuct","");
	SetElement("UseLocDR","");
	SetElement("LendTypeDR","");
	SetElement("Company","");
	SetElement("ContractPerson","");
	SetElement("PurposeDR","");
	SetElement("OriginalFee","");
	SetElement("RentFee","");
	SetElement("RentFeeType","");
	SetElement("BeginDate","");
	SetElement("EndDate","");
	SetElement("UserDR","");
	SetElement("Date","");
	SetElement("SubmitUserDR",""); 
	SetElement("SubmitDate","");
	SetElement("SubmitTime","");
	SetElement("AuditUserDR","");
	SetElement("AuditDate","");
	SetElement("AuditTime","");
	SetElement("Status","");
	SetElement("Hold1","");
	SetElement("Hold2","");
	SetElement("Hold3","");
	SetElement("Hold4","");
	SetElement("Hold5","");
	//SetElement("Building","");
	SetElement("UseLoc","");
	SetElement("LendType","");
	SetElement("Purpose","");
	SetElement("User","");
	SetElement("SubmitUser","");
	SetElement("AuditUser","");
}

function GetBuilding (value)
{
    GetLookUpID("BuildingDR",value); 
}
function GetUseLoc (value)
{
    GetLookUpID("UseLocDR",value);
}
function GetLendType (value)
{
    GetLookUpID("LendTypeDR",value);
}
function GetPurpose (value)
{
    GetLookUpID("PurposeDR",value);
}
function GetUser (value)
{
    GetLookUpID("UserDR",value);
}

///分摊折旧设置
function BDepreAllot_Click()
{
	var BuildingDR=GetElementValue("BuildingDR");
	var encmeth=GetElementValue("GetBuildingUnitDepreAllot");
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return;
	}
	var result=cspRunServerMethod(encmeth,BuildingDR);
	if (result>0)
	{	location.reload();	}
	else
	{
		alertShow(t[result]+" SQLCODE="+result);
	}
}

document.body.onload = BodyLoadHandler;
