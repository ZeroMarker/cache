
function InitWinEvent(obj){
	// 默认加载报表文件
	ReportFrame = document.getElementById("reportFrame");
	p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.CPW.STA.VarPath.raq&aDateFrom=&aDateTo=&aLocID=&aHospID=';	
	ReportFrame.src = p_URL;
	
	//查询按钮
	$("#btnQuery").on('click',function(){
		var aHospID  = $("#cboHospital").combobox("getValue");
	    var DateFrom = $("#DateFrom").datebox("getValue");
		var DateTo 	 = $("#DateTo").datebox("getValue");	
		var LocID 	 = ($("#cboLocation").combobox("getValue")==null||undefined)?"":$("#cboLocation").combobox("getValue");
		var PathMast 	 = ($("#cboPathMast").combobox("getValue")==null||undefined)?"":$("#cboPathMast").combobox("getValue");
		var Type = Common_GetValue('cboType');
    	//if(obj.IsAdmin<1) LocID=session['DHCMA.CTLOCID'];
		
		if ((DateFrom=="")||(DateTo==""))
		{
			$.messager.alert("错误提示",'请选择开始日期、结束日期！','info');
			return;
		}
		else
		{
			if(Common_CompareDate(DateFrom,DateTo)){
				$.messager.alert("错误提示",'开始日期不能大于结束日期！','info');
			return;
			}
		}
		
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.CPW.STA.VarPath.raq&aDateFrom=' + DateFrom +'&aDateTo='+ DateTo +'&aLocID='+ LocID+'&aHospID='+aHospID+'&aPathID='+PathMast+'&aType='+Type;	
		ReportFrame.src = p_URL;
	});
}