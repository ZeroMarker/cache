//页面Event
function InitItmScreenWinEvent(obj){	
	
	obj.LoadEvent = function(args){
	
		//查询
		$('#btnQuery').on('click', function(){
			obj.btnQuery_click();
		});
		//导出
		$('#btnExport').on('click', function(){
			obj.btnExport_click();
		});
	}
	
	obj.btnQuery_click = function() {	
		var aDateFrom 	= $('#dtDateFrom').datebox('getValue');
		var aDateTo		= $('#dtDateTo').datebox('getValue');
		if (Common_CompareDate(aDateFrom,aDateTo)>0) {
			$.messager.alert("提示","开始日期不能大于结束日期!");
			return;
		}
		obj.gridScreenOprLoad();
		obj.gridScreenDtlLoad();
		obj.EpisodeID="";
		obj.ScreenID="";	
		obj.ScreenDtl="";
		obj.gridScreenLogLoad();
	}
	
	obj.btnExport_click = function() {	
		var rows=$("#ScreenOpr").datagrid('getRows').length;			
		if (rows>0) {
			$('#ScreenOpr').datagrid('toExcel','疑似筛查处置统计.xls');
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出", 'info');
			return;
		}
	}	
	//加载统计
	obj.gridScreenOprLoad = function(){	
		obj.gridScreenOpr.load({
		    ClassName:"DHCHAI.IRS.CCScreenLogSrv",
			QueryName:"QrySuRuleOpr",
			aDateFrom:$('#dtDateFrom').datebox('getValue'),
			aDateTo:$('#dtDateTo').datebox('getValue'),
			aIsActive:1,
			page:1,    //可选项，页码，默认1
			rows:9999    //可选项，获取多少条数据，默认50
	    });
    }
	
	//单击选中事件
	obj.gridScreenOpr_onSelect = function (){
		var rowData = obj.gridScreenOpr.getSelected();
		var DiagCnt = parseInt(rowData["DiagNum"]);
		var	ExcCnt =  parseInt(rowData["ExcNum"]);
		if (rowData["RuleID"] == obj.RuleID) {
			obj.RuleID="";	
			obj.EpisodeID="";
			obj.ScreenID="";	
			obj.ScreenDtl="";	
			obj.gridScreenOpr.clearSelections();  //清除选中行
			obj.LoadChart(obj.DiagCnt,obj.ExcCnt);
		} else {	
			obj.RuleID = rowData["RuleID"];	
			obj.EpisodeID="";
			obj.ScreenID="";
			obj.ScreenDtl="";	
			obj.LoadChart(DiagCnt,ExcCnt);
		}
		obj.gridScreenDtlLoad(obj.RuleID);
		obj.gridScreenLogLoad();
		
	}	
	
	
	//加载明细
	obj.gridScreenDtlLoad =function(aRuleID) {
		obj.gridScreenDtl.load ({
			ClassName:"DHCHAI.IRS.CCScreenLogSrv",
			QueryName:"QrySuRuleOprDtl",
			aDateFrom:$('#dtDateFrom').datebox('getValue'),
			aDateTo:$('#dtDateTo').datebox('getValue'),
			aRuleID:obj.RuleID,
			aStatus:$('#cboStatus').combobox('getValue'),
			page:1,    //可选项，页码，默认1
			rows:9999    //可选项，获取多少条数据，默认50
		});
	}
	
	//单击选中事件
	obj.gridScreenDtl_onSelect = function (){
		var rowData = obj.gridScreenDtl.getSelected();
		if ((rowData["ScreeningID"]+"||"+rowData["ScreenDtlID"]) == obj.ScreenDtl) {
			obj.ScreenDtl="";
			obj.EpisodeID="";
			obj.ScreenID="";			
			obj.gridScreenDtl.clearSelections();  //清除选中行
		} else {
			obj.ScreenDtl=rowData.ScreeningID+"||"+rowData.ScreenDtlID;		
			obj.EpisodeID=rowData.EpisodeID;
			obj.ScreenID=rowData.ScreeningID;
		}
		obj.gridScreenLogLoad();
	}	
	
	
	//加载日志
	obj.gridScreenLogLoad =function() {
		obj.gridScreenLog.load ({
			ClassName:"DHCHAI.IRS.CCScreenLogSrv",
			QueryName:"QrySrceenDtlLog",
			aEpisodeID:obj.EpisodeID,
			aScreenID:obj.ScreenID,
			page:1,    //可选项，页码，默认1
			rows:9999    //可选项，获取多少条数据，默认50
		});
	}
	
	//单人疑似筛查
	obj.PatScreenShow = function(EpisodeID) {
		var t=new Date();
		t=t.getTime();
		var strUrl = "./dhcma.hai.ir.patscreening.csp?1=1&EpisodeDr=" + EpisodeID+'&1=1';
		websys_showModal({
			url:strUrl,
			title:'疑似病例筛查',
			iconCls:'icon-w-paper',  
	        originWindow:window,
			width:'95%',
			height:'95%',
			onBeforeClose:function(){}  //若无词句,IE下打开一份报告关闭后，摘要无法关闭
		});
	}

	obj.LoadChart = function (aDiagCnt,aExcCnt) {
		var myChart = echarts.init(document.getElementById('EchartDiagExc'));
		
		option = {
			tooltip: {
				trigger: 'item',
			},
			title: {
				text: '确诊排除占比',
				textStyle:{
					fontWeight : 'normal',
					fontSize:16
				},
				left: 'left'
			},
			legend: {
				orient: 'vertical',
		        x: 'left',
                y: 'bottom',
		        textStyle: { 
		        	fontSize: 10
		        },
		        data: ['确诊', '排除']
			},
			series: [
				{				
					type: 'pie',
					radius: ['40%', '70%'],
					itemStyle : {
		                normal : {
		                    label : {
		                        show : false   //隐藏标示文字
		                    },
		                    labelLine : {
		                        show : false   //隐藏标示线
		                    }
		                }
		            },
					data: [
						{ value: aDiagCnt, name: '确诊' },
						{ value: aExcCnt, name: '排除' }
					 ]
				}
			]
		};
		myChart.setOption(option);	
	}
	
	
	obj.LoadItemChart = function (arrRecord) {		
		var arrResultDesc 	= new Array();
		var arrResultCnt 	= new Array();
		var len = arrRecord.length;
	    if (len<1) return;
		
		for (var indRd = 0; indRd < len; indRd++){
			var rd =arrRecord[indRd];
			arrResultDesc.push(rd["RuleNote"]);
			arrResultCnt.push(parseInt(rd["DiagNum"])+ parseInt(rd["ExcNum"]));
		}
		var myChartItem = echarts.init(document.getElementById('EchartItem'));
		
		var arrLegend = arrResultDesc;
		option = {
			tooltip: {
				trigger: 'item',
		        position:function(p){ //其中p为当前鼠标的位置
					return [p[0]-80 , p[1]-50];
				}
			},
			title: {
				text: '疑似操作Top10',
				textStyle:{
					fontWeight : 'normal',
					fontSize:16
				},
				left: 'left'
			},
			series: [
				{
					type: 'pie',
					radius: ['40%', '70%'],
					itemStyle : {
		                normal : {
		                    label : {
		                        show : false   //隐藏标示文字
		                    },
		                    labelLine : {
		                        show : false   //隐藏标示线
		                    }
		                }
		            },
					data: (function(){
				        var arr=[];
				       	for (var i = 0; i < 10; i++) {	
 							arr.push({"value": arrResultCnt[i],"name":arrResultDesc[i]});
						}
						return arr;  
				    })()
				}
			]
		};
		myChartItem.setOption(option);	
	}
}
