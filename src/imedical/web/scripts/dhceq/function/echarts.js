//Create By ZY 20160922 ����ͼ����������������
//====================================================================
///add by zy 2016-09-19
///��ʼ��ͼ��
///objID:  ͼ��Ԫ��ID
///option��Ҫ�����ݶ���  : setEchertsData()�������
function initEcharts(objID,objEchertsData)
{
	var myChart = echarts.init(document.getElementById(objID));
	//pie  ��״ͼ  bar  ��״ͼ  type: objEchertsData.seriesType
	option_pie = {
	    	title : {text: objEchertsData.text,subtext: objEchertsData.subtext,
	    			 textStyle: {fontSize: 16,fontWeight: 'bold',color: '#05725F'},  // ������������ɫ
	        		 x:'left'
	        		},
	    	tooltip : {
	        		trigger: 'item',  //'item'   'axis
	        		formatter: "{a} <br/>{b} : {c} ({d}%)"
	    			},
	    	legend: {orient: 'vertical',x: 'left',y: 'bottom', data: objEchertsData.legendData},
	    	series : [{name: objEchertsData.seriesName,type: objEchertsData.seriesType,data:objEchertsData.seriesData,
	           			radius : '55%',center: ['50%', '60%'],itemStyle: {emphasis: {shadowBlur: 10,shadowOffsetX: 0,shadowColor: 'rgba(0, 0, 0, 0.5)'}},
	            		normal:{label:{show: true, formatter: '{b} : {c} ({d}%)' }} 
	        		}]
			};
	option_line = {
			title : {text: objEchertsData.text,subtext: objEchertsData.subtext,
	    			 textStyle: {fontSize: 16,fontWeight: 'bold',color: '#05725F'},  // ������������ɫ
	        		 x:'left'
	        		},
			tooltip: {trigger: 'axis'},
			legend: {x:'right',data: objEchertsData.legendData},
			calculable : true,
			grid: {
				left: '3%',
				right: '4%',
				bottom: '3%',
				containLabel: true
				},
			xAxis: [{
				type: 'category',
				boundaryGap: false,
				data: objEchertsData.xAxisData
				}],
			yAxis: [{type: 'value'}],
			series: objEchertsData.seriesData
		};
	option_bar = {
	 		title: {text: objEchertsData.text,subtext: objEchertsData.subtext,
	    			textStyle:{fontSize: 16,fontWeight: 'bold',color: '#05725F'}  // ������������ɫ
	 				},
		    //color: objEchertsData.color,
		    legend : {
		    	x: 'right', //add by zx 2017-03-30 ����ţ�358542 
			    y: 'top', 
					data : [ '�ڳ�ԭֵ', '�����¹�', '��ĩԭֵ' ]  //add by zx 2017-03-30 ����ţ�357255 
				},
		    tooltip : {
		        trigger: 'axis',
		        axisPointer : {            // ������ָʾ���������ᴥ����Ч
		            type : 'shadow'        // Ĭ��Ϊֱ�ߣ���ѡΪ��'line' | 'shadow'
		        }
		    },
		    grid: {left: '1%',right: '1%',bottom: '1%',containLabel: true},
		    xAxis : [{
		            type : 'category',
		            data : objEchertsData.xAxisData,
		            axisTick: {
		                alignWithLabel: true
		            }
		        }
		    ],
		    yAxis : [{type :objEchertsData.yAxisType}],
		    series : objEchertsData.seriesData //[{name: objEchertsData.seriesName,type: objEchertsData.seriesType,data:objEchertsData.seriesData,
		              // barWidth : 30}]
		};
	var option=""
	if (objEchertsData.seriesType=="pie"){option=option_pie}
	else if (objEchertsData.seriesType=="bar"){option=option_bar}
	else if (objEchertsData.seriesType=="line"){option=option_line}
	myChart.setOption(option); 
}

///����EchertsData����
function setEchertsData(text,subtext,color,legendData,seriesName,seriesType,seriesData,xAxisData,yAxisType)
{
    this.text = text;
    this.subtext = subtext;
    this.color = color;
    this.legendData = legendData;
    this.seriesName = seriesName;
    this.seriesType = seriesType;
    this.seriesData = seriesData;
    this.xAxisData = xAxisData;
    this.yAxisType = yAxisType;
}

///����SeriesData����
function setSeriesData(name,value)
{
    this.name = name;
    this.value = value;
}
//add by zx 2017-02-22 
//��״ͼ��ʽ�ı丳ֵ
function setBarData(name,data)
{
    this.name = name;
    this.type = 'bar';
    this.barWidth = 30;
    this.stack = '����豸';
    this.data = data;
}
///Add By DJ 2017-08-31
function setLineData(name,data)
{
    this.name = name;
    this.type = 'line';
    this.data = data;
}