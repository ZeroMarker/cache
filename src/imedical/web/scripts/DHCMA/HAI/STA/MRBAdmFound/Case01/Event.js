function InitWinEvent(obj){
	
	var myChart = echarts.init(document.getElementById('EchartDiv'), 'theme');
	var option1 = {
		title : {
			text: '多重耐药菌发现率'
		},
		tooltip: {
			trigger: 'axis',
		},
		toolbox: {
			"show": true
		},
		legend: {
			data:['多耐例数','发现率','住院人数'],
			selected: {
				'住院人数': false
			}
		},
		xAxis: [{
			type: 'category',
			data: [],
			axisLabel: {
				margin:8,
				rotate:45,
				interval:0
			}
		}],
		yAxis: [
			{
				type: 'value',
				name: '多耐例数',
				splitLine: {
					show: false
				},
				axisLabel: {
					formatter: '{value} '
				}
			},
			{
				type: 'value',
				name: '发现率(%)',
				splitLine: {
					show: false
				},
				axisLabel: {
					formatter: '{value} %'
				}
			}
		],
		series: [
			{
				name:'多耐例数',
				type:'bar',
				data:[],
				label: {
					show:true,
					formatter:"{c}"
				}
			},
			{
				name:'发现率',
				type:'line',
				yAxisIndex: 1,
				data:[],
				label: {
					show:true,
					formatter:"{c}%"
				}
			},
			{
				name:'住院人数',
				type:'bar',
				data:[],
				label: {
					show:true,
					formatter:"{c}"
				}
			}
		]
	};
	// 使用刚指定的配置项和数据显示图表。
	myChart.setOption(option1,true);
	
    //查询按钮
    $("#btnQuery").on('click', function(){
		var HospID=$("#cboHospital").combobox("getValue");
		var LocID=$("#cboLocation").combobox("getValue");
		var MonthFrom=$("#DateFrom").datebox("getValue");
		var MonthTo=$("#DateTo").datebox("getValue");
		
		var dataInput = "ClassName=" + 'DHCHAI.STAS.ChartsSrv' + "&QueryName=" + 'QryECResultByTime' +"&Arg1=" + LocID + "&Arg2=" + MonthFrom + "&Arg3=" + MonthTo + "&Arg4=MRBAdmCount&Arg5=InHospCount" + "&Arg6=" +HospID+"&ArgCnt=" + 6;
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
			$.messager.alert("简单提示", ErrorStr, "info");
			return;
		}
	
		$.ajax({
			url: "./dhchai.query.csp",
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
				obj.echartRatio(retval);
			},
			error: function(XMLHttpRequest, textStatus, errorThrown){
				alert("类" + tkclass + ":" + tkQuery + "执行错误,Status:" + textStatus + ",Error:" + errorThrown);
				myChart.hideLoading();    //隐藏加载动画
			}
		});
		
	});
	
	
	
	obj.echartRatio = function(runQuery){
		
		if (!runQuery) {
			$.messager.alert("简单提示", "没有找到相关数据", "info");
			return;
		}
		var arrxAxis = new Array();
		var arrRatio = new Array();
		var arrMRBCount = new Array();
		var arrInHospCount = new Array();
		var arrRecord = runQuery.record;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			arrxAxis.push(rd["ECTime"]);
			arrMRBCount.push(rd["Value1"]);
			arrInHospCount.push(rd["Value2"]);
			arrRatio.push(parseFloat(rd["Ratio"]).toFixed(2));
		}
		myChart.setOption({        //加载数据图表
			xAxis: {
				data: arrxAxis
			},
			series: [{
				data:arrMRBCount
			},{
				data:arrRatio
			},{
				data:arrInHospCount
			}]
		});
	}
}

