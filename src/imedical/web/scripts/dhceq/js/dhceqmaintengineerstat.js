var myDate = new Date();
//����һ������,��ȫ�ֱ��������ݷ�������
var GlobalObj = {
	MonthList : "",				//�·�
	MaintNumData : "",			//ά�޴���
	TotalMSFeeData : "",		//ά�������������
	
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
					data=data.replace(/\ +/g,"");		//ȥ���ո�
					data=data.replace(/[\r\n]/g,"");	//ȥ���س�����
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

//jquery�������
jQuery(document).ready(function()
{
	//��ʼ��ϵͳ����,ͨ��ajxe�Ӻ�̨ȡ����
	GlobalObj.getEngineerStatData();
	
	//��ʼ��ͼ��
	initEcharts_EngineerStat();
}); 

//��ʼ������ʦά��ͳ��ͼ��
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
	var Len=OneList.length;	//���һ��
	for(var i=0;i<Len;i++)
	{
		yAxisDataOne[i]=OneList[i];
		yAxisDataTwo[i]=TwoList[i];
	}
	var myChart = echarts.init(document.getElementById('EngineerStat'));
	var option = {
		title: {text: '����ʦ����ά��ͳ��',
				textStyle: {fontSize: 16,fontWeight: 'bold',color: '#05725F'},  // ������������ɫ
	        	x:'left'
		},
		tooltip: {
			trigger: 'axis',
			axisPointer: {animation: false}
		},
		legend: {
			data:['�������','ά�޴���'],
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
					formatter: '{value}��',
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
					formatter: '{value}��',
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
				name : '���(Ԫ)',
				type : 'value',
				//max : 500
			},
			{
				gridIndex: 1,
				name : '����',
				type : 'value',
				inverse: true
			}
		],
		series : [
			{
				name:'�������',
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