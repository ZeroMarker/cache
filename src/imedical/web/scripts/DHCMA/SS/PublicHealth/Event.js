//页面Event
function InitPublicHealthWinEvent(obj){	
    //屏幕宽高
    var Width  = window.screen.availWidth-20;
    var winHeight = window.screen.availHeight;
    if (winHeight>1000) {
	    var Height = winHeight-200;
    }else if (winHeight>800) {
	     var Height = winHeight-160;
    }else {
	     var Height = winHeight-80;
    }
    
    //弹出加载层
	function loadingWindow() {
	    var left = ($(window).outerWidth(true) - 190) / 2; 
		var top = ($(window).height() - 35) / 2; 
		var height = $(window).height() * 2; 
 		$("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: height }).appendTo("#divMain"); 
 		$("<div class=\"datagrid-mask-msg\"></div>").html("正在加载,请稍候...").appendTo("#divMain").css({ display: "block", left: left, top: top }); 
	}
	
	//取消加载层  
	function disLoadWindow() {
	    $(".datagrid-mask").remove();
	    $(".datagrid-mask-msg").remove();
	}
	
    //var Height = window.screen.availHeight-80;
	obj.LoadEvent = function(){
	  	loadingWindow();
		window.setTimeout(function () { 
			obj.LoadData();
			disLoadWindow(); 
		}, 100); 
 	}
	
	obj.LoadData = function(){
		//判断设置公共卫生首页权限
		if (Object.keys(tDHCMAModuleRole).length < 1){
			$("#divMain").empty();//清空主区域内容
			htmlStr='<div class="noresult">'
					+ 	'<div class="nodata"><p>未配置产品权限!</p></div>'
					+'</div>';
			$("#divMain").append(htmlStr);
			return;
		}
		
		//传染病主页内容
		if ((tDHCMAModuleRole['EPD']==1)||(tDHCMAModuleRole['Super']==1)){
			//传染病疑似筛查确诊未报数量
			$m({
				ClassName  : "DHCMed.EPDService.Service",
				MethodName : "GetUnRepEpdCnt",
				aDateFrom  : obj.lastMonth,
				aDateTo    : obj.now,
				aLoc	   : session['LOGON.CTLOCID']
			},function(txtData){
				var cnt = txtData;
				$("#cntUnRepEpd").html(cnt);
				if (cnt>0) {
					$("#cntUnRepEpd").css('display','block');
				}
			});
			//传染病报告未审核数量
			$m({
				ClassName  : "DHCMed.EPDService.Service",
				MethodName : "GetUnChkEpdCnt",
				aDateFrom  : obj.lastMonth,
				aDateTo    : obj.now,
				aLoc	   : session['LOGON.CTLOCID']
			},function(txtData){
				var cnt = txtData;
				$("#cntUnChkEpd").html(cnt);
				if (cnt>0) {
					$("#cntUnChkEpd").css('display','block');
				}
			});
			
			//传染病未报科室汇总
			$cm({
				ClassName:"DHCMed.EPDService.Service",
				QueryName:"QryEpdUnRepLocCnt",
				aLocID	 : session['LOGON.CTLOCID'],
				aDateFrom: obj.lastMonth,
				aDateTo  : obj.now
			},function(rs){
				obj.echartEpdUnRepLocCnt(rs);
			});
			
			//流行性感冒趋势分析
			$cm({
				ClassName:"DHCMed.EPDService.QryReportILI",
				QueryName:"QryHospILIRatio",
				aLocID	 : session['LOGON.CTLOCID'],
				aDateFrom: obj.lastMonth,
				aDateTo  : obj.now
			},function(rs){
				obj.echartEpdFluTrend(rs);
			});
			
			//传染病科室汇总
			$cm({
				ClassName:"DHCMed.EPDService.Service",
				QueryName:"QryEpdRepLocCnt",
				aLocID	 : session['LOGON.CTLOCID'],
				aDateFrom: obj.lastMonth,
				aDateTo  : obj.now
			},function(rs){
				obj.echartEpdRepLocCnt(rs);
			});
			
			//传染病疾病分布
			$cm({
				ClassName:"DHCMed.EPDService.Service",
				QueryName:"QryEpdRepICDCnt",
				aLocID	 : session['LOGON.CTLOCID'],
				aDateFrom: obj.lastMonth,
				aDateTo  : obj.now
			},function(rs){
				obj.echartEpdRepICDCnt(rs);
			});
			
		} else {
			$("#epdchart").css("display", "none");
			$("#epdtodo1").css("display", "none");
			$("#epdtodo2").css("display", "none");
		}
		
		//死亡证主页内容
		if ((tDHCMAModuleRole['DTH']==1)||(tDHCMAModuleRole['Super']==1)){
			//死亡证报告未审核数量
			$m({
				ClassName  : "DHCMed.DTHService.CommonSrv",
				MethodName : "GetUnChkDthCnt",
				aDateFrom  : obj.lastMonth,
				aDateTo    : obj.now,
				aLoc	   : session['LOGON.CTLOCID']
			},function(txtData){
				var cnt = txtData;
				$("#cntUnChkDth").html(cnt);
				if (cnt>0) {
					$("#cntUnChkDth").css('display','block');
				}
			});
			
			//儿童死亡证报告未审核数量
			$m({
				ClassName  : "DHCMed.DTHService.CommonSrv",
				MethodName : "GetUnChkChildDthCnt",
				aDateFrom  : obj.lastMonth,
				aDateTo    : obj.now,
				aLoc	   : session['LOGON.CTLOCID']
			},function(txtData){
				var cnt = txtData;
				$("#cntUnChkChildDth").html(cnt);
				if (cnt>0) {
					$("#cntUnChkChildDth").css('display','block');
				}
			});
			
			//死亡患者科室汇总
			$cm({
				ClassName:"DHCMed.DTHService.CommonSrv",
				QueryName:"QryDthRepLocCnt",
				aLocID	 : session['LOGON.CTLOCID'],
				aDateFrom: obj.lastMonth,
				aDateTo  : obj.now
			},function(rs){
				obj.echartDthRepLocCnt(rs);
			});
			
			//死亡患者疾病分布
			$cm({
				ClassName:"DHCMed.DTHService.CommonSrv",
				QueryName:"QryDthRepICDCnt",
				aLocID	 : session['LOGON.CTLOCID'],
				aDateFrom: obj.lastMonth,
				aDateTo  : obj.now
			},function(rs){
				obj.echartDthRepICDCnt(rs);
			});
			
		} else {
			$("#dthchart").css("display", "none");
			$("#dthtodo1").css("display", "none");
			$("#dthtodo2").css("display", "none");
		}
		
		//慢病主页内容
		if ((tDHCMAModuleRole['CD']==1)||(tDHCMAModuleRole['Super']==1)){
			//肿瘤卡未审核
			$m({
				ClassName  : "DHCMed.CDService.Service",
				MethodName : "GetUnChkCDReportCnt",
				aDateFrom  : obj.lastMonth,
				aDateTo    : obj.now,
				aLoc	   : session['LOGON.CTLOCID']
			},function(txtData){
				if (txtData != '') {
					var CDTypeList=txtData.split('^');
					for (var i=0; i<CDTypeList.length; i++) {
						if (CDTypeList[i] == '') {
							continue;
						}
						var CDTypeCntArr=CDTypeList[i].split(':');
						var CDType=CDTypeCntArr[0];
						var cnt=CDTypeCntArr[1];
						
						if (CDType=='ZLK') {
							$("#cntUnChkCDZLK").html(cnt);
							if (cnt>0) {
								$("#cntUnChkCDZLK").css('display','block');
							}
						}
						if ((CDType=='XNXG')&&(cnt>0)) {
							$("#cdxnxgtodo1").css('display','block');
							$("#cntUnChkCDXNXG").html(cnt);
							$("#cntUnChkCDXNXG").css('display','block');
						}
						if ((CDType=='GWZS')&&(cnt>0)) {
							$("#cdgwzstodo1").css('display','block');
							$("#cntUnChkCDGWZS").html(cnt);
							$("#cntUnChkCDGWZS").css('display','block');
						}
						if ((CDType=='NYZD')&&(cnt>0)) {
							$("#cdnyzdtodo1").css('display','block');
							$("#cntUnChkCDNYZD").html(cnt);
							$("#cntUnChkCDNYZD").css('display','block');
						}
						if ((CDType=='YSZYB')&&(cnt>0)) {
							$("#cdyszybtodo1").css('display','block');
							$("#cntUnChkCDYSZYB").html(cnt);
							$("#cntUnChkCDYSZYB").css('display','block');
						}
						if ((CDType=='SHK')&&(cnt>0)) {
							$("#cdshktodo1").css('display','block');
							$("#cntUnChkCDSHK").html(cnt);
							$("#cntUnChkCDSHK").css('display','block');
						}
						if ((CDType=='FZYCO')&&(cnt>0)) {
							$("#cdfzycotodo1").css('display','block');
							$("#cntUnChkCDFZYCO").html(cnt);
							$("#cntUnChkCDFZYCO").css('display','block');
						}
						if ((CDType=='TNB')&&(cnt>0)) {
							$("#cdtnbtodo1").css('display','block');
							$("#cntUnChkCDTNB").html(cnt);
							$("#cntUnChkCDTNB").css('display','block');
						}
					}
				}
			});
			
		} else {
			$("#cdtodo1").css("display", "none");
		}
		
		//食源性疾病主页内容
		if ((tDHCMAModuleRole['FBD']==1)||(tDHCMAModuleRole['Super']==1)){
			//食源性疾病未审核
			$m({
				ClassName  : "DHCMed.FBDService.Service",
				MethodName : "GetUnChkFBDReportCnt",
				aDateFrom  : obj.lastMonth,
				aDateTo    : obj.now,
				aLoc	   : session['LOGON.CTLOCID']
			},function(txtData){
				var cnt = txtData;
				$("#cntUnChkFbd").html(cnt);
				if (cnt>0) {
					$("#cntUnChkFbd").css('display','block');
				}
			});
			
		} else {
			$("#fbdtodo1").css("display", "none");
		}
		
		//精神疾病主页内容
		if ((tDHCMAModuleRole['SMD']==1)||(tDHCMAModuleRole['Super']==1)){
			//精神疾病未审核
			$m({
				ClassName  : "DHCMed.SMDService.Service",
				MethodName : "GetUnChkSMDReportCnt",
				aDateFrom  : obj.lastMonth,
				aDateTo    : obj.now,
				aLoc	   : session['LOGON.CTLOCID']
			},function(txtData){
				var cnt = txtData;
				$("#cntUnChkSmd").html(cnt);
				if (cnt>0) {
					$("#cntUnChkSmd").css('display','block');
				}
			});
			
		} else {
			$("#smdtodo1").css("display", "none");
		}
		// 慢阻肺主页内容
		if ((tDHCMAModuleRole['COP']==1)||(tDHCMAModuleRole['Super']==1)){
			// 慢阻肺未审核
			$m({
				ClassName  : "DHCMA.COP.IRS.ReportSrv",
				MethodName : "GetUnChkCOPReportCnt",
				aDateFrom  : obj.lastMonth,
				aDateTo    : obj.now,
				aLoc	   : session['LOGON.CTLOCID']
			},function(txtData){
				var cnt = txtData;
				$("#cntUnChkCop").html(cnt);
			});
			
		} else {
			$("#coptodo1").css("display", "none");
		}
	}
	
	obj.echartEpdUnRepLocCnt = function(rs){
		if (!rs) return;
		var arrViewLoc = new Array();
		var arrUnRepCnt = new Array();
		var arrRecord = rs.rows;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			arrViewLoc.push(rd["LocDesc"]);
			arrUnRepCnt.push(parseFloat(rd["Cnt"]));
		}
		var myChart = echarts.init(document.getElementById('divEpdUnRepLocCnt'));
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
					name:'传染病未报人数',
					type:'bar',
					itemStyle : {
						normal:{
							color : '#3398db'
						}
					},
					data:arrUnRepCnt,
					barWidth: 30
				}
			]
		};
		myChart.setOption(option);
	}
	
	obj.echartEpdFluTrend = function(rs){
		if (!rs) return;
		var arrViewTitle = new Array();
		var arrInfPatCnt = new Array();
		var arrRecord = rs.rows;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			arrViewTitle.push(rd["admDate"]);
			arrInfPatCnt.push(parseFloat(rd["PrevRatio"]).toFixed(2));
		}
		var myChart = echarts.init(document.getElementById('divEpdFluTrend'));
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
					name:'流感率',
					type:'line',
					data:arrInfPatCnt
				}
			]
		};
		myChart.setOption(option);
	}
	
	obj.echartEpdRepICDCnt = function(rs){
		if (!rs) return;
		var arrViewLoc = new Array();
		var arrRepCnt = new Array();
		var arrRecord = rs.rows;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			arrViewLoc.push(rd["RepLocDesc"]);
			arrRepCnt.push(parseFloat(rd["RepCnt"]));
		}
		var myChart = echarts.init(document.getElementById('divEpdRepICDCnt'));
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
					name:'传染疾病数目',
					type:'bar',
					itemStyle : {
						normal:{
							color : '#3398db'
						}
					},
					data:arrRepCnt,
					barWidth: 30
				}
			]
		};
		myChart.setOption(option);
	}
	
	obj.echartEpdRepLocCnt = function(rs){
		if (!rs) return;
		var arrViewLoc = new Array();
		var arrRepCnt = new Array();
		var arrRecord = rs.rows;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			arrViewLoc.push(rd["RepLocDesc"]);
			arrRepCnt.push(parseFloat(rd["RepCnt"]));
		}
		var myChart = echarts.init(document.getElementById('divEpdRepLocCnt'));
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
					name:'传染病人数',
					type:'bar',
					itemStyle : {
						normal:{
							color : '#3398db'
						}
					},
					data:arrRepCnt,
					barWidth: 30
				}
			]
		};
		myChart.setOption(option);
	}
	
	obj.echartDthRepLocCnt = function(rs){
		if (!rs) return;
		var arrViewLoc = new Array();
		var arrDTHCnt = new Array();
		var arrRecord = rs.rows;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			arrViewLoc.push(rd["LocDesc"]);
			arrDTHCnt.push(parseFloat(rd["Cnt"]));
		}
		var myChart = echarts.init(document.getElementById('divDthRepLocCnt'));
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
					name:'死亡人数',
					type:'bar',
					itemStyle : {
						normal:{
							color : '#3398db'
						}
					},
					data:arrDTHCnt,
					barWidth: 30
				}
			]
		};
		myChart.setOption(option);
	}
	
	obj.echartDthRepICDCnt = function(rs){
		if (!rs) return;
		var arrViewICD = new Array();
		var arrDTHICDCnt = new Array();
		var arrRecord = rs.rows;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			arrViewICD.push(rd["ICDDesc"]);
			arrDTHICDCnt.push(parseFloat(rd["ICDCnt"]));
		}
		var myChart = echarts.init(document.getElementById('divDthRepICDCnt'));
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
					data : arrViewICD,
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
					name:'死亡疾病数目',
					type:'bar',
					itemStyle : {
						normal:{
							color : '#3398db'
						}
					},
					data:arrDTHICDCnt,
					barWidth: 30
				}
			]
		};
		myChart.setOption(option);
	}
}

