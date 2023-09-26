function BodyLoadHandler()
{
	///alertShow('a');		
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
	KeyUp("EquipType^StatCat^UseLoc");
}

function BDepre_Clicked()
{
	var encmeth=GetElementValue("GetCurMonthDepre");
	var rtn=cspRunServerMethod(encmeth);
	if (rtn=="")
	{	alertShow(t['01']);}
	else
	{	alertShow(rtn)}
	
}

function BPrint_Clicked()
{
	///元素?GetRepPath?GetReportData
	///
	var templateName="DHCEQDepreList.xls";
	var isSave=1;
	var Job=GetElementValue("TJobz1");
	var savefilename=GetFileName();
	///locdesc_"^"_equiptypedesc_"^"_deprefee
	var colset="1:50^2:51^3:49^4:39^5:5^6:52^7:10^8:14^9:17^10:48^11:31^12:53";///列x1:输出结果第y1位^列x2:输出结果第y2位.....
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
// Mozy0024
function GetReportData(num)
{
	var encmeth=GetElementValue("GetReportData");
	var Job=GetElementValue("TJobz1");
	var rtn=cspRunServerMethod(encmeth,num,Job);
	return rtn;
}
// MR0009
function GetEquipType (value)
{
    GetLookUpID("EquipTypeDR",value);
}
function GetStatCat(value)
{
	GetLookUpID("StatCatDR",value);
}
function GetFundsType(value) // ItemDR
{
	var obj=document.getElementById("FundsTypeDR");
	var val=value.split("^");
	if (obj) obj.value=val[1];
}
document.body.onload = BodyLoadHandler;