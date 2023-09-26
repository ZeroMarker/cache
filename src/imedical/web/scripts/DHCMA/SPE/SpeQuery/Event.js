//页面Event
function InitSpeQueryWinEvent(obj){	
    
	obj.LoadEvent = function(args){ 
	    $('#SpeQuery').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
		
	    obj.chkStatus();
		//查询
		$('#btnQuery').on('click', function(){
			obj.SpeQueryLoad();
		});
		
		//状态选择事件
		$HUI.combobox("#cboQryStatus", {
			onSelect:function(){
				obj.SpeQueryLoad();
			}
		});
		
		//科室选择事件
		$HUI.combobox("#cboLoc", {
			onSelect:function(){
				obj.SpeQueryLoad();
			}
		});
		//患者类型选择事件
		$HUI.combobox("#cboPatTypeSub", {
			onSelect:function(){
				obj.SpeQueryLoad();
			}
		});
		//导出
		$('#btnExport').on('click', function(){
			var rows = obj.gridSpeQuery.getRows().length;  
			if (rows>0) {
				$('#SpeQuery').datagrid('toExcel','特殊患者查询表.xls');
			}else {
				$.messager.alert("确认", "无数据记录,不允许导出", 'info');
			}
		});	
	}
  
	obj.SpeQueryLoad = function(){	
		var DateFrom = $('#DateFrom').datebox('getValue');
		var DateTo = $('#DateTo').datebox('getValue');
		if ((DateFrom == '')||(DateTo == '')) {
			$.messager.alert("提示","开始日期、结束日期不允许为空!",'info');
			return;
		}
		if (Common_CompareDate(DateFrom,DateTo)>0) {
			$.messager.alert("提示","开始日期不能大于结束日期!",'info');
			return;
		}
	    $("#SpeQuery").datagrid("loading");	
		$cm ({
		    ClassName:"DHCMed.SPEService.PatientsQry",
			QueryName:"QrySpeList",	
			ResultSetType:"array",				
			aDateFrom: $('#DateFrom').datebox('getValue'), 
			aDateTo: $('#DateTo').datebox('getValue'), 
			aPatType: $('#cboPatTypeSub').combobox('getValue'), 
			aStatusList:obj.GetStatus(),   
			aLocID: $('#cboLoc').combobox('getValue'),
			aHospID: $('#cboSSHosp').combobox('getValue'),	
	    	page:1,
			rows:999
		},function(rs){
			$('#SpeQuery').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
		});
    }
}