//传染病未报
function btnUnRepEpd_Click(){
	var strUrl = "./dhcma.epd.ctlresult.csp?1=1&2=2"
	    websys_showModal({
			url:strUrl,
			title:'传染病筛查',
			iconCls:'icon-w-epr',  
	        originWindow:window,
			width:1340,
			height:'90%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
			onBeforeClose:function(){
				window.location.reload();  //刷新当前界面
			} 
		});
}

//传染病未审
function btnUnChkEpd_Click(){
	var strUrl = "./dhcma.epd.querybydateloc.csp?1=1&LocFlag=1&2=2"
	    websys_showModal({
			url:strUrl,
			title:'传染病报告查询',
			iconCls:'icon-w-epr',  
	        originWindow:window,
			width:1440,
			height:'90%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
			onBeforeClose:function(){
				window.location.reload();  //刷新当前界面
			} 
		});
}
//死亡未审
function btnUnChkDth_Click(){
	var strUrl = "./dhcma.dth.reportlist.csp?1=1&RepType=&2=2"
	    websys_showModal({
			url:strUrl,
			title:'死亡报告查询',
			iconCls:'icon-w-epr',  
	        originWindow:window,
			width:1340,
			height:'90%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
			onBeforeClose:function(){
				window.location.reload();  //刷新当前界面
			} 
		});
}
//儿童死亡未审
function btnUnChkChildDth_Click(){
	var strUrl = "./dhcma.dth.childdeathlist.csp?1=1&2=2"
	    websys_showModal({
			url:strUrl,
			title:'儿童死亡报告查询',
			iconCls:'icon-w-epr',  
	        originWindow:window,
			width:1340,
			height:'90%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
			onBeforeClose:function(){
				window.location.reload();  //刷新当前界面
			} 
		});
}
//食源性疾病未审核
function btnUnChkFbd_Click(){
	var strUrl = "./dhcma.fbd.qrybydate.csp?1=1&LocFlag=" + 1;
	    websys_showModal({
			url:strUrl,
			title:'食源性疾病报告查询',
			iconCls:'icon-w-epr',  
	        originWindow:window,
			width:1340,
			height:'90%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
			onBeforeClose:function(){
				window.location.reload();  //刷新当前界面
			} 
		});
}
//精神性疾病未审核
function btnUnChkSmd_Click(){
	var strUrl = "./dhcma.smd.reportqry.csp?1=1&2=2"
	    websys_showModal({
			url:strUrl,
			title:'精神疾病报告查询',
			iconCls:'icon-w-epr',  
	        originWindow:window,
			width:1340,
			height:'90%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
			onBeforeClose:function(){
				window.location.reload();  //刷新当前界面
			} 
		});
}

