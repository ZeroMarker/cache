//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2019-11-19
// 描述:	   全院mdt数据统计 JS
//===========================================================================================

var mdtParams = "";  /// 上级页面传递查询条件
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
	
	mdtParams = getParam("mdtParams");   /// 上级页面传递查询条件
}

/// 初始化界面组件
function InitComponents(){
	
	/// 开始日期
	$HUI.datebox("#StartDate").setValue(GetCurSystemDate(-30));
	
	/// 结束日期
	$HUI.datebox("#EndDate").setValue(GetCurSystemDate(0));
		
	/// 根据上级页面传参设置开始日期，结束日期
	if (mdtParams != ""){
		$HUI.datebox("#StartDate").setValue(mdtParams.split("@")[0]);
		$HUI.datebox("#EndDate").setValue(mdtParams.split("@")[1]);
	}
}

/// 初始化加载交班列表
function InitMainList(){
	
	///  定义columns
	var columns=[[
		{field:'mdtReqLoc',title:'申请科室',width:260,align:'center'},
		{field:'mdtReqQty',title:'申请数量',width:120,align:'center',formatter:SetCellUrl},
		{field:'mdtParams',title:'查询条件',width:200,align:'center',hidden:true}
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
				InitDisGrpChart(); /// MDT申请科室分布
			}
		}
	};
	/// 就诊类型
	var param = mdtParams;
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsGetMdtReqLocMap&Params="+param+ "&pid="+pid+"&MWToken="+websys_getMWToken();
	new ListComponent('bmMainList', columns, uniturl, option).Init(); 
}

/// 链接
function SetCellUrl(value, rowData, rowIndex){
	
	var mdtParams = rowData.mdtParams +"@"+ rowData.mdtReqLocID;
	var html = "<a href='#' onclick='Pop_Win(\""+ mdtParams +"\")' style='margin:0px 5px;'>"+ value +"</a>";
	return html;
}

/// 弹窗
function Pop_Win(mdtParams){
	
	var Link = "dhcmdt.docworkloadstat.csp?mdtParams="+ mdtParams+"&MWToken="+websys_getMWToken();
	window.open(Link, '_blank', 'height='+ (window.screen.availHeight-200) +', width='+ (window.screen.availWidth-200) +', top=100, left=100, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
}

/// 查询
function find_click(){
	
	var StartDate = $HUI.datebox("#StartDate").getValue(); /// 开始日期
	var EndDate = $HUI.datebox("#EndDate").getValue();     /// 结束日期
	var params = StartDate +"@"+ EndDate +"@@";
	$("#bmMainList").datagrid("load",{"Params":params, "pid":pid});
}

/// 打印
function print_click(){
	
}

/// MDT申请科室分布
function InitDisGrpChart(){

	runClassMethod("web.DHCMDTConsultQuery","JsGetMdtReqLocCharts",{"pid":pid},function(jsonString){
		
		if (jsonString != null){
			var ListDataObj = jsonString; ///jQuery.parseJSON(jsonString);
			for (var i in ListDataObj){
				ListDataObj[i].name = $g(ListDataObj[i].name);
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

/// 删除临时global
function killTmpGlobal(){

	runClassMethod("web.DHCMDTConsultQuery","killTmpGlobal",{"pid":pid},function(jsonString){
	},'',false)
}

/// 页面关闭之前调用
function onbeforeunload_handler() {
    killTmpGlobal();  /// 清除临时global
}

/// 自动设置页面布局
function onresize_handler(){
	$("#bmMainList").datagrid("resize");
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