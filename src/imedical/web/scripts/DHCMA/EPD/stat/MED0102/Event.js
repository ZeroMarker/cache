
function InitMED0102WinEvent(obj){
	// Ĭ�ϼ��ر����ļ�	
	ReportFrame = document.getElementById("reportFrame");
	p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMed.EPD.LocDiseasStat.raq&aHospIDs='+"" +'&aDateFrom=' + "" +'&aDateTo='+ "";	
	ReportFrame.src = p_URL;
	
	//��ѯ��ť
	$("#btnQuery").on('click',function(){
		var aHospID  = $("#cboHospital").combobox("getValue");
	    var DateFrom = $("#DateFrom").datebox("getValue");
		var DateTo 	 = $("#DateTo").datebox("getValue");		
		
		if ((DateFrom=="")||(DateTo=="")){
			$.messager.alert("������ʾ",'��ѡ��ʼ���ڡ��������ڣ�','info');
			return;
		}
		if(Common_CompareDate(DateFrom,DateTo)){
			$.messager.alert("������ʾ",'��ʼ����ӦС�ڻ���ڽ������ڣ�','info');
			return;
		}
		if(!checkThreeTime(DateFrom,DateTo)){
			$.messager.alert("������ʾ",'��ѯ���ڼ�������������£�','info');
			return;
		}
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMed.EPD.LocDiseasStat.raq&aHospIDs='+aHospID +'&aDateFrom=' + DateFrom +'&aDateTo='+ DateTo ;	
		ReportFrame.src = p_URL;
	});
		
}