//页面Event
function InitWinEvent(obj){
    obj.LoadEvent = function(args){ 
    	$('#search').on('click', function(){
	    	obj.btnQuery_click();
		});
		$('#btnExport').on('click', function(){
			obj.btnExport_click();
		});
		$('#btnExport2').on('click', function(){
			obj.btnExport2_click();
		});
		$('#sQuarter').hide();
		$('#sDateFrom').hide();
		$('#sDateTo').hide();
     }
    //窗体初始化
	obj.winQCDataPeo = $('#winQCDataPeo').dialog({
		title:'病种个人详细指标',
		iconCls:'icon-w-edit',  
		closed: true,
		modal: true,
		isTopZindex:true
	});
	 //图形窗体初始化
	obj.winGraphics = $('#winGraphics').dialog({
		title:"占比统计分析",
		iconCls:'icon-w-edit',  
		closed: true,
		modal: true,
		isTopZindex:true
	});
    obj.btnQuery_click = function(){
	    var HospID 	 = $("#Hospital").combobox("getValue");
		var DateType = $("#cboDateType").combobox("getValue");
		var Year 	 = $("#cboYear").combobox("getValue");
		var Quarter  = $("#cboQuarter").combobox("getValue");
	    var DateFrom = $("#DateFrom").datebox("getValue");
		var DateTo 	 = $("#DateTo").datebox("getValue");		
		var LocID 	 = $("#LocDic").combobox("getValue");
		var QCID 	 = $("#QCDic").combobox('getValue')
		if ((DateFrom!="")&&(Common_CompareDate(DateFrom,DateTo))){
			$.messager.alert("错误提示",'开始日期应小于或等于结束日期！','info');
			return;
		}
	    if (QCID==""){
			$.messager.alert("错误提示",'请选择病种! ','info');
			return;
		}
		if (DateType==""){
			$.messager.alert("错误提示",'请选择统计时间类型! ','info');
			return;
		}
		if (DateType=="1"&&Year==""){
			$.messager.alert("错误提示",'请选择年份! ','info');
			return;
		}
		obj.gridQCItemLoad();
	}
	
	obj.btnExport_click = function() {
		var rows = obj.gridType.getRows().length;  
		var Pname=$("#QCDic").combobox('getText')
		if (rows>0) {
			$('#gridType').datagrid('toExcel',Pname+'指标记录.xls');
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出", 'info');
			return;
		}
	}
	obj.btnExport2_click = function() {
		var rows = obj.gridTypePeo.getRows().length;  
		var Pname=$("#QCDic").combobox('getText')
		if (rows>0) {
			$('#gridTypePeo').datagrid('toExcel',Pname+'个人详细记录.xls');
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出", 'info');
			return;
		}
	}
	obj.OpenPeoReport=function(Year,Month){
		obj.gridQCPeoLoad(Year+"-"+Month,1)
		$HUI.dialog('#winQCDataPeo').open();
	}
	obj.OpenPeoReportAll=function(){
		obj.gridQCPeoLoad("",1)
		$HUI.dialog('#winQCDataPeo').open();
	}
	obj.gridQCItemLoad = function(ID){
		$cm ({
			ClassName:"DHCMA.CPW.SDS.QCIndexInfoSrv",
			MethodName:"GetDataByEntity",
			EntityId:$("#QCDic").combobox('getValue'),
			aType:"0"
		},function(rows){		
			$('#gridType').datagrid({
				 columns : rows,
				 pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
				 pageSize: 10,
				 pageList : [10,50]
			})
			$cm ({
				ClassName:"DHCMA.CPW.SDS.QCIndexInfoSrv",
				QueryName:"QryQCDataByEntity",
				aHospID:Common_GetValue('Hospital'),
				aEntity:$("#QCDic").combobox('getValue'),
				aDateFrom:$("#DateFrom").datebox('getValue'),
				aDateTo:$("#DateTo").datebox('getValue'),
				aLocID:$("#LocDic").combobox('getValue'),
				aStaType:$("#cboDateType").combobox("getValue"),
				ayear:$("#cboYear").combobox("getValue"),
				aQuarter:$("#cboQuarter").combobox("getValue"),
				aType:"0",
				ResultSetType:"array",
				page:1,
				rows:999
			},function(data){
				$('#gridType').datagrid({loadFilter:pagerFilter}).datagrid('loadData', data);
			});
		});
	}
	
	obj.gridQCPeoLoad = function(YMonth,flag){
		$cm ({
			ClassName:"DHCMA.CPW.SDS.QCIndexInfoSrv",
			MethodName:"GetDataByEntity",
			EntityId:$("#QCDic").combobox('getValue'),
			aType:"1"
		},function(rows){
		$('#gridTypePeo').datagrid({
			 columns : rows,
			 pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
			 pageSize: 10,
			 pageList : [10,50]
		})
		$.messager.progress({
				title: "提示",
				msg: '正在加载',
				text: '加载中....'
		});
		var DateFrom=$("#DateFrom").datebox('getValue');
		var DateTo=$("#DateTo").combobox("getValue");
		if ((YMonth!="")&&(DateFrom!="")){
			var DateFrom="";
			var DateTo=""
		}
		$cm ({
			ClassName:"DHCMA.CPW.SDS.QCIndexInfoSrv",
			QueryName:"QryQCDataByPeo",
			aHospID:Common_GetValue('Hospital'),
			aEntity:$("#QCDic").combobox('getValue'),
			aDate:YMonth,
			aLocID:$("#LocDic").combobox('getValue'),
			aDateFrom:DateFrom,
			aDateTo:DateTo,
			aStaType:$("#cboDateType").combobox("getValue"),
			ayear:$("#cboYear").combobox("getValue"),
			aQuarter:$("#cboQuarter").combobox("getValue"),
			aType:"1",
			ResultSetType:"array",
			page:1,
			rows:999
		},function(data){
			$.messager.progress("close");
			$('#gridTypePeo').datagrid({loadFilter:pagerFilter}).datagrid('loadData', data);
				
		});
	
	});
	}
	
	obj.gridQCPeoLoadAll = function(){
		$cm ({
			ClassName:"DHCMA.CPW.SDS.QCIndexInfoSrv",
			MethodName:"GetDataByEntity",
			EntityId:$("#QCDic").combobox('getValue'),
			aType:"1"
		},function(rows){
			$('#gridTypePeo').datagrid({
				 columns : rows,
				 pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
				 pageSize: 10,
				 pageList : [10,50]
			})
			$.messager.progress({
					title: "提示",
					msg: '正在加载',
					text: '加载中....'
			});
			$cm ({
				ClassName:"DHCMA.CPW.SDS.QCIndexInfoSrv",
				QueryName:"QryQCDataByPeo",
				aHospID:Common_GetValue('Hospital'),
				aEntity:$("#QCDic").combobox('getValue'),
				aDate:$("#DateFrom").datebox('getValue')+"^"+$("#DateTo").datebox('getValue'),
				aLocID:$("#LocDic").combobox('getValue'),
				aType:"1",
				ResultSetType:"array",
				page:1,
				rows:999
			},function(data){
				$.messager.progress("close");
				$('#gridTypePeo').datagrid({loadFilter:pagerFilter}).datagrid('loadData', data);
					
			});
		});
	}
	
	var myChart = echarts.init(document.getElementById('Case'), 'theme');
	obj.OpenGraphics=function(){
		var HospID 	 = $("#Hospital").combobox("getValue");
		var DateType = $("#cboDateType").combobox("getValue");
		var Year 	 = $("#cboYear").combobox("getValue");
		var Quarter  = $("#cboQuarter").combobox("getValue");
	    var DateFrom = $("#DateFrom").datebox("getValue");
		var DateTo 	 = $("#DateTo").datebox("getValue");		
		 	LocID 	 = $("#LocDic").combobox("getValue");
		var QCID 	 = $("#QCDic").combobox('getValue')
		$HUI.dialog('#winGraphics').open();
		//柱状图
		var option1 = {	
			title : {
				text: $("#QCDic").combobox('getText')+'占比指标统计',
				textStyle:{
					fontSize:20
				},
				x:'center',
				y:'top'
			},
			tooltip: {
				trigger: 'axis',
			},
			toolbox: {
				feature: {
					dataView: {show: false, readOnly: false},
					magicType: {show: true, type: ['line', 'bar']},
					restore: {show: true},
					saveAsImage: {show: true, pixelRatio: 2}
				}
			},
			grid: {
		    // top:48,
		    bottom: '22%', // 调整这个属性
		  },
			xAxis: [{
				type: 'category',
				data: [],
				axisLabel: {
					margin:15,
					rotate:45,
					interval:0,
					// 使用函数模板，函数参数分别为刻度数值（类目），刻度的索引
					formatter: function (value, index) {
						//处理标签，过长折行和省略
						if(value.length>6 && value.length<11){
							return value.substr(0,5)+'\n'+value.substr(5,5);
						}else if(value.length>10&&value.length<16){
							return value.substr(0,5)+'\n'+value.substr(5,5)+'\n'+value.substr(10,5);
						}else if(value.length>15&&value.length<21){
							return value.substr(0,5)+'\n'+value.substr(5,5)+'\n'+value.substr(10,5)+'\n'+value.substr(15,5);
						}else{
							return value;
						}
					}
				}
			}],
			yAxis: [
				{
					type: 'value',
					name: '',
					splitLine: {
						show: false
					},
					axisLabel: {
						formatter: '{value}% '
					}
				}
			],
			series: [
				{
					//name:'传染病病例数4',
					type:'bar',
					data:[],
					label: {
						show:true,
						formatter:"{c}%"
					}
				}
			]
		};
		
		//医生的柱状图
		var option = {
		  tooltip: {
		    trigger: 'axis',
		    axisPointer: {
		      // Use axis to trigger tooltip
		      type: 'shadow' // 'shadow' as default; can also be 'line' or 'shadow'
		    }
		  },
		  legend: {},
		  grid: {
		    //bottom: '22%',
		    //left:'1%',
		    containLabel: true
		  },
		  xAxis: {
		    type: 'value',
		    axisLabel: {
				formatter: '{value}% '
			}
		  },
		   yAxis: {
    		type: 'category',
  			},
  			series: []
		};
		
		
		// 使用刚指定的配置项和数据显示图表。
		if ((LocID=="")||(LocID==undefined)){
			myChart.setOption(option1,true);
			var dataInput = "ClassName=" + 'DHCMA.CPW.SDS.QCIndexInfoSrv' + "&QueryName=" + 'QryQCGraphicsData' + "&Arg1=" + QCID + "&Arg2=" + HospID + "&Arg3="+ DateType + "&Arg4="+ Year   +"&Arg5=" + Quarter +"&Arg6=" + DateFrom+"&Arg7=" + DateTo+"&ArgCnt=" + 7;
		}else{
			var dataInput = "ClassName=" + 'DHCMA.CPW.SDS.QCIndexInfoSrv' + "&QueryName=" + 'QryQCGraphicsLocData' + "&Arg1=" + QCID + "&Arg2=" + HospID + "&Arg3="+ DateType + "&Arg4="+ Year   +"&Arg5=" + Quarter +"&Arg6=" + DateFrom+"&Arg7=" + DateTo+"&Arg8=" + LocID+"&ArgCnt=" + 8;
			myChart.setOption(option,true);
		}		
			$.ajax({
				url: "./dhcma.query.csp",	//必须要有这个csp
				type: "post",
				timeout: 30000, //30秒超时
				async: true,   //异步
				beforeSend: function() {
					 myChart.showLoading();
				},
				data: dataInput,
				success: function(data, textStatus){
					myChart.hideLoading();    //隐藏加载动画
					var retval = (new Function("return " + data))();
					if ((LocID=="")||(LocID==undefined)){
						obj.echartRatio(retval);
					}else{
						obj.echartRatioLoc(retval);
					}
				},
				error: function(XMLHttpRequest, textStatus, errorThrown){
					$.messager.alert("提示","类执行错误,Status:" + textStatus + ",Error:" + errorThrown, 'info');
					myChart.hideLoading();    //隐藏加载动画
				}
			});
		}

	obj.echartRatio = function(runQuery){
		if (!runQuery) {
			$.messager.alert("提示","没有找到相关数据！", 'info');
			return;
		}
		var arrxAxis = new Array();
		var arrCount = new Array();
		var arrRecord = runQuery.record;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			var str= new Object();
			arrxAxis.push(rd["BTDesc"]);
			arrCount.push(rd["BTVal"]);
		}
		myChart.setOption({        //加载数据图表
			xAxis: {
				data: arrxAxis
			},
			series: [{
				data:arrCount
			}]
		});
		
	}
	obj.echartRatioLoc = function(runQuery){
		if (!runQuery) {
			$.messager.alert("提示","没有找到相关数据！", 'info');
			return;
		}
		var arryAxis = new Array();
		var arrCount = new Array();
		var arrData = new Array();
		var arrRecord = runQuery.record;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			if ((indRd!=0)&&(rd["BTLocName"]!=arrRecord[indRd-1]["BTLocName"])){
				obj.LocData={
					name:arrRecord[indRd-1]["BTLocName"],
					type: 'bar',
					stack: 'total',
					label: {
						show: true,
						formatter:"{c}%"
					},
					emphasis: {
						focus: 'series'
					},
					data: arrCount
				}
				var arryAxis = new Array();
				var arrCount = new Array();
				arrData.push(obj.LocData);
			}else if((indRd!=0)&&(indRd==(arrRecord.length-1))){
				obj.LocData={
					name:arrRecord[indRd-1]["BTLocName"],
					type: 'bar',
					stack: 'total',
					label: {
						show: true,
						formatter:"{c}%"
					},
					emphasis: {
						focus: 'series'
					},
					data: arrCount
				}
				arrData.push(obj.LocData)
			}
			arryAxis.push(rd["BTDesc"]);
			arrCount.push(rd["BTVal"]);
		}
		myChart.setOption({        //加载数据图表
			yAxis: {
				data: arryAxis
			},
			series: arrData
		});
		
	}
}