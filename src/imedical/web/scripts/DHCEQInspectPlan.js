function BodyLoadHandler() 
{	
	InitPage();	
	FillData();
	ChangeBStatus();
	InitUserInfo();
}

function InitPage()
{
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	
	var obj=document.getElementById("BSubmit");
	if (obj) obj.onclick=BSubmit_Click;
	
	var obj=document.getElementById("BCancelSubmit");
	if (obj) obj.onclick=BCancelSubmit_Click;
	
	var obj=document.getElementById("BExecute");
	if (obj) obj.onclick=BExecute_Click;
	
	var obj=document.getElementById("BInspectPlanItem");
	if (obj) obj.onclick=BInspectPlanItem_Click;
	
	KeyUp("Equip^InspectType^ManageLoc^MeasureDept^ManageUser^CycleUnit");
	Muilt_LookUp("Equip^InspectType^ManageLoc^MeasureDept^ManageUser^CycleUnit");
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
	//var sort=22;
	var sort=27;
	SetElement("Name",list[0]);
	SetElement("EquipDR",list[1]);
	SetElement("Equip",list[sort+0]);
	SetElement("CycleNum",list[2]);
	SetElement("CycleUnitDR",list[3]);
	SetElement("CycleUnit",list[sort+1]);
	SetElement("InspectTypeDR",list[4]);
	SetElement("InspectType",list[sort+2]);
	SetElement("PreInspectDate",list[5]);
	SetElement("NextMaintDate",list[6]);
	SetElement("PreWarnDaysNum",list[7]);
	SetElement("ManageLocDR",list[8]);
	SetElement("ManageLoc",list[sort+3]);
	SetElement("ManageUserDR",list[9]);
	SetElement("ManageUser",list[sort+4]);
	SetChkElement("OutInspectFlag",list[10]);
	SetElement("MeasureDeptDR",list[11]);
	SetElement("MeasureDept",list[sort+5]);
	SetChkElement("IsForcedFlag",list[12]);
	SetElement("InspectFee",list[13]);
	SetElement("Status",list[14]);
	SetElement("Remark",list[15]);
	SetElement("AddUserDR",list[16]);
	SetElement("AddUser",list[sort+6]);
	SetElement("AddDate",list[17]);
	SetElement("AddTime",list[18]);
	SetElement("UpdateUserDR",list[19]);
	SetElement("UpdateUser",list[sort+7]);
	SetElement("UpdateDate",list[20]);
	SetElement("UpdateTime",list[21]);
}
function BUpdate_Click() 
{
	var obj=document.getElementById("Name");
	var PlanName=obj.value;
	if (PlanName==""){
		alertShow(t["01"]);
		return;
		}
	var obj=document.getElementById("EquipDR");
	var EquipDR=obj.value;
	if (EquipDR==""){
		alertShow(t["02"]);
		return;
		}
	if (CheckNull()) return;
	var combindata="";
  	combindata=GetElementValue("RowID") ;
  	combindata=combindata+"^"+GetElementValue("Name") ;
  	combindata=combindata+"^"+GetElementValue("EquipDR") ;
  	combindata=combindata+"^"+GetElementValue("CycleNum") ;
  	
  	combindata=combindata+"^"+GetElementValue("CycleUnitDR") ;
  	combindata=combindata+"^"+GetElementValue("InspectTypeDR") ;
  	combindata=combindata+"^"+GetElementValue("PreInspectDate") ;
  	combindata=combindata+"^"+GetElementValue("NextMaintDate") ;
  	combindata=combindata+"^"+GetElementValue("PreWarnDaysNum") ;
  	combindata=combindata+"^"+GetElementValue("ManageLocDR") ;
  	combindata=combindata+"^"+GetElementValue("ManageUserDR") ;
  	
  	combindata=combindata+"^"+GetChkElementValue("OutInspectFlag") ;
  	combindata=combindata+"^"+GetElementValue("MeasureDeptDR") ;
  	combindata=combindata+"^"+GetChkElementValue("IsForcedFlag") ;
  	combindata=combindata+"^"+GetElementValue("InspectFee") ;
  	combindata=combindata+"^"+GetElementValue("Status") ;
  
  	combindata=combindata+"^"+GetElementValue("Remark") ;
  	combindata=combindata+"^"+curUserID ;
  	
  	/*combindata=combindata+"^"+GetElementValue("AddDate") ;
  	combindata=combindata+"^"+GetElementValue("AddTime") ;
  	combindata=combindata+"^"+GetElementValue("UpdateUserDR") ;
  	combindata=combindata+"^"+GetElementValue("UpdateDate") ;
  	combindata=combindata+"^"+GetElementValue("UpdateTime") ;*/
  	var upd=document.getElementById('upd');
	if (upd){var encmeth=upd.value} else {var encmeth=""};
	
	var ReturnValue=cspRunServerMethod(encmeth,"","",combindata);
	var ReturnList=ReturnValue.split("^");
	var sqlco=ReturnList[0]	;
	var RowID=ReturnList[1];
	if (sqlco!='0') {
		alertShow(t["04"]);
	return;	}
    parent.location.href= "dhceqinspectplan.csp?TRowID="+RowID+"&EquipDR="+GetElementValue("EquipDR");
}

