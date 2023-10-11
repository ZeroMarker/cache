function InitBactTrendWinEvent(obj){
   	obj.LoadEvent = function(args){
		$('#ReportFrame').css('display', 'block');
		setTimeout(function(){
			obj.LoadRep(1);
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
	
   	obj.LoadRep = function(flag){
		var aHospID 	= $('#cboHospital').combobox('getValue');

		var aStatUnit = $('#cboUnit').combobox('getValue');
		var FromYear  = $('#cboYearFrom').combobox('getValue');
		var ToYear    = $('#cboYearTo').combobox('getValue');
		var FromMonth = $('#cboMonthFrom').combobox('getValue');
		var ToMonth   = $('#cboMonthTo').combobox('getValue');
		var aDateFrom ="",aDateTo=""
		if (aStatUnit=="1") {    //月
			aDateFrom = FromYear+"-"+(FromMonth<10?('0'+FromMonth):FromMonth);
			aDateTo = ToYear+"-"+(ToMonth<10?('0'+ToMonth):ToMonth);
		}else if (aStatUnit=="2") {    //季度
		    var fm =FromMonth.split("JD")[1];
		    var tm =ToMonth.split("JD")[1];
			aDateFrom = FromYear+"-"+((fm*3-2)<10?('0'+(fm*3-2)):(fm*3-2));
			aDateTo = ToYear+"-"+((tm*3)<10?('0'+(tm*3)):(tm*3));
		}else {
			aDateFrom = FromYear;
			aDateTo = ToYear;
		}	
		
		var SubLocArr   = $('#cboSubLoc').combobox('getValues');
		var aSubLocIDs  = SubLocArr.join();
		var aBacteriaDr = obj.BacteriaDr;
		var aDateType 	= $('#cboDateType').combobox('getValue');
		var aDrugLevel 	= $('#cboDrugLevel').combobox('getValue');
		ReportFrame = document.getElementById("ReportFrame");
		
		if ($('#cboInfType').combobox('getValue')==""){
			obj.TypeCode="";
		}
		if(aDateFrom > aDateTo){
			$.messager.alert("提示","开始日期应小于或等于结束日期！", 'info');
			return;
		}
		if ((aDateFrom=="")||(aDateTo=="")){
			$.messager.alert("提示","请选择开始日期、结束日期！", 'info');
			return;
		}
		if ((aStatUnit==3)&&((aDateTo-aDateFrom)>3)){ //按年统计不能超过3年
			$.messager.alert("提示","统计开始结束日期不能超过三年！", 'info');
			return;
		}
		if((aBacteriaDr=="")&&(flag!=1)){
			$.messager.alert("提示","请选择细菌！", 'info');
			return;
		}
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.BactTrend.raq&aHospIDs='+aHospID +'&aDateFrom=' + aDateFrom +'&aDateTo='+ aDateTo+'&aDateType='+aDateType+'&aLocID='+aSubLocIDs+'&aBactID='+aBacteriaDr+'&aBactDesc='+obj.BactDesc+'&aDrugLevel='+aDrugLevel+'&aStatUnit='+aStatUnit+'&aTypeCode='+obj.TypeCode+'&aPath='+cspPath;
		if(!ReportFrame.src){
			ReportFrame.frameElement.src=p_URL;
		}else{
			ReportFrame.src = p_URL;
		}
	}
	
	
	
	obj.up=function(x,y){
        return y.InfPatCnt-x.InfPatCnt
    }
    
	obj.option1 = function(arrViewLoc,arrInfPatCnt,arrInfPatRatio,endnumber){
		var option1 = {
			title : {
				text: '病原体耐药性趋势分析',
				textStyle:{
					fontSize:28
				},
				x:'center',
				y:'top'
			},
			grid:{
				left:'5%',
				top:'11%',	
				right:'5%',
				bottom:'5%',
				containLabel:true
			},
			tooltip: {
				trigger: 'axis',
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
				data:['耐药/敏感数','耐药/敏感率'],
				x: 'center',
				y: 30
			},
			 dataZoom: [{
				height: 40,
				show: true,
				realtime: true,
				start: 0,
				end: endnumber,
				bottom: 0,
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
					name: '耐药/敏感数',
					min: 0,
					interval:Math.ceil(arrInfPatCnt[0]/10),
					axisLabel: {
						formatter: '{value} '
					}
				},
				{
					type: 'value',
					name: '耐药/敏感率(%)',
					min: 0,
					interval:10,
					axisLabel: {
						formatter: '{value} %'
					}
				}
			],
			series: [
				 {
					name:'耐药/敏感数',
					type:'bar',
					barMaxWidth:50,
					data:arrInfPatCnt
				},
				{
					name:'耐药/敏感率',
					type:'line',
					yAxisIndex: 1,
					data:arrInfPatRatio,
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
		var arrStatName  = new Array;
		var arrStatRatio = new Array;
		var arrStatSum = new Array;
		arrRecord = runQuery.record;
		
		var arrlength = 0;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			rd["StatRatio"] = parseFloat(rd["StatRatio"].replace('%','').replace('‰','')).toFixed(2);
		}
		
		arrRecord = arrRecord.sort(obj.up);
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			arrStatName.push(rd["StatName"]);
			arrStatSum.push(rd["StatSum"]);
			arrStatRatio.push(parseFloat(rd["StatRatio"]).toFixed(2));
		}
		var endnumber = (14/arrStatName.length)*100;
		
		// 使用刚指定的配置项和数据显示图表
		obj.myChart.setOption(obj.option1(arrStatName,arrStatSum,arrStatRatio,endnumber),true);
	}
   	obj.ShowEChaert1 = function(){
		obj.myChart.clear();
		//耐药率趋势分析图表
		var aHospID 	= $('#cboHospital').combobox('getValue');
		var aDateFrom 	= $('#dtDateFrom').datebox('getValue');
		var aDateTo		= $('#dtDateTo').datebox('getValue');
		var aStatUnit 	= $('#cboUnit').combobox('getValue');
		var SubLocArr   = $('#cboSubLoc').combobox('getValues');
		var aSubLocIDs  = SubLocArr.join();
		var aBacteriaDr = obj.BacteriaDr;
		var aDateType 	= $('#cboDateType').combobox('getValue');
		var aDrugLevel 	= $('#cboDrugLevel').combobox('getValue');
		
		var dataInput = "ClassName=" + 'DHCHAI.STATV2.BactTrend' + "&QueryName=" + 'QryMRBRstTrend' + "&Arg1=" + aHospID + "&Arg2=" + aDateType + "&Arg3=" + aDateFrom +"&Arg4="+aDateTo+"&Arg5="+aSubLocIDs+"&Arg6="+aBacteriaDr+"&Arg7="+aDrugLevel+"&Arg8="+aStatUnit+"&ArgCnt=" + 8;

		$.ajax({
			url: "./dhchai.query.csp",
			type: "post",
			timeout: 30000, //30秒超时
			async: true,   //异步
			beforeSend:function(){
				obj.myChart.showLoading();	
			},
			data: dataInput,
			success: function(data, textStatus){
				obj.myChart.hideLoading();    //隐藏加载动画
				var retval = (new Function("return " + data))();
				obj.echartLocInfRatio(retval);
			},
			error: function(XMLHttpRequest, textStatus, errorThrown){
				var tkclass="DHCHAI.STATV2.BactTrend";
				var tkQuery="QryMRBRstTrend";
				alert("类" + tkclass + ":" + tkQuery + "执行错误,Status:" + textStatus + ",Error:" + errorThrown);
				obj.myChart.hideLoading();    //隐藏加载动画
			}
		});
	}
	
}