//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2020-12-17
// 描述:	   知识导入
//===========================================================================================

/// 页面初始化函数
function initPageDefault(){
	
	/// 定义页面DataGrid
	InitBmDetList();
	
	/// 页面响应事件
	//InitPageEvent();
	
}

/// 页面响应事件
/* function InitPageEvent(){
	
	$(".bt-messager-popover").click(function(){
		$("#bmDetList").datagrid("reload",{"Params":this.id});
	})
}*/
/// 定义页面DataGrid
function InitBmDetList(){
	///  定义columns
	var columns=[[
		{field:'ItemId',title:'ID',width:150,hidden:true},
		{field:'IsDiff',title:'差异对比',width:120,align:'center',formatter:setCellLabel},
		{field:'ItemCode',title:'代码',width:120,align:'center'},
		{field:'ItemDesc',title:'名称',width:360},
		{field:'Manf',title:'厂家',width:260},
		{field:'Form',title:'剂型',width:120,align:'center'},
		{field:'RelTime',title:'发布时间',width:160,align:'center'},
		{field:'Source',title:'来源',width:160}
	]];
	
	///  定义datagrid
	var option = {
		//showHeader:false,
		rownumbers : true,
		singleSelect : true,
		pagination: true,
		onDblClickRow: function (rowIndex, rowData) {

        },
		onLoadSuccess:function(data){
	
			/// 标识区域
            if (typeof data.ALL == "undefined"){return;}
        	$("#ALL label").text(data.ALL);
			$("#DIFF label").text(data.DIFF);
			$("#ADD label").text(data.ADD);
		}
	};
	/// 就诊类型
	var param = "";
	var uniturl = $URL+"?ClassName=web.DHCCKBRuleUpdCompareToLibrary&MethodName=JsGetImpItemList&Params="+param;
	new ListComponent('bmDetList', columns, uniturl, option).Init(); 
}

/// 读取文件
function read(){
	var files=$("input[name=file9]").val();
	runClassMethod("web.DHCCKBRuleUpdCompareToLibrary","ImportGlobal",{"Global":"TMPExportDrugRule",FilePath:files},function(jsonString){
		if (jsonString == 0){
			$.messager.alert("提示:","导入成功！","info");
			$("input[name=file9]").val("");
			reload();
		}
	},'',false)
}


/// 重新读取
function reload(){
	$("#bmDetList").datagrid("reload");
}

/// 一键导入
function importRule(){
	alert(LoginInfo)
	/* runClassMethod("web.DHCCKBRuleUpdCompareToLibrary","GetImportIncRuleByruleDescDemo",{"loginInfo":LoginInfo},function(jsonString){
		if (jsonString == -1){
			$.messager.alert("提示:","导入失败！","warning");
			return;
		}
		if (jsonString == 0){
			$.messager.alert("提示:","导入成功！","info");
			$("#bmDetList").datagrid("reload");
		}
	},'',false) */
}

/// 差异分析
function setCellLabel(value, rowData, rowIndex){
	var html = "";
	if (value == 1){                                                                                        
		//html = '<a href="javascript:void(0);" style="color:red;font-weight:bold" onclick="showRuleDetWin('+rowData.ItemId+',"'+rowData.ItemCode+'")">差异分析</a>';
		html = '<a href="javascript:void(0);" style="color:red;font-weight:bold" onclick="showRuleDetWin('+rowData.ItemId+',\''+rowData.ItemCode+'\')">差异分析</a>';
	}
	return html;
}

/// 差异分析
function showRuleDetWin(itemId,itemCode){
	
	commonShowWin({
		url:"dhcckb.rulecheck.csp?itemId="+itemId+"&itemCode="+encodeURI(encodeURI(itemCode)),
		title:"药品规则对照",
		width: (window.screen.availWidth - 20),
		height: (window.screen.availHeight - 150)
	})
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })