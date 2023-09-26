function BodyLoadHandler()
{		
	InitPage();
	KeyUp("FundsType","N");	//清空选择
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
	var EquipTypeIDS=GetElementValue("EquipTypeIDS") //2009-07-21 党军
	var rtn=cspRunServerMethod(encmeth,"","",EquipTypeIDS); //2009-07-21 党军
	if (rtn=="")
	{	alertShow(t['01']);}
	else
	{	alertShow(rtn)}
	
}

function BPrint_Clicked()
{
	///元素?GetRepPath?GetReportData
	///
	var templateName="DHCEQDepreLoc.xls";
	var isSave=1;
	var savefilename="d:\\dhceqdepreloc.xls";
	///locdesc_"^"_equiptypedesc_"^"_deprefee
	var colset="1:1^2:2^3:0^4:3";///列x1:输出结果第y1位^列x2:输出结果第y2位.....
	PrintEQReport(templateName,isSave,savefilename,colset);
}

function PrintEQReportHeader(xlsheet)
{
	var row=2;	
	xlsheet.cells(row,1)="统计时间:"+GetElementValue("BeginDate")+"---"+GetElementValue("EndDate");
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
