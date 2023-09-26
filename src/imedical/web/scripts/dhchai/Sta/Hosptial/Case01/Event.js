function InitCtlResultWinEvent(obj){
	CheckSpecificKey();
	obj.myChart = echarts.init(document.getElementById('Case01'),'theme');
	obj.loadEvent = function(){
		obj.DateFrom=$.form.GetValue("DateFrom");
		obj.QryOpption="label01"
		obj.ShowEChaert1();
		$('#DateFrom').datetimepicker().on('changeMonth', function(ev){
			var year=parseInt(ev.date.getYear())-100
			var month=parseInt(ev.date.getMonth())+1;
			obj.DateFrom="20"+year +"-"+ month
			if(obj.QryOpption=="label01") {
				obj.ShowEChaert1();
			} else if(obj.QryOpption=="label02") {
				obj.ShowEChaert2();
			} else if(obj.QryOpption=="label03") {
				obj.ShowTable1();
			}
		});
		
		$(".Opption").on("click",function (e) {
			$(".Opption").css("background-color","");
			$(".Opption").css("color","#000000");
			$("#"+this.id).css("background-color","#40A2DE");
			$("#"+this.id).css("color","#FFFFFF");
			$('#Case01').css('display','none');
			$('#Case02').css('display','none');
			obj.QryOpption=this.id;
			if(obj.QryOpption=="label01") {
				$('#Case01').css('display','block');
				obj.ShowEChaert1();
			} else if(obj.QryOpption=="label02") {
				$('#Case01').css('display','block');
				obj.ShowEChaert2();
			} else if(obj.QryOpption=="label03") {
				$('#Case02').css('display','block');
				obj.ShowTable1();
			}
		})
	}
	
	obj.ShowEChaert1 = function(){
		obj.myChart.clear()
		$('#img-Loading').css('display','block');
		 //���¿��Ҹ�Ⱦ��ͼ��
		var dataInput = "ClassName=" + 'DHCHAI.STAS.ChartsSrv' + "&QueryName=" + 'QryLocInfRatio' + "&Arg1=" + $.LOGON.LOCID + "&Arg2=" + obj.DateFrom + "&ArgCnt=" + 2;
		$.ajax({
			url: "./dhchai.query.csp",
			type: "post",
			timeout: 30000, //30�볬ʱ
			async: true,   //�첽
			data: dataInput,
			success: function(data, textStatus){
				var retval = (new Function("return " + data))();
				obj.echartLocInfRatio(retval);
				$('#img-Loading').css('display','none');
			},
			error: function(XMLHttpRequest, textStatus, errorThrown){
				alert("��" + tkclass + ":" + tkQuery + "ִ�д���,Status:" + textStatus + ",Error:" + errorThrown);
			}
		});
	   obj.echartLocInfRatio = function(runQuery){
			if (!runQuery) return;
			var arrViewLoc = new Array();
			var arrInfRatio = new Array();
			var arrInfCount = new Array();
			obj.arrLocG= new Array();
			var arrRecord = runQuery.record;
			for (var indRd = 0; indRd < arrRecord.length; indRd++){
				var rd = arrRecord[indRd];
				arrViewLoc.push(rd["LocDesc"]);
				arrInfCount.push(rd["InfCount"]);
				arrInfRatio.push(parseFloat(rd["InfRatio"]).toFixed(2));
				obj.arrLocG.push(rd["LocID"]);
			}
			var option1 = {
				title : {
					text: '��Ⱦ���Σ��ʣ�ͳ��ͼ',
					x:'left'
				},
				tooltip: {
					trigger: 'axis',
				},
				toolbox: {
					"show": true,
					right:'18px'
				},
				legend: {
					data:['��Ⱦ����','��Ⱦ��'],
					textStyle: {
			            color: "#000000",
			            fontSize: 16
			        }
				},
				xAxis: [
					{
						type: 'category',
						data: arrViewLoc,
						/* axisPointer: {
							type: 'shadow'
						} */
						axisLabel: {
									margin:8,
									rotate:45,
									interval:0,
									// ʹ�ú���ģ�壬���������ֱ�Ϊ�̶���ֵ����Ŀ�����̶ȵ�����
									formatter: function (value, index) {
										//�����ǩ���������к�ʡ��
										if(value.length>6 && value.length<11){
											return value.substr(0,5)+'\n'+value.substr(5,5);
										}else if(value.length>10){
											return value.substr(0,6)+'\n'+value.substr(6,4)+"...";
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
						name: '��Ⱦ����',
				        nameTextStyle: {
				            color: '#000000',
				       		//padding: [0, 0, 10, -10]
				        },
						min: 0,
						interval:10,
						axisLabel: {
							formatter: '{value} '
						}
					},
					{
						type: 'value',
						name: '��Ⱦ��(%)',
						nameTextStyle: {
				            color: '#000000',
				       		//padding: [0, 0, 10, -10]
				        },
						min: 0,
						interval:10,
						axisLabel: {
							formatter: '{value} %'
						}
					}
				],
				series: [
					 {
						name:'��Ⱦ����',
						type:'bar',
						barMaxWidth:50,
						data:arrInfCount
					},
					{
						name:'��Ⱦ��',
						type:'line',
						yAxisIndex: 1,
						data:arrInfRatio,
						label: {
							show:true,
							formatter:"{c}%"
						}
					}
				   
				]
			};
			// ʹ�ø�ָ�����������������ʾͼ��
			obj.myChart.setOption(option1,true);
		}
	}
  
	obj.ShowEChaert2 = function(){
		var dataInput = "ClassName=" + 'DHCHAI.STAS.ChartsSrv' + "&QueryName=" + 'QryInfPosByRep' + "&Arg1=" + $.LOGON.HOSPID + "&Arg2=" + 1 + "&Arg3=" + obj.DateFrom + "&ArgCnt=" + 3;
		$.ajax({
			url: "./dhchai.query.csp",
			type: "post",
			timeout: 30000, //30�볬ʱ
			async: true,   //�첽
			data: dataInput,
			success: function(data, textStatus){
				var retval = (new Function("return " + data))();
				obj.echartPosDescPie(retval);
			},
			error: function(XMLHttpRequest, textStatus, errorThrown){
				alert("��" + tkclass + ":" + tkQuery + "ִ�д���,Status:" + textStatus + ",Error:" + errorThrown);
			}
			});
			obj.echartPosDescPie = function(runQuery){
			   if (!runQuery) return;
				var arrPosDesc = new Array();
				var arrPosCount = new Array();
				
				var arrRecord = runQuery.record;
				for (var indRd = 0; indRd < arrRecord.length; indRd++){
					var rd = arrRecord[indRd];
					arrPosDesc.push(rd["PosDesc"]);
					arrPosCount.push({"value":rd["PosCount"],"name":rd["PosDesc"]});
				}
				
			var option2 = {
				title : {
					text: '��Ⱦ���ͳ��ͼ',
					x:'center'
				},
				tooltip : {
					trigger: 'item',
					formatter: "{a} <br/>{b} : {c} ({d}%)"
				},
				 toolbox: {
					"show": true
				},
				legend: {
					orient: 'vertical',
					left: 'right',
					top:'middle',
					data: arrPosDesc
				},
				series : [
					{
						name: '��Ⱦ���',
						type: 'pie',
						radius : '55%',
						center: ['50%', '60%'],
						data:arrPosCount,
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
			// ʹ�ø�ָ�����������������ʾͼ��
			obj.myChart.setOption(option2,true);
		}
	}
	
	obj.ShowTable1 = function(){
		obj.myChart.clear()
		$('#img-Loading').css('display','block');
		 //���¿��Ҹ�Ⱦ��ͼ��
		var dataInput = "ClassName=" + 'DHCHAI.STAS.ChartsSrv' + "&QueryName=" + 'QryLocInfRatio' + "&Arg1=" + $.LOGON.LOCID + "&Arg2=" + obj.DateFrom + "&ArgCnt=" + 2;
		$.ajax({
			url: "./dhchai.query.csp",
			type: "post",
			timeout: 30000, //30�볬ʱ
			async: true,   //�첽
			data: dataInput,
			success: function(data, textStatus){
				var retval = (new Function("return " + data))();
				obj.MakeTable(retval);
				$('#img-Loading').css('display','none');
			},
			error: function(XMLHttpRequest, textStatus, errorThrown){
				alert("��" + tkclass + ":" + tkQuery + "ִ�д���,Status:" + textStatus + ",Error:" + errorThrown);
			}
		});
		obj.MakeTable = function(runQuery){
			if (!runQuery) return;
			
			var htmlTable=""
			htmlTable = htmlTable + '<table id="gridHAI" class="table table-striped table-bordered" cellspacing="0" width="100%">';
			htmlTable = htmlTable + '<thead>';
			htmlTable = htmlTable + '<tr>';
			htmlTable = htmlTable + '<th><b>���</b></th>';
			htmlTable = htmlTable + '<th width="30%"><b>����</b></th>';
			htmlTable = htmlTable + '<th><b>��Ⱦ����</b></th>';
			htmlTable = htmlTable + '<th><b>ͬ���ڿ�����</b></th>';
			htmlTable = htmlTable + '<th><b>��Ⱦ���η�����</b></th>';
			htmlTable = htmlTable + '</tr>';
			htmlTable = htmlTable + '</thead>';
			var arrRecord = runQuery.record;
			for (var indRd = 0; indRd < arrRecord.length; indRd++){
				var rd = arrRecord[indRd];
				htmlTable=htmlTable+"<tr><td>"+rd["ind"]+"</td>"
				htmlTable=htmlTable+"<td>"+rd["LocDesc"]+"</td>"
				htmlTable=htmlTable+"<td>"+rd["InfCount"]+"</td>"
				htmlTable=htmlTable+"<td>"+rd["InLocCount"]+"</td>"
				htmlTable=htmlTable+"<td>"+parseFloat(rd["InfRatio"]).toFixed(2)+"%</td></tr>"
				
			}
			$("#Case02").html(htmlTable)
		}
	}
	
	obj.myChart.on('click', function (params) {
		if (params.value>0){
			if (params.seriesType=="line"){
				if (params.seriesIndex==1){
					var LocID=obj.arrLocG[params.dataIndex];	//ҽ�񴦣�����ȫԺ
					var Month=obj.DateFrom;
					var RepType="";
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

