
function InitWinEvent(obj){
	// 默认加载报表文件
	ReportFrame = document.getElementById("reportFrame");
	p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMACPWSDDocWork.raq&aHospID='+2+'&aDateFrom=' + "" +'&aDateTo='+ ""+'&aType='+ "1";	
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
		var QCID 	 = $("#cboQC").combobox("getValue");
		var aType 	 = $("#Type").combobox("getValue");
		var aDocID 	 = $("#cboDoc").combobox("getValue");
		if ((DateFrom=="")||(DateTo=="")){
			$.messager.alert("错误提示",'请选择开始日期、结束日期！','info');
			return;
		}
		if(Common_CompareDate(DateFrom,DateTo)){
			$.messager.alert("错误提示",'开始日期应小于或等于结束日期！','info');
			return;
		}
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMACPWSDDocWork.raq&aHospID='+aHospID+'&aDateFrom=' + DateFrom +'&aDateTo='+ DateTo +'&aLocID='+ LocID+'&aQCEntityID='+QCID+'&aDocID='+aDocID+'&aType='+aType
		if(!ReportFrame.src){
			ReportFrame.frameElement.src=p_URL;
		}else{
			ReportFrame.src = p_URL;
		}
	});
		
}