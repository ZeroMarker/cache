function BFind_Clicked()
{
	var ReportFileName=jQuery("#ReportFileName").val();
	var lnk="";
	lnk=lnk+"&MonthStr="+GetJQueryDate("#MonthStr");
	lnk=lnk+"&UseLoc="+jQuery("#UseLoc").val();
	lnk=lnk+"&EquipType="+jQuery("#EquipType").val();
	lnk=lnk+"&UseLocDR="+GlobalObj.UseLocDR;
	lnk=lnk+"&EquipTypeDR="+GlobalObj.EquipTypeDR;
	lnk=lnk+"&QXType="+jQuery("#QXType").val();
	var Elements="" 
	var Elements2="";
	lnk=lnk+GetComboGridDesc(Elements,Elements2);
	document.getElementById('ReportFile').src="dhccpmrunqianreport.csp?reportName="+ReportFileName+lnk;
	document.getElementById('ReportFilePrint').src="dhccpmrunqianreport.csp?reportName="+ReportFileName+lnk+"&PrintFlag=1";
}