//肿瘤报卡未审
function btnUnChkCDZLK_Click(){
	var strUrl = "./dhcma.cd.crreportzlkqry.csp?1=1&LocFlag="+ 1;
	    websys_showModal({
			url:strUrl,
			title:'肿瘤报告查询',
			iconCls:'icon-w-epr',  
	        originWindow:window,
			width:1460,
			height:'90%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
			onBeforeClose:function(){
				window.location.reload();  //刷新当前界面
			} 
		});
}
//心脑血管未审
function btnUnChkCDXNXG_Click(){
	var strUrl = "./dhcma.cd.crreportxnxgqry.csp?1=1&LocFlag="+ 1;
	    websys_showModal({
			url:strUrl,
			title:'心脑血管事件报告查询',
			iconCls:'icon-w-epr',  
	        originWindow:window,
			width:1460,
			height:'90%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
			onBeforeClose:function(){
				window.location.reload();  //刷新当前界面
			} 
		});
}

//高温中暑未审
function btnUnChkCDGWZS_Click(){
	var strUrl = "./dhcma.cd.crreportgwzs.csp?1=1&LocFlag="+ 1;
	    websys_showModal({
			url:strUrl,
			title:'高温中暑报告查询',
			iconCls:'icon-w-epr',  
	        originWindow:window,
			width:1460,
			height:'90%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
			onBeforeClose:function(){
				window.location.reload();  //刷新当前界面
			} 
		});
}

