function InitDischDiagWinEvent(obj){
	obj.LoadEvent = function(args){ 
		$("#btnQuery").on('click',function(){
			obj.reloadgridDischDiag();
		});
		$("#btnExport").on('click',function(){
			obj.btnExport_click();
		});
	}
	//查询
	obj.reloadgridDischDiag = function(){
		var ErrorStr="";
		var DateFrom 	= $("#DateFrom").datebox('getValue');
		var DateTo 		= $("#DateTo").datebox('getValue');
		if ((DateFrom == '')||(DateTo=='')) {
			ErrorStr += '出院日期不允许为空!<br/>';
		}
		if ((Common_CompareDate(DateFrom,DateTo))) {
			ErrorStr += '开始日期不能大于结束日期!<br/>';
		}if (ErrorStr != '') {
			$.messager.alert("错误提示",ErrorStr, 'info');
			return;
		}
		$('#gridDischDiag').datagrid('load',{
			ClassName:'DHCHAI.IRS.INFDiagnosSrv',
	        QueryName:'QryDischInfDiag',
	        aHospIDs:$("#cboHospital").combobox('getValue'),
	        aDateFrom:$("#DateFrom").datebox('getValue'),
	        aDateTo:$("#DateTo").datebox('getValue'),
	        aAdmLoc:$("#cboLocation").combobox('getValue'),
	        aStatus:$("#cboStatus").combobox('getValue'),
	        aMrNo:$("#txtMrNO").val(), 
			});
			$('#gridDischDiag').datagrid('unselectAll');
	};
	//摘要
	obj.btnAbstractMsg_Click = function(EpisodeID)
	{	
	    var strUrl = '../csp/dhchai.ir.view.main.csp?PaadmID='+EpisodeID+'&PageType=WinOpen';
	    
	    var Page=DHCCPM_Open(strUrl);
	};
	//电子病历
	obj.btnEmrRecord_Click = function(EpisodeID){		
		var rst = $m({
			ClassName:"DHCHAI.DPS.PAAdmSrv",
			MethodName:"GetPaAdmHISx",
			aEpisodeID:EpisodeID
		},false);
		if(rst=="")return;
		var EpisodeID = rst.split("^")[0];
		var PatientID = rst.split("^")[1];
		var strUrl = cspUrl+'&PatientID=' + PatientID+'&EpisodeID='+EpisodeID + '&DefaultOrderPriorType=ALL&2=2';		
		
		var Page=DHCCPM_Open(strUrl);
	};
	//病例跟踪
	obj.btnAddQuest_Click = function(EpisodeID)
	{		
		var t=new Date();
		t=t.getTime();
		var strUrl = "./dhcma.hai.ir.feedback.csp?EpisodeID=" + EpisodeID+"&TypeCode=3";
		websys_showModal({
			url:strUrl,
			title:'病例跟踪',
			iconCls:'icon-w-paper',  
			width:800,
			height:600,
			onBeforeClose:function(){}  //若无词句,IE下打开一份报告关闭后，摘要无法关闭
		});
	};
	
	obj.btnReprot_Click=function(EpisodeID) {
		if (!EpisodeID) return;
		var url = '../csp/dhcma.hai.ir.inf.report.csp?EpisodeID='+EpisodeID+'&1=1';
		websys_showModal({
			url:url,
			title:'医院感染报告',
			iconCls:'icon-w-epr',
			closable:false,
			width:1320,
			height:'95%',
			onBeforeClose:function(){
				obj.reloadgridDischDiag();
			}
		});
	}

	//确诊
	obj.qz = function(EpisodeID,index)
	{	
		var InputStr  = EpisodeID;
		InputStr += "^" + "1";             // 处置状态 确诊
		InputStr += "^" + "";              // 处置意见
		InputStr += "^" + $.LOGON.USERID;  // 处置人
	    var rst = $m({
			ClassName:"DHCHAI.IRS.CCDiagnosSrv",
			MethodName:"SaveCCDiagnos",
			aInputInfo:InputStr,
			separete:"^"
		},false);
		if (parseInt(rst) <= 0) {
				$.messager.alert("错误提示", "确诊失败" , 'info');		
		}else {
			var rowData = $("#gridDischDiag").datagrid('getChecked');
			$.messager.popover({msg: '确诊成功',type:'success',timeout: 1000});
			//$("#gridDischDiag").datagrid('reload')
			//obj.gridDischDiag.reload() ;//刷新当前页
			//按数据行刷新
			$('#gridDischDiag').datagrid('updateRow', {
			    index: index,
			    row: {
			        "ActStatus": '确诊'
			    }
			});
		}
	};
	// 疑似
	obj.ys = function(EpisodeID,index)
	{	
		var InputStr  = EpisodeID;
		InputStr += "^" + "2";             // 处置状态 确诊
		InputStr += "^" + "";              // 处置意见
		InputStr += "^" + $.LOGON.USERID;  // 处置人
	    var rst = $m({
			ClassName:"DHCHAI.IRS.CCDiagnosSrv",
			MethodName:"SaveCCDiagnos",
			aInputInfo:InputStr,
			separete:"^"
		},false);
		if (parseInt(rst) <= 0) {
				$.messager.alert("错误提示", "疑似失败" , 'info');		
			}else {
				$.messager.popover({msg: '疑似成功',type:'success',timeout: 1000});
				//obj.gridDischDiag.reload() ;//刷新当前页
				//$("#gridDischDiag").datagrid('reload')
				//按数据行刷新
				$('#gridDischDiag').datagrid('updateRow', {
				    index: index,
				    row: {
				        "ActStatus": '疑似'
				    }
				});
			}
	};
	// 排除
	obj.pc = function(EpisodeID,index)
	{	
		var InputStr  = EpisodeID;
		InputStr += "^" + "3";             // 处置状态 排除
		InputStr += "^" + "";              // 处置意见
		InputStr += "^" + $.LOGON.USERID;  // 处置人
	    var rst = $m({
			ClassName:"DHCHAI.IRS.CCDiagnosSrv",
			MethodName:"SaveCCDiagnos",
			aInputInfo:InputStr,
			separete:"^"
		},false);
		if (parseInt(rst) <= 0) {
			$.messager.alert("错误提示", "排除失败" , 'info');		
		}else {
			$.messager.popover({msg: '排除成功',type:'success',timeout: 1000});
			//obj.gridDischDiag.reload() ;//刷新当前页
			//$("#gridDischDiag").datagrid('reload')
			//按数据行刷新
			$('#gridDischDiag').datagrid('updateRow', {
			    index: index,
			    row: {
			        "ActStatus": '排除'
			    }
			});
		}
	};
	
	//导出
	obj.btnExport_click = function() {
		var rows=$("#gridDischDiag").datagrid('getRows').length;
		
		if (rows>0) {
			$('#gridDischDiag').datagrid('toExcel','出院感染诊断查询.xls');
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出", 'info');
			return;
		}	
	}
}