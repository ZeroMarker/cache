function initChart(data){
		
		var rows=data.rows;
		var titleStr=data.titleStr;
		
	    // 基于准备好的dom，初始化echarts实例
        var myChart = echarts.init(document.getElementById('barDiv'));
		var xAxisData=[];
		var series=[];
		var legend=[];
		
		var titleArr=titleStr.split("^")
		for(var i=0;i<titleArr.length;i++){
			legend.push(titleArr[i]);
			var serieData=[];
			var serie = {};
			
			$.each(rows,function(index,itm){
				var trArr=itm.value.split("^");
				//console.warn(itm.value)
				serieData.push(Number(trArr[i+1]))
				
			})
			serie.name=titleArr[i];
			serie.type="bar";
			serie.data=serieData
			series.push(serie)
		}
		$.each(rows,function(index,itm){
			var trArr=itm.value.split("^")
			xAxisData.push(trArr[0])
			
		})
		//console.log(legend)
		//console.log(series)
		var colors = ['#60C0DD','#C6E579','#F4E001','#F0805A','#26C0C0'];		
        // 指定图表的配置项和数据
        var option = {
	        color: colors,
            tooltip: {},
		    toolbox: {
		        show : true,
		        feature : {
		            mark : {show: true},
		            dataView : {show: true, readOnly: false},
		            magicType : {show: true, type: ['line', 'bar']},
		            restore : {show: true},
		            saveAsImage : {show: true}
		        }
		    },
            legend: {
                data:legend
            },
            xAxis: {
	            type : 'category',
                data: xAxisData
            },
            yAxis: {
            	type : 'value'   
	        },
            series: series
        };

        // 使用刚指定的配置项和数据显示图表。
        myChart.setOption(option);
}

function initPie(data){

		
		var rows=data.rows;
		var titleStr=data.titleStr;
		
		var timelineData=[];
		var legend=[]
		var options=[];
				
		var titleArr=titleStr.split("^")
		for(var i=0;i<titleArr.length;i++){
			legend.push(titleArr[i]);
		}
		$.each(rows,function(index,itm){
			var trArr=itm.value.split("^")
			var seriesData=[];
			for(var i=0;i<trArr.length;i++){
				if(i>0){
					data={};
					data.value=Number(trArr[i]);
					data.name=titleArr[i-1];
					seriesData.push(data);
				}
			}
			timelineData.push(trArr[0])
			var subOption={}
			subOption.color=['#60C0DD','#C6E579','#F4E001','#F0805A','#26C0C0'];
			subOption.tooltip={
		                trigger: 'item',
		                formatter: "{a} <br/>{b} : {c} ({d}%)"
		            }
		    subOption.legend={data:legend}
		    subOption.series =[
		                {
		                    type:'pie',
		                    center: ['50%', '45%'],
		                    radius: '50%',
		                    data:seriesData
		                }
		            ]
		    options.push(subOption)  
		})
		
		
		var option = {
		    timeline : {
		        data : timelineData
		    },
		    options : options
		};

		console.dir(option)	
		var pieChart = echarts.init(document.getElementById('pieDiv'));
        // 使用刚指定的配置项和数据显示图表。
        pieChart.setOption(option);                
}

function initLine(data){
		
		var rows=data.rows;
		var titleStr=data.titleStr;
		
		var xAxisData=[];
		var series=[];
		var legend=[];
		
		var titleArr=titleStr.split("^")
		for(var i=0;i<titleArr.length;i++){
			xAxisData.push(titleArr[i]);

		}
		$.each(rows,function(index,itm){
			var trArr=itm.value.split("^")

			var serieData=[];
			var serie = {};
			
			for(var i=0;i<trArr.length;i++){
				serieData.push(Number(trArr[i+1]))
			}
			legend.push(trArr[0]);
			serie.name=trArr[0];
			serie.type="line";
			serie.data=serieData
			serie.markPoint={
		                data : [
		                    {type : 'max', name: '最大值'},
		                    {type : 'min', name: '最小值'}
		                ]
		            },
		     serie.markLine ={
		                data : [
		                    {type : 'average', name: '平均值'}
		                ]
		            }
			series.push(serie)
			
		})
		console.log(legend)
		option = {
			color: ['#60C0DD','#C6E579','#F4E001','#F0805A','#26C0C0'],
		    tooltip : {
		        trigger: 'axis'
		    },
		    toolbox: {
		        show : true,
		        feature : {
		            mark : {show: true},
		            dataView : {show: true, readOnly: false},
		            magicType : {show: true, type: ['line', 'bar']},
		            restore : {show: true},
		            saveAsImage : {show: true}
		        }
		    },
		    legend: {
		        data:legend
		    },
		    calculable : true,
		    xAxis : [
		        {
		            type : 'category',
		            boundaryGap : false,
		            data : xAxisData
		        }
		    ],
		    yAxis : [
		        {
		            type : 'value'
		        }
		    ],
		    series :series
		};
		var lineDiv = echarts.init(document.getElementById('lineDiv'));
        lineDiv.setOption(option); 
}