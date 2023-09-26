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
	$.form.SelectRender("cboRepType");	
	
	//渲染图表
	var myChart = echarts.init(document.getElementById('Case01'),'theme');
	var option1 = {
		title : {
			text: '感染例次（率）统计图',
			x:'left'
		},
		tooltip: {
			trigger: 'axis'
		},
		toolbox: {
			"show": true
		},
		legend: {
			data:['感染例次','感染率','住院人数'],
			selected: {
				'住院人数': false
			}
		},
		xAxis: [
			{
				type: 'category',
				data: [],
				axisLabel: {
					margin:8,
					rotate:45,
					interval:0
				}
			}
		],
		yAxis: [
			{
				type: 'value',
				name: '感染例次',
				axisLabel: {
					formatter: '{value} '
				}
			},{
				type: 'value',
				name: '感染率(%)',
				axisLabel: {
					formatter: '{value} %'
				}
			},{
				show: false,
				type: 'value',
				name: '住院人数',
				axisLabel: {
					formatter: '{value} '
				}
			}
		],
		series: [
			{
				name:'感染例次',
				type:'bar',
				barMaxWidth:50,
				data:[]
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
				name:'住院人数',
				type:'bar',
				barMaxWidth:50,
				data:[]
			}
		   
		]
	};
	myChart.setOption(option1);
	
	/****************/
    //查询按钮
    $("#btnQuery").on('click', function(){
	    var HospID=$.form.GetValue("cboHospital");
		var LocID=$.form.GetValue("cboInfLocation")
		var RepType=$.form.GetValue("cboRepType")
		var MonthFrom=$.form.GetValue("DateFrom")
		var MonthTo=$.form.GetValue("DateTo")
		
		if (RepType=="1") {
			var Numerator="HAICase"; //分子
			var Denominator="InHospCount"; //分母
		} else {
			var Numerator="BabyHAICase"; //分子
			var Denominator="BabyInHosp"; //分母
		}
		
		//当月科室感染率图表
		var dataInput = "ClassName=" + 'DHCHAI.STAS.ChartsSrv' + "&QueryName=" + 'QryECResultByTime' + "&Arg1=" + LocID + "&Arg2=" + MonthFrom + "&Arg3=" + MonthTo+ "&Arg4=" + Numerator + "&Arg5=" + Denominator + "&Arg6=" + HospID + "&ArgCnt=" + 6;
		
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
				obj.echartLocInfRatio(retval);
			},
			error: function(XMLHttpRequest, textStatus, errorThrown){
				alert("类" + tkclass + ":" + tkQuery + "执行错误,Status:" + textStatus + ",Error:" + errorThrown);
				myChart.hideLoading();    //隐藏加载动画
			}
		});
	});
   
   
   obj.echartLocInfRatio = function(runQuery){
		if (!runQuery) {
			layer.alert("查询失败！请检查查询条件！",{icon: 2});
			return  false;
		}
		var arrTime = new Array();
		var arrInfRatio = new Array();
		var arrInfCount = new Array();
		var arrInHospCount = new Array();
		var arrRecord = runQuery.record;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			arrTime.push(rd["ECTime"]);
			arrInfCount.push(rd["Value1"]);
			arrInHospCount.push(rd["Value2"]);
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
				data:arrInHospCount
			}]
		});
	}
	
}

