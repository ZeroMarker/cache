function InitS800CssPosInfWinEvent(obj){	
	layer.config({  
		extend: 'layerskin/style.css' 
	});
	$("#mCSB_2_container").css({"height":"99%"});
	// Ĭ�ϼ��ر����ļ�	
	ReportFrame = document.getElementById("reportFrame");
	//����ϵͳ����ȡ��ͬչʾ����ģʽ 1 =����
	var retval = $.Tool.RunServerMethod("DHCHAI.BT.Config","GetValByCode","StatLocModel");	
	if(retval=="2"){
		//obj.repName = "";
	}
	p_URL = 'dhccpmrunqianreport.csp?reportName='+obj.repName+'&aSurNumID=' + "";	
	ReportFrame.src = p_URL;
	
	//��ѯ��ť
    $("#btnQuery").on('click', function(){
	    var aHospID  = $.form.GetValue("cboHospital");
	    var aSurNum =$.form.GetText("cboSurvNumber");;
		var aSurNumID = $.form.GetValue("cboSurvNumber");;
		
		if (aSurNumID==""){
			layer.msg('��ѡ������ţ�');
			return;
		}
		
		p_URL = 'dhccpmrunqianreport.csp?reportName='+obj.repName+'&aSurNumID='+ aSurNumID;	
		ReportFrame.src = p_URL;
	});
}
