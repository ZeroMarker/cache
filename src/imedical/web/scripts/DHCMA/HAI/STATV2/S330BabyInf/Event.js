﻿function InitS021DayInfWinEvent(obj){
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
		var aHospID = $('#cboHospital').combobox('getValue');
		var DateFrom = $('#dtDateFrom').datebox('getValue');
		var DateTo= $('#dtDateTo').datebox('getValue');
		var Statunit = Common_CheckboxValue('chkStatunit');
		var Qrycon = $('#aQryCon').combobox('getValue');
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
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S330BabyInf.raq&aDateFrom=' + DateFrom +'&aDateTo='+ DateTo +'&aHospIDs='+aHospID+'&aLocIDs='+""+'&aLocType='+Statunit+'&aQrycon='+Qrycon ;
		if(!ReportFrame.src){
			ReportFrame.frameElement.src=p_URL;
		}else{
			ReportFrame.src = p_URL;
		}	
	}
   	obj.ShowEChaert1 = function(){
		obj.myChart.clear();
		
		
		 //当月科室感染率图表
		var HospID = $('#cboHospital').combobox('getValue');
		var DateFrom = $('#dtDateFrom').datebox('getValue');
		var DateTo= $('#dtDateTo').datebox('getValue');
		var StaType = Common_CheckboxValue('chkStatunit');
		var Qrycon = $('#aQryCon').combobox('getValue');
		var dataInput = "ClassName=" + 'DHCHAI.STATV2.S330BabyInf' + "&QueryName=" + 'QryInfPreBaby' + "&Arg1=" + DateFrom + "&Arg2=" + DateTo+  "&Arg3=" + HospID +"&Arg4=" +""+"&Arg5=" + StaType+"&Arg6=" +Qrycon+"&ArgCnt=" + 6;
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
				alert("类" + tkclass + ":" + tkQuery + "执行错误,Status:" + textStatus + ",Error:" + errorThrown);
				obj.myChart.hideLoading();    //隐藏加载动画
			}
		});
		
	   obj.echartLocInfRatio = function(runQuery){
			if (!runQuery) return;
			var arrViewLoc = new Array();
			var arrInfRatio = new Array();
			var arrInfCount = new Array();
			obj.arrLocG= new Array();
			var arrRecord = runQuery.record;
			
			for (var indRd = 0; indRd < arrRecord.length; indRd++){
				var rd = arrRecord[indRd];
				//去掉全院、医院、科室组
				if ((rd["DimenCode"].indexOf('-A-')>-1)||(rd["DimenCode"].indexOf('-H-')>-1)||(rd["DimenCode"].indexOf('-G-')>-1)) {
					delete arrRecord[indRd];
					continue;
				}
				rd["LocDesc"] = $.trim(rd["LocDesc"]); //去掉空格
				rd["INFCount"] = parseFloat(parseFloat(rd["INFCount"].replace('%','').replace('‰','')).toFixed(2));
			}
			arrRecord = arrRecord.sort(Common_GetSortFun('desc','INFCount'));  //排序
			if(obj.numbers=="ALL"){
				obj.numbers = arrRecord.length;
			}else{
				arrRecord.length=obj.numbers;
			}
			for (var indRd = 0; indRd < arrRecord.length; indRd++){                     
				var rd = arrRecord[indRd];
				//console.log(rd);
				if(rd==undefined){   //去掉全院、医院、科室组后,会有数据变为undefined
					continue;
				}else{
					arrViewLoc.push(rd["LocDesc"]);
					arrInfCount.push(rd["INFCount"]);
					arrInfRatio.push(parseFloat(rd["INFRatio"]).toFixed(2));
					obj.arrLocG.push(rd["DimenCode"]);
				}
			}
			
		var option1 = {
			title : {
				text: '新生儿患者医院感染例次发病率统计图',
				textStyle:{
						fontSize:20
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
				data:['感染例次数','感染例次率'],
				x: 'center',
				y: 30
			},
			 dataZoom: [{
        		show: true,
       	 		realtime: true,
       	 		start: 0,
		        end: (15/obj.numbers)*100,
        		zoomLock:true
    		}],
			xAxis: [
				{
					type: 'category',
					data: arrViewLoc,
					/* axisPointer: {
						type: 'shadow'
					} */
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
					name: '感染例次数',
					min: 0,
					nameTextStyle: {
			            padding: [0, 0, 10, -10]    // 四个数字分别为上右下左与原位置距离
			        },
					interval:10,
					axisLabel: {
						formatter: '{value} '
					}
				},
				{
					type: 'value',
					name: '感染例次率(%)',
					min: 0,
					nameTextStyle: {
			            padding: [0, 0, 10, -10]    // 四个数字分别为上右下左与原位置距离
			        },
					interval:Math.ceil(arrInfRatio[0]/10),
					axisLabel: {
						formatter: '{value} %'
					}
				}
			],
			series: [
				 {
					name:'感染例次数',
					type:'bar',
					barMaxWidth:50,
					data:arrInfCount
				},
				{
					name:'感染例次率',
					type:'line',
					yAxisIndex: 1,
					data:arrInfRatio,
					label: {
						show:true,
						formatter:"{c}%"
					}
				}
			   
			]
		};
		// 使用刚指定的配置项和数据显示图表
		obj.myChart.setOption(option1,true);	

		}
	}

		
}