
function InitMED1001WinEvent(obj){
	// 默认加载报表文件
	ReportFrame = document.getElementById("reportFrame");
	p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.CPW.STA.MonthLoc.raq&aDateFrom=&aDateTo=&aLocID=&aHospID=';	
	ReportFrame.src = p_URL;
	
	//查询按钮
	$("#btnQueryLoc").on('click',function(){
		var aHospID  = $("#cboHospital").combobox("getValue");
	    var DateFrom = $("#DateFrom").datebox("getValue");
		var DateTo 	 = $("#DateTo").datebox("getValue");		
		var LocID 	 = ($("#cboLocation").combobox("getValue")==null||undefined)?"":$("#cboLocation").combobox("getValue");
		var EntityID = ($("#cboPathEntity").combobox("getValue")==null||undefined)?"":$("#cboPathEntity").combobox("getValue");
    	if(obj.IsAdmin<1) LocID=session['DHCMA.CTLOCID'];
		
		if ((DateFrom=="")||(DateTo==""))
		{
			$.messager.alert("错误提示",'请选择开始日期、结束日期！','info');
			return;
		}
		else
		{
			var DateFromNum=parseInt(DateFrom.replace('-',''))
			var DateToNum=parseInt(DateTo.replace('-',''))
			if(DateFromNum > DateToNum){
				$.messager.alert("错误提示",'开始月份不能大于结束月份！','info');
			return;
			}
		}
		
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.CPW.STA.MonthLoc.raq&aDateFrom=' + DateFrom +'&aDateTo='+ DateTo +'&aLocID='+ LocID+'&aHospID='+aHospID+'&aSDID='+EntityID;	
		ReportFrame.src = p_URL;
	});
	$("#btnQuerySD").on('click',function(){
		var aHospID  = $("#cboHospital").combobox("getValue");
	    var DateFrom = $("#DateFrom").datebox("getValue");
		var DateTo 	 = $("#DateTo").datebox("getValue");		
		var LocID 	 = ($("#cboLocation").combobox("getValue")==null||undefined)?"":$("#cboLocation").combobox("getValue");
		var EntityID = ($("#cboPathEntity").combobox("getValue")==null||undefined)?"":$("#cboPathEntity").combobox("getValue");
		if(obj.IsAdmin<1) LocID=session['DHCMA.CTLOCID'];
		
		if ((DateFrom=="")||(DateTo==""))
		{
			$.messager.alert("错误提示",'请选择开始日期、结束日期！','info');
			return;
		}
		else
		{
			var DateFromNum=parseInt(DateFrom.replace('-',''))
			var DateToNum=parseInt(DateTo.replace('-',''))
			if(DateFromNum > DateToNum){
				$.messager.alert("错误提示",'开始月份不能大于结束月份！','info');
			return;
			}
		}
		
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.CPW.STA.MonthSD.raq&aDateFrom=' + DateFrom +'&aDateTo='+ DateTo +'&aLocID='+ LocID+'&aHospID='+aHospID+'&aSDID='+EntityID;	
		ReportFrame.src = p_URL;
	});
	/* $("#btnSync").on('click',function(){
		var aHospID  = $("#cboHospital").combobox("getValue");
	    var DateFrom = $("#DateFrom").datebox("getValue");
		var DateTo 	 = $("#DateTo").datebox("getValue");		
		var LocID 	 = $("#cboLocation").combobox("getValue");
		
		if ((DateFrom=="")||(DateTo=="")){
			$.messager.alert("错误提示",'请选择开始日期、结束日期！','info');
			return;
		}
		return;
		$m({
			ClassName:"DHCMA.CPW.STAS.CreateData",
			MethodName:"SyncDataByMonth",
			aFromDate:DateFrom,
			aToDate:DateTo,
			aHospID:aHospID
		},function(ret){
			if(parseInt(ret)>0){
				$.messager.popover({msg:"操作成功！",type:'success'});
			}else{
				$.messager.popover({msg:"操作失败！",type:'error'});
			}
		});
	}); */
}