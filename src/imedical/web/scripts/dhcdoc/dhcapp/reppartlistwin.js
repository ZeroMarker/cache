//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2016-12-22
// 描述:	   检查申请部位选择界面
//===========================================================================================

var oeori = "";

/// 页面初始化函数
function initPageDefault(){
	
	InitParam();     ///  初始化参数信息
	InitItemList();  ///  页面DataGrid检查分类列表
	InitBlButton();  ///  页面Button绑定事件
	
	InitLoadData();  ///  加载医嘱对应部位
}

/// 初始化加载病人就诊ID
function InitParam(){
	oeori = getParam("oeori");
}

/// 页面DataGrid初始定义检查分类列表
function InitItemList(){

	///  定义columns
	var columns=[[
		{field:'PartDesc',title:'部位',width:180,align:'center'},
		{field:'PosiDesc',title:'体位',width:120,align:'center'},
		{field:'ItemDisp',title:'后处理',width:160,align:'center'},
		{field:'ItemStat',title:'状态',width:100,align:'center'},
		{field:'ItemID',title:'ItemID',width:100,hidden:true},
		{field:'PartID',title:'PartID',width:100,hidden:true}
	]];
	
	///  定义datagrid
	var option = {
		border : false,
		rownumbers : false,
		singleSelect : true,
		pagination: false,
		rowStyler:function(index,rowData){   
	        if (rowData.ItemStat == "停止"){
	            return 'background-color:Pink;'; 
	        }
	    }
	};
	
	var params = "";
	var uniturl = "";
	new ListComponent('dmPartList', columns, uniturl, option).Init(); 
}

/// 页面 Button 绑定事件
function InitBlButton(){
	
	///  取消
	$('a:contains("取消")').bind("click",cancel);
	
	///  撤销
	$('a:contains("撤销")').bind("click",revExaReqItm);

}

/// 撤销执行选中项目
function revExaReqItm(){
	
	var rowData=$("#dmPartList").datagrid('getSelected'); /// 获取选中行
	if (rowData == null){
		$.messager.alert("提示:","请先选择待撤销记录！");
		return;
	}
	if (rowData.ItemStat == "停止"){
		$.messager.alert("提示:","当前记录已停止，不能再次撤销！");
		return;
	}
	if (rowData.ItemStat == "执行"){
		$.messager.alert("提示:","当前记录已执行，不能撤销！");
		return;
	}
	var arReqItmID = rowData.ItemID;  /// 项目ID
	var PartID = rowData.PartID;      /// 部位ID

	runClassMethod("web.DHCAPPExaReport","revExaReqItm",{"arRepItmID":arReqItmID, "PartID":PartID, "LgUserID":LgUserID},function(jsonString){
		
		if (jsonString == 1){
			$.messager.alert("提示:","报告已执行不能进行此操作！");
			return;
		}
	    if (jsonString < 0){
			$.messager.alert("提示:","删除错误,错误信息:"+jsonString);
			return;
		}
	    if (jsonString == 0){
			$("#dmPartList").datagrid("reload");   /// 刷新页面数据
		}
	
	},'',false)
}

/// 初始化加载部位数据
function InitLoadData(){
	
	/// 部位分类列表
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QueryPartItmList&oeori="+oeori;
	$('#dmPartList').datagrid({url:uniturl});
}

/// 关闭窗体
function cancel(){
	
	window.close();
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })