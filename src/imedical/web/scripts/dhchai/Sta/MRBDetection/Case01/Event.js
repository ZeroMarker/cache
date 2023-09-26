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
	$.form.SelectRender("#cboMRBRule");  //��Ⱦ������
	
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
			text: '������ҩ�������'
		},
		tooltip: {
			trigger: 'axis',
		},
		toolbox: {
			"show": true
		},
		legend: {
			data:['��������','�����','��Ӧ��ԭ��'],
			selected: {
				'��Ӧ��ԭ��': false
			}
		},
		xAxis: [{
			type: 'category',
			data: [],
			axisLabel: {
				margin:8,
				rotate:45,
				interval:0
				// ʹ�ú���ģ�壬���������ֱ�Ϊ�̶���ֵ����Ŀ�����̶ȵ�����
				,formatter: function (value, index) {
					//�����ǩ���������к�ʡ��
					if(value.length>6 && value.length<11){
						return value.substr(0,7)+'\n'+value.substr(7,3);
					}else if(value.length>10){
						return value.substr(0,6)+'\n'+value.substr(6,5)+"...";
					}else{
						return value;
					}
				}
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
			},{
				type: 'value',
				name: '�����(%)',
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
				name:'�����',
				type:'line',
				yAxisIndex: 1,
				data:[],
				label: {
					show:true,
					formatter:"{c}%"
				}
			},{
				name:'��Ӧ��ԭ��',
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
	
	//�л���ѯ����
	$("input:radio[name='cboType']").on('ifChecked', function(event){
		if ($("input[name='cboType']:checked").val() == "1") {
			$("#cboMRBRule option:first").prop("selected", true);
			$("#cboMRBRule").attr("disabled", true);
		} else {
			$("#cboMRBRule").attr("disabled", false);
		}
	});
	var MRBRule = $.Tool.RunServerMethod('DHCHAI.STAS.MRBDetectionSrv','GetMRBRule', "","");
	var MRBRuleJson = $.parseJSON(MRBRule);
	//��������������
	$.each(MRBRuleJson, function(index, value) {
		$("#cboMRBRule").append("<option value='"+index+"'>"+index+"</option>");
	});
	$("#cboMRBRule").attr("disabled", true);
	//���ͷ�����ʾ
	var htmlStr='<div><b>������ҩ���������</b></div><ul>';
	$.each(MRBRuleJson, function(index, value) {
		htmlStr += '<li>'+ index +'</li>';
		htmlStr += '<ul>';
		htmlStr += '<li>���ͣ�'+ value.MRB +'</li>';
		htmlStr += '<li>��ԭ�壺'+ value.Bacteria +'</li>';
		htmlStr += '</ul>';
	});
	htmlStr += '</ul>';
	$("#QueryDesc").html(htmlStr);
	
    //��ѯ��ť
    $("#btnQuery").on('click', function(){
		var HospID=$.form.GetValue("cboHospital");
		var LocID=$.form.GetValue("cboLocation");
		var MonthFrom=$.form.GetValue("DateFrom");
		var MonthTo=$.form.GetValue("DateTo");
		var Type = $("input[name='cboType']:checked").val();
		var MRBRule = $.form.GetValue("cboMRBRule");
		
		if (Type==1){
			//������
			var dataInput = "ClassName=" + 'DHCHAI.STAS.MRBDetectionSrv' + "&QueryName=" + 'QryMRBDetection' + "&Arg1="+HospID+"&Arg2=" + LocID + "&Arg3=" + MonthFrom + "&Arg4=" + MonthTo + "&Arg5=1&ArgCnt=" + 5;
		} else if(Type==2) {
			//��ʱ��
			var dataInput = "ClassName=" + 'DHCHAI.STAS.MRBDetectionSrv' + "&QueryName=" + 'QryMRBDeteByTime'+ "&Arg1="+HospID+"&Arg2=" + LocID + "&Arg3=" + MonthFrom + "&Arg4=" + MonthTo + "&Arg5=1&Arg6=" + MRBRule + "&ArgCnt=" + 6;
		} else if(Type==3) {
			//������
			var dataInput = "ClassName=" + 'DHCHAI.STAS.MRBDetectionSrv' + "&QueryName=" + 'QryMRBDeteByLoc' + "&Arg1="+HospID+"&Arg2=" + LocID + "&Arg3=" + MonthFrom + "&Arg4=" + MonthTo + "&Arg5=1&Arg6=" + MRBRule + "&Arg7=&ArgCnt=" + 7;
		}
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
		var arrBactCount = new Array();
		var arrRecord = runQuery.record;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			arrxAxis.push(rd["AxisName"]);
			arrMRBCount.push(rd["Numerator"]);
			arrBactCount.push(rd["Denominator"]);
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
				data:arrBactCount
			}]
		});
	}
   
}

