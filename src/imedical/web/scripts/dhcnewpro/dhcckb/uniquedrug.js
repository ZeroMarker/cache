
//===========================================================================================
// Author：      qunianpeng
// Date:		 2021-02-20
// Description:	 药品去重
//===========================================================================================

var resultArr = [{"value":"general","text":"带剂型通用名匹配"},{"value":"generalForm","text":"带剂型通用名+等效单位匹配"}] 
$(function(){ 
		initDataList();
	initCombobox();
	initButton();

		
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
		onSelect:function(){
			query();
	 	},
	 	onLoadSuccess:function () {
		 	var data =  $('#result').combobox('getData');//获取所有下拉框数据
            if (data.length > 0) {
             	$('#result').combobox('select',data[1].value);	//如果有数据的话默认选中第一条数据
            }
        }	 
	})	 

}

///初始化按钮
function initButton()
{
	$("#find").bind("click",query);
	$("#reset").bind("click",reset);
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
			{field:'id',title:'drugId',hidden:true},
			{field:'code',title:'药品代码',width:200,align:'left',sortable: true, sortOrder : 'desc',sorter: function (a, b) { return (a > b ? 1 : -1) }},
			{field:'desc',title:'规则描述',width:300,align:'left',sortable: true, sortOrder : 'desc',sorter: function (a, b) { return (a > b ? 1 : -1) }},
			{field:'linkDrug',title:'关联药品',width:300,align:'left',hidden:true},	
			{field:'form',title:'剂型',width:100,align:'left',sortable: true, sortOrder : 'desc',sorter: function (a, b) { return (a > b ? 1 : -1) }},
			{field:'generalName',title:'带剂型通用名',width:150,align:'left',sortable: true, sortOrder : 'desc',sorter: function (a, b) { return (a > b ? 1 : -1) }},
			{field:'spec',title:'规格',width:100,align:'left',sortable: true, sortOrder : 'desc',sorter: function (a, b) { return (a > b ? 1 : -1) }},
			{field:'eqUnit',title:'等效单位',width:150,align:'left',sortable: true, sortOrder : 'desc',sorter: function (a, b) { return (a > b ? 1 : -1) }},
			{field:'ruleFlag',title:'核实',width:100,align:'left',sortable: true, sortOrder : 'desc',sorter: function (a, b) { return (a > b ? 1 : -1) }},	
			{field:'hospList',title:'医院',width:100,align:'left'},			
			{field:'parref',title:'字典',width:100,align:'left',sortable: true, sortOrder : 'desc',sorter: function (a, b) { return (a > b ? 1 : -1) }}
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
		remoteSort:false,
		//sortName:"desc",
		sortOrder : 'desc',
		pageSize:100,
		pageList:[100,200,300],		
 		onClickRow:function(rowIndex,rowData){}, 
		onDblClickRow: function (rowIndex, rowData) {},
        onLoadSuccess:function(data){}			  
	}

	var uniturl = $URL+"?ClassName=web.DHCCKBUniqueDrug&MethodName=QueryUniqueAllDrug&type=generalForm";
	//var uniturl = $URL+"?ClassName=web.DHCCKBUniqueDrug&MethodName=UniqueAllDrug&type=generalForm"; 
	new ListComponent('druglist', columns, uniturl, option).Init();
	
}

///查询
function query()
{
	var queryType = $HUI.combobox("#result").getValue();
	$('#druglist').datagrid('load',{
		type:queryType
	}); 
	
}

///重置
function reset()
{
	$HUI.combobox("#result").setValue("") ;
	//$HUI.checkbox('#prodrug').uncheck();
	query();
}