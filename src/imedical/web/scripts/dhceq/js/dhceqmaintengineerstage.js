var myDate = new Date();
///����һ������,��ȫ�ֱ��������ݷ�������
var GlobalObj = {
	EngineerList : "",				///����ʦ�б�
	QtyData : "",					///�ʲ�������
	TotalOriginalFeeData : "",		///�ʲ��ܽ��
	TotalISFeeData : "",			///ά������ɹ����
	TotalMSFeeData : "",			///ά�������������
	MaintNumData : "",				///ά�޴���
	TotalWorkHourData : "",			///ά�޹�ʱ
	
	getEngineerStageData : function ()
	{
		var EngineerStageData=""
	    $.ajax({
		    	async: false,
	            url :"dhceq.jquery.method.csp",
	            type:"POST",
		            data:{
	                ClassName:"web.DHCEQM.DHCEQMMaintStatisticsAnaly",
	                MethodName:"GetEngineerStage",
			        Arg1:"1",
			        //Arg2:SessionObj.GGROURPID,
			        //Arg3:SessionObj.GLOCID,
			        
			        ArgCnt:1
	            },
	           	error:function(XMLHttpRequest, textStatus, errorThrown){
	                        alertShow(XMLHttpRequest.status);
	                        alertShow(XMLHttpRequest.readyState);
	                        alertShow(textStatus);
	            },
	            success:function (data, response, status) {
	            	$.messager.progress('close');
					data=data.replace(/\ +/g,"")	//ȥ���ո�
					data=data.replace(/[\r\n]/g,"")	//ȥ���س�����
	            	EngineerStageData=data
	           }
	    })
		//alertShow(Data[1])
	    var Data=EngineerStageData.split("&");
	    this.EngineerList=Data[0];
	    this.QtyData=Data[1];
	    this.TotalOriginalFeeData=Data[2];
	    this.TotalISFeeData=Data[3];
		this.TotalMSFeeData=Data[4];
		this.MaintNumData=Data[5];
		this.TotalWorkHourData=Data[6];
	}
}

