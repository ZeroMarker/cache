function showEchartsBar(id,title,xAxisData,seriesData){
	// ����׼���õ�dom����ʼ��echartsʵ��
	var myChart = echarts.init(document.getElementById(id));

	// ָ��ͼ��������������
	var option = {
		title: {
			text: title,
			textStyle:{
				color:'#fff',
				fontSize:'20px',/*hxy 2022-11-11*/
				fontWeight: "normal"
			},
			x:'center',
            y:'top',
            top:'20',/*hxy 2022-11-04 10->20*/
            bottom:'0',
		    textAlign:'left'
		},
		tooltip: {},
		legend: {
 		//data: ['����']
		},
		 grid:{
	          left: '5%',
	          right: '10%',
	          bottom: '5%',
	          top: '80',
	          containLabel: true,
		},/*hxy 2022-11-04*/
		xAxis: {
			data: xAxisData,
			axisLabel:{
				color:'#fff'
			},
			axisLine: {
		        lineStyle: {
		            color:  'rgba(255,255,255,0.2)',
		                width: 1,
		        }
		    },
		},
		yAxis: {
			axisLabel:{
				color:'#fff'
			},
			splitLine: {
		      lineStyle: {
		         color: "rgba(255,255,255, 0.2)"
		      }
			}
		},
		series: [{
		//	name: '����',
			type: 'bar',
			data: seriesData,
			barWidth : 40, //��ͼ���
	        itemStyle: {
	            color:'#2CEBC999'
	        }
		}]
	};

	// ʹ�ø�ָ�����������������ʾͼ��
	myChart.setOption(option);
}


function showEchartsGauge(id,seriesData){
	// ����׼���õ�dom����ʼ��echartsʵ��
	var myChart = echarts.init(document.getElementById(id));


	option = {
	  tooltip: {
	    formatter: '{a} <br/>{b} : {c}%'
	  },
	  series: [
	    {
	      name: 'Pressure',
	      type: 'gauge',
	      progress: {
	        show: true
	      },
	      detail: {
	        valueAnimation: true,
	        formatter: '{value}'
	      },
	      data: [
	        seriesData
	      ]
	    }
	  ]
	};

	// ʹ�ø�ָ�����������������ʾͼ��
	myChart.setOption(option);
}


function showEchartsPie(id,seriesName,seriesData){
	
	// ����׼���õ�dom����ʼ��echartsʵ��
	var myChart = echarts.init(document.getElementById(id));

	
	option = {
	  title: { //hxy 2022-11-25 add
		text: seriesName,
		left: 'center',
		top: "5%",
		textStyle:{
				color:'white',
				fontWeight:'normal',
				fontSize:20,
			}
       },
	  tooltip: {
	    trigger: 'item'
	  },
	  legend: {
//	    top: '5%',
//	    left: 'center',
//	    textStyle:{
//			color:'#fff'    
//		}
        //left: 'center',
	    x:'center',
	    //y:'bottom',
	    textStyle: {
            color: '#FFF',
            fontSize: '14px'
        },
        bottom: "3%"
	  },
	  series: [
	    {
		  //color:['#38c1ff99','#2CEBC999','#7ADD7A','#D7DB7499','#FFB16E99'],
		  color:['#4393D2','#3BACB1','#6DAB83','#A6AD81','#FFB16E99'],
	      name: seriesName,
	      type: 'pie',
	      radius: ['40%', '70%'],
	      avoidLabelOverlap: false,
	      label: {
	        show: false,
	        position: 'center'
	      },
	      emphasis: {
	        label: {
	          show: true,
	          fontSize: '40',
	          fontWeight: 'bold'
	        }
	      },
	      labelLine: {
	        show: false
	      },
	      data: seriesData
	    }
	  ]
	};
	
	// ʹ�ø�ָ�����������������ʾͼ��
	myChart.setOption(option);
	
}

