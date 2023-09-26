function BFind_Clicked()
{
	var ReportFileName=jQuery("#ReportFileName").val();
	var lnk="";
	lnk=lnk+"&pItemDR="+GlobalObj.ItemDR;      //modify by mwz 20171124   –Ë«Û∫≈468524
	lnk=lnk+"&pEquipCatDR="+GlobalObj.EquipCatDR;
	lnk=lnk+"&pEquipTypeDR="+GlobalObj.EquipTypeDR;
	lnk=lnk+"&pStatCatDR="+GlobalObj.StatCatDR;
	lnk=lnk+"&pUseLocDR="+GlobalObj.UseLocDR;
	lnk=lnk+"&pMinValue="+jQuery("#FromFee").val();
	lnk=lnk+"&pMaxValue="+jQuery("#ToFee").val();
	lnk=lnk+"&QXType="+jQuery("#QXType").val();
	lnk=lnk+"&pIncludeFlag="+jQuery("input[type='checkbox']").is(':checked');
	lnk=lnk+"&pFindAllFlag=1";
	var Elements="UseLoc^EquipCat^EquipType^StatCat";
	var Elements2="";
	lnk=lnk+GetComboGridDesc(Elements,Elements2);
	document.getElementById('ReportFile').src="dhccpmrunqianreport.csp?reportName="+ReportFileName+lnk;
	document.getElementById('ReportFilePrint').src="dhccpmrunqianreport.csp?reportName="+ReportFileName+lnk+"&PrintFlag=1";
}