//jquery�������
jQuery(document).ready(function()
{
	//��ʼ��ϵͳ����,ͨ��ajxe�Ӻ�̨ȡ����
	GlobalObj.getEngineerStageData();
	initMenu(); //��ʼ������������
	
	//��ʼ��ͼ��
	initEcharts_ManageEquipStat();
	initEcharts_AccessoryStat();
	initEcharts_MaintStat();
}); 
//�������˵����ݺ��¼�
function initMenu()
{
	var dataList=GlobalObj.EngineerList.split("^")
	var Len=dataList.length;
	for(var i=0;i<Len;i++)
	{
		var data=dataList[i].split(":")
		var userid=data[0]
		var username=data[1]
		var initials=data[2]
		jQuery('#Engineer').append('<li onclick ="addTabsData_Clicked(&quot;'+username+','+userid+'&quot;)" '+'><span class='+'"eq_radius"'+'>'+initials+'</span><a>'+username+'</a></li>')
	}
}
//����������������ʱ���tab���¼�
function addTabsData_Clicked(data)
{
	var datainfo = data.split(",");
	var Name=datainfo[0];
	var Id=datainfo[1];
	
	if($("#TabsData").tabs('exists',Name))
    {
        $("#TabsData").tabs('select',Name);
	}
	else
	{
		var content = '<iframe scrolling="auto" frameborder="0" src="dhceqmaintengineersframe.csp?&UserID='+Id+'" style="width:100%;height:100%;"></iframe>';
		$("#TabsData").tabs('add',{
			title:Name,
			iconCls:'icon-tip',
			fit:true,
			closable:true,
			selected:true,
			content:content,
			//href:href
			onSelect:function(title){alertShow(title+' is selected');}
		});
    }
}
//��ʼ������ʦ�����豸��Ϣͼ��
function initEcharts_ManageEquipStat()
{
	var xAxisData = new Array();
	var yAxisDataOne = new Array();
	var yAxisDataTwo = new Array();
	//alertShow("initEcharts_InMoveStat:"+GlobalObj.EngineerList)
	var dataList=GlobalObj.EngineerList.split("^");
	var Len=dataList.length;
	//alertShow(Len)
	for(var i=0;i<Len;i++)
	{
		var data=dataList[i].split(":");
		var userid=data[0];
		var username=data[1];
		var initials=data[2];
		xAxisData[i]=username;
	}
	var OneList=GlobalObj.QtyData.split("^");
	var TwoList=GlobalObj.TotalOriginalFeeData.split("^");
	var Len=OneList.length-1;	//���һ��
	
	for(var i=0;i<Len;i++)
	{
		yAxisDataOne[i]=OneList[i];
		yAxisDataTwo[i]=TwoList[i];
	}
	
	var myChart = echarts.init(document.getElementById('ManageEquipStat'));
	//alertShow(document.getElementById('ManageEquipStat'))
	option = {
		title: {text: '����ʦ�����豸',
				textStyle: {fontSize: 12,fontWeight: 'bold',color: '#05725F'},  // ������������ɫ
	        	x:'left'
		},
		tooltip : {trigger: 'axis'},
		legend: {data:['��ֵ','����']},
		toolbox: {
			show : false,
			feature : {
				mark : {show: true},
				dataView : {show: true},
				magicType : {show: true, type: ['line', 'bar']},
				restore : {show: true},
				saveAsImage : {show: true}
			}
		},
		xAxis : [
        {
            type : 'category',
            position: 'bottom',
            boundaryGap: true,
            axisLine : {    // ����
                show: true,
                lineStyle: {
                    color: 'green',
                    type: 'solid',
                    width: 2
                }
            },
            axisTick : {    // ����
                show:true,
                length: 10,
                lineStyle: {
                    color: 'red',
                    type: 'solid',
                    width: 2
                }
            },
            axisLabel : {
                show:true,
                interval: 0,	//'auto',    // {number}
                rotate: -45,
                margin: 8,
                //formatter: '{value}��',
                textStyle: {
                    color: 'blue',
                    fontFamily: 'sans-serif',
                    fontSize: 15,
                    fontStyle: 'italic',
                    fontWeight: 'bold'
                }
            },
            splitLine : {
                show:true,
                lineStyle: {
                    color: '#483d8b',
                    type: 'dashed',
                    width: 1
                }
            },
            splitArea : {
                show: true,
                areaStyle:{
                    color:['rgba(144,238,144,0.3)','rgba(135,200,250,0.3)']
                }
            },
			data : xAxisData
        }
		],
		yAxis : [
        {
            type : 'value',
            position: 'left',
            //min: 0,
            //max: 300,
            //splitNumber: 5,
            boundaryGap: [0,0.1],
            axisLine : {    // ����
                show: true,
                lineStyle: {
                    color: 'red',
                    type: 'dashed',
                    width: 2
                }
            },
            axisTick : {    // ����
                show:true,
                length: 10,
                lineStyle: {
                    color: 'green',
                    type: 'solid',
                    width: 2
                }
            },
            axisLabel : {
                show:true,
                interval: 'auto',    // {number}
                rotate: 0,
                margin: 18,
                formatter: '��{value}',    // Template formatter!
                textStyle: {
                    color: '#1e90ff',
                    fontFamily: 'verdana',
                    fontSize: 10,
                    fontStyle: 'normal',
                    fontWeight: 'bold'
                }
            },
            splitLine : {
                show:true,
                lineStyle: {
                    color: '#483d8b',
                    type: 'dotted',
                    width: 2
                }
            },
            splitArea : {
                show: true,
                areaStyle:{
                    color:['rgba(205,92,92,0.3)','rgba(255,215,0,0.3)']
                }
            }
        },
        {
            type : 'value',
            splitNumber: 10,
            axisLabel : {
                formatter: function (value) {
                    // Function formatter
                    return value + ' ̨'
                }
            },
            splitLine : {
                show: false
            }
        }],
		series : [
			{
				name: '��ֵ',
				type: 'bar',
				//data:[2.0, 4.9, 7.0, 23.2, 25.6, 76.7, 135.6, 162.2, 32.6, 20.0, 6.4, 3.3]
				data: yAxisDataTwo
			},
			{
				name:'����',
				type: 'line',
				yAxisIndex: 1,
				//data: [2.0, 2.2, 3.3, 4.5, 6.3, 10.2, 20.3, 23.4, 23.0, 16.5, 12.0, 6.2]
				data: yAxisDataOne
			}
		]
	}
    // ʹ�ø�ָ�����������������ʾͼ��
    myChart.setOption(option);
}
//��ʼ��ά������ɹ�����ͼ��
function initEcharts_AccessoryStat()
{
	var xAxisData = new Array();
	var yAxisDataOne = new Array();
	var yAxisDataTwo = new Array();
	//alertShow("initEcharts_InMoveStat:"+GlobalObj.EngineerList)
	var dataList=GlobalObj.EngineerList.split("^");
	var Len=dataList.length;
	//alertShow(Len)
	for(var i=0;i<Len;i++)
	{
		var data=dataList[i].split(":");
		var userid=data[0];
		var username=data[1];
		var initials=data[2];
		xAxisData[i]=username;
	}
	var OneList=GlobalObj.TotalISFeeData.split("^");
	var TwoList=GlobalObj.TotalMSFeeData.split("^");
	var Len=OneList.length-1;	//���һ��
	for(var i=0;i<Len;i++)
	{
		yAxisDataOne[i]=OneList[i];
		yAxisDataTwo[i]=TwoList[i];
	}
	
	var myChart = echarts.init(document.getElementById('AccessoryStat'));
    option = {
		title: {text: myDate.getFullYear()+'������ͳ��',
				textStyle: {fontSize: 12,fontWeight: 'bold',color: '#05725F'},  // ������������ɫ
	        	x:'left'
		},
		tooltip : {
			trigger: 'axis',
			axisPointer : {            // ������ָʾ���������ᴥ����Ч
				type : 'shadow'        // Ĭ��Ϊֱ�ߣ���ѡΪ��'line' | 'shadow'
			}
		},
		legend: {
			data:['�ɹ����', '��������']
		},
		toolbox: {
			show : false,
			feature : {
				mark : {show: true},
				dataView : {show: true, readOnly: false},
				magicType : {show: true, type: ['line', 'bar']},
				restore : {show: true},
				saveAsImage : {show: true}
			}
		},
		calculable : true,
		xAxis : [
			{
				type : 'value',
				axisLabel : {
				interval: 0	//'auto',    // {number}
				//����
				//    formatter: function(v){
				//        return - v;
				//    }
				},
			}
		],
		yAxis : [
			{
				type : 'category',
				axisLabel : {
					show:true,
					interval: 0	//'auto',    // {number}
					//rotate: -45,
				},
				axisTick : {show: false},
				data : xAxisData
			}
		],
		series : [
			{
				name:'�ɹ����',
				type:'bar',
				stack: '����',
				barWidth : 10,
				//itemStyle: {normal: {
				//    label : {show: true, position: 'left'}
				//}},
				data:yAxisDataOne
			},
			{
				name:'��������',
				type:'bar',
				stack: '����',
				//itemStyle: {normal: {
				//    label : {show: true}
				//}},
				data:yAxisDataTwo
			}
		]
	}
	// ʹ�ø�ָ�����������������ʾͼ��
    myChart.setOption(option);
}
//��ʼ������ʦά��ͳ��ͼ��
function initEcharts_MaintStat()
{
	var xAxisData = new Array();
	var yAxisDataOne = new Array();
	var yAxisDataTwo = new Array();
	//alertShow("initEcharts_InMoveStat:"+GlobalObj.EngineerList)
	var dataList=GlobalObj.EngineerList.split("^");
	var Len=dataList.length;
	//alertShow(Len)
	for(var i=0;i<Len;i++)
	{
		var data=dataList[i].split(":")
		var userid=data[0]
		var username=data[1]
		var initials=data[2]
		xAxisData[i]=username;
	}
	var OneList=GlobalObj.MaintNumData.split("^");
	var TwoList=GlobalObj.TotalWorkHourData.split("^");
	var Len=OneList.length-1;	//���һ��
	for(var i=0;i<Len;i++)
	{
		yAxisDataOne[i]=OneList[i];
		yAxisDataTwo[i]=TwoList[i];
	}
	
	var myChart = echarts.init(document.getElementById('MaintStat'));
	option = {
		title: {text: myDate.getFullYear()+'��ȹ���ʦά��ͳ��',
				textStyle: {fontSize: 12,fontWeight: 'bold',color: '#05725F'},  // ������������ɫ
	        	x:'left'
		},
		tooltip: {
			trigger: 'axis',
			axisPointer: {animation: false}
		},
		legend: {
			data:['ά�޹�ʱ','ά�޴���'],
			//x: 'left'
		},
		toolbox: {
			show : false,
			feature: {
				dataZoom: {
					yAxisIndex: 'none'
				},
				restore: {},
				saveAsImage: {}
			}
		},
		axisPointer: {
			link: {xAxisIndex: 'all'}
		},
		dataZoom: [
			{
				show: true,
				realtime: true,
				start: 30,
				end: 70,
				xAxisIndex: [0, 1]
			},
			{
				type: 'inside',
				realtime: true,
				start: 30,
				end: 70,
				xAxisIndex: [0, 1]
			}
		],
		grid: [{
			left: 50,
			right: 50,
			height: '35%'
		}, {
			left: 50,
			right: 50,
			top: '55%',
			height: '35%'
		}],
		xAxis : [
			{
				type : 'category',
				axisLabel : {
					show:true,
					//interval: 0,	//'auto',    // {number}
					//rotate: -45,
					//margin: 8,
					//formatter: '{value}��',
					textStyle: {
						//color: 'blue',
						fontFamily: 'sans-serif',
						fontSize: 15,
						fontStyle: 'italic',
						fontWeight: 'bold'
					}
				},
				boundaryGap : false,
				axisLine: {onZero: true},
				data: xAxisData
			},
			{
				gridIndex: 1,
				type : 'category',
				boundaryGap : false,
				axisLine: {onZero: true},
				show: false,
				data: xAxisData,
				position: 'top'
			}
		],
		yAxis : [
			{
				name : '��ʱ(Сʱ)',
				type : 'value',
				//max : 500
			},
			{
				gridIndex: 1,
				name : 'ά�޴���',
				type : 'value',
				inverse: true
			}
		],
		series : [
			{
				name:'ά�޹�ʱ',
				type:'line',
				symbolSize: 8,
				hoverAnimation: false,
				data:yAxisDataTwo
			},
			{
				name:'ά�޴���',
				type:'line',
				xAxisIndex: 1,
				yAxisIndex: 1,
				symbolSize: 8,
				hoverAnimation: false,
				data: yAxisDataOne
			}
		]
	}
    // ʹ�ø�ָ�����������������ʾͼ��
    myChart.setOption(option);
}