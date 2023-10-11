function InitTemperatureWinEvent(obj){
    
    $HUI.combobox('#cboWeeks', {
        onSelect: function () {
            creatCharts();
        }
    });
    
	function creatCharts(){

        var week=$('#cboWeeks').combobox('getValue');
        var weekText=$('#cboWeeks').combobox('getText');
        var datefrom=week.split("-")[0];
        var dateto=week.split("-")[1];
        var DateFrom = parseInt(datefrom);
		var DateTo = parseInt(dateto);
        var isAllWeek = ((weekText=="全部")&&(DateTo-DateFrom)>12) ? true : false; //全部时并且大于两周时去掉x轴内容防止重叠
        if ((DateTo-DateFrom)<6){ 	//不足一周补足一周
			DateTo = DateFrom+6;
		}
        var runQuery = $cm({
            ClassName: "DHCHAI.DPS.MRObservationsSrv",
            QueryName: "QryObservations",
            aEpisodeID: PaadmID,
            aDateFrom:DateFrom,
            aDateTo:DateTo,
            page: 1,
            rows: 99999
            }, false);
        
		var myChart = echarts.init(document.getElementById('charts'));
		var xData = [];
		var yData = [];
		if (runQuery.total!=0){
			for (var i = 0;i<runQuery.rows.length;i++){
				if (runQuery.rows[i].TimeInd!='10'){
					xData.push(runQuery.rows[i].TimeInd);
				}else{
					xData.push(runQuery.rows[i].TimeInd+'\n\n'+runQuery.rows[i].EntryDate);
				}
				yData.push(runQuery.rows[i].ItemValue);
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
			       if (runQuery.rows[dataIndex].ItemValue==''){
				       	return '';
				   }else{
						return '日期：'+runQuery.rows[dataIndex].EntryDate + ' ' + runQuery.rows[dataIndex].EntryTime + '<br/>'
							+ runQuery.rows[dataIndex].ItemDesc + '：' + runQuery.rows[dataIndex].ItemValue + '°C';
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