function BodyLoadHandler()
{
	InitUserInfo();		
	InitPage();
	SetBEnable();
	SetStatus();
	SetTableRow();
}
function SetStatus()
{
	SetElement("Status",GetElementValue("GetStatu"))
}
function InitPage()
{
	KeyUp("Loc^OutType^ToDept","N");
	Muilt_LookUp("Loc^OutType^ToDept");
}
function LocDR(value)
{
	GetLookUpID("LocDR",value);
}

function GetOutType(value)
{
	GetLookUpID("OutTypeDR",value);
}

function SetBEnable()
{
	var WaitAD=GetElementValue("WaitAD");
	if (WaitAD!="off")
	{
		DisableBElement("BAdd",true);
	}
}
function SetTableRow()
{
	var objtbl=document.getElementById("tDHCEQAReduceFind");
	var rows=objtbl.rows.length-1;
	for (var i=1;i<=rows;i++)
	{
		objtbl.rows[i].ondblclick=RowDblClick;
	}
}
function RowDblClick()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById("tDHCEQAReduceFind");
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	//alertShow(selectrow)
	var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQAReduce&RowID="+GetElementValue("TRowIDz"+selectrow)+"&CurRole="+GetElementValue("ApproveRole")+"&QXType="+GetElementValue("QXType")+"&WaitAD="+GetElementValue("WaitAD")+"&Status="+GetElementValue("Status")+"&ReturnTypeDR="+GetElementValue("ReturnTypeDR");
	//window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=900,height=400,left=100,top=10');
	window.location.href=str;
}
document.body.onload = BodyLoadHandler;