function BodyLoadHandler()
{		
	InitPage();
	KeyUp("FundsType","N");	//���ѡ��
	Muilt_LookUp("FundsType");
}

function InitPage()
{
	var obj=document.getElementById("BDepre");
	if (obj) obj.onclick=BDepre_Clicked;
	var obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_Clicked;
}

function BDepre_Clicked()
{
	var encmeth=GetElementValue("GetCurMonthDepre");
	var EquipTypeIDS=GetElementValue("EquipTypeIDS") //2009-07-21 ����
	var rtn=cspRunServerMethod(encmeth,"","",EquipTypeIDS); //2009-07-21 ����
	if (rtn=="")
	{	alertShow(t['01']);}
	else
	{	alertShow(rtn)}
	
}

function BPrint_Clicked()
{
	///Ԫ��?GetRepPath?GetReportData
	///
	var templateName="DHCEQDepreLoc.xls";
	var isSave=1;
	var savefilename="d:\\dhceqdepreloc.xls";
	///locdesc_"^"_equiptypedesc_"^"_deprefee
	var colset="1:1^2:2^3:0^4:3";///��x1:��������y1λ^��x2:��������y2λ.....
	PrintEQReport(templateName,isSave,savefilename,colset);
}

function PrintEQReportHeader(xlsheet)
{
	var row=2;	
	xlsheet.cells(row,1)="ͳ��ʱ��:"+GetElementValue("BeginDate")+"---"+GetElementValue("EndDate");
	row=row+1;
	return row;
}

function PrintEQReportFooter(xlsheet,row)
{
}

function GetReportData(num)
{
	var encmeth=GetElementValue("GetReportData");
	var rtn=cspRunServerMethod(encmeth,num);
	return rtn;
}
function GetFundsType(value) // ItemDR
{
	var obj=document.getElementById("FundsTypeDR");
	var val=value.split("^");
	if (obj) obj.value=val[1];
}
document.body.onload = BodyLoadHandler;
