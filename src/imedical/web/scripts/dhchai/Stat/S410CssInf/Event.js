function InitS410CssInfWinEvent(obj){	
	layer.config({  
		extend: 'layerskin/style.css' 
	});
	$("#mCSB_2_container").css({"height":"99%"});
	// Ĭ�ϼ��ر����ļ�	
	ReportFrame = document.getElementById("reportFrame");
	//����ϵͳ����ȡ��ͬչʾ����ģʽ 1 =����
	var retval = $.Tool.RunServerMethod("DHCHAI.BT.Config","GetValByCode","StatLocModel");	
	if(retval=="2"){
		obj.repName = "DHCHAI.STAT.S410CssInf2.raq";
	}
	p_URL = 'dhccpmrunqianreport.csp?reportName='+obj.repName+'&aHospIDs='+"" +'&aSurNumID=' + "" +'&aSurNum='+ ""+'&aLocModel='+retval;	
	ReportFrame.src = p_URL;
	
	//��ѯ��ť
    $("#btnQuery").on('click', function(){
	    var aHospID  = $.form.GetValue("cboHospital");
	    var aSurNum =$.form.GetText("cboSurvNumber");;
		var aSurNumID= $.form.GetValue("cboSurvNumber");;
		
		if (aSurNumID==""){
			layer.msg('��ѡ������ţ�');
			return;
		}
		var surStr = $.Tool.RunServerMethod("DHCHAI.STAT.S410CssInf","GetSurInfo",aSurNumID);
		var aDateFrom = "";
		var aDateTo = "";
		if(surStr!="")
		{
			var arr = surStr.split("^");
			if(arr.length<3)
			{
				layer.msg('ѡ��ĵ����Ŷ��������쳣��');
				return;
			}
			aDateFrom = arr[0];
			aDateTo = arr[1];
		}
		p_URL = 'dhccpmrunqianreport.csp?reportName='+obj.repName+'&aHospIDs='+aHospID +'&aSurNum=' + aSurNum +'&aSurNumID='+ aSurNumID+'&aLocModel='+retval+"&aDateFrom="+aDateFrom+"&aDateTo="+aDateTo;	
		ReportFrame.src = p_URL;
	});
}
