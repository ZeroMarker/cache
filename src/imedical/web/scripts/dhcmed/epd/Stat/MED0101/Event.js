function InitMED0101WinEvent(obj){	
	layer.config({  
		extend: 'layerskin/style.css' 
	});
	$("#mCSB_2_container").css({"height":"99%"});
	// Ĭ�ϼ��ر����ļ�	
	ReportFrame = document.getElementById("reportFrame");
	p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMed.EPD.OPAdmLog.raq&aHospIDs='+"" +'&aDateFrom=' + "" +'&aDateTo='+ "";	
	ReportFrame.src = p_URL;
	
	//��ѯ��ť
    $("#btnQuery").on('click', function(){
	    var aHospID  = $.form.GetValue("cboHospital");
	    var DateFrom = $("#DateFrom").val();
		var DateTo 	 = $("#DateTo").val();		
		var LocID 	 = $.form.GetValue("cboLocation");
		var PapmiNo	 = $("#txtPapmiNo").val();
		var MrNo	 = $("#txtMrNo").val();
		var PatName	 = $("#txtPatName").val();
		var Diagnos	 = $("#txtDiagnos").val();
		var User=$.LOGON.USERDESC;
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
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMed.EPD.OPAdmLog.raq&aHospIDs='+aHospID +'&aDateFrom=' + DateFrom +'&aDateTo='+ DateTo +'&aLoc='+ LocID+'&aPapmi='+ PapmiNo+'&aMrNo='+ MrNo +'&aName='+ PatName +'&aDiagnos='+ Diagnos+'&aUserName='+User;	
		ReportFrame.src = p_URL;
	});
}
