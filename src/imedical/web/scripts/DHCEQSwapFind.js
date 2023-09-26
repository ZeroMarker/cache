
function BodyLoadHandler()
{
	InitUserInfo(); //系统参数
	SetElement("Status",GetElementValue("GetStatus"));
	InitEvent();
}
function InitEvent()
{
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
}

function BAdd_Click()
{
	//window.location.href= "dhceqswapfind.csp?RowID=";
	window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQSwapNew&RowID='
}

function BFind_Click()
{
	//SwapNo, Type, StartDate, EndDate, RequestLocDR, Status, ApproveRole, InvalidFlag
	var val="";
    val="&SwapNo="+GetElementValue("SwapNo");
    val=val+"&Type="+GetElementValue("Type");
    val=val+"&StartDate="+GetElementValue("StartDate");
    val=val+"&EndDate="+GetElementValue("EndDate");
    val=val+"&ResquestLocDR="+GetElementValue("ResquestLocDR");
    val=val+"&Status="+GetElementValue("Status"); 
    val=val+"&ResquestLocDR="+GetElementValue("ApproveRole"); 
	val='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQSwapFind'+val;
    window.location.href=val
}
document.body.onload = BodyLoadHandler;