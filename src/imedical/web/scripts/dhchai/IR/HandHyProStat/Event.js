function InitCCSWorkWinEvent(obj){	
	layer.config({  
		extend: 'layerskin/style.css' 
	});
	$("#mCSB_2_container").css({"height":"99%"});
	// Ĭ�ϼ��ر����ļ�	
	ReportFrame = document.getElementById("reportFrame");
	p_URL = 'dhccpmrunqianreport.csp?reportName=DHCHAI.IR.HandHyProStat.raq&aHospID='+"" +'&aFromDate=' + "" +'&aToDate='+ "";	
	ReportFrame.src = p_URL;
	
	//��ѯ��ť
    $("#btnQuery").on('click', function(){
	    var aHospID  = $.form.GetValue("cboHospital");
	    var DateFrom = $("#DateFrom").val();
		var DateTo 	 = $("#DateTo").val();
		if(DateFrom > DateTo){
			layer.msg('��ʼ����ӦС�ڻ���ڽ������ڣ�');
			return;
		}
		if ((DateFrom=="")||(DateTo=="")){
			layer.msg('��ѡ��ʼ���ڡ��������ڣ�');
			return;
		}
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCHAI.IR.HandHyProStat.raq&aHospID='+aHospID +'&aFromDate=' + DateFrom +'&aToDate='+ DateTo;	
		ReportFrame.src = p_URL;
	});
}