function InitCtlBactResultWinEvent(obj){
	
	obj.LoadEvent = function(args){
		$('#gridAdm').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
		obj.reloadgridApply();
		//查询按钮
		$("#btnQuery").on('click',function(){
			obj.reloadgridApply();
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
	//感染类型标记
	obj.MenuEdit = function(index,ResultID,MRBOutLabType,RowID) {
		var e = event || window.event;
		$('#gridApply').datagrid("clearSelections"); //取消所有选中项 
		$('#gridApply').datagrid("selectRow", index); //根据索引选中该行 
		$('#menu').menu({
			onClick:function(item){
			    if (MRBOutLabType=="外院携带"){
				   var ret = $m({
						ClassName:"DHCHAI.IR.OutLabReport",
						MethodName:"UpdateInfType",
						aID:RowID,
						aMakeInfType:item.id
					},false);
					if (parseInt(ret) <= 0) {
						$.messager.alert("错误提示", "标记失败!Error=" + flg, 'info');
					}else {
						$.messager.popover({msg: '标记成功！',type:'success',timeout: 1000});
						obj.reloadgridApply(); //刷新当前页
					}
				}else{
			       	var ret = $m({
						ClassName:"DHCHAI.DP.LabVisitRepResult",
						MethodName:"UpdateInfType",
						aID:ResultID,
						aMakeInfType:item.id,
						aIsByHand:1
					},false);
					if (parseInt(ret) <= 0) {
						$.messager.alert("错误提示", "标记失败!Error=" + flg, 'info');
					}else {
						$.messager.popover({msg: '标记成功！',type:'success',timeout: 1000});
						obj.reloadgridApply(); 
					}
				}
		    }
		});
		$('#menu').menu('show', { 
			left: e.pageX,   //在鼠标点击处显示菜单 
			top: e.pageY
		});
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
	
	obj.OpenReslut = function(ResultID) {
		$('#gridIRDrugSen').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
		obj.reloadgridIRDrugSen(ResultID);
		$HUI.dialog('#winProEdit').open();	    
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
		var LabSpec  = $("#cboLabSpec").combobox('getValue');
		var WardID   = $("#cboWard").combobox('getValue');
		var InfType  =$("#cboInfType").combobox('getValue');
		var RepType  =$("#cboMRBOutLabType").combobox('getValue');
		var DateFlag=Common_CompareDate(DateFrom,DateTo);
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
				QueryName:"QryBactResult",
				ResultSetType:"array",
				aHospIDs:HospIDs,
				aDateType:DateType,
				aDateFrom:DateFrom,
				aDateTo:DateTo,
				aLocID:Location,
				aInfID:InfType,
				aBactID:Bacteria,
				aMRBID:MRBBact,
				aSpecID:LabSpec,
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
			var length = $("#gridCtlResult").datagrid('getChecked').length;
			if (length>0) {
				$('#gridCtlResult').datagrid('toExcel', {
				    filename: '细菌检出结果查询.xls',
				    rows: $("#gridCtlResult").datagrid('getChecked'),
				    worksheet: 'Worksheet',
				});
			} else {
				$('#gridCtlResult').datagrid('toExcel','细菌检出结果查询.xls');
			} 
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出", 'info');
			return;
		}	
	}

	//加载药敏结果信息
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

}
