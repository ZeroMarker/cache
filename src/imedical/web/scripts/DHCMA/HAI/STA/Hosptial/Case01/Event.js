
function InitCtlResultWinEvent(obj){
	obj.myChart = echarts.init(document.getElementById('Case01'),'theme');

	obj.loadEvent = function(args){
		obj.ShowEChart1();	
	}
	
	obj.ShowEChart1 = function(){
		obj.myChart.clear()
		 //当月科室感染率图表
		var dataInput = "ClassName=" + 'DHCHAI.STAS.ChartsSrv' + "&QueryName=" + 'QryLocInfRatio' + "&Arg1=" + $.LOGON.LOCID 	+ "&Arg2=" + $('#SearchMonth').datebox("getValue") + "&ArgCnt=" + 2;
		$.ajax({
			url: "./dhchai.query.csp",
			type: "post",
			timeout: 30000, //30秒超时
			async: true,   //异步
			data: dataInput,
			success: function(data, textStatus){
				var retval = (new Function("return " + data))();
				obj.echartLocInfRatio(retval);
			},
			error: function(XMLHttpRequest, textStatus, errorThrown){
				var tkclass="DHCHAI.STAS.ChartsSrv";
				var tkQuery="QryLocInfRatio";
				alert("类" + tkclass + ":" + tkQuery + "执行错误,Status:" + textStatus + ",Error:" + errorThrown);
			}
		});
	   obj.echartLocInfRatio = function(runQuery){
			if (!runQuery) return;
			var arrViewLoc = new Array();
			var arrInfRatio = new Array();
			var arrInfCount = new Array();
			obj.arrLocG= new Array();
			var arrRecord = runQuery.record;
			for (var indRd = 0; indRd < arrRecord.length; indRd++){
				var rd = arrRecord[indRd];
				arrViewLoc.push(rd["LocDesc"]);
				arrInfCount.push(rd["InfCount"]);
				arrInfRatio.push(parseFloat(rd["InfRatio"]).toFixed(2));
				obj.arrLocG.push(rd["LocID"]);
			}
			var option1 = {
				title : {
					text: '感染例次（率）统计图',
					x:'left'
				},
				tooltip: {
					trigger: 'axis',
				},
				toolbox: {
					"show": true,
					right:'18px'
				},
				legend: {
					data:['感染例次','感染率'],
					textStyle: {
			            color: "#000000",
			            fontSize: 16
			        }
				},
				xAxis: [
					{
						type: 'category',
						data: arrViewLoc,
						/* axisPointer: {
							type: 'shadow'
						} */
						axisLabel: {
									margin:8,
									rotate:45,
									interval:0,
									// 使用函数模板，函数参数分别为刻度数值（类目），刻度的索引
									formatter: function (value, index) {
										//处理标签，过长折行和省略
										if(value.length>6 && value.length<11){
											return value.substr(0,5)+'\n'+value.substr(5,5);
										}else if(value.length>10){
											return value.substr(0,6)+'\n'+value.substr(6,4)+"...";
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
						name: '感染例次',
				        nameTextStyle: {
				            color: '#000000',
				       		//padding: [0, 0, 10, -10]
				        },
						min: 0,
						interval:10,
						axisLabel: {
							formatter: '{value} '
						}
					},
					{
						type: 'value',
						name: '感染率(%)',
						nameTextStyle: {
				            color: '#000000',
				       		//padding: [0, 0, 10, -10]
				        },
						min: 0,
						interval:10,
						axisLabel: {
							formatter: '{value} %'
						}
					}
				],
				series: [
					 {
						name:'感染例次',
						type:'bar',
						barMaxWidth:50,
						data:arrInfCount
					},
					{
						name:'感染率',
						type:'line',
						yAxisIndex: 1,
						data:arrInfRatio,
						label: {
							show:true,
							formatter:"{c}%"
						}
					}
				   
				]
			};
			// 使用刚指定的配置项和数据显示图表。
			obj.myChart.setOption(option1,true);
		}
	}
  
	obj.ShowEChart2 = function(){
		var dataInput = "ClassName=" + 'DHCHAI.STAS.ChartsSrv' + "&QueryName=" + 'QryInfPosByRep' + "&Arg1=" +  "&Arg2=" + 	1 + "&Arg3=" + 	$('#SearchMonth').datebox("getValue") + "&ArgCnt=" + 3;
		$.ajax({
			url: "./dhchai.query.csp",
			type: "post",
			timeout: 30000, //30秒超时
			async: true,   //异步
			data: dataInput,
			success: function(data, textStatus){
				var retval = (new Function("return " + data))();
				obj.echartPosDescPie(retval);
			},
			error: function(XMLHttpRequest, textStatus, errorThrown){
				var tkclass="DHCHAI.STAS.ChartsSrv";
				var tkQuery="QryInfPosByRep";
				alert("类" + tkclass + ":" + tkQuery + "执行错误,Status:" + textStatus + ",Error:" + errorThrown);
			}
			});
			obj.echartPosDescPie = function(runQuery){
			   if (!runQuery) return;
				var arrPosDesc = new Array();
				var arrPosCount = new Array();
				
				var arrRecord = runQuery.record;
				for (var indRd = 0; indRd < arrRecord.length; indRd++){
					var rd = arrRecord[indRd];
					arrPosDesc.push(rd["PosDesc"]);
					arrPosCount.push({"value":rd["PosCount"],"name":rd["PosDesc"]});
				}
				
			var option2 = {
				title : {
					text: '感染诊断统计图',
					x:'center'
				},
				tooltip : {
					trigger: 'item',
					formatter: "{a} <br/>{b} : {c} ({d}%)"
				},
				 toolbox: {
					"show": true
				},
				legend: {
					orient: 'vertical',
					left: 'right',
					top:'middle',
					data: arrPosDesc
				},
				series : [
					{
						name: '感染诊断',
						type: 'pie',
						radius : '55%',
						center: ['50%', '60%'],
						data:arrPosCount,
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
			// 使用刚指定的配置项和数据显示图表。
			obj.myChart.setOption(option2,true);
		}
	}
	
	obj.ShowTable1 = function(){
			
		obj.myChart.clear()
		 //当月科室感染率图表
		var dataInput = "ClassName=" + 'DHCHAI.STAS.ChartsSrv' + "&QueryName=" + 'QryLocInfRatio' + "&Arg1=" +$.LOGON.LOCID+ "&Arg2=" + $('#SearchMonth').datebox("getValue") + "&ArgCnt=" + 2;
		$.ajax({
			url: "./dhchai.query.csp",
			type: "post",
			timeout: 30000, //30秒超时
			async: true,   //异步
			data: dataInput,
			success: function(data, textStatus){
				var retval = (new Function("return " + data))();
				obj.MakeTable(retval);
				
			},
			error: function(XMLHttpRequest, textStatus, errorThrown){
				var tkclass="DHCHAI.STAS.ChartsSrv";
				var tkQuery="QryLocInfRatio"
				alert("类" + tkclass + ":" + tkQuery + "执行错误,Status:" + textStatus + ",Error:" + errorThrown);
			}
		});
		obj.MakeTable = function(runQuery){
			if (!runQuery) return;
			$('#gridInfList').datagrid('loadData', runQuery.record);			
			
		}
	}
	
	
	obj.myChart.on('click', function (params) {
		
		if (params.value>0){
			if (params.seriesType=="line"){
				if (params.seriesIndex==1){
					var LocID=obj.arrLocG[params.dataIndex];	//医务处，代表全院
					var Month=obj.DateFrom;
					var RepType="";
					var strHtml="";
					var dataInput = "ClassName=" + 'DHCHAI.STAS.ChartsSrv' + "&QueryName=" + 'QryInfPatList' + "&Arg1=" + LocID + "&Arg2=" + Month + "&Arg3=" + RepType + "&ArgCnt=" + 3;
					$.ajax({
						url: "./dhchai.query.csp",
						type: "post",
						timeout: 30000, //30秒超时
						async: true,   //异步
						data: dataInput,
						success: function(data, textStatus){
							var retval = (new Function("return " + data))();
							var arrRecord = retval.record;
							return
							 //配置窗体-初始化
							
							$HUI.dialog('#tableInfList').open();
							
						},
						error: function(XMLHttpRequest, textStatus, errorThrown){
							alert("执行错误,Status:" + textStatus + ",Error:" + errorThrown);
						}
					});
				}
			}
		}
	}); 
}
