function InitCtlMonitorWinEvent(obj){
	
	obj.LoadEvent = function(args){
		//查询按钮
		$("#btnQuery").on('click',function(){
			obj.reloadgridApply();
		});
		// 监控按钮
		$("#btnTask").on('click',function(){
			obj.MonlitTsak();
		});
		$("#btnExport").on('click',function(){
			obj.btnExport_click();
		});	
		//登记按钮
		$("#btnOutLabReg").on('click',function(){
			obj.OpenOutLabReg();
		});
	}
	//打开登记链接
	obj.OpenOutLabReg = function() {
		var strUrl = '../csp/dhcma.hai.ir.outlabreg.csp';
		websys_showModal({
			url:strUrl,
			title:'外部检验结果登记',
			iconCls:'icon-w-epr',  
	        originWindow:window,
	        closable:true,
			width:1344,
			height:700,  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
			onBeforeClose:function(){
				obj.reloadgridApply();  //刷新
			} 
		});
	}
	// 监控
	obj.MonlitTsak = function(EpisodeID) {
		var CurrDate = Common_GetDate(new Date());
		$.messager.confirm("监控","确定执行监控任务？",function(r){
			if (r){
				$('#p').progressbar({value:0});
				var flg = $m({
					ClassName:"DHCHAI.Task.TaskManager",
					MethodName:"CheckBactTask",
					aDateFrom:CurrDate,
					aDateTo:CurrDate
				},false)
				if (flg.indexOf('OK') > -1) {
					//执行完毕
					setTimeout(function() {
						$('#p').progressbar({value:100});
						$.messager.popover({msg: '监控执行完成！',type:'success',timeout: 2000});
						setTimeout(function() {$('#p').hide();},2000);
						obj.reloadDetail();
					},1000);
				} else{
					$.messager.alert("提示","任务发生错误，请重新执行！",'info');
				}
			}
		})
	}
	
	//打开链接
	obj.OpenMainView = function(EpisodeID) {
		var strUrl = './dhchai.ir.view.main.csp?PaadmID='+EpisodeID+'&PageType=WinOpen';
		
		var Page=DHCCPM_Open(strUrl);
	}
	
	
	//电子病历
	obj.OpenEmrRecord = function(EpisodeID,PatientID) {		
		var strUrl = cspUrl+'&PatientID=' + PatientID+'&EpisodeID='+EpisodeID + '&DefaultOrderPriorType=ALL&2=2';		
		
		var Page=DHCCPM_Open(strUrl);
	};
	
	obj.openDetail = function(EpisodeID) {
		$('#gridBactDetail').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
		obj.reloadDetail(EpisodeID);
		$HUI.dialog('#winProEdit').open();	    
	}
	
	obj.reloadDetail= function(EpisodeID){
		var DateType = $("#cboDateType").combobox('getValue');
		var DateFrom = $("#dtDateFrom").datebox('getValue');
		var DateTo	 = $("#dtDateTo").datebox('getValue');
		$("#gridBactDetail").datagrid("loading");
		$cm ({
			ClassName:"DHCHAI.IRS.CtlMRBSrv",
			QueryName:"QryBactDetail",
			ResultSetType:"array",
			aEpisodeID:EpisodeID,
			aDateType:DateType,
			aDateFrom:DateFrom,
			aDateTo:DateTo,
			page:1,
			rows:200
		},function(rs){
			$('#gridBactDetail').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
		});
	}
	//重新加载表格数据
	obj.reloadgridApply = function(){
		var HospIDs  = $("#cboHospital").combobox('getValue');
		var DateType = $("#cboDateType").combobox('getValue');
		var DateFrom = $("#dtDateFrom").datebox('getValue');
		var DateTo	 = $("#dtDateTo").datebox('getValue');
		var Location = $("#cboLocation").combobox('getValue');
		var Bacteria = $("#cboBacteria").combobox('getValue');
		var MRBBact  = $("#cboMRBBact").combobox('getValue');
		var InfType  = $("#cboInfType").combobox('getValue');
		var WardID   = $("#cboWard").combobox('getValue');
		var DateFlag=Common_CompareDate(DateFrom,DateTo);
		var RepType  =$("#cboMRBOutLabType").combobox('getValue');
		var ErrorStr="";
		if (HospIDs=="") {
			ErrorStr += '请选择院区!<br/>';
		}
		if(DateType==""){
			$.messager.alert("提示","日期类型不能为空！", 'info');
			return;
		}
		if(DateFrom==""){
			$.messager.alert("提示","开始日期不能为空！", 'info');
			return;
		}
		if(DateTo==""){
			$.messager.alert("提示","结束日期不能为空！", 'info');
			return;
		}
		if (DateFlag==1){
			$.messager.alert("提示","开始日期不能大于结束日期！", 'info');
			return;
		}
		
		if (ErrorStr != '') {
			$.messager.alert("错误提示",ErrorStr, 'info');
			return;
		}else{
			$("#gridCtlResult").datagrid("loading");
			$cm ({
				ClassName:"DHCHAI.IRS.CtlMRBSrv",
				QueryName:"QryMRBMonitor",
				ResultSetType:"array",
				aHospIDs:HospIDs,
				aDateType:DateType,
				aDateFrom:DateFrom,
				aDateTo:DateTo,
				aLocID:Location,
				aInfID:InfType,
				aBactID:Bacteria,
				aMRBID:MRBBact,
				aSpecID:"",
				aWardID:WardID,
				aRepTypeID:RepType,
				page:1,
				rows:999999
			},function(rs){
				$('#gridCtlResult').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
			});
		
		};
	}
	obj.btnExport_click = function() {
		var rows=$("#gridCtlResult").datagrid('getRows').length;
		if (rows>0) {
			/*var length = $("#gridCtlResult").datagrid('getChecked').length;
			if (length>0) {
				$('#gridCtlResult').datagrid('toExcel', {
				    filename: '多重耐药菌监控.xls',
				    rows: $("#gridCtlResult").datagrid('getChecked'),
				    worksheet: 'Worksheet',
				});
			} else {
				$('#gridCtlResult').datagrid('toExcel','多重耐药菌监控.xls');
			} */
			$('#gridCtlResult').datagrid('toExcel','多重耐药菌监控.xls');
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出", 'info');
			return;
		}	
	}
	setTimeout(function(){obj.reloadgridApply()},1000);
}
