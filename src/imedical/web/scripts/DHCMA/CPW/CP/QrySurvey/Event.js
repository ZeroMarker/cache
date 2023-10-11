//页面Event
function InitCheckQueryWinEvent(obj){	
	obj.LoadEvent = function(args){
		//查询
		$('#btnQuery').on('click', function(){
			obj.GridQrySurvey();
		});
		$('#btnExport').on('click', function(){
			var rows=$("#GridQrySurvey").datagrid('getRows').length;
			if (rows>0) {
				$('#GridQrySurvey').datagrid('toExcel','临床路径问卷调查表.xls');	
			}else {
				$.messager.alert("确认", "无数据记录,不允许导出", 'info');
				return;
			}
		});
		//日期选择判断
		$HUI.datebox("#DateFrom", {
			onSelect:function(){
				var ret=Common_CompareDate(Common_GetValue("DateFrom"),Common_GetValue("DateTo"));				
				if (ret>0) {
					$.messager.popover({msg: '开始日期不能大于结束日期！',type:'error',timeout: 1000})
					Common_SetValue("DateFrom",'');
					}
			}
		});
		$HUI.datebox("#DateTo", {
			onSelect:function(){
				var ret=Common_CompareDate(Common_GetValue("DateFrom"),Common_GetValue("DateTo"));
				if (ret>0) {
					$.messager.popover({msg: '结束日期不能小于开始日期！',type:'error',timeout: 1000})
					Common_SetValue("DateTo",'');
					}
			}
		});
		//科室选择事件
		$HUI.combobox("#cboLoc", {
			onSelect:function(){
				obj.GridQrySurvey();
			}
		});
		//医院科室联动
		$HUI.combobox('#cboSSHosp',{
		    onChange:function(n,o){
			    if (o!="") $("#cboLoc").combobox('clear');		//首次加载不清除赋值
				$("#cboLoc").combobox('reload');  
			}
	    });
	    
		
		obj.DateFrom = Common_SetValue('DateFrom',Common_GetDate(new Date())); // 日期初始赋值
		obj.DateTo = Common_SetValue('DateTo',Common_GetDate(new Date()));
		obj.GridQrySurvey();
	}
	obj.btnExport = function(id,objExport,TitleDesc){
		var rows = objExport.getRows().length; 
		if (rows>0) {
		   $('#'+id).datagrid('toExcel',TitleDesc+".xls");
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出", 'info');
		}
	}
	obj.GridQrySurvey = function(){
    	obj.LocID=Common_GetValue('cboLoc');
	     $cm ({
			 ClassName:"DHCMA.CPW.CPS.PatStsSvySrv",
			QueryName:"QrySurByDate",	
			aDateFrom: Common_GetValue('DateFrom'), 
			aDateTo:Common_GetValue('DateTo'), 
			aLocID:$("#cboLoc").combobox('getValue'),
			aHospID:$("#cboSSHosp").combobox('getValue'),
			page:1,
			rows:999
		},function(rs){
			$('#GridQrySurvey').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
		});
    }
	obj.GridQrySurvey_onDblClick = function(rowIndex,rowData){
	    var EpisodeID=rowData['EpisodeID'];
	     var Code=rowData['Code'];
	    var strUrl="./dhcma.cpw.cp.survey.csp?EpisodeID="+EpisodeID+"&Code="+Code;
		websys_showModal({
			url:strUrl,
			title:'临床路径患者或其家属满意度调查表',
			iconCls:'icon-w-epr',  
	        originWindow:window,
	        closable:true,
			width:1150,
			height:'90%',
			onBeforeClose:function(){
				obj.GridQrySurvey();
			}
		});	
    }
}