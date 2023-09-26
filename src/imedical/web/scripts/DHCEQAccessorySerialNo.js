//DHCEQAccessorySerialNo.JS

function BodyLoadHandler()
{
	InitPage();
	SetEnabled();
}
function InitPage()
{
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Clicked;
}
function SetEnabled()
{
	var AInStockDR=GetElementValue("AInStockDR");
	var obj=document.getElementById("GetStatus");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var Status=cspRunServerMethod(encmeth,AInStockDR);
	if(Status!=""&&Status!=0)
	{
		DisableBElement("BUpdate",true);
	}
}

function BUpdate_Clicked()
{
	var AInStockDR=GetElementValue("AInStockDR");
	var ListNo=GetElementValue("ListNo");
	var obj=document.getElementById("SaveSerialNoGlobal");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var valList=getSerialNoGlobal();
	//alertShow("valList="+valList)
	if(valList=="") return;
	var ReturnList=cspRunServerMethod(encmeth,valList,AInStockDR,ListNo);
	window.location.reload();
}
function getSerialNoGlobal()
{
	var objtbl=document.getElementById('tDHCEQAccessorySerialNo'); //得到表格   t+组件名称
	var rows=objtbl.rows.length;
	var valList="";
	for(var i=1;i<rows;i++)
	{
		var TAccessoryDR=document.getElementById('TAccessoryDRz'+i).value;
		var TSerialNo=document.getElementById('TSerialNoz'+i).value;
		var TRemark=document.getElementById('TRemarkz'+i).value;
		
		if(valList!="") valList=valList+"&";
		valList=valList+TAccessoryDR+"^"+TSerialNo+"^"+TRemark;
	}
  	return valList;
}

document.body.onload = BodyLoadHandler;
