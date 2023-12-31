﻿function InitS030InfPrefWinEvent(obj){
	obj.numbers = "ALL";
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
		var aHospID = $('#cboHospital').combobox('getValue');
		var DateFrom = $('#dtDateFrom').datebox('getValue');
		var DateTo= $('#dtDateTo').datebox('getValue');
		var Statunit = Common_CheckboxValue('chkStatunit');
		var Qrycon = $('#cboQryCon').combobox('getText');
		var SubLocArr   = $('#cboLoc').combobox('getValues');
		var aLocIDs = SubLocArr.join();
		var aStatDimens = $('#cboShowType').combobox('getValue');
		ReportFrame = document.getElementById("ReportFrame");
		if(Qrycon==""){
			$.messager.alert("提示","请选择筛选条件！", 'info');
			return;	
		}
		if(DateFrom > DateTo){
			$.messager.alert("提示","开始日期应小于或等于结束日期！", 'info');
			return;
		}
		if ((DateFrom=="")||(DateTo=="")){
			$.messager.alert("提示","请选择开始日期、结束日期！", 'info');
			return;
		}
		var objDic = $cm({                  
					ClassName:"DHCHAI.BT.Dictionary",
					MethodName:"GetObjByDesc",
					aTypeCode:"StatScreenCondition",
					aDesc:Qrycon
				},
		false);
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S410SHCssInf.raq&aDateFrom=' + DateFrom +'&aDateTo='+ DateTo +'&aHospIDs='+aHospID +'&aLocIDs='+aLocIDs +'&aLocType='+ Statunit +'&aQryCon='+ objDic.BTCode+'&aStatDimens='+aStatDimens+'&aPath='+cspPath;;
		if(!ReportFrame.src){
			ReportFrame.frameElement.src=p_URL;
		}else{
			ReportFrame.src = p_URL;
		}	
	}
   	obj.ShowEChaert1 = function(){
		obj.myChart.clear();
		var option1 = {
			title : {
				text: '医院感染（例次）现患率统计图',
				textStyle:{
						fontSize:26
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
				right:'20px',
				feature: {
					dataView: {show: false, readOnly: false},
					magicType: {show: true, type: ['line', 'bar']},
					restore: {show: true},
					saveAsImage: {show: true}
				}
			},
			legend: {
				data:['感染人数','现患率'],
				x: 'center',
				y: 30
			},
			 dataZoom: [{
        		show: true,
       	 		realtime: true,
        		zoomLock:true
    		}],
			xAxis: [
				{
					type: 'category',
					data: [],
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
					name: '感染人数',
					min: 0,
					interval:10,
					axisLabel: {
						formatter: '{value} '
					}
				},
				{
					type: 'value',
					name: '现患率(%)',
					min: 0,
					interval:10,
					axisLabel: {
						formatter: '{value} %'
					}
				}
			],
			series: [
				 {
					name:'感染人数',
					type:'bar',
					barMaxWidth:50,
					data:[]
				},
				{
					name:'现患率',
					type:'line',
					yAxisIndex: 1,
					data:[],
					label: {
						show:true,
						formatter:"{c}%"
					}
				}
			   
			]
		};
		// 使用刚指定的配置项和数据显示图表
		obj.myChart.setOption(option1,true);
		
		 //当月科室感染率图表
		var aHospID = $('#cboHospital').combobox('getValue');
		var DateFrom = $('#dtDateFrom').datebox('getValue');
		var DateTo= $('#dtDateTo').datebox('getValue');
		var Statunit = Common_CheckboxValue('chkStatunit');
		var Qrycon = $('#cboQryCon').combobox('getText');
		var SubLocArr   = $('#cboLoc').combobox('getValues');
		var aLocIDs = SubLocArr.join();
		var aStatDimens = $('#cboShowType').combobox('getValue');
		var objDic = $cm({
		    ClassName: "DHCHAI.BT.Dictionary",
		    MethodName: "GetObjByDesc",
		    aTypeCode: "StatScreenCondition",
		    aDesc: Qrycon
		},
		false);
		obj.myChart.showLoading();	
		$cm({
		    ClassName: "DHCHAI.STATV2.S410SHCssInf",
		    QueryName: "QryInfPre1",
		    aDateFrom: DateFrom,
		    aDateTo: DateTo,
			aHospIDs:aHospID,
			aLocIDs:aLocIDs,
			aLocType:Statunit,
			aQryCon:objDic.BTCode,
			aStatDimens:aStatDimens,
			page:1,    //可选项，页码，默认1
			rows:999   //可选项，获取多少条数据，默认50
		},
		function(data){
			obj.myChart.hideLoading();    //隐藏加载动画
			
			obj.echartLocInfRatio(data);
		}
		,function(XMLHttpRequest, textStatus, errorThrown){
			alert("类" + "DHCHAI.STATV2.S410SHCssInf" + ":" + "QryInfPre1" + "执行错误,Status:" + textStatus + ",Error:" + errorThrown);
			obj.myChart.hideLoading();    //隐藏加载动画
		});
		
		
	   obj.echartLocInfRatio = function(runQuery){
			if (!runQuery) return;
			var aStatDimens = $('#cboShowType').combobox('getValue');  //展示维度
			var arrViewLoc 	= new Array();
			var arrInfRatio = new Array();
			var arrInfCount = new Array();
			var arrRecord 	= runQuery.rows;
			
			for (var indRd = 0; indRd < arrRecord.length; indRd++){
				var rd = arrRecord[indRd];
				//去掉全院、医院、科室组
				if ((rd["DimenCode"].indexOf('-A-')>-1)||((aStatDimens!="H")&&(rd["DimenCode"].indexOf('-H-')>-1))||((aStatDimens!="G")&&(aStatDimens!="HG")&&(rd["DimenCode"].indexOf('-G-')>-1))||(!rd["DimenCode"])) {
					delete arrRecord[indRd];
					continue;
				}
				rd["LocDesc"] = $.trim(rd["LocDesc"]); //去掉空格
				
				rd["HAICount"] =parseInt(rd["HospInfCount"])+parseInt(rd["ComInfCount"])
				rd["HAIRatio"] = parseFloat(parseFloat(rd["ComHAIRatio"].replace('%','').replace('‰',''))+parseFloat(rd["HAIRatio"].replace('%','').replace('‰',''))).toFixed(2);
			}
			
			arrRecord = arrRecord.sort(Common_GetSortFun('desc','HospInfCount'));  //排序

			if(obj.numbers=="ALL"){
				obj.numbers = arrRecord.length;
			}else{
				arrRecord.length=obj.numbers;
			}
			for (var indRd = 0; indRd < arrRecord.length; indRd++){                     
				var rd = arrRecord[indRd];
	
				if(rd==undefined){   //去掉全院、医院、科室组后,会有数据变为undefined
					continue;
				}else{
					arrViewLoc.push(rd["LocDesc"]);
					
					arrInfCount.push(rd["HAICount"]);
					arrInfRatio.push(parseFloat(rd["HAIRatio"]).toFixed(2));
				}
			}
			
			// 装载数据
			obj.myChart.setOption(
				{
					dataZoom: [{
		        		start: 0,
		        		end: (15/obj.numbers)*100
		    		}],
					xAxis: {
						data: arrViewLoc
					},
					series: [{
						data:arrInfCount
					},{
						data:arrInfRatio
					}]
				}
			);
			
		}
	}
}
