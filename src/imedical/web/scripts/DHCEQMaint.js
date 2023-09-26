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
	
	var obj=document.getElementById("BMaintItem");
	if (obj) obj.onclick=BMaintItem_Click;
	
	var obj=document.getElementById("BMaintpart");
	if (obj) obj.onclick=BMaintPart_Click;
	
	KeyUp("Equip^MaintType^MaintMode^ManageLoc^UseLoc^MaintLoc^MaintUser");
	Muilt_LookUp("Equip^MaintType^MaintMode^ManageLoc^UseLoc^MaintLoc^MaintUser");
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
	///var sort=24;
	var sort=29;
	SetElement("EquipDR",list[0]);
	SetElement("Equip",list[sort+0]);
	SetElement("MaintRequestDR",list[1]);
	SetElement("MaintRequest",list[sort+1]);
	SetElement("MaintPlanDR",list[2]);
	if (list[2]!="")
	{
		DisableLookup("Equip",true);
		DisableLookup("MaintType",true);
		DisableLookup("MaintMode",true);
	}
	SetElement("MaintPlan",list[sort+2]);
	SetElement("MaintTypeDR",list[3]);
	SetElement("MaintType",list[sort+3]);
	SetElement("MaintDate",list[4]);
	SetElement("MaintLocDR",list[5]);
	SetElement("MaintLoc",list[sort+4]);
	SetElement("MaintUserDR",list[6]);
	SetElement("MaintUser",list[sort+5]);
	SetElement("MaintModeDR",list[7]);
	//SetMaintFeeStatus("Total",GetFeeType(list[7]));
	SetElement("MaintMode",list[sort+6]);
	SetElement("Total",list[8]);
	SetElement("InputFlag",list[9]);
	SetElement("ManageLocDR",list[10]);
	SetElement("ManageLoc",list[sort+7]);
	SetElement("UseLocDR",list[11]);
	SetElement("UseLoc",list[sort+8]);
	SetElement("Status",list[12]);
	SetElement("Remark",list[13]);
	SetElement("OtherFee",list[23])
	/*SetElement("AddUserDR",list[14]);
	SetElement("AddUser",list[sort+9]);
	SetElement("AddDate",list[15]);
	SetElement("AddTime",list[16]);
	SetElement("UpdateUserDR",list[17]);
	SetElement("UpdateUser",list[sort+10]);
	SetElement("UpdateDate",list[18]);
	SetElement("UpdateTime",list[19]);
	SetElement("SubmitUserDR",list[20]);
	SetElement("SubmitUser",list[sort+11]);
	SetElement("SubmitDate",list[21]);
	SetElement("SubmitTime",list[22]);*/
}
function BUpdate_Click() 
{
	if (CheckNull()) return;
	var combindata="";
  	combindata=GetElementValue("RowID") ;
  	combindata=combindata+"^"+GetElementValue("EquipDR") ;
  	combindata=combindata+"^"+GetElementValue("MaintRequestDR") ;
  	combindata=combindata+"^"+GetElementValue("MaintPlanDR") ;
  	combindata=combindata+"^"+GetElementValue("MaintTypeDR") ;
  	combindata=combindata+"^"+GetElementValue("MaintDate") ;
  	combindata=combindata+"^"+GetElementValue("MaintLocDR") ;
  	combindata=combindata+"^"+GetElementValue("MaintUserDR") ;
  	combindata=combindata+"^"+GetElementValue("MaintModeDR") ;
  	combindata=combindata+"^"+GetElementValue("Total") ;
  	combindata=combindata+"^"+GetElementValue("InputFlag") ;
  	combindata=combindata+"^"+GetElementValue("ManageLocDR") ;
  	combindata=combindata+"^"+GetElementValue("UseLocDR") ;
  	combindata=combindata+"^"+GetElementValue("Status") ;//+"新增" //
  	combindata=combindata+"^"+GetElementValue("Remark") ;
  	/*combindata=combindata+"^"+GetElementValue("AddUserDR") ;
  	combindata=combindata+"^"+GetElementValue("AddDate") ;
  	combindata=combindata+"^"+GetElementValue("AddTime") ;
  	combindata=combindata+"^"+GetElementValue("UpdateUserDR") ;
  	combindata=combindata+"^"+GetElementValue("UpdateDate") ;
  	combindata=combindata+"^"+GetElementValue("UpdateTime") ;
  	combindata=combindata+"^"+GetElementValue("SubmitUserDR") ;
  	combindata=combindata+"^"+GetElementValue("SubmitDate") ;
  	combindata=combindata+"^"+GetElementValue("SubmitTime") ;*/
  	combindata=combindata+"^"+curUserID ;
  	combindata=combindata+"^"+GetElementValue("OtherFee");
  	var upd=document.getElementById('upd');
	if (upd){var encmeth=upd.value} else {var encmeth=""};
	var ReturnValue=cspRunServerMethod(encmeth,"","",combindata);
	var ReturnList=ReturnValue.split("^");
	var sqlco=ReturnList[0]	
	var RowID=ReturnList[1]
	if (sqlco!='0') {
		alertShow(t["04"]);
	return;	}
   parent.location.href= "dhceqmaint.csp?RowID="+RowID+"&EquipDR="+GetElementValue("EquipDR");
}

