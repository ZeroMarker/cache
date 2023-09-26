/// DHCEQAMoveStockFind.js
var tmpRowIDs="";	// Mozy003006		2020-04-03
function BodyLoadHandler()
{
	initButtonWidth();		/// Mozy		888605	2019-5-21	Hisui����
	InitUserInfo();	
	InitPage();	
	SetBEnable();
	SetStatus();
	SetElement("MoveType",GetElementValue("MoveTypeID"));
	//SetTableRow();		/// Mozy		888605	2019-5-21	Hisui����
	SetBackGroupColor('tDHCEQAMoveStockFind');
}

function SetStatus()
{
	SetElement("Status",GetElementValue("GetStatu"));
}
function InitPage()
{
	KeyUp("FromLoc^ToLoc");
	Muilt_LookUp("FromLoc^ToLoc");
	var obj=document.getElementById("MoveType");
	if (obj) obj.onchange=MoveType;
	var obj=document.getElementById("BBatchOpt");
	if (obj) obj.onclick=BBatchOpt_Clicked;
	var obj=document.getElementById("SelectAll");
	if (obj) obj.onclick=SelectAll_Clicked;
	var obj=document.getElementById("BAdd");	// Mozy003003	1247088		2020-3-27	����������ť����¼�
	if (obj) obj.onclick=BAdd_Clicked;
}
function GetFromLoc(value)
{
	GetLookUpID("FromLocDR",value);
}
function GetToLoc(value)
{
	GetLookUpID("ToLocDR",value);
}
function SetBEnable()
{
	var WaitAD=GetElementValue("WaitAD");
	if (WaitAD!="off")
	{
		DisableBElement("BAdd",true);
	}
}

/// ����:�޸��豸ת�����͵�ʱ��,���������Һͽ��ܿ��Ҵ��ݲ�ͬ�Ŀ������Ͳ���
function MoveType()
{
	var value=GetElementValue("MoveType")
	if (value=="0")
	{
		SetElement("FromLocType","0101");
		SetElement("ToLocType","0102");
	}else if (value=="3")
	{
		SetElement("FromLocType","0102");
		SetElement("ToLocType","0101");
	}else
	{
		SetElement("FromLocType","0102");
		SetElement("ToLocType","0102");
	}
}
/*// Mozy		888605	2019-5-21	Hisui����
function SetTableRow()
{
	var objtbl=document.getElementById("tDHCEQAMoveStockFind");
	var rows=objtbl.rows.length-1;
	for (var i=1;i<=rows;i++)
	{
		objtbl.rows[i].ondblclick=RowDblClick;
	}
}
function RowDblClick()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById("tDHCEQAMoveStockFind");
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	//alertShow(selectrow)
	var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQAMoveStock&RowID="+GetElementValue("TRowIDz"+selectrow)+"&CurRole="+GetElementValue("ApproveRole")+"&Type="+GetElementValue("Type")+"&WaitAD="+GetElementValue("WaitAD")+"&QXType="+GetElementValue("QXType");
	//window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=900,height=400,left=100,top=10');
	window.location.href=str;
}*/
function BBatchOpt_Clicked()
{
	var count=0;
	var valRowIDs="";
	var objtbl=document.getElementById("tDHCEQAMoveStockFind");
	var rows=objtbl.rows.length;
	for (var i=1;i<rows;i++)
	{
		var id=GetElementValue("TRowIDz"+i);
		var Chk=GetChkElementValue("TChkz"+i);
		if ((Chk)&&(id!="")&&(GetElementValue("TMoveTypez"+i)=="����"))
		{
			count=count+1;
			if (valRowIDs!="") valRowIDs=valRowIDs+",";
			valRowIDs=valRowIDs+GetElementValue("TRowIDz"+i);
		}
	}
	if (valRowIDs=="")
	{
		alertShow("δѡ����Ч��ӡ��.");
		return;
	}
	//alertShow(valRowIDs)
	if (count>0)
	{
		// Mozy003006		2020-04-03
		tmpRowIDs=valRowIDs;
		messageShow("confirm","","","���Ե�ǰ�б� "+count+" �ų��ⵥ������������,ȷ��ִ����?","",ConfirmOpt,DisConfirmOpt);
	}
	else
	{	alertShow("�޴������ĳ��ⵥ!");	}
}
// Mozy003006		2020-04-03
function ConfirmOpt()
{
	var encmeth=GetElementValue("Execute")
	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,tmpRowIDs);
	if (Rtn>0)
	{
		 alertShow("ִ�гɹ�!")
		 location.reload();
	}
	else
	{
		alertShow("ִ��ʧ��!")
	}
}
function DisConfirmOpt()
{
}
function SelectAll_Clicked()
{
	var obj=document.getElementById("SelectAll");
	var Objtbl=document.getElementById('tDHCEQAMoveStockFind');
	var Rows=Objtbl.rows.length;
	for (var i=1;i<Rows;i++)
	{
		if (GetElementValue("TMoveTypez"+i)=="����")
		{
			var selobj=document.getElementById('TChkz'+i);
			selobj.checked=obj.checked;
		}
	}
}
// Mozy0229		2019-10-28
function BAdd_Clicked()
{
	var url="dhceq.mp.storemove.csp?"+"&Type="+GetElementValue("Type")+"&QXType="+GetElementValue("QXType")+"&WaitAD="+GetElementValue("WaitAD");
	showWindow(url,"���ת�Ƶ�","","","icon-w-paper","modal","","","large"); //modify by lmm 2020-06-05 UI
}
document.body.onload = BodyLoadHandler;