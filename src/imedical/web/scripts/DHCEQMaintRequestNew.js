// DHCEQMaintRequestNew.js
function BodyLoadHandler() 
{
	KeyUp("Equip^RequestLoc^ManageLoc^UseLoc^UserSign^FaultCase^AcceptUser^FaultType^MaintMode^FaultReason^DealMethod","N");
	InitUserInfo();
	InitPage();	
	FillDataByEquipID();
	FillData();
	
	SetEnabled();
	SetElementEnabled();
	InitEditFields(GetElementValue("ApproveSetDR"),GetElementValue("CurRole"));
	InitApproveButton();
	
	SetFocus("Equip");
	Muilt_LookUp("Equip^RequestLoc^ManageLoc^UseLoc^UserSign^FaultCase^AcceptUser^FaultType^MaintMode^FaultReason^DealMethod")
}
function InitPage()
{
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	
	var obj=document.getElementById("BSubmit");
	if (obj) obj.onclick=BSubmit_Click;
	
	var obj=document.getElementById("Equip")
	if (obj) obj.onchange=Equip_Change;
}
function FillData()
{
	var obj=document.getElementById("RowID");
	if (obj) var RowID=obj.value;
	if (RowID=="")
	{
		var encmeth=GetElementValue("GetMRRwoID");
		if (encmeth=="") return;
		var EquipDR=GetElementValue("EquipDR");
		if (EquipDR=="") return;
		var RowID=cspRunServerMethod(encmeth,EquipDR);
	}
	if (RowID=="")  return;
	var obj=document.getElementById("fillData");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var ReturnList=cspRunServerMethod(encmeth,"","",RowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	//alertShow(RowID+"   ReturnList="+ReturnList);
	list=ReturnList.split("^");
	var sort=47;
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
	SetElement("RequestNO",list[42]);
	//alertShow(RowID+"   NextRoleDR="+list[sort+17]);
	//AIRowID_"^"_ApproveSetDR_"^"_NextRoleDR_"^"_NextFlowStep_"^"_ApproveStatu_"^"_
	//ApproveRoleDR_"^"_CancelFlag_"^"_CancelToFlowDR
	SetElement("ApproveSetDR",list[sort+16]);
	SetElement("NextRoleDR",list[sort+17]);
	SetElement("NextFlowStep",list[sort+18]);
	SetElement("ApproveStatu",list[sort+19]);
	SetElement("ApproveRoleDR",list[sort+20]);
	SetElement("CancelFlag",list[sort+21]);
	SetElement("CancelToFlowDR",list[sort+22]);
}
function SetEnabled()
{
	var Status=GetElementValue("Status");
	//alertShow("Status="+Status)
	var curRole=GetElementValue("CurRole");
	var nextRole=GetElementValue("NextRoleDR");
	//alertShow(curRole+":"+nextRole)
	if ((Status!=0)||(curRole!=nextRole))
	{
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BUpdate",true);
	}
	if (GetElementValue("EquipDR")=="")
	{
		DisableBElement("BSerContract",true);
	}
}
function SetElementEnabled()
{
	var Status=GetElementValue("Status");
	if (Status>0)
	{
		SetElementsReadOnly("Equip^RequestLoc^ManageLoc^UseLoc^UserSign^FaultCase^RequestDate^StartDate^FaultCaseRemark^UserOpinion^Remark",true);
	}
	else
	{
		SetElementsReadOnly("AcceptUser^FaultType^MaintMode^FaultReason^DealMethod^AcceptDate^EndDate^OtherFee^FaultReasonRemark^DealMethodRemark^MaintRemark",true);
	}
}

function SetElementsReadOnly(val,flag)
{
	var List=val.split("^")
	for(var i = 0; i < List.length; i++)
	{
		DisableElement(List[i],flag);
		ReadOnlyElement(List[i],flag);
		if (document.getElementById(GetLookupName(List[i])))
		{
			DisableElement(GetLookupName(List[i]),flag);
		}
	}
}

function GetEquip(value)
{
	var data=value.split("^");
	var obj=document.getElementById('EquipDR');
	obj.value=data[1];
	parent.frames["DHCEQBanner"].location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBanner&RowIDB='+data[1];
	SetContratByEquip(data[1]);
	var obj=new GetEquipOBJ(data[1],"");
	
	SetElement("UseLoc",obj.UseLoc);
	SetElement("UseLocDR",obj.UseLocDR);
	SetElement("UserSign",obj.Keeper);
	SetElement("UserSignDR",obj.KeeperDR);
	SetElement("AcceptUser",obj.MaintUser);
	SetElement("AcceptUserDR",obj.MaintUserDR);
}

function BUpdate_Click()
{
	if (CheckItemNull(1,"Equip")) return;
	if (CheckItemNull(1,"RequestLoc")) return;
	if (CheckItemNull(1,"FaultCase")) return;
	if (CheckItemNull(2,"StartDate")) return;
	if (CheckItemNull(2,"RequestDate")) return;
	if (CheckInvalidData()) return;
	var combindata=GetDataList();
	var upd=document.getElementById('upd');
	if (upd){var encmeth=upd.value} else {var encmeth=""};
	var ReturnValue=cspRunServerMethod(encmeth,"","",combindata);
	if (ReturnValue<0) //2011-10-31 DJ DJ0098
	{
		alertShow(t[ReturnValue])
		return;
	}
	window.location.href= "websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMaintRequestNew&RowID="+ReturnValue+"&CurRole="+GetElementValue("CurRole");
}
function GetDataList()
{
	var combindata="";
  	combindata=GetElementValue("RowID");
  	combindata=combindata+"^"+GetElementValue("EquipDR");
  	combindata=combindata+"^"+GetElementValue("RequestLocDR");
  	combindata=combindata+"^"+GetElementValue("FaultCaseDR");
  	combindata=combindata+"^"+GetElementValue("FaultCaseRemark");
  	combindata=combindata+"^"+GetElementValue("FaultReasonDR");
  	combindata=combindata+"^"+GetElementValue("FaultReasonRemark");
  	combindata=combindata+"^"+GetElementValue("DealMethodDR");
  	combindata=combindata+"^"+GetElementValue("DealMethodRemark");
  	combindata=combindata+"^"+GetElementValue("StartDate");
  	combindata=combindata+"^"+GetElementValue("StartTime");
  	combindata=combindata+"^"+GetElementValue("EndDate");
  	combindata=combindata+"^"+GetElementValue("EndTime");
  	combindata=combindata+"^"+GetElementValue("RequestDate");
  	combindata=combindata+"^"+GetElementValue("RequestTime");
  	combindata=combindata+"^"+GetElementValue("FaultTypeDR");
  	combindata=combindata+"^"+GetElementValue("AcceptDate");
  	combindata=combindata+"^"+GetElementValue("AcceptTime");
  	combindata=combindata+"^"+GetElementValue("AcceptUserDR");
  	combindata=combindata+"^"+GetElementValue("AssignDR");
  	combindata=combindata+"^"+GetElementValue("MaintModeDR");
  	combindata=combindata+"^"+GetChkElementValue("PayedMaintFlag");
  	combindata=combindata+"^"+GetElementValue("MaintFee");
  	combindata=combindata+"^"+GetElementValue("UserSignDR");
  	combindata=combindata+"^"+GetElementValue("UserOpinion");
  	combindata=combindata+"^"+GetElementValue("ManageLocDR");
  	combindata=combindata+"^"+GetElementValue("UseLocDR");
  	combindata=combindata+"^"+"Y"//GetChkElementValue("IsInputFlag");
  	combindata=combindata+"^"+GetElementValue("Remark");
  	combindata=combindata+"^"+GetElementValue("Status");
  	combindata=combindata+"^"+Guser;
  	combindata=combindata+"^"+curLocID;
  	combindata=combindata+"^"+GetElementValue("MaintRemark");
  	combindata=combindata+"^"+GetElementValue("MaintDept");
  	combindata=combindata+"^"+GetElementValue("OtherFee");
  	combindata=combindata+"^"+GetElementValue("RequestNO");
  	/*combindata=combindata+"^"+GetElementValue("AddDate");
  	combindata=combindata+"^"+GetElementValue("AddTime");
  	combindata=combindata+"^"+GetElementValue("UpdateUserDR");
  	combindata=combindata+"^"+GetElementValue("UpdateDate");
  	combindata=combindata+"^"+GetElementValue("UpdateTime");
  	combindata=combindata+"^"+GetElementValue("SubmitUserDR");
  	combindata=combindata+"^"+GetElementValue("SubmitDate");
  	combindata=combindata+"^"+GetElementValue("SubmitTime");*/
  	
    return combindata;
}
function BDelete_Click()
{
	var obj=document.getElementById("RowID");
	var RowID=obj.value;
	if (RowID=="")
	{
		alertShow(t["05"])
		return
	}
	var truthBeTold = window.confirm(t["10"]);
	if (!truthBeTold) return;
	
	var upd=document.getElementById('del');
	if (upd){var encmeth=upd.value} else {var encmeth=""};
	var Ret=cspRunServerMethod(encmeth,"","",RowID)
	if (Ret!='0')
	{
		alertShow(t["07"]);
		return;
	}
	window.location.href= "websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMaintRequestNew&RowID=";
}
function BSubmit_Click()	// 提交
{
	var IRowID=document.getElementById('RowID').value;
	if (IRowID=="")
	{
		alertShow(t["06"]);
		return 0;
	}
	var obj=document.getElementById('submit');
	if (obj) {var encmeth=obj.value} else {var encmeth=""};
	var Ret=cspRunServerMethod(encmeth,"","",IRowID,"1",Guser);
	if (Ret!="0") //2011-10-31 DJ DJ0098
	{
		if (Ret=="-1015")
		{
			alertShow(t[Ret])
		}
		else
		{
			alertShow(t["04"]);
		}
		return 0;
	}
	window.location.href= "websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMaintRequestNew&RowID="+IRowID+"&CurRole="+GetElementValue("CurRole");
}

function BCancelSubmit_Clicked() // 取消提交
{
	var combindata=GetValueList();
  	var encmeth=GetElementValue("CancelSubmitData");
  	if (encmeth=="") return;
  	//alertShow("combindata="+combindata)
  	//Modified by jdl 2011-3-9  jdl0073
	var Rtn=cspRunServerMethod(encmeth,combindata,GetElementValue("CurRole"));
    if (Rtn>0)
    {
		window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMaintRequestNew&RowID="+Rtn+"&CurRole="+GetElementValue("CurRole");
	}
    else
    {
	    alertShow(Rtn+"  : "+t["01"]);
    }
}

function BApprove_Clicked()
{
	/// 20150109手工录入模式	Mozy0149
  	var GetFaultTypeOperMethod=GetElementValue("GetFaultTypeOperMethod");
  	var FaultTypeDR=GetFaultTypeRowID(GetFaultTypeOperMethod);
  	if (FaultTypeDR<0)
  	{
	  	alertShow("故障类型发生异常!");
	  	return;
  	}
  	SetElement("FaultTypeDR",FaultTypeDR);
  	var GetFaultReasonOperMethod=GetElementValue("GetFaultReasonOperMethod");
  	var FaultReasonDR=GetFaultReasonRowID(GetFaultReasonOperMethod);
  	if (FaultReasonDR<0)
  	{
	  	alertShow("故障原因发生异常!");
	  	return;
  	}
  	SetElement("FaultReasonDR",FaultReasonDR);
  	var GetDealMethodOperMethod=GetElementValue("GetDealMethodOperMethod");
  	var DealMethodDR=GetDealMethodRowID(GetDealMethodOperMethod);
  	if (DealMethodDR<0)
  	{
	  	alertShow("解决方法发生异常!");
	  	return;
  	}
  	SetElement("DealMethodDR",DealMethodDR);
	var objtbl=GetParentTable("RequestNO")
	var EditFieldsInfo=ApproveEditFieldsInfo(objtbl);
	if (EditFieldsInfo=="-1") return;
	//alertShow(EditFieldsInfo);
	var combindata=GetValueList();
	var CurRole=GetElementValue("CurRole")
  	if (CurRole=="") return;
	var RoleStep=GetElementValue("RoleStep")
  	if (RoleStep=="") return;
  	var encmeth=GetElementValue("AuditData")
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,combindata,CurRole,RoleStep,EditFieldsInfo);
    if (Rtn=="0")
    {
	    window.location.reload();
	}
    else
    {
	    if (Rtn=="-1002")
	    {
			var truthBeTold = window.confirm(t[Rtn]);
			if (!truthBeTold) return;
			var Rtn=cspRunServerMethod(encmeth,combindata,CurRole,RoleStep,EditFieldsInfo,"Y");
		    if (Rtn=="0")
		    {
			    window.location.reload();
			}
		    else
		    {
			    alertShow(t[Rtn]);
			}
	    }
	    else
	    {
		    alertShow(t[Rtn]);
		}
	    
    }
}
function GetValueList()
{
	var ValueList="";
	ValueList=GetElementValue("RowID");
	ValueList=ValueList+"^"+curUserID;
	ValueList=ValueList+"^"+GetElementValue("CancelToFlowDR");
	
	return ValueList;
}

