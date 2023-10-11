function InitWinEvent(obj){
	
	var myChart = echarts.init(document.getElementById('EchartDiv'), 'theme');
	var option1 = {
		title : {
			text: '������ҩ��������'
		},
		tooltip: {
			trigger: 'axis',
		},
		toolbox: {
			"show": true
		},
		legend: {
			data:['��������','������','סԺ����'],
			selected: {
				'סԺ����': false
			}
		},
		xAxis: [{
			type: 'category',
			data: [],
			axisLabel: {
				margin:8,
				rotate:45,
				interval:0
			}
		}],
		yAxis: [
			{
				type: 'value',
				name: '��������',
				splitLine: {
					show: false
				},
				axisLabel: {
					formatter: '{value} '
				}
			},
			{
				type: 'value',
				name: '������(%)',
				splitLine: {
					show: false
				},
				axisLabel: {
					formatter: '{value} %'
				}
			}
		],
		series: [
			{
				name:'��������',
				type:'bar',
				data:[],
				label: {
					show:true,
					formatter:"{c}"
				}
			},
			{
				name:'������',
				type:'line',
				yAxisIndex: 1,
				data:[],
				label: {
					show:true,
					formatter:"{c}%"
				}
			},
			{
				name:'סԺ����',
				type:'bar',
				data:[],
				label: {
					show:true,
					formatter:"{c}"
				}
			}
		]
	};
	// ʹ�ø�ָ�����������������ʾͼ��
	myChart.setOption(option1,true);
	
    //��ѯ��ť
    $("#btnQuery").on('click', function(){
		var HospID=$("#cboHospital").combobox("getValue");
		var LocID=$("#cboLocation").combobox("getValue");
		var MonthFrom=$("#DateFrom").datebox("getValue");
		var MonthTo=$("#DateTo").datebox("getValue");
		
		var dataInput = "ClassName=" + 'DHCHAI.STAS.ChartsSrv' + "&QueryName=" + 'QryECResultByTime' +"&Arg1=" + LocID + "&Arg2=" + MonthFrom + "&Arg3=" + MonthTo + "&Arg4=MRBAdmCount&Arg5=InHospCount" + "&Arg6=" +HospID+"&ArgCnt=" + 6;
		var ErrorStr = "";
		if (MonthFrom=="") {
			ErrorStr += '��ѡ��ʼ����!<br/>';
		}
		if (MonthTo == "") {
			ErrorStr += '��ѡ���������!<br/>';
		}
		if (MonthFrom > MonthTo) {
			ErrorStr += '��ʼ���ڲ��ܴ��ڽ�������!<br/>';
		}
		if (ErrorStr != '') {
			$.messager.alert("����ʾ", ErrorStr, "info");
			return;
		}
	
		$.ajax({
			url: "./dhchai.query.csp",
			type: "post",
			timeout: 30000, //30�볬ʱ
			async: true,   //�첽
			beforeSend: function() {
				 myChart.showLoading();
			},
			data: dataInput,
			success: function(data, textStatus){
				myChart.hideLoading();    //���ؼ��ض���
				var retval = (new Function("return " + data))();
				obj.echartRatio(retval);
			},
			error: function(XMLHttpRequest, textStatus, errorThrown){
				alert("��" + tkclass + ":" + tkQuery + "ִ�д���,Status:" + textStatus + ",Error:" + errorThrown);
				myChart.hideLoading();    //���ؼ��ض���
			}
		});
		
	});
	
	
	
	obj.echartRatio = function(runQuery){
		
		if (!runQuery) {
			$.messager.alert("����ʾ", "û���ҵ��������", "info");
			return;
		}
		var arrxAxis = new Array();
		var arrRatio = new Array();
		var arrMRBCount = new Array();
		var arrInHospCount = new Array();
		var arrRecord = runQuery.record;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			arrxAxis.push(rd["ECTime"]);
			arrMRBCount.push(rd["Value1"]);
			arrInHospCount.push(rd["Value2"]);
			arrRatio.push(parseFloat(rd["Ratio"]).toFixed(2));
		}
		myChart.setOption({        //��������ͼ��
			xAxis: {
				data: arrxAxis
			},
			series: [{
				data:arrMRBCount
			},{
				data:arrRatio
			},{
				data:arrInHospCount
			}]
		});
	}
}

