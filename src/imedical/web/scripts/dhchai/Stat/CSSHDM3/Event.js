function InitCSSHDM3WinEvent(obj){	
	layer.config({  
		extend: 'layerskin/style.css' 
	});
	$("#mCSB_2_container").css({"height":"99%"});
	// Ĭ�ϼ��ر����ļ�	
	ReportFrame = document.getElementById("reportFrame");
	p_URL = 'dhccpmrunqianreport.csp?reportName=DHCHAI.HDMSta3W.raq&aSurNumID='+"";	
	ReportFrame.src = p_URL;
	
	//��ѯ��ť
    $("#btnQuery").on('click', function(){
	    var aSurNumID  = $.form.GetValue("cboSurvNumber");
		if(aSurNumID==""){
			layer.msg('�����Ų���Ϊ�գ�');
			return;
		}
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCHAI.HDMSta3W.raq&aSurNumID='+aSurNumID;
		ReportFrame.src = p_URL;	
	});
}
