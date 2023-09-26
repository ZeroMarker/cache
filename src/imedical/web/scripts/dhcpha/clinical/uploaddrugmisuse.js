/// Creator: bianshuai
/// CreateDate: 2014-10-29
//  Descript: 用药错误上报

var url="dhcpha.clinical.action.csp";
var statArray = [{ "val": "W", "text": "待审" }, { "val": "A", "text": "已审" }, { "val": "B", "text": "退回" }];
$(function(){

	$("#stdate").datebox("setValue", formatDate(-2));  //Init起始日期
	$("#enddate").datebox("setValue", formatDate(0));  //Init结束日期
	
	//科室
	$('#dept').combobox({
		onShowPanel:function(){
			$('#dept').combobox('reload',url+'?actiontype=SelAllLoc&loctype=E')
		}
	}); 

	//病区
	$('#ward').combobox({
		onShowPanel:function(){
			$('#ward').combobox('reload',url+'?actiontype=SelAllLoc&loctype=W')
		}
	});
	
	//状态
	$('#status').combobox({
		panelHeight:"auto",  //设置容器高度自动增长
		data:statArray 
	});
	$('#status').combobox('setValue',"W"); //设置combobox默认值
	
	$('#Find').bind("click",Query); //点击查询
	
	InitPatList(); //初始化病人列表
})

//查询
function Query()
{
	//1、清空datagrid 
	$('#maindg').datagrid('loadData', {total:0,rows:[]}); 
	//2、查询
	var StDate=$('#stdate').datebox('getValue'); //起始日期
	var EndDate=$('#enddate').datebox('getValue'); //截止日期
	var LocID=$('#dept').combobox('getValue'); //科室ID
	var WardID=$('#ward').combobox('getValue'); //病区ID
	if (LocID== undefined){LocID="";}
	if (WardID== undefined){WardID="";}
	var PatNo=$.trim($("#patno").val());
	var params=StDate+"^"+EndDate+"^"+WardID+"^"+LocID+"^"+PatNo+"^"+AppType;

	$('#maindg').datagrid({
		url:url+'?action=GetUntoEffectPatList',	
		queryParams:{
			params:params}
	});
}

//初始化病人列表
function InitPatList()
{
	//定义columns
	var columns=[[
		{field:"AdrRepID",title:'AdrRepID',width:90},
		{field:'AdrRepNo',title:'报告编号',width:160},
		{field:'PatNo',title:'登记号',width:80},
		{field:'PatName',title:'姓名',width:80},
		{field:'Status',title:'状态',width:80},
		{field:'AdmLoc',title:'科室',width:120},
		{field:'AdmWard',title:'病区',width:120},
		{field:'RepUser',title:'报告人',width:80},
		{field:'RepDate',title:'报告日期',width:100},
		{field:'RepTime',title:'报告时间',width:100},
		{field:'AuditUser',title:'审核人',width:80},
		{field:'AuditDate',title:'审核日期',width:100},
		{field:'AuditTime',title:'退回原因',width:120},
		{field:'IfUpLoad',title:'是否上报',width:120},
		{field:'UpLoad',title:'上报',width:120}
	]];
	
	//定义datagrid
	$('#maindg').datagrid({
		title:'病人列表',
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true
	});
	
	initScroll("#maindg");//初始化显示横向滚动条
}
