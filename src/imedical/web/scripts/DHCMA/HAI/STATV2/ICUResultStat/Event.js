function InitICUStatWinEvent(obj){
	obj.numbers = "ALL";
   	obj.LoadEvent = function(args){
		$('#ReportFrame').css('display', 'block');
   	    setTimeout(function () {
   	        obj.LoadRep();
   	    }, 50);

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
		var aHospID 	= $('#cboHospital').combobox('getValues').join('|');
		var aDateFrom 	= $('#dtDateFrom').datebox('getValue');
		var aDateTo		= $('#dtDateTo').datebox('getValue');
		var aLocType 	= "W";   //Common_CheckboxValue('chkStatunit');
		var aQryCon 	= $('#cboQryCon').combobox('getValue');
		var aLocIDs 	= $('#cboLoc').combobox('getValues').join(',');	
		
		var IsSplit = $m({
			ClassName: "DHCHAI.BT.Config",
			MethodName: "GetValByCode",
			aCode: "ICUPatLogSplit"
		},false);
		ReportFrame = document.getElementById("ReportFrame");
		if(aDateFrom > aDateTo){
			$.messager.alert("提示","开始日期应小于或等于结束日期！", 'info');
			return;
		}
		if ((aDateFrom=="")||(aDateTo=="")){
			$.messager.alert("提示","请选择开始日期、结束日期！", 'info');
			return;
		}
		
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.ICUResultStat.raq&aHospIDs='+aHospID +'&aDateFrom=' + aDateFrom +'&aDateTo='+ aDateTo+'&aLocType='+aLocType+'&aQryCon='+aQryCon+'&aLocIDs='+aLocIDs+'&aIsSplit='+IsSplit+'&aPath='+cspPath;	
		if(!ReportFrame.src){
			ReportFrame.frameElement.src=p_URL;
		}else{
			ReportFrame.src = p_URL;
		}	
	}
	
	obj.up=function(x,y){
        return y.VAPRatio-x.VAPRatio
        if(obj.sortName==$g("呼吸机使用率")){
			return y.VAPRatio-x.VAPRatio;
		}else if(obj.sortName==$g("导尿管使用率")){
			return y.UCRatio-x.UCRatio;
		}else if(obj.sortName==$g("导尿管感染发病率")){
			return y.UCINFRatio-x.UCINFRatio;
		}else if(obj.sortName==$g("中央血管导管使用率")){
			return y.PICCRatio-x.PICCRatio;
		}else if(obj.sortName==$g("中央血管导管感染发病率")){
			return y.PICCINFRatio-x.PICCINFRatio;
		}else{
			return y.VAPINFRatio-x.VAPINFRatio;
		} 
    }
	obj.option1 = function(arrViewLoc,arrVAPRatio,arrVAPINFRatio,arrUCRatio,arrUCINFRatio,arrPICCRatio,arrPICCINFRatio,endnumber){
		
		var option1 = {
			title : {
				text: $g('三管汇总统计图'),
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
				data:[$g('呼吸机使用率'),$g('呼吸机感染发病率'),$g('导尿管使用率'),$g('导尿管感染发病率'),$g('中央血管导管使用率'),$g('中央血管导管感染发病率')],
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
					name: $g('使用率(%)'),
					min: 0,
					interval:10,
					axisLabel: {
						formatter: '{value}% '
					}
				},
				{
					type: 'value',
					name: $g('感染发病率(‰)'),
					min: 0,
					interval:10,
					axisLabel: {
						formatter: '{value} ‰'
					}
				}
			],
			series: [
				 {
					name:$g('呼吸机使用率'),
					type:'line',
					yAxisIndex: 1,
					data:arrVAPRatio
				},
				{
					name:$g('呼吸机感染发病率'),
					type:'line',
					yAxisIndex: 1,
					data:arrVAPINFRatio,
					label: {
						show:true,
						formatter:"{c}‰"
					}
				},	
				{
					name:$g('导尿管使用率'),
					type:'line',
					yAxisIndex: 1,
					data:arrUCRatio
				},
				{
					name:$g('导尿管感染发病率'),
					type:'line',
					yAxisIndex: 1,
					data:arrUCINFRatio,
					label: {
						show:true,
						formatter:"{c}‰"
					}
				}, 
				{
					name:$g('中央血管导管使用率'),
					type:'line',
					yAxisIndex: 1,
					data:arrPICCRatio
				},
				{
					name:$g('中央血管导管感染发病率'),
					type:'line',
					yAxisIndex: 1,
					data:arrPICCINFRatio,
					label: {
						show:true,
						formatter:"{c}‰"
					}
				}
			]
		};
		return option1;
	}
	
    obj.echartTubeInfRatio = function(runQuery){
		if (!runQuery) return;
	  
		var arrViewLoc 	   = new Array();
		var arrVAPRatio    = new Array();    //使用率
		var arrVAPINFRatio = new Array();    //感染发病率	
		var arrUCRatio     = new Array();    //使用率
		var arrUCINFRatio  = new Array();    //感染发病率
		var arrPICCRatio   = new Array();    //使用率
		var arrPICCINFRatio= new Array();    //感染发病率
		
		arrRecord 		= runQuery.rows;	
		var arrlength		= 0;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			//科室合计
			if (!rd["DimensKey"]) {
				delete arrRecord[indRd];
				arrlength = arrlength + 1;
				continue;
			}
			rd["DimensDesc"] = $.trim(rd["DimensDesc"]); //去掉空格		
			rd["VAPRatio"] = parseFloat(rd["VAPRatio"].replace('%','').replace('‰','')).toFixed(2);
			rd["VAPINFRatio"] = parseFloat(rd["VAPINFRatio"].replace('%','').replace('‰','')).toFixed(2);
			rd["UCRatio"] = parseFloat(rd["UCRatio"].replace('%','').replace('‰','')).toFixed(2);
			rd["UCINFRatio"] = parseFloat(rd["UCINFRatio"].replace('%','').replace('‰','')).toFixed(2);
			rd["PICCRatio"] = parseFloat(rd["PICCRatio"].replace('%','').replace('‰','')).toFixed(2);
			rd["PICCINFRatio"] = parseFloat(rd["PICCINFRatio"].replace('%','').replace('‰','')).toFixed(2);
		}
		
		arrRecord = arrRecord.sort(obj.up);
		arrRecord.length = arrRecord.length - arrlength;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			
			arrViewLoc.push(rd["DimensDesc"]);
			arrVAPRatio.push(parseFloat(rd["VAPRatio"]).toFixed(2));
			arrVAPINFRatio.push(parseFloat(rd["VAPINFRatio"]).toFixed(2));
			arrUCRatio.push(parseFloat(rd["UCRatio"]).toFixed(2));
			arrUCINFRatio.push(parseFloat(rd["UCINFRatio"]).toFixed(2));
			arrPICCRatio.push(parseFloat(rd["PICCRatio"]).toFixed(2));
			arrPICCINFRatio.push(parseFloat(rd["PICCINFRatio"]).toFixed(2));
		}
		var endnumber = (14/arrViewLoc.length)*100;
		// 使用刚指定的配置项和数据显示图表。
		obj.myChart.setOption(obj.option1(arrViewLoc,arrVAPRatio,arrVAPINFRatio,arrUCRatio,arrUCINFRatio,arrPICCRatio,arrPICCINFRatio,endnumber),true);
	}
   	obj.ShowEChaert1 = function(){
		obj.myChart.clear()
	
		var aHospID 	= $('#cboHospital').combobox('getValues').join('|');
		var aDateFrom 	= $('#dtDateFrom').datebox('getValue');
		var aDateTo		= $('#dtDateTo').datebox('getValue');
		var aLocType 	= "W";     //Common_CheckboxValue('chkStatunit');
		var aQrycon 	= $('#cboQryCon').combobox('getValue');
		var aLocIDs 	= $('#cboLoc').combobox('getValues').join(',');	
		
		obj.myChart.showLoading();	//隐藏加载动画
		$cm({
			ClassName:"DHCHAI.STATV2.ICUResultStat",
			QueryName:"QryTubeInfo",
			aHospIDs:aHospID, 
			aDateFrom:aDateFrom, 
			aDateTo:aDateTo, 
			aLocType:aLocType, 
			aQryCon:aQrycon, 
			aLocIDs:aLocIDs,
			page:1,
			rows:999
		},function(rs){
			obj.myChart.hideLoading();    //隐藏加载动画
			obj.echartTubeInfRatio(rs);
						
			obj.sortName=$g("呼吸机感染发病率"); //初始化排序指标
			obj.myChart.off('legendselectchanged'); //取消事件，避免事件绑定重复导致多次触发
			obj.myChart.on('legendselectchanged', function(legObj){
				//处理排序问题 
				//如果是重复点击认为是需要执行隐藏处理,不想隐藏就不用判断了	
				if(obj.sortName!=legObj.name){
					obj.sortName=legObj.name;
					obj.echartLocInfRatio(rs);
				}else {
					obj.sortName="";  //初始化
				}
			});
		});
	}
}