function BDelete_Click() 
{
	
	var obj=document.getElementById("RowID");
	var RowID=obj.value;
	if (RowID==""){
		alertShow(t["05"]);
		return;
	}
	var truthBeTold = window.confirm(t["10"]);
	
	if (!truthBeTold) return;
	var upd=document.getElementById('del');
	if (upd){var encmeth=upd.value} else {var encmeth=""};
	var sqlco=cspRunServerMethod(encmeth,"","",RowID);
	if (sqlco!='0') {
		alertShow(t["07"]);
	return;	}
	
    parent.location.href= "dhceqmaint.csp";
}

function BSubmit_Click() 
{
	var IRowID=document.getElementById('RowID').value;
	if (IRowID==""){
		alertShow(t["06"]);
		return;
	}
	var Status=document.getElementById('Status').value;
	if (Status=="1"){
		alertShow(t["09"]);
		return;
	}
	var MaintPlanDR=document.getElementById('MaintPlanDR').value;
	var MaintDate=document.getElementById('MaintDate').value;
	if (MaintDate==""){
		alertShow(t["11"]);//
		return;
		}
	var obj=document.getElementById('submit')
	if (obj) {var encmeth=obj.value} else {var encmeth=""};
	var User=curUserID
	var sqlco=cspRunServerMethod(encmeth,"","",IRowID,"1",MaintPlanDR,MaintDate,User)
	 if (sqlco!='0') {
		alertShow(sqlco+"  "+t["04"]);
	return;	}
    parent.location.href= "dhceqmaint.csp?RowID="+IRowID+"&EquipDR="+GetElementValue("EquipDR");
}

function BCancelSubmit_Click() 
{
	SubmitMaintPlan("0");
}
//提交反提交
function SubmitMaintPlan(Val)
{
	var obj=document.getElementById("RowID");
	var RowID=obj.value;
	if (RowID==""){
		alertShow(t["08"]);
		return;
	}
	var upd=document.getElementById('submit');
	if (upd){var encmeth=upd.value} else {var encmeth=""};
	var sqlco=cspRunServerMethod(encmeth,"","",RowID,Val)
	if (sqlco!='0') {
		alertShow(t["09"]);
	return;	}
	try {		   
	    //alertShow(t["10"]);
	    window.location.reload();
		}  catch(e) {};
}
function BMaintItem_Click() 
{
	var MaintDR=document.getElementById("RowID").value; 
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMaintItem&MaintDR='+MaintDR;
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=600,height=400,left=320,top=0');
}
function CheckNull()
{
	if (CheckMustItemNull()) return true;
	/*
	if (CheckItemNull(1,"Equip")) return true;
	if (CheckItemNull(1,"MaintLoc")) return true;
	if (CheckItemNull(1,"MaintType")) return true;
	if (CheckItemNull(1,"MaintMode")) return true;
	if (CheckItemNull(2,"MaintDate")) return true;
	*/
	return false;
} 
function BMaintPart_Click() 
{
	var MaintDR=document.getElementById("RowID").value; 
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMaintpart&MaintDR='+MaintDR;
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
	//SetMaintFeeStatus("Total",GetFeeType(user[1]));
}
function GetManageLoc(value) {
	var user=value.split("^");
	var obj=document.getElementById("ManageLocDR");
	obj.value=user[1];
}
function GetUseLoc(value) {
	var user=value.split("^");
	var obj=document.getElementById("UseLocDR");
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
}
document.body.onload = BodyLoadHandler;
