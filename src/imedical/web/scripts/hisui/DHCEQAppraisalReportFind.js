/// DHCEQAppraisalReportFind.js
function BodyLoadHandler()
{
	SetBEnable();
	SetStatus();
	initButtonWidth();
	
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

function BAdd_Click()
{
	var url="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQAppraisalReport&Type="+GetElementValue("BussType")+"&WaitAD="+GetElementValue("WaitAD");
	showWindow(url,"设备鉴定报告","","","icon-w-paper","modal","","","large"); //modify by lmm 2020-06-05 UI
}

document.body.onload = BodyLoadHandler;