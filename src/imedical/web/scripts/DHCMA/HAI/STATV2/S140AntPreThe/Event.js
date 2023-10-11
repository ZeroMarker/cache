function InitS140AntPreTheWinEvent(obj){
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
		p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S140AntPreThe.raq&aHospIDs='+aHospID +'&aDateFrom=' + aDateFrom +'&aDateTo='+ aDateTo+'&aLocType='+aLocType+'&aQryCon='+aQryCon+'&aStatDimens='+aStatDimens+'&aLocIDs='+aLocIDs+'&aPath='+cspPath;	
		if(!ReportFrame.src){
			ReportFrame.frameElement.src=p_URL;
		}else{
			ReportFrame.src = p_URL;
		} 
		
	}
	obj.up=function(x,y){
        if(obj.sortName=="抗菌药物治疗使用人数"){
			return y.CureUseAntiCnt-x.CureUseAntiCnt;
		}else if(obj.sortName=="抗菌药物预防使用人数"){
			return y.PreUseAntiCnt-x.PreUseAntiCnt;
		}else if(obj.sortName=="抗菌药物预防使用率"){
			return y.PreUseAntiRatio-x.PreUseAntiRatio;
		}else{
			return y.CureUseAntiRatio-x.CureUseAntiRatio;
		}	   
    }
	obj.option1 = function(arrViewLoc,arrUseAntiCnt,arrCureUseAntiCnt,arrPreUseAntiCnt,arrUseAntiRatio,arrCureUseAntiRatio,arrPreUseAntiRatio,endnumber){
		var option = {
			title : {
				text: '抗菌药物预防治疗使用构成比统计图',
				textStyle:{
					fontSize:26
				},
				x:'center',
				y:'top'
			},
			grid:{
				left:'5%',
				top:'18%',	
				right:'5%',
				bottom:'5%',
				containLabel:true
			},
			legend: {
				dimensions: ['抗菌药物治疗使用人数', '抗菌药物预防使用人数','抗菌药物治疗使用率','抗菌药物预防使用率'],
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
			yAxis: [{
					type: 'value',
					name: '使用人数',
					min: 0,
					interval:10,
					axisLabel: {
						formatter: '{value} '
					}
				},
				{
					type: 'value',
					name: '使用率(%)',
					min: 0,
					interval:10,
					axisLabel: {
						formatter: '{value} %'
					}
				}
			],
			series: [
				/* {
					name:'抗菌药物使用人数',
					type:'bar',
					barMaxWidth:50,
					data:arrUseAntiCnt
				},*/
				 {
					name:'抗菌药物治疗使用人数',
					type:'bar',
					barMaxWidth:50,
					data:arrCureUseAntiCnt
				},
				 {
					name:'抗菌药物预防使用人数',
					type:'bar',
					barMaxWidth:50,
					data:arrPreUseAntiCnt
				},
				/*{
					name:'抗菌药物使用率',
					type:'line',
					yAxisIndex: 1,
					data:arrUseAntiRatio,
					label: {
						show:true,
						formatter:"{c}%"
					}
				},*/
				{
					name:'抗菌药物治疗使用率',
					type:'line',
					yAxisIndex: 1,
					data:arrCureUseAntiRatio,
					label: {
						show:true,
						formatter:"{c}%"
					}
				},
				{
					name:'抗菌药物预防使用率',
					type:'line',
					yAxisIndex: 1,
					data:arrPreUseAntiRatio,
					label: {
						show:true,
						formatter:"{c}%"
					}
				}
			]
		};
		return option;
	}
	
    obj.echartLocInfRatio = function(runQuery){
		if (!runQuery) return;	
		var aStatDimens = $('#cboShowType').combobox('getValue');  //展示维度
		var arrViewLoc 			= new Array();
		var arrUseAntiCnt 		= new Array();		//同期全身应用抗菌药物的人数	
		var arrCureUseAntiCnt 	= new Array();
		var arrPreUseAntiCnt 	= new Array();
		var arrUseAntiRatio		= new Array();
		var arrCureUseAntiRatio	= new Array();
		var arrPreUseAntiRatio	= new Array();
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
			rd["DimensDesc"] 		= $.trim(rd["DimensDesc"]); //去掉空格
			rd["UseAntiRatio"] 		= parseFloat(rd["UseAntiRatio"].replace('%','').replace('‰','')).toFixed(2);
			rd["CureUseAntiRatio"] 	= parseFloat(rd["CureUseAntiRatio"].replace('%','').replace('‰','')).toFixed(2);
			rd["PreUseAntiRatio"] 	= parseFloat(rd["PreUseAntiRatio"].replace('%','').replace('‰','')).toFixed(2);
		}
		
		arrRecord = arrRecord.sort(obj.up);
		arrRecord.length = arrRecord.length - arrlength;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			if(rd==undefined){   //去掉全院、医院、科室组后,会有数据变为undefined
					continue;
			}else{
				arrViewLoc.push(rd["DimensDesc"]);
				arrUseAntiCnt.push(rd["UseAntiCnt"]);
				arrUseAntiRatio.push(rd["UseAntiRatio"]);
				arrCureUseAntiCnt.push(rd["CureUseAntiCnt"]);
				arrCureUseAntiRatio.push(rd["CureUseAntiRatio"]);
				arrPreUseAntiCnt.push(rd["PreUseAntiCnt"]);
				arrPreUseAntiRatio.push(rd["PreUseAntiRatio"]);
	
			}
		}
		var endnumber = (14/arrViewLoc.length)*100;
		// 使用刚指定的配置项和数据显示图表。
		obj.myChart.setOption(obj.option1(arrViewLoc,arrUseAntiCnt,arrCureUseAntiCnt,arrPreUseAntiCnt,arrUseAntiRatio,arrCureUseAntiRatio,arrPreUseAntiRatio,endnumber),true);
	}
   	obj.ShowEChaert1 = function(){
		obj.myChart.clear()
		 //当月科室感染率图表
		var aHospID     = $('#cboHospital').combobox('getValues').join('|');
		var aDateFrom   = $('#dtDateFrom').datebox('getValue');
		var aDateTo     = $('#dtDateTo').datebox('getValue');
		var aLocType    = Common_CheckboxValue('chkStatunit');
		var aQryCon 	= $('#cboQryCon').combobox('getValue');
        var aStatDimens = $('#cboShowType').combobox('getValue');
		var aLocIDs 	= $('#cboLoc').combobox('getValues').join(',');	
		
		obj.myChart.showLoading();	//隐藏加载动画
		$cm({
			ClassName:"DHCHAI.STATV2.S140AntPreThe",
			QueryName:"QryHospAntPreThe",
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
			
			obj.sortName="抗菌药物治疗使用率"; //初始化排序指标
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