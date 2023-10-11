///Creator:bianshuai
var ECharts={
 	///Echarts�����ļ�������
    ChartConfig:function (container, option) {
	 	//container:Ϊҳ��Ҫ��Ⱦͼ���������optionΪ�Ѿ���ʼ���õ�ͼ�����͵�option����
	    require.config({//���볣�õ�ͼ�����͵�����
	    	paths: {
	            echarts: "../scripts/dhcadvEvt/echarts/echarts-2.2.1/build/dist"
	            }
	        });
	    this.option = { chart: {}, option: option, container: container};
	    return this.option;
	 },
	 ///���ݸ�ʽ��
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
  			//data�ĸ�ʽ���ϵ�Result2��typeΪҪ��Ⱦ��ͼ�����ͣ�����Ϊline��bar��is_stack��ʾΪ�Ƿ��Ƕѻ�ͼ�����ָ�ʽ�����ݶ�����չʾ��������ͼ���������ͼ  
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
						{type : 'max', name: '���ֵ'},
						{type : 'min', name: '��Сֵ'}
					];
					
			
                    var markLine_data=[
                    	//{type : 'average', name: 'ƽ��ֵ'}
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
	///ͼ�����͵����ó�ʼ��
	ChartOptionTemplates:{
    	CommonOption: {//ͨ�õ�ͼ���������
           	tooltip: {
                trigger: 'axis'//tooltip������ʽ:axis��X���ߴ���,item��ÿһ���������
            },
            toolbox: {
                show: true, //�Ƿ���ʾ������
                feature: {
                	mark : { show: true }, //����
                    //dataView: { show: true, readOnly: false }, //����Ԥ��
                    restore : { show: true }, //��ԭ
                    saveAsImage : { show: true } //�Ƿ񱣴�ͼƬ
                }
            }
        },
        CommonLineOption: {//ͨ�õ�����ͼ��Ļ�������
            tooltip: {
                trigger: 'axis'
            },
            toolbox: {
                show: true,
                feature: {
                	mark : { show: true }, //����
                    //dataView: { show: true, readOnly: false }, //����Ԥ��
                    restore : { show: true }, //��ԭ
                    saveAsImage : { show: true }, //�Ƿ񱣴�ͼƬ
                   	magicType : { show: true, type: ['line', 'bar']} //֧������ͼ������ͼ���л�     cyȥ��(, 'stack', 'tiled'�ѻ���ƽ��)
                }
            }
        },
        Pie: function (data, name) {//data:���ݸ�ʽ��{name��xxx,value:xxx}... ///��״ͼ
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
		Lines: function (data, name, is_stack) { //data:���ݸ�ʽ��{name��xxx,group:xxx,value:xxx}... ///����ͼ
            var stackline_datas = ECharts.ChartDataFormate.FormateGroupData(data, 'line', is_stack);

            var option = {
                legend: {
                    data: stackline_datas.category
                },
                xAxis: [{
                    type: 'category', //X���Ϊcategory��Y���Ϊvalue
                    data: stackline_datas.xAxis //,
                    //boundaryGap: false//��ֵ�����˵Ŀհײ���
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
        //qqa 2018-12-18 ��չһ�����������Ժ������Ҫ�����ı�����
		Bars: function (data, name,is_stack,extObs) {//data:���ݸ�ʽ��{name��xxx,group:xxx,value:xxx}... ///��״ͼ
           	extObs = (extObs==undefined?{}:extObs);
            var defExtObs={
	        	grid:{},  	//����ͼ��ǰ��߾�  
	        }
	        extObs = $.extend(defExtObs,extObs)
            var bars_dates = ECharts.ChartDataFormate.FormateGroupData(data, 'bar', is_stack);
            var defGrid={ // ����ͼ�Ĵ�С������������Щֵ�Ϳ��ԣ�
         		x: 50, //ǰ����� //hxy 2020-03-31 ԭ��30
         		x2:30, //�������
         		y: 20,
         		y2:80// y2���Կ��� X���Zoom�ؼ�֮��ļ����������Ϊ��б����� label�ص���zoom��  �������
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
	                        	return newParamsName.split("").join("\n");//������ʾ
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
        //����ͼ
		Blt: function (data, name,is_stack,extObs,grid) {//data:���ݸ�ʽ��{name��xxx,group:xxx,value:xxx}... ///��״ͼ
			//var colors = ['#5ABCFE']

           	extObs = (extObs==undefined?{}:extObs);
            var defExtObs={
	        	grid:{},  	//����ͼ��ǰ��߾� 
	        }
	        extObs = $.extend(defExtObs,extObs)
            var bars_dates = ECharts.ChartDataFormate.FormateGroupData(data, 'blt', is_stack);
			var colorflag=0  // 80%��ɫ��ǣ�ֻ�����ӽ�80%��һ��
            var defGrid={ // ����ͼ�Ĵ�С������������Щֵ�Ϳ��ԣ�
         		x: 50, //ǰ����� //hxy 2020-03-31 ԭ��30
         		x2:50, //�������
         		y: 50,
         		y2:80// y2���Կ��� X���Zoom�ؼ�֮��ļ����������Ϊ��б����� label�ص���zoom��  �������
     		}
            var grid = $.extend(defGrid,extObs.grid);
            
           var option = {
	           		grid:grid,
					title : {
						text : '����'
					},
					tooltip : {
						trigger : 'axis',
						axisPointer : { // ������ָʾ���������ᴥ����Ч
							type : 'shadow' // Ĭ��Ϊֱ�ߣ���ѡΪ��'line' | 'shadow'
						}
					},
					legend : {
						//selectedMode : false,
						data : ['����', '����']
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
		                        if(params.indexOf("��Ѫ������Ӧ")>=0){
			                        params="��Ѫ��Ӧ"
			                    }
	                       		var newParamsName= GetParamsName(params);
	                        	return newParamsName.split("").join("\n");//������ʾ
	                        }else{
		                        return params;
		                    }
	                    }
                    }

					},              
						 {
						type : 'category',
						data : bars_dates.series[0].xAxisnext,
						
						axisLabel: {    //�ص�����һ�飬������Ժ���
							interval: 0,   //���һ��Ҫ�У���������
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
								name : '����',
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
								name : '����',
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
								name : '����',
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
	///ͼ�ε���Ⱦ
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
// Bar���͵� x��������ʾ����
function GetParamsName(params,provideNumber){
    var newParamsName = "";// ����ƴ�ӳɵ��ַ���
    var paramsNameNumber = params.length;// ʵ�ʱ�ǩ�ĸ���
	if((provideNumber=="")||(provideNumber==undefined)){
		provideNumber=4;
	}//  provideNumber ÿ������ʾ���ֵĸ���
    var rowNumber = Math.ceil(paramsNameNumber / provideNumber);// ���еĻ�����Ҫ��ʾ���У�����ȡ��
    
    // �жϱ�ǩ�ĸ����Ƿ���ڹ涨�ĸ����� ������ڣ�����л��д��� ��������ڣ������ڻ�С�ڣ��ͷ���ԭ��ǩ
    // ������ͬ��rowNumber>1
    if (paramsNameNumber > provideNumber) {
       // ѭ��ÿһ��,p��ʾ�� 
        for (var p = 0; p < 1; p++) {
            var tempStr = "";// ��ʾÿһ�ν�ȡ���ַ���
            var start = p * provideNumber;// ��ʼ��ȡ��λ��
            var end = start + provideNumber;// ������ȡ��λ��
            // �˴����⴦�����һ�е�����ֵ
            if (p == rowNumber - 1) {
                // ���һ�β�����
                tempStr = params.substring(start, paramsNameNumber);
            } else {
                // ÿһ��ƴ���ַ���������
                tempStr = params.substring(start, end); //+ "\n";
            }
            newParamsName += tempStr;// ����ƴ�ɵ��ַ���
        }

    } else {
        // ���ɱ�ǩ��ֵ�����±�ǩ
        newParamsName = params;
    }
    //�����յ��ַ�������
    return newParamsName+"#"
}
