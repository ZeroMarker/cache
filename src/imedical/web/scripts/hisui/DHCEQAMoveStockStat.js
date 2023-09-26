///�޸ĺ���BPrint_Click
///����:����ʱ����·�������� 
/// -------------------------------
/// �޸�����:���Ӻ���MovType
/// ��������:�޸��豸ת�����͵�ʱ��??���������Һͽ��ܿ��Ҵ��ݲ�ͬ�Ŀ������Ͳ���
/// --------------------------------
function BodyLoadHandler()
{	
	initButtonWidth();		/// Mozy		888605	2019-5-21	Hisui����
	InitPage();	
	SetStatus();
	Muilt_LookUp("FromLoc^ToLoc^AccessoryType^Reciver"); //add by mwz 20181029 �����668448
	SetElement("MoveType",GetElementValue("MoveTypeID"));
	fillData();
	RefreshData();
	//SetTableRow();		/// Mozy		888605	2019-5-21	Hisui����
}

function SetStatus()
{
	SetElement("Status",GetElementValue("StatusDR"))
}
function InitPage()
{
	KeyUp("FromLoc^ToLoc^AccessoryType^Reciver"); //add by mwz 20181029 �����668448
	var obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_Click;
	var obj=document.getElementById("MoveType");
	if (obj) obj.onchange=MoveType;

	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
	var obj=document.getElementById("BClear");		//Mozy	984437	2019-8-5
	if (obj) obj.onclick=BClear_Click;
}

/// ����:zy 2009-07-15 BugNo.ZY0007
/// ��������??oveType
/// ����:�޸��豸ת�����͵�ʱ��??���������Һͽ��ܿ��Ҵ��ݲ�ͬ�Ŀ������Ͳ���
/// -------------------------------
function MoveType()
{
	var value=GetElementValue("MoveType")
	if (value==0)
	{
		SetElement("FromLocType",1);
		SetElement("ToLocType","");
	}else if (value==2)
	{
		SetElement("FromLocType","");
		SetElement("ToLocType",1);
	}else
	{
		SetElement("FromLocType","");
		SetElement("ToLocType","");
	}
}

function GetFromLoc(value)
{
	GetLookUpID("FromLocDR",value);
}

function GetToLoc(value)
{
	GetLookUpID("ToLocDR",value);
}
function GetAccessoryType(value)
{
	GetLookUpID("AccessoryTypeDR",value);
}
//201702-04	Mozy
function GetReciver(value)
{
    GetLookUpID("ReciverDR",value);
}
function BPrint_Click()
{
	///Ԫ��?GetRepPath?GetReportData
	var templateName="DHCEQAMoveStockStat.xls";
	var isSave=1;
	var savefilename=GetFileName();
	///locdesc_"^"_AccessoryTypedesc_"^"_deprefee
	//var colset="1:1^2:2^3:0^4:3";///��x1:��������y1λ^��x2:��������y2λ.....
	//var colset="1:4^2:0^3:5^4:6^5:2^6:9^7:10^8:11^9:10^10:13^11:14";///��x1:��������y1λ^��x2:��������y2λ.....
	var colset="1:0^2:1^3:2^4:3^5:4^6:5^7:6^8:7";///��x1:��������y1λ^��x2:��������y2λ.....
	PrintEQReport(templateName,isSave,savefilename,colset);

}

function PrintEQReportHeader(xlsheet)
{
	var row=2;
	xlsheet.cells(row,1)="��ʼ����:"+GetElementValue("StartDate");
	xlsheet.cells(row,3)="��������:"+GetElementValue("EndDate");
	row=row+1;
	return row;
}

function GetReportData(num)
{
	var ObjTJob=document.getElementById("TJobz1");
	if (ObjTJob)  TJob=ObjTJob.value;
	if (TJob=="")  return;
	var encmeth=GetElementValue("GetOneStoreMoveStat");
	var rtn=cspRunServerMethod(encmeth,num,TJob);
	return rtn;
}

function PrintEQReportFooter(xlsheet,row)
{
	///���һ����Ӵ���
}

function BFind_Click()
{
	var val="&vData="
	val=val+GetVData();
	window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQAMoveStockStat"+val;
}

