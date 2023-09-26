function BFind_Clicked()
{
	var ReportFileName=jQuery("#ReportFileName").val();
	var lnk="";
	lnk=lnk+"&EquipCatDR="+GlobalObj.EquipCatDR;
	lnk=lnk+"&EquipTypeDR="+GlobalObj.EquipTypeDR;
	lnk=lnk+"&UseLocDR="+GlobalObj.UseLocDR;
	lnk=lnk+"&MinValue="+jQuery("#FromFee").val();
	lnk=lnk+"&MaxValue="+jQuery("#ToFee").val();
	lnk=lnk+"&QXType="+jQuery("#QXType").val();
	var Elements="UseLoc^EquipCat^EquipType";
	var Elements2="";
	lnk=lnk+GetComboGridDesc(Elements,Elements2);
	document.getElementById('ReportFile').src="dhccpmrunqianreport.csp?reportName="+ReportFileName+lnk;
	document.getElementById('ReportFilePrint').src="dhccpmrunqianreport.csp?reportName="+ReportFileName+lnk+"&PrintFlag=1";
}