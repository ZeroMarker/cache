//页面Event
function InitViewportEvent(obj){	
    
	obj.LoadEvent = function(args){ 
		$('#gridRepInfo').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
		obj.btnQuery_click();
		//查询
		$('#btnQuery').on('click', function(){
			obj.btnQuery_click();
		});
		// 选择导出
		$('#btnExport').on('click', function(){
			obj.btnExport_click();
		});
		// 打印报告
		$('#btnPrint').on('click', function(){
			obj.btnPrint_click();
		});
     	// 批量审核
		$('#btnCheck').on('click', function(){
			obj.btnCheck_click();
		});
	
		//登记号回车查询事件
		$('#txtRegNo').keydown(function (e) {
			var e = e || window.event;
			if (e.keyCode == 13) {
				RegNo=$('#txtRegNo').val().replace(/(^\s*)|(\s*$)/g, "");
				if ($.trim(RegNo)=="") return;
				var Reglength=RegNo.length;
				for(var i=0;i<(10-Reglength);i++)
				{
					RegNo="0"+RegNo;
				}
				$('#txtRegNo').val(RegNo);
				obj.gridRepInfoLoad();
			}	
		});
	}
    
	obj.btnQuery_click = function() {
		var FromDate = $('#txtFromDate').datebox('getValue')
		var ToDate = $('#txtToDate').datebox('getValue')
		if ((FromDate == '')||(ToDate == '')) {
			$.messager.alert("提示","开始日期、结束日期不允许为空!");
		}
		if (Common_CompareDate(FromDate,ToDate)>0) {
			$.messager.alert("提示","开始日期不能大于结束日期!");
		}
		obj.gridRepInfoLoad();
	}
	obj.btnExport_click = function() {
		var rows = obj.gridRepInfo.getRows().length;  
		if (rows>0) {
			var length = obj.gridRepInfo.getChecked().length;
			if (length>0) {
				$('#gridRepInfo').datagrid('toExcel', {
				    filename: '非职业co中毒报告查询表.xls',
				    rows: obj.gridRepInfo.getChecked(),
				    worksheet: 'Worksheet'
				});
			} else {
				$.messager.alert("提示", "先选择查询记录,再进行导出!",'info');
				return;
			} 
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出", 'info');
			return;
		}
	}
	// 批量审核
	obj.btnCheck_click = function() {
		var record = obj.gridRepInfo.getChecked();
		var length = obj.gridRepInfo.getChecked().length; 	
		if (length>0) {
			var Count=0;
			for (var row = 0; row < length; row++) {
				var aReportID =  record[row]["ReportID"];
				var StatusDesc = record[row]["RepStatusDesc"];
				var CheckStr=aReportID+"^"+2+"^"+session['LOGON.USERID']+"^"+session['LOGON.CTLOCID'];
				if (StatusDesc == '上报') {
					var ret = $m({                  
						ClassName:"DHCMed.CD.CRReport",
						MethodName:"CheckReport",
						aInput:CheckStr,
						separete:"^"
					},false);
					Count++;
				}
			}
			if (Count < 1) {
				$.messager.alert("提示信息", "请至少选中一行待审记录,再进行审核!",'info');
				return;
			}
			$.messager.popover({
				msg: '批量审核成功',
				type: 'success',
				timeout: 2000, 		//0不自动关闭。3000s
				showType: 'slide'  //show,fade,slide
			});
			obj.gridRepInfoLoad();
			obj.gridRepInfo.clearSelections();  ;  //清除所有选择的行
		} else {
			$.messager.alert("提示信息", "先选择待审记录,再进行审核!",'info');
			return;
		}
		var rows = obj.gridRepInfo.getRows().length; 
		if(rows<1){
			$.messager.alert("提示","请先查询，再批量审核！",'info');
			return;
		}		
	}
	// 打印报告
	obj.btnPrint_click = function() {
		var record = obj.gridRepInfo.getChecked();
		var length = obj.gridRepInfo.getChecked().length; 	
		if (length>1) {
			$.messager.alert("提示", "打印报告只能选择一条报告", 'info');
			return;
		}else if (length==1){
			var aReportID =  record[0]["ReportID"];
			var PrintStr=aReportID+"^"+session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+"PRINT";
			var ret = $m({                  
				ClassName:"DHCMed.CD.CRReport",
				MethodName:"ExportReport",
				aInput:PrintStr,
				separete:"^"
			},false);
			if(parseInt(ret)<=0){
				$.messager.alert("错误","打印打印失败!"+ret, 'error');
				return;
			}else{
				var LODOP=getLodop();
				LODOP.PRINT_INIT("PrintCDFZYCOInfo");		//打印任务的名称
				LODOP.ADD_PRINT_HTM(1,600,300,100,"<span tdata='pageNO'>第##页</span>/<span tdata='pageCount'>共##页</span>");
				LODOP.SET_PRINT_STYLEA(0,"ItemType",1);			//每页都打印页码
				LODOP.SET_PRINT_MODE("DOUBLE_SIDED_PRINT", 0);	//人工双面打印(打印机不支持双面打印时，1为不双面打印，0为单面打印，2为双面打印)
				LODOP.SET_PRINT_MODE("PRINT_DUPLEX", 0);		//自动双面打印(打印机支持双面打印时，1为不双面打印，0为单面打印，2为双面打印)
				LodopPrintURL(LODOP,"dhcma.cd.lodopfzyco.csp?ReportID="+aReportID);
				LODOP.PRINT();			//直接打印
			}
		}else{
			$.messager.alert("提示","先选择查询记录，再打印报告！",'info');
			return;
		}
	}
	//打开链接
	obj.OpenReport = function(aReportID,aEpisodeID) {
		var strUrl= "./dhcma.cd.reportfzyco.csp?1=1&ReportID=" + aReportID + "&EpisodeID=" + aEpisodeID +"&LocFlag=" + LocFlag;
	    websys_showModal({
			url:strUrl,
			title:'CO中毒报卡',
			iconCls:'icon-w-epr',  
	        originWindow:window,
	        closable:false,
			width:1320,
			height:'90%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
			dataRow:{ReportID:aReportID},  
			onBeforeClose:function(){
				obj.gridRepInfoLoad();  //刷新
			} 
		});
	}
	
	obj.gridRepInfo_click = function() {
		var rowData = obj.gridRepInfo.getSelected();
		var index = obj.gridRepInfo.getRowIndex(rowData);  //获取当前选中行的行号(从0开始)
		
		var ReportID = rowData["ReportID"];
		var EpisodeID = rowData["EpisodeID"];
        var strUrl= "./dhcma.cd.reportfzyco.csp?1=1&ReportID=" + ReportID + "&EpisodeID=" + EpisodeID +"&LocFlag=" + LocFlag;

	    websys_showModal({
			url:strUrl,
			title:'CO中毒报卡',
			iconCls:'icon-w-epr',  
	        originWindow:window,
	        closable:false,
			width:1320,
			height:'90%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
			dataRow:{ReportID:ReportID},  
			onBeforeClose:function(){
				obj.gridRepInfoLoad();  //刷新
			} 
		});
	}
	
	obj.gridRepInfoLoad = function(){	
		$("#gridRepInfo").datagrid("loading");		
		$cm ({
			ClassName:"DHCMed.CDService.QryService",
			QueryName:"QryFZYCORepByDate",		
			aFromDate: $('#txtFromDate').datebox('getValue'), 
			aToDate: $('#txtToDate').datebox('getValue'),
			aHospID:$('#cboHospital').combobox('getValue'),   			
			aRepLoc: $('#cboRepLoc').combobox('getValue'), 
			aRepStatus: Common_CheckboxValue('chkStatusList'),
			aPatName:$('#txtPatName').val(),
			aRegNo:$('#txtRegNo').val(),
	    	page:1,
			rows:99999
		},function(rs){
			$('#gridRepInfo').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
		});
    }
	obj.OpenEMR =function(aEpisodeID,aPatientID) {
		var strUrl = cspUrl+"&PatientID=" + aPatientID+"&EpisodeID="+aEpisodeID + "&2=2";
		//var strUrl = "./emr.record.browse.csp?PatientID=" + aPatientID+"&EpisodeID="+aEpisodeID + "&2=2";
	    websys_showModal({
			url:strUrl,
			title:'病历浏览',
			iconCls:'icon-w-epr',  
	        originWindow:window,
			width:'98%',
			height:'98%'
		});
	}
}