$(function () {
	InitWelcomePage();
});
var obj = new Object();
//加载主页
function InitWelcomePage(){
	//1.加载待处理事项
    LoadToDoList();
    //2.加载全院概况
    LoadToHosp();
    //3.加载统计饼状图(医院感染部位+多耐检出+暴露工作类别+检出合格率+手卫生依从率)
    LoadToChart_1();
    //4.加载统计柱状图(感染发病率+现患率+三天发热+多耐菌分布)
    LoadToChart_2();
}
//1->加载待处理事项
function LoadToDoList() {
	//->加载页签
	$("#InfRep").popover({trigger:'hover',placement:'bottom',content:'当前'+InfRepDay+'日内感染报告待审核例数'});
	$("#InfScreen").popover({trigger:'hover',placement:'bottom',content:'当前在院疑似待处理病例数'});
	$("#InfNoRep").popover({trigger:'hover',placement:'bottom',content:'当前在院及出院'+InfNoRepDay+'日内疑似已确诊未报告感染报告病例数'});
	$("#InfMrb").popover({trigger:'hover',placement:'bottom',content:'当前'+InfMrbDay+'日内报告多重耐药菌例数'});
	$("#RegCheck").popover({trigger:'hover',placement:'bottom',content:'当前职业暴露报告待审核例数'});
	$("#RegRemind").popover({trigger:'hover',placement:'bottom',content:'当前'+RemindFromDay+'日前及'+RemindToDay+'日后内需提醒职业暴露检查例数'});
	$("#EntRemind").popover({trigger:'hover',placement:'bottom',content:'当前7日内环境卫生学监测报告不合格例数'});
	$("#UnReadMsg").popover({trigger:'hover',placement:'bottom',content:'31日内消息未读病例数'});
	$("#IsNeedAtt").popover({trigger:'hover',placement:'bottom',content:'需关注病例数'});
	$("#UnMap").popover({trigger:'hover',placement:'bottom',content:'未对照的抗生素、细菌、抗菌药物、标本、常用短语总数'});
	$("#EntMissRemind").popover({trigger:'hover',placement:'bottom',content:'环境卫生学监测科室计划未完成的项目数'});
	$("#WarnLoc").popover({trigger:'hover',placement:'bottom',content:'暴发预警疑似聚集科室数量'});
	$("#AntUseOver").popover({trigger:'hover',placement:'bottom',content:'抗菌药物连续使用超过'+OverDays+'天的在院患者数量'})
	//->显示(隐藏)模块
	$m({
   		ClassName: "DHCHAI.BT.SysUser",
		MethodName: "GetControlByID",
		aType:1,
		aID: $.LOGON.USERID
	}, function(Data){
		var ControlData="";
		if (Data!="") {
			if(ControlData=="Empty"){
		 		ControlData="";
		 	}
		 	else{
				ControlData=Data;
			}
		}else {
			//未设置时'默认加载所有'
			ControlData="InfRep,InfScreen,InfNoRep,WarnLoc,InfMrb,AntUseOver,RegCheck,RegRemind,EntRemind,EntMissRemind,UnReadMsg,IsNeedAtt,UnMap";
		}
		var ControlList="InfRep,InfScreen,InfNoRep,WarnLoc,InfMrb,AntUseOver,RegCheck,RegRemind,EntRemind,EntMissRemind,UnReadMsg,IsNeedAtt,UnMap";
		for(var ind=0;ind<ControlList.split(",").length;ind++){
			var Control=ControlList.split(",")[ind];
			if(ControlData.indexOf(Control)>=0){
				$('#'+Control).show();			//显示
			}
			else{
				$('#'+Control).hide();			//隐藏
			}
		}
	});
	//->加载待审核报告数量
	$cm({
   		ClassName: "DHCHAI.STAS.WelcomeSrv",
		QueryName: "QrySpanInfRepCnt",
		aLocID:$.LOGON.LOCID
	}, function(jsonData){
		if (jsonData!="") {
			var cnt = jsonData.rows[0].Count;
			if (cnt>0) {
				$("#cntInfRep").addClass("notice");
				$("#cntInfRep").html(cnt);
			}else {
				$("#cntInfRep").removeClass("notice");
				$("#cntInfRep").html("");
			}
		}
	});
	//->加载疑似待处理数量
	$cm({
   		ClassName: "DHCHAI.STAS.WelcomeSrv",
		QueryName: "QrySpanInfScreenCnt",
		aLocID:$.LOGON.LOCID
	}, function(jsonData){
		if (jsonData!="") {
			var cnt = jsonData.rows[0].Count;
			if (cnt>0) {
				$("#cntInfScreen").addClass("notice");
				$("#cntInfScreen").html(cnt);
			}else {
				$("#cntInfScreen").removeClass("notice");
				$("#cntInfScreen").html("");
			}
		}
	});
	//->加载确诊未报数量
	$cm({
   		ClassName: "DHCHAI.IRS.CCScreeningSrv",
		QueryName: "QryInfNoRep",
		aDateFrom: "",
		aDateTo: "",
		aHospIDs:HospAllIdsM
	}, function(jsonData){
		if (jsonData!="") {
			var cnt = jsonData.total;
			if (cnt>0) {
				$("#cntInfNoRep").addClass("notice");
				$("#cntInfNoRep").html(cnt);
			}else {
				$("#cntInfNoRep").removeClass("notice");
				$("#cntInfNoRep").html("");
			}
		}
	});
	
	//->加载暴发预警科室数量
	$cm({
   		ClassName: "DHCHAI.IRS.CCWarningNewSrv",
		QueryName: "QryWarnLoc",
		aHospIDs:HospAllIdsM
	}, function(jsonData){
		if (jsonData!="") {
			var cnt = jsonData.rows[0].LocCnt;
			if (cnt>0) {
				$("#cntWarnLoc").addClass("notice");
				$("#cntWarnLoc").html(cnt);
			}else {
				$("#cntWarnLoc").removeClass("notice");
				$("#cntWarnLoc").html("");
			}
		}
	});
	//->加载多重耐药菌数量
	$cm({
   		ClassName: "DHCHAI.STAS.WelcomeSrv",
		QueryName: "QryMRBResult",
		aHospIDs:HospAllIdsM,
		aDateType:2		//报告日期
	}, function(jsonData){
		if (jsonData!="") {
			var cnt=jsonData.total;
			if (cnt>0) {
				$("#cntInfMrb").addClass("notice");
				$("#cntInfMrb").html(cnt);
			}else {
				$("#cntInfMrb").removeClass("notice");
				$("#cntInfMrb").html("");
			}
		}
	});
	
	//->加载抗菌药物连续使用
	$cm({
   		ClassName: "DHCHAI.DPS.OEOrdItemSrv",
		QueryName: "QryAntOverDaysCnt",
		aDays:OverDays,
		aDate:''
	}, function(jsonData){
		if (jsonData!="") {
			var cnt=jsonData.rows[0].Count;
			if (cnt>0) {
				$("#cntAntUse").addClass("notice");
				$("#cntAntUse").html(cnt);
			}else {
				$("#cntAntUse").removeClass("notice");
				$("#cntAntUse").html("");
			}
		}
	});
	
	//->加载职业暴露报告待审核记录数量
	$cm({
   		ClassName: "DHCHAI.IRS.OccExpRegSrv",
		QueryName: "QryExpCheckCnt",
		aLocID:$.LOGON.LOCID
	}, function(jsonData){
		if (jsonData!="") {
			var cnt=jsonData.rows[0].Count;
			if (cnt>0) {
				$("#cntCheck").addClass("notice");
				$("#cntCheck").html(cnt);
			}else {
				$("#cntCheck").removeClass("notice");
				$("#cntCheck").html("");
			}
		}
	});
	//->加载暴露报告检验提醒记录数量
	$cm({
   		ClassName: "DHCHAI.IRS.OccExpRegSrv",
		QueryName: "QryRemindCnt",
		aLocID:$.LOGON.LOCID
	}, function(jsonData){
		if (jsonData!="") {
			var cnt=jsonData.rows[0].Count;
			if (cnt>0) {
				$("#cntRemind").addClass("notice");
				$("#cntRemind").html(cnt);
			}else {
				$("#cntRemind").removeClass("notice");
				$("#cntRemind").html("");
			}
		}
	});
	//->加载未对照内容提醒数量
	$cm({
   		ClassName: "DHCHAI.DPS.NoMapCountSrv",
		QueryName: "QryNoMapSumCount"
	}, function(jsonData){
		if (jsonData!="") {
			var cnt=jsonData.rows[0].SumCount;
			if (cnt>0) {
				$("#NoMapCount").addClass("notice");
				$("#NoMapCount").html(cnt);
			}else {
				$("#NoMapCount").removeClass("notice");
				$("#NoMapCount").html("");
			}
		}
	});
	
	/*- 2020新增模块 -*/
	//->加载31日内未读消息病例数数量
	$cm({                  
		ClassName:"DHCHAI.IRS.CCMessageSrv",
		MethodName:"GetUnReadMsgCnt",
		aLocID:$.LOGON.LOCID
	},function(jsonData){
		if (jsonData>0) {
			$("#cntUnReadMsg").addClass("notice");
			$("#cntUnReadMsg").html(jsonData);
		}else {
			$("#cntUnReadMsg").removeClass("notice");
			$("#cntUnReadMsg").html("");
		}
	});
	//->加载需关注病例数数量
	$cm({                  
		ClassName:"DHCHAI.IRS.CCScreenAttSrv",
		MethodName:"GetNeedAttCnt",
		aLocID:$.LOGON.LOCID
	},function(jsonData){
		if (jsonData>0) {
			$("#cntNeedAtt").addClass("notice");
			$("#cntNeedAtt").html(jsonData);
		}else {
			$("#cntNeedAtt").removeClass("notice");
			$("#cntNeedAtt").html("");
		}
	});	
	/*- 2021新增模块 -*/
	//->加载环境卫生学7天不合格报告提醒数量
	$cm({                  
		ClassName:"DHCHAI.IRS.EnviHyReportSrv",
		MethodName:"GetRemindEnvRt",
		aLocID:$.LOGON.LOCID
	},function(jsonData){
		if (jsonData>0) {
			$("#cntentRemind").addClass("notice");
			$("#cntentRemind").html(jsonData);
		}else {
			$("#cntentRemind").removeClass("notice");
			$("#cntentRemind").html("");
		}
	});
	//->加载环境卫生学7天不合格报告提醒数量
	$cm({                  
		ClassName:"DHCHAI.IRS.EnviHyLocItemsSrv",
		MethodName:"GetRemindEnvRt"
	},function(jsonData){
		if (jsonData>0) {
			$("#cntentMissRemind").addClass("notice");
			$("#cntentMissRemind").html(jsonData);
		}else {
			$("#cntentMissRemind").removeClass("notice");
			$("#cntentMissRemind").html("");
		}
	});
	
	/***设置页签显示[待处理事项]***/
	//***点击设置图标
    $('.icon-todo-install').click(function(){
	    //初始化下拉菜单
		var cboTodo = $HUI.combobox("#cboTodo",{
			valueField:'id',
			textField:'text',
			multiple:true,
			rowStyle:'checkbox', 		//显示成勾选行形式
			selectOnNavigation:false,
			editable:false,
			data:[
				{id:'InfRep',text:'新报告审核'},
				{id:'InfScreen',text:'疑似未处理'},
				{id:'InfNoRep',text:'确诊未上报'},
				{id:'WarnLoc',text:'暴发预警科室'},
				{id:'AntUseOver',text:'抗菌药物连续使用'},
				{id:'InfMrb',text:'多重耐药菌'},
				{id:'RegCheck',text:'待审职业暴露'},
				{id:'RegRemind',text:'职业暴露提醒'},
				{id:'EntRemind',text:'环境卫生学提醒'},
				{id:'EntMissRemind',text:'环境卫生学漏监测'},
				{id:'UnReadMsg',text:'未读消息'},
				{id:'IsNeedAtt',text:'需关注病例'},
				{id:'UnMap',text:'未对照短语'}
			]
		});
		//加载下拉菜单(设置值)
	    var ControlData = $m({
            ClassName: "DHCHAI.BT.SysUser",
            MethodName: "GetControlByID",
            aType:1,
            aID: $.LOGON.USERID
       	}, false);
       	if(ControlData=="Empty")ControlData="";
       	var ControlList=[];
       	for(var ind=0;ind<ControlData.split(",").length;ind++){
	        var Control=ControlData.split(",")[ind];
	       	ControlList.push(Control);
	    }
	    $('#cboTodo').combobox("setValues",ControlList);
		//弹出页面框
		$('#LayerEditTodo').show();     
	    $HUI.dialog('#LayerEditTodo', {
	        title: "设置待处理事项",
	        iconCls: 'icon-w-paper',
	        modal: true,
	        isTopZindex: true
	    });
	})
	//***保存事件
	$('#btnTodoSave').on('click', function () {
		var TodoList =$('#cboTodo').combobox('getValues');	//List
		var aTodo="";
		for(var ind=0;ind<TodoList.length;ind++){
			if(ind==TodoList.length-1){
				var aTodo=aTodo+TodoList[ind];
			}
			else{
				var aTodo=aTodo+TodoList[ind]+',';
			}
		}
		if(aTodo=="")aTodo="Empty";	//为空设置值(区分第一次打开)
		var flg = $m({
            ClassName: "DHCHAI.BT.SysUser",
            MethodName: "UpdateControlByID",
            aType:1,
            aID: $.LOGON.USERID,
            aControl:aTodo
       	 }, false);
       	 if (parseInt(flg) <= 0){
			$.messager.alert("错误提示", "保存失败!" , 'info');
		 } 
		 else {
		 	$HUI.dialog('#LayerEditTodo').close();
		 	$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
		    LoadToDoList();			//刷新待处理事项
		}
	});
    //***关闭事件
	$('#btnTodoClose').on('click', function () {
		$HUI.dialog('#LayerEditTodo').close();
	});
}

