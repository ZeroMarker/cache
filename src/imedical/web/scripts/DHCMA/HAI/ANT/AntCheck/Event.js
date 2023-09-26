//页面Event
function InitAntCheckWinEvent(obj){
	
	obj.LoadEvent = function(args){
	
		//查询按钮
		$('#btnQuery').on('click', function(){
			var tDateFrom=$('#dtDateFrom').datebox('getValue');
			var tDateTo=$('#dtDateTo').datebox('getValue');
			var loc=$('#cboLoc').combobox('getValue');
			if ((tDateFrom!='')&&(tDateTo!='')) {
				var ret=Common_CompareDate(tDateFrom,tDateTo);
				if (ret>0) {
					$.messager.popover({msg: '开始日期不能大于结束日期！',type:'error',timeout: 1000})
					return;
				}
			} else {
				$.messager.popover({msg: '开始日期、结束日期不允许为空！',type:'error',timeout: 1000})
				return;
			}
			obj.gridAntCheckLoad();
		});	
		//导出
		$('#btnExport').on('click', function(){
			obj.gridAntMajorLoad();
			obj.gridAntMinorLoad();
			var rows = obj.gridMajor.getRows().length;
			if (rows>0) {
			   ExportGridByCls(obj.gridMajor,obj.gridMinor,'抗菌用药审核表');
			}else {
				$.messager.alert("确认", "无数据记录,不允许导出", 'info');
			}
		});	
	}
	
	//双击列事件
	obj.openHandler = function(aEpisodeID,aReportID,aOrdItemID){
		var strUrl = "./dhcma.hai.ant.report.csp?1=1"+
			"&EpisodeID=" + aEpisodeID + 
			"&ReportID=" + aReportID +
			"&OrdItemID="+ aOrdItemID+
			"&LocFlag=" + 0;
        	
	    websys_showModal({
			url:strUrl,
			title:'碳青霉烯/替加环素类抗菌药物用药申请表',
			iconCls:'icon-w-epr',
	        originWindow:window,
			width:1340,
			height:'90%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
			onBeforeClose:function(){
				obj.gridAntCheckLoad();  //刷新当前页
			}
		});
		
	}
	
	obj.gridAntCheckLoad = function(){	
		$cm ({
			ClassName:"DHCHAI.ANTS.OrdAntiPatSrv",
			QueryName:"QryAntiCheck",	
			ResultSetType:"array",			
	        aHospital:$('#cboHospital').combobox('getValue'),
			aDateFrom:$('#dtDateFrom').datebox('getValue'),
			aDateTo:$('#dtDateTo').datebox('getValue'),
			aLocDr:$('#cboLoc').combobox('getValue'),
			aAntiMastDr:$('#cboAntiMast').combobox('getValue'),
			aQryStatus:$('#cboQryStatus').combobox('getValue'),
			page:1,
			rows:999
		},function(rs){
			$('#AntCheck').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
		});
    }
    
    obj.gridAntMajorLoad = function(){	
		var rs=$cm ({
				ClassName:"DHCHAI.ANTS.OrdAntiPatSrv",
				QueryName:"QryAntiExport",	
				ResultSetType:"array",			
				aHospital:$('#cboHospital').combobox('getValue'),
				aDateFrom:$('#dtDateFrom').datebox('getValue'),
				aDateTo:$('#dtDateTo').datebox('getValue'),
				aLocDr:$('#cboLoc').combobox('getValue'),
				aAntiMastDr:$('#cboAntiMast').combobox('getValue'),
				aQryStatus:$('#cboQryStatus').combobox('getValue'),
				page:1,
				rows:999
			},false);
		$('#Major').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);	
 	}
    obj.gridAntMinorLoad = function(){	
		var rs=$cm ({
				ClassName:"DHCHAI.ANTS.OrdAntiPatSrv",
				QueryName:"QryEtiologyEvi",	
				ResultSetType:"array",			
				aHospital:$('#cboHospital').combobox('getValue'),
				aDateFrom:$('#dtDateFrom').datebox('getValue'),
				aDateTo:$('#dtDateTo').datebox('getValue'),
				aLocDr:$('#cboLoc').combobox('getValue'),
				aAntiMastDr:$('#cboAntiMast').combobox('getValue'),
				page:1,
				rows:999
			},false);
		$('#Minor').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);	
    }

}