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
			$('#EchartDiv').removeClass("no-result");
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
		var DateFrom = $('#dtDateFrom').datebox('getValue');
		var DateTo= $('#dtDateTo').datebox('getValue');
		var Statunit = Common_CheckboxValue('chkStatunit');
		var Qrycon = $('#aQryCon').combobox('getValue');
		//var aLocIDs = $('#cboLoc').combobox('getValues').join(',');	
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
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S350BWPICCInf.raq&aHospIDs='+aHospID +'&aDateFrom=' + DateFrom +'&aDateTo='+ DateTo +'&aLocType='+ Statunit +'&aQryCon='+Qrycon+'&aPath='+cspPath;	
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
				text: '出生体重分组新生儿中央血管导管相关血流感染发病率统计图',
				textStyle:{
						fontSize:20
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
				data:['BW≤1000g','BW 1001g~1500g','BW 1501g~2500g','BW>2500g','BW未填写'],
				x: 'center',
				y: 30
			}/*,
			 dataZoom: [{
        		show: true,
       	 		realtime: true,
        		start: 0,
        		end: 10
    		}]*/,
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
							return value;
						}
					}
				}
			],
			yAxis: [
				{
					type: 'value',
					name: '感染例次',
					min: 0,
					interval:10,
					axisLabel: {
						formatter: '{value} '
					}
				},
				{
					type: 'value',
					name: '感染发病率(‰)',
					min: 0,
					interval:100,
					axisLabel: {
						formatter: '{value} ‰'
					}
				}
			],
			series: [
				{
					name:'BW≤1000g',
					type:'bar',
					barMaxWidth:20,
					data:[]
				},{
					name:'BW≤1000g',
					type:'line',
					yAxisIndex: 1,
					data:[],
					label: {
						show:true,
						formatter:"{c}‰"
					}
				},{
					name:'BW 1001g~1500g',
					type:'bar',
					barMaxWidth:20,
					data:[]
				},{
					name:'BW 1001g~1500g',
					type:'line',
					yAxisIndex: 1,
					data:[],
					label: {
						show:true,
						formatter:"{c}‰"
					}
				},{
					name:'BW 1501g~2500g',
					type:'bar',
					barMaxWidth:20,
					data:[]
				},{
					name:'BW 1501g~2500g',
					type:'line',
					yAxisIndex: 1,
					data:[],
					label: {
						show:true,
						formatter:"{c}‰"
					}
				},{
					name:'BW>2500g',
					type:'bar',
					barMaxWidth:20,
					data:[]
				},{
					name:'BW>2500g',
					type:'line',
					yAxisIndex: 1,
					data:[],
					label: {
						show:true,
						formatter:"{c}‰"
					}
				},{
					name:'BW未填写',
					type:'bar',
					barMaxWidth:20,
					data:[]
				},{
					name:'BW未填写',
					type:'line',
					yAxisIndex: 1,
					data:[],
					label: {
						show:true,
						formatter:"{c}‰"
					}
				}
			   
			]
		};
		// 使用刚指定的配置项和数据显示图表
		obj.myChart.setOption(option1,true);
		
		 //当月科室感染率图表
		var HospID = $('#cboHospital').combobox('getValues').join('|');
		var DateFrom = $('#dtDateFrom').datebox('getValue');
		var DateTo= $('#dtDateTo').datebox('getValue');
		var aLocType = Common_CheckboxValue('chkStatunit');
		var Qrycon = $('#aQryCon').combobox('getValue');
		
		
		obj.myChart.showLoading();	//隐藏加载动画
		$cm({
			ClassName:"DHCHAI.STATV2.S350BWPICCInf",
			QueryName:"QrySDayInf",
			aHospIDs:HospID, 
			aDateFrom:DateFrom, 
			aDateTo:DateTo, 
			aLocType:aLocType, 
			aQryCon:aQrycon
		},function(rs){
			obj.myChart.hideLoading();    //隐藏加载动画
			obj.echartLocInfRatio(rs);
		});
		
	   obj.echartLocInfRatio = function(runQuery){
			if (!runQuery) return;
			var arrViewLoc = new Array();
			var arrDatas = new Array();			
			var arrRecord = runQuery.rows;
			
			for (var indRd = 0; indRd < arrRecord.length; indRd++){
				var rd = arrRecord[indRd];
				rd["INFRatio"] = parseFloat(parseFloat(rd["INFRatio"].replace('%','').replace('‰','')).toFixed(2));
			}
			
			obj.numbers = arrRecord.length;
			
			for (var indRd = 0; indRd < arrRecord.length; indRd++){                     
				var rd = arrRecord[indRd];
				arrDatas.push({"id":rd["WtCat"]+"_"+rd["DimensDesc"],"count": rd["INFCount"],"ratio": parseFloat(rd["INFRatio"]).toFixed(2)});
				
				if (arrViewLoc.indexOf(rd["DimensDesc"])<0) {
					arrViewLoc.push(rd["DimensDesc"]);
				}
			}
			
			var seriesCases=[];
			var seriesRatios=[];
			var LocLen = arrViewLoc.length;
			if (LocLen==0) return;
			for (var i = 1; i <=5; i++) {
				var arrInfCase=[];
				var arrInfRatio=[];
				for (var j = 0; j < LocLen; j++) {
					var LocWtCat = i+"_"+arrViewLoc[j];
					for (var k=0; k < arrDatas.length; k++) {
						if (arrDatas[k]['id']!=LocWtCat) continue;
						arrInfCase.push(arrDatas[k]['count']);
						arrInfRatio.push(arrDatas[k]['ratio']);
					}
				}
				seriesCases.push(arrInfCase);
				seriesRatios.push(arrInfRatio);			
			}	
	
			// 装载数据
			obj.myChart.setOption(
				{
					xAxis:{
						data: arrViewLoc
					},
					series: [{
						data:seriesCases[0]
					},{
						data:seriesRatios[0]
					},{
						data:seriesCases[1]
					},{
						data:seriesRatios[1]
					},{
						data:seriesCases[2]
					},{
						data:seriesRatios[2]
					},{
						data:seriesCases[3]
					},{
						data:seriesRatios[3]
					},{
						data:seriesCases[4]
					},{
						data:seriesRatios[4]
					}]
				}
			);
		}
	}
}
