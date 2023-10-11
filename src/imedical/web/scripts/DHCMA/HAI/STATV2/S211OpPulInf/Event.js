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
		var aHospID 	= $('#cboHospital').combobox('getValues').join('|');
		var DateFrom = $('#dtDateFrom').datebox('getValue');
		var DateTo= $('#dtDateTo').datebox('getValue');
		var Statunit = Common_CheckboxValue('chkStatunit');
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
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S211OpPulInf.raq&aHospIDs='+aHospID +'&aDateFrom=' + DateFrom +'&aDateTo='+ DateTo +'&aStaType='+ Statunit +'&aQryCon='+ Qrycon+'&aOperCat='+OperCat+'&aStatDimens='+aStatDimens+'&aLocIDs='+aLocIDs+'&aPath='+cspPath;
		console.log(p_URL)	
		ReportFrame.src = p_URL; 	
	}
	obj.up=function(x,y){
		if(obj.sortName=="肺部感染发生例数")
		{
			return y.PullCount-x.PullCount;
		}
		else
		{
			return y.PullRatio-x.PullRatio;
		}	        
    }
   	obj.ShowEChaert1 = function(){
		obj.myChart.clear();
		var option1 = {
			title : {
				text: '手术患者肺部感染发病率统计图',
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
				trigger: 'axis',
			},
			toolbox: {
				feature: {
					magicType: {show: true, type: ['line', 'bar']},
					restore: {show: true},
					saveAsImage: {show: true}
				}
			},
			legend: {
				data:['肺部感染发生例数','感染发病率'],
				x: 'center',
				y: 30
			},
			 dataZoom: [{
				height: 40,
				show: true,
				realtime: true,
				bottom: 0,
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
									}else if(value.length>10){
										return value.substr(0,6)+'\n'+value.substr(6,4)+"...";
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
					name: '肺部感染发生例数',
					min: 0,
					interval:10,
					axisLabel: {
						formatter: '{value} '
					}
				},
				{
					type: 'value',
					name: '感染发病率(%)',
					min: 0,
					interval:10,
					axisLabel: {
						formatter: '{value} %'
					}
				}
			],
			series: [
				 {
					name:'肺部感染发生例数',
					type:'bar',
					barMaxWidth:50,
					data:[]
				},
				{
					name:'感染发病率',
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
			ClassName:'DHCHAI.STATV2.S211OpPulInf',
			QueryName:'QryOpPulInf',
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

			obj.sortName="感染发病率"; //初始化排序指标
			obj.myChart.off('legendselectchanged'); //取消事件，避免事件绑定重复导致多次触发
			obj.myChart.on('legendselectchanged', function(legObj){

				//处理排序问题 
				//如果是重复点击认为是需要执行隐藏处理,不想隐藏就不用判断了	
				if(obj.sortName!=legObj.name)
				{
					obj.sortName=legObj.name;
					obj.echartLocInfRatio(rs);
				}
				else
				{
					obj.sortName="";  //初始化
				}
				
			});
		});

	   obj.echartLocInfRatio = function(runQuery){
			if (!runQuery) return;
			var arrViewLoc = new Array();
			var arrInfRatio = new Array();
			var arrInfCount = new Array();
			obj.arrLocG= new Array();
			var arrRecord = runQuery.rows;
			var arrlength=0
			for (var indRd = 0; indRd < arrRecord.length; indRd++){
				var rd = arrRecord[indRd];
				//去掉全院、医院、科室组
				if ((rd["xDimensKey"].indexOf('-A-')>-1)||(rd["xDimensKey"].indexOf('-H-')>-1)||(rd["xDimensKey"].indexOf('-G-')>-1)) {
					delete arrRecord[indRd];
					arrlength=arrlength+1
					continue;
				}
				rd["DimensDesc"] = $.trim(rd["DimensDesc"]); //去掉空格
				rd["PullRatio"] = parseFloat(rd["PullRatio"].replace('%','').replace('‰','')).toFixed(2);
			}
			arrRecord = arrRecord.sort(obj.up);
			arrRecord.length=arrRecord.length-arrlength
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
					arrViewLoc.push(rd["DimensDesc"]);
					arrInfCount.push(rd["PullCount"]);
					arrInfRatio.push(parseFloat(rd["PullRatio"]).toFixed(2));
					obj.arrLocG.push(rd["DimensKey"]);
				}
			}
			
			// 装载数据
			obj.myChart.setOption(
				{
					dataZoom: [{
		        		start: 0,
		        		end: (10/obj.numbers)*100
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
