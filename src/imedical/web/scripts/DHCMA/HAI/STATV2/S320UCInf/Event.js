function InitUCTubeInfWinEvent(obj){
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
		var aLocType    = Common_CheckboxValue('chkStatunit');
		var aQrycon     = $('#aQryCon').combobox('getValue');
		var aStatDimens = $('#cboShowType').combobox('getValue');
		var aLocIDs 	= $('#cboLoc').combobox('getValues').join(',');		
		ReportFrame = document.getElementById("ReportFrame");
		if(aQrycon==""){
			$.messager.alert("提示","请选择筛选条件！", 'info');
			return;	
		}
		if(aDateFrom > aDateTo){
			$.messager.alert("提示","开始日期应小于或等于结束日期！", 'info');
			return;
		}
		if ((aDateFrom=="")||(aDateTo=="")){
			$.messager.alert("提示","请选择开始日期、结束日期！", 'info');
			return;
		}
		if ((aStatDimens=="")){
			$.messager.alert("提示","请选择展示维度！", 'info');
			return;
		}
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S320UCInf.raq&aHospIDs='+aHospID +'&aDateFrom=' + aDateFrom +'&aDateTo='+ aDateTo+'&aLocType='+aLocType+'&aQryCon='+aQrycon+'&aStatDimens='+aStatDimens+'&aLocIDs='+aLocIDs+'&aPath='+cspPath;	
		if(!ReportFrame.src){
			ReportFrame.frameElement.src=p_URL;
		}else{
			ReportFrame.src = p_URL;
		} 	
	}
   
   obj.up=function(x,y){
        if(obj.sortName=="使用率"){
			return y.TubeRatio-x.TubeRatio;
		}else {
			return y.INFRatio-x.INFRatio;
		}	 
    }
   	obj.ShowEChaert1 = function(){
		obj.myChart.clear();
	
		var option1 = {
			title : {
				text: '导尿管相关尿路感染统计图',
				textStyle:{
						fontSize:20
					},
				x:'center',
				y:'top'
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
			grid:{
				left:'5%',
				top:'11%',	
				right:'5%',
				bottom:'5%',
				containLabel:true
			},
			legend: {
				data:['使用率','发病率'],
				x: 'center',
				y: 30
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
					name: '使用率(%)',
					min: 0,
					interval:10,
					axisLabel: {
						formatter: '{value}% '
					}
				},
				{
					type: 'value',
					name: '发病率(‰)',
					min: 0,
					interval:10,
					axisLabel: {
						formatter: '{value} ‰'
					}
				}
			],
			series: [
				 {
					name:'使用率',
					type:'bar',
					barMaxWidth:50,
					data:[]
				},
				{
					name:'发病率',
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
		
		var aHospID 	= $('#cboHospital').combobox('getValues').join('|');
		var aDateFrom 	= $('#dtDateFrom').datebox('getValue');
		var aDateTo		= $('#dtDateTo').datebox('getValue');
		var aLocType 	= Common_CheckboxValue('chkStatunit');
		var aQrycon 	= $('#aQryCon').combobox('getValue');
		var aStatDimens = $('#cboShowType').combobox('getValue');
		var aLocIDs 	= $('#cboLoc').combobox('getValues').join(',');	
		
		obj.myChart.showLoading();	//隐藏加载动画
		$cm({
			ClassName:"DHCHAI.STATV2.S3TubeInf",
			QueryName:"QryTubeInf",
			aHospIDs:aHospID, 
			aDateFrom:aDateFrom, 
			aDateTo:aDateTo, 
			aLocType:aLocType, 
			aQryCon:aQrycon,
			aTubeType:'UC' ,
			aStatDimens:aStatDimens, 
			aLocIDs:aLocIDs,
			page: 1,
			rows: 999
		},function(rs){
			obj.myChart.hideLoading();    //隐藏加载动画
			obj.echartLocInfRatio(rs);
			
			obj.sortName="发病率"; //初始化排序指标
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
		
	   obj.echartLocInfRatio = function(runQuery){
			if (!runQuery) return;
			var aStatDimens = $('#cboShowType').combobox('getValue');  //展示维度

			var arrViewLoc = new Array();
			var arrInfRatio = new Array();
			var arrUseRatio = new Array();
			var arrRecord = runQuery.rows;
			
			var arrRecord = runQuery.rows;
			var arrlength	= 0;
			for (var indRd = 0; indRd < arrRecord.length; indRd++){
				var rd = arrRecord[indRd];
					//去掉全院、医院、科室组、科室合计
				if ((rd["DimenCode"].indexOf('-A-')>-1)||((aStatDimens!="H")&&(rd["DimenCode"].indexOf('-H-')>-1))||((aStatDimens!="G")&&(aStatDimens!="HG")&&(rd["DimenCode"].indexOf('-G-')>-1))||(!rd["DimenCode"])) {
					delete arrRecord[indRd];
					arrlength = arrlength + 1;
					continue;
				}
				rd["TubeRatio"] = parseFloat(rd["TubeRatio"].replace('%','').replace('‰','')).toFixed(2);
				rd["INFRatio"] = parseFloat(rd["INFRatio"].replace('%','').replace('‰','')).toFixed(2);
			}
			arrRecord = arrRecord.sort(obj.up);
			arrRecord.length = arrRecord.length - arrlength;
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
					arrUseRatio.push(parseFloat(rd["TubeRatio"]).toFixed(2));
					arrInfRatio.push(parseFloat(rd["INFRatio"]).toFixed(2));
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
						data:arrUseRatio
					},{
						data:arrInfRatio
					}]
				}
			);
			
		}
	}
}
