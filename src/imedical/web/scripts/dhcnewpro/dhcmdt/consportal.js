 
//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2019-07-02
// 描述:	   MDT会诊门户页面
//===========================================================================================
var WeekLimit=0;
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
var LgGroupID = session['LOGON.GROUPID'] /// 安全组ID
var LgParam=LgHospID+"^"+LgLocID+"^"+LgGroupID+"^"+LgUserID
var RightWidth = 480; ///
var LiftRightLimit = 10;
/// 页面初始化函数
function initPageDefault(){
	
	/// 合理用药审查趋势
//	InitDisGrpChart();

	/// 初始化本周日历
	InitWeekDate();
	
	/// 待处理申请
	InitWaitProREQ();
	
	/// 当日会诊
	LoadDailyConsult();
	
	/// 本周安排
	InitWeekSchedule();
	
	/// 页面Button绑定事件
	InitBlButton(); 
	
	/// 初始化日期
	InitWeekDaily();
	
	multi_Language();         /// 多语言支持
	
	LoadMoreScr();
	
	setInterval('FlushTable()',60000);
	
}

/// 页面 Button 绑定事件
function InitBlButton(){
	
	$("#appoint").bind('click',TakPlan);
	$("#schedule").bind('click',TakSchedule);
	$("#reqmore").bind('click',WaitReq_More);
}

/// 当日会诊
function LoadDailyConsult(){
	var consPlanDate=$HUI.datebox("#consPlanDate").getValue();	
	runClassMethod("web.DHCMDTConsPortal","JsGetDailyConsult",{"mParam":consPlanDate},function(jsonString){
		
		if (jsonString != null){
			InsDailyConsult(jsonString);
		}
	},'json',false)
}

/// 更新当日会诊
function InsDailyConsult(jsonArr){
	
	var htmlstr = "";
	for(var i=0; i<jsonArr.length; i++){
		var itemCss = "item-plan";
		if (jsonArr[i].StatDesc == "完成") itemCss = "item-complete";
		htmlstr = htmlstr + '<li class="pf-nav-item">';
		htmlstr = htmlstr + '	<div class="item-top"><label>'+	jsonArr[i].PatName +'</label></div>';
		htmlstr = htmlstr + '	<div class="item-center"><label>'+	jsonArr[i].DisGroup +'</label></div>';
		htmlstr = htmlstr + '	<div class="item-bottom"><label>'+	jsonArr[i].CstRTime +'</label></div>';
		htmlstr = htmlstr + '	<div class="item-tip '+ itemCss +'"></div>';
		htmlstr = htmlstr + '</li>';
	}
	$("#dailyconsult").html(htmlstr);
}

/// 待处理申请
function InitWaitProREQ_OLD(){
	
	runClassMethod("web.DHCMDTConsPortal","JsGetWaitProREQ",{"mParam":""},function(jsonString){
		
		if (jsonString != null){
			InsWaitProREQ(jsonString);
		}
	},'json',false)
}

/// 待处理申请
function InsWaitProREQ(jsonArr){
	
	var htmlstr = "";
	for(var i=1; i<jsonArr.length; i++){
		htmlstr = htmlstr + '<li class="item-news-item">';
		htmlstr = htmlstr + '	<div class="item-news-xu">患者苏小小</div>';
		htmlstr = htmlstr + '	<div class="item-news-title">疑难杂症</div>';
		htmlstr = htmlstr + '	<div class="item-news-time">19.04.05</div>';
		htmlstr = htmlstr + '</li>';
	}
	$(".item-news").append(htmlstr);
}

/// 本月MDT会诊病种分布
function InitDisGrpChart(){

	runClassMethod("web.DHCMDTConsPortal","JsGetDisGrpCharts",{},function(jsonString){
		
		if (jsonString != null){
			var ListDataObj = jsonString; ///jQuery.parseJSON(jsonString);
			
			for(var i in ListDataObj){
				ListDataObj[i].group=$g(ListDataObj[i].group);
			}
			
			var option = ECharts.ChartOptionTemplates.Bars(ListDataObj); 
			option.title ={
				text: '',    ///'审查指标趋势图',
				subtext: '', ///'饼状图',
				x:'center'
			}
			var container = document.getElementById('DisGrpCharts');
			opt = ECharts.ChartConfig(container, option);
			ECharts.Charts.RenderChart(opt);
		}
	},'json',false)
}

