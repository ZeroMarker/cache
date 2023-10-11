function InitMBRRepWinEvent(obj){
	obj.LoadEvent = function(args){
		//查询按钮
		$("#btnQuery").on('click',function(){
			obj.reloadgridApply();
		});
		$("#btnExport").on('click',function(){
			obj.btnExport_click();
		});		
	}
	
	obj.OpenReslut = function(ResultID) {
		$('#gridIRDrugSen').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
		obj.reloadgridIRDrugSen(ResultID);
		$HUI.dialog('#winProEdit').open();	    
	}
	obj.OpenMBRRepLog = function(RepID) {
		$('#gridMBRRepLog').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
		obj.reloadgridMBRRepLog(RepID);
		$HUI.dialog('#LayerMBRRepLog').open();	    
	}
	
	//打开链接
	obj.OpenReport = function(ReportID,EpisodeID,LabRepID) {
		var ParamAdmin= (tDHCMedMenuOper['Admin']==1 ?"Admin" : "")
		var strUrl = './dhcma.hai.ir.mrb.ctlreport.csp?&ReportID='+ReportID+'&EpisodeID='+EpisodeID+'&LabRepID='+LabRepID+'&ParamAdmin='+ParamAdmin+'&1=1';
		websys_showModal({
			url:strUrl,
			title:'多耐细菌报告',
			iconCls:'icon-w-epr',  
	        originWindow:window,
	        closable:true,
			width:1340,
			height:700,  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
			onBeforeClose:function(){
				obj.reloadgridApply();  //刷新
			} 
		});
	}
	
	//登记号补零 length位数
	var length=10;
	obj.PapmiNo=""
	$("#txtPapmiNo").keydown(function(event){
		 if (event.keyCode ==13) {
			obj.PapmiNo = $("#txtPapmiNo").val();
			if(!obj.PapmiNo) return;
			$("#txtPapmiNo").val((Array(length).join('0') + obj.PapmiNo).slice(-length)); 
			obj.reloadgridApply();
		}
	});	
	//重新加载表格数据
	obj.reloadgridApply = function(){
		var HospIDs  = $("#cboHospital").combobox('getValue');
		var DateFrom = $("#dtDateFrom").datebox('getValue');
		var DateTo	 = $("#dtDateTo").datebox('getValue');
		var Location = $("#cboLocation").combobox('getValue');
		var Bacteria = $("#cboBacteria").combobox('getValue');
		var MRBBact  = $("#cboMRBBact").combobox('getValue');
		var InfType  = $("#cboInfType").combobox('getValue');
		var PatName  = $("#txtPatName").val();
		var PapmiNo  = $("#txtPapmiNo").val();
		var MrNo 	 = $("#txtMrNo").val();
		var Inputs = PatName+'^'+PapmiNo+'^'+MrNo;
		var DateFlag=Common_CompareDate(DateFrom,DateTo);
		var Status   =$("#cboStatus").combobox('getValue');
		var ErrorStr="";
		if (HospIDs=="") {
			ErrorStr += '请选择院区!<br/>';
		}
		if(DateFrom==""){
			$.messager.alert("提示","送检日期不能为空！", 'info');
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
		
			$("#gridMBRRep").datagrid("loading");
			$cm ({
				ClassName:"DHCHAI.IRS.INFMBRSrv",
				QueryName:"QryINFMBRSrv",
				ResultSetType:"array",
				aHospIDs:HospIDs,
				aDateFrom:DateFrom,
				aDateTo:DateTo,
				aLocID:Location,
				aInfID:InfType,
				aBactID:Bacteria,
				aMRBID:MRBBact,
				aIntputs:Inputs,
				aStatus:Status,
				page:1,
				rows:999999
			},function(rs){
				$('#gridMBRRep').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);
				$('#gridMBRRep').datagrid('selectRow', obj.rowIndex );				
			});
		
		};
	}
	obj.btnExport_click = function() {
		var rows=$("#gridMBRRep").datagrid('getRows').length;
		if (rows>0) {
			var length = $("#gridMBRRep").datagrid('getChecked').length;
			if (length>0) {
				$('#gridMBRRep').datagrid('toExcel', {
				    filename: '多重耐药菌报告.xls',
				    rows: $("#gridMBRRep").datagrid('getChecked'),
				    worksheet: 'Worksheet',
				});
			} else {
				$('#gridMBRRep').datagrid('toExcel','多重耐药菌报告.xls');
			} 
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出", 'info');
			return;
		}	
	}
	
	//重新加载表格数据
	obj.reloadgridIRDrugSen = function(ResultID){
		$("#gridIRDrugSen").datagrid("loading");
		$cm ({
			ClassName:"DHCHAI.IRS.CtlMRBSrv",
			QueryName:"QryResultSen",
			ResultSetType:"array",
			aResultID:ResultID,
			page:1,
			rows:200
		},function(rs){
			$('#gridIRDrugSen').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
		});
	}

	//刷新操作明细
    obj.reloadgridMBRRepLog = function (RepID){
		$("#gridMBRRepLog").datagrid("loading");
		$cm ({
			ClassName:"DHCHAI.IRS.INFMBRSrv",
			QueryName:"QryMBRRepLog",
			ResultSetType:"array",
			aRepID:RepID,
			page:1,
			rows:200
		},function(rs){
			$('#gridMBRRepLog').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
		});
    }	
}
