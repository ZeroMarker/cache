function InitCtlResultWinEvent(obj){
	// ��ʼ��Ȩ��
	obj.AdminPower  = '0';
	if (typeof tDHCMedMenuOper != 'undefined')
	{
		if (typeof tDHCMedMenuOper['Admin'] != 'undefined')
		{
			obj.AdminPower  = tDHCMedMenuOper['Admin'];
		}
	}
	
	//��Ⱦͼ��
	var myChart = echarts.init(document.getElementById('Case01'),'theme');
	
	var option1 = {
		title : {
			text: '��Ⱦ���Σ��ʣ�ͳ��ͼ',
			x:'left'
		},
		tooltip: {
			trigger: 'axis'
		},
		toolbox: {
			"show": true
		},
		legend: {
			data:['��Ⱦ����','��Ⱦ��','סԺ����'],
			selected: {
				'סԺ����': false
			}
		},
		xAxis: [
			{
				type: 'category',
				data: [],
				axisLabel: {
					margin:8,
					rotate:45,
					interval:0
				}
			}
		],
		yAxis: [
			{
				type: 'value',
				name: '��Ⱦ����',
				axisLabel: {
					formatter: '{value} '
				}
			},{
				type: 'value',
				name: '��Ⱦ��(%)',
				axisLabel: {
					formatter: '{value} %'
				}
			},{
				show: false,
				type: 'value',
				name: 'סԺ����',
				axisLabel: {
					formatter: '{value} '
				}
			}
		],
		series: [
			{
				name:'��Ⱦ����',
				type:'bar',
				barMaxWidth:50,
				data:[]
			},{
				name:'��Ⱦ��',
				type:'line',
				yAxisIndex: 1,
				data:[],
				label: {
					show:true,
					formatter:"{c}%"
				}
			},{
				name:'סԺ����',
				type:'bar',
				barMaxWidth:50,
				data:[]
			}
		   
		]
	};
	myChart.setOption(option1);
	/****************/
    //��ѯ��ť
    $("#btnQuery").on('click', function(){
	        var HospID=$("#cboHospital").combobox("getValue");
		var LocID=$("#cboInfLocation").combobox("getValue");
		var RepType=$("#cboRepType").combobox("getValue");
		var MonthFrom=$("#DateFrom").datebox("getValue");
		var MonthTo=$("#DateTo").datebox("getValue")
		if (RepType=="1") {
			var Numerator="HAICase"; //����
			var Denominator="InHospCount"; //��ĸ
		} else {
			var Numerator="BabyHAICase"; //����
			var Denominator="BabyInHosp"; //��ĸ
		}
		
		//���¿��Ҹ�Ⱦ��ͼ��
		var dataInput = "ClassName=" + 'DHCHAI.STAS.ChartsSrv' + "&QueryName=" + 'QryECResultByTime' + "&Arg1=" + LocID + "&Arg2=" + MonthFrom + "&Arg3=" + MonthTo+ "&Arg4=" + Numerator + "&Arg5=" + Denominator + "&Arg6=" + HospID + "&ArgCnt=" + 6;
		
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
				layer.msg(ErrorStr,{icon: 0});
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
				obj.echartLocInfRatio(retval);
			},
			error: function(XMLHttpRequest, textStatus, errorThrown){
				alert("��" + tkclass + ":" + tkQuery + "ִ�д���,Status:" + textStatus + ",Error:" + errorThrown);
				myChart.hideLoading();    //���ؼ��ض���
			}
		});
	});
   
   
   obj.echartLocInfRatio = function(runQuery){
		if (!runQuery) {
			layer.alert("��ѯʧ�ܣ������ѯ������",{icon: 2});
			return  false;
		}
		var arrTime = new Array();
		var arrInfRatio = new Array();
		var arrInfCount = new Array();
		var arrInHospCount = new Array();
		var arrRecord = runQuery.record;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			arrTime.push(rd["ECTime"]);
			arrInfCount.push(rd["Value1"]);
			arrInHospCount.push(rd["Value2"]);
			arrInfRatio.push(parseFloat(rd["Ratio"]).toFixed(2));
		}
		myChart.setOption({        //��������ͼ��
			xAxis: {
				data: arrTime
			},
			series: [{
				data:arrInfCount
			},{
				data:arrInfRatio
			},{
				data:arrInHospCount
			}]
		});
	}
	
}

