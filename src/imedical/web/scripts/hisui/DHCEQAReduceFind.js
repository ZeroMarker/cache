function BodyLoadHandler()
{
	initButtonWidth();	// Mozy	888605	2019-5-21	Hisui����
	InitUserInfo();
	InitPage();
	SetBEnable();
	SetStatus();
	//SetTableRow();	// Mozy	888605	2019-5-21	ע�;ɰ�˫���¼����½����¼�����
}
function SetStatus()
{
	SetElement("Status",GetElementValue("GetStatu"))
}
function InitPage()
{
	KeyUp("Loc^OutType^ToDept","N");
	Muilt_LookUp("Loc^OutType^ToDept");
	var obj=document.getElementById("BAdd");	// Mozy003003	1247088		2020-3-27	����������ť����¼�
	if (obj) obj.onclick=BAdd_Clicked;
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
// Mozy	888605	2019-5-21	ע�;ɰ�˫���¼����½����¼�����
/*
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
//  Mozy0236	2019-11-29	�������ҵ��(HisUi)		ע��˫���¼�
function DblClickRowHandler(rowIndex,rowData)
{
	if (rowData.TRowID>0)
	{
		//Mozy	2019-5-28	914623,914675	ȡ��Hisui���
		var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQAReduce&RowID="+rowData.TRowID+"&CurRole="+GetElementValue("ApproveRole")+"&QXType="+GetElementValue("QXType")+"&WaitAD="+GetElementValue("WaitAD")+"&Status="+GetElementValue("Status")+"&ReturnTypeDR="+GetElementValue("ReturnTypeDR");
		window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1100,height=600,left=100,top=10');
	}
}*/
function BAdd_Clicked()
{
	var url="dhceq.mp.reduce.csp?"+"&Type="+GetElementValue("Type")+"&QXType="+GetElementValue("QXType")+"&WaitAD="+GetElementValue("WaitAD");
	showWindow(url,"������ٵ�","","","icon-w-paper","modal","","","large"); //modify by lmm 2020-06-05 UI
}
document.body.onload = BodyLoadHandler;