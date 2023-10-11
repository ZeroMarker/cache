function InitImpSubRateWinEvent(obj){	 
   	obj.LoadEvent = function(args){
			
		$('#ReportFrame').css('display', 'block');
		setTimeout(function(){
			obj.ShowReport();
		},50);

		//图的点击事件
		$('#btnSearchChart').on('click',function(e,value){
			$('#EchartDiv').css('display', 'block');
			$('#ReportFrame').css('display', 'none');
			obj.myChart = echarts.init(document.getElementById('EchartDiv'),'theme');
			obj.IsShowReport=0
			obj.ShowEChaert();
		});
		
		//表的点击事件
		$('#btnSearchTable').on('click',function(e,value){
			$('#ReportFrame').css('display', 'block');
			$('#EchartDiv').css('display', 'none');
			obj.IsShowReport=1
			obj.ShowReport();
		});
   	}
	
	$("#KeyWords").keywords({
         onClick:function(item){  //update 20230328 onSelect单选时不支持老版hisui的项目
	        var index=item.id;
			if (index==1){
				$("#SubDateType_tr").removeAttr("style");
				$("#SubHourType_tr").removeAttr("style");
				$("#LabTestSet_tr").removeAttr("style");
				$("#useSubDateType_tr").removeAttr("style");
				if ($('#btnMore').hasClass('expanded')) {
					$("#LabTestSet_div").css('height','190px');				
				}else {				
					$("#LabTestSet_div").css('height','30px');
				}
				ComboLabTestSet("cboLabTestSet2",2,1);
				obj.Type=1;
				if (obj.IsShowReport==1) {
					obj.ShowReport();
				}else {
					obj.ShowEChaert();
				}
			}
			if (index==2){
				$("#SubDateType_tr").css('display','none');
				$("#SubHourType_tr").css('display','none');
				$("#useSubDateType_tr").css('display','none');
				if (obj.IsMarkCount!=1) {
					$("#LabTestSet_tr").css('display','none');
					$("#cboLabTestSet2").combobox('clear');
				}else {
					$("#LabTestSet_tr").removeAttr("style");
					ComboLabTestSet("cboLabTestSet2",2,1);
				}
				if ($('#btnMore').hasClass('expanded')) {
					if (obj.IsMarkCount!=1) {
						$("#LabTestSet_div").css('height','150px');
					}else {
						$("#LabTestSet_div").css('height','190px');				
					}
				}else {				
					$("#LabTestSet_div").css('height','30px');
				}
				obj.Type=2;
				if (obj.IsShowReport==1) {
					obj.ShowReport();
				}else {
					obj.ShowEChaert();
				}
			}	
			if (index==3){
				$("#SubDateType_tr").removeAttr("style");
				$("#SubHourType_tr").removeAttr("style");
				$("#LabTestSet_tr").removeAttr("style");
				$("#LabTestSet_div").css('height','195px');
				ComboLabTestSet("cboLabTestSet2",2,1);
				$("#useSubDateType_tr").css('display','none');
				//使用前送检时长设置
	            $HUI.combobox("#cboSubHourType",{
	            	data:[
			            {value:'0',text:'无限制',selected:true},
			            {value:'1',text:'24H'},
			            {value:'2',text:'48H'},
						{value:'3',text:'72H'},
						{value:'4',text:'7天'},
						{value:'5',text:'14天'}
		            ],
					valueField:'value',
					textField:'text'
	            })
				if ($('#btnMore').hasClass('expanded')) {
					$("#LabTestSet_div").css('height','190px');				
				}else {				
					$("#LabTestSet_div").css('height','30px');
				}
				obj.Type=3;
				if (obj.IsShowReport==1) {
					obj.ShowReport();
				}else {
					obj.ShowEChaert();
				}
			}
		}
	});
	//展开按钮
	$('#btnMore').on('click', function(){ 	
		if ($(this).hasClass('expanded')){  //已经展开 隐藏
			$(this).removeClass('expanded');
			$("#btnMore")[0].innerText="展开";
			$('#MSearchItem').css('display','none');
			$("#LabTestSet_div").css('height','30px');
		}else{
			$(this).addClass('expanded');
			$("#btnMore")[0].innerText="隐藏";
			$('#MSearchItem').css('display','block');
			$("#LabTestSet_div").css('height','190px');
		}
	});
   	obj.ShowReport = function() {
		var aHospID 	= $('#cboHospital').combobox('getValues').join('|');	
		var aDateFrom 	= $('#dtDateFrom').datebox('getValue');
		var aDateTo		= $('#dtDateTo').datebox('getValue');
		var aSubDateType = $('#cboSubDateType').combobox('getValue');
		var aSubHourType = $('#cboSubHourType').combobox('getValue');
		var aLocType 	= Common_CheckboxValue('chkStatunit');
		var aQryCon 	= $('#cboQryCon').combobox('getValue');
		var aStatDimens = $('#cboShowType').combobox('getValue');
		var aLocIDs 	= $('#cboLoc').combobox('getValues').join(',');	

		var LabTestSet1 = $('#cboLabTestSet1').combobox('getValues');
		var LabTestSet2 = $('#cboLabTestSet2').combobox('getValues');
		var LabTestSet3 = $('#cboLabTestSet3').combobox('getValues');
		var LabTestSet4 = $('#cboLabTestSet4').combobox('getValues');
		var LabTestSet ='';
		if (LabTestSet1!="") {
			LabTestSet=LabTestSet1;
		}else{
			LabTestSet=LabTestSet;
		}
	    if (LabTestSet2!="") {
			if (LabTestSet!="") {
				LabTestSet=LabTestSet+","+LabTestSet2;
			}else {
				LabTestSet=LabTestSet2;
			}
		}else{
			LabTestSet=LabTestSet;
		}
		if (LabTestSet3!="") {
			if (LabTestSet!="") {
				LabTestSet=LabTestSet+","+LabTestSet3;
			}else {
				LabTestSet=LabTestSet3;
			}
		}else{
			LabTestSet=LabTestSet;
		}
		if (LabTestSet4!="") {
			if (LabTestSet!="") {
				LabTestSet=LabTestSet+","+LabTestSet4;
			}else {
				LabTestSet=LabTestSet4;
			}
		}else{
			LabTestSet=LabTestSet;
		}
		
		ReportFrame = document.getElementById("ReportFrame");
		if(aDateFrom > aDateTo){
			$.messager.alert("提示","开始日期应小于或等于结束日期！", 'info');
			return;
		}
		if ((aDateFrom=="")||(aDateTo=="")){
			$.messager.alert("提示","请选择开始日期、结束日期！", 'info');
			return;
		}
		if ((LabTestSet1=="")&&(LabTestSet2=="")&&(LabTestSet3=="")&&(LabTestSet4=="")){
			$.messager.alert("提示","至少选择一项病原学送检项目！", 'info');
			return;
		}
		
		if (obj.Type==1) {
			p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.SpeActOutAntSub.raq&aHospIDs='+aHospID +'&aDateFrom=' + aDateFrom +'&aDateTo='+ aDateTo+'&aLocType='+aLocType+'&aSubDateType='+aSubDateType+'&aSubHourType='+aSubHourType+'&aLabTestSet='+LabTestSet+'&aQryCon='+aQryCon+'&aStatDimens='+aStatDimens+'&aLocIDs='+aLocIDs+'&aPath='+cspPath;		
		}else if(obj.Type==2) {
			p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.SpeActOutInfSub.raq&aHospIDs='+aHospID +'&aDateFrom=' + aDateFrom +'&aDateTo='+ aDateTo+'&aLocType='+aLocType+'&aLabTestSet='+LabTestSet+'&aQryCon='+aQryCon+'&aStatDimens='+aStatDimens+'&aLocIDs='+aLocIDs+'&aPath='+cspPath;	
		}else if(obj.Type==3) {
			p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.SpeActOutAntComb.raq&aHospIDs='+aHospID +'&aDateFrom=' + aDateFrom +'&aDateTo='+ aDateTo+'&aLocType='+aLocType+'&aSubDateType='+aSubDateType+'&aSubHourType='+aSubHourType+'&aLabTestSet='+LabTestSet+'&aQryCon='+aQryCon+'&aStatDimens='+aStatDimens+'&aLocIDs='+aLocIDs+'&aPath='+cspPath;	
		}
		if(!ReportFrame.src){
			ReportFrame.frameElement.src=p_URL;
		}else{
			ReportFrame.src = p_URL;
		} 
	}
	
	obj.up=function(x,y){
		if (obj.Type==1) {
			if(obj.sortName=="使用人数"){
				return y.CureUseAntiCnt-x.CureUseAntiCnt;
			}else if(obj.sortName=="送检人数"){
				return y.BfCureSubmissCnt-x.BfCureSubmissCnt;
			}else {
				return y.BfCureSubRatio-x.BfCureSubRatio;
			}
		}else if(obj.Type==2) {
			if(obj.sortName=="感染人数"){
				return y.InfPatCnt-x.InfPatCnt;
			}else if(obj.sortName=="送检人数"){
				return y.InfSubCnt-x.InfSubCnt;
			}else {
				return y.InfSubRatio-x.InfSubRatio;
			}
			
		}else if(obj.Type==3) {
			if(obj.sortName=="联合用药"){
				return y.CombUseCnt-x.CombUseCnt;
			}else if(obj.sortName=="送检人数"){
				return y.BfCureSubCnt-x.BfCureSubCnt;
			}else {
				return y.BfCureSubRatio-x.BfCureSubRatio;
			}
		}
    }
	obj.option1 = function(arrViewLoc,arrCureUseAntiCnt,arrBfCureSubmissCnt,arrBfCureSubRatio,endnumber){
		var option1 = {
			title : {
				text: '出院患者抗菌药物治疗前病原学送检率统计图',
				textStyle:{
					fontSize:28
				},
				x:'center',
				y:'top'
			},
			grid:{
				left:'5%',
				top:'13%',	
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
				data:['使用人数','送检人数','送检率'],
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
					name: '使用人数',
					min: 0,
					interval:10,
					axisLabel: {
						formatter: '{value} '
					}
				},
				{
					type: 'value',
					name: '送检率(%)',
					min: 0,
					interval:10,
					axisLabel: {
						formatter: '{value} %'
					}
				}
			],
			series: [
				{
					name:'使用人数',
					type:'bar',
					barMaxWidth:50,
					data:arrCureUseAntiCnt
				},
				 {
					name:'送检人数',
					type:'bar',
					barMaxWidth:50,
					data:arrBfCureSubmissCnt
				},
				{
					name:'送检率',
					type:'line',
					yAxisIndex: 1,
					data:arrBfCureSubRatio,
					label: {
						show:true,
						formatter:"{c}%"
					}
				}
			]
		};
		return option1;
	}
	
	obj.option2 = function(arrViewLoc,arrInfPatCnt,arrInfSubCnt,arrInfSubRatio,endnumber){
		var option1 = {
			title : {
				text: '出院患者医院感染诊断相关病原学送检率统计图',
				textStyle:{
					fontSize:28
				},
				x:'center',
				y:'top'
			},
			grid:{
				left:'5%',
				top:'13%',	
				right:'5%',
				bottom:'5%',
				containLabel:true
			},
			tooltip: {
				trigger: 'axis',
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
				data:['感染人数','送检人数','送检率'],
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
					name: '感染人数',
					min: 0,
					interval:Math.ceil(arrInfPatCnt[0]/10),
					axisLabel: {
						formatter: '{value} '
					}
				},
				{
					type: 'value',
					name: '送检率(%)',
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
					data:arrInfPatCnt
				},
				 {
					name:'送检人数',
					type:'bar',
					barMaxWidth:50,
					data:arrInfSubCnt
				},
				{
					name:'送检率',
					type:'line',
					yAxisIndex: 1,
					data:arrInfSubRatio,
					label: {
						show:true,
						formatter:"{c}%"
					}
				}
			]
		};
		return option1;
	}
	
	obj.option3 = function(arrViewLoc,arrCombUseCnt,arrBfCureSubCnt,arrBfCureSubRatio,endnumber){
		var option1 = {
			title : {
				text: '出院患者抗菌药物治疗前病原学送检率统计图',
				textStyle:{
					fontSize:28
				},
				x:'center',
				y:'top'
			},
			grid:{
				left:'5%',
				top:'13%',	
				right:'5%',
				bottom:'5%',
				containLabel:true
			},
			tooltip: {
				trigger: 'axis',
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
				data:['联合用药人数','送检人数','送检率'],
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
					name: '联合用药人数',
					min: 0,
					interval:Math.ceil(arrCombUseCnt[0]/10),
					axisLabel: {
						formatter: '{value} '
					}
				},
				{
					type: 'value',
					name: '送检率(%)',
					min: 0,
					interval:10,
					axisLabel: {
						formatter: '{value} %'
					}
				}
			],
			series: [
				 {
					name:'联合用药人数',
					type:'bar',
					barMaxWidth:50,
					data:arrCombUseCnt
				},
				 {
					name:'送检人数',
					type:'bar',
					barMaxWidth:50,
					data:arrBfCureSubCnt
				},
				{
					name:'送检率',
					type:'line',
					yAxisIndex: 1,
					data:arrBfCureSubRatio,
					label: {
						show:true,
						formatter:"{c}%"
					}
				}
			]
		};
		return option1;
	}
	
   	obj.ShowEChaert = function(){
		obj.myChart.clear()
		 //送检率图表
		
		var aHospID 	= $('#cboHospital').combobox('getValues').join('|');	
		var aDateFrom 	= $('#dtDateFrom').datebox('getValue');
		var aDateTo		= $('#dtDateTo').datebox('getValue');
		var aSubDateType = $('#cboSubDateType').combobox('getValue');
		var aSubHourType = $('#cboSubHourType').combobox('getValue');
		var aLocType 	= Common_CheckboxValue('chkStatunit');
		var aQryCon 	= $('#cboQryCon').combobox('getValue');
		var aStatDimens = $('#cboShowType').combobox('getValue');
		var aLocIDs 	= $('#cboLoc').combobox('getValues').join(',');	
		var LabTestSet1 = $('#cboLabTestSet1').combobox('getValues');
		var LabTestSet2 = $('#cboLabTestSet2').combobox('getValues');
		var LabTestSet3 = $('#cboLabTestSet3').combobox('getValues');
		var LabTestSet4 = $('#cboLabTestSet4').combobox('getValues');
		var LabTestSet ='';
		if (LabTestSet1!="") {
			LabTestSet=LabTestSet1;
		}else{
			LabTestSet=LabTestSet;
		}
	    if (LabTestSet2!="") {
			if (LabTestSet!="") {
				LabTestSet=LabTestSet+","+LabTestSet2;
			}else {
				LabTestSet=LabTestSet2;
			}
		}else{
			LabTestSet=LabTestSet;
		}
		if (LabTestSet3!="") {
			if (LabTestSet!="") {
				LabTestSet=LabTestSet+","+LabTestSet3;
			}else {
				LabTestSet=LabTestSet3;
			}
		}else{
			LabTestSet=LabTestSet;
		}
		if (LabTestSet4!="") {
			if (LabTestSet!="") {
				LabTestSet=LabTestSet+","+LabTestSet4;
			}else {
				LabTestSet=LabTestSet4;
			}
		}else{
			LabTestSet=LabTestSet;
		}
		
		if (obj.Type==1) {
			obj.myChart.showLoading();	//隐藏加载动画
			$cm({
				ClassName:"DHCHAI.STATV2.SpeActOutAntSub",
				QueryName:"QryAntTheSub",
				aHospIDs:aHospID, 
				aDateFrom:aDateFrom, 
				aDateTo:aDateTo, 
				aLocType:aLocType,
				aSubDateType:aSubDateType,
				aSubHourType:aSubHourType,
				aLabTestSet:LabTestSet,
				aQryCon:aQryCon,
				aUseSubDateType:aSubDateType, 
				aStatDimens:aStatDimens, 
				aLocIDs:aLocIDs,
				page: 1,
				rows: 999
			},function(rs){
				obj.myChart.hideLoading();    //隐藏加载动画
				obj.echartAntSubRatio(rs);
			
				obj.sortName="送检率"; //初始化排序指标
				obj.myChart.off('legendselectchanged'); //取消事件，避免事件绑定重复导致多次触发
				obj.myChart.on('legendselectchanged', function(legObj){
					//处理排序问题 
					//如果是重复点击认为是需要执行隐藏处理,不想隐藏就不用判断了	
					if(obj.sortName!=legObj.name){
						obj.sortName=legObj.name;
						obj.echartAntSubRatio(rs);
					}else {
						obj.sortName="";  //初始化
					}
				});
			});
		}else if(obj.Type==2) {
			obj.myChart.showLoading();	//隐藏加载动画
			$cm({
				ClassName:"DHCHAI.STATV2.SpeActOutInfSub",
				QueryName:"QryInfSub",
				aHospIDs:aHospID, 
				aDateFrom:aDateFrom, 
				aDateTo:aDateTo, 
				aLocType:aLocType,
				aLabTestSet:LabTestSet,
				aQryCon:aQryCon,
				aStatDimens:aStatDimens, 
				aLocIDs:aLocIDs,
				page: 1,
				rows: 999
			},function(rs){
				obj.myChart.hideLoading();    //隐藏加载动画
				obj.echartInfSubRatio(rs);
				
				obj.sortName="送检率"; //初始化排序指标
				obj.myChart.off('legendselectchanged'); //取消事件，避免事件绑定重复导致多次触发
				obj.myChart.on('legendselectchanged', function(legObj){
					//处理排序问题 
					//如果是重复点击认为是需要执行隐藏处理,不想隐藏就不用判断了	
					if(obj.sortName!=legObj.name){
						obj.sortName=legObj.name;
						obj.echartInfSubRatio(rs);
					}else {
						obj.sortName="";  //初始化
					}
				});
			});
		}else if(obj.Type==3) {
			obj.myChart.showLoading();	//隐藏加载动画	
			$cm({
				ClassName:"DHCHAI.STATV2.SpeActOutAntComb",
				QueryName:"QryAntComb",
				aHospIDs:aHospID, 
				aDateFrom:aDateFrom, 
				aDateTo:aDateTo, 
				aLocType:aLocType,
				aSubDateType:aSubDateType,
				aSubHourType:aSubHourType,
				aLabTestSet:LabTestSet,
				aQryCon:aQryCon,
				aStatDimens:aStatDimens, 
				aLocIDs:aLocIDs,
				page: 1,
				rows: 999
			},function(rs){
				obj.myChart.hideLoading();    //隐藏加载动画
				obj.echartAntCombRatio(rs);
				obj.sortName="送检率"; //初始化排序指标
				obj.myChart.off('legendselectchanged'); //取消事件，避免事件绑定重复导致多次触发
				obj.myChart.on('legendselectchanged', function(legObj){
					//处理排序问题 
					//如果是重复点击认为是需要执行隐藏处理,不想隐藏就不用判断了	
					if(obj.sortName!=legObj.name){
						obj.sortName=legObj.name;
						obj.echartAntCombRatio(rs);
					}else {
						obj.sortName="";  //初始化
					}
				});
				
			});
		}
	}
	
	//1抗菌药物治疗前病原学送检率
	obj.echartAntSubRatio = function(runQuery){
		if (!runQuery) return;
		var aStatDimens = $('#cboShowType').combobox('getValue');  //展示维度

		var arrViewLoc 			= new Array();
		var arrCureUseAntiCnt   = new Array();		//使用人数
		var arrBfCureSubmissCnt = new Array();		//送检人数
		var arrBfCureSubRatio 	= new Array();
		arrRecord 		= runQuery.rows;
		
		var arrlength		= 0;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			//去掉全院、医院、科室组、科室合计
			if ((rd["DimensKey"].indexOf('-A-')>-1)||((aStatDimens!="H")&&(rd["DimensKey"].indexOf('-H-')>-1))||((aStatDimens!="G")&&(aStatDimens!="HG")&&(rd["DimensKey"].indexOf('-G-')>-1))||(!rd["DimensKey"])) {
				delete arrRecord[indRd];
				arrlength = arrlength + 1;
				continue;
			}
			rd["DimensDesc"] = $.trim(rd["DimensDesc"]); //去掉空格
			rd["BfCureSubRatio"] = parseFloat(rd["BfCureSubRatio"].replace('%','').replace('‰','')).toFixed(2);
		}
		
		arrRecord = arrRecord.sort(obj.up);
		arrRecord.length = arrRecord.length - arrlength;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			
			arrViewLoc.push(rd["DimensDesc"]);
			arrCureUseAntiCnt.push(rd["CureUseAntiCnt"]);
			arrBfCureSubmissCnt.push(rd["BfCureSubmissCnt"]);
			arrBfCureSubRatio.push(parseFloat(rd["BfCureSubRatio"]).toFixed(2));
			
		}
		var endnumber = (14/arrViewLoc.length)*100;
		// 使用刚指定的配置项和数据显示图表。
		obj.myChart.setOption(obj.option1(arrViewLoc,arrCureUseAntiCnt,arrBfCureSubmissCnt,arrBfCureSubRatio,endnumber),true);
	}
	
	//2医院感染诊断相关病原学送检率
	obj.echartInfSubRatio = function(runQuery){
		if (!runQuery) return;
		var aStatDimens = $('#cboShowType').combobox('getValue');  //展示维度

		var arrViewLoc 		= new Array();
		var arrInfPatCnt    = new Array();		//感染人数
		var arrInfSubCnt    = new Array();		//送检人数
		var arrInfSubRatio 	= new Array();
		arrRecord 		= runQuery.rows;
		
		var arrlength		= 0;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			//去掉全院、医院、科室组、科室合计
			if ((rd["DimensKey"].indexOf('-A-')>-1)||((aStatDimens!="H")&&(rd["DimensKey"].indexOf('-H-')>-1))||((aStatDimens!="G")&&(aStatDimens!="HG")&&(rd["DimensKey"].indexOf('-G-')>-1))||(!rd["DimensKey"])) {
				delete arrRecord[indRd];
				arrlength = arrlength + 1;
				continue;
			}
			rd["DimensDesc"] = $.trim(rd["DimensDesc"]); //去掉空格
			rd["InfSubRatio"] = parseFloat(rd["InfSubRatio"].replace('%','').replace('‰','')).toFixed(2);
		}
		
		arrRecord = arrRecord.sort(obj.up);
		arrRecord.length = arrRecord.length - arrlength;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			
			arrViewLoc.push(rd["DimensDesc"]);
			arrInfPatCnt.push(rd["InfPatCnt"]);
			arrInfSubCnt.push(rd["InfSubCnt"]);
			arrInfSubRatio.push(parseFloat(rd["InfSubRatio"]).toFixed(2));
			
		}
		var endnumber = (14/arrViewLoc.length)*100;
		// 使用刚指定的配置项和数据显示图表。
		obj.myChart.setOption(obj.option2(arrViewLoc,arrInfPatCnt,arrInfSubCnt,arrInfSubRatio,endnumber),true);
	}
	
	//3联合使用重点药物前病原学送检率
	obj.echartAntCombRatio = function(runQuery){
		if (!runQuery) return;
		var aStatDimens = $('#cboShowType').combobox('getValue');  //展示维度

		var arrViewLoc 			= new Array();
		var arrCombUseCnt       = new Array();		//联用人数
		var arrBfCureSubCnt     = new Array();		//送检人数
		var arrBfCureSubRatio 	= new Array();
		arrRecord 		= runQuery.rows;
	  
		var arrlength		= 0;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			//去掉全院、医院、科室组、科室合计
			if ((rd["DimensKey"].indexOf('-A-')>-1)||((aStatDimens!="H")&&(rd["DimensKey"].indexOf('-H-')>-1))||((aStatDimens!="G")&&(aStatDimens!="HG")&&(rd["DimensKey"].indexOf('-G-')>-1))||(!rd["DimensKey"])) {
				delete arrRecord[indRd];
				arrlength = arrlength + 1;
				continue;
			}
			rd["DimensDesc"] = $.trim(rd["DimensDesc"]); //去掉空格
			rd["BfCureSubRatio"] = parseFloat(rd["BfCureSubRatio"].replace('%','').replace('‰','')).toFixed(2);
		}
		
		arrRecord = arrRecord.sort(obj.up);
		arrRecord.length = arrRecord.length - arrlength;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			
			arrViewLoc.push(rd["DimensDesc"]);
			arrCombUseCnt.push(rd["CombUseCnt"]);
			arrBfCureSubCnt.push(rd["BfCureSubCnt"]);
			arrBfCureSubRatio.push(parseFloat(rd["BfCureSubRatio"]).toFixed(2));
			
		}
		var endnumber = (14/arrViewLoc.length)*100;
		// 使用刚指定的配置项和数据显示图表。
		obj.myChart.setOption(obj.option3(arrViewLoc,arrCombUseCnt,arrBfCureSubCnt,arrBfCureSubRatio,endnumber),true);
	}
	
}