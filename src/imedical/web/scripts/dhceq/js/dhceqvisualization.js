var IntervalFlag=1 //默认从标志位1的开始刷新
/*
** add by zx 2017-05-31
** 大屏数据Ajax统一调用
** 字符串数据处理
*/
var StatisticsChart;
var MonthChart;
var GroupChart;
var EngineerChart;
var ActionChart;
function getVisualization(ClassMethod,Type,FirstFlag)
{
	jQuery.ajax({
    	async: false, //true,
    	cache: false,
        url :"dhceq.jquery.method.visualization.csp",
        timeout : 50000,
        type:"POST",
            data:{
            ClassName:"web.DHCEQ.Process.DHCEQVisualization",
            MethodName:ClassMethod,
	        ArgCnt:0
        },
       	error:function(XMLHttpRequest, textStatus, errorThrown){
                    messageShow("","","",XMLHttpRequest.status);
                    messageShow("","","",XMLHttpRequest.readyState);
                    messageShow("","","",textStatus);
                    alertShow("调试1:"+errorThrown);
                    JSON.stringify(XMLHttpRequest);
        },
        success:function (data, response, status) {
        	jQuery.messager.progress('close');
			data=data.replace(/\ +/g,"");	//去掉空格
			data=data.replace(/[\r\n]/g,"");	//去掉回车换行
			if(FirstFlag=="N")
			{
				switch(Type)
				{
					case 1:  //
						initMaintStatistics(data)
						break;
					case 2:
						initMaintByMonth(data);
						break;
					case 3:
						initMaintByGroup(data);
						break;
					case 4:
						initMaintByEngineer(data);
						break;
					case 5:
						initActionDistribution(data);
						break;
					default:
						break;
				}
			}
			else
			{
				refreshData(data,Type);
			}
       }
    })
}
/*
* add by zx 2017-07-07
* 大屏echarts数据刷新处理
*/
function refreshData(data,type)
{
	switch(type)
	{
		case 1:  //
			var option = StatisticsChart.getOption();
			var wholenum=parseInt(data.split("^")[0]);
			var maintnum=parseInt(data.split("^")[1]);
			option.series[0].data=[{value:wholenum, name:'正常'},{value:maintnum, name:'故障'}];
			StatisticsChart.setOption(option);
			var MaintStatistics=(wholenum/(wholenum+maintnum)*100).toFixed(2);
			jQuery("#maintstatistics").html(MaintStatistics+"%");
			break;
		case 2:
			var option = MonthChart.getOption();
			option.xAxis[0].data=data.split("^")[0].split(",");
			option.series[0].data=data.split("^")[1].split(",");
		    option.series[1].data=data.split("^")[2].split(",");
		    MonthChart.setOption(option);
			break;
		case 3:
			var option = GroupChart.getOption();
			option.xAxis[0].data=data.split("^")[0].split(",");
			option.series[0].data=data.split("^")[2].split(",");
		    option.series[1].data=data.split("^")[1].split(",");
		    GroupChart.setOption(option);
			break;
		case 4:
			var option = EngineerChart.getOption();
			option.xAxis[0].data=data.split("^")[0].split(",");
			option.series[0].data=data.split("^")[2].split(",");
		    option.series[1].data=data.split("^")[1].split(",");
		    EngineerChart.setOption(option);
			break;
		case 5:
			var option = ActionChart.getOption();
			var serData=new Array();
			var nameData=data.split("^")[0].split(",");
			var valueData=data.split("^")[1].split(",");
			for (var i=0;i<nameData.length;i++)
			{
				var newSeriesData=new setSeriesData(nameData[i],valueData[i])
				serData.push(newSeriesData)
			}
			option.series[0].data=serData;
			ActionChart.setOption(option);
			break;
		default:
			break;
	}
}
/*
** add by zx 2017-06-01
** 大屏数据Ajax统一调用
** Query数据集处理
*/
function getVisualizationList(ClassMethod,Arg,ActionDesc,Type)
{
	jQuery.ajax({
    	async: false, //true,
    	cache: false,
        url :"dhceq.jquery.csp",
        timeout : 50000,
        type:"POST",
            data:{
            ClassName:"web.DHCEQ.Process.DHCEQVisualization",
            QueryName:ClassMethod,
            Arg1:Arg,
            Arg2:ActionDesc,
	        ArgCnt:2
        },
       	error:function(XMLHttpRequest, textStatus, errorThrown){
                    messageShow("","","",XMLHttpRequest.status);
                    messageShow("","","",XMLHttpRequest.readyState);
                    messageShow("","","",textStatus);
                    alertShow("调试2:"+errorThrown);
                    JSON.stringify(XMLHttpRequest);
        },
        success:function (data, response, status) {
        	jQuery.messager.progress('close');
			data=data.replace(/\ +/g,"");	//去掉空格
			data=data.replace(/[\r\n]/g,"");	//去掉回车换行
			var dataObject=eval('(' + data + ')');
			if(Type==6)
			{
				jQuery("#scrollWait").find("li").remove();
			}
			else if(Type==7)
			{
				jQuery("#scrollAccept").find("li").remove();
			}
			else
			{
				jQuery("#scroll").find("li").remove(); 
			}
			for (var i=0;i<dataObject.rows.length;i++)
			{
				var TMaintRequestDR=dataObject.rows[i].TMaintRequestDR;
				var TExObj=dataObject.rows[i].TExObj;
				var TExObjLoc=dataObject.rows[i].TExObjLoc;
				var TRequestUser=dataObject.rows[i].TRequestUser;
				var TAcceptUser=dataObject.rows[i].TAcceptUser;
				var TRequestDate=dataObject.rows[i].TRequestDate;
				var TAcceptDate=dataObject.rows[i].TAcceptDate;
				var TActionDesc=dataObject.rows[i].TActionDesc;
				var TActionCode=dataObject.rows[i].TActionCode;
				var TDate=dataObject.rows[i].TDate;
				if (TDate!=="") TDate=TDate+"天";
				MakeSpan(TExObj,TExObjLoc,TRequestUser,TAcceptUser,TRequestDate,TAcceptDate,TActionDesc,TActionCode,TDate,Type,TMaintRequestDR)
			}
       }
    })
}
function initMaintStatistics(data)
{
	StatisticsChart = echarts.init(document.getElementById('Statistics'));
	var wholenum=parseInt(data.split("^")[0]);
	var maintnum=parseInt(data.split("^")[1]);
	option = {
	    tooltip: {
	        trigger: 'item',
	        formatter: "{a} <br/>{b}: {c} ({d}%)"
	    },
	    color:['#008B45', '#7828CE'] ,
	    legend: {
	        orient: 'vertical',
	        x: 'left',
	        data:['正常','故障'],
	        textStyle:{    //图例文字的样式
		        color:'#F3E3EE',
		        fontSize:12
	    	}
	    },
	    series: [
	        {
	            name:'设备完好率',
	            type:'pie',
	            radius: ['50%', '70%'],
	            avoidLabelOverlap: false,
	            label: {
	                normal: {
	                    show: false,
	                    position: 'center'
	                },
	                emphasis: {
	                    show: true,
	                    textStyle: {
	                        fontSize: '30',
	                        fontWeight: 'bold'
	                    }
	                }
	            },
	            labelLine: {
	                normal: {
	                    show: false
	                }
	            },
	            data:[
	                {value:wholenum, name:'正常'},
	                {value:maintnum, name:'故障'}
	            ]
	        }
	    ]
	};
	StatisticsChart.setOption(option);
	var MaintStatistics=(wholenum/(wholenum+maintnum)*100).toFixed(2);
	jQuery("#maintstatistics").html(MaintStatistics+"%");

}
function initMaintByMonth(data)
{
	MonthChart = echarts.init(document.getElementById('MonthWork'));
		option = {
	    tooltip: {
	        trigger: 'axis'
	    },
	    legend: {
	        data:['月报修量','月完成量'],
	        textStyle:{    //图例文字的样式
		        color:'#F3E3EE',
		        fontSize:12
	    	}
	    },
	    grid: {
	        left: '4%',
	        right: '4%',
	        bottom: '8%',
	        containLabel: true
	    },
	    xAxis: {
	        type: 'category',
	        boundaryGap: false,
	        axisLine:{
	        	lineStyle:{
	            	color:'#F3E3EE',
	            	width:2
	            }
	      	},
	      	axisLabel: {
	           show: true,
	           rotate: 30,
	           textStyle: {
	               color: '#F3E3EE',
	               fontSize:10
	           }
	        },
	        data:data.split("^")[0].split(",")
	    },
	    yAxis: {
	        type: 'value',
	        axisLine:{
	        	lineStyle:{
	            	color:'#F3E3EE',
	            	width:2
	            }
	      	},
	       splitLine: {lineStyle:{color: ['#092756']}}
	    },
	    series: [
	        {
	            name:'月报修量',
	            type:'line',
	            smooth:true,
	            itemStyle:{
	            	normal:{color:'#2163CD'}  
	            },
	            data:data.split("^")[1].split(",")
	        },
	        {
	            name:'月完成量',
	            type:'line',
	            smooth:true,
	            itemStyle:{
	            	normal:{color:'#008B45'}  
	            },
	            data:data.split("^")[2].split(",")
	        }
	    ]
	};
	
	MonthChart.setOption(option);
	MonthChart.on('click', function (param) {
	var Month=param.name;
		getMaintDetail(Month,"","");
    });
}
function initMaintByGroup(data)
{
	GroupChart = echarts.init(document.getElementById('GroupWork'));
	option = {
	    tooltip : {
	        trigger: 'axis',
	        axisPointer : {            // 坐标轴指示器，坐标轴触发有效
	            type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
	        }
	    },
	    legend: {
	        data:['已经完成','正在维修'],
	        textStyle:{    //图例文字的样式
		        color:'#F3E3EE',
		        fontSize:12
	    	}
	    },
	    grid: {
	        left: '3%',
	        right: '4%',
	        bottom: '8%',
	        containLabel: true
	    },
	    xAxis : [
	        {
	            type : 'category',
	            axisLabel: {
		            rotate: 30
		        },
	            axisLine:{
		        	lineStyle:{
		            	color:'#F3E3EE',
		            	width:2
		            }
		      	},
	            data :data.split("^")[0].split(",")
	        }
	    ],
	    yAxis : [
	        {
	            type : 'value',
	            axisLine:{
		        	lineStyle:{
		            	color:'#F3E3EE',
		            	width:2
		            }
		      	},
	            splitLine: {lineStyle:{color: ['#092756']}}
	        }
	    ],
    
	    series : [
	        {
	            name:'已经完成',
	            type:'bar',
	            stack: '维修量',
	            itemStyle:{  
	            	normal:{color:'#008B45'}  
	            },
	            barWidth: 15,
	            data:data.split("^")[2].split(",")
	        },
	        {
	            name:'正在维修',
	            type:'bar',
	            stack: '维修量',
	            itemStyle:{  
	            	normal:{color:'#7828CE'}  
	            },
	            barWidth: 15,
	            data:data.split("^")[1].split(",")
	        }
	    ]
	};
	GroupChart.setOption(option);
	GroupChart.on('click', function (param) {
		var MaintGroup=param.name;
		getMaintDetail("",MaintGroup,"");
    });
}
function initMaintByEngineer(data)
{
	
	EngineerChart = echarts.init(document.getElementById('Engineer'));
	option = {
	    tooltip : {
	        trigger: 'axis',
	        axisPointer : {            // 坐标轴指示器，坐标轴触发有效
	            type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
	        }
	    },
	    legend: {
	        data:['已经完成','正在维修'],
	        textStyle:{    //图例文字的样式
		        color:'#F3E3EE',
		        fontSize:12
	    	}
	    },
	    toolbox: {
        	show : true,
        	color:['#1e90ff'],
        	itemSize: 30,  
	        feature : { 
	             myTool:{//自定义按钮 danielinbiti,这里增加，selfbuttons可以随便取名字    
	             	show:true,//是否显示    
	                title:'详细工作量', //鼠标移动上去显示的文字 
	                icon:'image://../scripts/dhceq/easyui/dhceqicon/details.png', 
	                //icon:'path://M432.45,595.444c0,2.177-4.661,6.82-11.305,6.82c-6.475,0-11.306-4.567-11.306-6.82s4.852-6.812,11.306-6.812C427.841,588.632,432.452,593.191,432.45,595.444L432.45,595.444z M421.155,589.876c-3.009,0-5.448,2.495-5.448,5.572s2.439,5.572,5.448,5.572c3.01,0,5.449-2.495,5.449-5.572C426.604,592.371,424.165,589.876,421.155,589.876L421.155,589.876z M421.146,591.891c-1.916,0-3.47,1.589-3.47,3.549c0,1.959,1.554,3.548,3.47,3.548s3.469-1.589,3.469-3.548C424.614,593.479,423.062,591.891,421.146,591.891L421.146,591.891zM421.146,591.891',  //'image://http://echarts.baidu.com/images/favicon.png', //图标    
	                //icon: 'path://<g id="Marketing_sliced" sketch:type="MSLayerGroup" transform="translate(0.000000, -840.000000)"></g><g id="Marketing" sketch:type="MSLayerGroup" transform="translate(2.000000, -830.000000)" stroke="#314E55" stroke-width="2" stroke-linejoin="round"><g id="Saleshop" transform="translate(4.000000, 838.000000)" sketch:type="MSShapeGroup"><rect id="Rectangle-1544" stroke-linecap="round" fill="#EA86A5" x="10" y="0" width="36" height="18"></rect><path d="M31,13 L26,13" id="Line" stroke-linecap="square"></path><path d="M40,13 L35,13" id="Line" stroke-linecap="square"></path><path d="M17,13 L17,5" id="Line" stroke-linecap="square"></path><path d="M22,13 L22,5" id="Line" stroke-linecap="square"></path><path d="M26,13 L26,5" id="Line" stroke-linecap="square"></path><path d="M31,13 L35,5" id="Line" stroke-linecap="square"></path><path d="M17,5 L22,5" id="Line" stroke-linecap="square"></path><path d="M17,9 L22,9" id="Line" stroke-linecap="square"></path></g></g></g>',
	                option:{},    
	                onclick:function(option1) {//点击事件,这里的option1是chart的option信息    
	                	getEngineerWorkDetail();//这里可以加入自己的处理代码，切换不同的图形    
	                }    
	            } 
	        }  
	    },
	    grid: {
	        left: '3%',
	        right: '4%',
	        bottom: '8%',
	        containLabel: true
	    },
	    xAxis : [
	        {
	            type : 'category',
	            axisLabel: {
		            textStyle:{    //图例文字的样式
				        color:'#F3E3EE',
				        fontSize:10
			    	},
		            rotate: 30
		        },
	            axisLine:{
		        	lineStyle:{
		            	color:'#F3E3EE',
		            	width:2
		            }
		      	},
	            data :data.split("^")[0].split(",")
	        }
	    ],
	    yAxis : [
	        {
	            type : 'value',
	            axisLine:{
		        	lineStyle:{
		            	color:'#F3E3EE',
		            	width:2
		            }
		      	},
	            splitLine: {lineStyle:{color: ['#092756']}}
	        }
	    ],
    
	    series : [
	        {
	            name:'已经完成',
	            type:'bar',
	            stack: '维修量',
	            itemStyle:{  
	            	normal:{color:'#008B45'}  
	            },
	            barWidth: 15,
	            data:data.split("^")[2].split(",")  //[12, 12, 11, 34, 9, 23, 20]
	        },
	        {
	            name:'正在维修',
	            type:'bar',
	            stack: '维修量',
	            itemStyle:{  
	            	normal:{color:'#7828CE'}  
	            },
	            barWidth: 15,
	            data:data.split("^")[1].split(",")  //[22, 18, 11, 24, 20, 30, 10]
	        }
	    ]
	};
	EngineerChart.setOption(option);
	EngineerChart.on('click', function (param) {
		var AcceptUser=param.name;
		getMaintDetail("","",AcceptUser);
    });
}
function initActionDistribution(data)
{
	var serData=new Array();
	var nameData=data.split("^")[0].split(",");
	var valueData=data.split("^")[1].split(",");
	for (var i=0;i<nameData.length;i++)
	{
		var newSeriesData=new setSeriesData(nameData[i],valueData[i])
		serData.push(newSeriesData)
	}
	ActionChart = echarts.init(document.getElementById('Action'));
	option = {
	    tooltip: {
	        trigger: 'item',
	        formatter: "{a} <br/>{b}: {c} ({d}%)"
	    },
	    color:['#9D2034', '#DF5F21','#259FD2','#008B45','#7828CE','#2551BB','#DDA803'] ,
	    legend: {
	        orient: 'vertical',
	        x: 'right',
	        data:nameData,
	        textStyle:{    //图例文字的样式
		        color:'#F3E3EE',
		        fontSize:12
	    	}
	    },
	    series: [
	    {
	        name:'状态分布',
	        type:'pie',
	        radius: ['50%', '70%'],
	        center: ['35%', '50%'], 
	        avoidLabelOverlap: false,
	        label: {
	            normal: {
	                show: false,
	                position: 'center'
	            },
	            emphasis: {
	                show: true,
	                textStyle: {
	                    fontSize: '30',
	                    fontWeight: 'bold'
	                }
	            }
	        },
	        labelLine: {
	            normal: {
	                show: false
	            }
	        },
	        data:serData
		    }
		]
	};
	ActionChart.setOption(option);
	ActionChart.on('click', function (param) {
		var ActionDesc=param.name;
		initActionDataList(ActionDesc);
    	
    });
}
/*
** add by zx 2017-06-06
** 按顺序刷新各区域数据
*/
function IntervalNext()
{
	switch(IntervalFlag)
	{
		case 1:  //
			getVisualization("GetMaintStatistics",IntervalFlag,"Y");
			IntervalFlag++;
			break;
		case 2:
			getVisualization("GetMaintAnaly",IntervalFlag,"Y");
			IntervalFlag++;
			break;
		case 3:
			getVisualization("GetMaintGroupWorkNum",IntervalFlag,"Y");
			IntervalFlag++;
			break;
		case 4:
			getVisualization("GetEngineerWorkNum",IntervalFlag,"Y");
			IntervalFlag++;
			break;
		case 5:
			getVisualization("GetMaintAction",IntervalFlag,"Y");
			IntervalFlag++;
			break;
		case 6:
			getVisualizationList("GetMaintRequestDetail","0","",IntervalFlag);
			IntervalFlag++;
			break;
		case 7:
			getVisualizationList("GetMaintRequestDetail","1","",IntervalFlag);
			IntervalFlag=1;
			break;
		default:
			break;
	}
}
/*
** add by zx 2017-06-06
** 滚动列表数据加载
*/
function MakeSpan(TExObj,TExObjLoc,TRequestUser,TAcceptUser,TRequestDate,TAcceptDate,TActionDesc,TActionCode,TDate,Type,TMaintRequestDR)
{
	var actioncss=""
	switch(TActionCode)
	{
		case '':
			actioncss="divcss7";
		break;
		case 'WX_Assign':
			actioncss="divcss1";
		break;
		case 'WX_Accept':
			actioncss="divcss2";
		break;
		case 'WX_Finish':
			actioncss="divcss3";
		break;
		case 'WX_Maint':
			actioncss="divcss4";
		break;
		case 'WX_Evaluate':
			actioncss="divcss5";
		break;
		case 'WX_Audit':
			actioncss="divcss6";
		break;
		case 'WX_LocAudit':
			actioncss="divcss6";
		break;
		default:
			actioncss="divcss7";
		break;
	}
	if(Type==6)
	{
		document.getElementById("scrollWait").innerHTML=
		document.getElementById("scrollWait").innerHTML+'<li onclick="getOneMaint('+TMaintRequestDR+');"><div class="lidivcss1">'+TExObjLoc+'</div><div class="lidivcss1">'+TExObj+'</div>'+
		'<div class="lidivcss2">'+TRequestUser+'</div><div class="lidivcss2">'+TRequestDate+'</div><div class="lidivcss3">'+TDate+'</div></li>';
	}
	else if (Type==7)
	{
		document.getElementById("scrollAccept").innerHTML=
		document.getElementById("scrollAccept").innerHTML+'<li onclick="getOneMaint('+TMaintRequestDR+');"><div class="'+actioncss+'">'+TActionDesc+'</div><div class="lidivcss1">'+TExObjLoc+'</div><div class="lidivcss1">'+TExObj+'</div>'+
		'<div class="lidivcss2">'+TAcceptUser+'</div><div class="lidivcss2">'+TAcceptDate+'</div><div class="lidivcss3">'+TDate+'</div></li>';
	}
	else 
	{
		document.getElementById("scroll").innerHTML=
		document.getElementById("scroll").innerHTML+'<li onclick="getOneMaint('+TMaintRequestDR+');"><div class="'+actioncss+'">'+TActionDesc+'</div><div class="lidivcss1">'+TExObjLoc+'</div><div class="lidivcss1">'+TExObj+'</div>'+
		'<div class="lidivcss2">'+TAcceptUser+'</div><div class="lidivcss2">'+TAcceptDate+'</div><div class="lidivcss3">'+TDate+'</div></li>';
	}
}
///创建SeriesData对象
function setSeriesData(name,value)
{
    this.name = name;
    this.value = value;
}
/*
** add by zx 2017-06-06
** 动作分布图表点击模态窗口数据加载
*/
function initActionDataList(ActionDesc)
{
	getVisualizationList("GetMaintRequestDetail","",ActionDesc,8);
	jQuery('#dlg').dialog('open');
}

