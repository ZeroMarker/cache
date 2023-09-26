function BFind_Clicked()
{
	var ReportFileName=jQuery("#ReportFileName").val();
	var lnk="";
	lnk=lnk+"&EquipID="+GlobalObj.EquipDR;
	lnk=lnk+"&DCRate="+jQuery("#DCRate").val();
	lnk=lnk+"&UseLocDR="+GlobalObj.UseLocDR;
	lnk=lnk+"&QXType="+jQuery("#QXType").val();
	var Elements="Equip^UseLoc";
	var Elements2="";
	lnk=lnk+GetComboGridDesc(Elements,Elements2);
	document.getElementById('ReportFile').src="dhccpmrunqianreport.csp?reportName="+ReportFileName+lnk;
	document.getElementById('ReportFilePrint').src="dhccpmrunqianreport.csp?reportName="+ReportFileName+lnk+"&PrintFlag=1";
}