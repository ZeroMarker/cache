//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2019-07-02
// 描述:	   MDT会诊门户页面
//===========================================================================================

/// 页面初始化函数
function initPageDefault(){
	
	/// 合理用药审查趋势
//	InitDisGrpChart();

	/// 待处理申请
	InitWaitProREQ();
	
	/// 当日会诊
	LoadDailyConsult();
	
	/// 本周安排
	InitWeekSchedule();
	
	///  页面Button绑定事件
	InitBlButton(); 
	
	/// 初始化日期
	InitWeekDaily();
	
	multi_Language();         /// 多语言支持
}

/// 页面 Button 绑定事件
function InitBlButton(){
	
	$("#appoint").bind('click',TakPlan);
	$("#schedule").bind('click',TakSchedule);
	$("#reqmore").bind('click',WaitReq_More);
}

/// 当日会诊
function LoadDailyConsult(){
	
	runClassMethod("web.DHCMDTConsPortal","JsGetDailyConsult",{"mParam":""},function(jsonString){
		
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
		{field:'name',title:'来源',width:100,align:'center'},
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
	var uniturl = $URL+"?ClassName=web.DHCMDTConsPortal&MethodName=JsGetGrpJsonData";
	new ListComponent('keptBedTable', columns, uniturl, option).Init();
		
}

/// 初始化本周安排
function InitWeekSchedule(){
	
	runClassMethod("web.DHCMDTConsPortal","JsGetWeekPlan",{"mParam":""},function(jsonString){
		
		if (jsonString != null){
			InsWeekSchedule(jsonString);
		}
	},'json',false)
}

/// 待处理申请
function InsWeekSchedule(jsonArr){
	
	for(var i=0; i<jsonArr.length; i++){
		var htmlstr = "";
		htmlstr = htmlstr + '<div class="week-item-grp">';
		htmlstr = htmlstr + '	<div class="item-grp-dis"><label>'+ jsonArr[i].DisGroup +'</label></div>';
		htmlstr = htmlstr + '	<div class="item-grp-time"><label>'+ jsonArr[i].TimeRange +'</label></div>';
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
		{field:'CstRLoc',title:'申请科室',width:100,align:'center'}
		
	]];
	
	///  定义datagrid
	var option = {
		//showHeader:false,
		rownumbers:false,
		singleSelect:true,
		pagination:false,
		fit:true,
	    onDblClickRow: function (rowIndex, rowData) {
			TakPlan();  /// 安排 
        }
	};
	/// 就诊类型
	var uniturl = $URL+"?ClassName=web.DHCMDTConsPortal&MethodName=JsGetWaitProREQ";
	new ListComponent('WaitProREQ', columns, uniturl, option).Init();
}

/// 预约 二级页面
function TakPlan(PatNo){
	
	var rowData = $('#WaitProREQ').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('提示',"请先选择一条待处理记录!","error");
		return;
	}
    window.location.href = "dhcmdt.platform.csp?PatNo="+rowData.PatNo;
}

/// 排班 二级页面
function TakSchedule(){
	
	window.open("opadm.scheduletemplate.hui.csp", '_blank', 'height='+ (window.screen.availHeight-100) +', width='+ (window.screen.availWidth-100) +', top=50, left=50, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
}

/// 初始化日期
function InitWeekDaily(){
	
	runClassMethod("web.DHCMDTConsPortal","JsGetCurDaily",{"mParam":""},function(jsonString){
		
		if (jsonString != null){
			$("#mdtday").text(jsonString);
		}
	},'',false)
}

/// 待申请 更多
function WaitReq_More(){
	
	window.open("dhcmdt.platform.csp", 'newwindow', 'height='+ (window.screen.availHeight-100) +', width='+ (window.screen.availWidth) +', top=20, left=20, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');	
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
	$(".view-first-left").width(Width - 480);
	$(".view-first-right").css("left",Width - 470);
	$(".view-second-left").width(Width - 480);
	$(".view-second-right").css("left",Width - 470);
	
	/// 本周会诊
//	$(".week-plan").width(Width - 505);
//	if (Width > 900){
//		var imgWidth = (Width - 630)/5;
//	}else{
//		var imgWidth = (Width - 611)/5;
//	}
//	$(".week-nav-item:not(:nth-child(1))").width(imgWidth);
	
	$(".item-chart").width(Width - 480);
	
	InitDisGrpChart(); /// 合理用药审查趋势
	InitDisResChart(); /// 本月MDT会诊来源分布
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

window.onload = onload_handler;
window.onresize = onresize_handler;

/// JQuery 初始化页面
$(function(){ initPageDefault(); })
