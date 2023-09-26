function BFind_Clicked()
{
	var ReportFileName=jQuery("#ReportFileName").val();
	var lnk="";
	lnk=lnk+"&pMonthStr="+GetJQueryDate('#pMonthStr');
	lnk=lnk+"&pUseLocDR="+GlobalObj.UseLocDR;
	lnk=lnk+"&pEquipNo="+GlobalObj.EquipDR;
	lnk=lnk+"&pEquipTypeDR="+GlobalObj.EquipTypeDR;
	lnk=lnk+"&pFundsTypeDR="+GlobalObj.FundsTypeDR;
	lnk=lnk+"&pHosptailDR="+GlobalObj.HospitalDR;
	document.getElementById('ReportFile').src="dhccpmrunqianreport.csp?reportName="+ReportFileName+lnk;
	document.getElementById('ReportFilePrint').src="dhccpmrunqianreport.csp?reportName="+ReportFileName+lnk+"&PrintFlag=1";
}