// 菜单跳转
function OpenMenu(menuCode,menuDesc,menuUrl) {
	var strUrl = '../csp/'+menuUrl+'?+&1=1';
	if ("undefined" !==typeof websys_getMWToken) {
		strUrl  += "&MWToken="+websys_getMWToken();
	}
	//主菜单
	var data = [{
		"menuId": "",
		"menuCode": menuCode,
		"menuDesc": menuDesc,
		"menuResource": strUrl,
		"menuOrder": "1",
		"menuIcon": "icon"
	}];
	if( typeof window.parent.showNavTab === 'function' ){   //bootstrap 版本
		window.parent.showNavTab(data[0]['menuCode'], data[0]['menuDesc'], data[0]['menuResource'], data[0]['menuCode'], data[0]['menuIcon'], false);
	}else{ //HISUI 版本
		window.parent.addTab({
			url:strUrl,
			title:menuDesc
		});
	}
}
//2->加载全院概况
function LoadToHosp(){
	//显示(隐藏)全院概况
	$m({
   		ClassName: "DHCHAI.BT.SysUser",
		MethodName: "GetControlByID",
		aType:2,
		aID: $.LOGON.USERID
	}, function(Data){
		var ControlData="";
		if (Data!="") {
			if(ControlData=="Empty"){
		 		ControlData="";
		 	}
		 	else{
				ControlData=Data;
			}
		}else {
			//未设置时'默认加载所有'
			ControlData="NewPatDiv,AdmPatDiv,DischPatDiv,FeverPatDiv,PICCPatDiv,VAPPatDiv,UCPatDiv,AntPatDiv,OperPatDiv";
		}
		var ControlList="NewPatDiv,AdmPatDiv,DischPatDiv,FeverPatDiv,PICCPatDiv,VAPPatDiv,UCPatDiv,AntPatDiv,OperPatDiv";
		for(var ind=0;ind<ControlList.split(",").length;ind++){
			var Control=ControlList.split(",")[ind];
			if(ControlData.indexOf(Control)>=0){
				$('#'+Control).show();			//显示
			}
			else{
				$('#'+Control).hide();			//隐藏
			}
		}
	});
	//->加载具体数据
	$cm({                  
		ClassName:"DHCHAI.STAS.WelcomeSrv",
		QueryName:"QryHospSurvey",
		aHospIDs:HospAllIdsM
	}, function(jsonData){
		if (jsonData.total>0){
			var HospSurvey=jsonData.rows[0];
			
			$('#NewPatCnt').html(HospSurvey.NewPatCnt);			//新入院
			$('#AdmPatCnt').html(HospSurvey.AdmPatCnt);			//在院
			$('#FeverPatCnt').html(HospSurvey.FeverPatCnt);		//发热
			$('#PICCPatCnt').html(HospSurvey.PICCPatCnt);		//中心静脉
			$('#VAPPatCnt').html(HospSurvey.VAPPatCnt);			//呼吸机
			$('#UCPatCnt').html(HospSurvey.UCPatCnt);			//泌尿道插管
			$('#AntPatCnt').html(HospSurvey.AntPatCnt);			//抗菌药物
			$('#OperPatCnt').html(HospSurvey.OperPatCnt);		//手术
			$('#DischPatCnt').html(HospSurvey.DischPatCnt);		//死亡|出院
		}
	})
	/***设置页签显示[全院概况]***/
	//***点击设置图标
	$('.icon-hosp-install').click(function(){
		//初始化下拉菜单
		var cboHosp = $HUI.combobox("#cboHosp",{
			valueField:'id',
			textField:'text',
			multiple:true,
			rowStyle:'checkbox', //显示成勾选行形式
			selectOnNavigation:false,
			editable:false,
			data:[
				{id:'NewPatDiv',text:'新入院人数'},
				{id:'AdmPatDiv',text:'在院人数'},
				{id:'DischPatDiv',text:'死亡/出院'},
				{id:'FeverPatDiv',text:'发热人数'},
				{id:'PICCPatDiv',text:'中心静脉'},
				{id:'VAPPatDiv',text:'呼吸机'},
				{id:'UCPatDiv',text:'泌尿道插管'},
				{id:'AntPatDiv',text:'抗菌药物'},
				{id:'OperPatDiv',text:'手术'}
			]
		});
		//加载下拉菜单(设置值)
	    var ControlData = $m({
            ClassName: "DHCHAI.BT.SysUser",
            MethodName: "GetControlByID",
            aType:2,
            aID: $.LOGON.USERID
       	}, false);
       	if(ControlData=="Empty")ControlData="";
       	var ControlList=[];
       	for(var ind=0;ind<ControlData.split(",").length;ind++){
	        var Control=ControlData.split(",")[ind];
	       	ControlList.push(Control);
	    }
	    $('#cboHosp').combobox("setValues",ControlList);
		//弹出框
		$('#LayerEditHosp').show();     
	    $HUI.dialog('#LayerEditHosp', {
	        title: "设置全院概况",
	        iconCls: 'icon-w-paper',
	        modal: true,
	        isTopZindex: true
	    });
	})
	//***保存事件
	$('#btnHospSave').on('click', function () {
		var HospList =$('#cboHosp').combobox('getValues');		//List
		var aHosp="";
		for(var ind=0;ind<HospList.length;ind++){
			if(ind==HospList.length-1){
				var aHosp=aHosp+HospList[ind];
			}
			else{
				var aHosp=aHosp+HospList[ind]+',';
			}
		}
		if(aHosp=="")aHosp="Empty";	//为空设置值(区分第一次打开)
		var flg = $m({
            ClassName: "DHCHAI.BT.SysUser",
            MethodName: "UpdateControlByID",
            aType:2,
            aID: $.LOGON.USERID,
            aControl:aHosp
       	 }, false);
       	 if (parseInt(flg) <= 0){
			$.messager.alert("错误提示", "保存失败!" , 'info');
		 } 
		 else {
		 	$HUI.dialog('#LayerEditHosp').close();
		 	$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
		    LoadToHosp();				//刷新页签
		}
	});
    //关闭全院概况设置
	$('#btnHospClose').on('click', function () {
		$HUI.dialog('#LayerEditHosp').close();
	});
	//点击全院概况
	function btnOpenHospSurvey(){
		OpenMenu("DHCHAIInf-HospSurvey","全院概况","dhcma.hai.ir.hospsurvey.csp");
	}
}
//3.加载统计饼状图(医院感染部位+多耐检出+暴露工作类别+检出合格率+手卫生依从率)
function LoadToChart_1(){
	var nowdate = new Date();
	var y = nowdate.getFullYear();
    var m = nowdate.getMonth()+1;
    var d = nowdate.getDate();
    var DateTo   = y+'-'+m+'-'+d;
    var DateFrom = y+'-'+"01"+'-'+"01";
	//->加载'医院感染部位分布'统计图
	//->*处理数据,加载图表
	function echartInfPosRatio(runQuery){
		var valbox = $HUI.panel("#DivInfPos",{
			title:"医院感染部位分布 Top5"+"&nbsp"+"&nbsp"+"&nbsp"+"&nbsp"+"&nbsp"+"&nbsp"+"&nbsp"+y+"年",
			headerCls:'panel-header-gray'
		});
			
		if (!runQuery.total) return;
		var arrPosDesc		= new Array();			//感染部位
		var arrInfPosCnt  	= new Array();  		//感染部位例数
		arrRecord 			= runQuery.rows;
		
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			arrInfPosCnt.push(rd["InfDiagCnt"]);	//加载诊断数据
			arrPosDesc.push(rd["PosDesc"]);			//加载感染部位-临时
		}
		//降序排序
		SortJson(arrInfPosCnt,arrPosDesc);
		
		var arrLegend = arrPosDesc;
		option = {
		    tooltip: {
		        trigger: 'item',
		        formatter: '{a}:<br/>{b}<br/> {c}例 ({d}%)',
		        position:["10%","5%"],
		        /*position:function(p){ //其中p为当前鼠标的位置
					return [p[0]-60 , p[1]-44];
				},*/
		        extraCssText:'width:120px;height:60px;font-Size:10px;'
		    },
		    legend: {
		        orient: 'vertical',
		        x: 'left',
                y: 'bottom',
		        textStyle: { 
		        	fontSize: 10
		        },

		        data: arrLegend
		    },
		    series: [
		        {
		            name: '感染部位',
		            type: 'pie',
		            radius: ['55%', '75%'],
		            center: ['65%','50%'],
		            itemStyle : {
		                normal : {
		                    label : {
		                        show : false   //隐藏标示文字
		                    },
		                    labelLine : {
		                        show : false   //隐藏标示线
		                    }
		                }
		            },
		            data: (function(){
				        var arr=[];
				       	for (var i = 0; i < 5; i++) {	
 							arr.push({"value": arrInfPosCnt[i],"name":arrPosDesc[i]});
						}
						return arr;  
				     })(),
		        },
		    ]
		};
		// 使用刚指定的配置项和数据显示图表。
		myChart_1.setOption(option);
		function OpenReport(){
			OpenMenu("DHCHAIInf-s390infpos","住院患者医院感染部位分布","dhcma.hai.statv2.s390infpos.csp");
		}
		$('#DivInfPos').on("click", OpenReport);
	}
	//->*定义
	var myChart_1 = echarts.init(document.getElementById('EchartDivInfPos'));
	myChart_1.showLoading();		//'加载中'提示
	//->*加载后台数据
	$cm({
   		ClassName: "DHCHAI.STATV2.S390InfPos",
		QueryName: "QryInPosInF",
		aHospIDs:HospAllIdsM,
		aDateFrom:DateFrom,
		aDateTo:DateTo,
		aLocType:"W",
		page: 1,
		rows: 999
	}, function(jsonData){
		if (jsonData!=""){
			myChart_1.hideLoading();  //关闭'加载中'提示
			
			var cnt = jsonData.total;
			echartInfPosRatio(jsonData);
			if (cnt==0) {
				$('#EchartDivInfPos').addClass('no-result');	//无数据加载'无数据'图片
			}
		}
	});
	
	//->加载'多重耐药菌检出分布'统计图
	//->*处理数据,加载图表
	function echartMbrPosSrv(runQuery){
		var valbox = $HUI.panel("#DivMrbPos",{
			title:"多重耐药菌检出分布"+"&nbsp"+"&nbsp"+"&nbsp"+" "+"&nbsp"+"&nbsp"+"&nbsp"+"&nbsp"+"&nbsp"+"&nbsp"+"&nbsp"+"&nbsp"+y+"年",
			headerCls:'panel-header-gray'
		});
		
		if (!runQuery.total) return;
		var arrMRSA		= new Array();
		var arrCRE		= new Array();
		var arrVRE		= new Array();
		var arrCRAB		= new Array();
		var arrCRPA		= new Array();
		var arrRecord 	= runQuery.rows;
		
		var rd = arrRecord[0];
		arrMRSA.push(rd["MRSAPatCase"]);
		arrCRE.push(rd["CREPatCase"]);
		arrVRE.push(rd["VREPatCase"]);
		arrCRAB.push(rd["CRABPatCase"]);
		arrCRPA.push(rd["CEPAPatCase"]);
		
		option = {
		    tooltip: {
		        trigger: 'item',
		        formatter: '{a}:{b}<br/>{c} 例 ({d}%)',
		        
		        position:function(p){ //其中p为当前鼠标的位置
					return [p[0]-60 , p[1]-30];
				},
		        extraCssText:'width:90px;height:40px;font-Size:10px;'
		    },
		    legend: {
		        orient: 'vertical',
		        x: 'left',
                y: 'bottom',
		        textStyle: { 
		        	fontSize: 10
		        },

		        data: ['MRSA', 'CRE', 'VRE', 'CRAB', 'CRPA'],
		    },
		    series: [
		        {
		            name: '多耐细菌',
		            type: 'pie',
		            radius: ['55%', '75%'],
		            center: ['65%','50%'],
		            itemStyle : {
		                normal : {
		                    label : {
		                        show : false   //隐藏标示文字
		                    },
		                    labelLine : {
		                        show : false   //隐藏标示线
		                    }
		                }
		            },
		            data: [
		             	{ value: arrMRSA, name: 'MRSA' },
		             	{ value: arrCRE, name: 'CRE' },
		             	{ value: arrVRE, name: 'VRE' },
		             	{ value: arrCRAB, name: 'CRAB' },
		             	{ value: arrCRPA, name: 'CRPA' },
		           	]
		        }
		    ]
		};
		// 使用刚指定的配置项和数据显示图表。
		myChart_2.setOption(option);
		function OpenReport(){
			OpenMenu("DHCHAIInf-star005","多重耐药菌检出分布表","dhcma.hai.statv2.s050mrbpos.csp");
		}
		$('#DivMrbPos').on("click", OpenReport);
	}
	//->*定义
	var myChart_2 = echarts.init(document.getElementById('EchartDivMrbPos'));
	myChart_2.showLoading();			//'加载中'提示
	//->*加载后台数据
	$cm({
   		ClassName: "DHCHAI.STAS.WelcomeSrv",
		QueryName: "QryMRBPos",
		aHospIDs:HospAllIdsM,
		aDateFrom:DateFrom,
		aDateTo:DateTo,
		aStaType:"W",
		page: 1,
		rows: 999
	}, function(jsonData){
		if (jsonData!=""){
			myChart_2.hideLoading();  //关闭'加载中'提示
			
			var cnt = jsonData.total;
			echartMbrPosSrv(jsonData);
			if (cnt==0) {
				$('#EchartDivMrbPos').addClass('no-result');	//无数据加载'无数据'图片
			}
		}
	});
	//->加载'职业暴露工作类别分布'统计图
	//->*处理数据,加载图表
	function echartOccRepStaSrv(runQuery){
		var valbox = $HUI.panel("#DivOccRep",{
			title:"职业暴露工作类别分布Top5"+"&nbsp"+y+"年",
			headerCls:'panel-header-gray'
		});
				
		if (!runQuery.total) return;
		var arrResultDesc 	= new Array();
		var arrResultCnt 	= new Array();
		var arrRecord 		= runQuery.rows;
		
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			rd["ResultDesc"]    = $.trim(rd["ResultDesc"]); //去掉空格
		}
		for (var indRd = 0; indRd < arrRecord.length; indRd++){                     
			var rd = arrRecord[indRd];
			if(rd==undefined){   //去掉全院、医院、科室组后,会有数据变为undefined
				continue;
			}else{
				
				arrResultDesc.push(rd["ResultDesc"]);
				arrResultCnt.push(rd["ResultCount"]);
			}
		}
		//降序排序
		SortJson(arrResultCnt,arrResultDesc);
		
		var arrLegend = arrResultDesc;
		option = {
		    tooltip: {
		        trigger: 'item',
		        formatter: '{a}:{b}<br/>{c} ({d}%)',
		       
		        position:function(p){ //其中p为当前鼠标的位置
					return [p[0]-60 , p[1]-30];
				},
		        extraCssText:'width:120px;height:40px;font-Size:10px;'
		    },
		    legend: {
		        orient: 'vertical',
		        x: 'left',
                y: 'bottom',
		        textStyle: { 
		        	fontSize: 10
		        },

		        data: arrLegend
		    },
		    series: [
		        {
		            name: "职别",
		            type: 'pie',
		            radius: ['55%', '75%'],
		            center: ['65%','50%'],
		            itemStyle : {
		                normal : {
		                    label : {
		                        show : false   //隐藏标示文字
		                    },
		                    labelLine : {
		                        show : false   //隐藏标示线
		                    }
		                }
		            },
		            data: (function(){
				        var arr=[];
				       	for (var i = 0; i < 5; i++) {	
 							arr.push({"value": arrResultCnt[i],"name":arrResultDesc[i]});
						}
						return arr;  
				     })(),
		        }
		    ]
		};
		// 使用刚指定的配置项和数据显示图表。
		myChart_3.setOption(option);
		function OpenReport(){
			OpenMenu("DHCHAIInf-occrepsta","职业暴露例数统计表","dhcma.hai.statv2.occrepsta.csp");
		}
		$('#DivOccRep').on("click", OpenReport);
	}
	//->*定义
	var myChart_3 = echarts.init(document.getElementById('EcharDivOccRep'));
	myChart_3.showLoading();			//'加载中'提示
	//->*加载后台数据
	$cm({
   		ClassName: "DHCHAI.STAS.WelcomeSrv",
		QueryName: "QryOccExpReg",
		aHospIDs:HospAllIdsM,
		aDateFrom:DateFrom,
		aDateTo:DateTo
	}, function(jsonData){
		if (jsonData!=""){
			myChart_3.hideLoading();  //关闭'加载中'提示
			
			var cnt = jsonData.total;
			echartOccRepStaSrv(jsonData);
			if (cnt==0) {
				$('#EcharDivOccRep').addClass('no-result');	//无数据加载'无数据'图片
			}
		}
	});
	//->加载'环境卫生学监测合格率'统计图
	//->*处理数据,加载图表
	function echartEnvHyRatio(runQuery){
		var valbox = $HUI.panel("#DivEnvHy",{
			title:"环境卫生学监测合格率 Top5"+"&nbsp"+"&nbsp"+"&nbsp"+m+"月",
			headerCls:'panel-header-gray'
		});
		
		if (!runQuery.total) return;
		var arrViewLoc = new Array();
		var arrInfRatio = new Array();
		var arrInfCount = new Array();
		var arrEvReportCntt = new Array();
		
		obj.arrLocG= new Array();
		var arrRecord = runQuery.rows;
		
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			rd["LocDesc"] = $.trim(rd["LocDesc"]); //去掉空格
		}
		
		for (var indRd = 0; indRd < arrRecord.length; indRd++){                     
			var rd = arrRecord[indRd];
			if(rd==undefined){   //去掉全院、医院、科室组后,会有数据变为undefined
				continue;
			}else{
				arrViewLoc.push(rd["LocDesc"]);
				arrInfCount.push(rd["StandardCnt"]);
				arrEvReportCntt.push(rd["EvReportCnt"]);
				arrInfRatio.push(parseFloat(rd["StandardRatio"]).toFixed(2));
			}
		}
		var arrInfRatio = arrInfRatio.sort(function (a,b){ return a-b });		// 排序
		var arrInfRatio = arrInfRatio.reverse();	// 从大到小排序
		var arrLegend = arrViewLoc;
		option = {
		    tooltip: {
		        trigger: 'item',
		        formatter: '{a}:{b}<br/>合格率:{c} %',
		       	position:["20%","20%"],
		       /* position:function(p){ //其中p为当前鼠标的位置
					return [p[0]-80 , p[1]-30];
				},*/
		        extraCssText:'width:120px;height:40px;font-Size:10px;'
		    },
		    legend: {
		        orient: 'vertical',
		        x: 'left',
                y: 'bottom',
		        textStyle: { 
		        	fontSize: 10
		        },

		        data: arrLegend
		    },
		    series: [
		        {
		            name: "监测科室",
		            type: 'pie',
		            radius: ['55%', '75%'],
		            center: ['65%','50%'],
		            itemStyle : {
		                normal : {
		                    label : {
		                        show : false   //隐藏标示文字
		                    },
		                    labelLine : {
		                        show : false   //隐藏标示线
		                    }
		                }
		            },
		            data: (function(){
				        var arr=[];
				       	for (var i = 0; i < 5; i++) {	
 							arr.push({"value": arrInfRatio[i],"name":arrViewLoc[i]});
						}
						return arr;  
				     })(),
		        }
		    ]
		};
		// 使用刚指定的配置项和数据显示图表。
		myChart_4.setOption(option);
		function OpenReport(){
			OpenMenu("DHCHAIInf-s470envhyqua","环境卫生学监测合格率统计表","dhcma.hai.statv2.s470envhyqua.csp");
		}
		$('#DivEnvHy').on("click", OpenReport);
	}
	//->*定义
	var myChart_4 = echarts.init(document.getElementById('EchartDivEnvHy'));
	myChart_4.showLoading();		//'加载中'提示
	//->*加载后台数据
	var NowDateFrom = y+'-'+m+'-'+"01";		//本月第一天
    var NowDateTo   = y+'-'+m+'-'+d;		//当前日期
	$cm({
   		ClassName: "DHCHAI.STATV2.S470EnvHyQua",
		QueryName: "QryEnvHyQua",
		aHospIDs:HospAllIdsM,
		aDateFrom:NowDateFrom,
		aDateTo:NowDateTo
	}, function(jsonData){
		if (jsonData!=""){
			myChart_4.hideLoading();  //关闭'加载中'提示
			
			var cnt = jsonData.total;
			echartEnvHyRatio(jsonData);
			if (cnt==0) {
				$('#EchartDivEnvHy').addClass('no-result');	//无数据加载'无数据'图片
			}
		}
	});
	//->加载'手卫生依从率'统计图
	//->*处理数据,加载图表
	function echartHandHyReg(runQuery){
		var valbox = $HUI.panel("#HandHyCom",{
			title:"手卫生依从率 Top5"+"&nbsp"+"&nbsp"+"&nbsp"+"&nbsp"+"&nbsp"+"&nbsp"+"&nbsp"+"&nbsp"+"&nbsp"+"&nbsp"+"&nbsp"+"&nbsp"+y+"年",
			headerCls:'panel-header-gray'
		});		
		if (!runQuery.total) return;
		var arrViewLoc 			= new Array();
		var arrCorrectCount 	= new Array();		//洗手正确数
		var arrCorrectRatio 	= new Array();		//正确率
		var arrCompRatio		= new Array();
		arrRecord 		= runQuery.rows;
		
		var arrlength		= 0;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			//去掉全院、医院、科室组
			if (rd["DimensKey"].indexOf('全院')>-1) {
				delete arrRecord[indRd];
				arrlength = arrlength + 1;
				continue;
			}
			rd["DimensDesc"]	= $.trim(rd["DimensDesc"]); //去掉空格
			rd["CorrectRatio"]	= parseFloat(rd["CorrectRatio"].replace('%','').replace('‰','')).toFixed(2);
			rd["CompRatio"]	= parseFloat(rd["CompRatio"].replace('%','').replace('‰','')).toFixed(2);
		}
		arrRecord = arrRecord.sort(obj.up);
		arrRecord.length = arrRecord.length - arrlength;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			
			arrViewLoc.push(rd["DimensDesc"]);
			var HandCount = rd["HandCount"];
			var SoapCount = rd["SoapCount"];
			var CorrectCount = +HandCount + +SoapCount;
			var CorrectCount = CorrectCount.toString();
			arrCorrectCount.push(CorrectCount);
			arrCorrectRatio.push(parseFloat(rd["CorrectRatio"]).toFixed(2));
			arrCompRatio.push(parseFloat(rd["CompRatio"]).toFixed(2));
		}
		
		//排序
		SortJson(arrCompRatio,arrViewLoc);
		
		var endnumber = (14/arrViewLoc.length)*100;
		var arrLegend = arrViewLoc;
		option = {
		    tooltip: {
		        trigger: 'item',
		        /*formatter:function(data){
			        console.log(data);
              		return data.seriesName + "<br/>"+ data.name+ " : " + data.value + " ("+data.percent.toFixed(1)+"%)";
                },*/
		        formatter: '{a}:{b}<br/> 手卫生依从率:  {c}%',
		       	position:["5%","20%"],
		        /*position:function(p){ //其中p为当前鼠标的位置
					return [p[0]-80 , p[1]-40];
				},*/
		        extraCssText:'width:130px;height:40px;font-Size:8px;'
		    },
		    legend: {
		        orient: 'vertical',
		        x: 'left',
                y: 'bottom',
		        textStyle: { 
		        	fontSize: 10
		        },
		        data: arrLegend
		    },
		    series: [
		        {
		            name: "科室",
		            type: 'pie',
		            radius: ['50%', '75%'],
		            center: ['65%','50%'],
		            avoidLabelOverlap: false,
		            itemStyle : {
		                normal : {
		                    label : {
		                        show : false   //隐藏标示文字
		                    },
		                    labelLine : {
		                        show : false   //隐藏标示线
		                    }
		                }
		            },
		            data: (function(){
				        var arr=[];
				       	for (var i = 0; i < 5; i++) {	
 							arr.push({"value": arrCompRatio[i],"name":arrViewLoc[i]});
						}
						return arr;  
						
				     })(),
		        }
		    ]
		},
		// 使用刚指定的配置项和数据显示图表。
		myChart_5.setOption(option);
		
		function OpenReport(){
			OpenMenu("DHCHAIInf-s380handhycom","医务人员手卫生依从率统计表","dhcma.hai.statv2.s380handhycom.csp");
		}
		$('#HandHyCom').on("click", OpenReport);
	}
	//->*定义
	var myChart_5 = echarts.init(document.getElementById('EchartHandHyCom'));
	myChart_5.showLoading();		//'加载中'提示
	//->*加载后台数据
	$cm({
   		ClassName: "DHCHAI.STATV2.S380HandHyCom",
		QueryName: "QryHandHyRegSta",
		aHospIDs:HospAllIdsM,
		aDateFrom:DateFrom,
		aDateTo:DateTo,
		page: 1,
		rows: 999
	}, function(jsonData){
		if (jsonData!=""){
			myChart_5.hideLoading();  //关闭'加载中'提示
			
			var cnt = jsonData.total;
			echartHandHyReg(jsonData);
			if (cnt==0) {
				$('#EchartHandHyCom').addClass('no-result');	//无数据加载'无数据'图片
			}
		}
	});
}
//4.加载统计柱状图(感染发病率+现患率+三天发热+多耐菌分布)
function LoadToChart_2(){
	//->加载'当月科室感染发病率'统计图
	//->*处理数据,加载图表
	function echartLocInfRatio(runQuery){
		if (!runQuery) return;
		var arrViewLoc = new Array();
		var arrInfRatio = new Array();
		var arrRecord = runQuery.rows;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			arrViewLoc.push(rd["LocDesc"]);
			arrInfRatio.push(parseFloat(rd["InfRatio"]).toFixed(2));
		}
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
		myChart_6.setOption(option);
		function OpenReport(){
			OpenMenu("DHCHAIInf-s010inf","住院患者医院感染（例次）发病率统计表","dhcma.hai.statv2.s010inf.csp");
		}
		$('#LocInfRatio').on("click", OpenReport);
	}
	// 使用刚指定的配置项和数据显示图表。
	var myChart_6 = echarts.init(document.getElementById('divLocInfRatio'));
	myChart_6.showLoading();		//'加载中'提示
	//->*加载后台数据
	$cm({
   		ClassName: "DHCHAI.STAS.WelcomeSrv",
		QueryName: "QryLocInfRatio",
		aLocID:$.LOGON.LOCID
	}, function(jsonData){
		if (jsonData!=""){
			myChart_6.hideLoading();  //关闭'加载中'提示
			
			echartLocInfRatio(jsonData);
		}
	});
	//->加载'全院现患率情况'统计图
	//->*处理数据,加载图表
	function echartHospPrevRatio(runQuery){
		if (!runQuery) return;
		var arrViewTitle = new Array();
		var arrInfPatCnt = new Array();
		var arrRecord = runQuery.rows;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			arrViewTitle.push(rd["PrevDate"]);
			arrInfPatCnt.push(parseFloat(rd["PrevRatio"]).toFixed(2));
		}
		
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
		myChart_7.setOption(option);
		function OpenReport(){
			OpenMenu("DHCHAIInf-s030infpre","医院感染（例次）现患率统计表","dhcma.hai.statv2.s030infpre.csp");
		}
		$('#HospPrevRatio').on("click", OpenReport);
	}
	//->*定义
	var myChart_7 = echarts.init(document.getElementById('divHospPrevRatio'));
	myChart_7.showLoading();		//'加载中'提示
	//->*加载后台数据
	$cm({
   		ClassName: "DHCHAI.STAS.WelcomeSrv",
		QueryName: "QryHospPrevRatio",
		aLocID:$.LOGON.LOCID
	}, function(jsonData){
		if (jsonData!=""){
			myChart_7.hideLoading();  //关闭'加载中'提示
			
			echartHospPrevRatio(jsonData);
		}
	});
	//->加载'科室近三天发热人数变化'统计图
	//->*处理数据,加载图表
	function echartLocFeverChange(runQuery){
		if (!runQuery) return;
		var arrViewLoc2 = new Array();
		var arrFeverNumber2 = new Array();
		var arrFeverNumber3 = new Array();
		var arrRecord = runQuery.rows;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			arrViewLoc2.push(rd["LocDesc"]);
			arrFeverNumber2.push(parseFloat(rd["ChainFeverNumber"]));
			arrFeverNumber3.push(parseFloat(rd["FeverNumber"]));
		}
		var colors = ['#5793f3', '#d14a61'];
		
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
		myChart_8.setOption(option);
		function OpenReport(){
			OpenMenu("DHCHAIInf-ccwarning","感染暴发预警","dhcma.hai.ir.ccwarning.csp");
		}
		$('#FeverNum').on("click", OpenReport);
	}
	//->*定义
	var myChart_8 = echarts.init(document.getElementById('divFeverNum1'));
	myChart_8.showLoading();		//'加载中'提示
	//->*加载后台数据
	$cm({
   		ClassName: "DHCHAI.STAS.WelcomeSrv",
		QueryName: "QryLocFeverChange",
		aLocID:$.LOGON.LOCID,
		page: 1,
		rows: 999
	}, function(jsonData){
		if (jsonData!=""){
			myChart_8.hideLoading();  //关闭'加载中'提示
			
			echartLocFeverChange(jsonData);
		}
	});
	//->2.点击'科室','环比'
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
	//->加载'当月多重耐药菌分布'统计图
	//->*处理数据,加载图表
	function echartLocMBRRatio(runQuery){
		if (!runQuery) return;
		var arrLocDesc = new Array();
		var arrMBRRatio = new Array();
		var arrRecord = runQuery.rows;
		for (var indRd = 0; indRd < arrRecord.length; indRd++){
			var rd = arrRecord[indRd];
			arrLocDesc.push(rd["LocDesc"]);
			arrMBRRatio.push(parseFloat(rd["MBRRatio"]).toFixed(2));
		}
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
		myChart_9.setOption(option);
		function OpenReport(){
			OpenMenu("DHCHAIInf-statv2star005","多重耐药菌检出分布表","dhcma.hai.statv2.star005.csp");
		}
		$('#divBacteria').on("click", OpenReport);
	}
	//->*定义
	var myChart_9 = echarts.init(document.getElementById('divBacteria0'));
	myChart_9.showLoading();		//'加载中'提示
	//->*加载后台数据
	$cm({
   		ClassName: "DHCHAI.STAS.WelcomeSrv",
		QueryName: "QryLocMBRRatio",
		aLocID:$.LOGON.LOCID
	}, function(jsonData){
		if (jsonData!=""){
			myChart_9.hideLoading();  //关闭'加载中'提示
			
			echartLocMBRRatio(jsonData);
		}
	});
	//->2.点击'科室','菌种'
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
}
    
