function BFind_Clicked()
{
	var ReportFileName=jQuery("#ReportFileName").val();
	var lnk="";
	lnk=lnk+"&MasterItemDR="+GlobalObj.ItemDR;
	lnk=lnk+"&EquipTypeDR="+GlobalObj.EquipTypeDR;
	lnk=lnk+"&StatCatDR="+GlobalObj.StatCatDR;
	lnk=lnk+"&EquipCatDR="+GlobalObj.EquipCatDR;
	lnk=lnk+"&UseLocDR="+GlobalObj.UseLocDR;
	lnk=lnk+"&BeginDate="+GetJQueryDate('#StartDate');
	lnk=lnk+"&EndDate="+GetJQueryDate('#EndDate');
	lnk=lnk+"&QXType="+jQuery("#QXType").val();
	lnk=lnk+"&DateFlag="+jQuery("input[type='checkbox']").is(':checked');
	var Elements="UseLoc^EquipType^StatCat^EquipCat";
	var Elements2="";
	lnk=lnk+GetComboGridDesc(Elements,Elements2);
	document.getElementById('ReportFile').src="dhccpmrunqianreport.csp?reportName="+ReportFileName+lnk;
	document.getElementById('ReportFilePrint').src="dhccpmrunqianreport.csp?reportName="+ReportFileName+lnk+"&PrintFlag=1";
}