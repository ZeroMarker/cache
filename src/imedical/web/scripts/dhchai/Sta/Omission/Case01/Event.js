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
	//给select2赋值change事件
	$("#cboHospital").on("select2:select", function (e) { 
		//获得选中的医院
		var data= e.params.data;
		var id = data.id;
		var text =data.text;
		$("#cboInfLocation").data("param",id+"^^I^E^1");
		$.form.SelectRender("cboInfLocation");  //渲染下拉框	
	});	
	
	$("#cboInfLocation").data("param",$.form.GetValue("cboHospital")+"^^I^E^1");
	$.form.SelectRender("cboInfLocation");
	
	var myChart = echarts.init(document.getElementById('Case01'), 'theme');
	var option1 = {
		title : {
			text: '感染漏报相关统计'
		},
		tooltip: {
			trigger: 'axis',
		},
		toolbox: {
			"show": true
		},
		legend: {
			data:['漏报例数','应报例数','漏报率']
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
				name: '漏报/应报例数',
				splitLine: {
					show: false
				},
				axisLabel: {
					formatter: '{value} '
				}
			},
			{
				type: 'value',
				name: '漏报率(%)',
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
				name:'漏报例数',
				type:'bar',
				data:[],
				label: {
					show:true,
					formatter:"{c}"
				}
			},
			{
				name:'应报例数',
				type:'bar',
				data:[],
				label: {
					show:true,
					formatter:"{c}"
				}
			},
			{
				name:'漏报率',
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
	// 使用刚指定的配置项和数据显示图表。
	myChart.setOption(option1);
	
    //查询按钮
    $("#btnQuery").on('click', function(){
		var HospID=$.form.GetValue("cboHospital");
		var LocID=$.form.GetValue("cboInfLocation");
		var MonthFrom=$.form.GetValue("DateFrom");
		var MonthTo=$.form.GetValue("DateTo");
		
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
		
		var dataInput = "ClassName=" + 'DHCHAI.IRS.InfOmissionSrv' + "&QueryName=" + 'QryOmissionEcharts' + "&Arg1=" + HospID + "&Arg2=" + LocID + "&Arg3=" + MonthFrom+ "&Arg4=" + MonthTo + "&ArgCnt=" + 4;
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
				obj.echartRatio(retval);
			},
			error: function(XMLHttpRequest, textStatus, errorThrown){
				alert("类" + tkclass + ":" + tkQuery + "执行错误,Status:" + textStatus + ",Error:" + errorThrown);
				myChart.hideLoading();    //隐藏加载动画
			}
		});
	});
	
	
	
	obj.echartRatio = function(runQuery){
		if (!runQuery) {
			layer.alert("查询失败！请检查查询条件！",{icon: 2});
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
		myChart.setOption({        //加载数据图表
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

