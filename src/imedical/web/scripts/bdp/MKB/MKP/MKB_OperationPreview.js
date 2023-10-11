/// 名称: 各版本ICD对照-结构化手术预览
/// 描述: 结构化手术属性列表
/// 编写者: 基础数据平台组-高姗姗
/// 编写日期: 2020-02-07

var init = function(){
	$('#Form_DiagPropertySearchGrid').datagrid('loadData',{total:0,rows:[]})
	$('#Form_DiagPropertySelectedGrid').datagrid('loadData',{total:0,rows:[]})
	$("#DiagForm").empty();
	LoadPropertyData(SelMRCICDRowid,"",indexTemplate);
	
	//再次打开时重新设置默认值，以防拖动后显示不下
	$('#mypromplayout').layout('panel', 'west').panel('resize',{width:myProWidth*(2/5)});
    //$('#mypromplayout').layout('panel', 'east').panel('resize',{width:myProWidth*(9/20)});
    $("#mypropertylayout").layout("resize");
}
$(init);
