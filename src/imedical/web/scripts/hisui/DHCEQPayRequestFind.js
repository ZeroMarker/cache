function BodyLoadHandler()
{
	InitUserInfo();
	KeyUp("Loc^Provider");
	SetStatus();
	Muilt_LookUp("Loc^Provider");
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
	HiddenTableIcon("DHCEQPayRequestFind","TRowID","TDetail");
	if (GetElementValue("Type")>0)
	{
		HiddenObj("BAdd",1)
	}
	initButtonWidth()
}

function SetStatus()
{
	setElement("Status",getElementValue("StatusDR"));
}

function GetLoc(value)
{
	GetLookUpID("LocDR",value);
}

function GetProvider(value)
{
	GetLookUpID("ProviderDR",value);
}
function BAdd_Click()
{
	var url="dhceq.em.payrequest.csp?&Type=0"
	showWindow(url,"∏∂øÓ…Í«Îµ•","","","icon-w-paper","modal","","","large")
}
//modified by csj 2019-2-20
function BFind_Click()
{
	if (!$(this).linkbutton('options').disabled){
		$('#tDHCEQPayRequestFind').datagrid('load',{ComponentID:getValueById("GetComponentID"),PayRequestNo:getValueById("PayRequestNo"),InvoiceNo:getValueById("InvoiceNo"),LocDR:getValueById("LocDR"),StatusDR:getValueById("Status"),ProviderDR:getValueById("ProviderDR"),StartDate:getValueById("StartDate"),EndDate:getValueById("EndDate"),PayFromType:getValueById("PayFromType"),SourceType:getValueById("SourceType"),Type:getValueById("Type")});
	}
}
document.body.onload = BodyLoadHandler;