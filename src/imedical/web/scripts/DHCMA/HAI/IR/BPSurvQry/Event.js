function InitBPSurvWinEvent(obj){

	CheckSpecificKey();
	var CheckFlg = 0; 
	if(tDHCMedMenuOper['Admin']==1) {
		CheckFlg = 1; //审核权限
	}
	obj.LoadEvent = function(args){
		//查询按钮
		$("#btnQuery").on('click',function(){
			obj.reloadgridBPReg();
		});
		$("#btnExport").on('click',function(){
			obj.btnExport_click();
		});
		//审核结果
		$('#btnChkReps').on('click', function(){
			obj.btnCheckRep_onClick();
		});
		//取消审核结果
		$('#btnUnChkReps').on('click', function(){
			obj.btnUnCheckRep_onClick();
		});
	}
	$("#txtPatName").keydown(function(event){
		if (event.keyCode ==13) obj.reloadgridBPReg();	
	});	
	//审核结果
	obj.btnCheckRep_onClick = function(){
		var rows = $("#gridBPRegList").datagrid('getRows').length;
		if (rows>0) {
			var chkRows=$HUI.datagrid('#gridBPRegList').getChecked();
			if (chkRows.length>0) {
				 $.messager.confirm("确认", "是否批量审核报告?", function (r) {
					if (r) {
						var reportIds = '';
						for (var row = 0; row < chkRows.length; row++){
							var rd = chkRows[row];
							if (!rd) continue;
							var repId = rd['BPSurvID'];
							if (reportIds != ''){
								reportIds += ',' + repId;
							} else {
								reportIds = repId;
							}
						}
						
						var flg = $m({
							ClassName   : "DHCHAI.IRS.BPSurverySrv",
							MethodName  : "SaveBPRepStatus",
							aReportIDs  : reportIds,
							aStatusCode : 3
						},false);
						if (parseInt(flg) < 1) {
							$.messager.alert("错误提示","批量审核报告操作错误!Error=" + flg, 'info');
						} else {
							$.messager.popover({msg: '批量审核报告操作成功！',type:'success',timeout: 1000});
							obj.reloadgridBPReg();  //刷新
						}
					}
				});
			} else {
				$.messager.alert("错误提示", "无选中记录,不可操作!",'info');
				return;
			}
		}else {
			$.messager.alert("错误提示", "无记录,不可操作!", 'info');
			return;
		}
	}
	//取消审核结果
	obj.btnUnCheckRep_onClick = function(){
		var rows = $("#gridBPRegList").datagrid('getRows').length;
		if (rows>0) {
			var chkRows=$HUI.datagrid('#gridBPRegList').getChecked();
			if (chkRows.length>0) {
				 $.messager.confirm("确认", "是否批量取消审核报告?", function (r) {
					if (r) {
						var reportIds = '';
						for (var row = 0; row < chkRows.length; row++){
							var rd = chkRows[row];
							if (!rd) continue;
							var repId = rd['BPSurvID'];
							if (reportIds != ''){
								reportIds += ',' + repId;
							} else {
								reportIds = repId;
							}
						}
						
						var flg = $m({
							ClassName   : "DHCHAI.IRS.BPSurverySrv",
							MethodName  : "SaveBPRepStatus",
							aReportIDs  : reportIds,
							aStatusCode : 6
						},false);
						if (parseInt(flg) < 1) {
							$.messager.alert("错误提示","批量取消审核报告操作错误!Error=" + flg, 'info');
						} else {
							$.messager.popover({msg: '批量取消审核报告操作成功！',type:'success',timeout: 1000});
							obj.reloadgridBPReg();  //刷新
						}
					}
				});
			} else {
				$.messager.alert("错误提示", "无选中记录,不可操作!",'info');
				return;
			}
		}else {
			$.messager.alert("错误提示", "无记录,不可操作!", 'info');
			return;
		}
	}
	//打开链接
	obj.OpenReport = function(SurvNumber,ReportID,Index,RepStatus,BPRegID) {
		var strUrl = '../csp/dhcma.hai.ir.bpsurvreport.csp?SurvNumber='+$("#cboSurvNumber").combobox("getValue")+'&ReportID='+ReportID+'&BPRegID='+BPRegID+'&AdminPower='+CheckFlg+'&RepStatus='+RepStatus+'&inputParams='+obj.Params+'&ComTempTypeCode='+'BP-REP'+'&1=1';
		websys_showModal({
			url:strUrl,
			title:'血透个案调查:'+$("#cboSurvNumber").combobox("getText"),
			iconCls:'icon-w-epr',  
	        originWindow:window,
	        closable:true,
			width:1420,
			height:'95%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
			onBeforeClose:function(){
				obj.reloadgridBPReg();
			} 
		});
	}
	setTimeout(function(){obj.reloadgridBPReg();},1000);
	//重新加载表格数据
	obj.reloadgridBPReg = function(){
		var HospIDs 	= $("#cboHospital").combobox('getValue');
		var BDLocation  = $("#cboBDLocation").combobox('getValues').join(',');;
		var SEID	 	= $("#cboSurvNumber").combobox('getValue');
		var PatName 	= $("#txtPatName").val();
		var PapmiNo 	= "";  
		var MrNo 		= "";
		//报告状态
		var Status=Common_CheckboxValue('chkStatunit');
		var Inputs = HospIDs+'^'+BDLocation+'^'+""+"^"+SEID+'^'+PatName+'^'+PapmiNo+'^'+MrNo+"^"+Status;
		
		var ErrorStr="";
		if (HospIDs=="") {
			ErrorStr += '请选择院区!<br/>';
		}
		if (SEID==""){
			ErrorStr += '请选择调查编号！<br/>';
		}
		if (ErrorStr != '') {
			$.messager.alert("错误提示",ErrorStr, 'info');
			return;
		}else{
			obj.Params = HospIDs+'^'+BDLocation+'^'+""+"^"+SEID+'^'+""+'^'+""+'^'+""+"^";
			$("#gridBPRegList").datagrid("loading");
			$cm ({
				ClassName:"DHCHAI.IRS.BPSurverySrv",
				QueryName:"QryBPPatList",
				ResultSetType:"array",
				aIntputs:Inputs,
				page:1,
				rows:1000
			},function(rs){
				$('#gridBPRegList').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
			});
		
		};
	}
	obj.btnExport_click = function() {
		var rows=$("#gridBPRegList").datagrid('getRows').length;
		if (rows>0) {
			var length = $("#gridBPRegList").datagrid('getChecked').length;
			if (length>0) {
				$('#gridBPRegList').datagrid('toExcel', {
				    filename: '血透个案调查列表.xls',
				    rows: $("#gridBPRegList").datagrid('getChecked'),
				    worksheet: 'Worksheet',
				});
			} else {
				$('#gridBPRegList').datagrid('toExcel','血透个案调查列表.xls');
			} 
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出", 'info');
			return;
		}	
	}
}