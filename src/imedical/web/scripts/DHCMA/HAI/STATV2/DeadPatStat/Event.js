function InitDeadPatStatWinEvent(obj){	 
   	obj.LoadEvent = function(args){
			
		$('#ReportFrame').css('display', 'block');
		setTimeout(function(){
			obj.ShowReport();
		},50);

		//图的点击事件
		$('#btnSearchChart').on('click',function(e,value){
			$('#EchartDiv').css('display', 'block');
			$('#ReportFrame').css('display', 'none');
			obj.myChart = echarts.init(document.getElementById('EchartDiv'),'theme');
			obj.ShowEChaert();
		});
		
		//表的点击事件
		$('#btnSearchTable').on('click',function(e,value){
			$('#ReportFrame').css('display', 'block');
			$('#EchartDiv').css('display', 'none');
			obj.ShowReport();
		});
   	}
	
	
   	obj.ShowReport = function() {
		var aHospID 	= $('#cboHospital').combobox('getValues').join('|');
		var aDateFrom 	= $('#dtDateFrom').datebox('getValue');
		var aDateTo		= $('#dtDateTo').datebox('getValue');
		var aLocType 	= Common_CheckboxValue('chkStatunit');
		var aQryCon 	= $('#cboQryCon').combobox('getValue');
		var aStatDimens = $('#cboShowType').combobox('getValue');
		var aLocIDs 	= $('#cboLoc').combobox('getValues').join(',');	
		ReportFrame = document.getElementById("ReportFrame");
		if(aDateFrom > aDateTo){
			$.messager.alert("提示","开始日期应小于或等于结束日期！", 'info');
			return;
		}
		if ((aDateFrom=="")||(aDateTo=="")){
			$.messager.alert("提示","请选择开始日期、结束日期！", 'info');
			return;
		}
		if ((aStatDimens=="")){
			$.messager.alert("提示","请选择展示维度！", 'info');
			return;
		}	
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCHAI.STATV2.DeadPatStat.raq&aHospIDs='+aHospID +'&aDateFrom='+ aDateFrom+'&aDateTo='+aDateTo +'&aLocType='+aLocType+'&aQryCon='+aQryCon+'&aStatDimens='+aStatDimens+'&aLocIDs='+aLocIDs+'&aPath='+cspPath;			
		if(!ReportFrame.src){
			ReportFrame.frameElement.src=p_URL;
		}else{
			ReportFrame.src = p_URL;
		} 
	}
	
	obj.up=function(x,y){
		return y.PatDeathCnt-x.PatDeathCnt
    }
	obj.option1 = function(arrViewLoc,arrPatDeathCnt,arrDeathInfCnt,arrDeathRatio,arrDeathInfRatio,endnumber){
		var option1 = {
			title : {
				text: '住院死亡患者医院感染情况统计图',
				textStyle:{
					fontSize:28
				},
				x:'center',
				y:'top'
			},
			grid:{
				left:'5%',
				top:'13%',	
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
				data:['死亡人数','感染死亡人数','死亡率','感染死亡率'],
				x: 'center',
				y: 30
			},
			 dataZoom: [{
				show: true,
				realtime: true,
				start: 0,
				zoomLock:true,
				end: endnumber
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
					name: '死亡人数',
					min: 0,
					interval:Math.ceil(arrPatDeathCnt[0]/10),
					axisLabel: {
						formatter: '{value} '
					}
				},
				{
					type: 'value',
					name: '死亡率(%)',
					min: 0,
					interval:10,
					axisLabel: {
						formatter: '{value} %'
					}
				}
			],
			series: [
				{
					name:'死亡人数',
					type:'bar',
					barMaxWidth:50,
					data:arrPatDeathCnt
				},
				 {
					name:'感染死亡人数',
					type:'bar',
					barMaxWidth:50,
					data:arrDeathInfCnt
				},
				{
					name:'死亡率',
					type:'line',
					yAxisIndex: 1,
					data:arrDeathRatio,
					label: {
						show:true,
						formatter:"{c}%"
					}
				},
				{
					name:'感染死亡率',
					type:'line',
					yAxisIndex: 1,
					data:arrDeathInfRatio,
					label: {
						show:true,
						formatter:"{c}%"
					}
				}
			]
		};
		return option1;
	}
	
	
   	obj.ShowEChaert = function(){
		obj.myChart.clear()
		 //送检率图表
		
		var aHospID 	= $('#cboHospital').combobox('getValues').join('|');
		var aDateFrom 	= $('#dtDateFrom').datebox('getValue');
		var aDateTo		= $('#dtDateTo').datebox('getValue');
		var aLocType 	= Common_CheckboxValue('chkStatunit');
		var aQryCon		= $('#cboQryCon').combobox('getValue');
		var aStatDimens = $('#cboShowType').combobox('getValue');
		var aLocIDs 	= $('#cboLoc').combobox('getValues').join(',');	
		
		obj.myChart.showLoading();
		$cm({
			ClassName:'DHCHAI.STATV2.DeadPatStat',
			QueryName:'QryDeathInf',
			aHospIDs:aHospID,
			aDateFrom:aDateFrom,
			aDateTo:aDateTo,
			aLocType:aLocType,
			aQryCon:aQryCon,
			aStatDimens:aStatDimens,
			aLocIDs:aLocIDs,
			page:1,    //可选项，页码，默认1
			rows:999   //可选项，获取多少条数据，默认50
		},function(rs){
			obj.myChart.hideLoading();    //隐藏加载动画
			obj.echartLocInfRatio(rs);
		});
	}
	
	//死亡率、感染死亡率
	obj.echartRatio = function(runQuery){
		if (!runQuery) return;
		var arrViewLoc 		 = new Array();
		var arrPatDeathCnt   = new Array();		//死亡人数
		var arrDeathInfCnt   = new Array();		//感染死亡人数
		var arrDeathRatio 	 = new Array();
		var arrDeathInfRatio = new Array();
		arrRecord 		= runQuery.rows;
		
		var arrlength		= 0;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			//去掉全院、医院、科室组
			if ((rd["DimensKey"].indexOf('-A-')>-1)||(rd["DimensKey"].indexOf('-H-')>-1)||(rd["DimensKey"].indexOf('-G-')>-1)) {
				delete arrRecord[indRd];
				arrlength = arrlength + 1;
				continue;
			}
			rd["DimensDesc"] = $.trim(rd["DimensDesc"]); //去掉空格
			rd["DeathRatio"] = parseFloat(rd["DeathRatio"].replace('%','').replace('‰','')).toFixed(2);
		}
		
		arrRecord = arrRecord.sort(obj.up);
		arrRecord.length = arrRecord.length - arrlength;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			
			arrViewLoc.push(rd["DimensDesc"]);
			arrPatDeathCnt.push(rd["PatDeathCnt"]);
			arrDeathInfCnt.push(rd["DeathInfCnt"]);
			arrDeathRatio.push(parseFloat(rd["DeathRatio"]).toFixed(2));
			arrDeathInfRatio.push(parseFloat(rd["DeathInfRatio"]).toFixed(2));
			
		}
		var endnumber = (14/arrViewLoc.length)*100;
		// 使用刚指定的配置项和数据显示图表。
		obj.myChart.setOption(obj.option1(arrViewLoc,arrPatDeathCnt,arrDeathInfCnt,arrDeathRatio,arrDeathInfRatio,endnumber),true);
	}
	

	
}