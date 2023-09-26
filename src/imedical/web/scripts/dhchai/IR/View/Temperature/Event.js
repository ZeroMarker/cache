//页面Event
function InitTemperatureWinEvent(obj){
	//  默认选中最后一周
	$.form.SetValue("cboWeeks",$("#cboWeeks>option:nth-child(2)").val(),$("#cboWeeks>option:nth-child(2)").text());
	//增加全部选项
	var maxWeekNum = 12; //默认最大显示周数
	var weekLength = $("#cboWeeks>option").length;
	var allDateTo = $("#cboWeeks>option:nth-child(2)").val().split('-')[1];
	if (weekLength >= (maxWeekNum+1)) {
		var allDateFrom = $("#cboWeeks>option:nth-child("+ (maxWeekNum+1) +")").val().split('-')[0];
	} else {
		var allDateFrom = $("#cboWeeks>option:nth-child("+ weekLength +")").val().split('-')[0];
	}
	$("#cboWeeks").prepend("<option value='"+ allDateFrom+"-"+allDateTo +"'>全部</option>");
	creatCharts();
	$("#cboWeeks").change(function(){
		creatCharts();
	});

	function creatCharts(){
		var weekValue = $.form.GetValue("cboWeeks");
		var weekText = $.form.GetText("cboWeeks");
		var weekDateFrom = weekValue.split('-')[0];
		var weekDateTo = weekValue.split('-')[1];
		var DateFrom = parseInt(weekDateFrom);
		var DateTo = parseInt(weekDateTo);
		var isAllWeek = ((weekText=="全部")&&(DateTo-DateFrom)>12) ? true : false; //全部时并且大于两周时去掉x轴内容防止重叠
		if ((DateTo-DateFrom)<6){ 	//不足一周补足一周
			DateTo = DateFrom+6;
		}
		var runQuery = $.Tool.RunQuery("DHCHAI.DPS.MRObservationsSrv","QryObservations",PaadmID,DateFrom,DateTo);
		// 基于准备好的dom，初始化echarts实例
		var myChart = echarts.init(document.getElementById('charts'));
		var xData = [];
		var yData = [];
		if (runQuery.total!=0){
			for (var i = 0;i<runQuery.record.length;i++){
				if (runQuery.record[i].TimeInd!='10'){
					xData.push(runQuery.record[i].TimeInd);
				}else{
					xData.push(runQuery.record[i].TimeInd+'\n\n'+runQuery.record[i].EntryDate);
				}
				yData.push(runQuery.record[i].ItemValue);
			}
		}
		
		option = {
		    title: {
		        //text: '体温记录'
		    },
		    tooltip: {
		        trigger: 'axis',
		        formatter : function (params) {
			       var dataIndex = params[0].dataIndex;
			       if (runQuery.record[dataIndex].ItemValue==''){
				       	return '';
				   }else{
						return '日期：'+runQuery.record[dataIndex].EntryDate + ' ' + runQuery.record[dataIndex].EntryTime + '<br/>'
							+ runQuery.record[dataIndex].ItemDesc + '：' + runQuery.record[dataIndex].ItemValue + '°C';
				   }
		        }
		    },
		    xAxis:  {
			    name : '日期',
			    nameLocation:'end',
			    nameGap:45,
		        type: 'category',
		        splitLine: {
		        	show:true,
		            lineStyle: {
		                type: 'dotted'
		            }
		        },
		        splitArea: {
		             show: true,
		             interval:function(index,value){
			         	if (index%6==0){
				        	return true;
				        }else{
					    	return false;
					    }
			         }
		        },
		        axisLabel: {  
				   interval:0,
				   formatter:function(value)
					{
						return isAllWeek ? "" : value;
					}
				},
		        boundaryGap: true,
		        data:xData
		    },
		    yAxis: {
			    name : '体温',
	            type : 'value',
	            min:'35',
	    		max:'42',
	    		splitLine: {
		            lineStyle: {
		                type: 'dotted'
		            }
		        },
		        axisLabel: {
		            formatter: '{value} °C'
		        }
	        },
		    series: [
		        {
		            name:'体温',
		            type:'line',
		            connectNulls:true,
					symbol: "emptyDiamond",
		            symbolSize:8,
		            data:yData,
		            // smooth:true,
		            markPoint: {
		                data: [
		                    {type: 'max', name: '最高体温'},
		                    {type: 'min', name: '最低体温'}
		                ]
		            },
					markLine: { //在38℃时加横提示线
						data: [
							{yAxis: 38}
						],
						symbol: ['none', 'none']
					}
		        }
		    ]
		};
	    myChart.setOption(option);
    }
	
}