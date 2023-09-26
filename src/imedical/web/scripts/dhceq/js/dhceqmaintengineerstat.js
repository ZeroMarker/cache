var myDate = new Date();
//定义一个对象,把全局变量的数据放在里面
var GlobalObj = {
	MonthList : "",				//月份
	MaintNumData : "",			//维修次数
	TotalMSFeeData : "",		//维修配件出库领用
	
	getEngineerStatData : function ()
	{
		var EngineerStatInfo=""
	    $.ajax({
		    	async: false,
	            url :"dhceq.jquery.method.csp",
	            type:"POST",
		            data:{
	                ClassName:"web.DHCEQM.DHCEQMMaintStatisticsAnaly",
	                MethodName:"GetEngineerStat",
			        Arg1:$("#UserID").val(),
			        ArgCnt:1
	            },
	           	error:function(XMLHttpRequest, textStatus, errorThrown){
	                alertShow(XMLHttpRequest.status);
	                alertShow(XMLHttpRequest.readyState);
	                alertShow(textStatus);
	            },
	            success:function (data, response, status) {
	            	$.messager.progress('close');
					data=data.replace(/\ +/g,"");		//去掉空格
					data=data.replace(/[\r\n]/g,"");	//去掉回车换行
					EngineerStatInfo=data;
				}
	    })
		//alertShow($("#UserID").val()+"-"+EngineerStatInfo)
		var Data=EngineerStatInfo.split("&");
	    this.MonthList=Data[0];
	    this.MaintNumData=Data[1];
		this.TotalMSFeeData=Data[2];
	}
}

//jquery界面入口
jQuery(document).ready(function()
{
	//初始化系统变量,通过ajxe从后台取数据
	GlobalObj.getEngineerStatData();
	
	//初始化图表
	initEcharts_EngineerStat();
}); 

//初始化工程师维修统计图表
function initEcharts_EngineerStat()
{
	var xAxisData = new Array();
	var yAxisDataOne = new Array();
	var yAxisDataTwo = new Array();
	var dataList=GlobalObj.MonthList.split("^");
	var Len=dataList.length;
	for(var i=0;i<Len;i++)
	{
		xAxisData[i]=dataList[i];
	}
	var OneList=GlobalObj.MaintNumData.split("^");
	var TwoList=GlobalObj.TotalMSFeeData.split("^");
	var Len=OneList.length;	//多出一个
	for(var i=0;i<Len;i++)
	{
		yAxisDataOne[i]=OneList[i];
		yAxisDataTwo[i]=TwoList[i];
	}
	var myChart = echarts.init(document.getElementById('EngineerStat'));
	var option = {
		title: {text: '工程师个人维修统计',
				textStyle: {fontSize: 16,fontWeight: 'bold',color: '#05725F'},  // 主标题文字颜色
	        	x:'left'
		},
		tooltip: {
			trigger: 'axis',
			axisPointer: {animation: false}
		},
		legend: {
			data:['配件领用','维修次数'],
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
		dataZoom : {
			show : true,
			realtime: true,
			start : 50,
			end : 100
		},
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
					formatter: '{value}月',
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
				axisLabel : {
					show:true,
					//interval: 0,	//'auto',    // {number}
					//rotate: -45,
					//margin: 8,
					formatter: '{value}月',
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
				show: true,
				data: xAxisData,
				position: 'top'
			}
		],
		yAxis : [
			{
				name : '金额(元)',
				type : 'value',
				//max : 500
			},
			{
				gridIndex: 1,
				name : '次数',
				type : 'value',
				inverse: true
			}
		],
		series : [
			{
				name:'配件领用',
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