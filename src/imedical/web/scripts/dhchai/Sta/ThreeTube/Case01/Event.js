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
		$("#cboInfLocation").data("param",id+"^^I|E^E^1");
		$.form.SelectRender("cboInfLocation");  //渲染下拉框	
	});
		
	$("#cboInfLocation").data("param",$.form.GetValue("cboHospital")+"^^I|E^W^1");
	$.form.SelectRender("cboInfLocation");
	$.form.SelectRender("cboRepType");
	var myChart = echarts.init(document.getElementById('Case01'),'theme');
	var option1 = {
		title : {
			text: '器械相关感染统计',
			x:'left'
		},
		tooltip: {
			trigger: 'axis',
		},
		toolbox: {
			"show": true
		},
		legend: {
			data:['使用日数','感染率','感染人数'],
			selected: {
				'感染人数': false
			}
		},
		xAxis: [
			{
				type: 'category',
				data: [],
				axisLabel: {
							margin:12,
							rotate:45,
							interval:0,
							// 使用函数模板，函数参数分别为刻度数值（类目），刻度的索引
							formatter: function (value, index) {
								//处理标签，过长折行和省略
								if(value.length>7){
									return value.substr(0,8)+'\n'+value.substr(8,15);
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
				name: '使用日数',
				splitLine: {
					show: false
				},
				axisLabel: {
					formatter: '{value} '
				}
			},
			{
				type: 'value',
				name: '感染率(‰)',
				splitLine: {
					show: false
				},
				axisLabel: {
					formatter: '{value} ‰'
				}
			}
		],
		series: [
			 {
				name:'使用日数',
				type:'bar',
				data:[],
				barMaxWidth:50,
				label: {
					show:true,
					formatter:"{c}"
				}
			},
			{
				name:'感染率',
				type:'line',
				yAxisIndex: 1,
				data:[],
				label: {
					show:true,
					formatter:"{c}‰"
				}
			},
			{
				name:'感染人数',
				type:'bar',
				yAxisIndex: 1,
				data:[],
				label: {
					show:true,
					formatter:"{c}"
				}
			}
		   
		]
	};
	// 使用刚指定的配置项和数据显示图表。
	myChart.setOption(option1);
	
	obj.level="level-M";
	obj.season="";
	obj.year=$.form.GetValue("DateFrom").substr(0,4)
	$("#year").text($.form.GetValue("DateFrom").substr(0,4)+"年")
	$(".sta-level .btn").on('click', function(){
		$(".sta-level .btn").css('background-color','#DEDEDE');
		$(".sta-level .btn").css('color','#000000');
		$("#"+this.id).css("background-color","#40A2DE");
		$("#"+this.id).css("color","#FFFFFF");
		$(".sta-year .btn").css("background-color","#DEDEDE");
		$(".sta-year .btn").css("color","#000000");
		$(".sta-season .btn").css('background-color','#DEDEDE');
		$(".sta-season .btn").css('color','#000000');
		if(this.id=="level-Y"){
			$(".sta-year .btn").css("background-color","#40A2DE");
			$(".sta-year .btn").css("color","#FFFFFF");
		}
		obj.level=this.id;
	});
	$(".sta-season .btn").on('click', function(){
		$(".sta-year .btn").css("background-color","#DEDEDE");
		$(".sta-year .btn").css("color","#000000");
		$(".sta-level .btn").css('background-color','#DEDEDE');
		$(".sta-level .btn").css('color','#000000');
		$("#level-S").css("background-color","#40A2DE");
		$("#level-S").css("color","#FFFFFF");
		$(".sta-season .btn").css('background-color','#DEDEDE');
		$(".sta-season .btn").css('color','#000000');
		$("#"+this.id).css("background-color","#40A2DE");
		$("#"+this.id).css("color","#FFFFFF");
		obj.season=this.id;
		obj.level="level-S";
	});
	$(".sta-year li").on('click', function(){
		var year=$("#"+this.id+" a").text();
		$("#year").text(year+"年");
		obj.year=year;
	});
	/****************/
    //查询按钮
    $("#btnQuery").on('click', function(){
		var LocID=$.form.GetValue("cboInfLocation")
		var MonthFrom=$.form.GetValue("DateFrom")
		var MonthTo=$.form.GetValue("DateTo")
		var RepType=$.form.GetValue("cboRepType")
		var HAICase=""
		var TubeCount=""
		
		switch(RepType)
		{
			case "1":
				HAICase="INFUC";
				TubeCount="CountUC";
				break;
			case "2":
				HAICase="INFVAP";
				TubeCount="CountVAP";
				break;
			case "3":
				HAICase="INFPICC";
				TubeCount="CountPICC";
				break;
		}
		
		var dataInput = "";
		if(obj.level=="level-M"){
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
			dataInput = "ClassName=" + 'DHCHAI.STAS.ChartsSrv' + "&QueryName=" + 'QryECResultByTime' + "&Arg1=" + LocID + "&Arg2=" + MonthFrom + "&Arg3=" + MonthTo+ "&Arg4=" + HAICase + "&Arg5=" + TubeCount + "&ArgCnt=" + 5;
		}else if(obj.level=="level-S"){
			switch(obj.season)
			{
				case "season-1":
					MonthFrom=obj.year+"-01";
					MonthTo=obj.year+"-03";
					break;
				case "season-2":
					MonthFrom=obj.year+"-04";
					MonthTo=obj.year+"-06";
					break;
				case "season-3":
					MonthFrom=obj.year+"-07";
					MonthTo=obj.year+"-09";
					break;
				case "season-4":
					MonthFrom=obj.year+"-10";
					MonthTo=obj.year+"-12";
					break;
				default:
					layer.msg('请选择季度!',{icon: 2});
			}
			dataInput = "ClassName=" + 'DHCHAI.STAS.ChartsSrv' + "&QueryName=" + 'QryECResultByLoc' + "&Arg1=" + LocID + "&Arg2=" + MonthFrom + "&Arg3=" + MonthTo+ "&Arg4=" + HAICase + "&Arg5=" + TubeCount + "&ArgCnt=" + 5;
		}else if(obj.level=="level-Y"){
			MonthFrom=obj.year+"-01";
			MonthTo=obj.year+"-12";
			dataInput = "ClassName=" + 'DHCHAI.STAS.ChartsSrv' + "&QueryName=" + 'QryECResultByLoc' + "&Arg1=" + LocID + "&Arg2=" + MonthFrom + "&Arg3=" + MonthTo+ "&Arg4=" + HAICase + "&Arg5=" + TubeCount + "&ArgCnt=" + 5;
		}
		
		var LocDesc=$.form.GetText("cboInfLocation")
		if(LocID=="") LocDesc="所有科室"
		var textCon=LocDesc+"，"+MonthFrom+"至"+MonthTo
		$("#condition").text(textCon);
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
	
	obj.arrTimeG=""
	obj.echartLocInfRatio = function(runQuery){
		if (!runQuery) {
			layer.alert("查询失败！请检查查询条件！",{icon: 2});
			return  false;
		}
		var arrTime = new Array();
		var arrInfRatio = new Array();
		var arrInfCount = new Array();
		var arrDateCount = new Array();
		obj.arrTimeG=arrTime
		var arrRecord = runQuery.record;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			arrTime.push(rd["ECTime"]);
			arrInfCount.push(rd["Value1"]);
			arrDateCount.push(rd["Value2"]);
			arrInfRatio.push(parseFloat(rd["Ratio"]*10).toFixed(2));
		}
		myChart.setOption({        //加载数据图表
			xAxis: {
				data: arrTime
			},
			series: [{
				data:arrDateCount
			},{
				data:arrInfRatio
			},{
				data:arrInfCount
			}]
		});
		
   }
   
	myChart.on('click', function (params) {
		if (params.value>0){
			if (params.seriesType=="line"){
				if (params.seriesIndex==1){
					var LocID=$.form.GetValue("cboInfLocation");
					var Month=obj.arrTimeG[params.dataIndex];
					var RepType=$.form.GetValue("cboRepType");
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

