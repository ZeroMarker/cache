function InitCSSHDM4WinEvent(obj){	
	layer.config({  
		extend: 'layerskin/style.css' 
	});
	$("#mCSB_2_container").css({"height":"99%"});
	// 默认加载报表文件	
	ReportFrame = document.getElementById("reportFrame");
	p_URL = 'dhccpmrunqianreport.csp?reportName=DHCHAI.HDMSta4W.raq&aSurNumID='+"" +'&aInfTypeStr=' + "" +'&aLocType='+ ""+'&aLocDr='+"";	
	ReportFrame.src = p_URL;
	
	//查询按钮
    $("#btnQuery").on('click', function(){
	    var aSurNumID  = $.form.GetValue("cboSurvNumber");
	    var aInfTypeStr = $.form.GetText("cboInfType");
		var StatType = $("#cboStatType").val();
		var aLocDr = $.form.GetValue("cboLocation");
		if(aSurNumID==""){
			layer.msg('调查编号不能为空！');
			return;
		}
		if (StatType==1){  // 按科室统计
			p_URL = 'dhccpmrunqianreport.csp?reportName=DHCHAI.HDMSta4.raq&aSurNumID='+aSurNumID +'&aInfTypeStr=' + aInfTypeStr +'&aLocType='+ "E"+'&aLocDr='+aLocDr;
			ReportFrame.src = p_URL;	
		}else{
			p_URL = 'dhccpmrunqianreport.csp?reportName=DHCHAI.HDMSta4W.raq&aSurNumID='+aSurNumID +'&aInfTypeStr=' + aInfTypeStr +'&aLocType='+ "W"+'&aLocDr='+aLocDr;	
			ReportFrame.src = p_URL;
		}
	});
}
