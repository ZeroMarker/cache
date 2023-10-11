
function InitCostAndDayWinEvent(obj){
	// 默认加载报表文件
	ReportFrame = document.getElementById("reportFrame");
	p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.CPW.STA.CostAndInDayByLoc.raq&aDateFrom=&aDateTo=&aLocID=&aHospID=&aLocType=';	
	ReportFrame.src = p_URL;
	
	//查询按钮
	$("#btnQuerySD").on('click',function(){
		var aHospID  = $("#cboHospital").combobox("getValue");
	    var DateFrom = $("#DateFrom").datebox("getValue");
		var DateTo 	 = $("#DateTo").datebox("getValue");		
		var LocID 	 = ($("#cboLocation").combobox("getValue")==null||undefined)?"":$("#cboLocation").combobox("getValue");
		var EntityID = ($("#cboPathForm").combobox("getValue")==null||undefined)?"":$("#cboPathForm").combobox("getValue");
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
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.CPW.STA.CostAndInDayBySD.raq&aDateFrom=' + DateFrom +'&aDateTo='+ DateTo +'&aLocID='+ LocID+'&aHospID='+aHospID+'&aSDID='+EntityID+'&aLocType=InP';	
		ReportFrame.src = p_URL;
	});
	//查询按钮
	$("#btnQueryLoc").on('click',function(){
		var aHospID  = $("#cboHospital").combobox("getValue");
	    var DateFrom = $("#DateFrom").datebox("getValue");
		var DateTo 	 = $("#DateTo").datebox("getValue");		
		var LocID 	 = ($("#cboLocation").combobox("getValue")==null||undefined)?"":$("#cboLocation").combobox("getValue");
		var EntityID = ($("#cboPathForm").combobox("getValue")==null||undefined)?"":$("#cboPathForm").combobox("getValue");
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
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.CPW.STA.CostAndInDayByLoc.raq&aDateFrom=' + DateFrom +'&aDateTo='+ DateTo +'&aLocID='+ LocID+'&aHospID='+aHospID+'&aSDID='+EntityID+'&aLocType=InP';	
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