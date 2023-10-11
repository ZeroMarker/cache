$(function () {
	InitComparisonWin();
});
//页面Gui
var objScreen = new Object();
function InitComparisonWin(){
	var obj = objScreen;
	obj.myChart = echarts.init(document.getElementById('EchartDiv'),'theme');
	
	//对比
	$('#btnQuery').on('click', function(){
		obj.ShowEcharts();
	});
	//评估模型
	obj.cboModel = $HUI.combogrid('#cboModel', {
		panelWidth: 1000,
		multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
	    pagination: true,
		blurValidValue: true, //为true时，光标离开时，检查是否选中值,没选中则置空输入框的值
		fitColumns: true,     //真正的自动展开/收缩列的大小，以适应网格的宽度，防止水平滚动条
		idField: 'ID',
		textField: 'AMDesc',
		url: $URL,
		queryParams:{ClassName: 'DHCHAI.AMS.AssessModelSrv',QueryName: 'QryAssessModel',aIsActive:1},
		columns: [[
			{field:'AMCode',title:'模型代码',width:100},
			{field:'AMDesc',title:'模型定义',width:350},
			{field:'AdmStatusDesc',title:'状态',width:100},
			{field:'SttDate',title:'开始日期',width:100},
			{field:'EndDate',title:'结束日期',width:100}
			
		]]
	});

   	obj.ShowEcharts = function(){ 
		obj.myChart.clear();
		var arrModel = $('#cboModel').combobox('getValues');
		var ModelIDs = arrModel.toString();
		obj.myChart.showLoading();	//隐藏加载动画
		$cm({
			ClassName:"DHCHAI.AMS.AssessRateSrv",
			QueryName:"QryComparison",
			aModelDrs:ModelIDs,
			page: 1,
			rows: 999
		},function(rs){
			obj.myChart.hideLoading();    //隐藏加载动画
			obj.eacharRate(rs);
		});
	}
	 obj.eacharRate = function(runQuery) {
		if (!runQuery) return;
		var arrModelDesc 	   = new Array();
		var arrACCRatio 	   = new Array();       //准确率
		var arrTPRRatio 	   = new Array();       //灵敏度
		var arrTNRRatio 	   = new Array();       //特异度
		var arrPPVRatio 	   = new Array();       //阳性预测值
		var arrNPVRatio 	   = new Array();       //阴性预测值
		var arrFNRRatio 	   = new Array();       //假阴性率
		var arrFPRRatio 	   = new Array();       //假阳性率
		arrRecord 	= runQuery.rows;		
		var arrlength = 0;
		arrlength = arrRecord.length - arrlength;
		for (var indRd = 0; indRd < arrlength; indRd++){
			var rd = arrRecord[indRd];			
			arrModelDesc.push(rd["ModelDesc"]);
			arrACCRatio.push(parseFloat(rd["ACCRatio"]).toFixed(2));
			arrTPRRatio.push(parseFloat(rd["TPRRatio"]).toFixed(2));
			arrTNRRatio.push(parseFloat(rd["TNRRatio"]).toFixed(2));
			arrPPVRatio.push(parseFloat(rd["PPVRatio"]).toFixed(2));
			arrNPVRatio.push(parseFloat(rd["NPVRatio"]).toFixed(2));
			arrFNRRatio.push(parseFloat(rd["FNRRatio"]).toFixed(2));
			arrFPRRatio.push(parseFloat(rd["FPRRatio"]).toFixed(2));	
		}
		var endnumber = (14/arrlength)*100;
		option1 = {
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
				data:['准确率','灵敏度','特异度','阳性预测值','阴性预测值','假阴性率','假阳性率'],
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
			xAxis: {
				type: 'category',
				data: arrModelDesc,
				axisLabel: {
					margin:10,
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
			},
			yAxis: {
				type: 'value',
				axisLabel: {
					formatter: '{value} %'
				}
			},
		 	 series: [
				{
					name:'准确率',
					type:'line',
					data:arrACCRatio,
					label: {
						show:true,
						formatter:"{c}%"
					}
				},
				{
					name:'灵敏度',
					type:'line',
					data:arrTPRRatio,
					label: {
						show:true,
						formatter:"{c}%"
					}
				},
				{
					name:'特异度',
					type:'line',
					data:arrTNRRatio,
					label: {
						show:true,
						formatter:"{c}%"
					}
				},
				{
					name:'阳性预测值',
					type:'line',
					data:arrPPVRatio,
					label: {
						show:true,
						formatter:"{c}%"
					}
				},
				{
					name:'阴性预测值',
					type:'line',
					data:arrNPVRatio,
					label: {
						show:true,
						formatter:"{c}%"
					}
				},
				{
					name:'假阴性率',
					type:'line',
					data:arrFNRRatio,
					label: {
						show:true,
						formatter:"{c}%"
					}
				},
				{
					name:'假阳性率',
					type:'line',
					data:arrFPRRatio,
					label: {
						show:true,
						formatter:"{c}%"
					}
				}
			]
		};
		
		obj.myChart.setOption(option1);
	}
}


