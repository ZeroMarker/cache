function InitCtlResultWinEvent(obj){
	CheckSpecificKey();
	// ��ʼ��Ȩ��
	obj.AdminPower  = '0';
	if (typeof tDHCMedMenuOper != 'undefined')
	{
		if (typeof tDHCMedMenuOper['Admin'] != 'undefined')
		{
			obj.AdminPower  = tDHCMedMenuOper['Admin'];
		}
	}
	
	//��ֵ��ʼֵ
    $("#cboHospital").data("param",$.LOGON.HOSPID);	
	$.form.SelectRender("#cboHospital");  //��Ⱦ������	
	
	$("#cboHospital option:selected").next().attr("selected", true)
	$("#cboHospital").select2();
	//��select2��ֵchange�¼�
	$("#cboHospital").on("select2:select", function (e) { 
		//���ѡ�е�ҽԺ
		var data= e.params.data;
		var id = data.id;
		var text =data.text;
		$("#cboInfLocation").data("param",id+"^^I^E^1");
		$.form.SelectRender("cboInfLocation");  //��Ⱦ������	
	});	
	
	$("#cboInfLocation").data("param",$.form.GetValue("cboHospital")+"^^I^E^1");
	$.form.SelectRender("cboInfLocation");
	
	var myChart = echarts.init(document.getElementById('Case01'), 'theme');
	var option1 = {
		title : {
			text: '��Ⱦ©�����ͳ��'
		},
		tooltip: {
			trigger: 'axis',
		},
		toolbox: {
			"show": true
		},
		legend: {
			data:['©������','Ӧ������','©����']
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
				name: '©��/Ӧ������',
				splitLine: {
					show: false
				},
				axisLabel: {
					formatter: '{value} '
				}
			},
			{
				type: 'value',
				name: '©����(%)',
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
				name:'©������',
				type:'bar',
				data:[],
				label: {
					show:true,
					formatter:"{c}"
				}
			},
			{
				name:'Ӧ������',
				type:'bar',
				data:[],
				label: {
					show:true,
					formatter:"{c}"
				}
			},
			{
				name:'©����',
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
	// ʹ�ø�ָ�����������������ʾͼ��
	myChart.setOption(option1);
	
    //��ѯ��ť
    $("#btnQuery").on('click', function(){
		var HospID=$.form.GetValue("cboHospital");
		var LocID=$.form.GetValue("cboInfLocation");
		var MonthFrom=$.form.GetValue("DateFrom");
		var MonthTo=$.form.GetValue("DateTo");
		
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
		
		var dataInput = "ClassName=" + 'DHCHAI.IRS.InfOmissionSrv' + "&QueryName=" + 'QryOmissionEcharts' + "&Arg1=" + HospID + "&Arg2=" + LocID + "&Arg3=" + MonthFrom+ "&Arg4=" + MonthTo + "&ArgCnt=" + 4;
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
			layer.alert("��ѯʧ�ܣ������ѯ������",{icon: 2});
			return  false;
		}
		var arrxAxis = new Array();
		var arrRatio = new Array();
		var arrMissCount = new Array();
		var arrNeedCount = new Array();
		var arrRecord = runQuery.record;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			arrxAxis.push(rd["xAxis"]);
			arrMissCount.push(rd["MissCount"]);
			arrNeedCount.push(rd["NeedCount"]);
			arrRatio.push(parseFloat(rd["Ratio"]*100).toFixed(2));
		}
		myChart.setOption({        //��������ͼ��
			xAxis: {
				data: arrxAxis
			},
			series: [{
				data:arrMissCount
			},{
				data:arrNeedCount
			},{
				data:arrRatio
			}]
		});
	}
   
}

