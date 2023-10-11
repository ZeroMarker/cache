function InitWinEvent(obj){
	obj.myChart = echarts.init(document.getElementById('EchartDiv'),'theme');
	var option1 = {
		title : {
			text: '器械相关感染统计',
			x:'left'
		},
		tooltip: {
			trigger: 'axis',
		},
		toolbox: {
			"show": true
		},
		legend: {
			data:['使用日数','感染率','感染人数'],
			selected: {
				'感染人数': false
			}
		},
		xAxis: [
			{
				type: 'category',
				data: [],
				axisLabel: {
							margin:12,
							rotate:45,
							interval:0,
							// 使用函数模板，函数参数分别为刻度数值（类目），刻度的索引
							formatter: function (value, index) {
								//处理标签，过长折行和省略
								if(value.length>7){
									return value.substr(0,8)+'\n'+value.substr(8,15);
								}else{
									return value;
								}
							} 
						}
			}
		],
		yAxis: [
			{
				type: 'value',
				name: '使用日数',
				splitLine: {
					show: false
				},
				axisLabel: {
					formatter: '{value} '
				}
			},
			{
				type: 'value',
				name: '感染率(‰)',
				splitLine: {
					show: false
				},
				axisLabel: {
					formatter: '{value} ‰'
				}
			}
		],
		series: [
			 {
				name:'使用日数',
				type:'bar',
				data:[],
				barMaxWidth:50,
				label: {
					show:true,
					formatter:"{c}"
				}
			},
			{
				name:'感染率',
				type:'line',
				yAxisIndex: 1,
				data:[],
				label: {
					show:true,
					formatter:"{c}‰"
				}
			},
			{
				name:'感染人数',
				type:'bar',
				yAxisIndex: 1,
				data:[],
				label: {
					show:true,
					formatter:"{c}"
				}
			}
		   
		]
	};
	// 使用刚指定的配置项和数据显示图表。
	obj.myChart.setOption(option1);
	
	obj.LoadEvent = function(args){
		//查询按钮
		$("#btnQuery").on('click', function(){
			obj.btnQuery_click()
		});
		obj.btnQuery_click()
   	}
	
	
	obj.echartLocInfRatio = function(runQuery){
		if (!runQuery) {
			layer.alert("查询失败！请检查查询条件！",{icon: 2});
			return  false;
		}
		var arrTime = new Array();
		var arrInfRatio = new Array();
		var arrInfCount = new Array();
		var arrDateCount = new Array();
		
		var arrRecord = runQuery.record;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			arrTime.push(rd["ECTime"]);
			arrInfCount.push(rd["Value1"]);
			arrDateCount.push(rd["Value2"]);
			arrInfRatio.push(parseFloat(rd["Ratio"]*10).toFixed(2));
		}
		obj.myChart.setOption({        //加载数据图表
			xAxis: {
				data: arrTime
			},
			series: [{
				data:arrDateCount
			},{
				data:arrInfRatio
			},{
				data:arrInfCount
			}]
		});
		
   }
   
	obj.myChart.on('click', function (params) {
		return;
		if (params.value>0){
			if (params.seriesType=="line"){
				if (params.seriesIndex==1){
					var LocID=$.form.GetValue("cboInfLocation");
					var Month=obj.arrTimeG[params.dataIndex];
					var RepType=$.form.GetValue("cboRepType");
					var strHtml="";
					var dataInput = "ClassName=" + 'DHCHAI.STAS.ChartsSrv' + "&QueryName=" + 'QryInfPatList' + "&Arg1=" + LocID + "&Arg2=" + Month + "&Arg3=" + RepType + "&ArgCnt=" + 3;
					$.ajax({
						url: "./dhchai.query.csp",
						type: "post",
						timeout: 30000, //30秒超时
						async: true,   //异步
						data: dataInput,
						success: function(data, textStatus){
							
						},
						error: function(XMLHttpRequest, textStatus, errorThrown){
							alert("执行错误,Status:" + textStatus + ",Error:" + errorThrown);
						}
					});
				}
			}
		}
	});
	obj.btnQuery_click=function(){
		var LocID=$("#cboInfLocation").combobox("getValue")
		var MonthFrom=$("#DateFrom").datebox("getValue")
		var MonthTo=$("#DateTo").datebox("getValue")
		var RepType=$("#cboRepType").combobox("getValue")
		var HAICase=""
		var TubeCount=""
		
		switch(RepType)
		{
			case "1":
				HAICase="INFUC";
				TubeCount="CountUC";
				break;
			case "2":
				HAICase="INFVAP";
				TubeCount="CountVAP";
				break;
			case "3":
				HAICase="INFPICC";
				TubeCount="CountPICC";
				break;
		}
		
		var dataInput = "";

		var ErrorStr = "";
		if (MonthFrom=="") {
			ErrorStr += '请选择开始日期!<br/>';
		}
		if (MonthTo == "") {
			ErrorStr += '请选择结束日期!<br/>';
		}
		if (MonthFrom > MonthTo) {
			ErrorStr += '开始日期不能大于结束日期!<br/>';
		}
		if (ErrorStr != '') {
				$.messager.alert("简单提示",ErrorStr, "info");
				return;
		}
		dataInput = "ClassName=" + 'DHCHAI.STAS.ChartsSrv' + "&QueryName=" + 'QryECResultByTime' + "&Arg1=" + LocID + "&Arg2=" + MonthFrom + "&Arg3=" + MonthTo+ "&Arg4=" + HAICase + "&Arg5=" + TubeCount + "&ArgCnt=" + 5;
		
		$.ajax({
			url: "./dhchai.query.csp",
			type: "post",
			timeout: 30000, //30秒超时
			async: true,   //异步
			beforeSend: function() {
				obj.myChart.showLoading();
			},
			data: dataInput,
			success: function(data, textStatus){
				obj.myChart.hideLoading();    //隐藏加载动画
				var retval = (new Function("return " + data))();
				obj.echartLocInfRatio(retval);
			},
			error: function(XMLHttpRequest, textStatus, errorThrown){
				var tkclass="DHCHAI.STAS.ChartsSrv"
				var QueryName="QryECResultByTime"
				alert("类" + tkclass + ":" + tkQuery + "执行错误,Status:" + textStatus + ",Error:" + errorThrown);
				obj.myChart.hideLoading();    //隐藏加载动画
			}
		});
		
	}
	
}