/// 会诊趋势图
function InitTrendChartCharts(){

	var ListDataObj = [
		{"name":"1月","group":"2021","value":"1"},
		{"name":"2月","group":"2021","value":"2"},
		{"name":"3月","group":"2021","value":"3"},
		{"name":"4月","group":"2021","value":"6"},
		{"name":"5月","group":"2021","value":"2"},
		{"name":"6月","group":"2021","value":"5"},
		{"name":"7月","group":"2021","value":"3"},
		{"name":"8月","group":"2021","value":"8"},
		{"name":"9月","group":"2021","value":"12"},
		{"name":"10月","group":"2021","value":"1"},
		{"name":"11月","group":"2021","value":"3"},
		{"name":"12月","group":"2021","value":"5"},
		{"name":"1月","group":"2020","value":"1"},
		{"name":"2月","group":"2020","value":"9"},
		{"name":"3月","group":"2020","value":"3"},
		{"name":"4月","group":"2020","value":"5"},
		{"name":"5月","group":"2020","value":"7"},
		{"name":"6月","group":"2020","value":"2"},
		{"name":"7月","group":"2020","value":"9"},
		{"name":"8月","group":"2020","value":"1"},
		{"name":"9月","group":"2020","value":"5"},
		{"name":"10月","group":"2020","value":"1"},
		{"name":"11月","group":"2020","value":"4"},
		{"name":"12月","group":"2020","value":"1"}
	];
	
	var option = ECharts.ChartOptionTemplates.Lines(ListDataObj); 
	option.title ={
		text: '',    ///'审查指标趋势图',
		subtext: '', ///'饼状图',
		x:'center'
	}
	var container = document.getElementById('TrendChartCharts');
	opt = ECharts.ChartConfig(container, option);
	ECharts.Charts.RenderChart(opt);

}


/// 会诊患者年龄分布
function InitConsAgeCharts(){

	
	var ListDataObj = [
		{"name":"1-10","value":"1"},
		{"name":"10-20","value":"5"},
		{"name":"20-30","value":"23"},
		{"name":"30-40","value":"34"},
		{"name":"40-50","value":"22"},
		{"name":"50-60","value":"34"},
		{"name":"60-70","value":"35"},
		{"name":"70-80","value":"2"},
		{"name":"80-90","value":"17"}
		]; 
	var option = ECharts.ChartOptionTemplates.Pie(ListDataObj); 
	option.title ={
		text: '',    ///'审查指标趋势图',
		subtext: '', ///'饼状图',
		x:'center'
	}
	var container = document.getElementById('ConsAgeCharts');
	opt = ECharts.ChartConfig(container, option);
	ECharts.Charts.RenderChart(opt);
	
}

/// 会诊处理统计
function InitConsAuditCharts(){
	var ListDataObj = [
		{"name":"通过","value":"188"},
		{"name":"驳回","value":"7"}
		]; 
	var option = ECharts.ChartOptionTemplates.Pie(ListDataObj); 
	option.title ={
		text: '',    ///'审查指标趋势图',
		subtext: '', ///'饼状图',
		x:'center'
	}
	var container = document.getElementById('ConsAuditCharts');
	opt = ECharts.ChartConfig(container, option);
	ECharts.Charts.RenderChart(opt);
}


/// 本月MDT会诊病种分布
/**function InitDisResChart(){

	runClassMethod("web.DHCMDTConsPortal","JsGetGrpCharts",{},function(jsonString){
		
		if (jsonString != null){
			var ListDataObj = jsonString; ///jQuery.parseJSON(jsonString);
			var str='';
			for(var i=1;i<ListDataObj.length;i++){
				   alert(ListDataObj[i].name)
				    str += "<tr>";
                    str += '<td>' + ListDataObj[i].name + "</td>";
                    str += '<td>' + ListDataObj[i].value + "</td>";
                    str += "</tr>";
				}
				$("#keptBedTable").append(htmlstr);
		}
	},'json',false)
}*/


/// 本月MDT会诊来源分布
function InitDisResChart(){
		
	///  定义columns
	var columns=[[
		{field:'name',title:'来源',width:100,align:'center',formatter:formatName},
		{field:'value',title:'数量',width:100,align:'center'},
		{field:'range',title:'比例',width:100,align:'center'}
	]];
	
	var option = {
		rownumbers:false,
		singleSelect:true,
		pagination:false,
		fit:true,
	    onDblClickRow: function (rowIndex, rowData) {
			
        }
	};
	var uniturl = $URL+"?ClassName=web.DHCMDTConsPortal&MethodName=JsGetGrpJsonData"+"&MWToken="+websys_getMWToken();
	new ListComponent('keptBedTable', columns, uniturl, option).Init();
		
}

function formatName(value, rowData,index){
	return $g(value);    
}

