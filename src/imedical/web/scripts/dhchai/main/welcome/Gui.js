//页面Gui
function InitWelcomePage(){
	var obj = new Object();
	
	//新报告审核记录
	var dataInput = "ClassName=" + 'DHCHAI.STAS.WelcomeSrv' + "&QueryName=" + 'QrySpanInfRepCnt' + "&Arg1=" + $.LOGON.LOCID + "&ArgCnt=" + 1;
	$.ajax({
		url: "./dhchai.query.csp",
		type: "post",
		timeout: 30000, //30秒超时
		async: true,   //异步
		data: dataInput,
		success: function(data, textStatus){
			var retval = (new Function("return " + data))();
			var arrRecord = retval.record;
			if (arrRecord.length>0){
				var cnt = arrRecord[0]["Count"];
				$("#cntInfRep").html(cnt);
			}
		},
		error: function(XMLHttpRequest, textStatus, errorThrown) {
			var tkclass = "DHCHAI.STAS.WelcomeSrv";
			var tkQuery = "QrySpanInfRepCnt";
			alert("类" + tkclass + ":" + tkQuery + "执行错误,Status:" + textStatus + ",Error:" + errorThrown);
		}
	});
	
	//疑似待处理记录（疑似未处理-持续关注）
	var dataInput = "ClassName=" + 'DHCHAI.STAS.WelcomeSrv' + "&QueryName=" + 'QrySpanInfScreenCnt' + "&Arg1=" + $.LOGON.LOCID + "&ArgCnt=" + 1;
	$.ajax({
		url: "./dhchai.query.csp",
		type: "post",
		timeout: 30000, //30秒超时
		async: true,   //异步
		data: dataInput,
		success: function(data, textStatus){
			var retval = (new Function("return " + data))();
			var arrRecord = retval.record;
			if (arrRecord.length>0){
				var cnt = arrRecord[0]["Count"];
				$("#cntInfScreen").html(cnt);
			}
		},
		error: function(XMLHttpRequest, textStatus, errorThrown) {
			var tkclass = "DHCHAI.STAS.WelcomeSrv";
			var tkQuery = "QrySpanInfScreenCnt";
			alert("类" + tkclass + ":" + tkQuery + "执行错误,Status:" + textStatus + ",Error:" + errorThrown);
		}
	});
	
	//确诊未上报记录
	var dataInput = "ClassName=" + 'DHCHAI.STAS.WelcomeSrv' + "&QueryName=" + 'QrySpanInfNoRepCnt' + "&Arg1=" + $.LOGON.LOCID + "&ArgCnt=" + 1;
	$.ajax({
		url: "./dhchai.query.csp",
		type: "post",
		timeout: 30000, //30秒超时
		async: true,   //异步
		data: dataInput,
		success: function(data, textStatus){
			var retval = (new Function("return " + data))();
			var arrRecord = retval.record;
			if (arrRecord.length>0){
				var cnt = arrRecord[0]["Count"];
				$("#cntInfNoRep").html(cnt);
			}
		},
		error: function(XMLHttpRequest, textStatus, errorThrown) {
			var tkclass = "DHCHAI.STAS.WelcomeSrv";
			var tkQuery = "QrySpanInfNoRepCnt";
			alert("类" + tkclass + ":" + tkQuery + "执行错误,Status:" + textStatus + ",Error:" + errorThrown);
		}
	});
	
	//多重耐药菌  近三天检出多重耐药菌数 按照报告日期查询
	var dataInput = "ClassName=" + 'DHCHAI.STAS.WelcomeSrv' + "&QueryName=" + 'QryMRBResult' + "&Arg1=" + $.LOGON.HOSPID +"&Arg2=2&Arg3=&Arg4=&Arg5=&Arg6=&Arg7=&Arg8=" + "&ArgCnt=" + 8;
	$.ajax({
		url: "./dhchai.query.csp",
		type: "post",
		timeout: 30000, //30秒超时
		async: true,   //异步
		data: dataInput,
		success: function(data, textStatus){
			var retval = (new Function("return " + data))();
			var arrRecord = retval.record;
			if (arrRecord.length>0){
				$("#cntInfMrb").html(arrRecord.length);
			}
		},
		error: function(XMLHttpRequest, textStatus, errorThrown) {
			var tkclass = "DHCHAI.STAS.WelcomeSrv";
			var tkQuery = "QryMRBResult";
			alert("类" + tkclass + ":" + tkQuery + "执行错误,Status:" + textStatus + ",Error:" + errorThrown);
		}
	});
	
	//职业暴露报告待审核记录
	var dataInput = "ClassName=" + 'DHCHAI.IRS.OccExpRegSrv' + "&QueryName=" + 'QryExpCheckCnt' + "&Arg1=" + $.LOGON.LOCID + "&ArgCnt=" + 1;
	$.ajax({
		url: "./dhchai.query.csp",
		type: "post",
		timeout: 30000, //30秒超时
		async: true,   //异步
		data: dataInput,
		success: function(data, textStatus){
			var retval = (new Function("return " + data))();
			var arrRecord = retval.record;
			if (arrRecord.length>0){
				var cnt = arrRecord[0]["Count"];
				$("#cntCheck").html(cnt);
			}
		},
		error: function(XMLHttpRequest, textStatus, errorThrown) {
			var tkclass = "DHCHAI.IRS.OccExpRegSrv";
			var tkQuery = "QryExpCheckCnt";
			alert("类" + tkclass + ":" + tkQuery + "执行错误,Status:" + textStatus + ",Error:" + errorThrown);
		}
	});
	
	//暴露报告检验提醒记录
	var dataInput = "ClassName=" + 'DHCHAI.IRS.OccExpRegSrv' + "&QueryName=" + 'QryRemindCnt' + "&Arg1=" + $.LOGON.LOCID + "&ArgCnt=" + 1;
	$.ajax({
		url: "./dhchai.query.csp",
		type: "post",
		timeout: 30000, //30秒超时
		async: true,   //异步
		data: dataInput,
		success: function(data, textStatus){
			var retval = (new Function("return " + data))();
			var arrRecord = retval.record;
			if (arrRecord.length>0){
				var cnt = arrRecord[0]["Count"];
				$("#cntRemind").html(cnt);
			}
		},
		error: function(XMLHttpRequest, textStatus, errorThrown) {
			var tkclass = "DHCHAI.IRS.OccExpRegSrv";
			var tkQuery = "QryRemindCnt";
			alert("类" + tkclass + ":" + tkQuery + "执行错误,Status:" + textStatus + ",Error:" + errorThrown);
		}
	});
		//环境卫生学7天不合格报告提醒
	var dataInput = "ClassName=" + 'DHCHAI.IRS.EnviHyReportSrv' + "&QueryName=" + 'QryRemindEnvRt' + "&Arg1=" + $.LOGON.LOCID + "&ArgCnt=" + 1;
	$.ajax({
		url: "./dhchai.query.csp",
		type: "post",
		timeout: 30000, //30秒超时
		async: true,   //异步
		data: dataInput,
		success: function(data, textStatus){
			var retval = (new Function("return " + data))();
			var arrRecord = retval.record;
			if (arrRecord.length>0){
				var cnt = arrRecord[0]["Count"];
				$("#entRemind").html(cnt);
			}
		},
		error: function(XMLHttpRequest, textStatus, errorThrown) { 
			var tkclass = "DHCHAI.IRS.EnviHyReportSrv";
			var tkQuery = "QryRemindEnvRt";
			alert("类" + tkclass + ":" + tkQuery + "执行错误,Status:" + textStatus + ",Error:" + errorThrown);
		}
	});
	//当月科室感染率图表
	var dataInput = "ClassName=" + 'DHCHAI.STAS.WelcomeSrv' + "&QueryName=" + 'QryLocInfRatio' + "&Arg1=" + $.LOGON.LOCID + "&ArgCnt=" + 1;
	$.ajax({
		url: "./dhchai.query.csp",
		type: "post",
		timeout: 30000, //30秒超时
		async: true,   //异步
		data: dataInput,
		success: function(data, textStatus){
			var retval = (new Function("return " + data))();
			obj.echartLocInfRatio(retval);
		},
		error: function(XMLHttpRequest, textStatus, errorThrown) {
			var tkclass = "DHCHAI.STAS.WelcomeSrv";
			var tkQuery = "QryLocInfRatio";
			alert("类" + tkclass + ":" + tkQuery + "执行错误,Status:" + textStatus + ",Error:" + errorThrown);
		}
	});
	obj.echartLocInfRatio = function(runQuery){
		if (!runQuery) return;
		var arrViewLoc = new Array();
		var arrInfRatio = new Array();
		var arrRecord = runQuery.record;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			arrViewLoc.push(rd["LocDesc"]);
			arrInfRatio.push(parseFloat(rd["InfRatio"]).toFixed(2));
		}
		var myChart = echarts.init(document.getElementById('divLocInfRatio'));
		var option = {
			tooltip : {
				trigger: 'axis'
			},
			grid:{
				x:52,
				y:30,
				x2:30,
				y2:60
			},
			xAxis : [
				{
					type : 'category',
					splitLine:{
						show:false
					},
					data : arrViewLoc,
					axisLabel: {
						margin:8,
						rotate:45,
						interval:0,
						// 使用函数模板，函数参数分别为刻度数值（类目），刻度的索引
						formatter: function (value, index) {
							//处理标签，过长折行和省略
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
			yAxis : [
				{
					type : 'value',
					splitLine:{
						show:true,
						lineStyle:{
							color:'#cccccc'
						}
					}
				}
			],
			series : [
				{
					name:'感染率',
					type:'bar',
					itemStyle : {
						normal:{
							color : '#3398db'
						}
					},
					data:arrInfRatio,
					barWidth: 30
				}
			]
		};
		myChart.setOption(option);
	}
	
	//科室发热人数图表(科室)
	var dataInput = "ClassName=" + 'DHCHAI.STAS.WelcomeSrv' + "&QueryName=" + 'QryLocFeverNumber' + "&Arg1=" + $.LOGON.LOCID + "&ArgCnt=" + 1;
	$.ajax({
		url: "./dhchai.query.csp",
		type: "post",
		timeout: 30000, //30秒超时
		async: true,   //异步
		data: dataInput,
		success: function(data, textStatus){
			var retval = (new Function("return " + data))();
			obj.echartLocFeverNumber(retval);
		},
		error: function(XMLHttpRequest, textStatus, errorThrown) {
			var tkclass = "DHCHAI.STAS.WelcomeSrv";
			var tkQuery = "QryLocFeverNumber";
			alert("类" + tkclass + ":" + tkQuery + "执行错误,Status:" + textStatus + ",Error:" + errorThrown);
		}
	});
	obj.echartLocFeverNumber = function(runQuery){
		if (!runQuery) return;
		var arrViewLoc = new Array();
		var arrFeverNumber = new Array();
		var arrRecord = runQuery.record;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			arrViewLoc.push(rd["LocDesc"]);
			arrFeverNumber.push(parseFloat(rd["FeverNumber"]));
		}
		var myChart = echarts.init(document.getElementById('fever3'));
		var option = {
			tooltip : {
				trigger: 'axis'
			},
			grid:{
				x:52,
				y:30,
				x2:30,
				y2:60
			},
			xAxis : [
				{
					type : 'category',
					splitLine:{
						show:false
					},
					data : arrViewLoc,
					axisLabel: {
						margin:8,
						rotate:45,
						interval:0,
						// 使用函数模板，函数参数分别为刻度数值（类目），刻度的索引
						formatter: function (value, index) {
							//处理标签，过长折行和省略
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
			yAxis : [
				{
					type : 'value',
					splitLine:{
						show:true,
						lineStyle:{
							color:'#cccccc'
						}
					}
				}
			],
			series : [
				{
					name:'发热人数',
					type:'bar',
					itemStyle : {
						normal:{
							color : '#3398db'
						}
					},
					data:arrFeverNumber,
					barWidth: 30
				}
			]
		};
		myChart.setOption(option);
	}
	
	//科室发热人数图表(人数变化)
	var dataInput = "ClassName=" + 'DHCHAI.STAS.WelcomeSrv' + "&QueryName=" + 'QryLocFeverChange' + "&Arg1=" + $.LOGON.LOCID + "&ArgCnt=" + 1;
	$.ajax({
		url: "./dhchai.query.csp",
		type: "post",
		timeout: 30000, //30秒超时
		async: true,   //异步
		data: dataInput,
		success: function(data, textStatus){
			var retval = (new Function("return " + data))();
			obj.echartLocFeverChange(retval);
		},
		error: function(XMLHttpRequest, textStatus, errorThrown) {
			var tkclass = "DHCHAI.STAS.WelcomeSrv";
			var tkQuery = "QryLocFeverChange";
			alert("类" + tkclass + ":" + tkQuery + "执行错误,Status:" + textStatus + ",Error:" + errorThrown);
		}
	});
	obj.echartLocFeverChange = function(runQuery){
		if (!runQuery) return;
		var arrViewLoc2 = new Array();
		var arrFeverNumber2 = new Array();
		var arrFeverNumber3 = new Array();
		var arrRecord = runQuery.record;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			arrViewLoc2.push(rd["LocDesc"]);
			arrFeverNumber2.push(parseFloat(rd["ChainFeverNumber"]));
			arrFeverNumber3.push(parseFloat(rd["FeverNumber"]));
		}
		var colors = ['#5793f3', '#d14a61'];
		var myChart = echarts.init(document.getElementById('fever2'));
		var option = {
			color: colors,
			tooltip : {
				trigger: 'axis'
			},
			grid:{
				x:52,
				y:30,
				x2:30,
				y2:60
			},
			xAxis : [
				{
					type : 'category',
					splitLine:{
						show:false
					},
					data : arrViewLoc2,
					axisLabel: {
						margin:8,
						rotate:45,
						interval:0,
						// 使用函数模板，函数参数分别为刻度数值（类目），刻度的索引
						formatter: function (value, index) {
							//处理标签，过长折行和省略
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
			yAxis : [
				{
					type : 'value',
					splitLine:{
						show:true,
						lineStyle:{
							color:'#cccccc'
						}
					}
				},
				{
					type: 'value'
				}
			],
			series : [
				{
					name:'环比人数',
					type:'bar',
					itemStyle : {
						normal:{
							color :  colors[0]
						}
					},
					data:arrFeverNumber2,
					barWidth: 20
				},
				{
					name:'发热人数',
					type:'bar',
					itemStyle : {
						normal:{
							color :  colors[1]
						}
					},
					data:arrFeverNumber3,
					barWidth: 20
				}
			]
		};
		myChart.setOption(option);
	}
	
	//全院现患率模块
	var dataInput = "ClassName=" + 'DHCHAI.STAS.WelcomeSrv' + "&QueryName=" + 'QryHospPrevRatio' + "&Arg1=" + $.LOGON.LOCID + "&ArgCnt=" + 1;
	$.ajax({
		url: "./dhchai.query.csp",
		type: "post",
		timeout: 30000, //30秒超时
		async: true,   //异步
		data: dataInput,
		success: function(data, textStatus){
			var retval = (new Function("return " + data))();
			obj.echartHospPrevRatio(retval);
		},
		error: function(XMLHttpRequest, textStatus, errorThrown){
			alert("类" + tkclass + ":" + tkQuery + "执行错误,Status:" + textStatus + ",Error:" + errorThrown);
		}
	});
	obj.echartHospPrevRatio = function(runQuery){
		if (!runQuery) return;
		var arrViewTitle = new Array();
		var arrInfPatCnt = new Array();
		var arrRecord = runQuery.record;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			arrViewTitle.push(rd["PrevDate"]);
			arrInfPatCnt.push(parseFloat(rd["PrevRatio"]).toFixed(2));
		}
		var myChart = echarts.init(document.getElementById('divHospPrevRatio'));
		var option = {
			grid:{
				x:52,
				y:25,
				x2:30,
				y2:34
			},
			tooltip : {
				trigger: 'axis'
				},
			calculable : true,
			xAxis : [
				{
					type : 'category',
					boundaryGap : false,
					data : arrViewTitle,
					axisLabel: {
						margin:4
						},	  
					splitLine:{
								show:false
							}
				}
			],
			yAxis : [
				{
					type : 'value',
					axisLabel : {
						formatter: '{value}'
					}
				}
			],
			series : [
				{
					name:'现患率',
					type:'line',
					data:arrInfPatCnt
				}
			]
		};
		myChart.setOption(option);
	}
	
	//当月多重耐药菌分布（科室）
	var dataInput = "ClassName=" + 'DHCHAI.STAS.WelcomeSrv' + "&QueryName=" + 'QryLocMBRRatio' + "&Arg1=" + $.LOGON.LOCID + "&ArgCnt=" + 1;
	$.ajax({
		url: "./dhchai.query.csp",
		type: "post",
		timeout: 30000, //30秒超时
		async: true,   //异步
		data: dataInput,
		success: function(data, textStatus){
			var retval = (new Function("return " + data))();
			obj.echartLocMBRRatio(retval);
		},
		error: function(XMLHttpRequest, textStatus, errorThrown){
			alert("类" + tkclass + ":" + tkQuery + "执行错误,Status:" + textStatus + ",Error:" + errorThrown);
		}
	});
	obj.echartLocMBRRatio = function(runQuery){
		if (!runQuery) return;
		var arrLocDesc = new Array();
		var arrMBRRatio = new Array();
		var arrRecord = runQuery.record;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			arrLocDesc.push(rd["LocDesc"]);
			arrMBRRatio.push(parseFloat(rd["MBRRatio"]).toFixed(2));
		}
		var myChart = echarts.init(document.getElementById('main2'));
		var option = {
			grid:{
				x:52,
				y:40,
				x2:30,
				y2:60
			},
			tooltip : {
				trigger: 'axis'
			},
			calculable : true,
			xAxis : [
				{
					type : 'category',
					data : arrLocDesc,
					axisLabel: {
						margin:8,
						rotate:45,
						interval:0,
						// 使用函数模板，函数参数分别为刻度数值（类目），刻度的索引
						formatter: function (value, index) {
							//处理标签，过长折行和省略
							if(value.length>6 && value.length<11){
								return value.substr(0,5)+'\n'+value.substr(5,5);
							}else if(value.length>10){
								return value.substr(0,6)+'\n'+value.substr(6,4)+"...";
							}else{
								return value;
							}
						}
					},	           
					splitLine:{
								show:false
							}
				}
			],
			yAxis : [
				{
					type : 'value',
					splitLine:{
								show:true,
								lineStyle:{
									color:'#cccccc'
								}
							}
				}
			],
			series : [
				{
					name:'检出率',
					type:'bar',
					data:arrMBRRatio,
					barWidth: 30,
					markPoint : {
						data : [
							{type : 'max', name: '最大值'},
							{type : 'min', name: '最小值'}
						]
					}
				}
			]
		};
		myChart.setOption(option);
	}
	
	//当月多重耐药菌分布（菌种）
	var dataInput = "ClassName=" + 'DHCHAI.STAS.WelcomeSrv' + "&QueryName=" + 'QryBactMBRRatio' + "&Arg1=" + $.LOGON.LOCID + "&ArgCnt=" + 1;
	$.ajax({
		url: "./dhchai.query.csp",
		type: "post",
		timeout: 60000, //60秒超时
		async: true,   //异步
		data: dataInput,
		success: function(data, textStatus){
			var retval = (new Function("return " + data))();
			obj.echartBactMBRRatio(retval);
		},
		error: function(XMLHttpRequest, textStatus, errorThrown) {
			var tkclass = "DHCHAI.STAS.WelcomeSrv";
			var tkQuery = "QryBactMBRRatio";
			alert("类" + tkclass + ":" + tkQuery + "执行错误,Status:" + textStatus + ",Error:" + errorThrown);
		}
	});
	obj.echartBactMBRRatio = function(runQuery){
		if (!runQuery) return;
		var arrMBRLocDesc2 = new Array();
		var arrMBRRatio2 = new Array();
		var arrRecord = runQuery.record;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			arrMBRLocDesc2.push(rd["BactDesc"]);
			arrMBRRatio2.push(parseFloat(rd["MBRRatio"]).toFixed(2));
		}
		var myChart = echarts.init(document.getElementById('main3'));
		var option = {
			tooltip : {
				trigger: 'axis'
			},
			grid:{
				x:52,
				y:40,
				x2:30,
				y2:60
			},
			calculable : true,
			xAxis : [
				{
					type : 'category',
					data : arrMBRLocDesc2,
					axisLabel: {
						margin:8,
						rotate:45,
						interval:0,
						// 使用函数模板，函数参数分别为刻度数值（类目），刻度的索引
						formatter: function (value, index) {
							//处理标签，过长折行和省略
							if(value.length>6 && value.length<11){
								return value.substr(0,5)+'\n'+value.substr(5,5);
							}else if(value.length>10){
								return value.substr(0,6)+'\n'+value.substr(6,4)+"...";
							}else{
								return value;
							}
						}
					},	           
					splitLine:{
								show:false
							}
				}
			],
			yAxis : [
				{
					type : 'value',
					splitLine:{
								show:true,
								lineStyle:{
									color:'#cccccc'
								}
							}
				}
			],
			series : [
				{
					name:'检出率',
					type:'bar',
					data:arrMBRRatio2,
					barWidth:30,
					markPoint : {
						data : [
							{type : 'max', name: '最大值'},
							{type : 'min', name: '最小值'}
						]

					}
				}
			]
		};
		myChart.setOption(option);
	}
	
	//第六块表格
	$('#tableId_2').DataTable({	    	
		"dom":'rt<"row"<"col-sm-8"pl><"col-sm-4"i>>',
		"select":'single',
		//"dom": '<"top"f >rt<"bottom"ilp><"clear">',//dom定位
		//"dom": 'tiprl',//自定义显示项
		//"dom":'<"domab"f>',
		// "scrollY": "100px",//dt高度
		"lengthMenu": [
			10,25,50,100
		],//每页显示条数设置
		"lengthChange": true,//是否允许用户自定义显示数量
		"bPaginate": true, //翻页功能
		"sPaginationType": "full_numbers",//翻页界面类型
		"bFilter": false, //列筛序功能
		"searching": false,//本地搜索
		"ordering": true, //排序功能
		"Info": false,//页脚信息
		"autoWidth": true,//自动宽度
		"oLanguage": {//国际语言转化
		   "oAria": {
			   "sSortAscending": " - click/return to sort ascending",
			   "sSortDescending": " - click/return to sort descending"
		   },
		   "sLengthMenu": "_MENU_",
		   "sZeroRecords": "对不起，查询不到任何相关数据",
		   "sEmptyTable": "未有相关数据",
		   "sLoadingRecords": "正在加载数据-请等待...",
		   "sInfo": "当前记录_START_--_END_条&emsp;共_TOTAL_条记录",
		   "sInfoEmpty": "当前记录0--0条&emsp;共0条记录",
		   "sInfoFiltered": "（数据库中共为 _MAX_ 条记录）",
		   "sProcessing": "<img src='../resources/user_share/row_details/select2-spinner.gif'/> 正在加载数据...",
		   "sSearch": "模糊查询：",
		   "sUrl": "",
		   //多语言配置文件，可将oLanguage的设置放在一个txt文件中，例：Javascript/datatable/dtCH.txt
		   "oPaginate": {
			   "sFirst": "首页",
			   "sPrevious": " 上一页 ",
			   "sNext": " 下一页 ",
			   "sLast": " 末页 "
		   }
		}
	});
	$("body").mCustomScrollbar({
		theme: "dark-thick",
		axis: "y",
		scrollInertia: 100
	});

	InitWelcomePageEvent(obj);
	return obj;
}