function showEchartsLine(id,title,xAxisData,seriesData){
	// ����׼���õ�dom����ʼ��echartsʵ��
	var myChart = echarts.init(document.getElementById(id));

	// ָ��ͼ��������������
	var option = {
		title: {
			text: title,
			textStyle:{
				color:'#fff',
				fontSize:'20px',/**/
				fontWeight:'normal'/**/
			},
			x:'center',
			y:'top',
			top:'20',/*hxy 2022-11-04 10->20*/
			textAlign:'left'
		},
		tooltip: {},
		legend: {
 		//data: ['����']
		},
		xAxis: {
			data: xAxisData,
			axisLabel:{
				color:'#fff'
			}
		},
		yAxis: {
			axisLabel:{
				color:'#fff'
			}
		},
		series: [{
		//	name: '����',
			type: 'line',
			data: seriesData,
			areaStyle: {},
			itemStyle: {
		        color:"rgba(51,137,203,0.8)" //'#2CEBC999'
		    }
			//smooth: true
		}]
	};

	// ʹ�ø�ָ�����������������ʾͼ��
	myChart.setOption(option);
}

//�Զ����
function showEchartsQPlain(id,title,value){
	var angle = 0;//�Ƕȣ��������򵥵Ķ���Ч����
	// ����׼���õ�dom����ʼ��echartsʵ��
	var myChart = echarts.init(document.getElementById(id));
    
	option = {
		backgroundColor:"",
		title: {
	        text: '{b|'+title+'}\n\n{a|'+ value +'}{c|%}',
	        x: 'center',
	        y: 'center',
	        textStyle: {
	            rich:{
	                a: {
	                    fontSize: 48,
	                    color: '#29EEF3'
	                },
	                b: {
	                    fontSize: 18,
	                    color: '#fff'
	                    //height:'20px'
	                },
	                c: {
	                    fontSize: 20,
	                    color: '#fff',
	                    // padding: [5,0]
	                }
	            }
	        }
	    },
	    legend: {
	        
	    },
	    series: [ 
	    	{
	            name: "",
	            type: 'custom',
	            coordinateSystem: "none",
	            renderItem: function(params, api) {
	                return {
	                    type: 'arc',
	                    shape: {
	                        cx: api.getWidth() / 2,
	                        cy: api.getHeight() / 2,
	                        r: Math.min(api.getWidth(), api.getHeight()) / 2 * 0.6,
	                        startAngle: (0+angle) * Math.PI / 180,
	                        endAngle: (90+angle) * Math.PI / 180
	                    },
	                    style: {
	                        stroke: "#0CD3DB",
	                        fill: "transparent",
	                        lineWidth: 1.5
	                    },
	                    silent: true
	                };
	            },
	            data: [0]
	        }, {
	            name: "",
	            type: 'custom',
	            coordinateSystem: "none",
	            renderItem: function(params, api) {
	                return {
	                    type: 'arc',
	                    shape: {
	                        cx: api.getWidth() / 2,
	                        cy: api.getHeight() / 2,
	                        r: Math.min(api.getWidth(), api.getHeight()) / 2 * 0.6,
	                        startAngle: (180+angle) * Math.PI / 180,
	                        endAngle: (270+angle) * Math.PI / 180
	                    },
	                    style: {
	                        stroke: "#0CD3DB",
	                        fill: "transparent",
	                        lineWidth: 1.5
	                    },
	                    silent: true
	                };
	            },
	            data: [0]
	        }, {
	            name: "",
	            type: 'custom',
	            coordinateSystem: "none",
	            renderItem: function(params, api) {
	                return {
	                    type: 'arc',
	                    shape: {
	                        cx: api.getWidth() / 2,
	                        cy: api.getHeight() / 2,
	                        r: Math.min(api.getWidth(), api.getHeight()) / 2 * 0.65,
	                        startAngle: (270+-angle) * Math.PI / 180,
	                        endAngle: (40+-angle) * Math.PI / 180
	                    },
	                    style: {
	                        stroke: "#0CD3DB",
	                        fill: "transparent",
	                        lineWidth: 1.5
	                    },
	                    silent: true
	                };
	            },
	            data: [0]
	        }, {
	            name: "",
	            type: 'custom',
	            coordinateSystem: "none",
	            renderItem: function(params, api) {
	                return {
	                    type: 'arc',
	                    shape: {
	                        cx: api.getWidth() / 2,
	                        cy: api.getHeight() / 2,
	                        r: Math.min(api.getWidth(), api.getHeight()) / 2 * 0.65,
	                        startAngle: (90+-angle) * Math.PI / 180,
	                        endAngle: (220+-angle) * Math.PI / 180
	                    },
	                    style: {
	                        stroke: "#0CD3DB",
	                        fill: "transparent",
	                        lineWidth: 1.5
	                    },
	                    silent: true
	                };
	            },
	            data: [0]
	        }, {
	            name: "",
	            type: 'custom',
	            coordinateSystem: "none",
	            renderItem: function(params, api) {
	                var x0 = api.getWidth() / 2;
	                var y0 = api.getHeight() / 2;
	                var r = Math.min(api.getWidth(), api.getHeight()) / 2 * 0.65;
	                var point = getCirlPoint(x0, y0, r, (90+-angle))
	                return {
	                    type: 'circle',
	                    shape: {
	                        cx: point.x,
	                        cy: point.y,
	                        r: 4
	                    },
	                    style: {
	                        stroke: "#0CD3DB",//��
	                        fill: "#0CD3DB"
	                    },
	                    silent: true
	                };
	            },
	            data: [0]
	        }, {
	            name: "",  //�̵�
	            type: 'custom',
	            coordinateSystem: "none",
	            renderItem: function(params, api) {
	                var x0 = api.getWidth() / 2;
	                var y0 = api.getHeight() / 2;
	                var r = Math.min(api.getWidth(), api.getHeight()) / 2 * 0.65;
	                var point = getCirlPoint(x0, y0, r, (270+-angle))
	                return {
	                    type: 'circle',
	                    shape: {
	                        cx: point.x,
	                        cy: point.y,
	                        r: 4
	                    },
	                    style: {
	                        stroke: "#0CD3DB",      //��
	                        fill: "#0CD3DB"
	                    },
	                    silent: true
	                };
	            },
	            data: [0]
	        }, {
	            name: '',
	            type: 'pie',
	            radius: ['58%', '45%'],
	            silent: true,
	            clockwise: true,
	            startAngle: 90,
	            z: 0,
	            zlevel: 0,
	            label: {
	                normal: {
	                    position: "center",

	                }
	            },
	            data: [{
	                    value: value,
	                    name: "",
	                    itemStyle: {
	                        normal: {
	                            color: { // ��ɵ�Բ������ɫ
	                                colorStops: [{
	                                    offset: 0,
	                                    color: '#4FADFD' // 0% ������ɫ
	                                }, {
	                                    offset: 1,
	                                    color: '#28E8FA' // 100% ������ɫ
	                                }]
	                            },
	                        }
	                    }
	                },
	                {
	                    value: 100-value,
	                    name: "",
	                    label: {
	                        normal: {
	                            show: false
	                        }
	                    },
	                    itemStyle: {
	                        normal: {
	                            color: "#173164"
	                        }
	                    }
	                }
	            ]
	        }
	        
	    ]
	};
	
	myChart.setOption(option, true)
}

