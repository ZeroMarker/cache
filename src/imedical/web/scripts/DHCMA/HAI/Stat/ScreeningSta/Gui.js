$(function () {
	InitScreeningWin();
});
//页面Gui
var objScreen = new Object();
function InitScreeningWin(){
	var obj = objScreen;
	obj.Type = "";
	Common_ComboToSSHosp("cboHospital",$.LOGON.HOSPID);
	$('#dtDateTo').hide();
	// 日期赋初始值
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
		QueryName:"QryMonth",
		aTypeID:""
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
	var NowMonth=NowDate.split("-")[1]-1;	//上个月
	$('#cboYear').combobox('select',((NowMonth>0) ? NowYear:(NowYear-1)));
	$('#cboMonth').combobox('select',((NowMonth>0) ? NowMonth:12));

    $HUI.combobox("#cboAdmStatus",{
		data:[
			{value:'A',text:'住院',selected:true},
			{value:'D',text:'出院'}
		],
		editable:false,
		valueField:'value',
		textField:'text',
		onSelect:function(rec){
			obj.LoadScreenSta();
		}
	})
	$HUI.radio("[name='radDimension']",{  
		onCheckChange:function(event,value){		
			obj.LoadScreenSta();
		}
	});
	
	$HUI.radio("[name='radShowType']",{  
		onCheckChange:function(event,value){	
			obj.LoadScreenSta();
		}
	});
	obj.LoadScreenSta = function() {	
		var AdmStatus = $("#cboAdmStatus").combobox('getValue');
		var Dimension = Common_RadioValue("radDimension");
		var ShowType = Common_RadioValue("radShowType");		
		if (Dimension=="I") {   //指标维度
			$('#btnTips').show();
			if (ShowType=="T") {				
				$('#EchartDiv').css('display', 'none');
				$('#TableDiv').css('display', 'block');
				$('#btnExport').show();
				LoadScreenItemStaTab();   //表格
			} 
			if (ShowType=="E") {		
				$('#EchartDiv').css('display', 'block');
				$('#TableDiv').css('display', 'none');
				$('#btnExport').hide();
				obj.myChart = echarts.init(document.getElementById('EchartDiv'),'theme');
				obj.ShowScreenEcharts();
			}
		}
		if (Dimension=="D") {    //感染诊断维度
		    $('#btnTips').hide();
			if (ShowType=="T") {
				$('#EchartDiv').css('display', 'none');
				$('#TableDiv').css('display', 'block');
				$('#btnExport').show();
				LoadDiagScreenStaTab();   //表格
			} 
			if (ShowType=="E") {		
				$('#EchartDiv').css('display', 'block');
				$('#TableDiv').css('display', 'none');
				$('#btnExport').hide();
				obj.myChart = echarts.init(document.getElementById('EchartDiv'),'theme');
				obj.ShowDiagScreenEcharts();
			}
		}
		if (Dimension=="L") {    //科室维度
		    $('#btnTips').hide();
			if (ShowType=="T") {
				$('#EchartDiv').css('display', 'none');
				$('#TableDiv').css('display', 'block');
				$('#btnExport').show();
				LoadLocScreenStaTab();   //表格
			} 
			if (ShowType=="E") {		
				$('#EchartDiv').css('display', 'block');
				$('#TableDiv').css('display', 'none');
				$('#btnExport').hide();
				obj.myChart = echarts.init(document.getElementById('EchartDiv'),'theme');
				obj.ShowLocScreenEcharts();
			}
		}
	}

	function LoadScreenItemStaTab() {	//指标维度--表格
		$HUI.datagrid("#ScreenSta",{
			fit: true,
			rownumbers: true, //如果为true, 则显示一个行号列
			singleSelect: true,
			nowrap:false,		
			loadMsg:'数据加载中...',
			loading:true,
			pageSize: 20,
			pageList : [20,50,100,200],
			pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
			url:$URL,
			queryParams:{
				ClassName:"DHCHAI.AMS.ScreenResultSrv",
				QueryName:"QrySuRuleRate",
				aHospIDs:$('#cboHospital').combobox('getValue'),
				aDateFrom:$('#dtDateFrom').datebox('getValue'),
				aDateTo:$('#dtDateTo').datebox('getValue'),
				aAdmStatus:$('#cboAdmStatus').combobox('getValue')
			},	    
			columns:[[
				{field:'RuleNote',title:'疑似指标',width:220,
					formatter: function(value,row,index) {
						if (row.RuleID==""){
							return value;
						} else {
							return '<span style="padding-left:15px">'+value+'</span>';
						}
					}
				},
				{field:'PatientCnt',title:'患者人数',width:80,align:'center',
					formatter: function(value,row,index){
						if (value==0){
							return value;
						}else {
							var type =1;
							return "<a href='#' style='white-space:normal;color:blue' onclick='objScreen.OpenDtl(\""+type+"\",\""+row.RuleID+"\");' >"+value+ "</a>";
						}
					}
				},
				{field:'InfRepCnt',title:'感染人数',width:80,align:'center',
					formatter: function(value,row,index){
						if (value==0){
							return value;
						}else {
							var type =2;
							return "<a href='#' style='white-space:normal;color:blue' onclick='objScreen.OpenDtl(\""+type+"\",\""+row.RuleID+"\");' >"+value+ "</a>";
						}
					}
				},
				{field:'InfRepRatio',title:'感染率',width:80,align:'center'},
				{field:'ScreeningCnt',title:'疑似人数',width:80,align:'center',sortable:true,
					formatter: function(value,row,index){
						if (value==0){
							return value;
						}else {
							var type =3;
							return "<a href='#' style='white-space:normal;color:blue' onclick='objScreen.OpenDtl(\""+type+"\",\""+row.RuleID+"\");' >"+value+ "</a>";
						}
					}
				},
				{field:'ScreenRatio',title:'疑似率',width:80,align:'center',sortable:true},
				{field:'DiagnosCnt',title:'确诊人数',width:80,align:'center',sortable:true,
					formatter: function(value,row,index){
						if (value==0){
							return value;
						}else {
							var type =4;
							return "<a href='#' style='white-space:normal;color:blue' onclick='objScreen.OpenDtl(\""+type+"\",\""+row.RuleID+"\");' >"+value+ "</a>";
						}
					}
				},
				{field:'DiagRatio',title:'确诊率',width:80,align:'center',sortable:true},
				{field:'ExcludeCnt',title:'排除人数',width:80,align:'center',sortable:true,
					formatter: function(value,row,index){
						if (value==0){
							return value;
						}else {
							var type =5;
							return "<a href='#' style='white-space:normal;color:blue' onclick='objScreen.OpenDtl(\""+type+"\",\""+row.RuleID+"\");' >"+value+ "</a>";
						}
					}
				},
				{field:'ExcRatio',title:'排除率',width:80,align:'center',sortable:true},
				{field:'InfScreenCnt',title:'感染疑似(TP)',width:100,align:'center',sortable:true,	
					formatter: function(value,row,index){
						if (value==0){
							return value;
						}else {
							var type =6;
							return "<a href='#' style='white-space:normal;color:blue' onclick='objScreen.OpenDtl(\""+type+"\",\""+row.RuleID+"\");' >"+value+ "</a>";
						}
					}
				},
				{field:'RepUnScreenCnt',title:'感染非疑似(FN)',width:120,align:'center',sortable:true,	
					formatter: function(value,row,index){
						if (value==0){
							return value;
						}else {
							var type =7;
							return "<a href='#' style='white-space:normal;color:blue' onclick='objScreen.OpenDtl(\""+type+"\",\""+row.RuleID+"\");' >"+value+ "</a>";
						}
					}
				},
				{field:'ScreenUnInfCnt',title:'疑似非感染(FP)',width:120,align:'center',sortable:true,	
					formatter: function(value,row,index){
						if (value==0){
							return value;
						}else {
							var type =8;
							return "<a href='#' style='white-space:normal;color:blue' onclick='objScreen.OpenDtl(\""+type+"\",\""+row.RuleID+"\");' >"+value+ "</a>";
						}
					}
				},
				{field:'UnInfScreenCnt',title:'非疑似感染(TN)',width:125,align:'center',sortable:true,
					formatter: function(value,row,index){
						if (value==0){
							return value;
						}else {
							var type =9;
							return "<a href='#' style='white-space:normal;color:blue' onclick='objScreen.OpenDtl(\""+type+"\",\""+row.RuleID+"\");' >"+value+ "</a>";
						}
					}
				},
				{field:'ACCRatio',title:'准确率',width:80,align:'center',sortable:true},
				{field:'TPRRatio',title:'灵敏度',width:80,align:'center',sortable:true},
				{field:'TNRRatio',title:'特异度',width:80,align:'center',sortable:true},
				{field:'PPVRatio',title:'阳性预测值',width:90,align:'center',sortable:true},
				{field:'NPVRatio',title:'阴性预测值',width:90,align:'center',sortable:true},
				{field:'FNRRatio',title:'假阴性率',width:80,align:'center',sortable:true},
				{field:'FPRRatio',title:'假阳性率',width:80,align:'center',sortable:true},
				{field:'F1Value',title:'F1值',width:80,align:'center',sortable:true}
			]]
		});
	}
	
	function LoadDiagScreenStaTab() {	//感染诊断维度--表格
		$HUI.datagrid("#ScreenSta",{
			fit: true,
			rownumbers: true, //如果为true, 则显示一个行号列
			singleSelect: true,
			nowrap:false,		
			loadMsg:'数据加载中...',
			loading:true,
			pageSize: 20,
			pageList : [20,50,100,200],
			pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
			url:$URL,
			queryParams:{
				ClassName:"DHCHAI.AMS.ScreenResultSrv",
				QueryName:"QryDiagScreenRate",
				aHospIDs:$('#cboHospital').combobox('getValue'),
				aDateFrom:$('#dtDateFrom').datebox('getValue'),
				aDateTo:$('#dtDateTo').datebox('getValue'),
				aAdmStatus:$('#cboAdmStatus').combobox('getValue')
			},	    
			columns:[[
				{field:'InfDiag',title:'感染诊断',width:220,
					formatter: function(value,row,index) {
						if (row.ID==""){
							return value;
						} else {
							return '<span style="padding-left:15px">'+value+'</span>';
						}
					}
				},
				{field:'InfPatCnt',title:'感染人数',width:100,align:'center',
					formatter: function(value,row,index){
						if (value==0){
							return value;
						}else {
							var type =1;
							return "<a href='#' style='white-space:normal;color:blue' onclick='objScreen.OpenDiagDtl(\""+type+"\",\""+row.ID+"\");' >"+value+ "</a>";
						}
					}
				},
				{field:'InfRepCnt',title:'感染例次数',width:100,align:'center'},
				{field:'ScreenPatCnt',title:'疑似人数',width:80,align:'center',sortable:true,
					formatter: function(value,row,index){
						if (value==0){
							return value;
						}else {
							var type =2;
							return "<a href='#' style='white-space:normal;color:blue' onclick='objScreen.OpenDiagDtl(\""+type+"\",\""+row.ID+"\");' >"+value+ "</a>";
						}
					}
				},
				{field:'TPRRatio',title:'疑似率',width:80,align:'center',sortable:true},		
				{field:'DiagnosCnt',title:'确诊人数',width:80,align:'center',sortable:true,
					formatter: function(value,row,index){
						if (value==0){
							return value;
						}else {
							var type =3;
							return "<a href='#' style='white-space:normal;color:blue' onclick='objScreen.OpenDiagDtl(\""+type+"\",\""+row.ID+"\");' >"+value+ "</a>";
						}
					}
				},
				{field:'DiagRatio',title:'确诊率',width:80,align:'center',sortable:true},
				{field:'ExcludeCnt',title:'排除人数',width:80,align:'center',sortable:true,
					formatter: function(value,row,index){
						if (value==0){
							return value;
						}else {
							var type =4;
							return "<a href='#' style='white-space:normal;color:blue' onclick='objScreen.OpenDiagDtl(\""+type+"\",\""+row.ID+"\");' >"+value+ "</a>";
						}
					}
				},
				{field:'ExcRatio',title:'排除率',width:80,align:'center',sortable:true},
				{field:'InfUnScreenCnt',title:'感染非疑似(FN)',width:120,align:'center',sortable:true,	
					formatter: function(value,row,index){
						if (value==0){
							return value;
						}else {
							var type =5;
							return "<a href='#' style='white-space:normal;color:blue' onclick='objScreen.OpenDiagDtl(\""+type+"\",\""+row.ID+"\");' >"+value+ "</a>";
						}
					}
				},									
				{field:'FNRRatio',title:'假阴性率',width:80,align:'center',sortable:true}		
			]]
		});
	}
	function LoadLocScreenStaTab() {      //科室维度--图表		
		$HUI.datagrid("#ScreenSta",{
			fit: true,
			rownumbers: true, //如果为true, 则显示一个行号列
			singleSelect: true,
			nowrap:false,		
			loadMsg:'数据加载中...',
			loading:true,
			pageSize: 20,
			pageList : [20,50,100,200],
			pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
			url:$URL,
			queryParams:{
				ClassName:"DHCHAI.AMS.ScreenResultSrv",
				QueryName:"QryLocScreenRate",
				aHospIDs:$('#cboHospital').combobox('getValue'),
				aDateFrom:$('#dtDateFrom').datebox('getValue'),
				aDateTo:$('#dtDateTo').datebox('getValue'),
				aAdmStatus:$('#cboAdmStatus').combobox('getValue')
			},	    
			columns:[[
				{field:'LocDesc',title:'科室',width:200,
					formatter: function(value,row,index) {
						if (row.LocID==""){
							return value;
						} else {
							return '<span style="padding-left:15px">'+value+'</span>';
						}
					}
				},
				{field:'PatCnt',title:'患者人数',width:80,align:'center',
					formatter: function(value,row,index){
						if (value==0){
							return value;
						}else {
							var type =1;
							return "<a href='#' style='white-space:normal;color:blue' onclick='objScreen.OpenLocDtl(\""+row.LocID+"\",\""+type+"\");' >"+value+ "</a>";
						}
					}
				},
				{field:'InfPatCnt',title:'感染人数',width:80,align:'center',
					formatter: function(value,row,index){
						if (value==0){
							return value;
						}else {
							var type =2;
							return "<a href='#' style='white-space:normal;color:blue' onclick='objScreen.OpenLocDtl(\""+row.LocID+"\",\""+type+"\");' >"+value+ "</a>";
						}
					}
				},
				{field:'InfRepCnt',title:'感染例次数',width:100,align:'center'},
				{field:'InfPatRatio',title:'感染率',width:80,align:'center'}, 
				{field:'InfRepRatio',title:'感染例次率',width:100,align:'center'},	
				{field:'ScreenPatCnt',title:'疑似人数',width:80,align:'center',sortable:true,
					formatter: function(value,row,index){
						if (value==0){
							return value;
						}else {
							var type =3;
							return "<a href='#' style='white-space:normal;color:blue' onclick='objScreen.OpenLocDtl(\""+row.LocID+"\",\""+type+"\");' >"+value+ "</a>";
						}
					}
				},
				{field:'ScreenRatio',title:'疑似率',width:80,align:'center',sortable:true},
				{field:'DiagnosCnt',title:'确诊人数',width:80,align:'center',sortable:true,
					formatter: function(value,row,index){
						if (value==0){
							return value;
						}else {
							var type =4;
							return "<a href='#' style='white-space:normal;color:blue' onclick='objScreen.OpenLocDtl(\""+row.LocID+"\",\""+type+"\");' >"+value+ "</a>";
						}
					}
				},
				{field:'DiagRatio',title:'确诊率',width:80,align:'center',sortable:true},
				{field:'ExcludeCnt',title:'排除人数',width:80,align:'center',sortable:true,
					formatter: function(value,row,index){
						if (value==0){
							return value;
						}else {
							var type =5;
							return "<a href='#' style='white-space:normal;color:blue' onclick='objScreen.OpenLocDtl(\""+row.LocID+"\",\""+type+"\");' >"+value+ "</a>";
						}
					}
				}, 
				{field:'ExcRatio',title:'排除率',width:80,align:'center',sortable:true},
				{field:'UnOperCnt',title:'未处置人数',width:100,align:'center',sortable:true,
					formatter: function(value,row,index){
						if (value==0){
							return value;
						}else {
							var type =6;
							return "<a href='#' style='white-space:normal;color:blue' onclick='objScreen.OpenLocDtl(\""+row.LocID+"\",\""+type+"\");' >"+value+ "</a>";
						}
					}
				}, 
				{field:'UnOperRatio',title:'未处置率',width:80,align:'center',sortable:true}
			]]
		});
	}
	
	//*********************************************************************↓↓↓感染诊断维度--图表  
	obj.up=function(x,y){
        return y.ScreeningCnt-x.ScreeningCnt
    }
   	obj.ShowScreenEcharts = function(){  
		obj.myChart.clear();
		var HospIDs = $('#cboHospital').combobox('getValue');
		var DateFrom = $('#dtDateFrom').datebox('getValue');
		var DateTo= $('#dtDateTo').datebox('getValue');
		var AdmStatus = $('#cboAdmStatus').combobox('getValue');
		
		obj.myChart.showLoading();	//隐藏加载动画
		$cm({
			ClassName:"DHCHAI.AMS.ScreenResultSrv",
			QueryName:"QrySuRuleRate",
			aHospIDs:HospIDs, 
			aDateFrom:DateFrom, 
			aDateTo:DateTo, 
			aLocType:AdmStatus
		},function(rs){
			obj.myChart.hideLoading();    //隐藏加载动画
			obj.eachartSuRuleRate(rs);
		});
	}
	 obj.eachartSuRuleRate = function(runQuery){
		if (!runQuery) return;
		var arrRuleNote 	   = new Array();
		var arrScreeningCnt    = new Array();	
		var arrScreenRatio     = new Array();	
		var arrDiagnosCnt      = new Array();		 //确诊人数
		var arrDiagRatio 	   = new Array();       
		var arrExcludeCnt      = new Array();		 //排除人数
		var arrExcRatio 	   = new Array();       
		var arrInfScreenCnt    = new Array();	     //感染疑似人数
		var arrRepUnScreenCnt  = new Array();	     //感染非疑似人数
		var arrScreenUnInfCnt  = new Array();	     //疑似非感染人数
		var arrACCRatio 	   = new Array();       //准确率
		var arrTPRRatio 	   = new Array();       //灵敏度
		var arrTNRRatio 	   = new Array();       //特异度
		var arrPPVRatio 	   = new Array();       //阳性预测值
		var arrNPVRatio 	   = new Array();       //阴性预测值
		var arrFNRRatio 	   = new Array();       //假阴性率
		var arrFPRRatio 	   = new Array();       //假阳性率
		arrRecord 		= runQuery.rows;
		
		var arrlength		= 0;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			rd["TPRRatio"] = parseFloat(rd["TPRRatio"].replace('%','').replace('‰','')).toFixed(2);
		}
		
		arrRecord = arrRecord.sort(obj.up);
		arrRecord.length = arrRecord.length - arrlength;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			
			arrRuleNote.push(rd["RuleNote"]);
			arrScreeningCnt.push(rd["ScreeningCnt"]);
			arrScreenRatio.push(parseFloat(rd["ScreenRatio"]).toFixed(2));
			arrDiagnosCnt.push(rd["DiagnosCnt"]);
			arrDiagRatio.push(parseFloat(rd["DiagRatio"]).toFixed(2));
			arrExcludeCnt.push(rd["ExcludeCnt"]);
			arrExcRatio.push(parseFloat(rd["ExcRatio"]).toFixed(2));
			arrInfScreenCnt.push(rd["InfScreenCnt"]);
			arrRepUnScreenCnt.push(rd["RepUnScreenCnt"]);
			arrScreenUnInfCnt.push(rd["ScreenUnInfCnt"]);
			arrACCRatio.push(parseFloat(rd["ACCRatio"]).toFixed(2));
			arrTPRRatio.push(parseFloat(rd["TPRRatio"]).toFixed(2));
			arrTNRRatio.push(parseFloat(rd["TNRRatio"]).toFixed(2));
			arrPPVRatio.push(parseFloat(rd["PPVRatio"]).toFixed(2));
			arrNPVRatio.push(parseFloat(rd["NPVRatio"]).toFixed(2));
			arrFNRRatio.push(parseFloat(rd["FNRRatio"]).toFixed(2));
			arrFPRRatio.push(parseFloat(rd["FPRRatio"]).toFixed(2));	
		}
		var endnumber = (14/arrRuleNote.length)*100;
		// 使用刚指定的配置项和数据显示图表。
		obj.myChart.setOption(obj.optionRate(arrRuleNote,arrScreeningCnt,arrScreenRatio,arrDiagnosCnt,arrDiagRatio,arrExcludeCnt,arrExcRatio,arrInfScreenCnt,arrRepUnScreenCnt,arrScreenUnInfCnt,arrACCRatio,arrTPRRatio,arrTNRRatio,arrPPVRatio,arrNPVRatio,arrFNRRatio,arrFPRRatio,endnumber),true);
	}
	
	obj.optionRate = function(arrRuleNote,arrScreeningCnt,arrScreenRatio,arrDiagnosCnt,arrDiagRatio,arrExcludeCnt,arrExcRatio,arrInfScreenCnt,arrRepUnScreenCnt,arrScreenUnInfCnt,arrACCRatio,arrTPRRatio,arrTNRRatio,arrPPVRatio,arrNPVRatio,arrFNRRatio,arrFPRRatio,endnumber){
		var optionRate = {
			title : {
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
				data:['疑似人数','感染疑似人数','感染非疑似人数','疑似率','确诊率','排除率','准确率','灵敏度','特异度','阳性预测值','阴性预测值','假阴性率','假阳性率'],
				selected:{
					"感染疑似人数":false,
					"感染非疑似人数":false,	
					"疑似率":false,
					"确诊率":false,
					"排除率":false,		
					"准确率":false,
					"阳性预测值":false,
					"阴性预测值":false,
                    "假阴性率":false,
					"假阳性率":false
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
					data: arrRuleNote,
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
					name: '疑似人数',
					min: 0,
					interval:Math.ceil(arrScreeningCnt[0]/10),
					axisLabel: {
						formatter: '{value} '
					}
				},
				{
					type: 'value',
					name: '灵敏度(%)',
					min: 0,
					interval:10,
					axisLabel: {
						formatter: '{value} %'
					}
				}
			],
			series: [
				 {
					name:'疑似人数',
					type:'bar',
					barMaxWidth:50,
					data:arrScreeningCnt
				},

				{
					name:'感染疑似人数',
					type:'bar',
					barMaxWidth:50,
					data:arrInfScreenCnt
				},
		
				{
					name:'感染非疑似人数',
					type:'bar',
					barMaxWidth:50,
					data:arrRepUnScreenCnt
				},
				{
					name:'疑似率',
					type:'line',
					yAxisIndex: 1,
					data:arrScreenRatio,
					label: {
						show:true,
						formatter:"{c}%"
					}
				},
				{
					name:'确诊率',
					type:'line',
					yAxisIndex: 1,
					data:arrDiagRatio,
					label: {
						show:true,
						formatter:"{c}%"
					}
				},
				{
					name:'排除率',
					type:'line',
					yAxisIndex: 1,
					data:arrExcRatio,
					label: {
						show:true,
						formatter:"{c}%"
					}
				},
				{
					name:'准确率',
					type:'line',
					yAxisIndex: 1,
					data:arrACCRatio,
					label: {
						show:true,
						formatter:"{c}%"
					}
				} ,			
				{
					name:'灵敏度',
					type:'line',
					yAxisIndex: 1,
					data:arrTPRRatio,
					label: {
						show:true,
						formatter:"{c}%"
					}
				} ,
				{
					name:'特异度',
					type:'line',
					yAxisIndex: 1,
					data:arrTNRRatio,
					label: {
						show:true,
						formatter:"{c}%"
					}
				} ,
				{
					name:'阳性预测值',
					type:'line',
					yAxisIndex: 1,
					data:arrPPVRatio,
					label: {
						show:true,
						formatter:"{c}%"
					}
				} ,
				{
					name:'阴性预测值',
					type:'line',
					yAxisIndex: 1,
					data:arrNPVRatio,
					label: {
						show:true,
						formatter:"{c}%"
					}
				} ,
				{
					name:'假阴性率',
					type:'line',
					yAxisIndex: 1,
					data:arrFNRRatio,
					label: {
						show:true,
						formatter:"{c}%"
					}
				} ,
				{
					name:'假阳性率',
					type:'line',
					yAxisIndex: 1,
					data:arrFPRRatio,
					label: {
						show:true,
						formatter:"{c}%"
					}
				} 
			]
		};
		return optionRate;
	}
	//********************************************************************* ↑↑↑指标维度--图表  
	
	//********************************************************************* ↓↓↓科室维度--图表      
	obj.upLoc=function(x,y){
        return y.ScreenPatCnt-x.ScreenPatCnt
    }
    
   	obj.ShowLocScreenEcharts = function(){  
		obj.myChart.clear();
		var HospIDs = $('#cboHospital').combobox('getValue');
		var DateFrom = $('#dtDateFrom').datebox('getValue');
		var DateTo= $('#dtDateTo').datebox('getValue');
		var AdmStatus = $('#cboAdmStatus').combobox('getValue');
	
		obj.myChart.showLoading();	//隐藏加载动画
		$cm({
			ClassName:"DHCHAI.AMS.ScreenResultSrv",
			QueryName:"QryLocScreenRate",
			aHospIDs:HospIDs, 
			aDateFrom:DateFrom, 
			aDateTo:DateTo, 
			aAdmStatus:AdmStatus
		},function(rs){
			obj.myChart.hideLoading();    //隐藏加载动画
			obj.eachartLocScreen(rs);
		});
	}
	
	
	obj.eachartLocScreen = function(runQuery){
		if (!runQuery) return;
		var arrLocDesc 	       = new Array();
		var arrInfPatCnt       = new Array();	    //感染人数
		var arrInfPatRatio     = new Array();	    
		var arrInfRepCnt       = new Array();	    //感染例次数
		var arrInfRepRatio     = new Array();	
		var arrScreenPatCnt    = new Array();	    //疑似人数
		var arrScreenRatio     = new Array();	
		var arrDiagnosCnt      = new Array();		//确诊人数
		var arrDiagRatio 	   = new Array();       
		var arrExcludeCnt      = new Array();		//排除人数
		var arrExcRatio 	   = new Array();       
		arrRecord 		= runQuery.rows;
		
		var arrlength = 0;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			//去掉全院
			if (rd["LocID"]=="") {
				delete arrRecord[indRd];
				arrlength = arrlength + 1;
				continue;
			}		
			rd["ScreenRatio"] = parseFloat(rd["ScreenRatio"].replace('%','').replace('‰','')).toFixed(2);
		}
		
		arrRecord = arrRecord.sort(obj.upLoc);
		arrRecord.length = arrRecord.length - arrlength;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			
			arrLocDesc.push(rd["LocDesc"]);
			arrInfPatCnt.push(rd["InfPatCnt"]);
			arrInfPatRatio.push(parseFloat(rd["InfPatRatio"]).toFixed(2));
			arrInfRepCnt.push(rd["InfRepCnt"]);
			arrInfRepRatio.push(parseFloat(rd["InfRepRatio"]).toFixed(2));
			arrScreenPatCnt.push(rd["ScreenPatCnt"]);
			arrScreenRatio.push(parseFloat(rd["ScreenRatio"]).toFixed(2));
			arrDiagnosCnt.push(rd["DiagnosCnt"]);
			arrDiagRatio.push(parseFloat(rd["DiagRatio"]).toFixed(2));
			arrExcludeCnt.push(rd["ExcludeCnt"]);
			arrExcRatio.push(parseFloat(rd["ExcRatio"]).toFixed(2));
	
		}
		var endnumber = (14/arrLocDesc.length)*100;
		// 使用刚指定的配置项和数据显示图表。
		obj.myChart.setOption(obj.optionLoc(arrLocDesc,arrInfPatCnt,arrInfPatRatio,arrInfRepCnt,arrInfRepRatio,arrScreenPatCnt,arrScreenRatio,arrDiagnosCnt,arrDiagRatio,arrExcludeCnt,arrExcRatio,endnumber),true);
	}
	
	obj.optionLoc = function(arrLocDesc,arrInfPatCnt,arrInfPatRatio,arrInfRepCnt,arrInfRepRatio,arrScreenPatCnt,arrScreenRatio,arrDiagnosCnt,arrDiagRatio,arrExcludeCnt,arrExcRatio,endnumber){
		var optionLoc = {
			title : {
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
				data:['感染人数','感染例次数','疑似人数','确诊人数','排除人数','感染率','感染例次率','疑似率','确诊率','排除率'],
				selected:{
					"感染例次数":false,
					"确诊人数":false,
					"排除人数":false,					
					"感染例次率":false,
					"确诊率":false,
					"排除率":false
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
					data: arrLocDesc,
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
					name: '疑似人数',
					min: 0,
					interval:Math.ceil(arrScreenPatCnt[0]/10),
					axisLabel: {
						formatter: '{value} '
					}
				},
				{
					type: 'value',
					name: '疑似率(%)',
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
					name:'感染例次数',
					type:'bar',
					barMaxWidth:50,
					data:arrInfRepCnt
				},
				 {
					name:'疑似人数',
					type:'bar',
					barMaxWidth:50,
					data:arrScreenPatCnt
				},
				{
					name:'确诊人数',
					type:'bar',
					barMaxWidth:50,
					data:arrDiagnosCnt
				},
				{
					name:'排除人数',
					type:'bar',
					barMaxWidth:50,
					data:arrExcludeCnt
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
				} ,			
				{
					name:'感染例次率',
					type:'line',
					yAxisIndex: 1,
					data:arrInfRepRatio,
					label: {
						show:true,
						formatter:"{c}%"
					}
				} ,
				{
					name:'疑似率',
					type:'line',
					yAxisIndex: 1,
					data:arrScreenRatio,
					label: {
						show:true,
						formatter:"{c}%"
					}
				},
				{
					name:'确诊率',
					type:'line',
					yAxisIndex: 1,
					data:arrDiagRatio,
					label: {
						show:true,
						formatter:"{c}%"
					}
				},
				{
					name:'排除率',
					type:'line',
					yAxisIndex: 1,
					data:arrExcRatio,
					label: {
						show:true,
						formatter:"{c}%"
					}
				}
				
			]
		};
		return optionLoc;
	}
	//********************************************************************* ↑↑↑科室维度--图表 

		
	//********************************************************************* ↓↓↓科室维度--图表      
	obj.upDiag=function(x,y){
        return y.InfPatCnt-x.InfPatCnt
    }
    
   	obj.ShowDiagScreenEcharts = function(){  
		obj.myChart.clear();
		var HospIDs = $('#cboHospital').combobox('getValue');
		var DateFrom = $('#dtDateFrom').datebox('getValue');
		var DateTo= $('#dtDateTo').datebox('getValue');
		var AdmStatus = $('#cboAdmStatus').combobox('getValue');
		
		obj.myChart.showLoading();	//隐藏加载动画
		$cm({
			ClassName:"DHCHAI.AMS.ScreenResultSrv",
			QueryName:"QryDiagScreenRate",
			aHospIDs:HospIDs, 
			aDateFrom:DateFrom, 
			aDateTo:DateTo, 
			aAdmStatus:AdmStatus,
			page: 1,
            rows: 999
		},function(rs){
			obj.myChart.hideLoading();    //隐藏加载动画
			obj.eachartDiagScreen(rs);
		});
	}
	
	
	obj.eachartDiagScreen = function(runQuery){
		if (!runQuery) return;
		var arrInfDiag 	       = new Array();
		var arrInfPatCnt       = new Array();	    //感染人数
		var arrInfPatRatio     = new Array();	    
		var arrInfRepCnt       = new Array();	    //感染例次数
		var arrInfRepRatio     = new Array();	
		var arrScreenPatCnt    = new Array();	    //疑似人数
		var arrScreenRatio     = new Array();	
		var arrDiagnosCnt      = new Array();		//确诊人数
		var arrDiagRatio 	   = new Array();       
		var arrExcludeCnt      = new Array();		//排除人数
		var arrExcRatio 	   = new Array();       
		arrRecord 		= runQuery.rows;
		
		var arrlength = 0;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			//去掉合计
			if (rd["ID"]=="") {
				delete arrRecord[indRd];
				arrlength = arrlength + 1;
				continue;
			}		
			rd["TPRRatio"] = parseFloat(rd["TPRRatio"].replace('%','').replace('‰','')).toFixed(2);
		}
		
		arrRecord = arrRecord.sort(obj.upDiag);
		arrRecord.length = arrRecord.length - arrlength;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			
			arrInfDiag.push(rd["InfDiag"]);
			arrInfPatCnt.push(rd["InfPatCnt"]);
			arrInfPatRatio.push(parseFloat(rd["InfPatRatio"]).toFixed(2));
			arrInfRepCnt.push(rd["InfRepCnt"]);
			arrInfRepRatio.push(parseFloat(rd["InfRepRatio"]).toFixed(2));
			arrScreenPatCnt.push(rd["ScreenPatCnt"]);
			arrScreenRatio.push(parseFloat(rd["TPRRatio"]).toFixed(2));
			arrDiagnosCnt.push(rd["DiagnosCnt"]);
			arrDiagRatio.push(parseFloat(rd["DiagRatio"]).toFixed(2));
			arrExcludeCnt.push(rd["ExcludeCnt"]);
			arrExcRatio.push(parseFloat(rd["ExcRatio"]).toFixed(2));
	
		}
		var endnumber = (14/arrInfDiag.length)*100;
		// 使用刚指定的配置项和数据显示图表。
		obj.myChart.setOption(obj.optionDiag(arrInfDiag,arrInfPatCnt,arrInfPatRatio,arrInfRepCnt,arrInfRepRatio,arrScreenPatCnt,arrScreenRatio,arrDiagnosCnt,arrDiagRatio,arrExcludeCnt,arrExcRatio,endnumber),true);
	}
	
	obj.optionDiag = function(arrInfDiag,arrInfPatCnt,arrInfPatRatio,arrInfRepCnt,arrInfRepRatio,arrScreenPatCnt,arrScreenRatio,arrDiagnosCnt,arrDiagRatio,arrExcludeCnt,arrExcRatio,endnumber){
		var optionDiag = {
			title : {
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
				data:['感染人数','感染例次数','疑似人数','确诊人数','排除人数','感染率','感染例次率','疑似率','确诊率','排除率'],
				selected:{
					"感染例次数":false,
					"确诊人数":false,
					"排除人数":false,					
					"感染例次率":false,
					"确诊率":false,
					"排除率":false
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
					data: arrInfDiag,
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
					name: '疑似人数',
					min: 0,
					interval:Math.ceil(arrScreenPatCnt[0]/10),
					axisLabel: {
						formatter: '{value} '
					}
				},
				{
					type: 'value',
					name: '疑似率(%)',
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
					name:'感染例次数',
					type:'bar',
					barMaxWidth:50,
					data:arrInfRepCnt
				},
				 {
					name:'疑似人数',
					type:'bar',
					barMaxWidth:50,
					data:arrScreenPatCnt
				},
				{
					name:'确诊人数',
					type:'bar',
					barMaxWidth:50,
					data:arrDiagnosCnt
				},
				{
					name:'排除人数',
					type:'bar',
					barMaxWidth:50,
					data:arrExcludeCnt
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
				} ,			
				{
					name:'感染例次率',
					type:'line',
					yAxisIndex: 1,
					data:arrInfRepRatio,
					label: {
						show:true,
						formatter:"{c}%"
					}
				} ,
				{
					name:'疑似率',
					type:'line',
					yAxisIndex: 1,
					data:arrScreenRatio,
					label: {
						show:true,
						formatter:"{c}%"
					}
				},
				{
					name:'确诊率',
					type:'line',
					yAxisIndex: 1,
					data:arrDiagRatio,
					label: {
						show:true,
						formatter:"{c}%"
					}
				},
				{
					name:'排除率',
					type:'line',
					yAxisIndex: 1,
					data:arrExcRatio,
					label: {
						show:true,
						formatter:"{c}%"
					}
				}
				
			]
		};
		return optionDiag;
	}
	//********************************************************************* ↑↑↑感染诊断维度--图表 

	obj.gridRateDtl = $HUI.datagrid("#RateDtlTab",{
		fit: true,
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		toolbar: [{
            text:'导出',
            iconCls:'icon-export',
            handler:function(){$('#RateDtlTab').datagrid('toExcel','明细数据.xls');}
        }],
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,		
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		url:$URL,
	    queryParams:{
			ClassName:'DHCHAI.AMS.ScreenResultSrv',
			QueryName:'QrySuRuleRateDtl'
	    },
		columns:[[
			{field:'PapmiNo',title:'登记号',width:100,sortable:true},
			{field:'MrNo',title:'病案号',width:100,sortable:true},
			{field:'PatName',title:'姓名',width:100},
			{field:'Sex',title:'性别',width:60},
			{field:'Age',title:'年龄',width:60},
			{field:'link',title:'摘要',width:60,align:'center',
				formatter: function(value,row,index){
					return " <a href='#' style='white-space:normal; color:blue' onclick='objScreen.OpenView(\"" + row.EpisodeID + "\");'>摘要</a>";
				}
			},
			{field:'InfRepList',title:'感染报告情况',width:250,showTip:true,
				formatter: function(value,row,index){
					if (!value){
					  	return "";
				  	}else {
				  		var strList = value.split("^");
					  	var len = strList.length;	   
					    var strRet ="";
					  	for (var indx=0;indx<len;indx++){
						  	var ReportID =strList[indx].split(" ")[0];
						  	var InfDate =strList[indx].split(" ")[1];
						  	var InfPos =strList[indx].split(" ")[2];
						  	var InfSub =strList[indx].split(" ")[3];
							if (InfSub) {
								InfPos = InfPos+"("+InfSub+")"
							}
						  	var RepStatus =strList[indx].split(" ")[4];
					        strRet +="<a href='#' class='icon-paper-info' style='line-height:30px;' data-options='plain:true,' onclick='objScreen.btnDetail_Click(\"" + ReportID + "\",\"" + row.EpisodeID + "\");'>&nbsp;&nbsp;&nbsp;&nbsp;</a><span>"+" "+InfPos+"&nbsp;&nbsp;"+InfDate+"</span></br>";
					  	}
					  	return strRet;
					}	
				}
			},
			{field:'SusResult',title:'疑似筛查结果',width:400,showTip:true,
				formatter: function(value,row,index){
					if (!value){
					  	return "";
				  	}else {
				  		var strList = value.split(",");
					  	var len = strList.length;	   
					    var strRet ="";
					  	for (var indx=0;indx<len;indx++){
						  	var SusResultDtl =value.split(",")[indx];					  
					        strRet +="<span style='line-height:30px;' >"+SusResultDtl+"</span></br>";
					  	}
					  	return strRet;
					}	
				}
			},
			{field:'RuleOprDtl',title:'处置情况',width:500,showTip:true,
				formatter: function(value,row,index){
					if (!value){
					  	return "";
				  	}else {
				  		var strList = value.split("^");
					  	var len = strList.length;	   
					    var strRet ="";
					  	for (var indx=0;indx<len;indx++){
						  	var Details =strList[indx].split(",")[1];
						  	var Status  =strList[indx].split(",")[2];
						  	var ActDate =strList[indx].split(",")[3];
							var ActTime =strList[indx].split(",")[4];
							var ActUser =strList[indx].split(",")[5];
				
					        strRet +="<span style='line-height:30px;'>"+Details+"&nbsp;&nbsp;<span style='color:red'>"+Status+"</span>&nbsp;&nbsp;"+"("+ActDate+"&nbsp;"+ActTime+"&nbsp;"+ActUser+")"+"</span></br>";
					  	}
					  	return strRet;
					}	
				}
			},
			{field:'AdmDate',title:'就诊日期',width:100,sortable:true},
			{field:'AdmTime',title:'就诊时间',width:80,sortable:true},
			{field:'AdmLocDesc',title:'就诊科室',width:150,sortable:true},
			{field:'AdmWardDesc',title:'就诊病区',width:180,sortable:true},
			{field:'DischDate',title:'出院日期',width:100,sortable:true},
			{field:'DischTime',title:'出院时间',width:80,sortable:true},
			{field:'DischLocDesc',title:'出院科室',width:150},
			{field:'DischWardDesc',title:'出院病区',width:180}
		]]
	});

	InitScreeningWinEvent(obj);
	obj.LoadEvent(arguments);
		
	return obj;
}


