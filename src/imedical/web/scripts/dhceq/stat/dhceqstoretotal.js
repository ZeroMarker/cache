function BFind_Clicked()
{
	var ReportFileName=jQuery("#ReportFileName").val();
	var lnk="&BussType="+jQuery("#BussType").combobox("getValue");
	lnk=lnk+"&vStartDate="+jQuery('#StartDate').datebox('getText');  // ������ڿؼ����ܵ��X��ձ༭������ "getValue"�������
	lnk=lnk+"&vEndDate="+jQuery('#EndDate').datebox('getText');
	lnk=lnk+"&QXType="+jQuery("#QXType").val();
	document.getElementById('ReportFile').src="dhccpmrunqianreport.csp?reportName="+ReportFileName+lnk;
	document.getElementById('ReportFilePrint').src="dhccpmrunqianreport.csp?reportName="+ReportFileName+lnk+"&PrintFlag=1";
}