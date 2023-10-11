/// DHCEQAppraisalReportFind.js
function BodyLoadHandler()
{
	//modified by cjt 20230211 需求号3222152 UI页面改造
	initPanelHeaderStyle();
	initButtonColor();
	SetBEnable();
	SetStatus();
	//initButtonWidth();
	SetEQTitle();
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
}

function SetBEnable()
{
	var WaitAD=GetElementValue("WaitAD");
	if (WaitAD!="off")
	{
		DisableBElement("BAdd",true);
	}
}
function SetStatus()
{
	SetElement("Status",GetElementValue("GetStatus"))
}
function SetEQTitle()
{
	var WaitAD=GetElementValue("WaitAD");
	if (WaitAD!="off")
	{
		SetElement("cEQTitle","鉴定报告审核")
	}
}

function BAdd_Click()
{
	// MZY0140	2612987		2022-10-31
	var url="dhceq.em.appraisalreport.csp?&Type="+GetElementValue("BussType")+"&WaitAD="+GetElementValue("WaitAD");
	//var url="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQAppraisalReport&Type="+GetElementValue("BussType")+"&WaitAD="+GetElementValue("WaitAD");
	// MZY0157	2612987		2023-03-29	设置弹框位置
	showWindow(url,"设备鉴定报告新增","1252","487","icon-w-paper","modal","94","160","");
}

document.body.onload = BodyLoadHandler;