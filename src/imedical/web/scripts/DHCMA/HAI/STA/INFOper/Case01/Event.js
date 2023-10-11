function InitEvent(obj){
	
	//初始化图表
	var myChart = echarts.init(document.getElementById('EchartDiv'),'theme');
	obj.loadEvent=function(){
		
		obj.setOption();
	}
	obj.setOption=function(){
		if (obj.QryOpption=="label01"){
			obj.QueryName = "QryECResultByTime";
			obj.Numerator = "INFOper";
			obj.Denominator = "OperCount";
			
			var option1 = {
				title : {
					text: '手术切口感染统计',
					x:'left'
				},
				tooltip: {
					trigger: 'axis',
				},
				toolbox: {
					"show": true
				},
				legend: {
					data:['感染例数','感染率','手术例数'],
					selected: {
						'手术例数': false
					}
				},
				xAxis: [
					{
						type: 'category',
						data: [],
						axisLabel: {
							margin:8,
							rotate:45
						}
					}
				],
				yAxis: [
					{
						type: 'value',
						name: '感染例数',
						splitLine: {
							show: false
						},
						axisLabel: {
							formatter: '{value} '
						}
					},{
						type: 'value',
						name: '感染率(‰)',
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
						name:'感染例数',
						type:'bar',
						data:[],
						label: {
							show:true,
							formatter:"{c}"
						}
					},{
						name:'感染率',
						type:'line',
						yAxisIndex: 1,
						data:[],
						label: {
							show:true,
							formatter:"{c}%"
						}
					},{
						name:'手术例数',
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
		} else if(obj.QryOpption=="label02") {
			obj.QueryName = "QryECResultByTime";
			obj.Numerator = "INFOper1";
			obj.Denominator = "Oper1Count";
			
			var option1 = {
				title : {
					text: '手术切口感染统计',
					x:'left'
				},
				tooltip: {
					trigger: 'axis',
				},
				toolbox: {
					"show": true
				},
				legend: {
					data:['感染例数','感染率','I类切口例数'],
					selected: {
						'I类切口例数': false
					}
				},
				xAxis: [
					{
						type: 'category',
						data: [],
						axisLabel: {
							margin:8,
							rotate:45
						}
					}
				],
				yAxis: [
					{
						type: 'value',
						name: '感染例数',
						splitLine: {
							show: false
						},
						axisLabel: {
							formatter: '{value} '
						}
					},{
						type: 'value',
						name: '感染率(‰)',
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
						name:'感染例数',
						type:'bar',
						data:[],
						barMaxWidth:50,
						label: {
							show:true,
							formatter:"{c}"
						}
					},{
						name:'感染率',
						type:'line',
						yAxisIndex: 1,						
						data:[],
						label: {
							show:true,
							formatter:"{c}%"
						}
					},{
						name:'I类切口例数',
						type:'bar',
						data:[],
						barMaxWidth:50,
						label: {
							show:true,
							formatter:"{c}"
						}
					}
				   
				]
			};
			// 使用刚指定的配置项和数据显示图表。
			myChart.setOption(option1,true);
		} else if(obj.QryOpption=="label03") {
			obj.QueryName = "QryECResultForPie";
			obj.ItemStr = "INFSuperInc^INFDeepInc^INFOrganInc";
			var option2 = {
				title : {
					text: '感染诊断统计图',
					x:'center'
				},
				tooltip : {
					trigger: 'item',
					formatter: "{a} <br/>{b} : {c} ({d}%)",
					textStyle: {
						fontSize: 20
					}
				},
				 toolbox: {
					"show": true,
					feature: {
						mark: {show: true}
					}
				},
				legend: {
					orient: 'vertical',
					left: 'right',
					top:'middle',
					data: []
				},
				series : [
					{
						name: '感染诊断',
						type: 'pie',
						radius : '55%',
						center: ['50%', '60%'],
						data:[],
						itemStyle: {
							emphasis: {
								shadowBlur: 10,
								shadowOffsetX: 0,
								shadowColor: 'rgba(0, 0, 0, 0.5)'
							}
						},
						label: {
							show:true,
							formatter:"{b}\n {c} ({d}%)",
							fontSize:18
						}
					}
				]
			};
			myChart.setOption(option2,true);
		}
	}
	
    obj.echartLineBar = function(runQuery){
	    if (!runQuery) alert(1);
		var arrTime = new Array();
		var arrInfRatio = new Array();
		var arrInfCount = new Array();
		var arrOperCount = new Array();

		var arrRecord = runQuery.record;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			arrTime.push(rd["ECTime"]);
			arrInfCount.push(rd["Value1"]);
			arrOperCount.push(rd["Value2"]);
			arrInfRatio.push(parseFloat(rd["Ratio"]).toFixed(2));
		}
		myChart.setOption({        //加载数据图表
			xAxis: {
				data: arrTime
			},
			series: [{
				data:arrInfCount
			},{
				data:arrInfRatio
			},{
				data:arrOperCount
			}]
		});
		
    }
	
	obj.echartPie = function(runQuery){
		if (!runQuery) return;
		var arrItemDesc = new Array();
		var arrValue = new Array();
		var arrRecord = runQuery.record;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			var ItemDesc=rd["ItemDesc"].replace(/感染例数/,"")
			arrItemDesc.push(ItemDesc);
			arrValue.push({"value":rd["Value"],"name":ItemDesc});
		}
		myChart.setOption({        //加载数据图表
			legend: {
				data: arrItemDesc
			},
			series: [{
				data:arrValue
			}]
		});
	}
	obj.keyWords_onClick=function(kayId){
		obj.QryOpption=kayId
		obj.setOption();
		var LocID=$("#cboInfLocation").combobox("getValue")
		var MonthFrom=$("#DateFrom").datebox("getValue")
		var MonthTo=$("#DateTo").datebox("getValue")
		//当月科室感染率图表
		var dataInput = "ClassName=" + 'DHCHAI.STAS.ChartsSrv' + "&QueryName=" + obj.QueryName + "&Arg1=" + LocID + "&Arg2=" + MonthFrom + "&Arg3=" + MonthTo+ "&Arg4=" + obj.Numerator + "&Arg5=" + obj.Denominator + "&ArgCnt=" + 5;
		if(obj.QryOpption=="label03") dataInput = "ClassName=" + 'DHCHAI.STAS.ChartsSrv' + "&QueryName=" + obj.QueryName + "&Arg1=" + LocID + "&Arg2=" + MonthFrom + "&Arg3=" + MonthTo+ "&Arg4=" + obj.ItemStr + "&ArgCnt=" + 4;
		
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
				if(obj.QryOpption=="label01") {
					obj.echartLineBar(retval);
				} else if(obj.QryOpption=="label02") {
					obj.echartLineBar(retval);
				} else if(obj.QryOpption=="label03") {
					obj.echartPie(retval);
				}
			},
			error: function(XMLHttpRequest, textStatus, errorThrown){
				alert("执行错误,Status:" + textStatus + ",Error:" + errorThrown);
				myChart.hideLoading();    //隐藏加载动画
			}
		});
				
	}
}

