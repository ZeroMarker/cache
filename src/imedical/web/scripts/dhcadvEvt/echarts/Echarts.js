///Creator:bianshuai
var ECharts={
 	///Echarts配置文件的引入
    ChartConfig:function (container, option) {
	 	//container:为页面要渲染图表的容器，option为已经初始化好的图表类型的option配置
	    require.config({//引入常用的图表类型的配置
	    	paths: {
	            echarts: "../scripts/dhcadvEvt/echarts/echarts-2.2.1/build/dist"
	            }
	        });
	    this.option = { chart: {}, option: option, container: container};
	    return this.option;
	 },
	 ///数据格式化
	ChartDataFormate:{  
        FormateNOGroupData: function (data) {
            var categories = [];
            var datas = [];
            for (var i = 0; i < data.length; i++) {  
				categories.push(data[i].name || "");   
				   datas.push({ name: data[i].name, value: data[i].value || 0 ,itemStyle:data[i].itemStyle||{}});
				}
	         return { category: categories, data: datas };
        },  
        FormateGroupData: function (data, type, is_stack) {
  			//data的格式如上的Result2，type为要渲染的图表类型：可以为line，bar，is_stack表示为是否是堆积图，这种格式的数据多用于展示多条折线图、分组的柱图  
            var chart_type = 'line';
            if (type){
            	chart_type = type || 'line';
                }
      
				var xAxis = []; 
	            var xAxisnext = [];   
	            var group = [];
	            var series = [];  
	            var bltrate = [];
	            for (var i = 0; i < data.length; i++) {
	                for (var j = 0; j < xAxis.length && xAxis[j] != data[i].name; j++);  
	                if (j == xAxis.length)  
	                    xAxis.push(data[i].name);  
	                    xAxisnext.push("");
	  
	                for (var k = 0; k < group.length && group[k] != data[i].group; k++);  
	                if (k == group.length)
	                    group.push(data[i].group);  
	            }  
 
                for (var i = 0; i < group.length; i++) {
                    var temp = [];
                    var sum = 0 ;
                    for (var j = 0; j < data.length; j++) {
                        if (group[i] == data[j].group) {
                            if (type == "map"){  
                            	temp.push({ name: data[j].name, value: data[i].value });
                    		}else{
                            	temp.push(data[j].value);
                            	sum = sum+data[j].value;
                    		}
                        }
                   }
			     if (sum==0) bltrate = [];
				 var numall=0;
				 var numsFlag= 0;
			     for (var m=0;m<temp.length;m++){
				 	numall = numall+temp[m];
					var nums = numall/sum;
				  	nums = nums *100;
				 	nums = Math.ceil(nums);
				 	bltrate.push(nums);
			    }
                 	
                    var markPoint_data=[
						{type : 'max', name: '最大值'},
						{type : 'min', name: '最小值'}
					];
					
			
                    var markLine_data=[
                    	//{type : 'average', name: '平均值'}
                    ];
                    
	                switch (type) {
	                    case 'bar':  
	                        var series_temp = { name: group[i], data: temp, type: chart_type , markPoint : { data : markPoint_data} , markLine : { data : markLine_data},itemStyle: {
	                                normal: { color:'#5ABCFE'},
	                                emphasis: { label: { show: true} }
	                            }}; 
	                        if (is_stack)  
	                            series_temp = $.extend({}, { stack: 'stack' }, series_temp);
	                        break;
	                    case 'blt':  
	                   
	                        var series_temp = { xAxisnext:xAxisnext,bltrate:bltrate,name: group[i], data: temp, type: chart_type , markPoint : { data : markPoint_data} , markLine : { data : markLine_data},itemStyle: {
	                                normal: { color:'#5ABCFE'},
	                                emphasis: { label: { show: true} },
	                                
	                            }}; 
	                        if (is_stack)  
	                            series_temp = $.extend({}, { stack: 'stack' }, series_temp);
	                        break;
	                    
	                    case 'line':
	                        var series_temp = { name: group[i], data: temp, type: chart_type , markLine : { data : markLine_data}};
	                        if (is_stack)
	                            series_temp = $.extend({}, { stack: 'stack' }, series_temp);
	                        break;
	                    default:
	                        var series_temp = { name: group[i], data: temp, type: chart_type };
	                }
	                series.push(series_temp);
            	}
            return { category: group, xAxis: xAxis, series: series };        }
	},
	///图表类型的配置初始化
	ChartOptionTemplates:{
    	CommonOption: {//通用的图表基本配置
           	tooltip: {
                trigger: 'axis'//tooltip触发方式:axis以X轴线触发,item以每一个数据项触发
            },
            toolbox: {
                show: true, //是否显示工具栏
                feature: {
                	mark : { show: true }, //画线
                    //dataView: { show: true, readOnly: false }, //数据预览
                    restore : { show: true }, //复原
                    saveAsImage : { show: true } //是否保存图片
                }
            }
        },
        CommonLineOption: {//通用的折线图表的基本配置
            tooltip: {
                trigger: 'axis'
            },
            toolbox: {
                show: true,
                feature: {
                	mark : { show: true }, //画线
                    //dataView: { show: true, readOnly: false }, //数据预览
                    restore : { show: true }, //复原
                    saveAsImage : { show: true }, //是否保存图片
                   	magicType : { show: true, type: ['line', 'bar']} //支持柱形图和折线图的切换     cy去掉(, 'stack', 'tiled'堆积，平铺)
                }
            }
        },
        Pie: function (data, name) {//data:数据格式：{name：xxx,value:xxx}... ///饼状图
            var pie_datas = ECharts.ChartDataFormate.FormateNOGroupData(data);
            var option = {
                tooltip: {
                    //trigger: 'item',
                    formatter: '{b} : {c} ({d}%)',
                    show: true
                },
                legend: {
                    orient: 'vertical',
                    x: 'left',
                    data: pie_datas.category
                },
                calculable : true,
                series: [
                {
                    name: name || "",
                    type: 'pie',
                    radius: '65%',
                    center: ['50%', '50%'],
                    data: pie_datas.data,
            		itemStyle:{
            			normal:{
                  			label:{
                    			show: true,
                   			 	formatter: '{b}({d}%)'
                  			},
                  			labelLine :{show:true}
                		}
            		}
                 }
                ]
            };
            return $.extend({}, ECharts.ChartOptionTemplates.CommonOption, option);
        },
		Lines: function (data, name, is_stack) { //data:数据格式：{name：xxx,group:xxx,value:xxx}... ///折线图
            var stackline_datas = ECharts.ChartDataFormate.FormateGroupData(data, 'line', is_stack);

            var option = {
                legend: {
                    data: stackline_datas.category
                },
                xAxis: [{
                    type: 'category', //X轴均为category，Y轴均为value
                    data: stackline_datas.xAxis //,
                    //boundaryGap: false//数值轴两端的空白策略
                }],
                yAxis: [{
                    name: name || ''//,
                    //type: 'value',
                    //splitArea: { show: true }
                }],
                series: stackline_datas.series
            };
            return $.extend({}, ECharts.ChartOptionTemplates.CommonLineOption, option);
        },
        //qqa 2018-12-18 扩展一个对象，用于以后界面需要单独改变的情况
		Bars: function (data, name,is_stack,extObs) {//data:数据格式：{name：xxx,group:xxx,value:xxx}... ///柱状图
           	extObs = (extObs==undefined?{}:extObs);
            var defExtObs={
	        	grid:{},  	//设置图像前后边距  
	        }
	        extObs = $.extend(defExtObs,extObs)
            var bars_dates = ECharts.ChartDataFormate.FormateGroupData(data, 'bar', is_stack);
            var defGrid={ // 控制图的大小，调整下面这些值就可以，
         		x: 50, //前面距离 //hxy 2020-03-31 原：30
         		x2:30, //后面距离
         		y: 20,
         		y2:80// y2可以控制 X轴跟Zoom控件之间的间隔，避免以为倾斜后造成 label重叠到zoom上  下面距离
     		}
            var grid = $.extend(defGrid,extObs.grid);
            
            var option = {
                legend: {
                    data: bars_dates.category
                },
                 tooltip: {
                    //trigger: 'item',
                    formatter: '{b} : {c}',
                    show: true
                },
                grid:grid,
                xAxis: [{
                    type: 'category',
                    data: bars_dates.xAxis,
                    axisLabel: {
                        show: true,
                        interval: 0,
                        //rotate: 15,
                        margion: 8,
                        formatter:function(params){
	                        if(is_stack=="#"){
	                       		var newParamsName= GetParamsName(params,4);
	                        	return newParamsName.split("").join("\n");//竖列显示
	                        }else{
		                        return params;
		                    }
	                    }
                    }
                }],
                yAxis: [{
                    type: 'value',
                    name: name || '',
                    splitArea: { show: true }
                }],
                series: bars_dates.series
            };
            return $.extend({}, ECharts.ChartOptionTemplates.CommonLineOption, option);
        },
        //柏拉图
		Blt: function (data, name,is_stack,extObs,grid) {//data:数据格式：{name：xxx,group:xxx,value:xxx}... ///柱状图
			//var colors = ['#5ABCFE']

           	extObs = (extObs==undefined?{}:extObs);
            var defExtObs={
	        	grid:{},  	//设置图像前后边距 
	        }
	        extObs = $.extend(defExtObs,extObs)
            var bars_dates = ECharts.ChartDataFormate.FormateGroupData(data, 'blt', is_stack);
			var colorflag=0  // 80%颜色标记，只标记最接近80%的一个
            var defGrid={ // 控制图的大小，调整下面这些值就可以，
         		x: 50, //前面距离 //hxy 2020-03-31 原：30
         		x2:50, //后面距离
         		y: 50,
         		y2:80// y2可以控制 X轴跟Zoom控件之间的间隔，避免以为倾斜后造成 label重叠到zoom上  下面距离
     		}
            var grid = $.extend(defGrid,extObs.grid);
            
           var option = {
	           		grid:grid,
					title : {
						text : '测试'
					},
					tooltip : {
						trigger : 'axis',
						axisPointer : { // 坐标轴指示器，坐标轴触发有效
							type : 'shadow' // 默认为直线，可选为：'line' | 'shadow'
						}
					},
					legend : {
						//selectedMode : false,
						data : ['数量', '比例']
					},
					toolbox : {
						show : true,
						feature : {
							mark : {
								show : true
							},
							dataView : {
								show : true,
								readOnly : false
							},
							restore : {
								show : true
							},
							saveAsImage : {
								show : true
							}
						}
					},
					xAxis : [{
						type : 'category',
						data : bars_dates.xAxis,
						axisLabel: {
                        show: true,
                        interval: 0,
                        //rotate: 15,
                        margion: 8,
                        formatter:function(params){
	                        if(is_stack=="#"){
		                        if(params.indexOf("输血不良反应")>=0){
			                        params="输血反应"
			                    }
	                       		var newParamsName= GetParamsName(params);
	                        	return newParamsName.split("").join("\n");//竖列显示
	                        }else{
		                        return params;
		                    }
	                    }
                    }

					},              
						 {
						type : 'category',
						data : bars_dates.series[0].xAxisnext,
						
						axisLabel: {    //重点在这一块，其余可以忽略
							interval: 0,   //这个一定要有，别忘记了
							rotate: 50,
							textStyle: {
								color: '#000',
								fontSize: 10
							}
						},
					}],
					yAxis : [{
								type : 'value',
								boundaryGap : [0, 0.1],
								splitLine : false
							}, {
								type : 'value',
								name : '比例',
								axisLabel : {
									formatter : '{value} %'
									/*formatter:function(params){
										if(params>80){
											alert(1)
											}
										}*/
								},
								splitLine : true
							}],
					series : [{
								name : '数量',
								type : 'bar',
								barCategoryGap : '0%',
								itemStyle : {
									normal : {
										/* color : function(obj) {
											if (obj.dataIndex >= 0) {
												return colors[0];
											}
										}, */
										barBorderWidth : 1,
										barBorderRadius : 0,
										label : {
											show : false,
											position : 'insideTop'
										}
									}
								},
								data : bars_dates.series[0].data
							}, {
								name : '比例',
								type : 'line',
								xAxisIndex : 1,
								yAxisIndex : 1,
								data : bars_dates.series[0].bltrate,
								itemStyle : {
									normal : {
										/* color : function(obj) {
												var data = obj.data

												if((data>=75)&&(data<100)&&(colorflag==0)){
													colorflag=1
													return "red"
												
												}else{
													return "#04B404";
													}
												
										} */
									}
								}
							}

					]
				};


            return $.extend({}, ECharts.ChartOptionTemplates.CommonLineOption, option);
        }
	},
	///图形的渲染
	Charts:{
	    RenderChart: function (option) {
	       require([
		        'echarts',
		        'echarts/chart/bar',
		        'echarts/chart/line',
                'echarts/chart/pie',  
                'echarts/chart/k',  
                'echarts/chart/scatter',  
                'echarts/chart/radar', 
                'echarts/chart/chord',
                'echarts/chart/force',
                'echarts/chart/map' 
	       ],
	       function (ec) {
				echarts = ec;
	            //if (option.chart && option.chart.dispose)
	            //option.chart.dispose();
	            option.chart = echarts.init(option.container);
	            //window.onresize = option.chart.resize;
	            option.chart.setOption(option.option, true);
	       });
	   }
	} 	
}  
// Bar类型的 x轴文字显示换行
function GetParamsName(params,provideNumber){
    var newParamsName = "";// 最终拼接成的字符串
    var paramsNameNumber = params.length;// 实际标签的个数
	if((provideNumber=="")||(provideNumber==undefined)){
		provideNumber=4;
	}//  provideNumber 每行能显示的字的个数
    var rowNumber = Math.ceil(paramsNameNumber / provideNumber);// 换行的话，需要显示几行，向上取整
    
    // 判断标签的个数是否大于规定的个数， 如果大于，则进行换行处理 如果不大于，即等于或小于，就返回原标签
    // 条件等同于rowNumber>1
    if (paramsNameNumber > provideNumber) {
       // 循环每一行,p表示行 
        for (var p = 0; p < 1; p++) {
            var tempStr = "";// 表示每一次截取的字符串
            var start = p * provideNumber;// 开始截取的位置
            var end = start + provideNumber;// 结束截取的位置
            // 此处特殊处理最后一行的索引值
            if (p == rowNumber - 1) {
                // 最后一次不换行
                tempStr = params.substring(start, paramsNameNumber);
            } else {
                // 每一次拼接字符串并换行
                tempStr = params.substring(start, end); //+ "\n";
            }
            newParamsName += tempStr;// 最终拼成的字符串
        }

    } else {
        // 将旧标签的值赋给新标签
        newParamsName = params;
    }
    //将最终的字符串返回
    return newParamsName+"#"
}