/*
** add by zx 2017-06-01
** 月报修统计 组工作量  工程师工作量 统一调用
** Query数据集处理
*/
function getMaintDetail(Month,MaintGroup,AcceptUser)
{
	jQuery.ajax({
    	async: false, //true,
    	cache: false,
        url :"dhceq.jquery.csp",
        timeout : 50000,
        type:"POST",
            data:{
            ClassName:"web.DHCEQ.Process.DHCEQVisualization",
            QueryName:"GetMaintRequestList",
            Arg1:Month,
            Arg2:MaintGroup,
            Arg3:AcceptUser,
            Arg4:'',
	        ArgCnt:4
        },
       	error:function(XMLHttpRequest, textStatus, errorThrown){
                    messageShow("","","",XMLHttpRequest.status);
                    messageShow("","","",XMLHttpRequest.readyState);
                    messageShow("","","",textStatus);
        },
        success:function (data, response, status) {
        	jQuery.messager.progress('close');
			data=data.replace(/\ +/g,"");	//去掉空格
			data=data.replace(/[\r\n]/g,"");	//去掉回车换行
			var dataObject=eval('(' + data + ')');
			//加载数据之前情况之前数据
			jQuery("#scroll").find("li").remove(); 
			for (var i=0;i<dataObject.rows.length;i++)
			{
				var TMaintRequestDR=dataObject.rows[i].TMaintRequestDR;
				var TExObj=dataObject.rows[i].TExObj;
				var TExObjLoc=dataObject.rows[i].TExObjLoc;
				var TRequestUser="";
				var TAcceptUser=dataObject.rows[i].TAcceptUser;
				var TRequestDate="";
				var TAcceptDate=dataObject.rows[i].TAcceptDate;
				var TActionDesc=dataObject.rows[i].TActionDesc;
				var TActionCode=dataObject.rows[i].TActionCode;
				var TDate=dataObject.rows[i].TDateNum;
				if (TDate!=="") TDate=TDate+"天";
				MakeSpan(TExObj,TExObjLoc,TRequestUser,TAcceptUser,TRequestDate,TAcceptDate,TActionDesc,TActionCode,TDate,"",TMaintRequestDR)
			}
			//数据加载完后,弹出模态窗口
			jQuery('#dlg').dialog('open');
       }
    })
}
/*
** add by zx 2017-08-22
** 工程师近一个月工作量明细
** Query数据集处理
*/
function getEngineerWorkDetail()
{
	jQuery.ajax({
    	async: false, //true,
    	cache: false,
        url :"dhceq.jquery.method.visualization.csp",
        timeout : 50000,
        type:"POST",
            data:{
            ClassName:"web.DHCEQ.Process.DHCEQVisualization",
            MethodName:"GetEngineerMaintWorkNum",
	        ArgCnt:0
        },
       	error:function(XMLHttpRequest, textStatus, errorThrown){
                    messageShow("","","",XMLHttpRequest.status);
                    messageShow("","","",XMLHttpRequest.readyState);
                    messageShow("","","",textStatus);
        },
        success:function (data, response, status) {
        	jQuery.messager.progress('close');
			data=data.replace(/\ +/g,"");	//去掉空格
			data=data.replace(/[\r\n]/g,"");	//去掉回车换行
			initMaintByEngineerWork(data);
        }
    })
	jQuery('#dlgdetail').dialog('open');
}

