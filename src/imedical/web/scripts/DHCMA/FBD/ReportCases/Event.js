
function InitMED0103WinEvent(obj){
	var tHospID  = $("#cboHospital").combobox("getValue");
    var tDateFrom = $("#DateFrom").datebox("getValue");
	var tDateTo 	 = $("#DateTo").datebox("getValue");	
	// 默认加载报表文件
	ReportFrame = document.getElementById("reportFrame");
	p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMed.FBD.Workload.raq&aHospIDs='+tHospID +'&aDateFrom=' + tDateFrom +'&aDateTo='+ tDateTo ;	
	ReportFrame.src = p_URL;
	
	//查询按钮
	$("#btnQuery").on('click',function(){
		var aHospID  = $("#cboHospital").combobox("getValue");
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
		if(!checkThreeTime(DateFrom,DateTo)){
			$.messager.popover({msg:"正在查询，查询日期间隔超过了三个月，请稍候...",type:'info'});
		}
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMed.FBD.Workload.raq&aHospIDs='+aHospID +'&aDateFrom=' + DateFrom +'&aDateTo='+ DateTo ;	
		ReportFrame.src = p_URL;
	});
		
}