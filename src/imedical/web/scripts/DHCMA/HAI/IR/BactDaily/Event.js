function InitBactDailyWinEvent(obj) {
	obj.LoadEvent = function(args){	
		
		$("#btnExport").on('click',function(){
			obj.btnExport_click();
		});	
	}
	
	//感染类型标记
	obj.MenuEdit = function(index,ResultID) {
		var e = event || window.event;
		$('#girdDailyResult').datagrid("clearSelections"); //取消所有选中项 
		$('#girdDailyResult').datagrid("selectRow", index); //根据索引选中该行
		   
		$('#menu').menu({
		    onClick:function(item){
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
					ResultTreeShow(); 
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
	//加载药敏结果表格
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
		
	};

	obj.btnExport_click = function() {
		var rows=$("#girdDailyResult").datagrid('getRows').length;
		if (rows>0) {
			var length = $("#girdDailyResult").datagrid('getChecked').length;
			if (length>0) {
				$('#girdDailyResult').datagrid('toExcel', {
				    filename: '细菌检出日报.xls',
				    rows: $("#girdDailyResult").datagrid('getChecked'),
				    worksheet: 'Worksheet',
				});
			} else {
				$('#girdDailyResult').datagrid('toExcel','细菌检出日报.xls');
			} 
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出", 'info');
			return;
		}	
	}
}