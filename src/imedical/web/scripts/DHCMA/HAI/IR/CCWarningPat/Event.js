function InitPatScreenEvent(obj) {
	obj.LoadEvent = function(){
		$('#btnCollect').on("click", function(){
			obj.btnCollect_click(); 
		});	
		
		$('#btnExport').on("click", function(){
			obj.btnExport_click(); 
		});		
		$('#btnExportLab').on("click", function(){
			obj.btnExportLab_click(); 
		});	
		$("#btnSingin").on('click',function(){				
			$('#DelOpnDialog').show();
			obj.DelOpnDialog = $HUI.dialog('#DelOpnDialog',{
				title:'请输入非暴发原因',
				iconCls:'icon-w-cancel',  
				resizable:true,
				modal: true,
				isTopZindex:true,
				buttons:[{
					text:'确定',
					handler:function(){
						var Opinion =  $.trim($('#txtOpinion').val());
						if (!Opinion) {
							$.messager.alert("提示", "请输入非暴发原因!", 'info');
							return;
						}
						obj.btnSingin_click(Opinion);													
					}				
				}]
			});
		})
	}
	
	obj.btnExport_click = function() {
		var rows=$("#LocPatients").datagrid('getRows').length;
		if (rows>0) {
			$('#LocPatients').datagrid('toExcel','暴发预警明细.xls');
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出", 'info');
			return;
		}	
	}
	
	obj.btnExportLab_click = function() {
		var rows=$("#LabSenList").datagrid('getRows').length;
		if (rows>0) {
			$('#LabSenList').datagrid('toExcel','细菌耐药谱.xls');
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出", 'info');
			return;
		}	
	}
	
	//非暴发
	obj.btnSingin_click= function(aOpinion){
		var InputStr = "";
		InputStr += "^" + WarnLocID;
		InputStr += "^" + SelItem;
		InputStr += "^" + WarnDate;
		InputStr += "^" + "2"; 
		InputStr += "^" + "";      // 处置日期
		InputStr += "^" + "";      // 处置时间
		InputStr += "^" + $.LOGON.USERID; // 处置人
		InputStr += "^" + aOpinion;     // 处置意见
		InputStr += "^" + "";     // 报告ID
		InputStr += "^#"+ WarnItems;	//查询条件		
		var retval = $m({
			ClassName:"DHCHAI.IR.CCWarningAct",
			MethodName:"Update",
			aInput:InputStr,
			aSeparate:"^"
		},false);
		
		if (parseInt(retval)>0){
			//增加处理记录排除患者明细 EpisodeDr
			var rowData=$("#LocPatients").datagrid("getData").rows;
			for(var i=0;i<rowData.length;i++){
				var EpID = rowData[i].EpisodeDr;
				var InputStrC = "^"+EpID+"^"+retval;
				var retvalC = $m({
					ClassName:"DHCHAI.IR.CCWarningActEp",
					MethodName:"Update",
					aInput:InputStrC,
					aSeparate:"^"
				},false);
			}
			$('#btnSingin').linkbutton("disable");
			$.messager.popover({msg: '【散发】处置成功！',type:'success',timeout: 1000});
						
		} else {
			$.messager.popover({msg: '【散发】处置失败！',type:'error',timeout: 1000});
		}
		$HUI.dialog('#DelOpnDialog').close();
		
	};
		
	//暴发报卡
	obj.btnCollect_click= function(){
		var rows = obj.LocPatients.getRows();
		if (rows.length<0){
			$.messager.alert("提示", "表格中无数据!",'info');
			return;
		}
		var ret = $m({
			ClassName:"DHCHAI.IRS.CCWarningRepSrv",
			MethodName:"JudgeRep",
			aLocID:WarnLocID,
			aDate:WarnDate,
			aselItems:SelItem
		},false);
		if (parseInt(ret)==1){
			$.messager.alert("提示",SelItem+"已报卡，无需再报", 'info');
			return;
		}
		if ((parseInt(ret)==2)){
			$.messager.confirm("提示", SelItem+"已散发处置，是否需要报卡", function (r) {
				if (r) {				
					obj.WarnRepShow(WarnLocID,'',WarnDate,SelItem,WarnItems);
				} 
			});	
		}
		if (parseInt(ret)==-1){
			obj.WarnRepShow(WarnLocID,'',WarnDate,SelItem,WarnItems);
		}
	}
	
	obj.WarnRepShow =function (aLocID,aReportID,aWarnDate,aItem,aWarnItem){ 
		var url='./dhcma.hai.ir.ccwarningrep.csp?LocID='+ aLocID+'&ReportID='+aReportID+'&QryDate='+aWarnDate+'&SelItems='+aItem+'&WarnItems='+aWarnItem;
		websys_showModal({
			url:url,
			title:'医院感染暴发报告:'+aItem,
			iconCls:'icon-w-epr',
			width:1320,
			height:'95%'
		});
	}
	
	obj.IntubateInfo=function (){
		$('#IntubateInfo').dialog({
			title: '三管信息',
			iconCls:'icon-w-paper',
			modal: true,
			width:800,
			height:600,
			isTopZindex:false
		});
	}
	//三管
	obj.OperIntubate_Click = function (EpisodeID){	
		$('#IntubateInfo').show();
		obj.IntubateInfo();
		$('#IntubateTable').datagrid('load',{
			ClassName:"DHCHAI.IRS.ICULogSrv",
			QueryName:"QryICUAdmOeItem",
			aPaAdm:EpisodeID,
			aFlag:0
		});	
	}
	
	//摘要
	obj.OperSummer_Click = function(EpisodeID) {	
		var t=new Date();
		t=t.getTime();
		var strUrl = "./dhchai.ir.view.main.csp?PaadmID=" + EpisodeID + "&PageType=WinOpen&t=" + t;
		websys_showModal({
			url:strUrl,
			title:'医院感染集成视图',
			iconCls:'icon-w-paper',  
	        originWindow:window,
			width:window.screen.availWidth-40,
			height:window.screen.availHeight-80,
			onBeforeClose:function(){}  //若无词句,IE下打开一份报告关闭后，摘要无法关闭
		});
	}
}

