/***************************************按钮调用函数*****************************************************/
function BFind_Clicked()
{
	var ReportFileName=jQuery("#ReportFileName").val();
	var lnk="";
	lnk=lnk+"&AcceptStartDate="+GetJQueryDate('#StartDate');
	lnk=lnk+"&AcceptEndDate="+GetJQueryDate('#EndDate');
	lnk=lnk+"&SendUser="+GlobalObj.EQUserDR;
	//messageShow("","","",lnk)
	
	var Elements="";
	var Elements2="";
	lnk=lnk+GetComboGridDesc(Elements,Elements2);
	document.getElementById('ReportFile').src="dhccpmrunqianreport.csp?reportName="+ReportFileName+lnk;
	document.getElementById('ReportFilePrint').src="dhccpmrunqianreport.csp?reportName="+ReportFileName+lnk+"&PrintFlag=1";
}
