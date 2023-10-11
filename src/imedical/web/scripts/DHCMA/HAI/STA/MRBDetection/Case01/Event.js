function InitCtlResultWinEvent(obj){
	
	//初始化图表
	var myChart = echarts.init(document.getElementById('EchartDiv'),'theme');
	
	var option1 = {
		title : {
			text: '多重耐药菌检出率'
		},
		tooltip: {
			trigger: 'axis',
		},
		toolbox: {
			"show": true
		},
		legend: {
			data:['多耐例数','检出率','相应病原体'],
			selected: {
				'相应病原体': false
			}
		},
		xAxis: [{
			type: 'category',
			data: [],
			axisLabel: {
				margin:8,
				rotate:45,
				interval:0
				// 使用函数模板，函数参数分别为刻度数值（类目），刻度的索引
				,formatter: function (value, index) {
					//处理标签，过长折行和省略
					if(value.length>6 && value.length<11){
						return value.substr(0,7)+'\n'+value.substr(7,3);
					}else if(value.length>10){
						return value.substr(0,6)+'\n'+value.substr(6,5)+"...";
					}else{
						return value;
					}
				}
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
			},{
				type: 'value',
				name: '检出率(%)',
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
				name:'检出率',
				type:'line',
				yAxisIndex: 1,
				data:[],
				label: {
					show:true,
					formatter:"{c}%"
				}
			},{
				name:'相应病原体',
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
	
	//切换查询类型
	 $HUI.radio("[name='cboType']",{
        onChecked:function(e,value){
            if ($(e.target).val()=="1"){
	            $("#cboMRBRule").combobox("setValue",""); 
	            $("#cboMRBRule").combobox('disable');
	            
            }else{
	            $("#cboMRBRule").combobox('enable');
            }
        }
    });
    //查询按钮
    $("#btnQuery").on('click', function(){
		var HospID=$("#cboHospital").combobox("getValue");
		var LocID=$("#cboLocation").combobox("getValue");
		var MonthFrom=$("#DateFrom").datebox("getValue");
		var MonthTo=$("#DateTo").datebox("getValue");
		var Type = $("input[name='cboType']:checked").val();
		var MRBRule = $("#cboMRBRule").combobox("getValue");
		
		if (Type==1){
			//按多耐
			var dataInput = "ClassName=" + 'DHCHAI.STAS.MRBDetectionSrv' + "&QueryName=" + 'QryMRBDetection' + "&Arg1="+HospID+"&Arg2=" + LocID + "&Arg3=" + MonthFrom + "&Arg4=" + MonthTo + "&Arg5=1&ArgCnt=" + 5;
		} else if(Type==2) {
			//按时间
			var dataInput = "ClassName=" + 'DHCHAI.STAS.MRBDetectionSrv' + "&QueryName=" + 'QryMRBDeteByTime'+ "&Arg1="+HospID+"&Arg2=" + LocID + "&Arg3=" + MonthFrom + "&Arg4=" + MonthTo + "&Arg5=1&Arg6=" + MRBRule + "&ArgCnt=" + 6;
		} else if(Type==3) {
			//按科室
			var dataInput = "ClassName=" + 'DHCHAI.STAS.MRBDetectionSrv' + "&QueryName=" + 'QryMRBDeteByLoc' + "&Arg1="+HospID+"&Arg2=" + LocID + "&Arg3=" + MonthFrom + "&Arg4=" + MonthTo + "&Arg5=1&Arg6=" + MRBRule + "&Arg7=&ArgCnt=" + 7;
		}
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
			$.messager.alert("简单提示", '没有找到相关数据', "info");
			return;
		}
		var arrxAxis = new Array();
		var arrRatio = new Array();
		var arrMRBCount = new Array();
		var arrBactCount = new Array();
		var arrRecord = runQuery.record;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			arrxAxis.push(rd["AxisName"]);
			arrMRBCount.push(rd["Numerator"]);
			arrBactCount.push(rd["Denominator"]);
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
				data:arrBactCount
			}]
		});
	}
   
}

