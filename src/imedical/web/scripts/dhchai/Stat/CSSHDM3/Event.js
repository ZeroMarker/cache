function InitCSSHDM3WinEvent(obj){	
	layer.config({  
		extend: 'layerskin/style.css' 
	});
	$("#mCSB_2_container").css({"height":"99%"});
	// 默认加载报表文件	
	ReportFrame = document.getElementById("reportFrame");
	p_URL = 'dhccpmrunqianreport.csp?reportName=DHCHAI.HDMSta3W.raq&aSurNumID='+"";	
	ReportFrame.src = p_URL;
	
	//查询按钮
    $("#btnQuery").on('click', function(){
	    var aSurNumID  = $.form.GetValue("cboSurvNumber");
		if(aSurNumID==""){
			layer.msg('调查编号不能为空！');
			return;
		}
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCHAI.HDMSta3W.raq&aSurNumID='+aSurNumID;
		ReportFrame.src = p_URL;	
	});
}
