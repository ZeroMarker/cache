﻿function InitOCCStaChartWinEvent(obj){
   	obj.LoadEvent = function(args){
		$('#ReportFrame').css('display', 'block');
		setTimeout(function(){
			//obj.LoadRep();
		},50);
		//表的点击事件
		$('#btnSearchTable').on('click',function(e,value){
			obj.LoadRep();
		});
   	}
	var myChart02 = echarts.init(document.getElementById('Case02'),'theme');
	option02 = {
	    title : {
			text: '职业暴露统计占比饼图',
			textStyle:{
				fontSize:20
			},
			x:'center',
			y:'top'
		},
	    tooltip: {
	        trigger: 'item',
	        formatter: '{a} <br/>{b} : {c} ({d}%)'
	    },
		toolbox: {
			feature: {
				dataView: {show: false, readOnly: false},
				magicType: {show: false, type: ['line', 'bar']},
				saveAsImage: {show: true, pixelRatio: 2}
			}
		},
	    legend: {
	        orient: 'vertical',
	        left: 'left',
	        padding:[120,0,0,0],
	        data: []
	    },
	    series: [
	        {
	            name: '暴露例数',
	            type: 'pie',
	            radius: '55%',
	            center: ['50%', '50%'],
	            data: [],
	            label: {
	            	normal: {
                		show: true,
                		position: 'left',
                		formatter:'{b}'+'\n'+'{d}' + '%'
            		}
            	},
	            emphasis: {
	                itemStyle: {
	                    shadowBlur: 10,
	                    shadowOffsetX: 0,
	                    shadowColor: 'rgba(0, 0, 0, 0.5)'
	                }
	            }
	        }
	    ]
	};
	myChart02.setOption(option02,true);
	
	var myChart = echarts.init(document.getElementById('Case01'), 'theme');
	var option1 = {
		title : {
			text: '职业暴露统计例数',
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
		legend: {
			data:['暴露例数'],
			x: 'center',
			y: 40
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
				name: '暴露例数',
				splitLine: {
					show: false
				},
				axisLabel: {
					formatter: '{value} '
				}
			}
		],
		series: [
			{
				name:'暴露例数',
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
	
   	obj.LoadRep = function(){
		var aHospIDs 	= $('#cboHospital').combobox('getValue');
		var aDateType 	= $('#cboDateType').combobox('getValue');
		var aDateFrom 	= $('#dtDateFrom').datebox('getValue');
		var aDateTo		= $('#dtDateTo').datebox('getValue');
		var aDicType  	= $('#cboDicType').combobox('getValue');
		var aRepType 	= $('#cboRepType').combobox('getValue');

		if(aDateFrom > aDateTo){
			$.messager.alert("提示","开始日期应小于或等于结束日期！", 'info');
			return;
		}
		if ((aDateFrom=="")||(aDateTo=="")){
			$.messager.alert("提示","请选择开始日期、结束日期！", 'info');
			return;
		}
		if (aDicType==""){
			$.messager.alert("提示","请选择统计项目！", 'info');
			return;
		}
		
		myChart.showLoading();	//隐藏加载动画
		$cm({
			ClassName:"DHCHAI.STA.OccRepStaSrv",
			QueryName:"QryOccCaseSata",
			aHospIDs:aHospIDs, 
			aRegType:aRepType,
			aDateFrom:aDateFrom, 
			aDateTo:aDateTo, 
			aDicTypeCode:aDicType, 
			aDateType:aDateType,
			page: 1,
			rows: 999
		},function(rs){
			myChart.hideLoading();    //隐藏加载动画
			obj.echartRatio(rs);
		});
	}
	obj.echartRatio = function(runQuery){
		
		if (!runQuery) {
			$.messager.alert("提示","没有找到相关数据！", 'info');
			return;
		}
		var arrxAxis = new Array();
		var arrCount = new Array();
		var arrCount02 = new Array();
		var arrRecord = runQuery.rows;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			var str= new Object();
			arrxAxis.push(rd["BTDesc"]);
			arrCount.push(rd["Numerator"]);
			if (rd["Numerator"]>0){
				str.name  = rd["BTDesc"];
				str.value = rd["Numerator"];
				arrCount02.push(str);
			}
		}
		myChart.setOption({        //加载数据图表
			xAxis: {
				data: arrxAxis
			},
			series: [{
				data:arrCount
			}]
		});
		
		myChart02.setOption({        //加载数据图表
			legend: {
				data: arrxAxis
			},
			series: [{
				data:arrCount02
			}]
		});
	}
}