function getOneMaint(TRowID)
{
	getApproveInfo(TRowID);
	getOneMaintDetail(TRowID);
}

function initMaintByEngineerWork(data)
{
	
	var EngineerWorkChart = echarts.init(document.getElementById('EngineerDetail'));
	option = {
		title: {  
			//主标题文本，'\n'指定换行  
			text: '近30天工作量一览',
			textStyle: {
				fontSize: 16,
				fontWeight: 'bold',
				color: '#F3E3EE'          // 主标题文字颜色
			}
		}, 
	    tooltip : {
	        trigger: 'axis',
	        axisPointer : {            // 坐标轴指示器，坐标轴触发有效
	            type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
	        }
	    },
	    legend: {
	        data:['已经完成','正在维修'],
	        textStyle:{    //图例文字的样式
		        color:'#F3E3EE',
		        fontSize:12
	    	}
	    },
	    grid: {
	        left: '3%',
	        right: '4%',
	        bottom: '8%',
	        containLabel: true
	    },
	    xAxis : [
	        {
            	type : 'category',
				axisTick : {
					alignWithLabel : true
				},
				axisLine:{
		        	lineStyle:{
		            	color:'#F3E3EE',
		            	width:2
		            }
		      	},
				axisLabel : {
					interval : 0,
					formatter : function(val) {
						return val.split("").join("\n");
					}
				},
	            data :data.split("^")[0].split(",")
	        }
	    ],
	    yAxis : [
	        {
	            type : 'value',
	            axisLine:{
		        	lineStyle:{
		            	color:'#F3E3EE',
		            	width:2
		            }
		      	},
	            splitLine: {lineStyle:{color: ['#092756']}}
	        }
	    ],
    
	    series : [
	        {
	            name:'已经完成',
	            type:'bar',
	            stack: '维修量',
	            itemStyle:{  
	            	normal:{color:'#008B45'}  
	            },
	            barWidth: 15,
	            data:data.split("^")[2].split(",")  //[12, 12, 11, 34, 9, 23, 20]
	        },
	        {
	            name:'正在维修',
	            type:'bar',
	            stack: '维修量',
	            itemStyle:{  
	            	normal:{color:'#7828CE'}  
	            },
	            barWidth: 15,
	            data:data.split("^")[1].split(",")  //[22, 18, 11, 24, 20, 30, 10]
	        }
	    ]
	};
	EngineerWorkChart.setOption(option);
	EngineerWorkChart.on('click', function (param) {
		var AcceptUser=param.name;
		getMaintDetail("","",AcceptUser);
    });
    
}
/*
** add by zx 2017-08-23
** 获维修单审核进去
*/
function getApproveInfo(rowid)
{
	jQuery.ajax({
    	async: false, //true,
    	cache: false,
        url :"dhceq.jquery.csp",
        timeout : 50000,
        type:"POST",
            data:{
            ClassName:"web.DHCEQMessages",
            QueryName:"GetApproveInfo",
            Arg1:"31",
            Arg2:rowid,
	        ArgCnt:2
        },
       	error:function(XMLHttpRequest, textStatus, errorThrown){
                    messageShow("","","",XMLHttpRequest.status);
                    messageShow("","","",XMLHttpRequest.readyState);
                    messageShow("","","",textStatus);
        },
        success:function (data, response, status) {
        	jQuery.messager.progress('close');
			data=data.replace(/\ +/g,"");	//去掉空格
			data=data.replace(/[\r\n]/g,"");	//去掉回车换行
			var dataObject=eval('(' + data + ')');
			//加载数据之前情况之前数据
			document.getElementById("ApproveInfo").innerHTML='';
			var num=dataObject.rows.length;
			for (var i=0;i<num;i++)
			{
				var TApproveUser = dataObject.rows[i].TApproveUser;
				var TAction = dataObject.rows[i].TAction;
				var TApproveDate = dataObject.rows[i].TApproveDate;
				var TApproveTime = dataObject.rows[i].TApproveTime;
				var TTimeInfo = dataObject.rows[i].TTimeInfo;
				var TOpinion = dataObject.rows[i].TOpinion;
				MakeApproveInfo(TApproveUser,TAction,TApproveDate,TApproveTime,TTimeInfo,TOpinion,i+1,num)
			}
			//数据加载完后,弹出模态窗口
			jQuery('#timeline').dialog('open');
       }
    })
}
function MakeApproveInfo(TApproveUser,TAction,TApproveDate,TApproveTime,TTimeInfo,TOpinion,i,len)
{
	var classstyle="list_head1"
	if(i==len){
		classstyle="list_head"
	}
	document.getElementById("ApproveInfo").innerHTML=
	'<div class="'+classstyle+'"><div class="time_box" ><p>'+i+'</p></div><div class="time_content"><em></em><span>'+TApproveDate+'</span></div><div class="clear"></div></div>'+
	'<div class="list_content"><dl><dt><h2>'+TApproveUser+' '+TAction+' '+TOpinion+' '+TApproveTime+'</h2></dt><dd class="pm_organ">响应时长：<span>'+TTimeInfo+'</span></dd></dl></div>'+
	document.getElementById("ApproveInfo").innerHTML;
}
// add by zx 2017-09-12
function getOneMaintDetail(rowid)
{
	jQuery.ajax({
    	async: false, //true,
    	cache: false,
        url :"dhceq.jquery.method.visualization.csp",
        timeout : 50000,
        type:"POST",
            data:{
            ClassName:"web.DHCEQM.DHCEQMMaintRequest",
            MethodName:"GetOneMaintRequest",
            Arg1:'',
            Arg2:'',
            Arg3:rowid,
            Arg4:'',
            Arg5:'',
            Arg6:'2',
	        ArgCnt:6
        },
       	error:function(XMLHttpRequest, textStatus, errorThrown){
                    messageShow("","","",XMLHttpRequest.status);
                    messageShow("","","",XMLHttpRequest.readyState);
                    messageShow("","","",textStatus);
                    alertShow("调试1:"+errorThrown);
                    JSON.stringify(XMLHttpRequest);
        },
        success:function (data, response, status) {
        	jQuery.messager.progress('close');
			data=data.replace(/\ +/g,"");	//去掉空格
			data=data.replace(/[\r\n]/g,"");	//去掉回车换行
			data=data.split("^");
			var faultcase="";
			if(data[82]==""){
				faultcase=data[10];
			}else{
				if(data[10]==""){
					faultcase=data[82];
				}else{
					faultcase=data[82]+"("+data[10]+")";
				}
			}
			if(data[120]!="") var startdate=data[120].split("/")[2]+"-"+data[120].split("/")[1]+"-"+data[120].split("/")[0];
			var equipinfo=data[80]+"于"+startdate+"启用";
			jQuery("#equipinfo").html(equipinfo);
			if(data[17]!="") var requestdate=data[17].split("/")[2]+"-"+data[17].split("/")[1]+"-"+data[17].split("/")[0];
			var requestinfo=data[85]+"于"+requestdate+"报修";
			jQuery("#requestinfo").html(requestinfo);
			jQuery("#faultinfo").html(faultcase);
			jQuery("#equip").html(data[79]+"("+data[121]+")");
       }
    })
}