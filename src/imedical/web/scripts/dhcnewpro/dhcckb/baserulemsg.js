
//===========================================================================================
// Author：      qunianpeng
// Date:		 2020-11-05
// Description:	 兜底规则拒绝生成列表
//===========================================================================================

var resultArr = [{"value":"1","text":"单位不同"},{"value":"2","text":"比值符号冲突"},{"value":"3","text":"数值或单位为空"},{"value":"4","text":"非儿童特殊剂量"}]
$(function(){ 

	initCombobox();
	initButton();
	initDataList();
		
})

///初始化combobox
function initCombobox()
{
	//var uniturl = $URL+"?ClassName=web.DHCCKBCommonUtil&MethodName=QueryHospList"  
	$HUI.combobox("#result",{
		//url:uniturl,
		valueField:'value',
		textField:'text',
		panelHeight:"160",
		mode:'remote',
		data:resultArr,
		onSelect:function(ret){
			query();
	 	}
	})	 
	 		
}

///初始化按钮
function initButton()
{
	$("#find").bind("click",query);
	$("#reset").bind("click",reset);
	$("#drugName").bind("keypress",query);	

}

///药品列表
function initDataList(){
	
	// 编辑格
	var texteditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}

	// 定义columns
	var columns=[[   	 
			{field:'drugId',title:'drugId',hidden:true},
			{field:'drugName',title:'药品',width:400,align:'left'},
			{field:'ruleId',title:'规则序号',width:100,align:'left'},
			{field:'result',title:'拒绝生成原因',width:300,align:'left'},
			{field:'dataId',title:'字典id',width:300,align:'left',hidden:true},
			{field:'dataName',title:'字典',width:300,align:'left'},
			{field:'soulce',title:'数据来源',width:200,align:'left',hidden:true}						
		 ]]

	var option={	
		bordr:false,
		fit:true,
		fitColumns:true,
		singleSelect:true,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:30,
		pageList:[30,60,90],		
 		onClickRow:function(rowIndex,rowData){}, 
		onDblClickRow: function (rowIndex, rowData) {},
        onLoadSuccess:function(data){}			  
	}

	var uniturl = $URL+"?ClassName=web.DHCCKBPrescTest&MethodName=QueryErrBaseRuleMsg&params=";
	new ListComponent('errmsg', columns, uniturl, option).Init();
	
}

///查询
function query()
{
	var params = $HUI.combobox("#result").getValue();
	var drugName = $("#drugName").val();
	params = params +"^"+ drugName;
	$('#errmsg').datagrid('load',{
		params:params
	}); 
	
}

///重置
function reset()
{
	$HUI.combobox("#result").setValue("");
	$("#drugName").val("");
	//$HUI.checkbox('#prodrug').uncheck();
	query();
}