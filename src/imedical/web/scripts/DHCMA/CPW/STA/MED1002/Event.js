
function InitMED1002WinEvent(obj){
	// 默认加载报表文件
	ReportFrame = document.getElementById("reportFrame");
	p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.CPW.STA.DayLoc.raq&aDateFrom=&aDateTo=&aLocID=&aHospID=&aLocType=';	
	ReportFrame.src = p_URL;
	
	//查询按钮
	$("#btnQueryLoc").on('click',function(){
		var aHospID  = $("#cboHospital").combobox("getValue");
	    var DateFrom = $("#DateFrom").datebox("getValue");
		var DateTo 	 = $("#DateTo").datebox("getValue");		
		var LocID 	 = ($("#cboLocation").combobox("getValue")==null||undefined)?"":$("#cboLocation").combobox("getValue");
		var EntityID = ($("#cboPathEntity").combobox("getValue")==null||undefined)?"":$("#cboPathEntity").combobox("getValue");
    	var LocType  = $('input[name=LocType]:checked').val();
		
		//if(obj.IsAdmin<1) LocID=session['DHCMA.CTLOCID'];
		
		if ((DateFrom=="")||(DateTo==""))
		{
			$.messager.alert("错误提示",'请选择开始日期、结束日期！','info');
			return;
		}
		else
		{
			if(DateFrom > DateTo){
				$.messager.alert("错误提示",'开始日期不能大于结束日期！','info');
			return;
			}
		}
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.CPW.STA.DayLoc.raq&aDateFrom=' + DateFrom +'&aDateTo='+ DateTo +'&aLocID='+ LocID+'&aHospID='+aHospID+'&aSDID='+EntityID+'&aLocType='+LocType;	
		ReportFrame.src = p_URL;
	});
	$("#btnQuerySD").on('click',function(){
		var aHospID  = $("#cboHospital").combobox("getValue");
	    var DateFrom = $("#DateFrom").datebox("getValue");
		var DateTo 	 = $("#DateTo").datebox("getValue");	
		var LocID 	 = ($("#cboLocation").combobox("getValue")==null||undefined)?"":$("#cboLocation").combobox("getValue");
		var EntityID = ($("#cboPathEntity").combobox("getValue")==null||undefined)?"":$("#cboPathEntity").combobox("getValue");
		var LocType  = $('input[name=LocType]:checked').val();
		
		//if(obj.IsAdmin<1) LocID=session['DHCMA.CTLOCID'];
		
		if ((DateFrom=="")||(DateTo==""))
		{
			$.messager.alert("错误提示",'请选择开始日期、结束日期！','info');
			return;
		}
		else
		{
			if(DateFrom > DateTo){
				$.messager.alert("错误提示",'开始日期不能大于结束日期！','info');
			return;
			}
		}
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.CPW.STA.DaySD.raq&aDateFrom=' + DateFrom +'&aDateTo='+ DateTo +'&aLocID='+ LocID+'&aHospID='+aHospID+'&aSDID='+EntityID+'&aLocType='+LocType;	
		ReportFrame.src = p_URL;
	});
}