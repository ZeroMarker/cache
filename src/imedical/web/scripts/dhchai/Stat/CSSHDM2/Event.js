function InitCSSHDM2WinEvent(obj){	
	layer.config({  
		extend: 'layerskin/style.css' 
	});
	$("#mCSB_2_container").css({"height":"99%"});
	// Ĭ�ϼ��ر����ļ�	
	ReportFrame = document.getElementById("reportFrame");
	p_URL = 'dhccpmrunqianreport.csp?reportName=DHCHAI.HDMSta2W.raq&aSurNumID='+"" +'&aInfTypeStr=' + "" +'&aLocType='+ "";	
	ReportFrame.src = p_URL;
	
	//��ѯ��ť
    $("#btnQuery").on('click', function(){
	    var aSurNumID  = $.form.GetValue("cboSurvNumber");
	    var aInfTypeStr = $.form.GetText("cboInfType");
		var StatType = $("#cboStatType").val();
		if(aSurNumID==""){
			layer.msg('�����Ų���Ϊ�գ�');
			return;
		}
		if (StatType==1){  // ������ͳ��
			p_URL = 'dhccpmrunqianreport.csp?reportName=DHCHAI.HDMSta2.raq&aSurNumID='+aSurNumID +'&aInfTypeStr=' + aInfTypeStr +'&aLocType='+ "E";	
			ReportFrame.src = p_URL;	
		}else{
			p_URL = 'dhccpmrunqianreport.csp?reportName=DHCHAI.HDMSta2W.raq&aSurNumID='+aSurNumID +'&aInfTypeStr=' + aInfTypeStr +'&aLocType='+ "W";	
			ReportFrame.src = p_URL;
		}
	});
}
