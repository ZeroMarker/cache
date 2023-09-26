/// Created By HZY 2012-03-05 
/// Desc:研究课题管理
/// --------------------------------------------------------
function BodyLoadHandler(){	
	InitPage();
	SetStatus();
	SetEnabled();
}

function SetStatus()
{
	SetElement("Status",GetElementValue("GetStatu"));
}

function SetEnabled()
{
	var Type=GetElementValue("Type");
	if (Type!="0")
	{
		DisableBElement("BAdd",true);
	}
	else
	{
		EQCommon_HiddenElement("WaitAD");
		EQCommon_HiddenElement("cWaitAD");
	}
}
function InitPage()
{
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Clicked;
}

function BFind_Clicked()
{
	//QXType, Status, StartDate, EndDate, Type, ApproveRole, WaitAD, IssueNo, IssueShortName, IssueDept, InvalidFlag 
	var obj=document.getElementById("WaitAD");
	var WaitAD="0";
	if (obj.checked) WaitAD="on";
	var lnkvar="&WaitAD="+WaitAD;
	lnkvar=lnkvar+"&Type="+GetElementValue("Type");
	lnkvar=lnkvar+"&Status="+GetElementValue("Status");
	lnkvar=lnkvar+"&ApproveRole="+GetElementValue("ApproveRole");
	lnkvar=lnkvar+"&StartDate="+GetElementValue("StartDate");	   
	lnkvar=lnkvar+"&EndDate="+GetElementValue("EndDate");		
	lnkvar=lnkvar+"&QXType="+GetElementValue("QXType");
	
	lnkvar=lnkvar+"&IssueNo="+GetElementValue("IssueNo");
	lnkvar=lnkvar+"&IssueShortName="+GetElementValue("IssueShortName");
	lnkvar=lnkvar+"&IssueDept="+GetElementValue("IssueDept");
	lnkvar=lnkvar+"&InvalidFlag="+GetElementValue("InvalidFlag");
	//alertShow(lnkvar);
	window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQIssueFind"+lnkvar;
}

document.body.onload = BodyLoadHandler;