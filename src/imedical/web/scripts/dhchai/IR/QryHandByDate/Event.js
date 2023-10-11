//页面Event
function InitQryHandInfPosWinEvent(obj){	
	obj.LoadEvent = function(args){
	    $('#QryHandByDate').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0

		//查询按钮
		$("#btnQuery").on('click',function(){
			obj.reloadgridQryHandByDate();
		});
	}
	//重新加载表格数据
	obj.reloadgridQryHandByDate = function(){
		var HospIDs	    = $('#cboHospital').combobox('getValue');
		var DateFrom	= $('#DateFrom').datebox('getValue');
		var DateTo		= $('#DateTo').datebox('getValue');
		var Loc 		= $("#cboLoc").combobox('getValue');
		var Method 		= $("#cboMethod").combobox('getText');
		var ErrorStr="";
		if (HospIDs=="") {
			ErrorStr += '请选择院区!<br/>';
		}
		if (Loc==""){
			$.messager.alert("提示","请选择调查病区！", 'info');
			return;
		}
		if (DateFrom==""){
			$.messager.alert("提示","请选择开始日期！", 'info');
			return;
		}
		if (DateTo==""){
			$.messager.alert("提示","请选择结束日期！", 'info');
			return;
		}
		if(DateFrom > DateTo){
			$.messager.alert("提示","开始日期应小于或等于结束日期！", 'info');
			return;
		}
		if (ErrorStr != '') {
			$.messager.alert("错误提示",ErrorStr, 'info');
			return;
		}else{
			$("#QryHandByDate").datagrid("loading");
			$cm ({
				ClassName:"DHCHAI.IRS.HandHyRegSrv",
				QueryName:"QryHandHyByDate",
				ResultSetType:"array",
				aHospID:HospIDs,
				aLocID:Loc,
		        aDateFrom:DateFrom,
		        aDateTo:DateTo,
		        aMethod:Method,
				page:1,
				rows:200
			},function(rs){
				$('#QryHandByDate').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
			});
		}
	};
    
}



