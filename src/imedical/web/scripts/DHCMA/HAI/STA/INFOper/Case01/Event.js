function InitEvent(obj){
	
	//��ʼ��ͼ��
	var myChart = echarts.init(document.getElementById('EchartDiv'),'theme');
	obj.loadEvent=function(){
		
		obj.setOption();
	}
	obj.setOption=function(){
		if (obj.QryOpption=="label01"){
			obj.QueryName = "QryECResultByTime";
			obj.Numerator = "INFOper";
			obj.Denominator = "OperCount";
			
			var option1 = {
				title : {
					text: '�����пڸ�Ⱦͳ��',
					x:'left'
				},
				tooltip: {
					trigger: 'axis',
				},
				toolbox: {
					"show": true
				},
				legend: {
					data:['��Ⱦ����','��Ⱦ��','��������'],
					selected: {
						'��������': false
					}
				},
				xAxis: [
					{
						type: 'category',
						data: [],
						axisLabel: {
							margin:8,
							rotate:45
						}
					}
				],
				yAxis: [
					{
						type: 'value',
						name: '��Ⱦ����',
						splitLine: {
							show: false
						},
						axisLabel: {
							formatter: '{value} '
						}
					},{
						type: 'value',
						name: '��Ⱦ��(��)',
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
						name:'��Ⱦ����',
						type:'bar',
						data:[],
						label: {
							show:true,
							formatter:"{c}"
						}
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
						name:'��������',
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
		} else if(obj.QryOpption=="label02") {
			obj.QueryName = "QryECResultByTime";
			obj.Numerator = "INFOper1";
			obj.Denominator = "Oper1Count";
			
			var option1 = {
				title : {
					text: '�����пڸ�Ⱦͳ��',
					x:'left'
				},
				tooltip: {
					trigger: 'axis',
				},
				toolbox: {
					"show": true
				},
				legend: {
					data:['��Ⱦ����','��Ⱦ��','I���п�����'],
					selected: {
						'I���п�����': false
					}
				},
				xAxis: [
					{
						type: 'category',
						data: [],
						axisLabel: {
							margin:8,
							rotate:45
						}
					}
				],
				yAxis: [
					{
						type: 'value',
						name: '��Ⱦ����',
						splitLine: {
							show: false
						},
						axisLabel: {
							formatter: '{value} '
						}
					},{
						type: 'value',
						name: '��Ⱦ��(��)',
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
						name:'��Ⱦ����',
						type:'bar',
						data:[],
						barMaxWidth:50,
						label: {
							show:true,
							formatter:"{c}"
						}
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
						name:'I���п�����',
						type:'bar',
						data:[],
						barMaxWidth:50,
						label: {
							show:true,
							formatter:"{c}"
						}
					}
				   
				]
			};
			// ʹ�ø�ָ�����������������ʾͼ��
			myChart.setOption(option1,true);
		} else if(obj.QryOpption=="label03") {
			obj.QueryName = "QryECResultForPie";
			obj.ItemStr = "INFSuperInc^INFDeepInc^INFOrganInc";
			var option2 = {
				title : {
					text: '��Ⱦ���ͳ��ͼ',
					x:'center'
				},
				tooltip : {
					trigger: 'item',
					formatter: "{a} <br/>{b} : {c} ({d}%)",
					textStyle: {
						fontSize: 20
					}
				},
				 toolbox: {
					"show": true,
					feature: {
						mark: {show: true}
					}
				},
				legend: {
					orient: 'vertical',
					left: 'right',
					top:'middle',
					data: []
				},
				series : [
					{
						name: '��Ⱦ���',
						type: 'pie',
						radius : '55%',
						center: ['50%', '60%'],
						data:[],
						itemStyle: {
							emphasis: {
								shadowBlur: 10,
								shadowOffsetX: 0,
								shadowColor: 'rgba(0, 0, 0, 0.5)'
							}
						},
						label: {
							show:true,
							formatter:"{b}\n {c} ({d}%)",
							fontSize:18
						}
					}
				]
			};
			myChart.setOption(option2,true);
		}
	}
	
    obj.echartLineBar = function(runQuery){
	    if (!runQuery) alert(1);
		var arrTime = new Array();
		var arrInfRatio = new Array();
		var arrInfCount = new Array();
		var arrOperCount = new Array();

		var arrRecord = runQuery.record;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			arrTime.push(rd["ECTime"]);
			arrInfCount.push(rd["Value1"]);
			arrOperCount.push(rd["Value2"]);
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
				data:arrOperCount
			}]
		});
		
    }
	
	obj.echartPie = function(runQuery){
		if (!runQuery) return;
		var arrItemDesc = new Array();
		var arrValue = new Array();
		var arrRecord = runQuery.record;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			var ItemDesc=rd["ItemDesc"].replace(/��Ⱦ����/,"")
			arrItemDesc.push(ItemDesc);
			arrValue.push({"value":rd["Value"],"name":ItemDesc});
		}
		myChart.setOption({        //��������ͼ��
			legend: {
				data: arrItemDesc
			},
			series: [{
				data:arrValue
			}]
		});
	}
	obj.keyWords_onClick=function(kayId){
		obj.QryOpption=kayId
		obj.setOption();
		var LocID=$("#cboInfLocation").combobox("getValue")
		var MonthFrom=$("#DateFrom").datebox("getValue")
		var MonthTo=$("#DateTo").datebox("getValue")
		//���¿��Ҹ�Ⱦ��ͼ��
		var dataInput = "ClassName=" + 'DHCHAI.STAS.ChartsSrv' + "&QueryName=" + obj.QueryName + "&Arg1=" + LocID + "&Arg2=" + MonthFrom + "&Arg3=" + MonthTo+ "&Arg4=" + obj.Numerator + "&Arg5=" + obj.Denominator + "&ArgCnt=" + 5;
		if(obj.QryOpption=="label03") dataInput = "ClassName=" + 'DHCHAI.STAS.ChartsSrv' + "&QueryName=" + obj.QueryName + "&Arg1=" + LocID + "&Arg2=" + MonthFrom + "&Arg3=" + MonthTo+ "&Arg4=" + obj.ItemStr + "&ArgCnt=" + 4;
		
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
				if(obj.QryOpption=="label01") {
					obj.echartLineBar(retval);
				} else if(obj.QryOpption=="label02") {
					obj.echartLineBar(retval);
				} else if(obj.QryOpption=="label03") {
					obj.echartPie(retval);
				}
			},
			error: function(XMLHttpRequest, textStatus, errorThrown){
				alert("ִ�д���,Status:" + textStatus + ",Error:" + errorThrown);
				myChart.hideLoading();    //���ؼ��ض���
			}
		});
				
	}
}

