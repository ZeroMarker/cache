function InitCtlResultWinEvent(obj){
	
	//��ʼ��ͼ��
	var myChart = echarts.init(document.getElementById('EchartDiv'),'theme');
	
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
	 $HUI.radio("[name='cboType']",{
        onChecked:function(e,value){
            if ($(e.target).val()=="1"){
	            $("#cboMRBRule").combobox("setValue",""); 
	            $("#cboMRBRule").combobox('disable');
	            
            }else{
	            $("#cboMRBRule").combobox('enable');
            }
        }
    });
    //��ѯ��ť
    $("#btnQuery").on('click', function(){
		var HospID=$("#cboHospital").combobox("getValue");
		var LocID=$("#cboLocation").combobox("getValue");
		var MonthFrom=$("#DateFrom").datebox("getValue");
		var MonthTo=$("#DateTo").datebox("getValue");
		var Type = $("input[name='cboType']:checked").val();
		var MRBRule = $("#cboMRBRule").combobox("getValue");
		
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
			$.messager.alert("����ʾ", 'û���ҵ��������', "info");
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

