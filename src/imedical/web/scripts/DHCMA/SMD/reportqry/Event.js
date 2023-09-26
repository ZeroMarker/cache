//页面Event
function InitReportQryWinEvent(obj){	
    
	obj.LoadEvent = function(args){ 
	    $('#SMDDQuery').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
	    obj.SMDDQueryLoad();
		//查询
		$('#btnQuery').on('click', function(){
			obj.btnQuery_click();
		});
		//选择导出
		$('#btnExport').on('click', function(){
			obj.btnExport_click();
		});
		//导出Xml
		$('#btnExportXml').on('click', function(){
			obj.btnExportXml_click();
		});
		//批量审核
		$('#btnBatchCheck').on('click', function(){
			obj.btnBatchCheck_click();
		});
	  
		//报卡类型
		$HUI.combobox("#cboRepType", {
			onSelect:function(){
				obj.SMDDQueryLoad();
			}
		});
	}
    
	obj.btnQuery_click = function() {
		var RepStatus = Common_CheckboxValue('chkRepStatusList');
		if (RepStatus == ''){
			$.messager.alert("提示","请选择报告状态！",'info');
			return;
		}
		var StaDate = $('#dtDateFrom').datebox('getValue');
		var EndDate = $('#dtDateTo').datebox('getValue');
		if ((StaDate == '')||(EndDate == '')) {
			$.messager.alert("提示","开始日期、结束日期不允许为空!");
			return;
		}
		if (Common_CompareDate(StaDate,EndDate)>0) {
			$.messager.alert("提示","开始日期不能大于结束日期!");
			return;
		}
		obj.SMDDQueryLoad();
	}
	obj.btnExport_click = function() {	
		var rows = obj.gridSMDDQuery.getRows().length;  
		if (rows>0) {
			$('#SMDDQuery').datagrid('toExcel','精神疾病报告查询表.xls');
		} else{
			$.messager.alert("提示","请先查询再导出Excel！",'info');
			return;
		}
	}
	obj.btnExportXml_click = function() {
		var rows = obj.gridSMDDQuery.getRows().length;  
		if (rows>0) {
			$.messager.alert("提示","待写！",'info');
		} else{
			$.messager.alert("提示","请先查询再导出XML！",'info');
			return;
		}
		
	}
	obj.btnBatchCheck_click = function() {
		var record = obj.gridSMDDQuery.getChecked();
		var length = obj.gridSMDDQuery.getChecked().length; 	
		if (length>0) {
			var Count=0;
			for (var row = 0; row < length; row++) {
				var ReportID =  record[row]["ReportID"];
				var StatusDesc = record[row]["StatusDesc"];
				if ((StatusDesc == '提交')||(StatusDesc == '取消审核')){
					var ret = $m({                  
						ClassName:"DHCMed.SMD.Report",
						MethodName:"CheckReport",
						ReportID:ReportID, 
						StatusCode:2,
						ResumeText:"",
						UserID:session['LOGON.USERID']
					},false);
					Count++;
				}
			}
			if (Count < 1) {
				$.messager.alert("提示信息", "请至少选中一行待审记录,再进行审核!",'info');
				return;
			}
			obj.SMDDQueryLoad();
			obj.gridSMDDQuery.clearSelections();  ;  //清除所有选择的行
		} else {
			$.messager.alert("提示信息", "先选择待审记录,再进行审核!",'info');
			return;
		}
		var rows = obj.gridSMDDQuery.getRows().length; 
		 
		if(rows<1){
			$.messager.alert("提示","请先查询，再批量审核！",'info');
			return;
		}		
		
	}
	//打开链接
	obj.OpenSMDReport = function(aReportID) {
		var strUrl = "./dhcma.smd.report.csp?1=1&ReportID=" +aReportID;
		websys_showModal({
			url:strUrl,
			title:'精神疾病报告',
			iconCls:'icon-w-epr',  
	        originWindow:window,
	        closable:false,
			width:1320,
			height:'90%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
			onBeforeClose:function(){
				obj.SMDDQueryLoad();  //刷新
			} 
		});
	}

	obj.SMDDQueryLoad = function(){	
		$("#SMDDQuery").datagrid("loading");	
		$cm ({
		    ClassName:"DHCMed.SMDService.ReportSrv",
			QueryName:"QryReportByDate",
			ResultSetType:"array",		
			aRepType: $('#cboRepType').combobox('getValue'),
			aDateFrom: $('#dtDateFrom').datebox('getValue'), 
			aDateTo: $('#dtDateTo').datebox('getValue'), 
			aHospID: $('#cboSSHosp').combobox('getValue'),  
			aRepLoc: $('#cboRepLoc').combobox('getValue'),  
			aStatusList: Common_CheckboxValue('chkRepStatusList'),
			aAdmTypeList:Common_CheckboxValue('chkAdmTypeList'),
			aPatName:$('#txtPatName').val(),
	    	page:1,
			rows:999
		},function(rs){
			$('#SMDDQuery').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
		});
    }	
}