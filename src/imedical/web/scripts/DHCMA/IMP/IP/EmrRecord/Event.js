function InitReportWinEvent(obj) {
	// 默认加载报表文件
	ReportFrame = document.getElementById("reportFrame");
	//p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMAIMPQueryRecord.raq&aHospID='+2+'&aDateFrom=' + "" +'&aDateTo='+ "";	
	p_URL = cspUrl+'&PatientID=' + PatientID+'&EpisodeID='+EpisodeID + '&DefaultOrderPriorType=ALL&2=2';
	if(!ReportFrame.src){
		ReportFrame.frameElement.src=p_URL;
	}else{
		ReportFrame.src = p_URL;
	}
	
}


