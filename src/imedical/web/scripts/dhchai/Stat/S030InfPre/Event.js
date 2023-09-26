function InitS030InfWinEvent(obj){	
	layer.config({  
		extend: 'layerskin/style.css' 
	});
	$("#mCSB_2_container").css({"height":"99%"});
	// 默认加载报表文件	
	ReportFrame = document.getElementById("reportFrame");
	p_URL = 'dhccpmrunqianreport.csp?reportName=DHCHAI.STAT.S030InfPre.raq&aHospIDs='+"" +'&aDateFrom=' + "" +'&aDateTo='+ "";	
	ReportFrame.src = p_URL;
	
	//查询按钮
    $("#btnQuery").on('click', function(){
	    var aHospID  = $.form.GetValue("cboHospital");
	    var DateFrom = $("#DateFrom").val();
		var DateTo 	 = $("#DateFrom").val();
		
		if (DateFrom==""){
			layer.msg('请选择调查日期！');
			return;
		}
		
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCHAI.STAT.S030InfPre.raq&aHospIDs='+aHospID +'&aDateFrom=' + DateFrom +'&aDateTo='+ DateTo;	
		ReportFrame.src = p_URL;
	});
}
