var myDate = new Date();
///定义一个对象,把全局变量的数据放在里面
var GlobalObj = {
	EngineerList : "",				///工程师列表
	QtyData : "",					///资产总数量
	TotalOriginalFeeData : "",		///资产总金额
	TotalISFeeData : "",			///维修配件采购入库
	TotalMSFeeData : "",			///维修配件出库领用
	MaintNumData : "",				///维修次数
	TotalWorkHourData : "",			///维修工时
	
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
					data=data.replace(/\ +/g,"")	//去掉空格
					data=data.replace(/[\r\n]/g,"")	//去掉回车换行
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

//jquery界面入口
jQuery(document).ready(function()
{
	//初始化系统变量,通过ajxe从后台取数据
	GlobalObj.getEngineerStageData();
	initMenu(); //初始化左侧待办事项
	
	//初始化图表
	initEcharts_ManageEquipStat();
	initEcharts_AccessoryStat();
	initEcharts_MaintStat();
}); 
//处理左侧菜单数据和事件
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
//定义点击左侧待办事项时添加tab的事件
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
//初始化工程师管理设备信息图表
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
	var Len=OneList.length-1;	//多出一个
	
	for(var i=0;i<Len;i++)
	{
		yAxisDataOne[i]=OneList[i];
		yAxisDataTwo[i]=TwoList[i];
	}
	
	var myChart = echarts.init(document.getElementById('ManageEquipStat'));
	//alertShow(document.getElementById('ManageEquipStat'))
	option = {
		title: {text: '工程师管理设备',
				textStyle: {fontSize: 12,fontWeight: 'bold',color: '#05725F'},  // 主标题文字颜色
	        	x:'left'
		},
		tooltip : {trigger: 'axis'},
		legend: {data:['总值','数量']},
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
            axisLine : {    // 轴线
                show: true,
                lineStyle: {
                    color: 'green',
                    type: 'solid',
                    width: 2
                }
            },
            axisTick : {    // 轴标记
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
                //formatter: '{value}月',
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
            axisLine : {    // 轴线
                show: true,
                lineStyle: {
                    color: 'red',
                    type: 'dashed',
                    width: 2
                }
            },
            axisTick : {    // 轴标记
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
                formatter: '￥{value}',    // Template formatter!
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
                    return value + ' 台'
                }
            },
            splitLine : {
                show: false
            }
        }],
		series : [
			{
				name: '总值',
				type: 'bar',
				//data:[2.0, 4.9, 7.0, 23.2, 25.6, 76.7, 135.6, 162.2, 32.6, 20.0, 6.4, 3.3]
				data: yAxisDataTwo
			},
			{
				name:'数量',
				type: 'line',
				yAxisIndex: 1,
				//data: [2.0, 2.2, 3.3, 4.5, 6.3, 10.2, 20.3, 23.4, 23.0, 16.5, 12.0, 6.2]
				data: yAxisDataOne
			}
		]
	}
    // 使用刚指定的配置项和数据显示图表。
    myChart.setOption(option);
}
//初始化维修配件采购消耗图表
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
	var Len=OneList.length-1;	//多出一个
	for(var i=0;i<Len;i++)
	{
		yAxisDataOne[i]=OneList[i];
		yAxisDataTwo[i]=TwoList[i];
	}
	
	var myChart = echarts.init(document.getElementById('AccessoryStat'));
    option = {
		title: {text: myDate.getFullYear()+'年度配件统计',
				textStyle: {fontSize: 12,fontWeight: 'bold',color: '#05725F'},  // 主标题文字颜色
	        	x:'left'
		},
		tooltip : {
			trigger: 'axis',
			axisPointer : {            // 坐标轴指示器，坐标轴触发有效
				type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
			}
		},
		legend: {
			data:['采购入库', '出库领用']
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
				//倒序
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
				name:'采购入库',
				type:'bar',
				stack: '总量',
				barWidth : 10,
				//itemStyle: {normal: {
				//    label : {show: true, position: 'left'}
				//}},
				data:yAxisDataOne
			},
			{
				name:'出库领用',
				type:'bar',
				stack: '总量',
				//itemStyle: {normal: {
				//    label : {show: true}
				//}},
				data:yAxisDataTwo
			}
		]
	}
	// 使用刚指定的配置项和数据显示图表。
    myChart.setOption(option);
}
//初始化工程师维修统计图表
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
	var Len=OneList.length-1;	//多出一个
	for(var i=0;i<Len;i++)
	{
		yAxisDataOne[i]=OneList[i];
		yAxisDataTwo[i]=TwoList[i];
	}
	
	var myChart = echarts.init(document.getElementById('MaintStat'));
	option = {
		title: {text: myDate.getFullYear()+'年度工程师维修统计',
				textStyle: {fontSize: 12,fontWeight: 'bold',color: '#05725F'},  // 主标题文字颜色
	        	x:'left'
		},
		tooltip: {
			trigger: 'axis',
			axisPointer: {animation: false}
		},
		legend: {
			data:['维修工时','维修次数'],
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
					//formatter: '{value}月',
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
				name : '工时(小时)',
				type : 'value',
				//max : 500
			},
			{
				gridIndex: 1,
				name : '维修次数',
				type : 'value',
				inverse: true
			}
		],
		series : [
			{
				name:'维修工时',
				type:'line',
				symbolSize: 8,
				hoverAnimation: false,
				data:yAxisDataTwo
			},
			{
				name:'维修次数',
				type:'line',
				xAxisIndex: 1,
				yAxisIndex: 1,
				symbolSize: 8,
				hoverAnimation: false,
				data: yAxisDataOne
			}
		]
	}
    // 使用刚指定的配置项和数据显示图表。
    myChart.setOption(option);
}