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
		$("#cboLocation").data("param",id+"^^I|E^E^1");
		$.form.SelectRender("cboLocation");  //��Ⱦ������	
	});	
	$("#cboLocation").data("param",$.form.GetValue("cboHospital")+"^^I|E^E^1");
	$.form.SelectRender("cboLocation");
	
	var myChart = echarts.init(document.getElementById('Case01'), 'theme');
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
		var HospID=$.form.GetValue("cboHospital");
		var LocID=$.form.GetValue("cboLocation");
		var MonthFrom=$.form.GetValue("DateFrom");
		var MonthTo=$.form.GetValue("DateTo");
		
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
			layer.msg('û���ҵ�������ݣ�',{icon: 2});
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

