/// Created By HZY 2012-02-22 
/// Desc:研究课题
/// --------------------------------------------------------
function BodyLoadHandler() 
{
	InitUserInfo();
	InitPage();
	FillData();
	SetEnabled();
	InitEditFields(GetElementValue("ApproveSetDR"),GetElementValue("CurRole"));
	InitApproveButton();
	SetDisplay();
}
function SetDisplay()
{
	ReadOnlyCustomItem(GetParentTable("ShortName"),GetElementValue("Status"));
	ReadOnlyElements("AuditOpinion",true);	
	//ReadOnlyElements("IssueNo^IssueName^ShortName^Content^Purpose^Master^RequestDate^RequestFee^Dept^StartDate^EndDate^Remark^AuditOpinion^RejectReason^RefuseRemark^EditOpinion",true)	
}

function InitPage()
{
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Clicked;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Clicked;
	var obj=document.getElementById("BSubmit");
	if (obj) obj.onclick=BSubmit_Clicked;
	var obj=document.getElementById("BCancelSubmit");
	if (obj) obj.onclick=BCancelSubmit_Clicked;
}
function FillData()
{
	var obj=document.getElementById("RowID");
	var RowID=obj.value;
	if ((RowID=="")||(RowID<1))	return;
	var obj=document.getElementById("fillData");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var ReturnList=cspRunServerMethod(encmeth,RowID,GetElementValue("CurRole"));
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	//alertShow(ReturnList);
	var valueRequest=ReturnList.split("^");
	
	SetElement("RowID",valueRequest[0]);
	SetElement("IssueNo",valueRequest[1]);
	SetElement("IssueName",valueRequest[2]);
	SetElement("ShortName",valueRequest[3]);
	SetElement("Content",valueRequest[4]);
	SetElement("Purpose",valueRequest[5]);
	SetElement("Master",valueRequest[6]);
	SetElement("RequestDate",valueRequest[7]);
	SetElement("RequestFee",valueRequest[8]);
	SetElement("Dept",valueRequest[9]);
	SetElement("StartDate",valueRequest[10]);
	SetElement("EndDate",valueRequest[11]);
	SetElement("Status",valueRequest[12]);
	SetElement("Remark",valueRequest[13]);
	
	SetElement("Hold1",valueRequest[27]);
	SetElement("Hold2",valueRequest[28]);
	SetElement("Hold3",valueRequest[29]);
	SetElement("Hold4",valueRequest[30]);
	SetElement("Hold5",valueRequest[31]);

	var sortRequest=31;
	//alertShow(valueRequest[sortRequest+2]+"^"+valueRequest[sortRequest+3]+"^"+valueRequest[sortRequest+4]+"^"+valueRequest[sortRequest+5]+"^"+valueRequest[sortRequest+6]+"^"+valueRequest[sortRequest+7]+"^"+valueRequest[sortRequest+8]);
	SetElement("ApproveSetDR",valueRequest[sortRequest+2]);
	SetElement("NextRoleDR",valueRequest[sortRequest+3]);
	SetElement("NextFlowStep",valueRequest[sortRequest+4]);
	SetElement("ApproveStatus",valueRequest[sortRequest+5]);
	SetElement("ApproveRoleDR",valueRequest[sortRequest+6]);
	SetElement("CancelFlag",valueRequest[sortRequest+7]);
	SetElement("CancelToFlowDR",valueRequest[sortRequest+8]);
	SetElement("AuditOpinion",valueRequest[sortRequest+11]);
	
	encmeth=GetElementValue("GetApproveByRource");
	var ApproveListInfo=cspRunServerMethod(encmeth,"20",RowID);
	ApproveListInfo=ApproveListInfo.replace(/\\n/g,"\n");
	FillEditOpinion(ApproveListInfo,"EditOpinion");
	//SetElement("OpinionRemark",valueRequest[sortRequest+]);

	encmeth=GetElementValue("GetOneRefuseRecord");
	var obj=document.getElementById("RefuseRecordDR");
	var refuseDR=obj.value;
	//alertShow(RowID+"HZY"+refuseDR);
	var Result=cspRunServerMethod(encmeth,"1",RowID,refuseDR);
	//alertShow(Result);
	if (Result!="")
	{
		Result=Result.replace(/\\n/g,"\n");
		var RefuseRecord=Result.split("^");
		SetElement("RefuseRecordDR",RefuseRecord[0]);
		SetElement("RejectReason",RefuseRecord[3]);
		SetElement("RefuseRemark",RefuseRecord[4]);
	}
}
function SetEnabled()
{
	var Status=GetElementValue("Status");
	var WaitAD=GetElementValue("WaitAD");
	if (Status=="")
	{
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
	}
	if ((Status==1)||(Status==2))
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
	}
	// 是否审核动作已经完成
	if (GetElementValue("ApproveSetDR")!="")
	{
		var nextStep=GetElementValue("NextFlowStep");
		var curRole=GetElementValue("CurRole");
		var nextRole=GetElementValue("NextRoleDR");
		//alertShow(nextStep+","+curRole+","+nextRole+","+flag)
	}	
	if (WaitAD=="on")
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);		
	}
}

