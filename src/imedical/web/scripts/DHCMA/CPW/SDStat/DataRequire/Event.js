
function InitMED0101WinEvent(obj){
	// 默认加载报表文件
	ReportFrame = document.getElementById("reportFrame");
	ReportFrame.src="../scripts/DHCMA/CPW/SDStat/ItemStat/SDNoDataTips.html"
	
	//查询按钮
	$("#btnQuery").on('click',function(){
	    var DateFrom = $("#DateFrom").datebox("getValue");
		var DateTo 	 = $("#DateTo").datebox("getValue");		
		var LocID 	 = $("#cboLocation").combobox("getValue");
		var QCID 	 = $("#cboQC").combobox("getValue");
		
		if ((DateFrom=="")||(DateTo=="")){
			$.messager.alert("错误提示",'请选择开始日期、结束日期！','info');
			return;
		}
		if(Common_CompareDate(DateFrom,DateTo)){
			$.messager.alert("错误提示",'开始日期应小于或等于结束日期！','info');
			return;
		}
		if (QCID==""){
			$.messager.alert("错误提示",'请选择病种！','info');
			return;
		}
		var QCEntity = $m({
			ClassName:"DHCMA.CPW.SD.QCEntity",
			MethodName:"GetObjById",
			aId:QCID
			},false);
			debugger;
		var QCAbbrev = $.parseJSON(QCEntity).BTAbbrev;
		var QCReportName="DHCMACPWSD"+QCAbbrev+".raq";
		alert(QCReportName)
		p_URL = 'dhccpmrunqianreport.csp?reportName='+QCReportName+'&aHospID'+2+'&aDateFrom=' + DateFrom +'&aDateTo='+ DateTo +'&aLocID='+ LocID+'&aQCEntityID='+QCID
		ReportFrame.src = p_URL;
	});
		
}