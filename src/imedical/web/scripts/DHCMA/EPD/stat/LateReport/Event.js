
function InitLateReportWinEvent(obj){
	// 默认加载报表文件
	ReportFrame = document.getElementById("reportFrame");
	p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMed.EPD.LateReport.raq&aHospIDs='+"" +'&aDateFrom=' + "" +'&aDateTo='+ ""+ '&aLocs=' + "" + '&aStaType='+ "" + '&aQryCon=' + "";	;	
	ReportFrame.src = p_URL;
	
	//查询按钮
	$("#btnQuery").on('click',function(){
		var aHospID  = $("#cboHospital").combobox("getValue");
	    var DateFrom = $("#DateFrom").datebox("getValue");
		var DateTo 	 = $("#DateTo").datebox("getValue");
		var aLocIDs   = $("#cboLocation").combobox("getValues");	
		var IsQCon	= $("#IsQCon").checkbox('getValue') ? "1":"0";		
		if ((DateFrom=="")||(DateTo=="")){
			$.messager.alert("错误提示",'请选择开始日期、结束日期！','info');
			return;
		}
		if(Common_CompareDate(DateFrom,DateTo)){
			$.messager.alert("错误提示",'开始日期应小于或等于结束日期！','info');
			return;
		}
		if(!checkThreeTime(DateFrom,DateTo)){
			$.messager.popover({msg:"正在查询，查询日期间隔超过了三个月，请稍候...",type:'info'});
		}
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMed.EPD.LateReport.raq&aHospIDs='+aHospID +'&aDateFrom=' + DateFrom +'&aDateTo='+ DateTo + '&aLocs=' + aLocIDs + '&aStaType=E' + '&aQryCon=' + IsQCon;	
		ReportFrame.src = p_URL;
	});
		
}