function InitS380HandHyComWinEvent(obj){
   	obj.LoadEvent = function(args){
		
		$('#ReportFrame').css('display', 'block');
		setTimeout(function(){
			obj.LoadRep();
		},50);

		//图的点击事件
		$('#btnSearchChart').on('click',function(e,value){
			$('#EchartDiv').css('display', 'block');
			$('#ReportFrame').css('display', 'none');
			obj.myChart = echarts.init(document.getElementById('EchartDiv'),'theme');
			obj.ShowEChaert1();
		});
		
		//表的点击事件
		$('#btnSearchTable').on('click',function(e,value){
			$('#ReportFrame').css('display', 'block');
			$('#EchartDiv').css('display', 'none');
			obj.LoadRep();
		});
   	}
   	obj.LoadRep = function(){
		var aHospID 	= $('#cboHospital').combobox('getValue');
		var aDateFrom 	= $('#dtDateFrom').datebox('getValue');
		var aDateTo		= $('#dtDateTo').datebox('getValue');
		var aMethod		= $('#cboMethod').datebox('getValue');
		var aObsType    = $('#cboObsType').datebox('getValue');
		if(aDateFrom > aDateTo){
			$.messager.alert("提示","开始日期应小于或等于结束日期！", 'info');
			return;
		}
		if ((aDateFrom=="")||(aDateTo=="")){
			$.messager.alert("提示","请选择开始日期、结束日期！", 'info');
			return;
		}
		ReportFrame = document.getElementById("ReportFrame");
		p_URL 		= 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S380HandHyCom.raq&aHospIDs='+aHospID +'&aDateFrom=' + aDateFrom +'&aDateTo='+ aDateTo +'&aMethod='+ aMethod+'&aObsType='+aObsType;	
		if(!ReportFrame.src){
			ReportFrame.frameElement.src=p_URL;
		}else{
			ReportFrame.src = p_URL;
		}
		
	}
	obj.up=function(x,y){
        return x.CorrectCount-y.CorrectCount
    }
	obj.option1 = function(arrViewLoc,arrCorrectCount,arrCorrectRatio,arrCompRatio,endnumber){
		var option1 = {
			title : {
				text: '手卫生依从性、正确性统计图',
				textStyle:{
					fontSize:28
				},
				x:'center',
				y:'top'
			},
			tooltip: {
				trigger: 'axis',
			},
			grid:{
				left:'5%',
				top:'11%',	
				right:'5%',
				bottom:'5%',
				containLabel:true
			},
			toolbox: {
				feature: {
					dataView: {show: false, readOnly: false},
					magicType: {show: true, type: ['line', 'bar']},
					restore: {show: true},
					saveAsImage: {show: true}
				}
			},
			legend: {
				data:['洗手正确人数','正确率','依从率'],
				x: 'center',
				y: 30
			},
			 dataZoom: [{
				show: true,
				realtime: true,
				start: 0,
				end: endnumber,
				zoomLock:true
			}],
			xAxis: [
				{
					type: 'category',
					data: arrViewLoc,
					axisLabel: {
						margin:8,
						rotate:45,
						interval:0,
						// 使用函数模板，函数参数分别为刻度数值（类目），刻度的索引
						formatter: function (value, index) {
							//处理标签，过长折行和省略
							if(value.length>6 && value.length<11){
								return value.substr(0,5)+'\n'+value.substr(5,5);
							}else if(value.length>10&&value.length<16){
								return value.substr(0,5)+'\n'+value.substr(5,5)+'\n'+value.substr(10,5);
							}else if(value.length>15&&value.length<21){
								return value.substr(0,5)+'\n'+value.substr(5,5)+'\n'+value.substr(10,5)+'\n'+value.substr(15,5);
							}else{
								return value;
							}
						}
					}
				}
			],
			yAxis: [
				{
					type: 'value',
					name: '洗手正确人数',
					min: 0,
					interval:Math.ceil(arrCorrectCount[0]/10),
					axisLabel: {
						formatter: '{value} '
					}
				},
				{
					type: 'value',
					name: '正确率(%)',
					min: 0,
					interval:10,
					axisLabel: {
						formatter: '{value} %'
					}
				}
			],
			series: [
				 {
					name:'洗手正确人数',
					type:'bar',
					barMaxWidth:50,
					data:arrCorrectCount
				},
				{
					name:'正确率',
					type:'line',
					yAxisIndex: 1,
					data:arrCorrectRatio,
					label: {
						show:true,
						formatter:"{c}%"
					}
				},
				{
					name:'依从率',
					type:'line',
					yAxisIndex: 1,
					data:arrCompRatio,
					label: {
						show:true,
						formatter:"{c}%"
					}
				}  
			]
		};
		return option1;
	}
	
    obj.echartLocInfRatio = function(runQuery){
		if (!runQuery) return;
		var arrViewLoc 			= new Array();
		var arrCorrectCount 	= new Array();		//洗手正确数
		var arrCorrectRatio 	= new Array();		//正确率
		var arrCompRatio		= new Array();
		arrRecord 		= runQuery.rows;
		
		var arrlength		= 0;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			//去掉全院、医院、科室组
			if (rd["DimensKey"].indexOf('全院')>-1) {
				delete arrRecord[indRd];
				arrlength = arrlength + 1;
				continue;
			}
			rd["DimensDesc"]	= $.trim(rd["DimensDesc"]); //去掉空格
			rd["CorrectRatio"]	= parseFloat(rd["CorrectRatio"].replace('%','').replace('‰','')).toFixed(2);
			rd["CompRatio"]	= parseFloat(rd["CompRatio"].replace('%','').replace('‰','')).toFixed(2);
		}
		
		arrRecord = arrRecord.sort(obj.up);
		arrRecord.length = arrRecord.length - arrlength;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			
			arrViewLoc.push(rd["DimensDesc"]);
			arrCorrectCount.push(rd["CorrectCount"]);
			arrCorrectRatio.push(parseFloat(rd["CorrectRatio"]).toFixed(2));
			arrCompRatio.push(parseFloat(rd["CompRatio"]).toFixed(2));
		}
		var endnumber = (14/arrViewLoc.length)*100;
	
		// 使用刚指定的配置项和数据显示图表。
		obj.myChart.setOption(obj.option1(arrViewLoc,arrCorrectCount,arrCorrectRatio,arrCompRatio,endnumber),true);
	}
   	obj.ShowEChaert1 = function(){
		obj.myChart.clear()
		 //当月科室感染率图表
		var aHospID = $('#cboHospital').combobox('getValue');
		var aDateFrom = $('#dtDateFrom').datebox('getValue');
		var aDateTo= $('#dtDateTo').datebox('getValue');
		var aMethod = $('#cboMethod').datebox('getValue');
		var aObsType = $('#cboObsType').datebox('getValue');
		
		obj.myChart.showLoading();	//隐藏加载动画
		$cm({
			ClassName:"DHCHAI.STATV2.S380HandHyCom",
			QueryName:"QryHandHyRegSta",
			aHospIDs:aHospID, 
			aDateFrom:aDateFrom, 
			aDateTo:aDateTo, 
			aMethod:aMethod, 
			aObsType:aObsType, 
			page: 1,
			rows: 999
		},function(rs){
			obj.myChart.hideLoading();    //隐藏加载动画
			obj.echartLocInfRatio(rs);
		});
	}
	
}