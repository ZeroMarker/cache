﻿function InitS245OpPosInfSumEvent(obj){
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
		var aHospID 	= $('#cboHospital').combobox('getValues').join('|');
		var DateFrom = $('#dtDateFrom').datebox('getValue');
		var DateTo= $('#dtDateTo').datebox('getValue');
		var StaType = Common_CheckboxValue('chkStatunit');
		var Qrycon = $('#aQryCon').combobox('getValue');
		var OperCat = $('#cboOperCat').combobox('getValue');
		var aStatDimens = $('#cboShowType').combobox('getValue');
		var aLocIDs 	= $('#cboLoc').combobox('getValues').join(',');
		
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
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S245OpPosInfSum.raq&aDateFrom=' + DateFrom +'&aDateTo='+ DateTo +'&aHospIDs='+aHospID +'&aQryCon='+Qrycon+'&aStaType='+StaType+'&aOperCat='+OperCat+'&aStatDimens='+aStatDimens+'&aLocIDs='+aLocIDs+'&aPath='+cspPath;
		if(!ReportFrame.src){
			ReportFrame.frameElement.src=p_URL;
		}else{
			ReportFrame.src = p_URL;
		}	
	}
   	obj.ShowEChaert1 = function(arrViewLoc,arrInfRatio){
		obj.myChart.clear();
		
		var option1 = {
			title : {
				text: '手术部位医院感染例数统计图',
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
				data:['一类切口','二类切口','三类切口','四类切口'],
				x: 'center',
				y: 30
			},
			 dataZoom: [{
        		show: true,
       	 		realtime: true,
        		//start: 0,
        		//end: 50,
        		//zoomLock:true,
				zoomOnMouseWheel:true,
				startValue:0, //数据窗口范围的起始数值
				endValue:10, //数据窗口范围的结束数值。
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
				}
			],
			series: [
				 {
					name:'一类切口',
					type:'bar',
					stack: '切口等级',
					barMaxWidth:50,
					data:[]
				},{				 
					name:'二类切口',
					type:'bar',
					stack: '切口等级',
					barMaxWidth:50,
					data:[]
				}, {
					name:'三类切口',
					type:'bar',
					stack: '切口等级',
					barMaxWidth:50,
					data:[]
				}, {
					name:'四类切口',
					type:'bar',
					stack: '切口等级',
					barMaxWidth:50,
					data:[]
				}

			   
			]
		};
		// 使用刚指定的配置项和数据显示图表
		obj.myChart.setOption(option1,true);
		
		 //当月科室感染率图表
		var HospID = $('#cboHospital').combobox('getValues').join('|');
		var DateFrom = $('#dtDateFrom').datebox('getValue');
		var DateTo= $('#dtDateTo').datebox('getValue');
		var StaType = Common_CheckboxValue('chkStatunit');
		var Qrycon = $('#aQryCon').combobox('getValue');
		var OperCat = $('#cboOperCat').combobox('getValue');
		var aStatDimens = $('#cboShowType').combobox('getValue');
		var aLocIDs 	= $('#cboLoc').combobox('getValues').join(',');
		
	obj.myChart.showLoading();
		$cm({
			ClassName:'DHCHAI.STATV2.S245OpPosInfSum',
			QueryName:'QryOpPosInf',
			aHospIDs:HospID,
			aDateFrom:DateFrom,
			aDateTo:DateTo,
			aStaType:StaType,
			aQryCon:Qrycon,
			aOperCat:OperCat,
			aStatDimens:aStatDimens,
			aLocIDs:aLocIDs,
			page:1,
			rows:999
		},function(rs){
			obj.myChart.hideLoading();    //隐藏加载动画
			obj.echartLocInfRatio(rs);
		})

		
	   obj.echartLocInfRatio = function(runQuery){
			if (!runQuery) return;
			var arrViewLoc = new Array();

			var arrOpCaseCount1 = new Array();
			var arrOpCaseCount2 = new Array();
			var arrOpCaseCount3 = new Array();
			var arrOpCaseCount4 = new Array();
			obj.arrLocG= new Array();
			var arrRecord = runQuery.rows;
			
			var aHospID 	= $('#cboHospital').combobox('getValue');
	   		var QryCon="-H-";	//默认统计医院
			for (var indRd = 0; indRd < arrRecord.length; indRd++){
				var rd = arrRecord[indRd];
				//去掉全院、医院、科室组
				/*if ((rd["DimensKey"].indexOf(QryCon)<0)) {
					delete arrRecord[indRd];
					continue;
				}*/
				if ((rd["DimensKey"].indexOf('-A-')>-1)||(rd["DimensKey"].indexOf('-H-')>-1)||(rd["DimensKey"].indexOf('-G-')>-1)) {
					delete arrRecord[indRd];
					continue;
				}
			}
			arrRecord = arrRecord.sort(Common_GetSortFun('desc','sumOperCase'));  //排序
			
			for (var indRd = 0; indRd < arrRecord.length; indRd++){                     
				var rd = arrRecord[indRd];
				//console.log(rd);
				if(rd==undefined){   //去掉全院、医院、科室组后,会有数据变为undefined
					continue;
				}else{
					arrViewLoc.push(rd["DimensDesc"]);
					arrOpCaseCount1.push(rd["OperCaseCount1"]);
					arrOpCaseCount2.push(rd["OperCaseCount2"]);
					arrOpCaseCount3.push(rd["OperCaseCount3"]);
					arrOpCaseCount4.push(rd["OperCaseCount4"]);

				}
			}
			console.log(runQuery)
			// 装载数据
			obj.myChart.setOption(
				{
					/*dataZoom: [{
		        		start: 0,
		        		end: (10/obj.numbers)*100
		    		}],*/
					xAxis: {
						data: arrViewLoc
					},
					series: [{
						data:arrOpCaseCount1
					},{
						data:arrOpCaseCount2
					},{
						data:arrOpCaseCount3
					},{
						data:arrOpCaseCount4
					}]
				}
			);
			
		}
	}
}
