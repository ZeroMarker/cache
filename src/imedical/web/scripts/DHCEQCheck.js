
function BodyLoadHandler() 
{
	InitStyle("Equip","6");
	InitPage();
	FillData();
	SetEnabled();
	KeyUp("InstallLoc^CheckType^CheckResult","N");
	Muilt_LookUp("Equip^InstallLoc^CheckType^CheckResult");
	InitUserInfo();
}
function SetEnabled()
{
	var Status=GetElementValue("Status");
	var Type=GetElementValue("Type");
	if (Status=="0")
	{
		DisableBElement("BAudit",true);
		DisableBElement("BCancelSubmit",true);
	}
	if (Status=="1")
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
	}
	if (Status=="2")
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BAudit",true);
		DisableBElement("BCancelSubmit",true);
	}
	if (Status=="")
	{
		DisableBElement("BCheckItem",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BAudit",true);
		DisableBElement("BCancelSubmit",true);
		DisableBElement("BConfig",true);
	}
	if (Type!="0")
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		var NextStep=GetElementValue("NextFlowStep")
		if (Type=="1")
		{
			var RoleStep=GetElementValue("RoleStep")
			if (RoleStep!=NextStep)
			{
				DisableBElement("BCancelSubmit",true);
				DisableBElement("BAudit",true);
			}
		}
		if (Type=="2")
		{
			if (NextStep!="")
			{
				DisableBElement("BCancelSubmit",true);
				DisableBElement("BAudit",true);
			}
		}
	}
	else
	{
		DisableBElement("BAudit",true);
		DisableBElement("BCancelSubmit",true);
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
	var sort=32;
	SetElement("EquipDR",list[0]);
	SetElement("Equip",list[sort+0]);
	SetElement("InstallLocDR",list[1]);
	SetElement("InstallLoc",list[sort+1]);
	SetElement("InstallDate",list[2]);
	SetElement("InstallUser",list[3]);
	SetElement("StartDate",list[4]);
	SetElement("EndDate",list[5]);
	SetElement("CheckContent",list[6]);
	SetElement("CheckResultDR",list[7]);
	SetElement("CheckResult",list[sort+2]);
	SetElement("CheckResultRemark",list[8]);
	SetElement("CheckTypeDR",list[9]);
	SetElement("CheckType",list[sort+3]);
	SetElement("Status",list[10]);
	SetElement("Remark",list[11]);
	SetElement("RejectReason",list[12]);
	SetElement("RejectUserDR",list[13]);
	//SetElement("RejectUser",list[sort+4]);
	SetElement("RejectDate",list[14]);
	SetElement("RejectTime",list[15]);
	SetElement("ApproveSetDR",list[16]);
	//SetElement("ApproveSet",list[sort+5]);
	SetElement("NextRoleDR",list[17]);
	//SetElement("NextRole",list[sort+6]);
	SetElement("NextFlowStep",list[18]);
	SetElement("ApproveStatu",list[19]);
	SetElement("ApproveRoleDR",list[20]);
	SetElement("ApproveRole",list[sort+7]);
	//SetElement("Hold1",list[21]);
	SetChkElement("InvalidFlag",list[22]);
}

