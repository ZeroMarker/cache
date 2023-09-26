function InitS021DayInfWinEvent(obj){
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
		ReportFrame = document.getElementById("ReportFrame");

		if(DateFrom > DateTo){
			$.messager.alert("提示","开始日期应小于或等于结束日期！", 'info');
			return;
		}
		if ((DateFrom=="")||(DateTo=="")){
			$.messager.alert("提示","请选择开始日期、结束日期！", 'info');
			return;
		}
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.ICUResultStat.raq&aDateFrom='+DateFrom +'&aDateTo='+ DateTo +'&aHospIDs=' + aHospID  +'&aLocType='+"W"+'&aQryCon='+2;	
		if(!ReportFrame.src){
			ReportFrame.frameElement.src=p_URL;
		}else{
			ReportFrame.src = p_URL;
		}	
	}
   	obj.ShowEChaert1 = function(){
		obj.myChart.clear();
		option1 = {
			title : {
				text: 'ICU三管信息统计图',
				textStyle:{
						fontSize:26
					},
				x:'center',
				y:'top'
			},
		    color: ['#003366', '#006699', '#4cabce', '#e5323e'],
		    tooltip: {
		        trigger: 'axis',
		        axisPointer: {
		            type: 'shadow'
		        }
		    },
		    grid:{
				left:'5%',
				top:'12%',	
				right:'1%',
				bottom:'5%',
				containLabel:true
			},
		     dataZoom: [{
        		show: true,
       	 		realtime: true,
        		start: 0,
        		end: 16,
        		zoomLock:true
    		}],
		    legend: {
		        data: ['VAP人数', 'PICC人数', 'UC人数'],
		        x: 'center',
				y: 40
		    },
		    toolbox: {
			    right:"20px",
		        feature: {
		            magicType: {show: true, type: ['line', 'bar']},
		            restore: {show: true},
		            saveAsImage: {show: true}
		        }
		    },
		   	xAxis: [
				{
					type: 'category',
					data: [],
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
		            type: 'value'
		        }
		    ],
		    series: [
		        {
		            name: 'VAP人数',
		            type: 'bar',
		            barGap: 0,
		            data: []
		        },
		        {
		            name: 'PICC人数',
		            type: 'bar',
		            data: []
		        },
		        {
		            name: 'UC人数',
		            type: 'bar',
		            data: []
		        }
		    ]
		};
		// 使用刚指定的配置项和数据显示图表
		obj.myChart.setOption(option1,true);
		
		 //当月科室感染率图表
		var HospID = $('#cboHospital').combobox('getValue');
		var DateFrom = $('#dtDateFrom').datebox('getValue');
		var DateTo= $('#dtDateTo').datebox('getValue');
		var dataInput = "ClassName=" + 'DHCHAI.STATV2.ICUResultStat' + "&QueryName=" + 'QryTubeInfo' + "&Arg1=" + DateFrom + "&Arg2=" + DateTo + "&Arg3=" + HospID+ "&Arg4=" +"W"+"&Arg5="+2+"&ArgCnt=" + 5;
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
				//console.log(data);
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
			var arrVAP = new Array();
			var arrPICC = new Array();
			var arrUC = new Array();
			obj.arrLocG= new Array();
			var arrRecord = runQuery.record;
			
			for (var indRd = 0; indRd < arrRecord.length; indRd++){
				var rd = arrRecord[indRd];
				//去掉全院、医院、科室组
				if ((rd["xDimensKey"].indexOf('-A-')>-1)||(rd["xDimensKey"].indexOf('-H-')>-1)||(rd["xDimensKey"].indexOf('-G-')>-1)) {
					delete arrRecord[indRd];
					continue;
				}
				//rd["VAPCount"] = parseFloat(parseFloat(rd["VAPCount"].replace('%','').replace('‰','')).toFixed(2));
			}
			arrRecord = arrRecord.sort(Common_GetSortFun('desc','VAPCount'));  //排序
			arrRecord = arrRecord.sort(Common_GetSortFun('desc','PICCCount'));  //排序
			arrRecord = arrRecord.sort(Common_GetSortFun('desc','UCCount'));  //排序
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
					arrViewLoc.push(rd["DimensDesc"]);
					arrVAP.push(rd["VAPCount"]);
					arrPICC.push(rd["PICCCount"]);
					arrUC.push(rd["UCCount"])
					//arrInfRatio.push(parseFloat(rd["VAPCount"]).toFixed(2));
					obj.arrLocG.push(rd["xDimensKey"]);
				}
			}
			console.log(arrViewLoc);
			console.log(arrVAP);
			// 装载数据
			obj.myChart.setOption(
				{
					dataZoom: [{
		        		start: 0,
		        		end: (16/obj.numbers)*100
		    		}],
					xAxis: {
						data: arrViewLoc
					},
					series:  [{
						data:arrVAP
					},{
						data:arrPICC
					},{
						data:arrUC
					}]
				}
			);
			
		}
	}
}
