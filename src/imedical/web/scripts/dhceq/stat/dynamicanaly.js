function BFind_Clicked()
{
	var ReportFileName=jQuery("#ReportFileName").val();
	var lnk="";
	lnk=lnk+"&EquipID="+GlobalObj.BenifitEquipDR;
	lnk=lnk+"&UseLocDR="+GlobalObj.UseLocDR;
	lnk=lnk+"&StartDate="+GetJQueryDate('#SMonthStr');
	lnk=lnk+"&EndDate="+GetJQueryDate('#EMonthStr');
	lnk=lnk+"&DCRate="+jQuery("#DCRate").val();
	lnk=lnk+"&QXType="+jQuery("#QXType").val();
	var Elements="";
	var Elements2="";
	lnk=lnk+GetComboGridDesc(Elements,Elements2);
	document.getElementById('ReportFile').src="dhccpmrunqianreport.csp?reportName="+ReportFileName+lnk;
	document.getElementById('ReportFilePrint').src="dhccpmrunqianreport.csp?reportName="+ReportFileName+lnk+"&PrintFlag=1";
}