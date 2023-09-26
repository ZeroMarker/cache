function InitCtlResultWinEvent(obj){
	CheckSpecificKey();
	// 初始化权限
	obj.AdminPower  = '0';
	if (typeof tDHCMedMenuOper != 'undefined')
	{
		if (typeof tDHCMedMenuOper['Admin'] != 'undefined')
		{
			obj.AdminPower  = tDHCMedMenuOper['Admin'];
		}
	}
	
	//赋值初始值
    $("#cboHospital").data("param",$.LOGON.HOSPID);	
	$.form.SelectRender("#cboHospital");  //渲染下拉框	
	$("#cboHospital option:selected").next().attr("selected", true)
	$("#cboHospital").select2();
	
	$("#cboInfLocation").data("param",$.form.GetValue("cboHospital")+"^^I^E^1");
	$.form.SelectRender("cboInfLocation");
	$.form.SelectRender("cboRepType");	
	//给select2赋值change事件
	$("#cboHospital").on("select2:select", function (e) { 
		//获得选中的医院
		var data= e.params.data;
		var id = data.id;
		var text =data.text;
		$("#cboInfLocation").data("param",id+"^^I^E^1");
		$.form.SelectRender("cboInfLocation");  //渲染下拉框	
	});
	
	//初始化图表
	var myChart = echarts.init(document.getElementById('Case01'),'theme');
	
	obj.ShowChart = function(){
		if (obj.QryOpption=="label01"){
			obj.QueryName = "QryECResultByTime";
			obj.Numerator = "INFOper";
			obj.Denominator = "OperCount";
			
			var option1 = {
				title : {
					text: '手术切口感染统计',
					x:'left'
				},
				tooltip: {
					trigger: 'axis',
				},
				toolbox: {
					"show": true
				},
				legend: {
					data:['感染例数','感染率','手术例数'],
					selected: {
						'手术例数': false
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
						name: '感染例数',
						splitLine: {
							show: false
						},
						axisLabel: {
							formatter: '{value} '
						}
					},{
						type: 'value',
						name: '感染率(‰)',
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
						name:'感染例数',
						type:'bar',
						data:[],
						label: {
							show:true,
							formatter:"{c}"
						}
					},{
						name:'感染率',
						type:'line',
						yAxisIndex: 1,
						data:[],
						label: {
							show:true,
							formatter:"{c}%"
						}
					},{
						name:'手术例数',
						type:'bar',
						data:[],
						label: {
							show:true,
							formatter:"{c}"
						}
					}
				   
				]
			};
			// 使用刚指定的配置项和数据显示图表。
			myChart.setOption(option1,true);
		} else if(obj.QryOpption=="label02") {
			obj.QueryName = "QryECResultByTime";
			obj.Numerator = "INFOper1";
			obj.Denominator = "Oper1Count";
			
			var option1 = {
				title : {
					text: '手术切口感染统计',
					x:'left'
				},
				tooltip: {
					trigger: 'axis',
				},
				toolbox: {
					"show": true
				},
				legend: {
					data:['感染例数','感染率','I类切口例数'],
					selected: {
						'I类切口例数': false
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
						name: '感染例数',
						splitLine: {
							show: false
						},
						axisLabel: {
							formatter: '{value} '
						}
					},{
						type: 'value',
						name: '感染率(‰)',
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
						name:'感染例数',
						type:'bar',
						data:[],
						barMaxWidth:50,
						label: {
							show:true,
							formatter:"{c}"
						}
					},{
						name:'感染率',
						type:'line',
						yAxisIndex: 1,						
						data:[],
						label: {
							show:true,
							formatter:"{c}%"
						}
					},{
						name:'I类切口例数',
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
			// 使用刚指定的配置项和数据显示图表。
			myChart.setOption(option1,true);
		} else if(obj.QryOpption=="label03") {
			obj.QueryName = "QryECResultForPie";
			obj.ItemStr = "INFSuperInc^INFDeepInc^INFOrganInc";
			var option2 = {
				title : {
					text: '感染诊断统计图',
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
						name: '感染诊断',
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
    //查询按钮
    $("#btnQuery").on('click', function(){
		var LocID=$.form.GetValue("cboInfLocation")
		var MonthFrom=$.form.GetValue("DateFrom")
		var MonthTo=$.form.GetValue("DateTo")
		//当月科室感染率图表
		var dataInput = "ClassName=" + 'DHCHAI.STAS.ChartsSrv' + "&QueryName=" + obj.QueryName + "&Arg1=" + LocID + "&Arg2=" + MonthFrom + "&Arg3=" + MonthTo+ "&Arg4=" + obj.Numerator + "&Arg5=" + obj.Denominator + "&ArgCnt=" + 5;
		if(obj.QryOpption=="label03") dataInput = "ClassName=" + 'DHCHAI.STAS.ChartsSrv' + "&QueryName=" + obj.QueryName + "&Arg1=" + LocID + "&Arg2=" + MonthFrom + "&Arg3=" + MonthTo+ "&Arg4=" + obj.ItemStr + "&ArgCnt=" + 4;
		if ((MonthFrom!="")||(MonthTo!=""))
		{ 
			var ErrorStr = "";
			if (MonthFrom=="") {
				ErrorStr += '请选择开始日期!<br/>';
			}
			if (MonthTo == "") {
				ErrorStr += '请选择结束日期!<br/>';
			}
			if (MonthFrom > MonthTo) {
				ErrorStr += '开始日期不能大于结束日期!<br/>';
			}
			if (ErrorStr != '') {
					layer.msg(ErrorStr,{icon: 0});
					return;
			}
		}else{
		$.ajax({
			url: "./dhchai.query.csp",
			type: "post",
			timeout: 30000, //30秒超时
			async: true,   //异步
			beforeSend: function() {
				myChart.showLoading();
			},
			data: dataInput,
			success: function(data, textStatus){
				myChart.hideLoading();    //隐藏加载动画
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
				alert("执行错误,Status:" + textStatus + ",Error:" + errorThrown);
				myChart.hideLoading();    //隐藏加载动画
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
		$("#btnQuery").click(); //默认查询
	});
	//默认打开第一个页签
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
		myChart.setOption({        //加载数据图表
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
			var ItemDesc=rd["ItemDesc"].replace(/感染例数/,"")
			arrItemDesc.push(ItemDesc);
			arrValue.push({"value":rd["Value"],"name":ItemDesc});
		}
		myChart.setOption({        //加载数据图表
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
						timeout: 30000, //30秒超时
						async: true,   //异步
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
								fixed: false, //不固定
								content: $('#tableInfList'),
								success: function(layero, index){
								
								},
							});
						},
						error: function(XMLHttpRequest, textStatus, errorThrown){
							alert("执行错误,Status:" + textStatus + ",Error:" + errorThrown);
						}
					});
				}
			}
		}
	}); 
   
}