/// 会诊参与科室统计
function InitJoinConsLoc(){
		
	///  定义columns
	var columns=[[
		{field:'loc',title:'科室',width:100,align:'center'},
		{field:'value',title:'次数',width:100,align:'center'}
	]];
	
	var option = {
		data:[
			{"loc":"消化内科","value":1},
			{"loc":"CT室","value":6},
			{"loc":"呼吸内科","value":9},
			{"loc":"耳鼻喉科","value":8}
		],
		rownumbers:false,
		singleSelect:true,
		pagination:false,
		fit:true,
		fitColumns:true,
	    onDblClickRow: function (rowIndex, rowData) {
			
        }
	};
	var uniturl = "" //$URL+"?ClassName=web.DHCMDTConsPortal&MethodName=JsGetGrpJsonData";
	new ListComponent('joinConsLoc', columns, uniturl, option).Init();
		
}

function SetNowWeek(){
	WeekLimit=0;	
	InitWeekSchedule();
}
function SetTopWeek(){
	WeekLimit--;
	InitWeekSchedule();
}
function SetNextWeek(){
	WeekLimit++;
	InitWeekSchedule();
}

/// 初始化本周安排
function InitWeekSchedule(){
	runClassMethod("web.DHCMDTConsPortal","JsGetWeekDay",{"WeekLimit":WeekLimit},function(ret){
		var retArr=ret.split("^");
		$("#weekOneDay").html("("+retArr[0]+")");
		$("#weekTwoDay").html("("+retArr[1]+")");
		$("#weekThreeDay").html("("+retArr[2]+")");
		$("#weekFourDay").html("("+retArr[3]+")");
		$("#weekFiveDay").html("("+retArr[4]+")");
	},'text',false)
	
	runClassMethod("web.DHCMDTConsPortal","JsGetWeekPlan",{"mParam":WeekLimit},function(jsonString){
		
		if (jsonString != null){
			InsWeekSchedule(jsonString);
		}
	},'json',false)
}

/// 待处理申请
function InsWeekSchedule(jsonArr){
	$(".weekM").html("")
	for(var i=0; i<jsonArr.length; i++){
		var htmlstr = "";
		htmlstr = htmlstr + '<div class="week-item-grp">';
		htmlstr = htmlstr + '	<div class="item-grp-dis"><label class="grp-dis-text">'+ jsonArr[i].DisGroup +'</label></div>';
		htmlstr = htmlstr + '	<div class="item-grp-time"><label class="grp-dis-text">'+ jsonArr[i].TimeRange +'</label></div>';
		htmlstr = htmlstr + '	<div class="item-grp-value"><label>'+ jsonArr[i].value +'</label></div>';
		htmlstr = htmlstr + '</div>';
		$("#"+jsonArr[i].Week).append(htmlstr);
	}
}

/// 页面DataGrid初始定义已选列表
function InitWaitProREQ(){
	
	///  定义columns
	var columns=[[
		{field:'PatNo',title:'病人ID',width:100,align:'center'},
		{field:'PatName',title:'姓名',width:80},
		{field:'DisGroup',title:'病种名称',width:150},
		{field:'CstRUser',title:'申请医生',width:100,align:'center'},
		{field:'CstRTime',title:'申请时间',width:140,align:'center'},
		{field:'CstRLoc',title:'申请科室',width:100,align:'center'},
		{field:'Status',title:'当前状态',width:100,align:'center'}
	]];
	
	///  定义datagrid
	var option = {
		fit:true,
		rownumbers:false,
		singleSelect:true,
		pagination:false,
	    onDblClickRow: function (rowIndex, rowData) {
			TakPlan();  /// 安排 
        }
	};
	/// 就诊类型
	var uniturl = $URL+"?ClassName=web.DHCMDTConsPortal&MethodName=JsGetWaitProREQ&LgParam="+LgParam+"&MWToken="+websys_getMWToken();
	new ListComponent('WaitProREQ', columns, uniturl, option).Init();
}

/// 预约 二级页面
function TakPlan(PatNo){
	
	var rowData = $('#WaitProREQ').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('提示',"请先选择一条待处理记录!","error");
		return;
	}
	
	//ID EpisodeID 
	//dhcmdt.makeresplan.csp?ID=59&amp;mdtMakResID=&amp;DisGrpID=1&amp;EpisodeID=35
	//dhcmdt.matreview.csp?ID=57&amp;mdtMakResID=undefined&amp;DisGrpID=1&amp;EpisodeID=71
	Link = "dhcmdt.matreview.csp?ID="+rowData.ID +"&mdtMakResID="+rowData.mdtMakResID+"&DisGrpID="+ rowData.DisGrpID+"&EpisodeID="+ rowData.EpisodeID
			+"&IsConsCentPlan=1"+"&MWToken="+websys_getMWToken();
	
	commonShowWin({
		url: Link,
		title: $g("安排"),
		width: window.screen.availWidth - 60,
		height: window.screen.availHeight - 120,
		onClose:function(){
			FlushTable();
		}
	})	
	return;
	
}

