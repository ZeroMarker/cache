function BFind_Clicked()
{
	var ReportFileName=jQuery("#ReportFileName").val();
	var lnk="";
	lnk=lnk+"&EquipID="+GlobalObj.BenifitEquipDR;   //modified by czf 388776
	lnk=lnk+"&EquipName="+jQuery("#BenifitEquip").val();
	lnk=lnk+"&UseLoc="+jQuery("#UseLoc").val();
	lnk=lnk+"&DCRate="+jQuery("#DCRate").val();
	lnk=lnk+"&UseLocDR="+GlobalObj.UseLocDR;
	lnk=lnk+"&QXType="+jQuery("#QXType").val();
	var Elements="UseLoc";
	var Elements2="";
	lnk=lnk+GetComboGridDesc(Elements,Elements2);
	document.getElementById('ReportFile').src="dhccpmrunqianreport.csp?reportName="+ReportFileName+lnk;
	document.getElementById('ReportFilePrint').src="dhccpmrunqianreport.csp?reportName="+ReportFileName+lnk+"&PrintFlag=1";
}