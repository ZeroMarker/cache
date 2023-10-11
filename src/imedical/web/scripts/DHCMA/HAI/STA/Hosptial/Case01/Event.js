
function InitCtlResultWinEvent(obj){
	obj.myChart = echarts.init(document.getElementById('Case01'),'theme');

	obj.loadEvent = function(args){
		obj.ShowEChart1();	
	}
	
	obj.ShowEChart1 = function(){
		obj.myChart.clear()
		 //���¿��Ҹ�Ⱦ��ͼ��
		var dataInput = "ClassName=" + 'DHCHAI.STAS.ChartsSrv' + "&QueryName=" + 'QryLocInfRatio' + "&Arg1=" + $.LOGON.LOCID 	+ "&Arg2=" + $('#SearchMonth').datebox("getValue") + "&ArgCnt=" + 2;
		$.ajax({
			url: "./dhchai.query.csp",
			type: "post",
			timeout: 30000, //30�볬ʱ
			async: true,   //�첽
			data: dataInput,
			success: function(data, textStatus){
				var retval = (new Function("return " + data))();
				obj.echartLocInfRatio(retval);
			},
			error: function(XMLHttpRequest, textStatus, errorThrown){
				var tkclass="DHCHAI.STAS.ChartsSrv";
				var tkQuery="QryLocInfRatio";
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
  
	obj.ShowEChart2 = function(){
		var dataInput = "ClassName=" + 'DHCHAI.STAS.ChartsSrv' + "&QueryName=" + 'QryInfPosByRep' + "&Arg1=" +  "&Arg2=" + 	1 + "&Arg3=" + 	$('#SearchMonth').datebox("getValue") + "&ArgCnt=" + 3;
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
				var tkclass="DHCHAI.STAS.ChartsSrv";
				var tkQuery="QryInfPosByRep";
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
		 //���¿��Ҹ�Ⱦ��ͼ��
		var dataInput = "ClassName=" + 'DHCHAI.STAS.ChartsSrv' + "&QueryName=" + 'QryLocInfRatio' + "&Arg1=" +$.LOGON.LOCID+ "&Arg2=" + $('#SearchMonth').datebox("getValue") + "&ArgCnt=" + 2;
		$.ajax({
			url: "./dhchai.query.csp",
			type: "post",
			timeout: 30000, //30�볬ʱ
			async: true,   //�첽
			data: dataInput,
			success: function(data, textStatus){
				var retval = (new Function("return " + data))();
				obj.MakeTable(retval);
				
			},
			error: function(XMLHttpRequest, textStatus, errorThrown){
				var tkclass="DHCHAI.STAS.ChartsSrv";
				var tkQuery="QryLocInfRatio"
				alert("��" + tkclass + ":" + tkQuery + "ִ�д���,Status:" + textStatus + ",Error:" + errorThrown);
			}
		});
		obj.MakeTable = function(runQuery){
			if (!runQuery) return;
			$('#gridInfList').datagrid('loadData', runQuery.record);			
			
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
							return
							 //���ô���-��ʼ��
							
							$HUI.dialog('#tableInfList').open();
							
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