function RefreshData()
{
	var vdata1=GetElementValue("vData");
	var vdata2=GetVData();
	if (vdata1!=vdata2) BFind_Click();
}

function GetVData()
{
	var	val="^FromLocDR="+GetElementValue("FromLocDR");
	val=val+"^ToLocDR="+GetElementValue("ToLocDR");
	val=val+"^Status="+GetElementValue("Status");
	val=val+"^MoveType="+GetElementValue("MoveType");
	val=val+"^StartDate="+GetElementValue("StartDate");
	val=val+"^EndDate="+GetElementValue("EndDate");
	val=val+"^Name="+GetElementValue("Name");
	val=val+"^AccessoryTypeDR="+GetElementValue("AccessoryTypeDR");
	val=val+"^StoreMoveNo="+GetElementValue("StoreMoveNo");
	val=val+"^ShortDesc="+GetElementValue("ShortDesc");
	val=val+"^FileNo="+GetElementValue("FileNo");
	val=val+"^ReciverDR="+GetElementValue("ReciverDR");
	return val;
}

function fillData()
{
	var vData=GetElementValue("vData")
	if (vData!="")
	{
		var list=vData.split("^");
		for (var i=1; i<list.length; i++)
		{
			Detail=list[i].split("=");
			switch (Detail[0])
			{
				default :
					SetElement(Detail[0],Detail[1]);
					break;
			}
		}
	}
	var val="";
	val=val+"dept=FromLoc="+GetElementValue("FromLocDR")+"^";
	val=val+"dept=ToLoc="+GetElementValue("ToLocDR")+"^";
	val=val+"AccessoryType=AccessoryType="+GetElementValue("AccessoryTypeDR")+"^";
	val=val+"user=Reciver="+GetElementValue("ReciverDR")+"^";
	var encmeth=GetElementValue("GetDRDesc");
	var result=cspRunServerMethod(encmeth,val);
	var list=result.split("^");
	for (var i=1; i<list.length; i++)
	{
		var Detail=list[i-1].split("=");
		SetElement(Detail[0],Detail[1]);
	}
}
/*// Mozy		888605	2019-5-21	Hisui����
function SetTableRow()
{
	var objtbl=document.getElementById("tDHCEQAMoveStockStat");
	var rows=objtbl.rows.length-1;
	for (var i=1;i<=rows;i++)
	{
		objtbl.rows[i].ondblclick=RowDblClick;
	}
}
function RowDblClick()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById("tDHCEQAMoveStockStat");
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (selectrow==1)  return;   //add by mwz 20180929 �����666265
	//alertShow(selectrow)
	var str="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQAMoveStock&RowID="+GetElementValue("TRowIDz"+selectrow)+"&CurRole="+GetElementValue("ApproveRole")+"&Type="+GetElementValue("Type")+"&WaitAD="+GetElementValue("WaitAD");
	window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=900,height=400,left=100,top=10');
	//window.location.href=str;
}*/

function DblClickRowHandler(rowIndex,rowData)
{
	if (rowData.TRowID>0)
	{
		// Mozy0229		2019-10-28
		var url="dhceq.mp.storemove.csp?&ReadOnly=1&RowID="+rowData.TRowID+"&Type="+GetElementValue("Type")+"&WaitAD="+GetElementValue("WaitAD");
		showWindow(url,"���ת�Ƶ�","","","icon-w-paper","modal","","","large"); //modify by lmm 2020-06-05 UI
	}
}
//Mozy	984437	2019-8-5
function BClear_Click()
{
	SetElement("StoreMoveNo","");
	SetElement("Name","");
	SetElement("AccessoryType","");
	SetElement("AccessoryTypeDR","");
	SetElement("StartDate","");
	SetElement("EndDate","");
	SetElement("MoveType","");
	SetElement("MoveTypeID","");
	SetElement("FromLoc","");
	SetElement("FromLocDR","");
	SetElement("ToLoc","");
	SetElement("ToLocDR","");
	SetElement("ShortDesc","");
	SetElement("Reciver","");
	SetElement("ReciverDR","");
	SetElement("StatusDR","");
	SetElement("Status","");
}
document.body.onload = BodyLoadHandler;
