function BodyLoadHandler() 
{	InitPage();	
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
	
	var obj=document.getElementById("BMaintPlanItem");
	if (obj) obj.onclick=BMaintPlanItem_Click;
	
	var obj=document.getElementById("BMaintPlanPart");
	if (obj) obj.onclick=BMaintPlanPart_Click;
	
	KeyUp("Equip^MaintType^MaintLoc^CycleUnit^MaintUser");
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
	//var sort=21;
	var sort=26;
	SetElement("Name",list[0]);
	SetElement("EquipDR",list[1]);
	SetElement("Equip",list[sort+0]);
	SetElement("CycleNum",list[2]);
	SetElement("CycleUnitDR",list[3]);
	SetElement("CycleUnit",list[sort+1]);
	SetElement("MaintTypeDR",list[4]);
	SetElement("MaintType",list[sort+2]);
	SetElement("PreMaintDate",list[5]);
	SetElement("NextMaintDate",list[6]);
	SetElement("PreWarnDaysNum",list[7]);
	SetElement("MaintFee",list[8]);
	SetElement("MaintLocDR",list[9]);
	SetElement("MaintLoc",list[sort+3]);
	SetElement("MaintUserDR",list[10]);
	SetElement("MaintUser",list[sort+4]);
	SetElement("MaintModeDR",list[11]);
	//SetMaintFeeStatus("MaintFee",GetFeeType(list[11]));
	SetElement("MaintMode",list[sort+5]);
	SetElement("Remark",list[12]);
	SetElement("Status",list[13]);
	SetElement("OtherFee",list[20]);
	/*
	SetElement("AddUserDR",list[14]);
	SetElement("AddUser",list[sort+6]);
	SetElement("AddDate",list[15]);
	SetElement("AddTime",list[16]);
	SetElement("UpdateUserDR",list[17]);
	SetElement("UpdateUser",list[sort+7]);
	SetElement("UpdateDate",list[18]);
	SetElement("UpdateTime",list[19]);*/
}
function BUpdate_Click() 
{
	if (CheckNull()) return;
	var combindata="";
  	combindata=GetElementValue("RowID") ;
  	combindata=combindata+"^"+GetElementValue("Name") ;
  	combindata=combindata+"^"+GetElementValue("EquipDR") ;
  	combindata=combindata+"^"+GetElementValue("CycleNum") ;
  	combindata=combindata+"^"+GetElementValue("CycleUnitDR") ;
  	combindata=combindata+"^"+GetElementValue("MaintTypeDR") ;
  	combindata=combindata+"^"+GetElementValue("PreMaintDate") ;
  	combindata=combindata+"^"+GetElementValue("NextMaintDate") ;
  	combindata=combindata+"^"+GetElementValue("PreWarnDaysNum") ;
  	combindata=combindata+"^"+GetElementValue("MaintFee") ;
  	combindata=combindata+"^"+GetElementValue("MaintLocDR") ;
  	combindata=combindata+"^"+GetElementValue("MaintUserDR") ;
  	combindata=combindata+"^"+GetElementValue("MaintModeDR") ;
 	combindata=combindata+"^"+GetElementValue("Remark") ;
  	combindata=combindata+"^"+GetElementValue("Status") ;
  	/*combindata=combindata+"^"+GetElementValue("AddUserDR") ;
  	combindata=combindata+"^"+GetElementValue("AddDate") ;
  	combindata=combindata+"^"+GetElementValue("AddTime") ;
  	combindata=combindata+"^"+GetElementValue("UpdateUserDR") ;
  	combindata=combindata+"^"+GetElementValue("UpdateDate") ;
  	combindata=combindata+"^"+GetElementValue("UpdateTime") ;*/
  	combindata=combindata+"^"+curUserID ;
  	combindata=combindata+"^"+GetElementValue("OtherFee") ;
  	var upd=document.getElementById('upd');
	if (upd){var encmeth=upd.value} else {var encmeth=""};
	var ReturnValue=cspRunServerMethod(encmeth,"","",combindata);
	var ReturnList=ReturnValue.split("^");
	var sqlco=ReturnList[0]	
	var RowID=ReturnList[1]
	if (sqlco!='0') {
		alertShow(t["04"]);
	return;	}
   parent.location.href= "dhceqmaintplan.csp?RowID="+RowID+"&EquipDR="+GetElementValue("EquipDR");
}

