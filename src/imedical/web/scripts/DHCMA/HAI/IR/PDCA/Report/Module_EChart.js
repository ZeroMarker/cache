//PDCA'统计图'相关
function InitPARepWinChart(obj){
	//显示报表图
	obj.reportChart = function(){
		//报表		
    	obj.myChart = echarts.init(document.getElementById('main'));
        obj.myChart.resize();
        var myDate =$("#qryDate").datebox('getValue'); //获取今天日期
        function getNextDate(date,day) {  
		  var dd = new Date(date);
		  dd.setDate(dd.getDate() + day);
		  var y = dd.getFullYear();
		  var m = dd.getMonth() + 1 < 10 ? "0" + (dd.getMonth() + 1) : dd.getMonth() + 1;
		  var d = dd.getDate() < 10 ? "0" + dd.getDate() : dd.getDate();
		  return y + "-" + m + "-" + d;
		};
		var dateArray = []; 
		var dateTemp; 
		for (var i = 0; i < 7; i++) {
			dateTemp = getNextDate(myDate,-(6-i))
		    dateArray.push(dateTemp);
		}
        // 指定图表的配置项和数据 $.form.GetCurrDate("-")
        var option = {
			title: {
				text: '人数',
				show: true,
				x: 'center',
				textStyle: {
					fontSize: 14,
					fontWeight: 'bold',
				},
			},
			tooltip: {
				trigger: 'axis'
			},
			legend: {
				data:['发热']
			},
			toolbox: {
				show: true,
				padding: 5,
				feature: {
					dataZoom: {
						yAxisIndex: 'none'
					},
					dataView: {show: false,readOnly: false},
					magicType: {type: ['line', 'bar']},
					saveAsImage: {},
					restore: {}
				}
			},
			xAxis:  {
				type: 'category',
				boundaryGap: false,
				data:dateArray
			},
			yAxis: {
				type: 'value',
				axisLabel: {
					formatter: '{value}'
				}
			},
			series: [
				{
					name:'发热人数',
					type:'line',
					data:[],  //11, 11, 15, 13, 12, 13, 10
					markPoint: {
						data: [
							{type: 'max', name: '最大值'},
							{type: 'min', name: '最小值'}
						]
					},
					markLine: {
						data: [
							{type: 'average', name: '平均值'}
						]
					}
				}
			]
		};
		
        // 使用刚指定的配置项和数据显示图表。
        obj.myChart.setOption(option);
	};
	
	refreshChart = function () {
		/*if (obj.selLocID == null) return;
		IsActive=$("#WarnItem_24Hour").checkbox('getValue');
		IsActive = (IsActive==true? 1: 0);
		
		var retval = $m({
			ClassName:"DHCHAI.IRS.CCWarningNewSrv",
			MethodName:"GetCurrItemIndex",
			aLocID:obj.selLocID,
			aWarnDate:$("#qryDate").datebox('getValue'),
			aSelItem:obj.selItems,
			aFlag:IsActive
		},false);
		var titleTxt = obj.selItems.split("|")[0];
		if ((titleTxt.split(":")[0].indexOf("发热")>-1)) {
			titleTxt = "发热:"+titleTxt.split(":")[1];
		}
	    */
		var dataY = [];			
		/*if(retval!="") {
			dataY =retval.split("^");
		}*/
		var option = {
			title: {
				text: "sssss",
				subtext: ''
			},
			series: [
				{
					name:"人数",
					type:'line',
					data:dataY,  //11, 11, 15, 13, 12, 13, 10
					markPoint: {
						data: [
							{type: 'max', name: '最大值'},
							{type: 'min', name: '最小值'}
						]
					},
					markLine: {
						data: [
							{type: 'average', name: '平均值'}
						]
					}
				}
			]
		};
		obj.myChart.setOption(option);
	}
	
	
	//->刷新统计图
	obj.up=function(x,y){
        return y.InfPatCnt-x.InfPatCnt
    }
	obj.option1 = function(arrViewLoc,arrInfPatCnt,arrInfPatRatio,endnumber){
		var option1 = {
			title : {
				text: '三管汇总统计图',
				textStyle:{
					fontSize:25
				},
				x:'center',
				y:'top'
			},
			grid:{
				left:'5%',
				top:'17%',	
				right:'5%',
				bottom:'0%',
				containLabel:true
			},
			tooltip: {
				trigger: 'axis',
			},
			toolbox: {
				feature: {
					dataView: {show: false, readOnly: false},
					magicType: {show: true, type: ['line', 'bar']},
					restore: {show: true},
					saveAsImage: {show: true}
				}
			},
			legend: {
				data:['感染人数','感染率'],
				x: 'center',
				y: 30
			},
			 dataZoom: [{
				height: 30,
				show: true,
				realtime: true,
				start: 0,
				end: endnumber,
				bottom: 0,
				zoomLock:true
			}],
			xAxis: [
				{
					type: 'category',
					data: arrViewLoc,
					axisLabel: {
								margin:8,
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
				}
			],
			yAxis: [
				{
					type: 'value',
					name: '感染人数',
					min: 0,
					interval:Math.ceil(arrInfPatCnt[0]/10),
					axisLabel: {
						formatter: '{value} '
					}
				},
				{
					type: 'value',
					name: '感染率(%)',
					min: 0,
					interval:10,
					axisLabel: {
						formatter: '{value} %'
					}
				}
			],
			series: [
				 {
					name:'感染人数',
					type:'bar',
					barMaxWidth:50,
					data:arrInfPatCnt
				},
				{
					name:'感染率',
					type:'line',
					yAxisIndex: 1,
					data:arrInfPatRatio,
					label: {
						show:true,
						formatter:"{c}%"
					}
				}
				/*,
				{
					markLine: { //在38℃时加横提示线
						data: [
							{yAxis: 3}
						],
						symbol: ['none', 'none']
					}
		        }*/
			]
		};
		return option1;
	}
	
    obj.echartLocInfRatio = function(runQuery){
		if (!runQuery) return;
		var arrViewLoc 		= new Array;
		var arrInfPatCnt 	= new Array;
		var arrInfPatRatio 	= new Array;
		arrRecord 		= runQuery.record;
		
		var arrlength		= 0;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			//去掉全院、医院、科室组
			if ((rd["xDimensKey"].indexOf('-A-')>-1)||(rd["xDimensKey"].indexOf('-H-')>-1)||(rd["xDimensKey"].indexOf('-G-')>-1)) {
				delete arrRecord[indRd];
				arrlength = arrlength + 1;
				continue;
			}
			rd["DimensDesc"] = $.trim(rd["DimensDesc"]);  //去掉空格
			rd["InfPatRatio"] = parseFloat(rd["InfPatRatio"].replace('%','').replace('‰','')).toFixed(2);
		}
		
		arrRecord = arrRecord.sort(obj.up);
		arrRecord.length = arrRecord.length - arrlength;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			
			arrViewLoc.push(rd["DimensDesc"]);
			arrInfPatCnt.push(rd["InfPatCnt"]);
			arrInfPatRatio.push(parseFloat(rd["InfPatRatio"]).toFixed(2));
		}
		var endnumber = (14/arrViewLoc.length)*100;
		arrViewLoc.push("2022-07");
		arrViewLoc.push("2022-08");
		arrViewLoc.push("2022-09");
		arrViewLoc.push("2022-10");
		arrInfPatCnt.push("2")
		arrInfPatCnt.push("3")
		arrInfPatCnt.push("4")
		arrInfPatCnt.push("5")
		arrInfPatRatio.push("1.34")
		arrInfPatRatio.push("2.34")
		arrInfPatRatio.push("1.94")
		arrInfPatRatio.push("3.34")
		
		// 使用刚指定的配置项和数据显示图表
		obj.myChart.setOption(obj.option1(arrViewLoc,arrInfPatCnt,arrInfPatRatio,endnumber),true);
	}
   	obj.ShowEChaert1 = function(){
		obj.myChart.clear()
		//当月科室感染率图表
		var aHospID = "1|2|3";
		var aDateFrom = "2020-03-01";
		var aDateTo= "2020-03-31";
		var aLocType = "W";
		var aQryCon =  2;
		var dataInput = "ClassName=" + 'DHCHAI.STATV2.S010Inf' + "&QueryName=" + 'QryS010Inf' + "&Arg1=" + aHospID + "&Arg2=" + aDateFrom + "&Arg3=" + aDateTo +"&Arg4="+aLocType+"&Arg5="+aQryCon+"&ArgCnt=" + 5;

		$.ajax({
			url: "./dhchai.query.csp",
			type: "post",
			timeout: 30000, //30秒超时
			async: true,   //异步
			beforeSend:function(){
				obj.myChart.showLoading();	
			},
			data: dataInput,
			success: function(data, textStatus){
				obj.myChart.hideLoading();    //隐藏加载动画
				var retval = (new Function("return " + data))();
				//obj.echartLocInfRatio(retval);
				$('#EchartDivInfPos').addClass('no-result');	//无数据加载'无数据'图片
				
			},
			error: function(XMLHttpRequest, textStatus, errorThrown){
				var tkclass="DHCHAI.STATV2.S010Inf";
				var tkQuery="QryS010Inf";
				alert("类" + tkclass + ":" + tkQuery + "执行错误,Status:" + textStatus + ",Error:" + errorThrown);
				obj.myChart.hideLoading();    //隐藏加载动画
			}
		});
	}
	
    obj.InitChart=function(ID){
	    $('#'+ID).addClass('no-result');
	    /*
		// 基于准备好的dom，初始化echarts实例
	    obj.myChart = echarts.init(document.getElementById(ID),'theme');
		var xData = [];
		var yData = [];
		for (var i = 0;i<10;i++){
				xData.push(i);
				yData.push(i);
			}
		
		option = {
		    title: {
		        //text: '体温记录'
		    },
		    xAxis:  {
			    name : '日期',
			    nameLocation:'end',
			    nameGap:45,
		        type: 'category',
		        splitLine: {
		        	show:true,
		            lineStyle: {
		                type: 'dotted'
		            }
		        },
		        splitArea: {
		             show: true,
		             interval:function(index,value){
			         	if (index%6==0){
				        	return true;
				        }else{
					    	return false;
					    }
			         }
		        },
		        axisLabel: {  
				   interval:0,
				   formatter:function(value)
					{
						return 1;
					}
				},
		        boundaryGap: true,
		        data:xData
		    },
		    yAxis: {
			    name : '体温',
	            type : 'value',
	            min:'35',
	    		max:'42',
	    		splitLine: {
		            lineStyle: {
		                type: 'dotted'
		            }
		        },
		        axisLabel: {
		            formatter: '{value} °C'
		        }
	        },
		    series: [
		        {
		            name:'体温',
		            type:'line',
		            connectNulls:true,
					symbol: "emptyDiamond",
		            symbolSize:8,
		            data:yData,
		            // smooth:true,
		            markPoint: {
		                data: [
		                    {type: 'max', name: '最高体温'},
		                    {type: 'min', name: '最低体温'}
		                ]
		            },
					markLine: { //在38℃时加横提示线
						data: [
							{yAxis: 38}
						],
						symbol: ['none', 'none']
					}
		        }
		    ]
		};
	    obj.myChart.setOption(option);
    	*/
	}
}