function LoadFeverFever() {	
	//科室发热人数图表(科室)
	$cm({
		ClassName:"DHCHAI.STAS.WelcomeSrv",
		QueryName:"QryLocFeverNumber",
		aLocID:$.LOGON.LOCID,
		page: 1,
		rows: 999
	},function(rs){
		echartLocFeverNumber(rs);
	});
	
	function echartLocFeverNumber(runQuery){
		if (!runQuery) return;
		var arrViewLoc = new Array();
		var arrFeverNumber = new Array();
		var arrRecord = runQuery.rows;
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
	$cm({
		ClassName:"DHCHAI.STAS.WelcomeSrv",
		QueryName:"QryBactMBRRatio",
		aLocID:$.LOGON.LOCID,
		page: 1,
		rows: 999
	},function(rs){
		echartBactMBRRatio(rs);
	});

	function echartBactMBRRatio(runQuery){
		if (!runQuery) return;
		var arrMBRLocDesc2 = new Array();
		var arrMBRRatio2 = new Array();
		var arrRecord = runQuery.rows;
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
//数组排序 
function SortJson(Json1,Json2){
	//对JSON1进行排序--冒泡排序
	for(var ind=0;ind<Json1.length;ind++){
		for(var jnd=0;jnd<Json1.length-ind;jnd++){
			var temp1=Json1[jnd];
			var temp2=Json2[jnd];
			
			if(Json1[jnd-1]<Json1[jnd]){
				Json1[jnd]=Json1[jnd-1]
				Json1[jnd-1]=temp1
				//同步更新JSON2
				Json2[jnd]=Json2[jnd-1]
				Json2[jnd-1]=temp2
			}
		}
	}
}
//->点击[新报告审核]
function btnUnCheck_Click(){
	var num=$("#cntInfRep").text();
	if (num) {
		var url="dhcma.hai.main.welcome.link.csp?1=1&TypeCode=4&Days="+InfRepDay;
		websys_showModal({
			url:url,
			title:'当前'+InfRepDay+'日内感染报告待审核记录',
			iconCls:'icon-w-epr',  
			width:'98%',
			height:'98%',
			onBeforeClose:function(){
				LoadToDoList();  //刷新代办事项
			} 
		});
	}else {
		$.messager.popover({msg: '无数据需展示！',type:'success',timeout: 1000});
	}
}
//->点击[疑似未处理]
function btnUnTreated_Click(){
	var num=$("#cntInfScreen").text();
		if (num) {
		var url="dhcma.hai.ir.ccscreening.csp?1=1";
		websys_showModal({
			url:url,
			title:'疑似未处理',
			iconCls:'icon-w-epr',  
			width:'98%',
			height:'98%',
			onBeforeClose:function(){
				LoadToDoList();  //刷新代办事项
			} 
		});
	}else {
		$.messager.popover({msg: '无数据需展示！',type:'success',timeout: 1000});
	}
}
//->点击[确诊未上报]
function btnInfNoRep_Click(){
	var num=$("#cntInfNoRep").text();
	if (num) {
		var url="dhcma.hai.ir.norepscreening.csp?1=1";	
		websys_showModal({
			url:url,
			title:'当前在院及出院'+InfNoRepDay+'日内疑似已确诊未报告感染报告病例',
			iconCls:'icon-w-epr',  
			width:'98%',
			height:'98%',
			onBeforeClose:function(){
				LoadToDoList();  //刷新代办事项
			} 
		});
	}else {
		$.messager.popover({msg: '无数据需展示！',type:'success',timeout: 1000});
	}
}

//->点击[暴发预警科室]
function btnWarnLoc_Click(){
	var num=$("#cntWarnLoc").text();
	if (num) {
		OpenMenu("DHCHAIInf-CCWarning","感染暴发预警","dhcma.hai.ir.ccwarning.csp");
	
	}else {
		$.messager.popover({msg: '无预警科室需展示！',type:'success',timeout: 1000});
	}
}
//->点击[多重耐药菌]
function btnInfMrb_Click(){
	var num=$("#cntInfMrb").text();
	if (num) {
		var url="dhcma.hai.main.welcome.link.csp?1=1&TypeCode=5&Days="+InfMrbDay;
		websys_showModal({
			url:url,
			title:'当前'+InfMrbDay+'日内报告多重耐药菌记录',
			iconCls:'icon-w-epr',  
			width:'98%',
			height:'98%',
			onBeforeClose:function(){
				LoadToDoList();  //刷新代办事项
			} 
		});
	}else {
		$.messager.popover({msg: '无数据需展示！',type:'success',timeout: 1000});
	}
}

//->点击[抗菌药物连续使用]
function btnAntUseOver_Click(){
	var num=$("#cntAntUse").text();
	if (num) {
		var url="dhcma.hai.main.welcome.link.csp?1=1&TypeCode=6&Days="+OverDays;	
		websys_showModal({
			url:url,
			title:'连续使用抗菌药物超过'+OverDays+'天在院患者',
			iconCls:'icon-w-epr',  
			width:'98%',
			height:'98%',
			onBeforeClose:function(){
				LoadToDoList();  //刷新代办事项
			} 
		});
	}else {
		$.messager.popover({msg: '无数据需展示！',type:'success',timeout: 1000});
	}
}
//->点击[待审职业暴露]
function btnRegCheck_Click(){
	var num=$("#cntCheck").text();
	if (num) {
		var url="dhcma.hai.main.welcome.link.csp?1=1&TypeCode=1";
		websys_showModal({
			url:url,
			title:'当前职业暴露报告待审核记录',
			iconCls:'icon-w-epr',  
			width:'98%',
			height:'98%',
			onBeforeClose:function(){
				LoadToDoList();  //刷新代办事项
			} 
		});
	}else {
		$.messager.popover({msg: '无数据需展示！',type:'success',timeout: 1000});
	}
}
//->点击[环境卫生学提醒]
function btnRegRemind_Click(){
	var num=$("#cntRemind").text();
	if (num) {
		var url="dhcma.hai.main.welcome.link.csp?1=1&TypeCode=2";
		websys_showModal({
			url:url,
			title:'当前'+RemindFromDay+'日内及'+RemindToDay+'日后内需提醒职业暴露检查记录',
			iconCls:'icon-w-epr',  
			width:'98%',
			height:'98%',
			onBeforeClose:function(){
				LoadToDoList();  //刷新代办事项
			} 
		});
	}else {
		$.messager.popover({msg: '无数据需展示！',type:'success',timeout: 1000});
	}
}
//->点击[环境卫生学未监测]
function btnEntMissRemind_Click(){
	var num=$("#cntentMissRemind").text();
	if (num) {
		var url="dhcma.hai.main.welcome.link.csp?1=1&TypeCode=31";
		websys_showModal({
			url:url,
			title:'环境卫生学未监测明细',
			iconCls:'icon-w-epr',  
			width:'98%',
			height:'98%',
			onBeforeClose:function(){
				LoadToDoList();  //刷新代办事项
			} 
		});
	}else {
		$.messager.popover({msg: '无数据需展示！',type:'success',timeout: 1000});
	}
}
//->点击[环境卫生学漏监测]
function btnEntRemind_Click(){
	var num=$("#cntentRemind").text();
	if (num) {
		var url="dhcma.hai.main.welcome.link.csp?1=1&TypeCode=3";
		websys_showModal({
			url:url,
			title:'当前7日内环境卫生学监测报告不合格记录',
			iconCls:'icon-w-epr',  
			width:'98%',
			height:'98%',
			onBeforeClose:function(){
				LoadToDoList();  //刷新代办事项
			} 
		});
	}else {
		$.messager.popover({msg: '无数据需展示！',type:'success',timeout: 1000});
	}
}
//->点击[未读消息]
function btnUnReadMsg_Click(){
	var num=$("#cntUnReadMsg").text();
	if (num) {
		var url="dhcma.hai.ir.unreadmsg.csp?1=1";
		websys_showModal({
			url:url,
			title:'31日内消息未读病例',
			iconCls:'icon-w-epr',  
			width:'98%',
			height:'98%',
			onBeforeClose:function(){
				LoadToDoList();  //刷新代办事项
			} 
		});
	}else {
		$.messager.popover({msg: '无数据需展示！',type:'success',timeout: 1000});
	}
}
//->点击[需关注病例]
function btnNeedAtt_Click(){
	var num=$("#cntNeedAtt").text();
	if (num) {
		var url="dhcma.hai.ir.needattlist.csp?1=1";
		websys_showModal({
			url:url,
			title:'需关注病例',
			iconCls:'icon-w-epr',  
			width:'98%',
			height:'98%',
			onBeforeClose:function(){
				LoadToDoList();  //刷新代办事项
			} 
		});
	}else {
		$.messager.popover({msg: '无数据需展示！',type:'success',timeout: 1000});
	}
}
//->点击[未对照短语]
function btnNoMapCount_Click(){
	var num=$("#NoMapCount").text();
	if (num) {
		var url="dhcma.hai.ir.nomapcount.csp?1=1";
		websys_showModal({
			url:url,
			title:'未对照内容',
			iconCls:'icon-w-epr',  
			width:'98%',
			height:'98%',
			onBeforeClose:function(){
				LoadToDoList();  //刷新代办事项
			} 
		});
	}else {
		$.messager.popover({msg: '无数据需展示！',type:'success',timeout: 1000});
	}
}
//点击全院概况
function btnOpenHospSurvey(){
	OpenMenu("DHCHAIInf-HospSurvey","全院概况","dhcma.hai.ir.hospsurvey.csp");
}
