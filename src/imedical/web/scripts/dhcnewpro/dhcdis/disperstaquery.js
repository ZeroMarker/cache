///Description: 配送人员状态查询
///Creator:     zhaowuqiang
///Date:        2017/02/06
var Array = [{ "value": "0", "text": "忙碌" },{ "value": "1", "text": "空闲" }];
$(document).ready(function(){
	initStatuslist();      // 初始化配送人员状态列表
	initButton();		   // 初始化页面的按钮
	initCombobox();		   // 初始化页面的下拉框
	querystatus();         // 初始化查询
 });

///定义datagrid
function initStatuslist()
{
	//  定义columns
	var columns=[[
		{field:'LocDesc',title:'科室',width:260,align:'center'},
		{field:'StaNo',title:'人员工号',width:260,align:'center'},
		{field:'StaName',title:'姓名',width:260,align:'center'},
		{field:'Enable',title:'是否可用',width:260,align:'center'},
		{field:'Status',title:'状态',width:290,align:'center'}
	]];
	// 初始化 datagrid
	$('#statuslist').datagrid({
		title:'',
		fit:true,
		nowrap:false,
		rownumbers:true,
		columns:columns,
		pageSize:20,  		// 每页显示的记录条数
		pageList:[20,40],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true
	});
	
}

/// 初始化按钮
function initButton()
{
	// 查询按钮
	$('a:contains("查询")').bind("click",querystatus);
	
	//清空combobox
	$('a:contains("清空")').bind("click",clearcombobox);
	
	//绑定回车事件
	$(document).keydown(function (e) { 
		if (e.which == 13) { 
		querystatus(); 
		} 
}); 
	
}


/// 初始化combobox
function initCombobox()
{
	// 人员状态
	var StatusCombobox = new ListCombobox("Status",'',Array,{panelHeight:"auto",editable:true});
	StatusCombobox.init();
	//$("#Status").combobox("setValue","0");   //设置默认
	$("#Status").combobox({
		//value:"0",
		onSelect:function(){
			querystatus();}
		
		});
	// 状态下拉框选择触发查询事件
	/*  $("#Status").combobox({
		onSelect:function(){
			querystatus();}
		}); */
	
	// 病区
	var uniturl = LINK_CSP+"?ClassName=web.DHCDISPerStatus&MethodName=";	
	var url = uniturl+"SelAllLoc";
	new ListCombobox("Dept",url,'').init();
	// 科室下拉框选择触发查询事件
	$("#Dept").combobox({
		onSelect:function(){
			querystatus();}
		});
	//$("#Dept").combobox("setValue","0");    //设置默认
	
}
/// 查询
function querystatus()
{
	var dept=$("#Dept").combobox("getValue");
	var status=$("#Status").combobox("getValue");
	//alert(status)
	var params=dept+"^"+status;
	$('#statuslist').datagrid(
		{
			url:'dhcapp.broker.csp?ClassName=web.DHCDISPerStatus&MethodName=QueryPersonStatus',	
			queryParams:{
			StrParam:params}
			});
}
///清空combobox
function clearcombobox()
{
	$("#Dept").combobox("setValue","");
	$("#Status").combobox("setValue","");
	querystatus();
}

/// JQuery 初始化页面
//$(function(){ initPageDefault(); })