function BFind_Clicked()
{
	var ReportFileName=jQuery("#ReportFileName").val();
	var lnk="";
	lnk=lnk+"&pEquipDR="+GlobalObj.EquipDR;
	lnk=lnk+"&pEquipNo=";
	lnk=lnk+"&pEquipName=";
	lnk=lnk+"&pModelDR="+GlobalObj.ModelDR;
	lnk=lnk+"&pEquipTypeDR="+GlobalObj.EquipTypeDR;
	lnk=lnk+"&pStatCatDR="+GlobalObj.StatCatDR;
	lnk=lnk+"&pEquipCatDR="+GlobalObj.EquipCatDR;
	lnk=lnk+"&pTransSDate="+jQuery('#StartDate').datebox('getText');  //Modified by HHM 2016-01-15 解决日期控件不能点击X清空编辑框内容 "getValue"不能清空
	lnk=lnk+"&pTransEDate="+jQuery('#EndDate').datebox('getText');    //Modified by HHM 2016-01-15
	lnk=lnk+"&pProviderDR="+GlobalObj.ProviderDR;
	lnk=lnk+"&QXType="+jQuery("#QXType").val();
	lnk=lnk+"&pFindAllFlag=1";
	var Elements="";
	var Elements2="";
	lnk=lnk+GetComboGridDesc(Elements,Elements2);
	document.getElementById('ReportFile').src="dhccpmrunqianreport.csp?reportName="+ReportFileName+lnk;
	document.getElementById('ReportFilePrint').src="dhccpmrunqianreport.csp?reportName="+ReportFileName+lnk+"&PrintFlag=1";
}