function InitPage()
{
	var obj=document.getElementById("BCheckItem");
	if (obj) obj.onclick=BCheckItem_Click;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Clicked;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Clicked;
	var obj=document.getElementById("BSubmit");
	if (obj) obj.onclick=BSubmit_Clicked;
	var obj=document.getElementById("BAudit");
	if (obj) obj.onclick=BAudit_Clicked;
	var obj=document.getElementById("BConfig");
	if (obj) obj.onclick=BConfig_Clicked;
	var obj=document.getElementById("BCancelSubmit");
	if (obj) obj.onclick=BCancelSubmit_Clicked;
	var obj=document.getElementById("Equip");
	if (obj) obj.onchange=ValueClear;
		
}
function BCancelSubmit_Clicked()
{
	if (CheckItemNull(2,"RejectReason")) return;
	var RejectReason=GetElementValue("RejectReason");
	var Return=UpdateCheck(RejectReason,"4");
    if (Return>0)
    {
	    window.location.reload() //href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBuyPlan&RowID='+Return+'&Type='+GetElementValue("Type")//+'&PlanType='+GetElementValue("PlanType")
	}
    else
    {
	    alertShow(Return+"   "+t["01"]);
    }
}
function BConfig_Clicked()
{
	var EquipID=GetElementValue("EquipDR");
	if (EquipID=="")
	{
		alertShow(t["01"]);
		return;
	}
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQConfig&EquipDR='+EquipID;
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0');
}
function BDelete_Clicked()
{
	var truthBeTold = window.confirm(t["02"]);
	if (!truthBeTold) return;
	var Return=UpdateCheck("","3");
	if (Return=="")
    {
	    parent.frames["DHCEQCheck"].location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCheck&Type=0&RowID='+Return
	    parent.frames["DHCEQBanner"].location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBanner&RowIDB='+"";
	}
    else
    {
	    alertShow(Return+"   "+t["01"]);
    }
}
function BSubmit_Clicked()
{
	var combindata="";
	combindata=GetElementValue("InstallDate") ;
	combindata=combindata+"^"+GetElementValue("InstallLocDR") ;
	var Return=UpdateCheck(combindata,"1");
    if (Return>0)
    {
	    parent.frames["DHCEQCheck"].location.reload() //href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCheck&RowID='+Return
	}
    else
    {
	    alertShow(t[Return]+" "+t["01"]);
    }
}
function GetOpinion()
{
	var ApproveRole=GetElementValue("CurRole");
	var CurStep=GetElementValue("RoleStep");
	var combindata=""
	combindata=combindata+GetElementValue("CurRole") ;
  	combindata=combindata+"^"+GetElementValue("RoleStep") ;
  	combindata=combindata+"^"+GetElementValue("Opinion_"+ApproveRole+"_"+CurStep) ;
  	combindata=combindata+"^"+GetElementValue("OpinionRemark") ;
  	return combindata;
  	
}
function CheckAuditNull()
{
	var ApproveRole=GetElementValue("CurRole");
	var CurStep=GetElementValue("RoleStep");
	if (CheckItemNull(2,"Opinion_"+ApproveRole+"_"+CurStep)) return true;
	return false
}
function BAudit_Clicked()
{
	var combindata="";
	combindata=GetElementValue("InstallDate") ;
	combindata=combindata+"^"+GetElementValue("InstallLocDR") ;
	var Type=GetElementValue("Type")
	if (Type=="2")
	{
		var Return=UpdateCheck(combindata,"2");
	}
	if (Type=="1")
	{
		if (CheckAuditNull()) return;
		var combindata=combindata+";"+GetOpinion();
		var Return=UpdateCheck(combindata,"5");
	}
    if (Return>0)
    {
	    parent.frames["DHCEQCheck"].location.reload() //href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCheck&RowID='+Return
	    parent.frames["DHCEQBanner"].location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBanner&RowIDB='+GetElementValue("EquipDR");
	}
    else
    {
	    alertShow(Return+"   "+t["01"]);
    }
}
function BUpdate_Clicked()
{
	if (CheckNull()) return;
	var combindata="";
  	combindata=GetElementValue("RowID") ;
  	combindata=combindata+"^"+GetElementValue("EquipDR") ;
  	combindata=combindata+"^"+GetElementValue("InstallLocDR") ;
  	combindata=combindata+"^"+GetElementValue("InstallDate") ;
  	combindata=combindata+"^"+GetElementValue("InstallUser") ;
  	combindata=combindata+"^"+GetElementValue("StartDate") ;
  	combindata=combindata+"^"+GetElementValue("EndDate") ;
  	combindata=combindata+"^"+GetElementValue("CheckContent") ;
  	combindata=combindata+"^"+GetElementValue("CheckResultDR") ;
  	combindata=combindata+"^"+GetElementValue("CheckResultRemark") ;
  	combindata=combindata+"^"+GetElementValue("CheckTypeDR") ;
  	combindata=combindata+"^"+GetElementValue("Status") ;
  	combindata=combindata+"^"+GetElementValue("Remark") ;	
    var Return=UpdateCheck(combindata,"0");
    
    var ReturnList=Return.split("^")
    var Return=ReturnList[0]
    var EquipDR=ReturnList[1]
    
    if (Return>0)
    {
	    var RowID=GetElementValue("RowID")
	    if (RowID=="")
	    {
		    var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQConfig&EquipDR='+EquipDR;
    		window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
	    }
		//add by HHM 20150910 HHM0013
		//添加操作成功是否提示
		ShowMessage();
		//****************************
	    parent.frames["DHCEQCheck"].location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCheck&Type=0&RowID='+Return
	}
    else
    {
	    alertShow(Return+"   "+t["01"]);
    }
    
}

function BCheckItem_Click() 
{
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCheckItem&CheckDR='+GetElementValue("RowID")
	window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=600,height=400,left=320,top=0')
}


function UpdateCheck(ValueList,AppType)
{
	var RowID=GetElementValue("RowID");
	var encmeth=GetElementValue("upd");
	var EquipDR=GetElementValue("EquipDR");
	var user=curUserID;
	var ReturnValue=cspRunServerMethod(encmeth,"","",ValueList,AppType,RowID,EquipDR,user);
	return ReturnValue;
}
function CheckNull()
{
	if (CheckMustItemNull()) return true;
	/*
	if (CheckItemNull(1,"Equip")) return true;
	if (CheckItemNull(2,"InstallDate")) return true;
	if (CheckItemNull(1,"InstallLoc")) return true;
	if (CheckItemNull(1,"CheckResult")) return true;
	if (CheckItemNull(2,"CheckContent")) return true;
	*/
	return false;
}
function ValueClear()
{
	var obj=document.getElementById("EquipDR");
	obj.value="";
	parent.frames["DHCEQBanner"].location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBanner&RowIDB='+"";
}

function GetEquip (value)
{
    var user=value.split("^");
	var obj=document.getElementById('EquipDR');
	obj.value=user[1];
	parent.frames["DHCEQBanner"].location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBanner&RowIDB='+user[1];
}
function GetInstallLoc (value)
{
    GetLookUpID("InstallLocDR",value);
}
function GetCheckType (value)
{
    GetLookUpID("CheckTypeDR",value);
}
function GetCheckResult (value)
{
    GetLookUpID("CheckResultDR",value);
}
document.body.onload = BodyLoadHandler;

