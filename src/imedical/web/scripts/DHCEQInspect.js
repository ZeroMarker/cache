function BodyLoadHandler() {
	FillData();
	InitPage();
	ChangeBStatus();
	InitUserInfo();
}
function InitPage(){

	var BAobj=document.getElementById("BAudit");
	if (BAobj) BAobj.onclick=BAduit_click;
	
	var BUobj=document.getElementById("BUpdate");
	if (BUobj) BUobj.onclick=BUpdate_click;
	
	var BDobj=document.getElementById("BDelete");
	if (BDobj) BDobj.onclick=BDelete_click;
	
	var obj=document.getElementById("BInspectItem");
	if (obj) obj.onclick=BInspectItem_Click;
	
	KeyUp("ManageLoc^ManageUser^UseLoc^InspectType^MeasureDept^Result")
	Muilt_LookUp("ManageLoc^ManageUser^UseLoc^InspectType^MeasureDept^Result");
}
function FillDataApp(ReturnList){
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	if (ReturnList==""){
		var ValueList=["","","","","","","","","","","","","","","","","","","","","","",""]
	
	}
	else{
		var ValueList=ReturnList.split("^");
	}
	var obj=document.getElementById("RowID");
	if (obj) obj.value=ValueList[20];
	var obj=document.getElementById("EquipDR");
	if (obj) obj.value=ValueList[0];
	var obj=document.getElementById("Equip");
	if (obj) obj.value=ValueList[1];
	var obj=document.getElementById("InspectPlanDR");
	if (obj) obj.value=ValueList[2];
	if (ValueList[2]!="")
	{
		DisableLookup("Equip",true);
		DisableLookup("InspectType",true);
	}
	var obj=document.getElementById("InspectTypeDR");
	if (obj) obj.value=ValueList[3];
	var obj=document.getElementById("InspectType");
	if (obj) obj.value=ValueList[4];
	var obj=document.getElementById("InspectDate");
	if (obj) obj.value=ValueList[5];
	var obj=document.getElementById("ManageLocDR");
	if (obj) obj.value=ValueList[6];
	var obj=document.getElementById("ManageLoc");
	if (obj) obj.value=ValueList[7];
	var obj=document.getElementById("ManageUserDR");
	if (obj) obj.value=ValueList[8];
	var obj=document.getElementById("ManageUser");
	if (obj) obj.value=ValueList[9];
	var obj=document.getElementById("UseLocDR");
	if (obj) obj.value=ValueList[10];
	var obj=document.getElementById("UseLoc");
	if (obj) obj.value=ValueList[11];
	var obj=document.getElementById("MeasureDeptDR");
	if (obj) obj.value=ValueList[12];
	var obj=document.getElementById("MeasureDept");
	if (obj) obj.value=ValueList[13];
	var obj=document.getElementById("InspectUsers");
	if (obj) obj.value=ValueList[14];
	var obj=document.getElementById("InspectFee");
	if (obj) obj.value=ValueList[15];
	var obj=document.getElementById("Result");
	if (obj) obj.value=ValueList[16];
	var obj=document.getElementById("ResultDR");
	if (obj) obj.value=ValueList[20];
	var obj=document.getElementById("Remark");
	if (obj) obj.value=ValueList[19];
	var obj=document.getElementById("Status");
	if (obj) obj.value=ValueList[18];
	var obj=document.getElementById("IsForcedFlag");
	if (ValueList[17]=="Y"){
		obj.checked=true;
	}
	else{
		obj.checked=false;
	}
	var obj=document.getElementById("IsOutInspectFlag");
	if (ValueList[22]=="Y"){
		obj.checked=true;
	}
	else{
		obj.checked=false;
	}
}
function FillData(){
	var obj=document.getElementById("RowID");
	var ArgValue=obj.value;
	if (ArgValue==""){
		return;
	}
	var obj=document.getElementById("fillinfo");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var ReturnList=cspRunServerMethod(encmeth,"","",ArgValue)
	FillDataApp(ReturnList)

}
function BAduit_click(){
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
	var InspectPlanDR=document.getElementById('InspectPlanDR').value;
	var InspectDate=document.getElementById('InspectDate').value;
	if (InspectDate==""){
		alertShow(t["11"]);
		return;
		}
	var IEquipID=document.getElementById("EquipDR").value;
	var obj=document.getElementById('aud');
	if (obj) {var encmeth=obj.value;} else {var encmeth="";}
	var User=curUserID;
	var sqlco=cspRunServerMethod(encmeth,"","",IRowID,"1",InspectPlanDR,InspectDate,User);
	 if (sqlco!='0') {
		alertShow(t["04"]);
	return;	}
    parent.location.href= "dhceqinspect.csp?RowID="+IRowID+"&EquipDR="+IEquipID;
}
function BUpdate_click(){
	if (CheckNull()) return;
	var IRowID=document.getElementById('RowID').value;
	var IEquipID=document.getElementById('EquipDR').value;
	var ValueList=""
	ValueList+=IEquipID+"^";
	var IInspectPlanID=document.getElementById('InspectPlanDR').value;
	ValueList+=IInspectPlanID+"^";
	
	var IInspectTypeID=document.getElementById('InspectTypeDR').value;
	ValueList+=IInspectTypeID+"^";
	var IInspectDate=document.getElementById('InspectDate').value;
	ValueList+=IInspectDate+"^";
	var IManageLocID=document.getElementById('ManageLocDR').value;
	ValueList+=IManageLocID+"^";
	var IManageUserID=document.getElementById('ManageUserDR').value;
	ValueList+=IManageUserID+"^";
	var IUseLocID=document.getElementById('UseLocDR').value;
	ValueList+=IUseLocID+"^";
	var IMeaSureDeptID=document.getElementById('MeasureDeptDR').value;
	ValueList+=IMeaSureDeptID+"^";
	var IInspectUsers=document.getElementById('InspectUsers').value;
	ValueList+=IInspectUsers+"^";
	
	var IInspectFee=document.getElementById('InspectFee').value;
	ValueList+=IInspectFee+"^";
		
	var IResult=document.getElementById('ResultDR').value;
	ValueList+=IResult+"^";

	var IIsForcedFlag=document.getElementById('IsForcedFlag').checked;
	if (IIsForcedFlag){
		IIsForcedFlag="Y";
	}
	else{
		IIsForcedFlag="N";
	}
	ValueList+=IIsForcedFlag+"^";
	var IRemark=document.getElementById('Remark').value;
	ValueList+=IRemark+"^";
	var IIsOutInspectFlag=document.getElementById('IsOutInspectFlag').checked;
	if (IIsOutInspectFlag){
		IIsOutInspectFlag="Y";
	}
	else{
		IIsOutInspectFlag="N";
	}
	ValueList+=IIsOutInspectFlag+"^";
	var IUser=curUserID;
	ValueList+=IUser;
	var upd=document.getElementById('upd');
	if (upd){var encmeth=upd.value} else {var encmeth=""};
	var ReturnValue=cspRunServerMethod(encmeth,"","",IRowID,ValueList);
	var ReturnList=ReturnValue.split("^");
	var sqlco=ReturnList[0];
	var IRowID=ReturnList[1];
	if (sqlco!='0') {
		alertShow(t["04"]);
	return;	}
    parent.location.href= "dhceqinspect.csp?RowID="+IRowID+"&EquipDR="+IEquipID;
}
function BDelete_click(){	
	var IRowID=document.getElementById('RowID').value;
	if (IRowID==""){
		alertShow(t['05']);
		return;
	}
	var truthBeTold = window.confirm(t["10"]);
	
	if (!truthBeTold) return;
	
	var del=document.getElementById('del');
	if (del){var encmeth=del.value} else {var encmeth=""};
	var sqlco=cspRunServerMethod(encmeth,"","",IRowID)//,IInspectDate,IMangeLocID,IMangeUserID,IUseLocID,IMeasureDeptID,IInspectUsers,IInspectFee,IInspectResult,IIsForcedFlag,IRemark,IUserID)
	
	if (sqlco!='0') {
		alertShow(t["08"]);
	return;	}
	parent.location.href= "dhceqinspect.csp";
	
}
function BInspectItem_Click() 
{
	var InspectDR=document.getElementById("RowID").value; 
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInspectItem&InspectDR='+InspectDR;
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=600,height=400,left=320,top=0');
}
function CheckNull()
{
	if (CheckMustItemNull()) return true;
	/*
	if (CheckItemNull(1,"Equip")) return true;
	if (CheckItemNull(2,"InspectDate")) return true;
	if (CheckItemNull(1,"InspectType")) return true;
	*/
	return false;
}
function GetUserID(value)	{
	
	var user=value.split("^");
	var obj=document.getElementById('UseLocDR');
	obj.value=user[1];
}
function GetManageUser(value)	{
	
	var user=value.split("^");
	var obj=document.getElementById('ManageUserDR');
	obj.value=user[1];
}
function GetInspectType(value)	{
	var user=value.split("^");
	var obj=document.getElementById('InspectTypeDR');
	obj.value=user[1];
}
function GetMeasureDept(value)	{
	var user=value.split("^");//其中user数组顺序与cls中query对应的返回值顺序一致
	var obj=document.getElementById('MeasureDeptDR');
	obj.value=user[1];
}
function GetUseLoc(value)	{
	var user=value.split("^");//其中user数组顺序与cls中query对应的返回值顺序一致
	var obj=document.getElementById('UseLocDR');
	obj.value=user[1];
}
function GetManageLoc(value)	{
	var user=value.split("^");//其中user数组顺序与cls中query对应的返回值顺序一致
	var obj=document.getElementById('ManageLocDR');
	obj.value=user[1];
}
function GetResult(value)	{
	var user=value.split("^");//其中user数组顺序与cls中query对应的返回值顺序一致
	var obj=document.getElementById('ResultDR');
	obj.value=user[1];
}

function GetEquip(value)	{
	var user=value.split("^");
	var obj=document.getElementById('EquipDR');
	obj.value=user[1];
	parent.frames["DHCEQBanner"].location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBanner&RowIDB='+user[1];
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
	DisableBElement("BAudit",Value);
}

document.body.onload = BodyLoadHandler;