function BFind_Clicked()
{
	var ReportFileName=jQuery("#ReportFileName").val();
	var lnk="";
	lnk=lnk+"&StartMonth="+GetJQueryDate('#SMonthStr');
	lnk=lnk+"&EndMonth="+GetJQueryDate('#EMonthStr');
	lnk=lnk+"&QXType="+jQuery("#QXType").val();
	document.getElementById('ReportFile').src="dhccpmrunqianreport.csp?reportName="+ReportFileName+lnk;
	document.getElementById('ReportFilePrint').src="dhccpmrunqianreport.csp?reportName="+ReportFileName+lnk+"&PrintFlag=1";
}