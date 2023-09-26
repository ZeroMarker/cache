function BodyLoadHandler()
{
	InitUserInfo();		
	InitPage();
	SetBtnEnable();
	SetStatus();
	KeyUp("Loc^BuyLoc","N")		//Add By DJ 2016-12-05
	Muilt_LookUp("Loc^BuyLoc");
	SetTableRow();
	SetBackGroupColor('tDHCEQAInStockFind');
}

function SetStatus()
{
	SetElement("Status",GetElementValue("GetStatus"))
}
function InitPage()
{
	KeyUp("Loc");
}
function GetLoc(value)
{
	GetLookUpID("LocDR",value);
}

function GetBuyLoc(value)
{
	GetLookUpID("BuyLocDR",value);
}
function SetBtnEnable()
{
	var WaitAD=GetElementValue("WaitAD");
	if (WaitAD!="off")
	{
		DisableBElement("BAdd",true);
	}
}
function SetTableRow()
{
	var objtbl=document.getElementById("tDHCEQAInStockFind");
	var rows=objtbl.rows.length-1;
	for (var i=1;i<=rows;i++)
	{
		objtbl.rows[i].ondblclick=RowDblClick;
	}
}
function RowDblClick()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById("tDHCEQAInStockFind");
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	//alertShow(selectrow)
	var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQAInStock&RowID="+GetElementValue("TRowIDz"+selectrow)+"&CurRole="+GetElementValue("ApproveRole")+"&Type="+GetElementValue("Type")+"&WaitAD="+GetElementValue("WaitAD");
	//window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=900,height=400,left=100,top=10');
	window.location.href=str;
}
document.body.onload = BodyLoadHandler;