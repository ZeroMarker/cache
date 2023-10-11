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
				   datas.push({ name: data[i].name, value: data[i].value || 0 });
				}
			var colors = ['#327eb2', '#fda632', '#f3723b', '#449be2', '#6abfef', '#7dba56', '#afd17e','#39c6c8', '#21be97', '#f4d44f', '#ec90da', '#bc80dc'];
	        return { category: categories, data: datas , color: colors };
        },  
        FormateGroupData: function (data, type, is_stack) {
  			//data的格式如上的Result2，type为要渲染的图表类型：可以为line，bar，is_stack表示为是否是堆积图，这种格式的数据多用于展示多条折线图、分组的柱图  
            var chart_type = 'line';
            if (type){
            	chart_type = type || 'line';
                }
      
	            var xAxis = [];  
	            var group = [];
	            var series = [];  
	            for (var i = 0; i < data.length; i++) {
	                for (var j = 0; j < xAxis.length && xAxis[j] != data[i].name; j++);  
	                if (j == xAxis.length)  
	                    xAxis.push(data[i].name);  
	  
	                for (var k = 0; k < group.length && group[k] != data[i].group; k++);  
	                if (k == group.length)
	                    group.push(data[i].group);  
	            }  
 
                for (var i = 0; i < group.length; i++) {
                    var temp = [];
                    for (var j = 0; j < data.length; j++) {
                        if (group[i] == data[j].group) {
                            if (type == "map"){  
                            	temp.push({ name: data[j].name, value: parseFloat(data[i].value) });
                    		}else{
                            	temp.push(parseFloat(data[j].value));
                    		}
                        }
                   }
                   
                    var markPoint_data=[
						{type : 'max', name: '最大值'},
						{type : 'min', name: '最小值'}
					];
					
                    var markLine_data=[
                    	{type : 'average', name: '平均值'}
                    ];
                    
	                switch (type) {
	                    case 'bar':  
	                        var series_temp = { name: group[i], data: temp, type: chart_type , markPoint : { data : markPoint_data} , markLine : { data : markLine_data}}; 
	                        if (is_stack)  
	                            series_temp = $.extend({}, { stack: 'stack' }, series_temp);
	                        break;
	                    /*
	                    case 'map':  
	                        var series_temp = {
	                            name: group[i], type: chart_type, mapType: 'china', selectedMode: 'single',
	                            itemStyle: {
	                                normal: { label: { show: true} },
	                                emphasis: { label: { show: true} }
	                            },
	                            data: temp
	                        };
	                        break;  
	  					*/
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
            return { category: group, xAxis: xAxis, series: series };
        }
	},
	///图表类型的配置初始化
	ChartOptionTemplates:{
    	CommonOption: {//通用的图表基本配置
           	tooltip: {
                trigger: 'axis'//tooltip触发方式:axis以X轴线触发,item以每一个数据项触发
            },
            toolbox: {
                show: false, //是否显示工具栏
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
                show: false,
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
                    formatter: '{b} : {c} ({d}/%)',
                    show: true
                },
                legend: {
                    orient: 'vertical',
                    x: 'left',
                    data: pie_datas.category
                },
                calculable : true,
                color: pie_datas.color,
                series: [
                {
                    name: name || "",
	                type:'pie',
	                radius : ['50%', '70%'],
                    data: pie_datas.data,
            		itemStyle:{
            			normal:{
		                    label : {
		                        show : false
		                    },
		                    labelLine : {
		                        show : false
		                    }
                		},
		                emphasis : {
		                    label : {
		                        show : true,
		                        position : 'center',
		                        textStyle : {
		                            fontSize : '30',
		                            fontWeight : 'bold'
		                        }
		                    }
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
                grid: {
			        x: 40,
			        y: 42,
			        x2: 40,
			        y2: 42,
			        backgroundColor: 'rgba(0,0,0,0)',
			        borderWidth: 1,
			        borderColor: '#ccc'
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
		Bars: function (data, name, is_stack) {//data:数据格式：{name：xxx,group:xxx,value:xxx}... ///柱状图
            var bars_dates = ECharts.ChartDataFormate.FormateGroupData(data, 'bar', is_stack);
			
            var option = {
                legend: {
                    data: bars_dates.category
                },
			    grid: {
			        x: 40,
			        y: 22,
			        x2: 40,
			        y2: 32,
			        backgroundColor: 'rgba(0,0,0,0)',
			        borderWidth: 1,
			        borderColor: '#ccc'
			    },
                xAxis: [{
                    type: 'category',
                    data: bars_dates.xAxis,
                    axisLabel: {
                        formatter: function(params) {
                var newParamsName = ''
                var paramsNameNumber = params.length
                var provideNumber = 5
                var rowNumber = Math.ceil(paramsNameNumber / provideNumber)
                for (var row = 0; row <rowNumber; row++) {
                  newParamsName +=
                    params.substring(
                      row * provideNumber,
                      (row + 1) * provideNumber
                    ) + '\n'
                }
                return newParamsName
              },
				interval:0
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
