function BodyLoadHandler()
{
	initButtonWidth();		/// Mozy		888605	2019-5-21	Hisui����
	InitUserInfo();		
	InitPage();
	SetBtnEnable();
	SetStatus();
	KeyUp("Loc^BuyLoc","N")		//Add By DJ 2016-12-05
	Muilt_LookUp("Loc^BuyLoc");
	//SetTableRow();		/// Mozy		888605	2019-5-21	Hisui����
	SetBackGroupColor('tDHCEQAInStockFind');
}

function SetStatus()
{
	SetElement("Status",GetElementValue("GetStatus"))
}
function InitPage()
{
	KeyUp("Loc");
	// Mozy003003	1247088		2020-3-27	����������ť����¼�
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Clicked;
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
/*// Mozy		888605	2019-5-21	Hisui����
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
}*/
// Mozy		2019-10-08
function BAdd_Clicked()
{
	var url="dhceq.mp.instock.csp?"+"&Type="+GetElementValue("Type")+"&QXType="+GetElementValue("QXType")+"&WaitAD="+GetElementValue("WaitAD");
	showWindow(url,"�����ⵥ","","","icon-w-paper","modal","","","large"); //modify by lmm 2020-06-05 UI
}
document.body.onload = BodyLoadHandler;