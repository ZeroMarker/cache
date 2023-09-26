
function BodyLoadHandler() 
{
	InitPage();
	SetButtonDisabled();
	InitUserInfo();
	FillData();
	SetDisabled();
}
function FillData()
{
	var obj=document.getElementById("RowID");
	if (obj) var RowID=obj.value;
	if (RowID=="") return;
	var obj=document.getElementById("fillData");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var ReturnList=cspRunServerMethod(encmeth,"","",RowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	list=ReturnList.split("^");
	var sort=43;
	SetElement("EquipDR",list[0]);
	SetContratByEquip(list[0]);
	SetElement("Equip",list[sort+0]);
	SetElement("RequestLocDR",list[1]);
	SetElement("RequestLoc",list[sort+1]);
	SetElement("FaultCaseDR",list[2]);
	SetElement("FaultCase",list[sort+2]);
	SetElement("FaultCaseRemark",list[3]);
	SetElement("FaultReasonDR",list[4]);
	SetElement("FaultReason",list[sort+3]);
	SetElement("FaultReasonRemark",list[5]);
	SetElement("DealMethodDR",list[6]);
	SetElement("DealMethod",list[sort+4]);
	SetElement("DealMethodRemark",list[7]);
	SetElement("StartDate",list[8]);
	SetElement("StartTime",list[9]);
	SetElement("EndDate",list[10]);
	SetElement("EndTime",list[11]);
	SetElement("RequestDate",list[12]);
	SetElement("RequestTime",list[13]);
	SetElement("FaultTypeDR",list[14]);
	SetElement("FaultType",list[sort+5]);
	SetElement("AcceptDate",list[15]);
	SetElement("AcceptTime",list[16]);
	SetElement("AcceptUserDR",list[17]);
	SetElement("AcceptUser",list[sort+6]);
	SetElement("AssignDR",list[18]);
	SetElement("Assign",list[sort+7]);
	SetElement("MaintModeDR",list[19]);
	SetElement("MaintMode",list[sort+8]);
	//SetMaintFeeStatus("MaintFee",GetFeeType(list[19]));
	SetChkElement("PayedMaintFlag",list[20]);
	SetElement("MaintFee",list[21]);
	SetElement("UserSignDR",list[22]);
	SetElement("UserSign",list[sort+9]);
	SetElement("UserOpinion",list[23]);
	SetElement("ManageLocDR",list[24]);
	SetElement("ManageLoc",list[sort+10]);
	SetElement("UseLocDR",list[25]);
	SetElement("UseLoc",list[sort+11]);
	SetElement("IsInputFlag",list[26]);
	SetElement("Remark",list[27]);
	switch (list[28]){
		case "0":
			list[28]="新增";
			break;
		case "1":
			list[28]="提交";
			break;
		case "2":
			list[28]="分配";
			break;
		case "3":
			list[28]="受理";
			break;
		case "4":
			list[28]="解决";
	}
	SetElement("Status",list[28]);
	/*SetElement("AddUserDR",list[29]);
	SetElement("AddUser",list[sort+12]);
	SetElement("AddDate",list[30]);
	SetElement("AddTime",list[31]);
	SetElement("UpdateUserDR",list[32]);
	SetElement("UpdateUser",list[sort+13]);
	SetElement("UpdateDate",list[33]);
	SetElement("UpdateTime",list[34]);
	SetElement("SubmitUserDR",list[35]);
	SetElement("SubmitUser",list[sort+14]);
	SetElement("SubmitDate",list[36]);
	SetElement("SubmitTime",list[37]);*/
	SetElement("MaintLocDR",list[38]);
	SetElement("MaintRemark",list[39]);
	SetElement("MaintDept",list[40]);
	SetElement("OtherFee",list[41]);
	SetElement("RequestNO",list[42])
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
	
	var obj=document.getElementById("BAssign");
	if (obj) obj.onclick=BAssign_Click;
	
	var obj=document.getElementById("BDeal");
	if (obj) obj.onclick=BDeal_Click;
	
	var obj=document.getElementById("BSolve");
	if (obj) obj.onclick=BSolve_Click;
	
	var obj=document.getElementById("BSerContract");
	if (obj) obj.onclick=BSerContract_Click;
	
	var obj=document.getElementById("BMaintItem");
	if (obj) obj.onclick=BMaintItem_Click;
	
	var obj=document.getElementById("BMaintPart");
	if (obj) obj.onclick=BMaintPart_Click;
	
	var obj=document.getElementById("Equip")
	if (obj) obj.onchange=Equip_Change;
	KeyUp("UserSign^DealMethod^AcceptUser^FaultCase^FaultReason^FaultType^MaintMode^ManageLoc^RequestLoc^UseLoc","N");
	Muilt_LookUp("UserSign^DealMethod^AcceptUser^FaultCase^FaultReason^FaultType^MaintMode^ManageLoc^RequestLoc^UseLoc");
	
	var obj=document.getElementById("BOuter");
	if (obj) obj.onclick=BOuter_Click;
}

function BOuter_Click()
{
	var RowID=GetElementValue("RowID");
	var encmeth=GetElementValue("GetOuter");
	if ((RowID=="")||(encmeth=="")) return;
	
	var ReturnValue=cspRunServerMethod(encmeth,RowID);
	if (ReturnValue>0)
    {
	    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQOuterMaintRequest&RowID='+ReturnValue+'&Type=0';
	}
    else
    {
	    alertShow(t[ReturnValue]);
    }
}

function Equip_Change()
{
	KeyUp("Equip");
	parent.frames["DHCEQBanner"].location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBanner&RowIDB=';
	SetSerContract("0","","")
}

function BSerContract_Click()
{
	var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQSerContract&EquipDR="+GetElementValue("EquipDR")
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
}

function SetButtonDisabled()
{
	var obj=document.getElementById("Status");
	if (obj) var Status=obj.value;
	if (Status=="新增"){
		DisableBElement("BCancelSubmit",true);
		DisableBElement("BAssign",true);
		DisableBElement("BSolve",true);
		DisableBElement("BDeal",true);
		DisableBElement("BMaintItem",true);
		DisableBElement("BMaintPart",true);
	}
	else if (Status=="提交"){
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BDeal",true);
		DisableBElement("BMaintItem",true);
		DisableBElement("BMaintPart",true);
		DisableBElement("BSolve",true)	;	
	}
	else if (Status=="分配"){
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BCancelSubmit",true);
		DisableBElement("BMaintItem",true);
		DisableBElement("BMaintPart",true);
		DisableBElement("BSolve",true)	;	
	}
	else if (Status=="受理"){
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BCancelSubmit",true);
		DisableBElement("BAssign",true);
		//DisableBElement("BDeal",true)		
	}
	else if (Status=="解决"){
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BCancelSubmit",true);
		DisableBElement("BSolve",true);
		//DisableBElement("BMaintPart",true)
		//DisableBElement("BMaintItem",true)
		DisableBElement("BDeal",true);	
		DisableBElement("BAssign",true)	;
	}
	var Add=GetElementValue("Add")
	if (Add==0){
		DisableBElement("BCancelSubmit",true);
		DisableBElement("BSolve",true);
		DisableBElement("BDeal",true);	
		DisableBElement("BAssign",true)
	}
	DisableBElement("BSerContract",true);
}
function SetDisabled()
{
	var obj=document.getElementById("Status");
	if (obj) var Status=obj.value;
	if (Status=="新增"){
		SetMultDisabled("AcceptUser^AcceptDate^PayedMaintFlag^MaintFee^FaultType^MaintMode^EndDate^FaultReason^FaultReasonRemark^DealMethod^DealMethodRemark^MaintRemark",true);
	}
	//alertShow(Status);
	if (Status!="新增"){
		SetMultDisabled("RequestNO^Equip^ManageLoc^UseLoc^UserSign^RequestLoc^StartDate^RequestDate^FaultCase^FaultCaseRemark^UserOpinion^Remark",true);
		//SetMultDisabled("AcceptUser^AcceptDate^PayedMaintFlag^MaintFee^FaultType^MaintMode^EndDate^FaultReason^FaultReasonRemark^DealMethod^DealMethodRemark^MaintRemark",false)
	}
}
function SetMultDisabled(Val,Value)
{
	var ValList=Val.split("^");
	var i=0;
	for (i=0;i<ValList.length;i++)
	{
		DisableLookup(ValList[i],Value);
	}
}
function BUpdate_Click()
{
	if (CheckItemNull(1,"Equip")) return;
	if (CheckItemNull(1,"RequestLoc")) return;
	if (CheckItemNull(2,"FaultCase")) return;
	if (CheckItemNull(2,"StartDate")) return;
	if (CheckItemNull(2,"RequestDate")) return;
	var Return=Update("0","0");
	if (Return==0) return;
	window.location.href= "websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMaintRequest&RowID="+Return+"&Status=新增"+"&Add="+GetElementValue("Add");
  	
}
function Update(Status,Flag)
{
	var obj=document.getElementById("EquipDR");
	var EquipDR=obj.value
	if (EquipDR==""){
		alertShow(t["02"])
		return 0
		}
	/*
	var obj=document.getElementById("FaultCaseDR");
	var MaintModeDR=obj.value
	if (MaintModeDR==""){
		alertShow(t["01"])
		return 0
		}
	*/
	var combindata="";
  	combindata=GetElementValue("RowID") ;
  	combindata=combindata+"^"+GetElementValue("EquipDR") ;
  	combindata=combindata+"^"+GetElementValue("RequestLocDR") ;
  	combindata=combindata+"^"+GetElementValue("FaultCaseDR") ;
  	combindata=combindata+"^"+GetElementValue("FaultCaseRemark") ;
  	combindata=combindata+"^"+GetElementValue("FaultReasonDR") ;
  	combindata=combindata+"^"+GetElementValue("FaultReasonRemark") ;
  	combindata=combindata+"^"+GetElementValue("DealMethodDR") ;
  	combindata=combindata+"^"+GetElementValue("DealMethodRemark") ;
  	combindata=combindata+"^"+GetElementValue("StartDate") ;
  	combindata=combindata+"^"+GetElementValue("StartTime") ;
  	combindata=combindata+"^"+GetElementValue("EndDate") ;
  	combindata=combindata+"^"+GetElementValue("EndTime") ;
  	combindata=combindata+"^"+GetElementValue("RequestDate") ;
  	combindata=combindata+"^"+GetElementValue("RequestTime") ;
  	combindata=combindata+"^"+GetElementValue("FaultTypeDR") ;
  	combindata=combindata+"^"+GetElementValue("AcceptDate") ;
  	combindata=combindata+"^"+GetElementValue("AcceptTime") ;
  	combindata=combindata+"^"+GetElementValue("AcceptUserDR") ;
  	combindata=combindata+"^"+GetElementValue("AssignDR") ;
  	combindata=combindata+"^"+GetElementValue("MaintModeDR") ;
  	combindata=combindata+"^"+GetChkElementValue("PayedMaintFlag") ;
  	combindata=combindata+"^"+GetElementValue("MaintFee") ;
  	combindata=combindata+"^"+GetElementValue("UserSignDR") ;
  	combindata=combindata+"^"+GetElementValue("UserOpinion") ;
  	combindata=combindata+"^"+GetElementValue("ManageLocDR") ;
  	combindata=combindata+"^"+GetElementValue("UseLocDR") ;
  	combindata=combindata+"^"+"Y" //GetChkElementValue("IsInputFlag") ;
  	combindata=combindata+"^"+GetElementValue("Remark") ;
  	combindata=combindata+"^"+Status //GetElementValue("Status") ;
  	combindata=combindata+"^"+curUserID ;
  	
  	combindata=combindata+"^"+curLocID ;
  	combindata=combindata+"^"+GetElementValue("MaintRemark") ;
  	combindata=combindata+"^"+GetElementValue("MaintDept") ;
  	combindata=combindata+"^"+GetElementValue("OtherFee") ;
  	combindata=combindata+"^"+GetElementValue("RequestNO") ;
  	/*combindata=combindata+"^"+GetElementValue("AddDate") ;
  	combindata=combindata+"^"+GetElementValue("AddTime") ;
  	combindata=combindata+"^"+GetElementValue("UpdateUserDR") ;
  	combindata=combindata+"^"+GetElementValue("UpdateDate") ;
  	combindata=combindata+"^"+GetElementValue("UpdateTime") ;
  	combindata=combindata+"^"+GetElementValue("SubmitUserDR") ;
  	combindata=combindata+"^"+GetElementValue("SubmitDate") ;
  	combindata=combindata+"^"+GetElementValue("SubmitTime") ;*/
  	//2010-03-06 党军 begin
  	combindata=combindata+"^"+GetElementValue("FaultCase") ;
  	combindata=combindata+"^"+GetElementValue("FaultReason") ;
  	combindata=combindata+"^"+GetElementValue("DealMethod") ;
  	//2010-03-06 党军 end
  	var upd=document.getElementById('upd');
	if (upd){var encmeth=upd.value} else {var encmeth=""};
	var ReturnValue=cspRunServerMethod(encmeth,"","",combindata,Flag);
	var ReturnList=ReturnValue.split("^");
	var sqlco=ReturnList[0];
	var RowID=ReturnList[1];
	if (sqlco!='0') {
		alertShow(t["04"]);
	return 0;	}
    return RowID
}
function BDelete_Click()
{
	var obj=document.getElementById("RowID");
	var RowID=obj.value;
	if (RowID==""){
		alertShow(t["05"])
		return
	}
	var truthBeTold = window.confirm(t["10"]);
	
	if (!truthBeTold) return;
	
	var upd=document.getElementById('del');
	if (upd){var encmeth=upd.value} else {var encmeth=""};
	//alertShow(encmeth)
	var sqlco=cspRunServerMethod(encmeth,"","",RowID)
	//alertShow(sqlco+" "+RowID)
	if (sqlco!='0') {
		alertShow(t["07"]);
	return;	}
	
   window.location.href= "websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMaintRequest&RowID="+""+"&Status=新增"+"&Add="+GetElementValue("Add");
}
function BSubmit_Click()
{
	var Return=Submit("1")
	if (Return==0) return
	window.location.href= "websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMaintRequest&RowID="+Return+"&Status=提交"+"&Add="+GetElementValue("Add");
}
function BCancelSubmit_Click()
{
	var Return=Submit("0")
	if (Return==0) return
	window.location.href= "websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMaintRequest&RowID="+Return+"&Status=新增"+"&Add="+GetElementValue("Add");
}
function Submit(value)
{
	var IRowID=document.getElementById('RowID').value;
	if (IRowID==""){
		alertShow(t["06"]);
		return 0;
	}
	
	var obj=document.getElementById('submit');
	if (obj) {var encmeth=obj.value} else {var encmeth=""};
	var User=curUserID;
	var sqlco=cspRunServerMethod(encmeth,"","",IRowID,value,User);
	if (sqlco!='0') {
		alertShow(t["04"]);
	return 0;	}
   return IRowID;
}
function BAssign_Click()
{
	if (CheckItemNull(1,"AcceptUser")) return;
	var Return=Update("2","1");
	if (Return==0) return;
	window.location.href= "websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMaintRequest&RowID="+Return+"&Status=分配"+"&Add="+GetElementValue("Add");
}
function BDeal_Click()
{
	if (CheckItemNull(1,"AcceptUser")) return;
	if (CheckItemNull(2,"AcceptDate")) return;
	if (CheckItemNull(1,"FaultType")) return;
	if (CheckItemNull(1,"MaintMode")) return;
	var Return=Update("3","2");
	if (Return==0) return;
	window.location.href= "websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMaintRequest&RowID="+Return+"&Status=受理"+"&Add="+GetElementValue("Add");
}
function BSolve_Click()
{
	if (CheckItemNull(1,"AcceptUser")) return;
	if (CheckItemNull(2,"AcceptDate")) return;
	if (CheckItemNull(1,"FaultType")) return;
	if (CheckItemNull(1,"MaintMode")) return;
	if (CheckItemNull(2,"EndDate")) return;
	if (CheckItemNull(2,"FaultReason")) return;
	if (CheckItemNull(2,"DealMethod")) return;
	var Return=Update("4","3");
	if (Return==0) return;
	window.location.href= "websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMaintRequest&RowID="+Return+"&Status=解决"+"&Add="+GetElementValue("Add");
}
function GetMaintDR()
{
	var obj=document.getElementById("RowID");
	var RowID=obj.value;
	if (RowID==""){
		alertShow(t["05"]);
		return "";
	}
	var obj=document.getElementById('maintdr');
	if (obj) {var encmeth=obj.value} else {var encmeth=""};
	var MaintDR=cspRunServerMethod(encmeth,"","",RowID);
	return MaintDR;
}
function BMaintItem_Click() 
{	
	var MaintDR=GetMaintDR();
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMaintItem&MaintDR='+MaintDR
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=600,height=400,left=320,top=0')
}

function BMaintPart_Click() 
{
	var MaintDR=GetMaintDR();
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMaintPart&MaintDR='+MaintDR
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=600,height=400,left=320,top=0')
}

function GetEquip(value)
{
	var user=value.split("^");
	var obj=document.getElementById('EquipDR');
	obj.value=user[1];
	parent.frames["DHCEQBanner"].location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBanner&RowIDB='+user[1];
	SetContratByEquip(user[1]);
	var obj=new GetEquipOBJ(user[1],"");
	
	
	SetElement("UseLoc",obj.UseLoc);
	SetElement("UseLocDR",obj.UseLocDR);
	SetElement("UserSign",obj.Keeper);
	SetElement("UserSignDR",obj.KeeperDR);
	SetElement("AcceptUser",obj.MaintUser);
	SetElement("AcceptUserDR",obj.MaintUserDR);

}

function GetUserSign(value)
{
	GetLookUpID('UserSignDR',value);
}
function GetDealMethod(value)
{
	GetLookUpID('DealMethodDR',value);
}
function GetAcceptUser(value)
{
	GetLookUpID('AcceptUserDR',value);
}
function GetFaultCase(value)
{
	GetLookUpID('FaultCaseDR',value);
}
function GetFaultReason(value)
{
	GetLookUpID('FaultReasonDR',value);
}
function GetFaultType(value)
{
	GetLookUpID('FaultTypeDR',value);
}
function GetMaintMode(value)
{
	user=value.split("^");
	GetLookUpID('MaintModeDR',value);
	//SetMaintFeeStatus("MaintFee",GetFeeType(user[1]));
}
function GetManageLoc(value)
{
	GetLookUpID('ManageLocDR',value);
}
function GetUseLoc(value)
{
	GetLookUpID('UseLocDR',value);
}
function GetRequestLoc(value)
{
	GetLookUpID('RequestLocDR',value);
}
function SetContratByEquip(EquipDR)
{
	var encmeth=GetElementValue("SetContract");
	var ValueList=cspRunServerMethod(encmeth,EquipDR);
	var Value=ValueList.split("^");
	SetSerContract(Value[0],Value[1],Value[2]);
}
function SetSerContract(Type,StartDate,EndDate)
{
	
	if (Type=="0")  //没有保修
	{
		DisableBElement("BSerContract",true);
	}
	else
	{
		DisableBElement("BSerContract",false);
		var obj=document.getElementById("BSerContract");
		if (obj) obj.onclick=BSerContract_Click;
	}
	SetElement("MaintStartDate",StartDate);
	SetElement("MaintEndDate",EndDate);
}
document.body.onload = BodyLoadHandler;
