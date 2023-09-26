/**
 *打印模板
**/
var formNameID="";
function initPageDefault(){
	
	initCombobx();
	initDatagrid();
	
}
function initCombobx(){
	var uniturl = LINK_CSP+"?ClassName=web.DHCADVEXPFIELD&MethodName=";
	var option = {
		valueField:'value',
		textField:'text',
		onSelect:function(option){
			formNameID = option.value;
			reloadAllItmTable(option.value);
	    }
	};
	
	var url = uniturl+"getRepType";
	new ListCombobox("reportType",url,'',option).init();	
	
	$('#search').searchbox({
		searcher : function (value, name) {
			search($.trim(value));
		}
	});
	
	var option = {
		valueField:'value',
		textField:'text',
		editable:false,
		data:[
			{
				"value":1,
				"text":"不良事件"
			},{
				"value":2,
				"text":"妇幼系统"
			},
		],
		onSelect:function(option){
			reloadReportTypeCombobox(option.value);
	    }
	};
	
	new ListCombobox("printType","","",option).init();
	$("#printType").combobox("setValue",1);	
}

function reloadReportTypeCombobox(value){
	var url="";
	if(value==1) url=LINK_CSP+"?ClassName=web.DHCADVEXPFIELD&MethodName=getRepType";
	if(value==2) url=LINK_CSP+"?ClassName=web.DHCADVEXPFIELD&MethodName=getRepTypeNew";
	$("#reportType").combobox({
		url:url	
	})
	$('#allItmTable').datagrid('loadData', { total: 0, rows: [] });
	return;
}

function initDatagrid(){
	
	var columns=[[
		{field:'FormDicID',title:'FormDicID',width:80,hidden:true},
		{field:'DicField',title:'DicField',width:120,hidden:true},
		{field:'DicDesc',title:'全部列',width:160}
	]];
	
	
	$HUI.datagrid('#allItmTable',{
		url:LINK_CSP+"?ClassName=web.DHCADVEXPFIELD&MethodName=QueryAllItmByFormID",
		fit:true,
		border:false,
		autoSizeColumn:false,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true,
		showHeader:false,
		rownumbers : true,
		showPageList : false,
	    onClickRow: function (rowIndex, rowData) {
		    var moreItmFlag=$HUI.checkbox("#moreId").getValue()?1:0;
       		$("#dataframe")[0].contentWindow.setSelItmID(rowData.DicField,rowData.DicDesc,moreItmFlag);
        },
		onLoadSuccess:function(data){
			$('.pagination-page-list').hide();
            $('.pagination-info').hide();
		}
	})
	
	$('#allItmTable').datagrid('getPager').pagination({ showRefresh: false});  
}
//reload 左上表
function reloadAllItmTable(value){
	var url="";
	var printType = $("#printType").combobox("getValue");	
	if(printType==1) url=LINK_CSP+"?ClassName=web.DHCADVEXPFIELD&MethodName=QueryAllItmByFormID";
	if(printType==2) url=LINK_CSP+"?ClassName=web.DHCADVEXPFIELD&MethodName=QueryAllItmByFormID";
	
	$("#allItmTable").datagrid({
		url:url,
		queryParams:{
			ForNameID:value,
			Input:''
		}
	})
}

function search(input)
{
	$("#allItmTable").datagrid('load',{
		ForNameID:formNameID,
		Input:input
	})
}
/// JQuery 初始化页面
$(function(){ initPageDefault(); })