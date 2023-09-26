//页面Event
function InitSpeStatisticWinEvent(obj){	
    
    obj.LoadEvent = function(args){
		$('#SpeStatistic').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
		obj.SpeStatisticLoad();
		//查询
		$('#btnQuery').on('click', function(){
			obj.SpeStatisticLoad();
			if ($('#cboPatType').combobox('getValue') == "") {
				$('#cboPatTypeSub').combobox('reload');
			}
		});
		
		
		//科室选择事件
		$HUI.combobox("#cboLoc", {
			onSelect:function(){
				obj.SpeStatisticLoad();
			}
		});
		
		//特殊患者大类选择事件
		$HUI.combobox("#cboPatType", {
			onSelect:function(){
				$('#cboPatTypeSub').combobox('setValue', ''); //先清空
				$('#cboPatTypeSub').combobox('reload');       //再加载
				obj.SpeStatisticLoad();
			}
		});
		
		//特殊患者子类选择事件
		$HUI.combobox("#cboPatTypeSub", {
			onSelect:function(){
				obj.SpeStatisticLoad();
			}
		});
		//导出
		$('#btnExport').on('click', function(){
			var rows = obj.gridSpeStatistic.getRows().length;  
			if (rows>0) {
				$('#SpeStatistic').datagrid('toExcel','特殊患者统计查询表.xls');
			}else {
				$.messager.alert("确认", "无数据记录,不允许导出", 'info');
			}
		});	
    }

	
    obj.SpeStatisticLoad = function(){	
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
		$("#SpeStatistic").datagrid("loading");	
		$cm ({
			ClassName:"DHCMed.SPEService.PatientsQry",
			QueryName:"QueryStatistic",	
			ResultSetType:"array",			
	        aFromDate: $('#DateFrom').datebox('getValue'), 
			aToDate: $('#DateTo').datebox('getValue'), 
			aTypeID: $('#cboPatType').combobox('getValue'), 
			aTypeSubID:$('#cboPatTypeSub').combobox('getValue'), 
			aLocID: $('#cboLoc').combobox('getValue'), 
			aHospID: $('#cboSSHosp').combobox('getValue'),
			page:1,
			rows:999
		},function(rs){
			$('#SpeStatistic').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
		});
    }
}