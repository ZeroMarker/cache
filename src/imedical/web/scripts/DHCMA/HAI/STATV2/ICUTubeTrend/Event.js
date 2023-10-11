function InitWinEvent(obj){
	obj.myChart = echarts.init(document.getElementById('EchartDiv'),'theme');
	
   	obj.LoadEvent = function(args){
		$('#ReportFrame').css('display', 'block');
		setTimeout(function(){
			obj.LoadRep(1);
		},50);
	
		//表的点击事件
		$('#btnSearchTable').on('click',function(e,value){
			$('#ReportFrame').css('display', 'block');
			$('#EchartDiv').css('display', 'none');
			obj.LoadRep();
		});
		$('#btnSearchChart').on('click',function(e,value){
			$('#EchartDiv').css('display', 'block');
			$('#ReportFrame').css('display', 'none');
			
			obj.ShowEChaert();
		});
   	}
	
   	obj.LoadRep = function(flag){
		var aHospID   = $('#cboHospital').combobox('getValues').join('|');
		var aLocType  = Common_CheckboxValue('chkStatunit');
		var SubLocArr = $('#cboLoc').combobox('getValues');
		var aLocIDs   = SubLocArr.join();
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
		var aTubeType = $('#cboTubeType').combobox('getValue');
		var aQrycon = $('#cboQryCon').combobox('getValue');
		ReportFrame = document.getElementById("ReportFrame");
		
		if(aDateFrom > aDateTo){
			$.messager.alert("提示","开始日期应小于或等于结束日期！", 'info');
			return;
		}
		if ((aDateFrom=="")||(aDateTo=="")){
			$.messager.alert("提示","请选择开始日期、结束日期！", 'info');
			return;
		}
		if (aStatUnit==3){ //按年统计不能超过3年
			if((aDateTo-aDateFrom)>3){
				$.messager.alert("提示","统计开始结束日期不能超过三年！", 'info');
				return;
			}
		}else{
			var FromYear=aDateTo.split("-")[0]
			var ToYear=aDateFrom.split("-")[0]
			if ((FromYear-ToYear)>1){
				$.messager.alert("提示","（单位为季或者月时）开始结束日期不得超过一年！", 'info');
				return;
			}
		}
	
		p_URL = "dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.ICUTubeTrend.raq&aHospIDs="+aHospID+
			"&aLocType="+ aLocType+
			"&aLocIDs="+aLocIDs +
			"&aStatUnit="+aStatUnit+
			"&aDateFrom="+aDateFrom+
			"&aDateTo="+ aDateTo+
			"&aTubeType="+ aTubeType+
			"&aQryCon="+ aQrycon+
			"&aFlag="+obj.Flag+
			"&aPath="+cspPath
		if(!ReportFrame.src){
			ReportFrame.frameElement.src=p_URL;
		}else{
			ReportFrame.src = p_URL;
		}
	}
	
	obj.ShowEChaert = function(){
		var aHospID   = $('#cboHospital').combobox('getValues').join('|');
		var LocType=Common_CheckboxValue('chkStatunit');
		var SubLocArr = $('#cboLoc').combobox('getValues');
		var aLocIDs   = SubLocArr.join();
		var aStatUnit = $('#cboUnit').combobox('getValue');
		var FromYear  = $('#cboYearFrom').combobox('getValue');
		var ToYear    = $('#cboYearTo').combobox('getValue');
		var FromMonth = $('#cboMonthFrom').combobox('getValue');
		var ToMonth   = $('#cboMonthTo').combobox('getValue');
		var aDateFrom ="",aDateTo="";
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
		var aTubeType = $('#cboTubeType').combobox('getValue');
		var aQrycon = $('#cboQryCon').combobox('getValue');
		var TubeTypeDesc=$("#cboTubeType").combobox("getText");
		if(aDateFrom > aDateTo){
			$.messager.alert("提示","开始日期应小于或等于结束日期！", 'info');
			return;
		}
		if ((aDateFrom=="")||(aDateTo=="")){
			$.messager.alert("提示","请选择开始日期、结束日期！", 'info');
			return;
		}
		var timeStat=5    //插管感染人/例次数
		var infStat=0.05
		if (aStatUnit==3){ //按年统计不能超过3年
			if((aDateTo-aDateFrom)>3){
				$.messager.alert("提示","（单位为年时）统计开始结束日期不能超过三年！", 'info');
				return;
			}
			timeStat=20;
		}else{
			var FromYear=aDateTo.split("-")[0];
			var ToYear=aDateFrom.split("-")[0];
			if ((FromYear-ToYear)>1){        //粗略判定 年份差<=2即可
				$.messager.alert("提示","（单位为季或者月时）开始结束日期不得超过一年！", 'info');
				return;
			}
			if (aStatUnit==2){
				timeStat=10;
			}
		}
		var Value=$cm({
			ClassName:'DHCHAI.STATV2.ICUTubeTrend',
			QueryName:'QryTubeTrendInfo',
			aHospIDs:aHospID,
			aLocType:LocType,
			aLocIDs:aLocIDs ,
			aStatUnit:aStatUnit,
			aDateFrom:aDateFrom,
			aDateTo:aDateTo,
			aTubeType: aTubeType,
			aQryCon:aQrycon,
			aFlag:obj.Flag
		},false)
		var Data=Value.rows;
		var arrTimeDimens   = new Array(); 

		var arrVAPRatio    = new Array();    //使用率
		var arrVAPINFRatio = new Array();    //感染发病率	
		var arrUCRatio     = new Array();    //使用率
		var arrUCINFRatio  = new Array();    //感染发病率
		var arrPICCRatio   = new Array();    //使用率
		var arrPICCINFRatio= new Array();    //感染发病率
				
		for (var i=0;i<Data.length;i++){
			arrTimeDimens.push(Data[i].TimeDimens);

			arrVAPRatio.push(parseFloat(Data[i].VAPRatio).toFixed(2));
			arrVAPINFRatio.push(parseFloat(Data[i].VAPINFRatio).toFixed(2));
			arrPICCRatio.push(parseFloat(Data[i].PICCRatio).toFixed(2));
			arrPICCINFRatio.push(parseFloat(Data[i].PICCINFRatio).toFixed(2));
			arrUCRatio.push(parseFloat(Data[i].UCRatio).toFixed(2));
			arrUCINFRatio.push(parseFloat(Data[i].UCINFRatio).toFixed(2));
			if (Data[i].VAPRatio>infStat*5){
				infStat=parseFloat((Data[i].VAPRatio)/5).toFixed(2)
			}
		}
		var aType="出院";
		if (obj.Flag!="O"){
			aType="住院";
		}
		
		option = {
			title : {
			        text: aType+'患者插管相关感染趋势分析',
			        textStyle:{
						fontSize:28
					},
			        x:'center'
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
				data:['呼吸机使用率','呼吸机感染发病率','导尿管使用率','导尿管感染发病率','中央血管导管使用率','中央血管导管感染发病率'],
				//selected:noLegend,
				x: 'center',
				y: 30
			},
			xAxis: [
				{
					type: 'category',
					data: arrTimeDimens,					//['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'],
					axisPointer: {
						type: 'shadow'
					}
				}
			],
			yAxis: [
				{
					type: 'value',
					name: '使用率(%)',
					min: 0,
					interval:10,
					axisLabel: {
						formatter: '{value}% '
					}
				},
				{
					type: 'value',
					name: '感染发病率(‰)',
					min: 0,
					interval:10,
					axisLabel: {
						formatter: '{value} ‰'
					}
				}
			],
			series: [
				 {
					name:'呼吸机使用率',
					type:'line',
					yAxisIndex: 1,
					data:arrVAPRatio
				},
				{
					name:'呼吸机感染发病率',
					type:'line',
					yAxisIndex: 1,
					data:arrVAPINFRatio,
					label: {
						show:true,
						formatter:"{c}‰"
					}
				},	
				{
					name:'导尿管使用率',
					type:'line',
					yAxisIndex: 1,
					data:arrUCRatio
				},
				{
					name:'导尿管感染发病率',
					type:'line',
					yAxisIndex: 1,
					data:arrUCINFRatio,
					label: {
						show:true,
						formatter:"{c}‰"
					}
				}, 
				{
					name:'中央血管导管使用率',
					type:'line',
					yAxisIndex: 1,
					data:arrPICCRatio
				},
				{
					name:'中央血管导管感染发病率',
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
		obj.myChart.setOption(option);
	}
}