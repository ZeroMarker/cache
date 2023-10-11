//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2018-08-15
// 描述:	   急诊医生收治病人查询
//===========================================================================================

var Pid = "";         /// 进程号
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID

/// 页面初始化函数
function initPageDefault(){
	
	/// 初始化加载病人列表
	InitPatList();
	
	/// 初始化病人基本信息
	InitPatInfoPanel();
	
	/// 病人列表页面
	InitPatDetailWin();
}

/// 初始化病人基本信息
function InitPatInfoPanel(){
	
	/// 开始日期
	$HUI.datebox("#StartDate").setValue(GetCurSystemDate(-1));
	/// 结束日期
	$HUI.datebox("#EndDate").setValue(GetCurSystemDate(0));
	
	/// 急诊医生
	$HUI.combobox("#EmDoc",{
		url:$URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLocCareProv&LocID="+LgLocID,
		valueField:'value',
		textField:'text',
		mode:'remote',
		onSelect:function(option){
	    }	
	})
}

/// 页面DataGrid初始定义已选列表
function InitPatList(){
	
	///  定义columns
	var columns=[[
		{field:'CPrvID',title:'CPrvID',width:100,hidden:true},
		{field:'CPrvCode',title:'工号',width:100},
		{field:'CPrvUser',title:'姓名',width:100},
		{field:'PatNums',title:'接收病人总数',width:120},
		{field:'Detail',title:'查看明细',width:100,formatter:setCellLabel},
		{field:'Pid',title:'Pid',width:100,hidden:true}
	]];
	
	///  定义datagrid
	var option = {
		//showHeader:false,
		toolbar:"#toolbar",
		fitColumns:true,
		rownumbers : true,
		singleSelect : true,
		pagination: true,
		onLoadSuccess:function(data){
			if (typeof data.rows[0] != "undefined"){
				Pid = data.rows[0].Pid;
			}
		},
		onDblClickRow:function(rowIndex, rowData){
        }
	};
	/// 就诊类型
	var param = "^^^^"+LgHospID; //hxy 2020-06-04
	var uniturl = $URL+"?ClassName=web.DHCEMDocMainQuery&MethodName=JsGetDocTakPat&Params="+param;
	new ListComponent('bmDetList', columns, uniturl, option).Init(); 
}

/// 申请列表 卡片样式
function setCellLabel(value, rowData, rowIndex){
	
	var html = '<a href="#" onclick="OpenDetailWin('+ rowData.Pid +','+ rowData.CPrvID +')">'+$g("明细")+'</a>';
	return html;
}

/// 查询
function QryPatList(){
	
	var StartDate = $HUI.datebox("#StartDate").getValue(); /// 开始日期
	var EndDate = $HUI.datebox("#EndDate").getValue();     /// 结束日期
	var EmDocID = $HUI.combobox("#EmDoc").getValue();      /// 急诊医生
	if (typeof EmDocID == "undefined") EmDocID = "";
	var params = StartDate +"^"+ EndDate +"^"+ EmDocID +"^"+ Pid+"^"+LgHospID; //hxy 2020-06-04
	$("#bmDetList").datagrid("load",{"Params":params}); 
}

/// 明细窗口
function OpenDetailWin(Pid, CPrvID){
	
	$("#PupPatWin").window("open");
	$("#PupPatList").datagrid("reload",{"Pid":Pid, "CPrvID":CPrvID});
}

/// 病人列表页面
function InitPatDetailWin(){
	
	var option = {
		iconCls:'icon-w-paper',
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:true,
		closed:"true"
	};
	new WindowUX('病人列表', 'PupPatWin', '1360', '600', option).Init();
	$("#PupPatWin").window("close");
	
	///  定义columns
	var columns=[[
		{field:'EpisodeID',title:'EpisodeID',width:100,hidden:true},
		{field:'PatientID',title:'PatientID',width:100,hidden:true},
		{field:'PatNo',title:'登记号',width:100},
		{field:'PatName',title:'姓名',width:100},
		{field:'PatSex',title:'性别',width:100},
		{field:'PatAge',title:'年龄',width:100},
		{field:'PatBed',title:'床位',width:100},
		{field:'PatDiag',title:'诊断',width:300},
		{field:'BillType',title:'费别',width:100},
		{field:'PatLoc',title:'科室',width:140},
		{field:'PatWard',title:'病区',width:140},
		{field:'UpdateUser',title:'更新人',width:100,hidden:true}
	]];
	
	///  定义datagrid
	var option = {
		bodyCls:'panel-header-gray',
		border:true,
		fitColumns:true,
		rownumbers : true,
		singleSelect : true,
		pagination: true
	};
	
	/// 就诊类型
	var uniturl = $URL+"?ClassName=web.DHCEMDocMainQuery&MethodName=JsGetDocTakPatDetail&Pid=0&CPrvID=0";
	new ListComponent('PupPatList', columns, uniturl, option).Init(); 
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

	runClassMethod("web.DHCEMDocMainQuery","killTmpGlobal",{"pid":Pid},function(jsonString){
	},'',false)
}

/// 页面关闭之前调用
function onbeforeunload_handler() {
    killTmpGlobal();  /// 清除临时global
}

window.onbeforeunload = onbeforeunload_handler;

/// JQuery 初始化页面
$(function(){ initPageDefault(); })
