function InitS170AntTheSubWinEvent(obj){	 
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
		var aHospID = $('#cboHospital').combobox('getValues').join('|');
		var aDateFrom = $('#dtDateFrom').datebox('getValue');
		var aDateTo= $('#dtDateTo').datebox('getValue');
		var aLocType = Common_CheckboxValue('chkStatunit');
		var aQryCon 	= $('#cboQryCon').combobox('getValue');
		var aSubDateType = $('#cboSubDateType').combobox('getValue');
		var aUseSubDateType = $('#useSubDateType').combobox('getValue');
		var aSubHourType = $('#cboSubHourType').combobox('getValue');
		var aStatDimens = $('#cboShowType').combobox('getValue');
		var aLocIDs 	= $('#cboLoc').combobox('getValues').join(',');		
		var aUseSubDateType = $('#useSubDateType').combobox('getValue');
		var LabSubType = $('#cboLabSubType').combobox('getValue');
		
		ReportFrame = document.getElementById("ReportFrame");
		if(aDateFrom > aDateTo){
			$.messager.alert("提示","开始日期应小于或等于结束日期！", 'info');
			return;
		}
		if ((aDateFrom=="")||(aDateTo=="")){
			$.messager.alert("提示","请选择开始日期、结束日期！", 'info');
			return;
		}
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S170AntTheSubGrade.raq&aHospIDs='+aHospID +'&aDateFrom=' + aDateFrom +'&aDateTo='+ aDateTo+'&aSubDateType='+aSubDateType+'&aSubHourType='+aSubHourType+'&aLocType='+aLocType+'&aQryCon='+aQryCon+'&aUseSubDateType='+aUseSubDateType+'&aStatDimens='+aStatDimens+'&aLocIDs='+aLocIDs+'&aLabSubType='+LabSubType+'&aPath='+cspPath;			
		if(!ReportFrame.src){
			ReportFrame.frameElement.src=p_URL;
		}else{
			ReportFrame.src = p_URL;
		} 
		
	}
	obj.up=function(x,y){
        if(obj.sortName=="非限制级送检人数"){
			return y.UseKSS1AndSub-x.UseKSS1AndSub;
		}else if(obj.sortName=="限制级送检人数"){
			return y.UseKSS2AndSub-x.UseKSS2AndSub;
		}else if(obj.sortName=="特殊级送检人数"){
			return y.UseKSS3AndSub-x.UseKSS3AndSub;
		}else if(obj.sortName=="非限制级送检率"){
			return y.UseKSS1SubRatio-x.UseKSS1SubRatio;
		}else if(obj.sortName=="限制级送检率"){
			return y.UseKSS2SubRatio-x.UseKSS2SubRatio;
		}else {
			return y.UseKSS3SubRatio-x.UseKSS3SubRatio;
		}
    }
	obj.option1 = function(arrViewLoc,arrBfCureSubmissCnt,arrBfCureSubRatio,arrUseKSS1AndSub,arrUseKSS1SubRatio,arrUseKSS2AndSub,arrUseKSS2SubRatio,arrUseKSS3AndSub,arrUseKSS3SubRatio,endnumber){
		var option1 = {
			title : {
				text: '抗菌药物治疗前病原学送检率统计图',
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
				trigger: 'axis'
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
				data:['非限制级送检人数','限制级送检人数','特殊级送检人数','非限制级送检率','限制级送检率','特殊级送检率'],
				selected:{
					"非限制级送检人数":false,
					"非限制级送检率":false
				},
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
					name: '送检人数',
					min: 0,
					interval:10,
					axisLabel: {
						formatter: '{value} '
					}
				},
				{
					type: 'value',
					name: '送检率(%)',
					min: 0,
					interval:10,
					axisLabel: {
						formatter: '{value} %'
					}
				}
			],
			series: [
				{
					name:'非限制级送检人数',
					type:'bar',
					barMaxWidth:50,
					data:arrUseKSS1AndSub
				},
				
				 {
					name:'限制级送检人数',
					type:'bar',
					barMaxWidth:50,
					data:arrUseKSS2AndSub
				},
				{
					name:'特殊级送检人数',
					type:'bar',
					barMaxWidth:50,
					data:arrUseKSS3AndSub
				},
				{
					name:'非限制级送检率',
					type:'line',
					yAxisIndex: 1,
					data:arrUseKSS1SubRatio,
					label: {
						show:true,
						formatter:"{c}%"
					}
				},
				{
					name:'限制级送检率',
					type:'line',
					yAxisIndex: 1,
					data:arrUseKSS2SubRatio,
					label: {
						show:true,
						formatter:"{c}%"
					}
				},
				{
					name:'特殊级送检率',
					type:'line',
					yAxisIndex: 1,
					data:arrUseKSS3SubRatio,
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
		var aStatDimens = $('#cboShowType').combobox('getValue');  //展示维度
		var arrViewLoc 			= new Array();
		var arrBfCureSubmissCnt = new Array();		//送检人数
		var arrBfCureSubRatio 	= new Array();
		var arrUseKSS1AndSub    = new Array();		//非限制级送检人数
		var arrUseKSS1SubRatio 	= new Array();
		var arrUseKSS2AndSub    = new Array();		//限制级送检人数
		var arrUseKSS2SubRatio 	= new Array();
		var arrUseKSS3AndSub    = new Array();		//特殊级送检人数
		var arrUseKSS3SubRatio 	= new Array();
		arrRecord 		= runQuery.rows;
		
		var arrlength		= 0;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			//去掉全院、医院、科室组、科室合计
			if ((rd["xDimensKey"].indexOf('-A-')>-1)||((aStatDimens!="H")&&(rd["xDimensKey"].indexOf('-H-')>-1))||((aStatDimens!="G")&&(aStatDimens!="HG")&&(rd["xDimensKey"].indexOf('-G-')>-1))||(!rd["xDimensKey"])) {
				delete arrRecord[indRd];
				arrlength = arrlength + 1;
				continue;
			}
			rd["DimensDesc"] = $.trim(rd["DimensDesc"]); //去掉空格
			rd["BfCureSubRatio"] = parseFloat(rd["BfCureSubRatio"].replace('%','').replace('‰','')).toFixed(2);
			rd["UseKSS1SubRatio"] = parseFloat(rd["UseKSS1SubRatio"].replace('%','').replace('‰','')).toFixed(2);
			rd["UseKSS2SubRatio"] = parseFloat(rd["UseKSS2SubRatio"].replace('%','').replace('‰','')).toFixed(2);
			rd["UseKSS3SubRatio"] = parseFloat(rd["UseKSS3SubRatio"].replace('%','').replace('‰','')).toFixed(2);
		}
		
		arrRecord = arrRecord.sort(obj.up);
		arrRecord.length = arrRecord.length - arrlength;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			
			arrViewLoc.push(rd["DimensDesc"]);
			arrBfCureSubmissCnt.push(rd["BfCureSubmissCnt"]);
			arrBfCureSubRatio.push(parseFloat(rd["BfCureSubRatio"]).toFixed(2));
			arrUseKSS1AndSub.push(rd["UseKSS1AndSub"]);
			arrUseKSS1SubRatio.push(parseFloat(rd["UseKSS1SubRatio"]).toFixed(2));
			arrUseKSS2AndSub.push(rd["UseKSS2AndSub"]);
			arrUseKSS2SubRatio.push(parseFloat(rd["UseKSS2SubRatio"]).toFixed(2));
			arrUseKSS3AndSub.push(rd["UseKSS3AndSub"]);
			arrUseKSS3SubRatio.push(parseFloat(rd["UseKSS3SubRatio"]).toFixed(2));
			
		}
		var endnumber = (14/arrViewLoc.length)*100;
		// 使用刚指定的配置项和数据显示图表。
		obj.myChart.setOption(obj.option1(arrViewLoc,arrBfCureSubmissCnt,arrBfCureSubRatio,arrUseKSS1AndSub,arrUseKSS1SubRatio,arrUseKSS2AndSub,arrUseKSS2SubRatio,arrUseKSS3AndSub,arrUseKSS3SubRatio,endnumber),true);
	}
   	obj.ShowEChaert1 = function(){
		obj.myChart.clear()
		 //当月科室送检率图表
		var aHospID = $('#cboHospital').combobox('getValues').join('|');
		var aDateFrom = $('#dtDateFrom').datebox('getValue');
		var aDateTo= $('#dtDateTo').datebox('getValue');
		var aLocType = Common_CheckboxValue('chkStatunit');
		var aQryCon 	= $('#cboQryCon').combobox('getValue');
		var aSubDateType = $('#cboSubDateType').combobox('getValue');
		var aUseSubDateType = $('#useSubDateType').combobox('getValue');
		var aSubHourType = $('#cboSubHourType').combobox('getValue');
		var aStatDimens = $('#cboShowType').combobox('getValue');
		var aLocIDs 	= $('#cboLoc').combobox('getValues').join(',');		
		var LabSubType = $('#cboLabSubType').combobox('getValue');
		
		obj.myChart.showLoading();	//隐藏加载动画
		$cm({
			ClassName:"DHCHAI.STATV2.S170AntTheSub",
			QueryName:"QryAntTheSub",
			aHospIDs:aHospID, 
			aDateFrom:aDateFrom, 
			aDateTo:aDateTo, 
			aSubDateType:aSubDateType,
			aSubHourType:aSubHourType,
			aLocType:aLocType, 
			aQryCon:aQryCon, 
			aUseSubDateType:aUseSubDateType,
			aStatDimens:aStatDimens, 
			aLocIDs:aLocIDs,
			aLabSubType:LabSubType, 
			page: 1,
			rows: 999
		},function(rs){
			obj.myChart.hideLoading();    //隐藏加载动画
			obj.echartLocInfRatio(rs);
			
			obj.sortName="特殊级送检率"; //初始化排序指标
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