//��ȡԲ����ĳ�������(x0,y0��ʾ���꣬r�뾶��angle�Ƕ�)
function getCirlPoint(x0, y0, r, angle) {
    var x1 = x0 + r * Math.cos(angle * Math.PI / 180)
    var y1 = y0 + r * Math.sin(angle * Math.PI / 180)
    return {
        x: x1,
        y: y1
    }
}

//hxy 2022-11-24 ����
function ChartsViewDial(id,title,value){		
        startAngle = 215, // ��ʼ�Ƕ�
        endAngle = -35, // �����Ƕ�
        splitCount = 50, // �̶�����
        pointerAngle = (startAngle - endAngle) * (1 - value) + endAngle; // ��ǰָ�루ֵ���Ƕ�
	    option = {
	        title: {
	            text: title,
	            left: "center",
	            top: "80%",
	            textStyle: {
	                color: "#FFFFFF",
					fontWeight:'normal',
					fontSize:18
	            }
	        },
	        series: [
	            {
	                type: 'gauge',
	                radius: '95%',
	                startAngle: pointerAngle,
	                endAngle: endAngle,
	                splitNumber: 1,
	                axisLine: {
	                    show: false,
	                    lineStyle: {
	                        width: 1,
	                        opacity: 10
	                    }
	                },
	                title: { show: false },
	                detail: { show: false },
	                splitLine: { show: false },
	                axisTick: {
	                    length: 18,
	                    splitNumber: Math.ceil((1 - value) * splitCount),
	                    lineStyle: {
	                        color: '#9FE477',
	                        width: 1
	                    }
	                },
	                axisLabel: { show: false },
	                pointer: { show: false },
	                itemStyle: {},
	                data: [
	                    {
	                        value: value,
	                        name: title
	                    }
	                ]
	            },
	            {
	                type: 'gauge',
	                radius: '95%',
	                startAngle: startAngle,
	                endAngle: pointerAngle,
	                splitNumber: 1,
	                axisLine: {
	                    show: false,
	                    lineStyle: {
	                        width: 3,
	                        opacity: 0
	                    }
	                },
	                title: { show: false },
	                detail: {
	                    show: true,
	                    color: "#FFFFFF",
	                    fontSize: 48,
						fontWeight:'normal',
						offsetCenter: [0, '-5%'],
	                    formatter: function (value) {
	                        return Math.round(value * 100); /// 2023-05-19 �����������ݴ���
	                    }
	                },
	                splitLine: { show: false },
	                axisTick: {
	                    length: 18,
	                    splitNumber: Math.ceil(value * splitCount),
	                    lineStyle: {
	                        color: "#2CEBC999", //
	                        width: 2
	                    }
	                },
	                axisLabel: { show: false },
	                pointer: { show: false },
	                itemStyle: {},
	                data: [
	                    {
	                        value: value,
	                        name: title
	                    }
	                ]
	            },
	            {
	                type: 'gauge',
	                radius: '100%',
	                startAngle: pointerAngle,
	                endAngle: pointerAngle,
	                splitNumber: 1,
	                axisLine: {
	                    show: false,
	                    lineStyle: {
	                        width: 3,
	                        opacity: 0
	                    }
	                },
	                title: { show: false },
	                detail: { show: false },
	                splitLine: { show: false },
	                axisTick: {
	                    length: 10,
	                    splitNumber: 1,
	                    lineStyle: {
	                        color: "#2CEBC999",
	                        width: 3
	                    }
	                },
	                axisLabel: { show: false },
	                pointer: { show: false },
	                itemStyle: {},
	                data: [
	                    {
	                        value: value,
	                        name: title
	                    }
	                ]
	            },
	            {
	                type: 'gauge',
	                radius: '95%',
	                startAngle: startAngle,
	                endAngle: endAngle,
	                splitNumber: 2,
	                axisLine: {
	                    show: false,
	                },
	                title: { show: false },
	                detail: { show: false, },
	                splitLine: { show: false },
	                axisTick: { show: false },
	                axisLabel: {
	                    show: true,
	                    color: "#FFFFFF",
						fontSize:10
	                },
	                pointer: { show: false },
	                itemStyle: {},
	                data: [
	                    {
	                        value: value,
	                        name: title,
	                    }
	                ]
	            },
	        ]
	    }
	
		var myChart = echarts.init($("#"+id)[0]);
		option&&myChart.setOption(option);
}

function draw(){
	
   //window.requestAnimationFrame(draw);
}


