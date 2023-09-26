/// Modified By HZY 2011-10-19 HZY0018
/// 修改函数: InitPage

function BodyLoadHandler()
{
	InitUserInfo();		
	InitPage();
	InitTblEvt();
}

function InitPage()
{
	KeyUp("SignLoc^Provider^Status");
	Muilt_LookUp("SignLoc^Provider^Status");

	var Type=GetElementValue("Type");
	if (Type=="0")
	{
		// 可新增合同单
		EQCommon_HiddenElement("WaitAD");
		EQCommon_HiddenElement("ReplacesAD");
	}
	else
	{
		// 审批合同单
		DisableBElement("BAdd",true);
		DisableBElement("BAdd1",true);
	}
	var obj=document.getElementById("WaitAD");
	if (obj) obj.onchange=CheckChange;
	var obj=document.getElementById("ReplacesAD")
	if (obj) obj.onchange=CheckChange;
}
function CheckChange()
{
	var eSrc=window.event.srcElement;
	if (eSrc.checked)
	{
		if (eSrc.id=="WaitAD") SetChkElement("ReplacesAD","0");
		if (eSrc.id=="ReplacesAD") SetChkElement("WaitAD","0");
	} 
}

function GetSignLoc (value)
{
    GetLookUpID("SignLocDR",value);
}
function GetProvider (value)
{
    GetLookUpID("ProviderDR",value);
}
function GetStatus (value)
{
    GetLookUpID("StatusDR",value);
}
function InitTblEvt()
	{
	var objtbl=document.getElementById('tDHCEQContractFind');
	var rows=objtbl.rows.length;
	
	for (var i=1; i<rows; i++)
	{
		var obj=document.getElementById("TDetailz"+i);
		if (obj) obj.onclick=TDetail_Clicked;
	}
}

function TDetail_Clicked()
{
	var CurRow=GetTableCurRow();
	var val="&RowID="+GetElementValue("TRowIDz"+CurRow);
  val=val+"&CurRole="+GetElementValue("ApproveRole");
  val=val+"&QXType="+GetElementValue("QXType");
  val=val+"&Type="+GetElementValue("Type");
  var LinkComponentName="DHCEQContractNew";
  var ContractType=GetElementValue("TContractTypez"+CurRow);
  if (ContractType==1)
  {
	  LinkComponentName="DHCEQContractForMaint";
  }
  var str= 'websys.default.csp?WEBSYS.TCOMPONENT='+LinkComponentName+val;
  window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1000,height=680,left=120,top=0') //2011-10-27 DJ DJ0097
}
document.body.onload = BodyLoadHandler;