//十三项指标Event
function InitThirteenIndexWinEvent(obj){
	obj.LoadEvent = function(args){
		obj.Year="";
		obj.Month="";
		obj.DateFrom="";
		obj.DateTo="";
		obj.Index=14;
		RepCode ="IIHAI-1";											//帮助文档
		
		$('#ReportFrame').css('display', 'block'); 
   	    obj.LoadLeft();
   	    setTimeout(function () {
	   	    //obj.LoadLeft();
   	        obj.LoadRep();
   	    }, 50);
	}
	//关键词方式
	$("#KeyWords").keywords({
        onSelect:function(item){
			var index=item.id;
			obj.Year=$('#cboYear').combobox('getValue');
			obj.Month=$('#cboMonth').combobox('getValue');
			obj.DateFrom=$('#dtDateFrom').datebox('getValue');
			obj.DateTo=$('#dtDateTo').datebox('getValue');
			if(index==5){
				$('#LeftDiv').html(obj.html_2);
				//帮助文档
				RepCode ="IIHAI-55";
			}
			else if(index==7){
				$('#LeftDiv').html(obj.html_3);
				//帮助文档
				RepCode ="IIHAI-40";
			}
			else{
				$('#LeftDiv').html(obj.html_1);
				//帮助文档
				if(index==13) RepCode ="IIHAI-1";
				if(index==1) RepCode ="IIHAI-6";
				if(index==2) RepCode ="IIHAI-53";
				if(index==3) RepCode ="IIHAI-23";
				if(index==4) RepCode ="IIHAI-24";
				if(index==6) RepCode ="IIHAI-33";
				if(index==8) RepCode ="IIHAI-8";
				if(index==9) RepCode ="IIHAI-46";
				if(index==10) RepCode ="IIHAI-14";
				if(index==11) RepCode ="IIHAI-15";
				if(index==12) RepCode ="IIHAI-13";
			}
			$.parser.parse('#LeftDiv');
			obj.Index=index+1;		//赋值
			obj.LoadLeft();
			if(obj.ChartType==2){				
				setTimeout(function () {
			   	    obj.ShowEChart();
		   	    }, 50);
			}
			else{
				setTimeout(function () {
			   	    obj.LoadRep();
		   	    }, 50);
			}
		}
	});

	//初始化左侧查询
	obj.LoadLeft=function(){
		//Common_ComboToSSHosp("cboHospital",$.LOGON.HOSPID);		//初始化院区
		var YearList = $cm ({									//初始化年(最近十年)
			ClassName:"DHCHAI.STATV2.AbstractComm",
			QueryName:"QryYear"
		},false);
		$HUI.combobox("#cboYear",{
			valueField:'ID',
			textField:'Desc',
			editable:false,
			data:YearList.rows,
			onSelect:function(rec){
				Date_QuickSelect("cboYear","cboMonth","dtDateFrom","dtDateTo");	//更改开始-结束日期
			}
		});
		var MonthList = $cm ({									//初始化月+季度+全年
			ClassName:"DHCHAI.STATV2.AbstractComm",
			QueryName:"QryMonth"
		},false);
		$HUI.combobox("#cboMonth",{
			valueField:'ID',
			textField:'Desc',
			editable:false,
			data:MonthList.rows,
			onSelect:function(rec){
				Date_QuickSelect("cboYear","cboMonth","dtDateFrom","dtDateTo");	//更改开始-结束日期
			}
		});
		var NowDate=month_formatter(new Date());
		var NowYear=NowDate.split("-")[0];	//当前年
		var NowMonth=NowDate.split("-")[1]	//当前月
		$('#cboYear').combobox('select',NowYear);
		$('#cboMonth').combobox('select',NowMonth);
			
		if((obj.DateFrom!="")&&(obj.DateTo!="")){
			$('#cboYear').combobox('select',obj.Year);
			$('#cboMonth').combobox('select',obj.Month);
			$('#dtDateFrom').datebox('setValue',obj.DateFrom); 
			$('#dtDateTo').datebox('setValue', obj.DateTo); 
		}
		if(obj.Index==6){		//手卫生依从性调查表
			//加载调查方式下拉框
			$HUI.combobox("#cboMethod",{
				url:$URL+'?ClassName=DHCHAI.BTS.DictionarySrv&QueryName=QryDic&ResultSetType=Array&aTypeCode='+"HandHyObsMethod",
				valueField:'ID',
				textField:'DicDesc'
			});
			Common_ComboDicID("cboObsType","HandHyObsType");
			//图的点击事件
			$('#btnSearchChart').on('click',function(e,value){
				$('#EchartDiv').css('display', 'block');
				$('#ReportFrame').css('display', 'none');
				obj.myChart = echarts.init(document.getElementById('EchartDiv'),'theme');
				obj.ShowEChart();
			});
			//表的点击事件
			$('#btnSearchTable').on('click',function(e,value){
				$('#ReportFrame').css('display', 'block');
				$('#EchartDiv').css('display', 'none');
				obj.LoadRep();
			});
		}
		else{		//治疗前病原学送检率
			if(obj.Index==8){
				//送检时间类型设置
				$HUI.combobox("#cboSubDateType",{
					data:[
						{value:'1',text:'采样时间',selected:true},
						{value:'2',text:'下检验医嘱日期'}
					],
					valueField:'value',
					textField:'text'
				})
				//用药时间类型设置
				$HUI.combobox("#useSubDateType",{
					data:[
						{value:'1',text:'医嘱开始时间',selected:true},
						{value:'2',text:'护士执行时间'}
						],
						valueField:'value',
						textField:'text'
				})
				
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
			}
			Common_ComboDicCode("cboQryCon","StatScreenCondition");		//筛选条件
			$('#cboQryCon').combobox('setValue',1);
			$('#cboQryCon').combobox('setText',"显示全部病区(科室)");
		
			$HUI.radio("#chkStatunit-Ward").setValue(true);				//统计单位
			var unitConfig = $m({
				ClassName: "DHCHAI.BT.Config",
				MethodName: "GetValByCode",
				aCode: "StatV2ScreenuUnit",
				aHospDr: $.LOGON.HOSPID
			},false);
			if (unitConfig) {
				if (unitConfig == 'E') {
					$HUI.radio("#chkStatunit-Loc").setValue(true);
				}
			}
		}
		/*
		//图的点击事件
		$('#btnSearchChart').on('click',function(e,value){
			$('#EchartDiv').css('display', 'block');
			$('#ReportFrame').css('display', 'none');
			obj.myChart = echarts.init(document.getElementById('EchartDiv'),'theme');
			obj.ShowEChart();
		});
		*/
		//表的点击事件
		$('#btnSearchTable').on('click',function(e,value){
			$('#ReportFrame').css('display', 'block');
			$('#EchartDiv').css('display', 'none');
			obj.LoadRep();
		});
	}
	//加载表
   	obj.LoadRep = function(){
	   	obj.ChartType=1;
	   	
	   	var aHospID 	= $.LOGON.LOCID;	//"72"  -产科 院区 $('#cboHospital').combobox('getValue')
		var aDateFrom 	= $('#dtDateFrom').datebox('getValue');		//开始日期
		var aDateTo		= $('#dtDateTo').datebox('getValue');		//结束日期
		if(aDateFrom > aDateTo){
			$.messager.alert("提示","开始日期应小于或等于结束日期！", 'info');
			return;
		}
		if ((aDateFrom=="")||(aDateTo=="")){
			$.messager.alert("提示","请选择开始日期、结束日期！", 'info');
			return;
		}
	   	//1->医院感染发病（例次）率
	   	if(obj.Index==14){
			var aLocType 	=  xLocType; //Common_CheckboxValue('chkStatunit');
			var aQrycon 	=  "9999"; //1 全部数据 2-有数据 9999-约定为临床医生报表打开
			ReportFrame = document.getElementById("ReportFrame");
			//p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S010Inf.raq&aHospIDs='+aHospID +'&aDateFrom=' + aDateFrom +'&aDateTo='+ aDateTo+'&aLocType='+aLocType+'&aQryCon='+aQrycon+'&aLocIDs='+$.LOGON.LOCID;		
			p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S010Inf.raq&aHospIDs='+aHospID +'&aDateFrom=' + aDateFrom +'&aDateTo='+ aDateTo+'&aLocType='+aLocType+'&aQryCon='+aQrycon+'&aStatDimens='+'&aLocIDs='+$.LOGON.LOCID+'&aPath='+cspPath;	
		}
		//2->医院感染现患（例次）率
		if(obj.Index==2){
			var aLocType 	= xLocType;  //Common_CheckboxValue('chkStatunit');
			var aQrycon 	=  "9999"; //$('#cboQryCon').combobox('getValue');
			ReportFrame = document.getElementById("ReportFrame");
			//p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S030InfPre.raq&aDateFrom=' + aDateFrom +'&aDateTo='+ aDateTo +'&aHospIDs='+aHospID +'&aLocIDs='+'' +'&aLocType='+ aLocType +'&aQryCon='+ aQrycon+'&aLocIDs='+$.LOGON.LOCID;
			p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S030InfPre.raq&aDateFrom=' + aDateFrom +'&aDateTo='+ aDateTo +'&aHospIDs='+aHospID +'&aLocType='+ aLocType +'&aQryCon='+ aQrycon+'&aStatDimens='+'&aLocIDs='+$.LOGON.LOCID+'&aPath='+cspPath;
		}
		//3->医院感染病例漏报率统计表
		if(obj.Index==3){
			var aLocType 	= xLocType;  //Common_CheckboxValue('chkStatunit');
			var aQrycon 	= "9999"; // $('#cboQryCon').combobox('getValue');
			ReportFrame = document.getElementById("ReportFrame");
			//p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S370InfMisRep.raq&aHospIDs=' + aHospID + '&aDateFrom=' + aDateFrom + '&aDateTo=' + aDateTo + '&aLocType=' + aLocType + '&aQryCon=' + aQrycon+'&aLocIDs='+$.LOGON.LOCID;
			p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S370InfMisRep.raq&aHospIDs=' + aHospID + '&aDateFrom=' + aDateFrom +'&aDateTo='+ aDateTo+'&aLocType='+aLocType+'&aQryCon='+aQrycon+'&aStatDimens='+'&aLocIDs='+$.LOGON.LOCID+'&aPath='+cspPath;	
		}
		//4->多重耐药菌感染发现率统计表
		if(obj.Index==4){
			var aLocType 	= xLocType;  //Common_CheckboxValue('chkStatunit');
			var aQrycon 	= "9999"; // $('#cboQryCon').combobox('getValue');
			ReportFrame = document.getElementById("ReportFrame");
			p_URL = 'dhccpmrunqianreport.csp?reportName=DHCHAI.STATV2.ThirteenInd.STar004.raq&aHospIDs='+$.LOGON.HOSPID +'&aDateFrom=' + aDateFrom +'&aDateTo='+ aDateTo+'&aLocType='+aLocType+'&aQryCon='+aQrycon+'&aStatDimens='+''+'&aLocIDs='+$.LOGON.LOCID+'&aPath='+cspPath;		
		}
		//5->多重耐药菌检出率统计表
		if(obj.Index==5){
			var aLocType 	= xLocType;  //Common_CheckboxValue('chkStatunit');
			var aQrycon 	= "9999"; // $('#cboQryCon').combobox('getValue');
			ReportFrame = document.getElementById("ReportFrame");
			p_URL = 'dhccpmrunqianreport.csp?reportName=DHCHAI.STATV2.ThirteenInd.STar005.raq&aHospIDs='+$.LOGON.HOSPID +'&aDateFrom=' + aDateFrom +'&aDateTo='+ aDateTo+'&aLocType='+aLocType+'&aQryCon='+aQrycon+'&aStatDimens='+''+'&aLocIDs='+$.LOGON.LOCID+'&aPath='+cspPath;	
		}
		//6->医务人员手卫生依从率统计表
	   	if(obj.Index==6){
		   	//后台方法没有该参数 var aLocType 	= xLocType;  //Common_CheckboxValue('chkStatunit');
			//后台方法没有该参数 var aQrycon 	= "9999"; // $('#cboQryCon').combobox('getValue');
			//aHospID 值为临床科室ID
			var aMethod		= $('#cboMethod').datebox('getValue');
			var aObsType    = $('#cboObsType').datebox('getValue');
			ReportFrame = document.getElementById("ReportFrame");
			p_URL 		= 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S380HandHyCom.raq&aHospIDs='+'' +'&aDateFrom=' + aDateFrom +'&aDateTo='+ aDateTo +'&aMethod='+ aMethod+'&aObsType='+aObsType+'&aLocID='+aHospID+'&aLocIDs='+$.LOGON.LOCID;
		}
		//7->住院患者抗菌药物使用率统计表
		if(obj.Index==7){
			var aLocType 	= xLocType;  //Common_CheckboxValue('chkStatunit');
			var aQrycon 	= "9999"; // $('#cboQryCon').combobox('getValue');
			ReportFrame = document.getElementById("ReportFrame");
			p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S130AntUse.raq&aHospIDs='+$.LOGON.HOSPID +'&aDateFrom=' + aDateFrom +'&aDateTo='+ aDateTo+'&aLocType='+aLocType+'&aQryCon='+aQrycon+'&aStatDimens='+''+'&aLocIDs='+$.LOGON.LOCID+'&aPath='+cspPath;	
		}
		//8->住院患者抗菌药物治疗前病原学送检率统计表
		if(obj.Index==8){
			var aSubDateType 	= $('#cboSubDateType').combobox('getValue');
			var aSubHourType 	= $('#cboSubHourType').combobox('getValue');
			var aLocType 	= xLocType;  //Common_CheckboxValue('chkStatunit');
			var aQrycon 	= "9999"; // $('#cboQryCon').combobox('getValue');
			ReportFrame = document.getElementById("ReportFrame");
			p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S170AntTheSub.raq&aHospIDs='+$.LOGON.HOSPID +'&aDateFrom=' + aDateFrom +'&aDateTo='+ aDateTo+'&aSubDateType='+aSubDateType+'&aSubHourType='+aSubHourType+'&aLocType='+aLocType+'&aQryCon='+aQrycon+'&aUseSubDateType='+''+'&aStatDimens='+''+'&aLocIDs='+$.LOGON.LOCID+'&aLabSubType='+''+'&aPath='+cspPath;		
		}
		//9->Ⅰ类切口手术手术部位感染率统计表
		if(obj.Index==9){
			var aLocType 	= xLocType;  //Common_CheckboxValue('chkStatunit');
			var aQrycon 	= "9999"; // $('#cboQryCon').combobox('getValue');
			ReportFrame = document.getElementById("ReportFrame");
			//p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S240AIncInf.raq&aHospIDs='+aHospID +'&aDateFrom=' + aDateFrom +'&aDateTo='+ aDateTo +'&aStaType='+ aLocType +'&aQryCon='+ aQrycon+'&aLocIDs='+$.LOGON.LOCID;	
			p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S240AIncInf.raq&aHospIDs='+$.LOGON.HOSPID +'&aDateFrom=' + aDateFrom +'&aDateTo='+ aDateTo +'&aStaType='+ aLocType +'&aQryCon='+ aQrycon+'&aOperCat='+''+'&aStatDimens='+''+'&aLocIDs='+$.LOGON.LOCID+'&aPath='+cspPath;	

		}
		//10->Ⅰ类切口手术抗菌药物预防使用率统计表
		if(obj.Index==10){
			var aLocType 	= xLocType;  //Common_CheckboxValue('chkStatunit');
			var aQrycon 	= "9999"; // $('#cboQryCon').combobox('getValue');
			ReportFrame = document.getElementById("ReportFrame");
			//p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S260AIncAntUse.raq&aHospIDs='+aHospID +'&aDateFrom=' + aDateFrom +'&aDateTo='+ aDateTo +'&aStaType='+ aLocType +'&aQryCon='+ aQrycon+'&aLocIDs='+$.LOGON.LOCID;	
			p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S260AIncAntUse.raq&aHospIDs='+$.LOGON.HOSPID +'&aDateFrom=' + aDateFrom +'&aDateTo='+ aDateTo +'&aStaType='+ aLocType +'&aQryCon='+ aQrycon+'&aOperCat='+''+'&aStatDimens='+''+'&aLocIDs='+$.LOGON.LOCID+'&aPath='+cspPath;	

		}
		//11->血管导管相关血流感染发病率统计表
		if(obj.Index==11){
			var aLocType 	= xLocType;
			var aQrycon 	= "1"; // $('#cboQryCon').combobox('getValue');
			ReportFrame = document.getElementById("ReportFrame");
			var IsSplit = $m({
				ClassName: "DHCHAI.BT.Config",
				MethodName: "GetValByCode",
				aCode: "ICUPatLogSplit"
			},false);
			p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S300PICCInf.raq&aHospIDs='+$.LOGON.HOSPID +'&aDateFrom=' + aDateFrom +'&aDateTo='+ aDateTo+'&aLocType='+aLocType+'&aQryCon='+aQrycon+'&aStatDimens='+''+'&aLocIDs='+$.LOGON.LOCID+'&aIsSplit='+IsSplit+'&aPath='+cspPath;	
		}
		//12->呼吸机相关肺炎发病率统计表
		if(obj.Index==12){
			var aLocType 	= xLocType;
			var aQrycon 	= "1"; // $('#cboQryCon').combobox('getValue');
			ReportFrame = document.getElementById("ReportFrame");
			p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S310VAPInf.raq&aHospIDs='+$.LOGON.HOSPID +'&aDateFrom=' + aDateFrom +'&aDateTo='+ aDateTo+'&aLocType='+aLocType+'&aQryCon='+aQrycon+'&aStatDimens='+''+'&aLocIDs='+$.LOGON.LOCID+'&aPath='+cspPath;				
			//p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S310VAPInf.raq&aDateFrom=' + aDateFrom +'&aDateTo='+ aDateTo +'&aHospIDs='+aHospID+'&aLocIDs='+''+'&aLocType='+aLocType+'&aQryCon='+aQrycon+'&aTubeType='+'VAP' ;
		}
		//13->导尿管相关泌尿道感染发病率统计表
		if(obj.Index==13){
			var aLocType 	= xLocType;
			var aQrycon 	= "1"; // $('#cboQryCon').combobox('getValue');
			ReportFrame = document.getElementById("ReportFrame");
			p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S320UCInf.raq&aHospIDs='+$.LOGON.HOSPID +'&aDateFrom=' + aDateFrom +'&aDateTo='+ aDateTo+'&aLocType='+aLocType+'&aQryCon='+aQrycon+'&aStatDimens='+''+'&aLocIDs='+$.LOGON.LOCID+'&aPath='+cspPath;				
			//p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMA.HAI.STATV2.S320UCInf.raq&aDateFrom=' + aDateFrom +'&aDateTo='+ aDateTo +'&aHospIDs='+aHospID+'&aLocIDs='+''+'&aLocType='+aLocType+'&aQryCon='+aQrycon+'&aTubeType='+'UC' ;
		}
		if(!ReportFrame.src){
			ReportFrame.frameElement.src=p_URL;
		}else{
			ReportFrame.src = p_URL;
		}
	}
	//加载图
	obj.ShowEChart = function(){
		obj.ChartType=2;
		
		//1->医院感染发病（例次）率	
		if(obj.Index==14){
			//排序
			obj.up=function(x,y){
        		return y.InfPatCnt-x.InfPatCnt
    		}
    		//统计图模板
    		obj.option = function(arrViewLoc,arrInfPatCnt,arrInfPatRatio,endnumber){
				var option = {
					title : {
						text: '住院患者感染例次（率）统计图',
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
						data:['感染人数','感染率'],
						x: 'center',
						y: 30
					},
			 		dataZoom: [{
						show: true,
						realtime: true,
						start: 0,
						end: endnumber,
						bottom: 0,
						zoomLock:true
					}],
					xAxis: [{
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
					}],
					yAxis: [{
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
						name: '感染率(%)',
						min: 0,
						interval:10,
						axisLabel: {
							formatter: '{value} %'
						}
					}],
					series: [{
						name:'感染人数',
						type:'bar',
						barMaxWidth:50,
						data:arrInfPatCnt
					},
					{
						name:'感染率',
						type:'line',
						yAxisIndex: 1,
						data:arrInfPatRatio,
						label: {
							show:true,
							formatter:"{c}%"
						}
					}]
				};
				return option;
			}
			//处理数据
			obj.echartLocInfRatio = function(runQuery){
				if (!runQuery) return;
				var arrViewLoc 		= new Array;
				var arrInfPatCnt 	= new Array;
				var arrInfPatRatio 	= new Array;
				arrRecord 		= runQuery.rows;
		
				var arrlength		= 0;
				for (var indRd = 0; indRd < arrRecord.length; indRd++){
					var rd = arrRecord[indRd];
					//去掉全院、医院、科室组
					if ((rd["xDimensKey"].indexOf('-A-')>-1)||(rd["xDimensKey"].indexOf('-H-')>-1)||(rd["xDimensKey"].indexOf('-G-')>-1)) {
						delete arrRecord[indRd];
						arrlength = arrlength + 1;
						continue;
					}
					rd["DimensDesc"] = $.trim(rd["DimensDesc"]);  //去掉空格
					rd["InfPatRatio"] = parseFloat(rd["InfPatRatio"].replace('%','').replace('‰','')).toFixed(2);
				}
		
				arrRecord = arrRecord.sort(obj.up);
				arrRecord.length = arrRecord.length - arrlength;
				for (var indRd = 0; indRd < arrRecord.length; indRd++){
					var rd = arrRecord[indRd];
			
					arrViewLoc.push(rd["DimensDesc"]);
					arrInfPatCnt.push(rd["InfPatCnt"]);
					arrInfPatRatio.push(parseFloat(rd["InfPatRatio"]).toFixed(2));
				}
				var endnumber = (14/arrViewLoc.length)*100;
		
				// 使用刚指定的配置项和数据显示图表
				obj.myChart.setOption(obj.option(arrViewLoc,arrInfPatCnt,arrInfPatRatio,endnumber),true);
			}	
			obj.myChart.clear()
			//当月科室感染率图表
			var aHospID = $('#cboHospital').combobox('getValue');
			var aDateFrom = $('#dtDateFrom').datebox('getValue');
			var aDateTo= $('#dtDateTo').datebox('getValue');
			var aLocType = Common_CheckboxValue('chkStatunit');
			var aQryCon =  $('#cboQryCon').combobox('getValue');
			
			obj.myChart.showLoading();	//隐藏加载动画
			$cm({
				ClassName:"DHCHAI.STATV2.S010Inf",
				QueryName:"QryS010Inf",
				aHospIDs:aHospID, 
				aDateFrom:aDateFrom, 
				aDateTo:aDateTo, 
				aLocType:aLocType, 
				aQryCon:aQryCon,
				page: 1,
				rows: 999
			},function(rs){
				obj.myChart.hideLoading();    //隐藏加载动画
				obj.echartLocInfRatio(rs);
			});
		}
		//2->医院感染现患（例次）率
		if(obj.Index==2){
			obj.myChart.clear();
			var option = {
				title : {
					text: '医院感染（例次）现患率统计图',
					textStyle:{
						fontSize:26
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
					right:'20px',
					feature: {
						dataView: {show: false, readOnly: false},
						magicType: {show: true, type: ['line', 'bar']},
						restore: {show: true},
						saveAsImage: {show: true}
					}
				},
				legend: {
					data:['感染人数','现患率'],
					x: 'center',
					y: 30
				},
			 	dataZoom: [{
        			show: true,
       	 			realtime: true,
        			zoomLock:true
    			}],
				xAxis: [
				{
					type: 'category',
					data: [],
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
				}],
				yAxis: [
				{
					type: 'value',
					name: '感染人数',
					min: 0,
					interval:10,
					axisLabel: {
						formatter: '{value} '
					}
				},
				{
					type: 'value',
					name: '现患率(%)',
					min: 0,
					interval:10,
					axisLabel: {
						formatter: '{value} %'
					}
				}],
				series: [
				 {
					name:'感染人数',
					type:'bar',
					barMaxWidth:50,
					data:[]
				},
				{
					name:'现患率',
					type:'line',
					yAxisIndex: 1,
					data:[],
					label: {
						show:true,
						formatter:"{c}%"
					}
				}]
			};
			// 使用刚指定的配置项和数据显示图表
			obj.myChart.setOption(option,true);
		
		 	//当月科室感染率图表
			var HospID		= $('#cboHospital').combobox('getValue');
			var DateFrom 	= $('#dtDateFrom').datebox('getValue');
			var DateTo		= $('#dtDateTo').datebox('getValue');
			var StaType 	= Common_CheckboxValue('chkStatunit');
			var Qrycon 		= $('#cboQryCon').combobox('getValue');
			obj.myChart.showLoading();	//隐藏加载动画
			$cm({
				ClassName:"DHCHAI.STATV2.S030InfPre",
				QueryName:"QryInfPre",
				aHospIDs:HospID, 
				aDateFrom:DateFrom, 
				aDateTo:DateTo, 
				aLocType:StaType, 
				aQryCon:Qrycon,
				page: 1,
				rows: 999
			},function(rs){
				obj.myChart.hideLoading();    //隐藏加载动画
				obj.echartLocInfRatio(rs);
			});

	   		obj.echartLocInfRatio = function(runQuery){
				if (!runQuery) return;
				var arrViewLoc 	= new Array();
				var arrInfRatio = new Array();
				var arrInfCount = new Array();
				var arrRecord 	= runQuery.rows;
			
				for (var indRd = 0; indRd < arrRecord.length; indRd++){
					var rd = arrRecord[indRd];
					//去掉全院、医院、科室组
					if ((rd["DimenCode"].indexOf('-A-')>-1)||(rd["DimenCode"].indexOf('-H-')>-1)||(rd["DimenCode"].indexOf('-G-')>-1)) {
						delete arrRecord[indRd];
						continue;
					}
					rd["LocDesc"] = $.trim(rd["LocDesc"]); //去掉空格
					rd["HAIRatio"] = parseFloat(parseFloat(rd["HAIRatio"].replace('%','').replace('‰','')).toFixed(2));
				}
			
				arrRecord = arrRecord.sort(Common_GetSortFun('desc','HAICount'));  //排序
				obj.numbers="ALL";
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
						arrViewLoc.push(rd["LocDesc"]);
						arrInfCount.push(rd["HAICount"]);
						arrInfRatio.push(parseFloat(rd["HAIRatio"]).toFixed(2));
					}
				}
			
				// 装载数据
				obj.myChart.setOption(
				{
					dataZoom: [{
		        		start: 0,
		        		end: (15/obj.numbers)*100
		    		}],
					xAxis: {
						data: arrViewLoc
					},
					series: [{
						data:arrInfCount
					},{
						data:arrInfRatio
					}]
				});
			}
		}
		//3->医院感染病例漏报率统计表
		if(obj.Index==3){
			obj.myChart.clear();
			var option = {
				title : {
					text: '医院感染病例漏报/迟报率统计',
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
					data:['漏报感染例数','漏报率'],
					x: 'center',
					y: 30
				},
			 	dataZoom: [{
        			show: true,
       	 			realtime: true,
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
				}],
				yAxis: [
				{
					type: 'value',
					name: '漏报感染例数',
					min: 0,
					nameTextStyle: {
			            padding: [0, 0, 5, -10]    // 四个数字分别为上右下左与原位置距离
			        },
					interval:1,
					axisLabel: {
						formatter: '{value} '
					}
				},
				{
					type: 'value',
					name: '漏报率(%)',
					scale : false,
					nameTextStyle: {
			            padding: [0, 0, 5, -10]    // 四个数字分别为上右下左与原位置距离
			        },
            		max : 100,
            		min : 0,
            		//splitNumber :20,
            		minInterval :10,  
					//interval:1,
					axisLabel: {
						margin:8,
						formatter: '{value}'
					}
				}],
				series: [
				{
					name:'漏报感染例数',
					type:'bar',
					barMaxWidth:50,
					data:[]
				},
				{
					name:'漏报率',
					type:'line',
					yAxisIndex: 1,
					data:[],
					label: {
						show:true,
						formatter:"{c}"
					}
				}]
			};
			// 使用刚指定的配置项和数据显示图表
			obj.myChart.setOption(option,true);
		
		 	//当月科室感染率图表
			var HospID = $('#cboHospital').combobox('getValue');
			var DateFrom = $('#dtDateFrom').datebox('getValue');
			var DateTo= $('#dtDateTo').datebox('getValue');
			var StaType = Common_CheckboxValue('chkStatunit');
			var Qrycon = $('#cboQryCon').combobox('getValue');

			obj.myChart.showLoading();	//隐藏加载动画
			$cm({
				ClassName:"DHCHAI.STATV2.S370InfMisRep",
				QueryName:"QryInfMisRep",
				aHospIDs:HospID, 
				aDateFrom:DateFrom, 
				aDateTo:DateTo, 
				aLocType:StaType, 
				aQryCon:Qrycon,
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
				obj.arrLocG= new Array();
				var arrRecord = runQuery.rows;
			
				for (var indRd = 0; indRd < arrRecord.length; indRd++){
					var rd = arrRecord[indRd];
					//去掉全院、医院、科室组
					if ((rd["DimensKey"].indexOf('-A-')>-1)||(rd["DimensKey"].indexOf('-H-')>-1)||(rd["DimensKey"].indexOf('-G-')>-1)) {
						delete arrRecord[indRd];
						continue;
					}
					rd["DimensDesc"] = $.trim(rd["DimensDesc"]); //去掉空格
					rd["MissRepRatio"] = parseFloat(parseFloat(rd["MissRepRatio"].replace('%','').replace('‰','')).toFixed(2));
				}
				arrRecord = arrRecord.sort(Common_GetSortFun('desc','InfMissPatCount'));  //排序
				obj.numbers="ALL"
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
						arrInfCount.push(rd["InfMissPatCount"]);
						arrInfRatio.push(parseFloat(rd["MissRepRatio"]).toFixed(2));
						obj.arrLocG.push(rd["DimensKey"]);
					}
				}
			
				// 装载数据
				obj.myChart.setOption(
				{
					dataZoom: [{
		        		start: 0,
		        		end: (15/obj.numbers)*100
		    		}],
					xAxis: {
						data: arrViewLoc
					},
					series: [{
						data:arrInfCount
					},{
						data:arrInfRatio
					}]
				});
			}
		}
		//4->多重耐药菌感染发现率统计表
		if(obj.Index==4){
			obj.myChart.clear()
			
			obj.echartLocInfRatio = function(runQuery){
	   			var aHospID 	= $('#cboHospital').combobox('getValue');
	    		var QryCon="-H-";	//默认统计医院
	    		if (aHospID.indexOf('|')>-1) QryCon="-A-";	//多院区时统计全院
				if (!runQuery) return;
				arrRecord 		= runQuery.rows;
				
				var arrMRBDesc = new Array();		//多耐类别
				var arrMRBPat	= new Array();			//感染人数
				for (var indRd = 0; indRd < arrRecord.length; indRd++){
					var rd = arrRecord[indRd];
					if ((rd["DimensKey"].indexOf(QryCon)>-1)) {
						
						arrMRBDesc.push(rd["MRBType"]);		//加载多耐类别
						arrMRBPat.push(rd["MRBPat"]);			//加载多耐数目
					}
				}
				// 使用刚指定的配置项和数据显示图表。
				option = {
			    	title : {
			       	 	text: '全院多重耐药菌感染人数统计图',
			        	textStyle:{
							fontSize:28
						},
			        	x:'center'
			    	},
			    	tooltip : {
			        	trigger: 'item',
			        	formatter: "{a} <br/>{b} : {c} ({d}%)"
			    	},
			    	legend: {
			        	orient: 'vertical',
			        	left: 'left',
			        	data:arrMRBDesc
			    	},
			    	series : [
			        {
			            name: '多耐名称',
			            type: 'pie',
			            radius : '55%',
			            center: ['50%', '60%'],
			            data:  (function(){
				        	var arr=[];
				       		for (var i = 0; i < arrMRBDesc.length; i++) {	
 								arr.push({"value": arrMRBPat[i],"name":arrMRBDesc[i]});
							}
							return arr;  
				     	})(),
			        }]
				};
				obj.myChart.setOption(option,true);
			}
			//当月科室感染率图表
			var aHospID 	= $('#cboHospital').combobox('getValues').join('|');
			var aDateFrom 	= $('#dtDateFrom').datebox('getValue');
			var aDateTo		= $('#dtDateTo').datebox('getValue');
			var aLocType 	= Common_CheckboxValue('chkStatunit');
			var aQrycon 	= $('#cboQryCon').combobox('getValue');
			var aStatDimens = $('#cboShowType').combobox('getValue');
			var aLocIDs 	= $('#cboLoc').combobox('getValues').join(',');	

			obj.myChart.showLoading();	//隐藏加载动画
			$cm({
				ClassName:"DHCHAI.STATV2.ThirteenInd.STar004",
				QueryName:"QryMRBInf",
				aHospIDs:aHospID, 
				aDateFrom:aDateFrom, 
				aDateTo:aDateTo, 
				aLocType:aLocType, 
				aQryCon:aQrycon,
				aStatDimens:aStatDimens,
				aLocIDs:aLocIDs,
				page: 1,
				rows: 999
			},function(rs){
				obj.myChart.hideLoading();    //隐藏加载动画
				obj.echartLocInfRatio(rs);
			});
		}
		//5->多重耐药菌检出率统计表
		if(obj.Index==5){
			obj.myChart.clear();
			obj.echartLocInfRatio = function(runQuery){
	    		var aHospID 	= $('#cboHospital').combobox('getValue');
	    		var QryCon="-H-";	//默认统计医院
	   		 	if (aHospID.indexOf('|')>-1) QryCon="-A-";	//多院区时统计全院
				if (!runQuery) return;
				arrRecord 		= runQuery.rows;
				
				var arrMRBDesc = new Array();		//多耐类别
				var arrMRBCnt	= new Array();		//多耐数目
				
				for (var indRd = 0; indRd < arrRecord.length; indRd++){
					var rd = arrRecord[indRd];
					if ((rd["DimensKey"].indexOf(QryCon)>-1)) {
						
						arrMRBDesc.push(rd["MRBType"]);		//加载多耐类别
						arrMRBCnt.push(rd["MRBCase"]);		//加载多耐数目
					}
				}
				// 使用刚指定的配置项和数据显示图表。
				option = {
			    	title : {
			        	text: '全院多重耐药菌检出数统计图',
			        	textStyle:{
							fontSize:28
						},
			        	x:'center'
			    	},
			    	tooltip : {
			        	trigger: 'item',
			        	formatter: "{a} <br/>{b} : {c} ({d}%)"
			    	},
			    	legend: {
			        	orient: 'vertical',
			        	left: 'left',
			        	data:arrMRBDesc
			    	},
			    	series : [
			        {
			            name: '多耐名称',
			            type: 'pie',
			            radius : '55%',
			            center: ['50%', '60%'],
			            data: (function(){
				        	var arr=[];
				       		for (var i = 0; i < arrMRBDesc.length; i++) {	
 								arr.push({"value": arrMRBCnt[i],"name":arrMRBDesc[i]});
							}
							return arr;  
				     	})(),
			        }]
				};
				obj.myChart.setOption(option,true);
			}
			//当月科室感染率图表
			var aHospID 	= $('#cboHospital').combobox('getValues').join('|');
			var aDateFrom 	= $('#dtDateFrom').datebox('getValue');
			var aDateTo		= $('#dtDateTo').datebox('getValue');
			var aLocType 	= Common_CheckboxValue('chkStatunit');
			var aQrycon 	= $('#cboQryCon').combobox('getValue');
			var aStatDimens = $('#cboShowType').combobox('getValue');
			var aLocIDs 	= $('#cboLoc').combobox('getValues').join(',');	

			obj.myChart.showLoading();	//隐藏加载动画
			$cm({
				ClassName:"DHCHAI.STATV2.ThirteenInd.STar005",
				QueryName:"QryMRBPos",
				aHospIDs:aHospID, 
				aDateFrom:aDateFrom, 
				aDateTo:aDateTo, 
				aLocType:aLocType, 
				aQryCon:aQrycon,
				aStatDimens:aStatDimens,
				aLocIDs:aLocIDs,
				page: 1,
				rows: 999
			},function(rs){
				obj.myChart.hideLoading();    //隐藏加载动画
				obj.echartLocInfRatio(rs);
			});
		}
		//6->医务人员手卫生依从率统计表
		if(obj.Index==6){
			obj.myChart.clear()
			obj.up=function(x,y){
        		return x.CorrectCount-y.CorrectCount
    		}
			obj.option = function(arrViewLoc,arrCorrectCount,arrCorrectRatio,arrCompRatio,endnumber){
				var option = {
					title : {
						text: '手卫生依从性、正确性统计图',
						textStyle:{
							fontSize:28
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
						data:['洗手正确人数','正确率','依从率'],
						x: 'center',
						y: 30
					},
			 		dataZoom: [{
						show: true,
						realtime: true,
						start: 0,
						end: endnumber,
						zoomLock:true
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
					}],
					yAxis: [
					{
						type: 'value',
						name: '洗手正确人数',
						min: 0,
						interval:Math.ceil(arrCorrectCount[0]/10),
						axisLabel: {
							formatter: '{value} '
						}	
					},
					{
						type: 'value',
						name: '正确率(%)',
						min: 0,
						interval:10,
						axisLabel: {
							formatter: '{value} %'
						}
					}],
					series: [
				 	{
						name:'洗手正确人数',
						type:'bar',
						barMaxWidth:50,
						data:arrCorrectCount
					},
					{
						name:'正确率',
						type:'line',
						yAxisIndex: 1,
						data:arrCorrectRatio,
						label: {
							show:true,
							formatter:"{c}%"
						}
					},
					{
						name:'依从率',
						type:'line',
						yAxisIndex: 1,
						data:arrCompRatio,
						label: {
							show:true,
							formatter:"{c}%"
						}
					}]
				};
				return option;
			}
    		obj.echartLocInfRatio = function(runQuery){
				if (!runQuery) return;
				var arrViewLoc 			= new Array();
				var arrCorrectCount 	= new Array();		//洗手正确数
				var arrCorrectRatio 	= new Array();		//正确率
				var arrCompRatio		= new Array();
				arrRecord 		= runQuery.rows;
		
				var arrlength		= 0;
				for (var indRd = 0; indRd < arrRecord.length; indRd++){
					var rd = arrRecord[indRd];
					//去掉全院、医院、科室组
					if (rd["DimensKey"].indexOf('全院')>-1) {
						delete arrRecord[indRd];
						arrlength = arrlength + 1;
						continue;
					}
					rd["DimensDesc"]	= $.trim(rd["DimensDesc"]); //去掉空格
					rd["CorrectRatio"]	= parseFloat(rd["CorrectRatio"].replace('%','').replace('‰','')).toFixed(2);
					rd["CompRatio"]	= parseFloat(rd["CompRatio"].replace('%','').replace('‰','')).toFixed(2);
				}
		
				arrRecord = arrRecord.sort(obj.up);
				arrRecord.length = arrRecord.length - arrlength;
				for (var indRd = 0; indRd < arrRecord.length; indRd++){
					var rd = arrRecord[indRd];
			
					arrViewLoc.push(rd["DimensDesc"]);
					arrCorrectCount.push(rd["CorrectCount"]);
					arrCorrectRatio.push(parseFloat(rd["CorrectRatio"]).toFixed(2));
					arrCompRatio.push(parseFloat(rd["CompRatio"]).toFixed(2));
				}
				var endnumber = (14/arrViewLoc.length)*100;
	
				// 使用刚指定的配置项和数据显示图表。
				obj.myChart.setOption(obj.option(arrViewLoc,arrCorrectCount,arrCorrectRatio,arrCompRatio,endnumber),true);
			}
			//当月科室感染率图表
			var aHospID = $('#cboHospital').combobox('getValue');
			var aDateFrom = $('#dtDateFrom').datebox('getValue');
			var aDateTo= $('#dtDateTo').datebox('getValue');
			var aMethod = $('#cboMethod').datebox('getValue');
			var aObsType    = $('#cboObsType').datebox('getValue');
			
			obj.myChart.showLoading();	//隐藏加载动画
			$cm({
				ClassName:"DHCHAI.STATV2.S380HandHyCom",
				QueryName:"QryHandHyRegSta",
				aHospIDs:aHospID, 
				aDateFrom:aDateFrom, 
				aDateTo:aDateTo, 
				aMethod:aMethod, 
				aObsType:aObsType
			},function(rs){
				obj.myChart.hideLoading();    //隐藏加载动画
				obj.echartLocInfRatio(rs);
			});
		}
		//7->住院患者抗菌药物使用率统计表
		if(obj.Index==7){
			obj.myChart.clear()
			obj.up=function(x,y){
        		return y.UseAntiCnt-x.UseAntiCnt
    		}
			obj.option = function(arrViewLoc,arrUseAntiCnt,arrUseAntiRatio,endnumber){
				var option = {
					title : {
						text: '住院患者抗菌药物使用率统计图',
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
						data:['应用抗菌药物人数','使用率'],
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
					}],
					yAxis: [
					{
						type: 'value',
						name: '应用抗菌药物人数',
						min: 0,
						interval:Math.ceil(arrUseAntiCnt[0]/10),
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
					}],
					series: [
				 	{
						name:'应用抗菌药物人数',
						type:'bar',
						barMaxWidth:50,
						data:arrUseAntiCnt
					},
					{
						name:'使用率',
						type:'line',
						yAxisIndex: 1,
						data:arrUseAntiRatio,
						label: {
							show:true,
							formatter:"{c}%"
						}
					}]
				};
				return option;
			}
    		obj.echartLocInfRatio = function(runQuery){
				if (!runQuery) return;
		
				var arrViewLoc 		= new Array();
				var arrUseAntiCnt 	= new Array();		//同期全身应用抗菌药物的人数
				var arrUseAntiRatio = new Array();
				arrRecord 		= runQuery.rows;
				
				var arrlength		= 0;
				for (var indRd = 0; indRd < arrRecord.length; indRd++){
					var rd = arrRecord[indRd];
					//去掉全院、医院、科室组
					if ((rd["xDimensKey"].indexOf('-A-')>-1)||(rd["xDimensKey"].indexOf('-H-')>-1)||(rd["xDimensKey"].indexOf('-G-')>-1)) {
						delete arrRecord[indRd];
						arrlength = arrlength + 1;
						continue;
					}
					rd["DimensDesc"] = $.trim(rd["DimensDesc"]); //去掉空格
					rd["UseAntiRatio"] = parseFloat(rd["UseAntiRatio"].replace('%','').replace('‰','')).toFixed(2);
				}
		
				arrRecord = arrRecord.sort(obj.up);
				arrRecord.length = arrRecord.length - arrlength;
				for (var indRd = 0; indRd < arrRecord.length; indRd++){
					var rd = arrRecord[indRd];
			
					arrViewLoc.push(rd["DimensDesc"]);
					arrUseAntiCnt.push(rd["UseAntiCnt"]);
					arrUseAntiRatio.push(parseFloat(rd["UseAntiRatio"]).toFixed(2));
				}
				var endnumber = (14/arrViewLoc.length)*100;
				// 使用刚指定的配置项和数据显示图表。
				obj.myChart.setOption(obj.option(arrViewLoc,arrUseAntiCnt,arrUseAntiRatio,endnumber),true);
			}
	 		//当月科室使用率图表
			var aHospID 	= $('#cboHospital').combobox('getValue');
			var aDateFrom 	= $('#dtDateFrom').datebox('getValue');
			var aDateTo		= $('#dtDateTo').datebox('getValue');
			var aLocType 	= Common_CheckboxValue('chkStatunit');
			var aQrycon 	= $('#cboQryCon').combobox('getValue');

			obj.myChart.showLoading();	//隐藏加载动画
			$cm({
				ClassName:"DHCHAI.STATV2.S130AntUse",
				QueryName:"QryAntUse",
				aHospIDs:aHospID, 
				aDateFrom:aDateFrom, 
				aDateTo:aDateTo, 
				aLocType:aLocType, 
				aQryCon:aQrycon,
				page: 1,
				rows: 999
			},function(rs){
				obj.myChart.hideLoading();    //隐藏加载动画
				obj.echartLocInfRatio(rs);
			});
		}
		//8->住院患者抗菌药物治疗前病原学送检率统计表
		if(obj.Index==8){
			obj.myChart.clear()
			obj.up=function(x,y){
       	 		return y.BfCureSubmissCnt-x.BfCureSubmissCnt
    		}
			obj.option = function(arrViewLoc,arrBfCureSubmissCnt,arrBfCureSubRatio,arrUseKSS1AndSub,arrUseKSS1SubRatio,arrUseKSS2AndSub,arrUseKSS2SubRatio,arrUseKSS3AndSub,arrUseKSS3SubRatio,endnumber){
				var option = {
					title : {
						text: '抗菌药物治疗前病原学送检率统计图',
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
						//data:['送检人数','送检率'],
						data:['送检人数','非限制级送检人数','限制级送检人数','特殊级送检人数','送检率','非限制级送检率','限制级送检率','特殊级送检率'],
						selected:{
							"非限制级送检人数":false,
							"限制级送检人数":false,
							"特殊级送检人数":false,
							"非限制级送检率":false,
							"限制级送检率":false,
							"特殊级送检率":false
						},
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
							name: '送检人数',
							min: 0,
							interval:Math.ceil(arrBfCureSubmissCnt[0]/10),
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
							name:'送检人数',
							type:'bar',
							barMaxWidth:50,
							data:arrBfCureSubmissCnt
						},
						{
							name:'非限制级送检人数',
							type:'bar',
							barMaxWidth:50,
							data:arrUseKSS1AndSub
						},
						
						 {
							name:'限制级送检人数',
							type:'bar',
							barMaxWidth:50,
							data:arrUseKSS2AndSub
						},
						{
							name:'特殊级送检人数',
							type:'bar',
							barMaxWidth:50,
							data:arrUseKSS3AndSub
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
						},
						{
							name:'非限制级送检率',
							type:'line',
							yAxisIndex: 1,
							data:arrUseKSS1SubRatio,
							label: {
								show:true,
								formatter:"{c}%"
							}
						},
						{
							name:'限制级送检率',
							type:'line',
							yAxisIndex: 1,
							data:arrUseKSS2SubRatio,
							label: {
								show:true,
								formatter:"{c}%"
							}
						},
						{
							name:'特殊级送检率',
							type:'line',
							yAxisIndex: 1,
							data:arrUseKSS3SubRatio,
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
				var arrViewLoc 			= new Array();
				var arrBfCureSubmissCnt = new Array();		//送检人数
				var arrBfCureSubRatio 	= new Array();
				var arrUseKSS1AndSub    = new Array();		//非限制级送检人数
				var arrUseKSS1SubRatio 	= new Array();
				var arrUseKSS2AndSub    = new Array();		//限制级送检人数
				var arrUseKSS2SubRatio 	= new Array();
				var arrUseKSS3AndSub    = new Array();		//特殊级送检人数
				var arrUseKSS3SubRatio 	= new Array();
				arrRecord 		= runQuery.rows;
		
				var arrlength		= 0;
				for (var indRd = 0; indRd < arrRecord.length; indRd++){
					var rd = arrRecord[indRd];
					//去掉全院、医院、科室组
					if ((rd["xDimensKey"].indexOf('-A-')>-1)||(rd["xDimensKey"].indexOf('-H-')>-1)||(rd["xDimensKey"].indexOf('-G-')>-1)) {
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
					arrBfCureSubmissCnt.push(rd["BfCureSubmissCnt"]);
					arrBfCureSubRatio.push(parseFloat(rd["BfCureSubRatio"]).toFixed(2));
					arrUseKSS1AndSub.push(rd["UseKSS1AndSub"]);
					arrUseKSS1SubRatio.push(parseFloat(rd["UseKSS1SubRatio"]).toFixed(2));
					arrUseKSS2AndSub.push(rd["UseKSS2AndSub"]);
					arrUseKSS2SubRatio.push(parseFloat(rd["UseKSS2SubRatio"]).toFixed(2));
					arrUseKSS3AndSub.push(rd["UseKSS3AndSub"]);
					arrUseKSS3SubRatio.push(parseFloat(rd["UseKSS3SubRatio"]).toFixed(2));
				}
				var endnumber = (14/arrViewLoc.length)*100;
				// 使用刚指定的配置项和数据显示图表。
				obj.myChart.setOption(obj.option(arrViewLoc,arrBfCureSubmissCnt,arrBfCureSubRatio,arrUseKSS1AndSub,arrUseKSS1SubRatio,arrUseKSS2AndSub,arrUseKSS2SubRatio,arrUseKSS3AndSub,arrUseKSS3SubRatio,endnumber),true);
			}
			//当月科室送检率图表
			var aHospID = $('#cboHospital').combobox('getValue');
			var aDateFrom = $('#dtDateFrom').datebox('getValue');
			var aDateTo= $('#dtDateTo').datebox('getValue');
			var aLocType = Common_CheckboxValue('chkStatunit');
			var aQryCon 	= $('#cboQryCon').combobox('getValue');
			var aSubDateType = $('#cboSubDateType').combobox('getValue');
			var aSubHourType = $('#cboSubHourType').combobox('getValue');
			var aUseSubDateType = $('#useSubDateType').combobox('getValue');
			obj.myChart.showLoading();	//隐藏加载动画
			$cm({
				ClassName:"DHCHAI.STATV2.S170AntTheSub",
				QueryName:"QryAntTheSub",
				aHospIDs:aHospID, 
				aDateFrom:aDateFrom, 
				aDateTo:aDateTo, 
				aSubDateType:aSubDateType, 
				aSubHourType:aSubHourType,
				aLocType:aLocType, 
				aQryCon:aQryCon,
				aUseSubDateType:aUseSubDateType,
				page: 1,
				rows: 999
			},function(rs){
				obj.myChart.hideLoading();    //隐藏加载动画
				obj.echartLocInfRatio(rs);
			});
		}
		//9->Ⅰ类切口手术手术部位感染率统计表
		if(obj.Index==9){
			obj.myChart.clear();
			obj.numbers = "ALL";
			var option = {
				title : {
					text: 'Ⅰ类切口手术部位感染率统计图',
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
						dataView: {show: false, readOnly: false},
						magicType: {show: true, type: ['line', 'bar']},
						restore: {show: true},
						saveAsImage: {show: true}
					}
				},
				legend: {
					data:['Ⅰ类切口手术部位感染例次数','Ⅰ类切口手术部位感染率'],
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
				}],
				yAxis: [
				{
					type: 'value',
					nameTextStyle:{padding:[15,0]},
					name: 'Ⅰ类切口手术部位感染例次数',
					min: 0,
					interval:1,
					axisLabel: {
						formatter: '{value} '
					}
				},
				{
					type: 'value',
					name: 'Ⅰ类切口手术部位感染率(%)',
					min: 0,
					interval:10,
					axisLabel: {
						formatter: '{value} %'
					}
				}],
				series: [
				{
					name:'Ⅰ类切口手术部位感染例次数',
					type:'bar',
					barMaxWidth:50,
					data:[]
				},
				{
					name:'Ⅰ类切口手术部位感染率',
					type:'line',
					yAxisIndex: 1,
					data:[],
					label: {
						show:true,
						formatter:"{c}%"
					}
				}]
			};
			// 使用刚指定的配置项和数据显示图表
			obj.myChart.setOption(option,true);
		
			//当月科室感染率图表
			var HospID = $('#cboHospital').combobox('getValue');
			var DateFrom = $('#dtDateFrom').datebox('getValue');
			var DateTo= $('#dtDateTo').datebox('getValue');
			var StaType = Common_CheckboxValue('chkStatunit');
			var Qrycon = $('#cboQryCon').combobox('getValue');
			
			obj.myChart.showLoading();	//隐藏加载动画
			$cm({
				ClassName:"DHCHAI.STATV2.S240AIncInf",
				QueryName:"QryAIncInf",
				aHospIDs:HospID, 
				aDateFrom:DateFrom, 
				aDateTo:DateTo, 
				aStaType:StaType, 
				aQryCon:Qrycon,
				aOperCat:'',
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
				obj.arrLocG= new Array();
				var arrRecord = runQuery.rows;
			
				for (var indRd = 0; indRd < arrRecord.length; indRd++){
					var rd = arrRecord[indRd];
					//去掉全院、医院、科室组
					if ((rd["DimensKey"].indexOf('-A-')>-1)||(rd["DimensKey"].indexOf('-H-')>-1)||(rd["DimensKey"].indexOf('-G-')>-1)) {
						delete arrRecord[indRd];
						continue;
					}
					rd["DimensDesc"] = $.trim(rd["DimensDesc"]); //去掉空格
					rd["OperCaseInfCount"] = parseFloat(parseFloat(rd["OperCaseInfCount"].replace('%','').replace('‰','')).toFixed(2));
				}
				arrRecord = arrRecord.sort(Common_GetSortFun('desc','OperCaseInfCount'));  //排序
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
						arrInfCount.push(rd["OperCaseInfCount"]);
						arrInfRatio.push(parseFloat(rd["SuperIncRatio"]).toFixed(2));
						obj.arrLocG.push(rd["DimensKey"]);
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
				});
			}
		}
		//10->Ⅰ类切口手术抗菌药物预防使用率统计表
		if(obj.Index==10){
			obj.myChart.clear();
			obj.numbers = "ALL";
			var option = {
				title : {
					text: 'Ⅰ类切口手术抗菌药物预防使用率统计图',
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
						dataView: {show: false, readOnly: false},
						magicType: {show: true, type: ['line', 'bar']},
						restore: {show: true},
						saveAsImage: {show: true}
					}
				},
				legend: {
					data:['Ⅰ类切口预防性抗菌药物例数','Ⅰ类切口抗菌药物预防使用率'],
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
				}],
				yAxis: [
				{
					type: 'value',
					name: 'Ⅰ类切口预防抗菌药物例数',
					min: 0,
					interval:10,	//坐标间距，如果密集可以调整
					axisLabel: {
						formatter: '{value} '
					}
				},
				{
					type: 'value',
					name: 'Ⅰ类切口预防抗菌药使用率(%)',
					min: 0,
					interval:10,
					axisLabel: {
						formatter: '{value} %'
					}
				}],
				series: [
				{
					name:'Ⅰ类切口预防性抗菌药物例数',
					type:'bar',
					barMaxWidth:50, 
					data:[]
				},
				{
					name:'Ⅰ类切口抗菌药物预防使用率',
					type:'line',
					yAxisIndex: 1,
					data:[],
					label: {
						show:true,
						formatter:"{c}%"
					}
				}]
			};
			// 使用刚指定的配置项和数据显示图表
			obj.myChart.setOption(option,true);
		
		 	//当月科室感染率图表
			var HospID = $('#cboHospital').combobox('getValue');
			var DateFrom = $('#dtDateFrom').datebox('getValue');
			var DateTo= $('#dtDateTo').datebox('getValue');
			var StaType = Common_CheckboxValue('chkStatunit');
			var Qrycon = $('#cboQryCon').combobox('getValue');
	
			obj.myChart.showLoading();	//隐藏加载动画
			$cm({
				ClassName:"DHCHAI.STATV2.S260AIncAntUse",
				QueryName:"QryAIncAntUse",
				aHospIDs:HospID, 
				aDateFrom:DateFrom, 
				aDateTo:DateTo, 
				aStaType:StaType, 
				aQryCon:Qrycon,
				aOperCat:'',
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
				obj.arrLocG= new Array();
				var arrRecord = runQuery.rows;
			
				for (var indRd = 0; indRd < arrRecord.length; indRd++){
					var rd = arrRecord[indRd];
					//去掉全院、医院、科室组
					if ((rd["DimensKey"].indexOf('-A-')>-1)||(rd["DimensKey"].indexOf('-H-')>-1)||(rd["DimensKey"].indexOf('-G-')>-1)) {
						delete arrRecord[indRd];
						continue;
					}
					rd["DimensDesc"] = $.trim(rd["DimensDesc"]); //去掉空格
					rd["OperPreAntiCount"] = parseFloat(parseFloat(rd["OperPreAntiCount"].replace('%','').replace('‰','')).toFixed(2));
				}
				arrRecord = arrRecord.sort(Common_GetSortFun('desc','OperPreAntiCount'));  //排序
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
						arrInfCount.push(rd["OperPreAntiCount"]);
						arrInfRatio.push(parseFloat(rd["SuperAntiRatio"]).toFixed(2));
						obj.arrLocG.push(rd["DimensKey"]);
					}
				}
			
				// 装载数据
				obj.myChart.setOption(
				{
					dataZoom: [{
		        		start: 0,
		        		end: (15/obj.numbers)*100
		    		}],
					xAxis: {
						data: arrViewLoc
					},
					series: [{
						data:arrInfCount
					},{
						data:arrInfRatio
					}]
				});
			}
		}
		//11->血管导管相关血流感染发病率统计表
		if(obj.Index==11){
			obj.myChart.clear();
			var option = {
				title : {
					text: '血管导管相关血流感染发病率统计表',
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
						dataView: {show: false, readOnly: false},
						magicType: {show: true, type: ['line', 'bar']},
						restore: {show: true},
						saveAsImage: {show: true}
					},
			    	right:'2%',
				},
				legend: {
					data:['使用率','发病率'],
					x: 'center',
					y: 40
				},
				grid:{
					left:'5%',
					top:'13%',	
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
				}],
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
				}],
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
				}]
			};
			// 使用刚指定的配置项和数据显示图表
			obj.myChart.setOption(option,true);
		
			//当月科室感染率图表
			var HospID = $('#cboHospital').combobox('getValue');
			var DateFrom = $('#dtDateFrom').datebox('getValue');
			var DateTo= $('#dtDateTo').datebox('getValue');
			var aLocType = Common_CheckboxValue('chkStatunit');
			var Qrycon = $('#cboQryCon').combobox('getValue');
			
			obj.myChart.showLoading();	//隐藏加载动画
			$cm({
				ClassName:"DHCHAI.STATV2.S3TubeInf",
				QueryName:"QryTubeInf",
				aHospIDs:HospID, 
				aDateFrom:DateFrom, 
				aDateTo:DateTo, 
				aLocType:aLocType, 
				aQryCon:Qrycon,
				aTubeType:'PICC',
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
				obj.arrLocG= new Array();
				var arrRecord = runQuery.rows;
			
				for (var indRd = 0; indRd < arrRecord.length; indRd++){
					var rd = arrRecord[indRd];
					//去掉全院、医院、科室组
				
					if ((rd["DimenCode"].indexOf('-A-')>-1)||(rd["DimenCode"].indexOf('-H-')>-1)||(rd["DimenCode"].indexOf('-G-')>-1)) {
						delete arrRecord[indRd];
						continue;
					}
					rd["TubeRatio"] = parseFloat(parseFloat(rd["TubeRatio"].replace('%','').replace('‰','')).toFixed(2));
				}
				arrRecord = arrRecord.sort(Common_GetSortFun('desc','TubeRatio'));  //排序
				obj.numbers="ALL";
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
						arrInfCount.push(parseFloat(rd["TubeRatio"]).toFixed(2));
						arrInfRatio.push(parseFloat(rd["INFRatio"]).toFixed(2));
						obj.arrLocG.push(rd["LocID"]);
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
				});
			
			}
		}
		//12->呼吸机相关肺炎发病率统计表
		if(obj.Index==12){
			obj.myChart.clear();
			var option = {
				title : {
					text: '呼吸机相关肺炎发病率统计表',
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
				}],
				yAxis: [
				{
					type: 'value',
					name: '使用率',
					min: 0,
					interval:1,
					axisLabel: {
						formatter: '{value} '
					}
				},
				{
					type: 'value',
					name: '发病率(‰)',
					min: 0,
					interval:1,
					axisLabel: {
						formatter: '{value} ‰'
					}
				}],
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
				}]
			};
			// 使用刚指定的配置项和数据显示图表
			obj.myChart.setOption(option,true);
		
		 	//当月科室感染率图表
			var HospID = $('#cboHospital').combobox('getValue');
			var DateFrom = $('#dtDateFrom').datebox('getValue');
			var DateTo= $('#dtDateTo').datebox('getValue');
			var aLocType = Common_CheckboxValue('chkStatunit');
			var Qrycon = $('#cboQryCon').combobox('getValue');
			
			obj.myChart.showLoading();	//隐藏加载动画
			$cm({
				ClassName:"DHCHAI.STATV2.S3TubeInf",
				QueryName:"QryTubeInf",
				aHospIDs:HospID, 
				aDateFrom:DateFrom, 
				aDateTo:DateTo, 
				aLocType:aLocType, 
				aQryCon:Qrycon,
				aTubeType:'VAP',
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
				obj.arrLocG= new Array();
				var arrRecord = runQuery.rows;
			
				for (var indRd = 0; indRd < arrRecord.length; indRd++){
					var rd = arrRecord[indRd];
					//去掉全院、医院、科室组
				
					if ((rd["DimenCode"].indexOf('-A-')>-1)||(rd["DimenCode"].indexOf('-H-')>-1)||(rd["DimenCode"].indexOf('-G-')>-1)) {
						delete arrRecord[indRd];
						continue;
					}	
					rd["TubeRatio"] = parseFloat(parseFloat(rd["TubeRatio"].replace('%','').replace('‰','')).toFixed(2));
				}
				arrRecord = arrRecord.sort(Common_GetSortFun('desc','TubeRatio'));  //排序
				obj.numbers="ALL";
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
						arrViewLoc.push(rd["LocDesc"]);
						arrInfCount.push(parseFloat(rd["TubeRatio"]).toFixed(2));
						arrInfRatio.push(parseFloat(rd["INFRatio"]).toFixed(2));
						obj.arrLocG.push(rd["LocID"]);
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
				});
			
			}
		}
		//13->导尿管相关泌尿道感染发病率统计表
		if(obj.Index==13){
			obj.myChart.clear();
			var option = {
				title : {
					text: '导尿管相关泌尿道感染发病率统计表',
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
				}],
				yAxis: [
				{
					type: 'value',
					name: '使用率',
					min: 0,
					interval:1,
					axisLabel: {
						formatter: '{value} '
					}
				},
				{
					type: 'value',
					name: '发病率(‰)',
					min: 0,
					interval:1,
					axisLabel: {
						formatter: '{value} ‰'
					}
				}],
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
				}]
			};
			// 使用刚指定的配置项和数据显示图表
			obj.myChart.setOption(option,true);
		
		 	//当月科室感染率图表
			var HospID = $('#cboHospital').combobox('getValue');
			var DateFrom = $('#dtDateFrom').datebox('getValue');
			var DateTo= $('#dtDateTo').datebox('getValue');
			var aLocType = Common_CheckboxValue('chkStatunit');
			var Qrycon = $('#cboQryCon').combobox('getValue');

			obj.myChart.showLoading();	//隐藏加载动画
			$cm({
				ClassName:"DHCHAI.STATV2.S3TubeInf",
				QueryName:"QryTubeInf",
				aHospIDs:HospID, 
				aDateFrom:DateFrom, 
				aDateTo:DateTo, 
				aLocType:aLocType, 
				aQryCon:Qrycon,
				aTubeType:'UC',
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
				obj.arrLocG= new Array();
				var arrRecord = runQuery.rows;
			
				for (var indRd = 0; indRd < arrRecord.length; indRd++){
					var rd = arrRecord[indRd];
					//去掉全院、医院、科室组
				
					if ((rd["DimenCode"].indexOf('-A-')>-1)||(rd["DimenCode"].indexOf('-H-')>-1)||(rd["DimenCode"].indexOf('-G-')>-1)) {
						delete arrRecord[indRd];
						continue;
					}
					
					rd["TubeRatio"] = parseFloat(parseFloat(rd["TubeRatio"].replace('%','').replace('‰','')).toFixed(2));
				}
				arrRecord = arrRecord.sort(Common_GetSortFun('desc','TubeRatio'));  //排序
				obj.numbers="ALL";
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
						arrViewLoc.push(rd["LocDesc"]);
						arrInfCount.push(parseFloat(rd["TubeRatio"]).toFixed(2));
						arrInfRatio.push(parseFloat(rd["INFRatio"]).toFixed(2));
						obj.arrLocG.push(rd["LocID"]);
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
				});
			}
		}
	}	
}