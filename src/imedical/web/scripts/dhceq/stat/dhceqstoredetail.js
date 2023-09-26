function BFind_Clicked()
{
	var ReportFileName=jQuery("#ReportFileName").val();
	var lnk="&BussType="+jQuery("#BussType").combobox("getValue");
	lnk=lnk+"&vStartDate="+jQuery('#StartDate').datebox('getText');  // 解决日期控件不能点击X清空编辑框内容 "getValue"不能清空
	lnk=lnk+"&vEndDate="+jQuery('#EndDate').datebox('getText');
	lnk=lnk+"&QXType="+jQuery("#QXType").val();
	document.getElementById('ReportFile').src="dhccpmrunqianreport.csp?reportName="+ReportFileName+lnk;
	document.getElementById('ReportFilePrint').src="dhccpmrunqianreport.csp?reportName="+ReportFileName+lnk+"&PrintFlag=1";
}