//农药中毒未审
function btnUnChkCDNYZD_Click(){
	var strUrl = "./dhcma.cd.crreportnyzdqry.csp?1=1&LocFlag="+ 1;
	    websys_showModal({
			url:strUrl,
			title:'农药中毒报告查询',
			iconCls:'icon-w-epr',  
	        originWindow:window,
			width:1460,
			height:'90%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
			onBeforeClose:function(){
				window.location.reload();  //刷新当前界面
			} 
		});
}

//疑似职业病未审
function btnUnChkCDYSZYB_Click(){
	var strUrl = "./dhcma.cd.crreportyszyb.csp?1=1&LocFlag="+ 1;
	    websys_showModal({
			url:strUrl,
			title:'疑似职业病报告查询',
			iconCls:'icon-w-epr',  
	        originWindow:window,
			width:1460,
			height:'90%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
			onBeforeClose:function(){
				window.location.reload();  //刷新当前界面
			} 
		});
}

//伤害卡未审
function btnUnChkCDSHK_Click(){
	var strUrl = "./dhcma.cd.crreportshk.csp?1=1&LocFlag="+ 1;
	    websys_showModal({
			url:strUrl,
			title:'意外伤害监测报告查询',
			iconCls:'icon-w-epr',  
	        originWindow:window,
			width:1460,
			height:'90%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
			onBeforeClose:function(){
				window.location.reload();  //刷新当前界面
			} 
		});
}

