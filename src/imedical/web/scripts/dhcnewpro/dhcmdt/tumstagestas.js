//===========================================================================================
// 作者：      yangyongtao
// 编写日期:   2020-08-18
// 描述:	   MDT病例不同分期情况所占比例 JS
//===========================================================================================

var pid = "";        /// 计数器
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID

/// 页面初始化函数
function initPageDefault(){
	
	InitParams();      /// 初始华参数
	InitComponents();  /// 初始化界面组件
	InitMainList();    /// 初始化交班列表
}

/// 初始化页面参数
function InitParams(){
	
}

/// 初始化界面组件
function InitComponents(){
	
	/// 开始日期
	$HUI.datebox("#StartDate").setValue(GetCurSystemDate(-30));
	
	/// 结束日期
	$HUI.datebox("#EndDate").setValue(GetCurSystemDate(0));
	
}

/// 初始化加载肿瘤状态列表
function InitMainList(){
	
	///  定义columns
	var columns=[[
		{field:'TumStage',title:'分期',width:200,align:'center',formatter:function(value){return $g(value);}},
		{field:'DisQty',title:'会诊总量',width:120,align:'center'},

	]];
	
	///  定义datagrid
	var option = {
		headerCls:'panel-header-gray',
		rownumbers : true,
		singleSelect : true,
		pagination: true,
		onClickRow:function(rowIndex, rowData){

		},
		onLoadSuccess:function(data){
			if (typeof data.rows[0] != "undefined"){
				pid = data.rows[0].pid;
				InitDisGrpChart(); /// MDT会诊病种分布
			}
		}
	};
	/// 就诊类型
	var StartDate = $HUI.datebox("#StartDate").getValue(); /// 开始日期
	var EndDate = $HUI.datebox("#EndDate").getValue();     /// 结束日期
	var param =  StartDate +"^"+ EndDate;
	var uniturl = $URL+"?ClassName=web.DHCMDTStatistics&MethodName=JsGetTumStageMap&Params="+param+ "&pid="+pid+"&MWToken="+websys_getMWToken();
	new ListComponent('bmMainList', columns, uniturl, option).Init(); 
}



/// 查询
function find_click(){
	
	var StartDate = $HUI.datebox("#StartDate").getValue(); /// 开始日期
	var EndDate = $HUI.datebox("#EndDate").getValue();     /// 结束日期
	var params = StartDate +"^"+ EndDate;
	$("#bmMainList").datagrid("load",{"Params":params, "pid":pid});
}


/// MDT会诊病种月分布
function InitDisGrpChart(){

	runClassMethod("web.DHCMDTStatistics","JsGetTumStageMapCharts",{"pid":pid},function(jsonString){
		
		if (jsonString != null){
			var ListDataObj = jsonString; ///jQuery.parseJSON(jsonString);
			
			for (var i in ListDataObj){
				ListDataObj[i].name?ListDataObj[i].name=$g(ListDataObj[i].name):"";
			}
			
			var option = ECharts.ChartOptionTemplates.Pie(ListDataObj); 
			option.title ={
				text: '',    ///'审查指标趋势图',
				subtext: '', ///'饼状图',
				x:'center'
			}
			var container = document.getElementById('TumStageCharts');
			opt = ECharts.ChartConfig(container, option);
			ECharts.Charts.RenderChart(opt);
		}
	},'json',false)
}

/// 获取系统当前日期
function GetCurSystemDate(offset){
	
	var SysDate = "";
	runClassMethod("web.DHCEMConsultCom","GetCurSystemDate",{"offset":offset},function(jsonString){

		if (jsonString != ""){
			SysDate = jsonString;
		}
	},'',false)
	return SysDate
}

/// 页面关闭之前调用
function onbeforeunload_handler() {
    killTmpGlobal();  /// 清除临时global
}

/// 自动设置页面布局
function onresize_handler(){
	
}

/// 页面全部加载完成之后调用(EasyUI解析完之后)
function onload_handler() {

	
	/// 自动设置页面布局
	onresize_handler();
}

window.onload = onload_handler;
window.onresize = onresize_handler;
window.onbeforeunload = onbeforeunload_handler;

/// JQuery 初始化页面
$(function(){ initPageDefault(); })