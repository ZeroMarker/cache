$(function () {
	InitWelcomePage();
});


function InitWelcomePage(){
	var obj = new Object();
    
	$("#Fever li").click(function(){
		var index=$("#Fever li").index(this);
		$(this).removeClass().addClass("active").siblings().removeClass();
	
		var chosenId='#divFeverNum'+index;
		$(chosenId).css("display","block");
		$(chosenId).siblings().css("display","none");
		if (index==0) {
			LoadFeverFever();
		}
	});
	
	$("#Bacteria li").click(function(){
		var index=$("#Bacteria li").index(this);
		$(this).removeClass().addClass("active").siblings().removeClass();

		var chosenId='#divBacteria'+index;
		$(chosenId).css("display","block");
		$(chosenId).siblings().css("display","none");
		if (index==1) {
			LoadBactMBRRatio();
		}
	});
	$("#InfRep").popover({trigger:'hover',placement:'bottom',content:'当前'+InfRepDay+'日内感染报告待审核例数'});
	$("#InfScreen").popover({trigger:'hover',placement:'bottom',content:'当前在院疑似待处理病例数'});
	$("#InfNoRep").popover({trigger:'hover',placement:'bottom',content:'当前在院及出院'+InfNoRepDay+'日内疑似已确诊未报告感染报告病例数'});
	$("#InfMrb").popover({trigger:'hover',placement:'bottom',content:'当前'+InfMrbDay+'日内报告多重耐药菌例数'});
	$("#RegCheck").popover({trigger:'hover',placement:'bottom',content:'当前职业暴露报告待审核例数'});
	$("#RegRemind").popover({trigger:'hover',placement:'bottom',content:'当前'+RemindFromDay+'日前及'+RemindToDay+'日后内需提醒职业暴露检查例数'});
	$("#EntRemind").popover({trigger:'hover',placement:'bottom',content:'当前7日内环境卫生学监测报告不合格例数'});
	$("#UnReadMsg").popover({trigger:'hover',placement:'bottom',content:'31日内消息未读病例数'});
	$("#IsNeedAt").popover({trigger:'hover',placement:'bottom',content:'需关注病例数'});

	//待审报告
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
	//疑似待处理
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
	
	//确诊未报
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
	$cm({                  
		ClassName:"DHCHAI.IRS.EnviHyReportSrv",
		MethodName:"GetRemindEnvRt",
		aLocID:$.LOGON.LOCID
	},function(jsonData){
		$("#entRemind").html(jsonData);
	});
	
	
	//31日内未读消息病例数
	$cm({                  
		ClassName:"DHCHAI.IRS.CCMessageSrv",
		MethodName:"GetUnReadMsgCnt",
		aLocID:$.LOGON.LOCID
	},function(jsonData){
		$("#cntUnReadMsg").html(jsonData);
	});
	
	//需关注病例数
	$cm({                  
		ClassName:"DHCHAI.IRS.CCScreenAttSrv",
		MethodName:"GetNeedAttCnt",
		aLocID:$.LOGON.LOCID
	},function(jsonData){
		$("#cntNeedAtt").html(jsonData);
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
				y:31,
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
				    type: 'value',
				    name: '现患率(%)',
					axisLabel : {
						formatter: '{value}'
					}
				}
			],
			series : [
				{
				    name: '现患率',
					type:'line',
					data:arrInfPatCnt
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
		var myChart = echarts.init(document.getElementById('divFeverNum1'));
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
		var myChart = echarts.init(document.getElementById('divBacteria0'));
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
}

function LoadFeverFever() {	
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
			echartLocFeverNumber(retval);
		},
		error: function(XMLHttpRequest, textStatus, errorThrown) {
			var tkclass = "DHCHAI.STAS.WelcomeSrv";
			var tkQuery = "QryLocFeverNumber";
			alert("类" + tkclass + ":" + tkQuery + "执行错误,Status:" + textStatus + ",Error:" + errorThrown);
		}
	});
	
	function echartLocFeverNumber(runQuery){
		if (!runQuery) return;
		var arrViewLoc = new Array();
		var arrFeverNumber = new Array();
		var arrRecord = runQuery.record;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			arrViewLoc.push(rd["LocDesc"]);
			arrFeverNumber.push(parseFloat(rd["FeverNumber"]));
		}
		var myChart = echarts.init(document.getElementById('divFeverNum0'));
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
}



function LoadBactMBRRatio() {
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
			echartBactMBRRatio(retval);
		},
		error: function(XMLHttpRequest, textStatus, errorThrown) {
			var tkclass = "DHCHAI.STAS.WelcomeSrv";
			var tkQuery = "QryBactMBRRatio";
			alert("类" + tkclass + ":" + tkQuery + "执行错误,Status:" + textStatus + ",Error:" + errorThrown);
		}
	});
	function echartBactMBRRatio(runQuery){
		if (!runQuery) return;
		var arrMBRLocDesc2 = new Array();
		var arrMBRRatio2 = new Array();
		var arrRecord = runQuery.record;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			arrMBRLocDesc2.push(rd["BactDesc"]);
			arrMBRRatio2.push(parseFloat(rd["MBRRatio"]).toFixed(2));
		}
		var myChart = echarts.init(document.getElementById('divBacteria1'));
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
}


function btnUnCheck_Click(){
	var y = new Date().getFullYear();
	var m = new Date().getMonth()+1;
	var d = new Date().getDate();
	var acurrDate = y+"-"+m+"-"+d;
	var RepType = "1|2"
	var url="dhchai.ir.inf.repqry.csp?1=1&currDate="+acurrDate+'&Status='+113+'&flag='+1+'&aRepType='+RepType+"&2=2";
	websys_showModal({
		url:url,
		title:'当前'+InfRepDay+'日内感染报告待审核例数',
		iconCls:'icon-w-epr',  
		width:'98%',
		height:'98%'
	});
}
function btnUnTreated_Click(){
	var url="dhcma.hai.ir.ccscreening.csp?1=1";
	websys_showModal({
		url:url,
		title:'疑似未处理',
		iconCls:'icon-w-epr',  
		width:'98%',
		height:'98%'
	});
}

function btnInfNoRep_Click(){
	var url="dhcma.hai.ir.norepscreening.csp?1=1";	
	websys_showModal({
		url:url,
		title:'当前在院及出院'+InfNoRepDay+'日内疑似已确诊未报告感染报告病例数',
		iconCls:'icon-w-epr',  
		width:'98%',
		height:'98%'
	});
}

function btnInfMrb_Click(){
	var url="dhchai.ir.mrb.ctlresult.csp?1=1&HomeFlag=1";
	websys_showModal({
		url:url,
		title:'当前'+InfMrbDay+'日内报告多重耐药菌例数',
		iconCls:'icon-w-epr',  
		width:'98%',
		height:'98%'
	});
}

function btnUnReadMsg_Click(){
	var url="dhcma.hai.ir.unreadmsg.csp?1=1";
	websys_showModal({
		url:url,
		title:'31日内消息未读病例数',
		iconCls:'icon-w-epr',  
		width:'98%',
		height:'98%'
	});
}

function btnNeedAtt_Click(){
	var url="dhcma.hai.ir.needattlist.csp?1=1";
	websys_showModal({
		url:url,
		title:'需关注病例数',
		iconCls:'icon-w-epr',  
		width:'98%',
		height:'98%'
	});
}


