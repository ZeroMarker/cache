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
		var LocID = $("#cboLoc").combobox('getValue');
		ReportFrame = document.getElementById("ReportFrame");
		
		if(DateFrom > DateTo){
			$.messager.alert("提示","开始日期应小于或等于结束日期！", 'info');
			return;
		}
		if ((DateFrom=="")||(DateTo=="")){
			$.messager.alert("提示","请选择开始日期、结束日期！", 'info');
			return;
		}
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S471EnvHyQua.raq&aHospIDs='+aHospID +'&aDateFrom=' + DateFrom +'&aDateTo='+ DateTo +'&aMonitorLocID='+LocID;	
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
				text: '环境卫生学监测合格率统计图',
				textStyle:{
						fontSize:20
					},
				x:'center',
				y:'top'
			},
			tooltip: {
				trigger: 'axis',
			},
			toolbox: {
				feature: {
					//dataView: {show: false, readOnly: false},
					magicType: {show: true, type: ['line', 'bar']},
					restore: {show: true},
					saveAsImage: {show: true}
				}
			},
			legend: {
				data:['合格数量','合格率'],
				x: 'center',
				y: 30
			},
			grid:{
				left:'5%',
				top:'11%',	
				right:'5%',
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
					type: 'value',
					name: '合格数量',
					min: 0,
					interval:1,
					axisLabel: {
						formatter: '{value} '
					}
				},
				{
					type: 'value',
					name: '合格率(%)',
					min: 0,
					interval:10,
					axisLabel: {
						formatter: '{value}%'
					}
				}
			],
			series: [
				 {
					name:'合格数量',
					type:'bar',
					barMaxWidth:50,
					data:[]
				},
				{
					name:'合格率',
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
		var HospID = $('#cboHospital').combobox('getValue');
		var DateFrom = $('#dtDateFrom').datebox('getValue');
		var DateTo= $('#dtDateTo').datebox('getValue');
		var LocID = $("#cboLoc").combobox('getValue');
		
		obj.myChart.showLoading();	//隐藏加载动画
		$cm({
			ClassName:"DHCHAI.STATV2.S470EnvHyQua",
			QueryName:"QryEnvHyQua",		
			aHospIDs:HospID,
			aDateFrom:DateFrom, 
			aDateTo:DateTo, 
			aMonitorLocID:LocID,
			page: 1,
			rows: 999
		},function(rs){
			obj.myChart.hideLoading();    //隐藏加载动画
			obj.echartLocInfRatio(rs);
		});
	
	   obj.echartLocInfRatio = function(runQuery){
			if (!runQuery) return;
			var arrViewLoc = new Array();
			var arrInfRatio = new Array();
			var arrInfCount = new Array();
			
			var arrRecord = runQuery.rows;
			
			for (var indRd = 0; indRd < arrRecord.length; indRd++){
				var rd = arrRecord[indRd];
				
				rd["LocDesc"] = $.trim(rd["LocDesc"]); //去掉空格
				rd["StandardCnt"] = parseFloat(parseFloat(rd["StandardCnt"].replace('%','').replace('‰','')).toFixed(2));
			}
			arrRecord = arrRecord.sort(Common_GetSortFun('desc','StandardCnt'));  //排序
			/*if(obj.numbers=="ALL"){
				obj.numbers = arrRecord.length;
			}else{
				arrRecord.length=obj.numbers;
			}*/
			obj.numbers = arrRecord.length;
			for (var indRd = 0; indRd < arrRecord.length; indRd++){                     
				var rd = arrRecord[indRd];
				//console.log(rd);
				if(rd==undefined){   //去掉全院、医院、科室组后,会有数据变为undefined
					continue;
				}else{
					arrViewLoc.push(rd["LocDesc"]);
					arrInfCount.push(rd["StandardCnt"]);
					arrInfRatio.push(parseFloat(rd["StandardRatio"]).toFixed(2));
					
				}
			}
			
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
