
function BodyLoadHandler() 
{
	InitPage();
	FillData();
	SetEnabled();
	KeyUp("Module^Function^Type^BringUser^SolveUser^DutyUser^Custorm^CloseUser");
	Muilt_LookUp("Module^Function^Type^BringUser^SolveUser^DutyUser^Custorm^CloseUser");
	InitUserInfo();
}
function SetEnabled()
{
	var Status=GetElementValue("Status");
	if (Status=="0")
	{
		DisableBElement("BAccept",true);
		DisableBElement("BSolve",true);
		DisableBElement("BClose",true);
		DisableLookup("SolveReason",true);
		DisableLookup("SolveMethod",true);
		DisableLookup("CloseUser",true);
	}
	if (Status=="1")
	{
		DisableBElement("BAdd",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSolve",true);
		DisableBElement("BClose",true);
		DisableLookup("SolveReason",true);
		DisableLookup("SolveMethod",true);
		DisableLookup("CloseUser",true);
		DisableLookup("Module",true);
		DisableLookup("Function",true);
		DisableLookup("MatterDesc",true);
		DisableLookup("Type",true);
		DisableLookup("BringUser",true);
		DisableLookup("Custorm",true);
	}
	if (Status=="2")
	{
		DisableBElement("BAdd",true);
		DisableBElement("BDelete",true);
		DisableBElement("BAssign",true);
		DisableBElement("BAccept",true);
		DisableBElement("BClose",true);
		DisableLookup("CloseUser",true);
		DisableLookup("Module",true);
		DisableLookup("Function",true);
		DisableLookup("MatterDesc",true);
		DisableLookup("Type",true);
		DisableLookup("BringUser",true);
		DisableLookup("Custorm",true);
		DisableLookup("DutyUser",true);
		DisableLookup("SolveUser",true);
	}
	if (Status=="3")
	{
		DisableBElement("BAdd",true);
		DisableBElement("BAssign",true);
		DisableBElement("BDelete",true);
		DisableBElement("BAccept",true);
		DisableBElement("BSolve",true);
		DisableLookup("SolveReason",true);
		DisableLookup("SolveMethod",true);
		DisableLookup("Module",true);
		DisableLookup("Function",true);
		DisableLookup("MatterDesc",true);
		DisableLookup("Type",true);
		DisableLookup("BringUser",true);
		DisableLookup("Custorm",true);
		DisableLookup("DutyUser",true);
		DisableLookup("SolveUser",true);
	}
	if (Status=="4")
	{
		DisableBElement("BAdd",true);
		DisableBElement("BAssign",true);
		DisableBElement("BDelete",true);
		DisableBElement("BAccept",true);
		DisableBElement("BSolve",true);
		DisableBElement("BClose",true);
		DisableLookup("SolveReason",true);
		DisableLookup("SolveMethod",true);
		DisableLookup("CloseUser",true);
		DisableLookup("Module",true);
		DisableLookup("Function",true);
		DisableLookup("MatterDesc",true);
		DisableLookup("Type",true);
		DisableLookup("BringUser",true);
		DisableLookup("Custorm",true);
		DisableLookup("DutyUser",true);
		DisableLookup("SolveUser",true);
	}
	if (Status=="")
	{
		DisableBElement("BAssign",true);
		DisableBElement("BDelete",true);
		DisableBElement("BAccept",true);
		DisableBElement("BSolve",true);
		DisableBElement("BClose",true);
		DisableLookup("DutyUser",true);
		DisableLookup("SolveUser",true);
		DisableLookup("SolveReason",true);
		DisableLookup("SolveMethod",true);
		DisableLookup("CloseUser",true);
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
	var sort=22
	SetElement("ModuleDR",list[0]);
	SetElement("Module",list[sort+0]);
	SetElement("FunctionDR",list[1]);
	SetElement("Function",list[sort+1]);
	SetElement("MatterDesc",list[2]);
	SetElement("TypeDR",list[3]);
	SetElement("Type",list[sort+2]);
	SetElement("Status",list[4]);
	SetElement("BringDate",list[5]);
	SetElement("BringTime",list[6]);
	SetElement("BringUserDR",list[7]);
	SetElement("BringUser",list[sort+3]);
	SetElement("SolveDate",list[8]);
	SetElement("SolveTime",list[9]);
	SetElement("SolveUserDR",list[10]);
	SetElement("SolveUser",list[sort+4]);
	SetElement("SolveReason",list[11]);
	SetElement("SolveMethod",list[12]);
	SetElement("CloseUserDR",list[13]);
	SetElement("CloseUser",list[sort+5]);
	SetElement("CloseDate",list[14]);
	SetElement("CloseTime",list[15]);
	SetElement("CustormDR",list[16]);
	SetElement("Custorm",list[sort+6]);
	SetElement("DutyUserDR",list[17]);
	SetElement("DutyUser",list[sort+7]);
	SetElement("AssignDate",list[18]);
	SetElement("AssignTime",list[19]);
	SetElement("AcceptDate",list[20]);
	SetElement("AcceptTime",list[21]);
}

function InitPage()
{
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Clicked;
	var obj=document.getElementById("BAssign");
	if (obj) obj.onclick=BAssign_Clicked;
	var obj=document.getElementById("BAccept");
	if (obj) obj.onclick=BAccept_Clicked;
	var obj=document.getElementById("BSolve");
	if (obj) obj.onclick=BSolve_Clicked;
	var obj=document.getElementById("BClose");
	if (obj) obj.onclick=BClose_Clicked;
}
function BDelete_Clicked()
{
	var truthBeTold = window.confirm(t["02"]);
	if (!truthBeTold) return;
	var Return=UpdateData("6");
	if (Return=="")
    {
	   window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQQMatter&RowID='+Return
	}
    else
    {
	    alertShow(Return+"   "+t["01"]);
    }
}
function BAssign_Clicked()
{
	if (CheckItemNull(1,"DutyUser")) return;
	if (CheckItemNull(1,"SolveUser")) return;
	var Return=UpdateData("1");
    if (Return>0)
    {
	   window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQQMatter&RowID='+Return
	}
    else
    {
	    alertShow(Return+"   "+t["01"]);
    }
}
function BAccept_Clicked()
{
	var Return=UpdateData("2");
    if (Return>0)
    {
	   window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQQMatter&RowID='+Return
	}
    else
    {
	    alertShow(Return+"   "+t["01"]);
    }
}
function BAdd_Click()
{	
	if (CheckItemNull(1,"Module")) return;
	if (CheckItemNull(1,"Function")) return;
	if (CheckItemNull(1,"Type")) return;
	if (CheckItemNull(2,"MatterDesc")) return;
    var Return=UpdateData("0");
    if (Return>0)
    {
	   window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQQMatter&RowID='+Return
	}
    else
    {
	    alertShow(Return+"   "+t["01"]);
    }
}

function BSolve_Clicked() 
{
	if (CheckItemNull(2,"SolveReason")) return;
	var Return=UpdateData("3");
    if (Return>0)
    {
	   window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQQMatter&RowID='+Return
	}
    else
    {
	    alertShow(Return+"   "+t["01"]);
    }
}
function BClose_Clicked() 
{
	if (CheckItemNull(1,"CloseUser")) return;
	var Return=UpdateData("4");
    if (Return>0)
    {
	   window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQQMatter&RowID='+Return
	}
    else
    {
	    alertShow(Return+"   "+t["01"]);
    }}

function UpdateData(AppType)
{
	var combindata="";
  	combindata=GetElementValue("RowID") ;//1
  	combindata=combindata+"^"+GetElementValue("ModuleDR") ;//2
  	combindata=combindata+"^"+GetElementValue("FunctionDR") ;//3
  	combindata=combindata+"^"+GetElementValue("MatterDesc") ;//4
  	combindata=combindata+"^"+GetElementValue("TypeDR") ;//5
  	combindata=combindata+"^"+GetElementValue("Status") ;//6
  	combindata=combindata+"^"+GetElementValue("BringDate") ;//7
  	combindata=combindata+"^"+GetElementValue("BringTime") ;//8
  	combindata=combindata+"^"+GetElementValue("BringUserDR") ;//9
  	combindata=combindata+"^"+GetElementValue("SolveDate") ;//10
  	combindata=combindata+"^"+GetElementValue("SolveTime") ;//11
  	combindata=combindata+"^"+GetElementValue("SolveUserDR") ;//12
  	combindata=combindata+"^"+GetElementValue("SolveReason") ;//13
  	combindata=combindata+"^"+GetElementValue("SolveMethod") ;//14
  	combindata=combindata+"^"+GetElementValue("CloseUserDR") ;//15
  	combindata=combindata+"^"+GetElementValue("CloseDate") ;//16
  	combindata=combindata+"^"+GetElementValue("CloseTime") ;//17
  	combindata=combindata+"^"+GetElementValue("CustormDR") ;//18
  	combindata=combindata+"^"+GetElementValue("DutyUserDR") ;//19
  	combindata=combindata+"^"+GetElementValue("AssignDate") ;//20
  	combindata=combindata+"^"+GetElementValue("AssignTime") ;//21
  	combindata=combindata+"^"+GetElementValue("AcceptDate") ;//22
  	combindata=combindata+"^"+GetElementValue("AcceptTime") ;//23
  	var encmeth=GetElementValue("upd");
	var ReturnValue=cspRunServerMethod(encmeth,"","",combindata,AppType);
	return ReturnValue;
}

function GetModule (value)
{
    GetLookUpID("ModuleDR",value);
}
function GetFunction (value)
{
    GetLookUpID("FunctionDR",value);
}
function GetType (value)
{
    GetLookUpID("TypeDR",value);
}
function GetBringUser (value)
{
    GetLookUpID("BringUserDR",value);
}
function GetSolveUser (value)
{
    GetLookUpID("SolveUserDR",value);
}
function GetDutyUser (value)
{
    GetLookUpID("DutyUserDR",value);
}
function GetCustorm (value)
{
    GetLookUpID("CustormDR",value);
}
function GetCloseUser (value)
{
    GetLookUpID("CloseUserDR",value);
}
document.body.onload = BodyLoadHandler;