function FlushTable(){
	$("#WaitProREQ").datagrid('reload');	
}

/// 排班 二级页面
function TakSchedule(){
	
	var url="opadm.scheduletemplate.hui.csp"+"?MWToken="+websys_getMWToken();
	window.open(url, '_blank', 'height='+ (window.screen.availHeight-100) +', width='+ (window.screen.availWidth-100) +', top=50, left=50, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
}

/// 初始化日期
function InitWeekDaily(){
	$HUI.datebox("#consPlanDate",{
		onSelect: function(date){
        	LoadDailyConsult();
    	}	
	})
	$HUI.datebox("#consPlanDate").setValue(ToDayDate);
	return;
	runClassMethod("web.DHCMDTConsPortal","JsGetCurDaily",{"mParam":""},function(jsonString){
		
		if (jsonString != null){
			//$("#mdtday").text(jsonString);
			
		}
	},'',false)
}

/// 待申请 更多
function WaitReq_More(){
	var url="dhcmdt.platform.csp"+"?MWToken="+websys_getMWToken();
	window.open(url, 'newwindow', 'height='+ (window.screen.availHeight-100) +', width='+ (window.screen.availWidth) +', top=20, left=20, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');	
}

/// 自动设置图片展示区分布
function onresize_handler(){
	
	
	var Width = document.body.offsetWidth;
	//var Height = document.body.scrollHeight;
	var Height = window.screen.availHeight;
	var TainerHeight = Height - 110;
	/// 外层容器
	$(".container").width(Width - 30);
	$(".view-first").width(Width - 30);
	$(".view-second").width(Width - 30);
	
	/// 左边
	$(".view-first-left").width(Width - RightWidth);
	$(".view-first-right").css("left",Width - RightWidth + LiftRightLimit);
	$(".view-second-left").width(Width - RightWidth);
	$(".view-second-right").css("left",Width - RightWidth + LiftRightLimit);
	$(".bt-item-right").css("width","80px");
	
	
	if(IsOpenMoreScreen!="0"){
		$("#reqmore").hide();
		$(".view-first-right-top").hide()
		$(".view-first-right-bottom").css({"top":0,"height":"100%"});
		$(".list-order-item-req").css({"height":560});
	}
	
	$(".view-second-right,.list-order-item-req,.view-first-right-bottom,.view-first-right,.view-first-right-top").css("width",RightWidth -LiftRightLimit*3);
	$(".bt-nav-item").css("width",parseInt(RightWidth/2-20));
	
	/// 本周会诊
//	$(".week-plan").width(Width - 505);
//	if (Width > 900){
//		var imgWidth = (Width - 630)/5;
//	}else{
//		var imgWidth = (Width - 611)/5;
//	}
//	$(".week-nav-item:not(:nth-child(1))").width(imgWidth);
	
	$(".item-chart").width(Width - RightWidth);
	
	InitDisGrpChart(); /// 合理用药审查趋势
	InitDisResChart(); /// 本月MDT会诊来源分布
	$HUI.datagrid("#WaitProREQ").resize();
}

/// 初始化本周日历
function InitWeekDate(){
	
	runClassMethod("web.DHCMDTConsPortal","JsGetWeekDate",{},function(jsonString){
		
		if (jsonString != null){
			InsWeekDate(jsonString);
		}
	},'json',false)
}

/// 待处理申请
function InsWeekDate(jsonObject){
	
	$('.week-plan-title [id^="Week"]').each(function(){
		var week_date = typeof jsonObject[this.id] == "undefined"?"":jsonObject[this.id];
		if (week_date != "") week_date = "["+ week_date +"]"; 
		$(this).text(week_date);
	})
}

/// 多语言支持
function multi_Language(){
	
	$g("提示");
	$g("请先选择一条待处理记录!");
}

/// 页面全部加载完成之后调用(EasyUI解析完之后)
function onload_handler() {
	
	/// 自动分布
	onresize_handler();
}

function SetToDay(){
	$HUI.datebox("#consPlanDate").setValue(ToDayDate);
	LoadDailyConsult();
}


/// 病历查看:超融合
function LoadMoreScr(){
	
	websys_on("onMdtPortal",function(res){
		LoadDailyConsult();
		InitWeekSchedule();
	});
}

window.onload = onload_handler;
window.onresize = onresize_handler;

/// JQuery 初始化页面
$(function(){ initPageDefault(); })