function BUpdate_Clicked()
{
	SetElement("RequestFee",parseFloat(+GetElementValue("RequestFee")));
	if (IsValidateNumber(GetElementValue("RequestFee"),1,1,0,1)==0)
	{
		alertShow("申请经费数据异常,请修正.");
		return;
	}
	if (CheckMustItemNull())
	{
		return;
	}
	var RequestValue=CombineData();
	//alertShow(RequestValue);
    var Return=UpdateIssue(RequestValue,"0");
    //alertShow(Return);
    var list=Return.split("^");
	if (list[1]!="0")
	{
		alertShow("操作异常! "+list[1]);
	}
	else
	{
		if (list[0]>0)
		{
			window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQIssue&RowID='+list[0]+"&WaitAD=off"+"&Status=0";
		}
		else
		{
			alertShow(t["01"]);
		}
	}
}
function BDelete_Clicked()
{
	var truthBeTold = window.confirm(t["02"]);
	if (!truthBeTold) return;
	var Return=UpdateIssue("","1");
    var list=Return.split("^");
	if (list[1]!="0")
	{
		alertShow("操作异常! "+list[1]);
	}
	else
    {
	    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQIssue';
	}
}

function BSubmit_Clicked()
{
	var combindata=GetAuditData();
  	var encmeth=GetElementValue("SubmitData");
  	if (encmeth=="") return;
  	//alertShow(rtn)  	
	var rtn=cspRunServerMethod(encmeth,combindata);
	if (rtn>0)
    {
	    window.location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQIssue&RowID='+rtn+"&Status=1"+"&WaitAD="+GetElementValue("WaitAD");
	}
    else
    {
	    alertShow(t[rtn]+"   "+t["01"]);
    }
}
function BCancelSubmit_Clicked() 
{
	if (CheckItemNull(2,"RejectReason")) return;
	var auditdata=GetAuditData();
  	var encmeth=GetElementValue("CancelSubmitData");
  	if (encmeth=="") return;
  	//alertShow(auditdata);
	var rtn=cspRunServerMethod(encmeth,auditdata,GetElementValue("CurRole"));
    //alertShow(rtn);
    if (rtn>0)
    {
	    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQIssue&RowID='+rtn+"&WaitAD="+GetElementValue("WaitAD");
	}
    else
    {
	    alertShow(rtn+"   "+t["01"]);
    }
}

function CombineData()
{
	var value="";
	value=GetElementValue("IssueNo");
	value=value+"^"+GetElementValue("IssueName");
	value=value+"^"+GetElementValue("ShortName");
	value=value+"^"+GetElementValue("Content");
	value=value+"^"+GetElementValue("Purpose");
	value=value+"^"+GetElementValue("Master");
	value=value+"^"+GetElementValue("RequestDate");
	value=value+"^"+GetElementValue("RequestFee");
	value=value+"^"+GetElementValue("Dept");
	value=value+"^"+GetElementValue("StartDate");
	value=value+"^"+GetElementValue("EndDate");
	value=value+"^"+GetElementValue("Status");
	value=value+"^"+GetElementValue("Remark");
	value=value+"^"+GetElementValue("AddUserDR");	//15--AddUserDR
	value=value+"^"+GetPYCode(GetElementValue("ShortName"));	//GetElementValue("Hold1")
	value=value+"^"+GetElementValue("Hold2");
	value=value+"^"+GetElementValue("Hold3");
	value=value+"^"+GetElementValue("Hold4");
	value=value+"^"+GetElementValue("Hold5");
	
	return value;
}

function GetAuditData()
{
	var ValueList="";
	ValueList=GetElementValue("RowID");
	ValueList=ValueList+"^"+curUserID;
	ValueList=ValueList+"^"+GetElementValue("CancelToFlowDR");
	ValueList=ValueList+"^"+GetElementValue("EditOpinion");
	ValueList=ValueList+"^"+GetElementValue("OpinionRemark");
	ValueList=ValueList+"^"+GetElementValue("RejectReason");
	ValueList=ValueList+"^"+GetElementValue("CurRole");
	ValueList=ValueList+"^"+GetElementValue("RoleStep");
	ValueList=ValueList+"^"+GetElementValue("RefuseRecordDR");
	ValueList=ValueList+"^"+GetElementValue("RefuseRemark");
	return ValueList;
}
function BApprove_Clicked()
{
	if (CheckItemNull(2,"EditOpinion")) return;
	var auditdata=GetAuditData();
	var CurRole=GetElementValue("CurRole");
  	if (CurRole=="") return;
	var RoleStep=GetElementValue("RoleStep");
  	if (RoleStep=="") return;
  	var objtbl=document.getElementById('tDHCEQIssue');
  	var EditFieldsInfo=ApproveEditFieldsInfo(objtbl);
	if (EditFieldsInfo=="-1") return;
  	var encmeth=GetElementValue("AuditData");
  	if (encmeth=="") return;
	var rtn=cspRunServerMethod(encmeth,auditdata,CurRole,RoleStep,EditFieldsInfo);
	//alertShow(auditdata+","+CurRole+","+RoleStep+","+EditFieldsInfo+","+rtn);
    if (rtn>0)
    {
	    window.location.reload();
	}
    else
    {
	    alertShow(t["01"]);
    }
}

///
function UpdateIssue(RequestValue,AppType)
{
	var RowID=GetElementValue("RowID");
	RequestValue=RowID+"^"+RequestValue;
	//alertShow(ValueList)
	var encmeth=GetElementValue("upd");
	var ReturnValue=cspRunServerMethod(encmeth,RequestValue,AppType);
	return ReturnValue;
}

document.body.onload = BodyLoadHandler;