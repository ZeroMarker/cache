function InitS380HandHyComWinEvent(obj){	
	layer.config({  
		extend: 'layerskin/style.css' 
	});
	$("#mCSB_2_container").css({"height":"99%"});
	// Ĭ�ϼ��ر����ļ�	
	ReportFrame = document.getElementById("reportFrame");
	p_URL = 'dhccpmrunqianreport.csp?reportName=DHCHAI.STAT.S380HandHyCom.raq&aLocID='+"" +'&aDateFrom=' + "" +'&aDateTo='+ "";	
	ReportFrame.src = p_URL;
	
	//��ѯ��ť
    $("#btnQuery").on('click', function(){
	    var aLocID  = $.form.GetValue("cboLoc");
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
		var threeFlag = checkThreeTime(DateFrom,DateTo);
		if(!threeFlag){
			layer.msg('��ѯ���ڼ�������������£�');
			return;
		}
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCHAI.STAT.S380HandHyCom.raq&aLocID='+aLocID +'&aDateFrom=' + DateFrom +'&aDateTo='+ DateTo;	
		ReportFrame.src = p_URL;
	});
}
