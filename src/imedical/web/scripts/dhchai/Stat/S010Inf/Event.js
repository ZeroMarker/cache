function InitS010InfWinEvent(obj){	
	layer.config({  
		extend: 'layerskin/style.css' 
	});
	$("#mCSB_2_container").css({"height":"99%"});
	// 默认加载报表文件	
	ReportFrame = document.getElementById("reportFrame");
	p_URL = 'dhccpmrunqianreport.csp?reportName=DHCHAI.STAT.S010Inf.raq&aHospIDs='+"" +'&aDateFrom=' + "" +'&aDateTo='+ "";	
	ReportFrame.src = p_URL;
	
	//查询按钮
    $("#btnQuery").on('click', function(){
	    var aHospID  = $.form.GetValue("cboHospital");
	    var DateFrom = $("#DateFrom").val();
		var DateTo 	 = $("#DateTo").val();
		if(DateFrom > DateTo){
			layer.msg('开始日期应小于或等于结束日期！');
			return;
		}
		if ((DateFrom=="")||(DateTo=="")){
			layer.msg('请选择开始日期、结束日期！');
			return;
		}
		var threeFlag = checkThreeTime(DateFrom,DateTo);
		if(!threeFlag){
			layer.msg('查询日期间隔超过了三个月！');
			return;
		}
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCHAI.STAT.S010Inf.raq&aHospIDs='+aHospID +'&aDateFrom=' + DateFrom +'&aDateTo='+ DateTo;	
		ReportFrame.src = p_URL;
	});
}
