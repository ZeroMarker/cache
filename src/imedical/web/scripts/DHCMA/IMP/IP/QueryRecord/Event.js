
function InitMED0101WinEvent(obj){
	// 默认加载报表文件
	ReportFrame = document.getElementById("reportFrame");
	p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMAIMPQueryRecord.raq&aHospID='+2+'&aDateFrom=' + "" +'&aDateTo='+ "";	
	if(!ReportFrame.src){
		ReportFrame.frameElement.src=p_URL;
	}else{
		ReportFrame.src = p_URL;
	}
	
	//查询按钮
	$("#btnQuery").on('click',function(){
		var aHospID 	= $('#cboHospital').combobox('getValue');
	    var DateFrom = $("#DateFrom").datebox("getValue");
		var DateTo 	 = $("#DateTo").datebox("getValue");		
		var LocID 	 = $("#cboLocation").combobox("getValue");
		var CategoryID 	 = $("#cboCategory").combobox("getValue");
		if ((DateFrom=="")||(DateTo=="")){
			$.messager.alert("错误提示",'请选择开始日期、结束日期！','info');
			return;
		}
		if(Common_CompareDate(DateFrom,DateTo)){
			$.messager.alert("错误提示",'开始日期应小于或等于结束日期！','info');
			return;
		}
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMAIMPQueryRecord.raq&aHospID='+aHospID+'&aDateFrom=' + DateFrom +'&aDateTo='+ DateTo +'&aLocID='+ LocID+'&aCategory='+CategoryID
		if(!ReportFrame.src){
			ReportFrame.frameElement.src=p_URL;
		}else{
			ReportFrame.src = p_URL;
		}
	});
		
}