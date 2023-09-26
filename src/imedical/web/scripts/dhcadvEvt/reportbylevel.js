// Creator: yangyongtao
// CreateDate: 2017-09-26
// Descript:按等级统计
var url = "dhcadv.repaction.csp";
var TypeArr = [{"value":"Pie","text":'饼状图'}, {"value":"Bars","text":'条形图'}];
var LevelArr = [{"value":"Ⅰ级","text":'一级'},{"value":"Ⅱ级","text":'二级'}, {"value":"Ⅲ级","text":'三级'},{"value":"Ⅳ级","text":'四级'}];
$(function(){
	$("#stdate").datebox("setValue", formatDate(-7));  //Init起始日期
	$("#enddate").datebox("setValue", formatDate(0));  //Init结束日期
	//类型
	$('#type').combobox({
		panelHeight:"auto",  //设置容器高度自动增长
		data:TypeArr
	});
	//报告类型  
	$('#reptype').combobox({
		//panelHeight:"auto",  //设置容器高度自动增长
		url:url+'?action=selEvent'	
	});
	$('#type').combobox('setValue',"Pie");   
	//$('#Find').bind("click",Query);  //点击查询
	//等级
	$('#level').combobox({
		panelHeight:"auto",  //设置容器高度自动增长
		data:LevelArr
	});
	
    // 查找按钮绑定单击事件  
    $('#Find').bind('click',function(event){
         Query(); //调用查询
    });
	
	Statisticmain(); //初始化统计列表
})
//查询
function Query()
{
	//1、清空datagrid 
	$('#maindg').datagrid('loadData', {total:0,rows:[]}); 
	//2、查询
	var StDate=$('#stdate').datebox('getValue');   //起始日期
	var EndDate=$('#enddate').datebox('getValue'); //截止日期
	var level=$('#level').combobox('getValue');
	if (level==undefined){level="";}
	var reptype=$('#reptype').combobox('getValue');  //报告类型
	if (reptype==undefined){reptype="";}
	var params=StDate+"^"+EndDate+"^"+level+"^"+reptype;
	var type=$('#type').combobox('getValue');
	$('#maindg').datagrid({
		//url:url+'?action=QueryLelStatic',	
		url:'dhcapp.broker.csp?ClassName=web.DHCADVREPBYLEVEL&MethodName=QueryLelStatic',
		queryParams:{
			params:params}
	});
	if(type=="Pie"){
	$.ajax({
		type: "POST",
		data : {'params':params},
		//url: url+"?action=QueryLelAnalysis&params="+params,
		url:'dhcapp.broker.csp?ClassName=web.DHCADVREPBYLEVEL&MethodName=QueryLelAnalysis',
		success: function(jsonString){
			var ListDataObj = jQuery.parseJSON(jsonString);
			var option = ECharts.ChartOptionTemplates.Pie(ListDataObj); 
			option.title ={
				//text: '不良反应事件统计分析',
				//subtext: '饼状图',
				//x:'center'
			}
			var container = document.getElementById('charts');
			opt = ECharts.ChartConfig(container, option);
			ECharts.Charts.RenderChart(opt);
		}
	});}
	if(type=="Bars"){
	$.ajax({
		type: "POST",
		data : {'params':params},
		url:'dhcapp.broker.csp?ClassName=web.DHCADVREPBYLEVEL&MethodName=QueryLelAnalysis', //+'&params='+params,
		//url: url+"?action=QueryLelAnalysis&params="+params,
		success: function(jsonString){
			var ListDataObj = jQuery.parseJSON(jsonString);
			var option = ECharts.ChartOptionTemplates.Bars(ListDataObj); 
			option.title ={
				//text: '不良反应事件统计分析',
				//subtext: '柱状图',
				//x:'center'
			}
			var container = document.getElementById('charts');
			opt = ECharts.ChartConfig(container, option);
			ECharts.Charts.RenderChart(opt);
		}
	});}
}
//初始化统计列表
function Statisticmain()
{
	//定义columns
	var columns=[[
		{field:"name",title:'事件等级',width:150,align:'center'},
		{field:'value',title:'数量',width:150,align:'center'},
	]];
	//定义datagrid
	$('#maindg').datagrid({
		url:'',
		fit:true,
		columns:columns,
	    singleSelect:false,
		loadMsg: '正在加载信息...',
		showFooter:true,
		pagination:true,
		onLoadSuccess: function (data) {
		}
	});
	//initScroll("#maindg");//初始化显示横向滚动条
	$('#maindg').datagrid('loadData', {total:0,rows:[]}); 
}