function BDelete_Click() 
{
	
	var obj=document.getElementById("RowID");
	var RowID=obj.value;
	if (RowID==""){
		alertShow(t["05"]);
		return;
	}
	var truthBeTold = window.confirm(t["11"]);
	
	if (!truthBeTold) return;
	var upd=document.getElementById('del');
	if (upd){var encmeth=upd.value} else {var encmeth=""};
	var sqlco=cspRunServerMethod(encmeth,"","",RowID);
	if (sqlco!='0') {
		alertShow(t["07"]);
	return;	}
	
   parent.location.href= "dhceqinspectplan.csp";
}

function BSubmit_Click() 
{
	SubmitInspectPlan("1");
}

function BCancelSubmit_Click() 
{
	SubmitInspectPlan("0");
}
//提交反提交
function SubmitInspectPlan(Val)
{
	var obj=document.getElementById("RowID");
	var RowID=obj.value;
	if (RowID==""){
		alertShow(t["08"]);
		return;
	}
	var upd=document.getElementById('submit');
	if (upd){var encmeth=upd.value} else {var encmeth=""};
	var sqlco=cspRunServerMethod(encmeth,"","",RowID,Val);
	if (sqlco!='0') {
		alertShow(t["09"]);
	return;	}
	parent.location.href= "dhceqinspectplan.csp?TRowID="+RowID+"&EquipDR="+GetElementValue("EquipDR");;
}
function BExecute_Click() 
{
	var obj=document.getElementById("RowID");
	var RowID=obj.value;
	
	if (RowID==""){
		alertShow(t["12"]);
		return;
	}
	var obj=document.getElementById("Status");
	var Status=obj.value;
	if (Status!="1"){
		alertShow(t["13"]);
		return;
	}
	var upd=document.getElementById('CheckInspect');
	if (upd){var encmeth=upd.value} else {var encmeth=""};
	var sqlco=cspRunServerMethod(encmeth,"","",RowID)
	if (sqlco==0){
		alertShow(t["15"]);
		return
		}
	var upd=document.getElementById('execute');
	if (upd){var encmeth=upd.value} else {var encmeth=""};
	var User=curUserID ;
	var ReturnValue=cspRunServerMethod(encmeth,"","",RowID,User)
	var ReturnList=ReturnValue.split("^");
	var sqlco=ReturnList[0];
	var IRowID=ReturnList[1];
	if (sqlco!='0') {
		alertShow(t["14"]+" "+sqlco+" "+IRowID);
		return;	}
	var lnk= "dhceqinspect.csp?RowID="+IRowID+"&EquipDR="+GetElementValue("EquipDR");
	parent.location.href=lnk;
}
function CheckNull()
{
	if (CheckMustItemNull()) return true;
	if (CheckItemNull(1,"CycleUnit","周期单位")) return true;
	/*
	if (CheckItemNull(1,"Equip")) return true;
	if (CheckItemNull(2,"Name")) return true;
	if (CheckItemNull(1,"InspectType")) return true;
	if (CheckItemNull(2,"CycleNum")) return true;
	if (CheckItemNull(1,"CycleUnit","周期单位")) return true;
	if (CheckItemNull(2,"PreWarnDaysNum")) return true;
	*/
	return false;
}
function BInspectPlanItem_Click() 
{
	var InspectPlanDR=document.getElementById("RowID").value; 
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInspectPlanItem&InspectPlanDR='+InspectPlanDR;
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=700,height=500,left=320,top=0');
}
function GetEquip(value) {
	var user=value.split("^");
	var obj=document.getElementById("EquipDR");
	obj.value=user[1];
	parent.frames["DHCEQBanner"].location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBanner&RowIDB='+user[1];
}
function GetInspectType(value) {
	var user=value.split("^");
	var obj=document.getElementById("InspectTypeDR");
	obj.value=user[1];
}
function GetManageLoc(value) {
	var user=value.split("^");
	var obj=document.getElementById("ManageLocDR");
	obj.value=user[1];
}
function GetMeasureDept(value) {
	var user=value.split("^");
	var obj=document.getElementById("MeasureDeptDR");
	obj.value=user[1];
}
function GetCycleUnit(value) {
	var user=value.split("^");
	var obj=document.getElementById("CycleUnitDR");
	obj.value=user[1];
}
function GetManageUser(value) {
	var user=value.split("^");
	var obj=document.getElementById("ManageUserDR");
	obj.value=user[1];
}
function ChangeBStatus()
{
	var obj=document.getElementById("Status");
	var Status=obj.value;
	if (Status=="1")
		{ChangeStatus(true);}
	else
		{ChangeStatus(false);}
}
function ChangeStatus(Value)
{
	DisableBElement("BUpdate",Value);
	DisableBElement("BDelete",Value);
	DisableBElement("BSubmit",Value);
	DisableBElement("BCancelSubmit",!Value);
	DisableBElement("BExecute",!Value);
}

document.body.onload = BodyLoadHandler;