//一氧化碳中毒未审
function btnUnChkCDFZYCO_Click(){
	var strUrl = "./dhcma.cd.crreportfzycoqry.csp?1=1&LocFlag="+ 1;
	    websys_showModal({
			url:strUrl,
			title:'非职业一氧化碳中毒报告查询',
			iconCls:'icon-w-epr',  
	        originWindow:window,
			width:1460,
			height:'90%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
			onBeforeClose:function(){
				window.location.reload();  //刷新当前界面
			} 
		});
}

//糖尿病未审
function btnUnChkCDTNB_Click(){
	var strUrl = "./dhcma.cd.crreporttnbqry.csp?1=1&LocFlag="+ 1;
	    websys_showModal({
			url:strUrl,
			title:'糖尿病报告查询',
			iconCls:'icon-w-epr',  
	        originWindow:window,
			width:1460,
			height:'90%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
			onBeforeClose:function(){
				window.location.reload();  //刷新当前界面
			} 
		});
}
// 慢阻肺疾病未审核
function btnUnChkCop_Click(){
	var strUrl = "./dhcma.cop.ir.reportqry.csp?1=1&2=2"
	    websys_showModal({
			url:strUrl,
			title:'慢阻肺报告查询',
			iconCls:'icon-w-epr',  
	        originWindow:window,
			width:1340,
			height:'90%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
			onBeforeClose:function(){
				window.location.reload();  //刷新当前界面
			} 
		});
}