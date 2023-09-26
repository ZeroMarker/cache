function BFind_Clicked()
{
	var ReportFileName=jQuery("#ReportFileName").val();
	var lnk="";
	lnk=lnk+"&StartDate="+GetJQueryDate('#StartDate');
	lnk=lnk+"&EndDate="+GetJQueryDate('#EndDate');
	lnk=lnk+"&QXType="+jQuery("#QXType").val();
	var Elements="";
	var Elements2="";
	lnk=lnk+GetComboGridDesc(Elements,Elements2);
	document.getElementById('ReportFile').src="dhccpmrunqianreport.csp?reportName="+ReportFileName+lnk;
	document.getElementById('ReportFilePrint').src="dhccpmrunqianreport.csp?reportName="+ReportFileName+lnk+"&PrintFlag=1";
}