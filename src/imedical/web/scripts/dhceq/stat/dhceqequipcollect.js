function BFind_Clicked()
{
	var ReportFileName=jQuery("#ReportFileName").val();
	var lnk="";
	lnk=lnk+"&pItemDR="+GlobalObj.ItemDR;
	lnk=lnk+"&pEquipTypeDR="+GlobalObj.EquipTypeDR;
	lnk=lnk+"&pStatCatDR="+GlobalObj.StatCatDR;
	lnk=lnk+"&pTransSDate="+GetJQueryDate('#StartDate');
	lnk=lnk+"&pTransEDate="+GetJQueryDate('#EndDate');
	lnk=lnk+"&pUseLocDR="+GlobalObj.UseLocDR;
	lnk=lnk+"&pMinValue="+jQuery("#FromFee").val();
	lnk=lnk+"&pMaxValue="+jQuery("#ToFee").val();
	lnk=lnk+"&QXType="+jQuery("#QXType").val();
	lnk=lnk+"&pIncludeFlag="+jQuery("input[type='checkbox']").is(':checked');
	lnk=lnk+"&pFindAllFlag=1";
	var Elements="";
	var Elements2="";
	lnk=lnk+GetComboGridDesc(Elements,Elements2);
	document.getElementById('ReportFile').src="dhccpmrunqianreport.csp?reportName="+ReportFileName+lnk;
	document.getElementById('ReportFilePrint').src="dhccpmrunqianreport.csp?reportName="+ReportFileName+lnk+"&PrintFlag=1";
}