function Equip_Change()
{
	KeyUp("Equip");
	parent.frames["DHCEQBanner"].location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBanner&RowIDB=';
	SetSerContract("0","","");
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
// 保修日期
function BSerContract_Click()
{
	var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQSerContract&EquipDR="+GetElementValue("EquipDR")+"&ReadOnly=1"
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
}
/*
// 外修申请
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

function GetMaintDR()
{
	var obj=document.getElementById("RowID");
	var RowID=obj.value;
	if (RowID=="")
	{
		alertShow(t["05"]);
		return "";
	}
	var obj=document.getElementById('maintdr');
	if (obj) {var encmeth=obj.value} else {var encmeth=""};
	var MaintDR=cspRunServerMethod(encmeth,"","",RowID);
	return MaintDR;
}
// 维修项目
function BMaintItem_Click() 
{	
	var MaintDR=GetMaintDR();
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMaintItem&MaintDR='+MaintDR
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=600,height=400,left=320,top=0')
}
// 维修更换配件
function BMaintPart_Click() 
{
	var MaintDR=GetMaintDR();
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMaintPart&MaintDR='+MaintDR
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=600,height=400,left=320,top=0')
}
*/

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
function CheckInvalidData()
{
	if (IsValidateNumber(GetElementValue("MaintFee"),1,1,0,1)==0)
	{
		alertShow("维修费用数据异常,请修正.");
		return true;
	}
	if (IsValidateNumber(GetElementValue("OtherFee"),1,1,0,1)==0)
	{
		alertShow("其他费用数据异常,请修正.");
		return true;
	}
	return false;
}

function FillDataByEquipID()
{
	var EquipDR=GetElementValue("EquipDR");
	if (EquipDR=="") return;
	var objEquip=new Equipment(EquipDR,"");
	SetElement("EquipDR",objEquip.ID);
	SetContratByEquip(objEquip.ID);
	SetElement("Equip",objEquip.Name);
	SetElement("UseLocDR",objEquip.UseLocDR);
	SetElement("UseLoc",objEquip.UseLoc);
	SetElement("UserSignDR",objEquip.KeeperDR);
	SetElement("UserSign",objEquip.Keeper);
}
document.body.onload = BodyLoadHandler;