function InitS150AntVarDayWinEvent(obj){
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
	   	var NoMapCount = $cm ({									
			ClassName:"DHCHAI.DPS.NoMapCountSrv",
			MethodName:"NoOEItmMastMap"
		},false);
	
	   	if (NoMapCount>0) {
		   	$.messager.defaults.ok ="跳转";
		   	$.messager.confirm("提示", "当前存在<span style='color:red;font-size:16px;'>"+NoMapCount+"</span>条抗菌药物未对照标准名称的记录，不完成数据对照影响抗菌药物品种数判断，是否跳转至抗菌药物对照界面？", function(r){
				if (r){
					OpenMenu('DHCHAIBaseDP-LabInfTestSet','抗菌药物对照','dhcma.hai.dp.oeantimastmap.csp');
				}
		   	})
		   	$.messager.defaults.ok="确认";
	   	}

		var aHospID 	= $('#cboHospital').combobox('getValues').join('|');
		var aDateFrom 	= $('#dtDateFrom').datebox('getValue');
		var aDateTo		= $('#dtDateTo').datebox('getValue');
		var aLocType 	= Common_CheckboxValue('chkStatunit');
		var aQryCon 	= $('#cboQryCon').combobox('getValue');
		var aStatDimens = $('#cboShowType').combobox('getValue');
		var aLocIDs 	= $('#cboLoc').combobox('getValues').join(',');	
		ReportFrame = document.getElementById("ReportFrame");
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
		
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S150AntVarDay.raq&aHospIDs='+aHospID +'&aDateFrom=' + aDateFrom +'&aDateTo='+ aDateTo+'&aLocType='+aLocType+'&aQryCon='+aQryCon+'&aStatDimens='+aStatDimens+'&aLocIDs='+aLocIDs+'&aPath='+cspPath;			
		if(!ReportFrame.src){
			ReportFrame.frameElement.src=p_URL;
		}else{
			ReportFrame.src = p_URL;
		} 
		
	}
	
	// 菜单跳转
	function OpenMenu(menuCode,menuDesc,menuUrl) {
		var strUrl = '../csp/'+menuUrl+'?+&1=1';
		//主菜单
		var data = [{
			"menuId": "",
			"menuCode": menuCode,
			"menuDesc": menuDesc,
			"menuResource": menuUrl,
			"menuOrder": "1",
			"menuIcon": "icon"
		}];
		if( typeof window.parent.showNavTab === 'function' ){   //bootstrap 版本
			window.parent.showNavTab(data[0]['menuCode'], data[0]['menuDesc'], data[0]['menuResource'], data[0]['menuCode'], data[0]['menuIcon'], false);
		}else{ //HISUI 版本
			window.parent.addTab({
				url:menuUrl,
				title:menuDesc
			});
		}
	}
	obj.up=function(x,y){
		 if(obj.sortName=="人均使用抗菌药物天数"){
			return y.AvgDays-x.AvgDays;
		}else {
			return y.AvgCount-x.AvgCount	//根据人均使用抗菌药物品种数排序
		}	        
    }
	obj.option1 = function(arrViewLoc,arrAvgCount,arrAvgDays,endnumber){
		var option1 = {
			title : {
				text: '出院患者人均使用抗菌药物品种数和天数统计图',
				textStyle:{
					fontSize:28
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
				data:['人均使用抗菌药物品种数','人均使用抗菌药物天数'],
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
					name: '人均使用品种数',
					min: 0,
					interval:Math.ceil(arrAvgCount[0]/10),
					axisLabel: {
						formatter: '{value} '
					}
				},
				{
					type: 'value',
					name: '人均使用天数',
					min: 0,
					interval:Math.ceil(arrAvgDays[0]/10),
					axisLabel: {
						formatter: '{value}'
					}
				}
			],
			series: [
				 {
					name:'人均使用抗菌药物品种数',
					type:'bar',
					barMaxWidth:50,
					data:arrAvgCount
				},
				{
					name:'人均使用抗菌药物天数',
					type:'line',
					yAxisIndex: 1,
					data:arrAvgDays,
					label: {
						show:true,
						formatter:"{c}"
					}
				}  
			]
		};
		return option1;
	}
	
    obj.echartLocInfRatio = function(runQuery){
		if (!runQuery) return;
		var aStatDimens = $('#cboShowType').combobox('getValue');  //展示维度
		var arrViewLoc 		= new Array();
		var arrAvgCount 	= new Array();		
		var arrAvgDays 		= new Array();
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
		}
		
		arrRecord = arrRecord.sort(obj.up);
		arrRecord.length = arrRecord.length - arrlength;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			
			arrViewLoc.push(rd["DimensDesc"]);
			arrAvgCount.push(rd["AvgCount"]);
			arrAvgDays.push(rd["AvgDays"]);
			
		}
		var endnumber = (10/arrViewLoc.length)*100;
		// 使用刚指定的配置项和数据显示图表。
		obj.myChart.setOption(obj.option1(arrViewLoc,arrAvgCount,arrAvgDays,endnumber),true);
	}
   	obj.ShowEChaert1 = function(){
		obj.myChart.clear();
		var NoMapCount = $cm ({									
			ClassName:"DHCHAI.DPS.NoMapCountSrv",
			MethodName:"NoOEItmMastMap"
		},false);
	
	   	if (NoMapCount>0) {
		   	$.messager.defaults.ok ="跳转";
		   	$.messager.confirm("提示", "当前存在<span style='color:red;font-size:16px;'>"+NoMapCount+"</span>条抗菌药物未对照标准名称的记录，不完成数据对照影响药品品种数判断，是否跳转至抗菌药物对照界面？", function(r){
				if (r){
					OpenMenu('DHCHAIBaseDP-LabInfTestSet','抗菌药物对照','dhcma.hai.dp.oeantimastmap.csp');
				}
		   	})
		   	$.messager.defaults.ok="确认";
	   	}
		 //当月科室感染率图表
		var aHospID 	= $('#cboHospital').combobox('getValues').join('|');
		var aDateFrom 	= $('#dtDateFrom').datebox('getValue');
		var aDateTo		= $('#dtDateTo').datebox('getValue');
		var aLocType 	= Common_CheckboxValue('chkStatunit');
		var aQryCon 	= $('#cboQryCon').combobox('getValue');
		var aStatDimens = $('#cboShowType').combobox('getValue');
		var aLocIDs 	= $('#cboLoc').combobox('getValues').join(',');	
		obj.myChart.showLoading();	//隐藏加载动画
		$cm({
			ClassName:"DHCHAI.STATV2.S150AntVarDay",
			QueryName:"QryAntVarDay",
			aHospIDs:aHospID, 
			aDateFrom:aDateFrom, 
			aDateTo:aDateTo, 
			aLocType:aLocType, 
			aQryCon:aQryCon, 
			aStatDimens:aStatDimens, 
			aLocIDs:aLocIDs, 
			page: 1,
			rows: 999
		},function(rs){
			obj.myChart.hideLoading();    //隐藏加载动画
			obj.echartLocInfRatio(rs);
			obj.sortName="人均使用抗菌药物品种数"; //初始化排序指标
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