function BDelete_Click() 
{
	var obj=document.getElementById("RowID");
	var RowID=obj.value;
	if (RowID==""){
		alertShow(t["05"])
		return
	}
	var truthBeTold = window.confirm(t["11"]);
	
	if (!truthBeTold) return;
	var upd=document.getElementById('del');
	if (upd){var encmeth=upd.value} else {var encmeth=""};
	var sqlco=cspRunServerMethod(encmeth,"","",RowID)
	//alertShow(sqlco)
	if (sqlco!='0') {
		alertShow(t["07"]);
	return;	}
	
    parent.location.href= "dhceqmaintplan.csp";
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
		alertShow(t["08"])
		return
	}
	var upd=document.getElementById('submit');
	if (upd){var encmeth=upd.value} else {var encmeth=""};
	var sqlco=cspRunServerMethod(encmeth,"","",RowID,Val);
	if (sqlco!='0') {
		alertShow(t["09"]);
	return;	}
	parent.location.href= "dhceqmaintplan.csp?RowID="+RowID+"&EquipDR="+GetElementValue("EquipDR");
}
function BExecute_Click() 
{	var obj=document.getElementById("RowID");
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
	var upd=document.getElementById('checkmaint');
	if (upd){var encmeth=upd.value} else {var encmeth=""};
	var sqlco=cspRunServerMethod(encmeth,"","",RowID);
	if (sqlco==0){
		alertShow(t["15"]);
		return;
		}
	var upd=document.getElementById('execute');
	if (upd){var encmeth=upd.value} else {var encmeth=""};
	var User=curUserID ;
	var ReturnValue=cspRunServerMethod(encmeth,"","",RowID,User);
	var ReturnList=ReturnValue.split("^");
	var sqlco=ReturnList[0];
	var IRowID=ReturnList[1];
	if (sqlco!='0') {
		alertShow(t["14"]+" "+sqlco);
		return;	}
	var lnk= "dhceqmaint.csp?RowID="+IRowID+"&EquipDR="+GetElementValue("EquipDR");
	parent.location.href=lnk;
}
function CheckNull()
{
	if (CheckMustItemNull()) return true;
	if (CheckItemNull(1,"CycleUnit","周期单位")) return true;
	/*
	if (CheckItemNull(1,"Equip")) return true;
	if (CheckItemNull(1,"MaintLoc")) return true;
	if (CheckItemNull(1,"MaintType")) return true;
	if (CheckItemNull(1,"MaintMode")) return true;
	if (CheckItemNull(2,"Name")) return true;
	if (CheckItemNull(2,"CycleNum")) return true;
	if (CheckItemNull(1,"CycleUnit","周期单位")) return true;
	if (CheckItemNull(2,"PreWarnDaysNum")) return true;
	*/
	return false;
} 
function BMaintPlanItem_Click() 
{
	var MaintPlanDR=document.getElementById("RowID").value; 
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMaintPlanItem&MaintPlanDR='+MaintPlanDR;
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=600,height=400,left=320,top=0');
}

function BMaintPlanPart_Click() 
{
	var MaintPlanDR=document.getElementById("RowID").value; 
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMaintPlanpart&MaintPlanDR='+MaintPlanDR;
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=600,height=400,left=320,top=0');
}

function GetEquip(value) {
	var user=value.split("^");
	var obj=document.getElementById("EquipDR");
	obj.value=user[1];
	parent.frames["DHCEQBanner"].location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBanner&RowIDB='+user[1];
}

function GetMaintType(value) {
	var user=value.split("^");
	var obj=document.getElementById("MaintTypeDR");
	obj.value=user[1];
}

function GetMaintLoc(value) {
	var user=value.split("^");
	var obj=document.getElementById("MaintLocDR");
	obj.value=user[1];
}

function GetMaintMode(value) {
	var user=value.split("^");
	var obj=document.getElementById("MaintModeDR");
	obj.value=user[1];
	//SetMaintFeeStatus("MaintFee",GetFeeType(user[1]));
}

function GetCycleUnit(value) {
	var user=value.split("^");
	var obj=document.getElementById("CycleUnitDR");
	obj.value=user[1];
}

function GetMaintUser(value) {
	var user=value.split("^");
	var obj=document.getElementById("MaintUserDR");
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
