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
	
	$("#cboInfLocation").data("param",$.form.GetValue("cboHospital")+"^^I^E^1");
	$.form.SelectRender("cboInfLocation");
	$.form.SelectRender("cboRepType");	
	//��select2��ֵchange�¼�
	$("#cboHospital").on("select2:select", function (e) { 
		//���ѡ�е�ҽԺ
		var data= e.params.data;
		var id = data.id;
		var text =data.text;
		$("#cboInfLocation").data("param",id+"^^I^E^1");
		$.form.SelectRender("cboInfLocation");  //��Ⱦ������	
	});
	
	//��ʼ��ͼ��
	var myChart = echarts.init(document.getElementById('Case01'),'theme');
	
	obj.ShowChart = function(){
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
	
	/****************/
    //��ѯ��ť
    $("#btnQuery").on('click', function(){
		var LocID=$.form.GetValue("cboInfLocation")
		var MonthFrom=$.form.GetValue("DateFrom")
		var MonthTo=$.form.GetValue("DateTo")
		//���¿��Ҹ�Ⱦ��ͼ��
		var dataInput = "ClassName=" + 'DHCHAI.STAS.ChartsSrv' + "&QueryName=" + obj.QueryName + "&Arg1=" + LocID + "&Arg2=" + MonthFrom + "&Arg3=" + MonthTo+ "&Arg4=" + obj.Numerator + "&Arg5=" + obj.Denominator + "&ArgCnt=" + 5;
		if(obj.QryOpption=="label03") dataInput = "ClassName=" + 'DHCHAI.STAS.ChartsSrv' + "&QueryName=" + obj.QueryName + "&Arg1=" + LocID + "&Arg2=" + MonthFrom + "&Arg3=" + MonthTo+ "&Arg4=" + obj.ItemStr + "&ArgCnt=" + 4;
		if ((MonthFrom!="")||(MonthTo!=""))
		{ 
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
		}else{
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
	});
	
	$(".Opption").on("click",function (e, IsQuery) {
		$(".Opption").css("background-color","");
		$(".Opption").css("color","#000000");
		$("#"+this.id).css("background-color","#40A2DE");
		$("#"+this.id).css("color","#FFFFFF");
		obj.QryOpption=this.id;
		obj.ShowChart();
		$("#btnQuery").click(); //Ĭ�ϲ�ѯ
	});
	//Ĭ�ϴ򿪵�һ��ҳǩ
	obj.QryOpption="label01";
	obj.ShowChart();
	
    obj.arrTimeG=""
    obj.echartLineBar = function(runQuery){
	    if (!runQuery) alert(1);
		var arrTime = new Array();
		var arrInfRatio = new Array();
		var arrInfCount = new Array();
		var arrOperCount = new Array();
		obj.arrTimeG=arrTime
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
	
	myChart.on('click', function (params) {
		if (params.value>0){
			if (params.seriesType=="line"){
				if (params.seriesIndex==1){
					var LocID=$.form.GetValue("cboInfLocation");
					var Month=obj.arrTimeG[params.dataIndex];
					var RepType=4;
					if(obj.QryOpption=="label02") RepType=5;
					var strHtml="";
					var dataInput = "ClassName=" + 'DHCHAI.STAS.ChartsSrv' + "&QueryName=" + 'QryInfPatList' + "&Arg1=" + LocID + "&Arg2=" + Month + "&Arg3=" + RepType + "&ArgCnt=" + 3;
					
					$.ajax({
						url: "./dhchai.query.csp",
						type: "post",
						timeout: 30000, //30�볬ʱ
						async: true,   //�첽
						data: dataInput,
						success: function(data, textStatus){
							var retval = (new Function("return " + data))();
							var arrRecord = retval.record;
							for (var indRd = 0; indRd < arrRecord.length; indRd++){
								var rd = arrRecord[indRd];
								strHtml=strHtml+"<tr><td>"+rd["ind"]+"</td>"
								strHtml=strHtml+"<td>"+rd["PatMrNo"]+"</td>"
								strHtml=strHtml+"<td>"+rd["PatName"]+"</td>"
								strHtml=strHtml+"<td>"+rd["PatSex"]+"</td>"
								strHtml=strHtml+"<td>"+rd["InfPosDescs"]+"</td>"
								strHtml=strHtml+"<td>"+rd["InfLocDesc"]+"</td>"
								strHtml=strHtml+"<td>"+rd["IRInfDate"]+"</td>"
								strHtml=strHtml+"<td>"+rd["StatusDesc"]+"</td></tr>"
							}
							$("#tableInfList tbody").html(strHtml)
							layer.open({
								type: 1,
								zIndex: 99999,
								skin: 'btn-all-blue',
								area: ['80%','60%'],
								title:'',
								fixed: false, //���̶�
								content: $('#tableInfList'),
								success: function(layero, index){
								
								},
							});
						},
						error: function(XMLHttpRequest, textStatus, errorThrown){
							alert("ִ�д���,Status:" + textStatus + ",Error:" + errorThrown);
						}
					});
				}
			}
		}
	}); 
   
}

