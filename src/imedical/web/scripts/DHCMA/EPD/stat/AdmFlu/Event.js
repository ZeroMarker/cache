﻿function InitAdmFluWinEvent(obj){
	var DateFrom = $("#DateFrom").datebox("getValue");
	var DateTo 	 = $("#DateTo").datebox("getValue");	
	// 默认加载报表文件
	ReportFrame = document.getElementById("reportFrame");
	p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA_EPD_FluSatic.raq&aHospID='+$("#cboHospital").combobox("getValue")+'&aLocID='+""+'&aDateFrom=' + DateFrom +'&aDateTo='+ DateTo;	
	ReportFrame.src = p_URL;
	
	//查询按钮
	$("#btnQuery").on('click',function(){
		var aHospID  = $("#cboHospital").combobox("getValue");
		if (!aHospID){ aHospID="";}		
	    var DateFrom = $("#DateFrom").datebox("getValue");
		var DateTo 	 = $("#DateTo").datebox("getValue");				
	
		if ((DateFrom=="")||(DateTo=="")){
			$.messager.alert("错误提示",'请选择开始日期、结束日期！','info');
			return;
		}
		if(Common_CompareDate(DateFrom,DateTo)){
			$.messager.alert("错误提示",'开始日期应小于或等于结束日期！','info');
			return;
		}

		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA_EPD_FluSatic.raq&aHospID='+aHospID +'&aLocID='+""+'&aDateFrom=' + DateFrom +'&aDateTo='+ DateTo;	
		ReportFrame.src = p_URL;
	});
		
}