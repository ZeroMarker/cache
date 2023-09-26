var EchartsObj=new Array();
var EchartsObjOption=new Array();
var EchartsObjMap=new Array();
//Create By ZY 20160922 增加图表公共处理方法及函数
//====================================================================
///add by zy 2016-09-19
///初始化图标
///objID:  图标元素ID
///option需要的数据对象  : setEchertsData()对象定义的
function initEcharts(objID,objEchertsData)
{
	var myChart = echarts.init(document.getElementById(objID));
	//pie  饼状图  bar  柱状图  type: objEchertsData.seriesType
	option_pie = {
	    	title : {text: objEchertsData.text,subtext: objEchertsData.subtext,
	    			 textStyle: {fontSize: 16,fontWeight: 'bold',color: '#05725F'},  // 主标题文字颜色
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
	    			 textStyle: {fontSize: 16,fontWeight: 'bold',color: '#05725F'},  // 主标题文字颜色
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
	    			textStyle:{fontSize: 16,fontWeight: 'bold',color: '#05725F'}  // 主标题文字颜色
	 				},
		    //color: objEchertsData.color,
		    legend : {
		    	x: 'right', //add by zx 2017-03-30 需求号：358542 
			    y: 'top', 
					data : [ '期初原值', '本月新购', '期末原值' ]  //add by zx 2017-03-30 需求号：357255 
				},
		    tooltip : {
		        trigger: 'axis',
		        axisPointer : {            // 坐标轴指示器，坐标轴触发有效
		            type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
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

///创建EchertsData对象
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

///创建SeriesData对象
function setSeriesData(name,value)
{
    this.name = name;
    this.value = value;
}
//add by zx 2017-02-22 
//柱状图样式改变赋值
function setBarData(name,data)
{
    this.name = name;
    this.type = 'bar';
    this.barWidth = 30;
    this.stack = '租借设备';
    this.data = data;
}
///Add By DJ 2017-08-31
function setLineData(name,data)
{
    this.name = name;
    this.type = 'line';
    this.data = data;
}

/***************************************************************************************************/
///初始化图表
function initChartsDefine(ChartsNameStr,ChartsPars)
{
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTChartsDefine","GetChartsInfo",ChartsNameStr,ChartsPars)
	jsonData=jQuery.parseJSON(jsonData);
	var ChartsNameStr=ChartsNameStr.split("^")
	for (var i=0; i<ChartsNameStr.length; i++)
	{
		var CurChartName=ChartsNameStr[i]
		var LengedX=jsonData[CurChartName+"_D"]["CDLegentX"]
		var LengedY=jsonData[CurChartName+"_D"]["CDLegentY"]
		var SubTextPos=jsonData[CurChartName+"_D"]["CDSubTextPosition"]
		if (LengedX=="") LengedX="right" //Modify by zx 2020-04-26 默认靠右 BUG ZX0084
		if (LengedY=="") LengedY="top"
		if (SubTextPos=="") SubTextPos="left"
		if (jsonData[CurChartName+"_D"]!=undefined)
		{
			if (jsonData[CurChartName+"_D"]["CDSeriesType"]=="eqblock")
			{
				//图表与界面元素对照关系
				jQuery('#'+CurChartName).append(jsonData[CurChartName+"_S"])
			}
			else if (jsonData[CurChartName+"_D"]["CDSeriesType"]=="eqgrid")
			{
				for (var key in jsonData[CurChartName+"_S"])
				{
					jQuery('#'+CurChartName).append(jsonData[CurChartName+"_S"][key])
				}
				$(".eq_radius").each(function(){
					var id=$(this)[0].id;
					if ((jQuery("#"+id).attr("value")!="")&&(jQuery("#"+id).attr("value")!="undefined"))
					{
						$HUI.tooltip('#'+id,{
							position: 'bottom',
							content: function(){return jQuery("#"+id).attr("value");},
							onShow: function(){
								$(this).tooltip('tip').css({
									backgroundColor: '#88a8c9',
									borderColor: '#4f75aa',
									boxShadow: '1px 1px 3px #4f75aa'
								});
							 },
							onPosition: function(){
								$(this).tooltip('tip').css('bottom', $(this).offset().bottom);
								$(this).tooltip('arrow').css('bottom', 20);
							}
						});
					}
				});
			}
			else if ((jsonData[CurChartName+"_D"]["CDSeriesType"]=="line")||(jsonData[CurChartName+"_D"]["CDSeriesType"]=="bar"))
			{
				if ((EchartsObj[EchartsObjMap[CurChartName]]=="")||(EchartsObj[EchartsObjMap[CurChartName]]==undefined))
				{
					var myChart = echarts.init(document.getElementById(EchartsObjMap[CurChartName]));
					EchartsObj[EchartsObjMap[CurChartName]]=myChart
				}
				else
				{
					var myChart =EchartsObj[EchartsObjMap[CurChartName]]
				}
				var option={
							title:{text:jsonData[CurChartName+"_D"]["CDSubText"],x:SubTextPos},
							legend: {x:LengedX, y:LengedY, data: strToArray(EchartsObjOption[EchartsObjMap[CurChartName]],0,jsonData[CurChartName+"_L"])},
							xAxis: [{
								axisLabel:{interval:0,rotate:30},
								type: 'category',
								data: strToArray("",1,jsonData[CurChartName+"_XY"])
								}],
							yAxis: createyAxis(EchartsObjOption[EchartsObjMap[CurChartName]],jsonData[CurChartName+"_D"]["CDHold1"],jsonData[CurChartName+"_D"]["CDHold2"]),
							series: createSeriesData(EchartsObjOption[EchartsObjMap[CurChartName]],jsonData[CurChartName+"_D"]["CDSeriesType"],jsonData[CurChartName+"_LDR"],jsonData[CurChartName+"_L"],jsonData[CurChartName+"_XYDR"],jsonData,CurChartName)
						};
				EchartsObjOption[EchartsObjMap[CurChartName]]=option
				myChart.setOption(option); 
			}
			else if (jsonData[CurChartName+"_D"]["CDSeriesType"]=="pie")
			{
				if ((EchartsObj[EchartsObjMap[CurChartName]]=="")||(EchartsObj[EchartsObjMap[CurChartName]]==undefined))
				{
					var myChart = echarts.init(document.getElementById(EchartsObjMap[CurChartName]));
					EchartsObj[EchartsObjMap[CurChartName]]=myChart
				}
				else
				{
					var myChart =EchartsObj[EchartsObjMap[CurChartName]]
				}
				var lengedDRCount=jsonData[CurChartName+"_LDR"].split("^")
				var legendDataCount=jsonData[CurChartName+"_L"].split("^")
				var xyDRCount=jsonData[CurChartName+"_XYDR"].split("^")
				var xyDataCount=jsonData[CurChartName+"_XY"].split("^")
				var SeriesCenter=jsonData[CurChartName+"_D"]["CDSeriesCenter"].split(",")
				var ColorScheme=new Array()
				if ((jsonData[CurChartName+"_ColorScheme"]!="")&&(jsonData[CurChartName+"_ColorScheme"]!=undefined))
				{
					var ColorScheme=strToArray("",1,jsonData[CurChartName+"_ColorScheme"])
				}
				var pieSeries=new Array()			
				for (var k=0; k<xyDRCount.length; k++)
				{
					//多饼图需重新定位(默认为Y轴扩展)(100*(1+2*k)/xyDRCount.length)
					var SeriesCenterArray=new Array()
					SeriesCenterArray.push((100*(1+2*k)/(xyDRCount.length*2))+"%")
					SeriesCenterArray.push(SeriesCenter[1]+"%")
					
					var CurXYDR=xyDRCount[k]
					var OneListArray=new Array()
					for (var j=0; j<lengedDRCount.length; j++)
					{
						var CurLengedDR=lengedDRCount[j]
						OneListArray.push({name:legendDataCount[j],value:jsonData[CurChartName+"_S"][CurLengedDR+"-"+CurXYDR]})
					}
					var seriesName=jsonData[CurChartName+"_D"]["CDSeriesName"]
					if (xyDRCount.length>1) seriesName=xyDataCount[k]
					pieSeries.push({color:ColorScheme,name:seriesName,type:'pie',roseType:jsonData[CurChartName+"_D"]["CDSeriesRoseType"],radius:jsonData[CurChartName+"_D"]["CDSeriesRadius"]+"%",center: SeriesCenterArray,data:OneListArray})
				}
				//多饼图
				var option={
							title : {text: jsonData[CurChartName+"_D"]["CDSubText"],x:SubTextPos},
							tooltip : {trigger: 'item',formatter: "{a} <br/>{b} : {c} ({d}%)"},
							legend: {orient: 'vertical',x: LengedX, y: LengedY, data: strToArray("",0,jsonData[CurChartName+"_L"]), padding:[10,10,10,10]},  //Modify by zx 2020-04-29 BUG ZX0085 增加边距处理
							series : pieSeries
						};
				myChart.setOption(option);
			}
		}
	}	
}
///创建Y轴信息
function createyAxis(echartsObj,yname,yunit)
{
	if ((echartsObj!="")&&(echartsObj!=undefined))
	{
		var oldInfo=""
		oldInfo=echartsObj.yAxis
		var OldJsonStr=JSON.stringify(oldInfo)
		var OldArray=JSON.parse(OldJsonStr)
	}
	else
	{
		var OldArray=new Array()
	}
	if ((yname=="")&&(yunit==""))
	{
		OldArray.push({type:'value'})
	}
	else
	{		
		OldArray.push({type:'value', name:yname, axisLabel: {formatter: '{value}'+yunit}})
	}
	return OldArray
}
///字符串转数组
function strToArray(echartsObj,optionprop,vStr)
{
	if ((echartsObj!="")&&(echartsObj!=undefined))
	{
		var oldInfo=""
		if (optionprop==0)
		{
			oldInfo=echartsObj.legend.data
		}
		else if (optionprop==1)
		{
			oldInfo=echartsObj.xAxis.data
		}
		var OldJsonStr=JSON.stringify(oldInfo)
		var OldArray=JSON.parse(OldJsonStr)
	}
	else
	{
		var OldArray=new Array()
	}
	if (vStr=="") return OldArray
	var StrCount=vStr.split("^")
	for (var i=0; i<StrCount.length; i++)
	{
		OldArray.push(StrCount[i])
	}
	return OldArray
}
///生成SeriesData
function createSeriesData(echartsObj,seriesType,legendDataDR,legendData,xyDataDR,jsonData,element)
{
	var yAxisIndex=0
	var chartsdefine=jsonData[element+"_D"]
	var seriesData=jsonData[element+"_S"]
	if ((echartsObj!="")&&(echartsObj!=undefined))
	{
		oldInfo=echartsObj.series
		var OldJsonStr=JSON.stringify(oldInfo)
		var OldArray=JSON.parse(OldJsonStr)
		yAxisIndex=1
	}
	else
	{
		var OldArray=new Array()
	}
	
	var SeriesMarkLine=new Array()
	var MarkLineInfo=chartsdefine["CDSeriesMarkLine"]
	var MarkLineInfo1=MarkLineInfo.split(",")
	if (chartsdefine["CDSeriesMarkLineType"]=="0")
	{
		SeriesMarkLine.push({silent:false,linestyle:{type:'solid'},label:{position:'end',formatter:"max"},yAxis:MarkLineInfo1[0]})
	}
	else if (chartsdefine["CDSeriesMarkLineType"]=="1")
	{
		SeriesMarkLine.push({silent:false,linestyle:{type:'solid'},label:{position:'end',formatter:"min"},yAxis:MarkLineInfo1[0]})
	}
	else if (chartsdefine["CDSeriesMarkLineType"]=="3")
	{
		SeriesMarkLine.push({type:'average', name:'average'})
	}
	else if (chartsdefine["CDSeriesMarkLineType"]=="2")
	{
		SeriesMarkLine.push({silent:false,linestyle:{type:'solid'},label:{position:'end',formatter:"max"},yAxis:MarkLineInfo1[0]})
		SeriesMarkLine.push({silent:false,linestyle:{type:'solid'},label:{position:'end',formatter:"min"},yAxis:MarkLineInfo1[1]})
	}
	else if (chartsdefine["CDSeriesMarkLineType"]=="4")
	{
		SeriesMarkLine.push({silent:false,linestyle:{type:'solid'},label:{position:'end',formatter:"max"},yAxis:MarkLineInfo1[0]})
		SeriesMarkLine.push({silent:false,linestyle:{type:'solid'},label:{position:'end',formatter:"min"},yAxis:MarkLineInfo1[1]})
		SeriesMarkLine.push({type:'average', name:'average'})
	}
	var areaStyle=chartsdefine["CDSeriesAreaStyle"]
	var stack=chartsdefine["CDSeriesStack"]
	if (areaStyle=="{}") areaStyle={normal:{}}
	if (legendDataDR=="")
	{
		if (seriesType=="line") return [OldArray.push({type:seriesType,stack:stack, areaStyle:areaStyle,data:strToArray(seriesData),yAxisIndex:yAxisIndex,markLine:{data:SeriesMarkLine}})]
		return [OldArray.push({type:seriesType,stack:stack,data:strToArray(seriesData),yAxisIndex:yAxisIndex,markLine:{data:SeriesMarkLine}})]
	}
	var lengedDRCount=legendDataDR.split("^")
	var legendDataCount=legendData.split("^")
	var xyDRCount=xyDataDR.split("^")
	for (var i=0; i<lengedDRCount.length; i++)
	{
		var CurLengedDR=lengedDRCount[i]
		var OneListArray=new Array()
		for (var j=0; j<xyDRCount.length; j++)
		{
			var CurXYDR=xyDRCount[j]
			OneListArray.push(seriesData[CurLengedDR+"-"+CurXYDR])
		}
		if ((jsonData[element+"_ColorScheme"]!="")&&(jsonData[element+"_ColorScheme"]!=undefined))
		{
			var ColorCount=jsonData[element+"_ColorScheme"].split("^")
			if (ColorCount[i]!="")
			{
				if (seriesType=="line")
				{
					OldArray.push({type:seriesType, name:legendDataCount[i] , label:{normal:{show:jsonData[element+"_D"]["CDHold5"],position:'top'}},stack:stack, areaStyle:areaStyle,data:OneListArray,yAxisIndex:yAxisIndex,itemStyle:{normal:{color:ColorCount[i]}},markLine:{data:SeriesMarkLine}})
				}
				else
				{
					OldArray.push({type:seriesType, name:legendDataCount[i], barWidth: jsonData[element+"_D"]["CDHold4"], label:{normal:{show:jsonData[element+"_D"]["CDHold5"],position:'top'}},stack:stack, data:OneListArray,yAxisIndex:yAxisIndex,itemStyle:{normal:{color:ColorCount[i]}},markLine:{data:SeriesMarkLine}})
				}
			}
			else
			{
				if (seriesType=="line")
				{
					OldArray.push({type:seriesType, name:legendDataCount[i] , label:{normal:{show:jsonData[element+"_D"]["CDHold5"],position:'top'}},stack:stack, areaStyle:areaStyle,data:OneListArray,yAxisIndex:yAxisIndex,markLine:{data:SeriesMarkLine}})
				}
				else
				{
					OldArray.push({type:seriesType, name:legendDataCount[i], barWidth: jsonData[element+"_D"]["CDHold4"], label:{normal:{show:jsonData[element+"_D"]["CDHold5"],position:'top'}},stack:stack, data:OneListArray,yAxisIndex:yAxisIndex,markLine:{data:SeriesMarkLine}})
				}
			}
		}
		else
		{
			if (seriesType=="line")
			{
				OldArray.push({type:seriesType, name:legendDataCount[i] , label:{normal:{show:jsonData[element+"_D"]["CDHold5"],position:'top'}},stack:stack, areaStyle:areaStyle,data:OneListArray,yAxisIndex:yAxisIndex,markLine:{data:SeriesMarkLine}})
			}
			else
			{
				OldArray.push({type:seriesType, name:legendDataCount[i], barWidth: jsonData[element+"_D"]["CDHold4"], label:{normal:{show:jsonData[element+"_D"]["CDHold5"],position:'top'}},stack:stack, data:OneListArray,yAxisIndex:yAxisIndex,markLine:{data:SeriesMarkLine}})
			}
		}
	}
	return OldArray
}