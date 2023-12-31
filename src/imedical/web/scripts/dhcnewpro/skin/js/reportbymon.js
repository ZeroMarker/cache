// Creator: yangyongtao
// CreateDate: 2017-09-22
// Descript: 不良事件全部月统计

var url = "dhcadv.repaction.csp";
//var StDate=formatDate(-7);  //一周前的日期
//var EndDate=formatDate(0); //系统的当前日期



$(function(){
	$("#stdate").datebox("setValue", formatDateD(0));  //Init起始日期
	$("#enddate").datebox("setValue", formatDate(0));  //Init结束日期
    
	//报告类型
	$('#type').combobox({
		//panelHeight:"auto",  //设置容器高度自动增长
		url:url+'?action=selEvent'
		
	});
	
	$('#Find').bind("click",Query);  //点击查询
	StatAllRepByMon(); //初始化统计列表	
	
})
//查询
 function Query()
{
	//1、清空datagrid 
	$('#maindg').datagrid('loadData', {total:0,rows:[]}); 
	//2、查询
	var StDate=$('#stdate').datebox('getValue');   //起始日期
	var EndDate=$('#enddate').datebox('getValue'); //截止日期
	var typeCode=$('#type').combobox('getValue');  //报告类型
	if(typeof typeCode == "undefined"){typeCode=""}	

	var params=StDate+"^"+EndDate+"^"+typeCode;
	
	$('#maindg').datagrid({
		//url:url+'?action=StatAllRepByMon',
		url:'dhcapp.broker.csp?ClassName=web.DHCADVREPBYMON&MethodName=StatAllRepByMon',	
		queryParams:{
			params:params}
	});
	
	$.ajax({
		type: "POST",
		url:'dhcapp.broker.csp?ClassName=web.DHCADVREPBYMON&MethodName=AnalysisRepByMon'+'&params='+params,	
		//url: url+"?action=AnalysisRepByMon&params="+params,
		success: function(jsonString){
			var ListDataObj = jQuery.parseJSON(jsonString);
			var option = ECharts.ChartOptionTemplates.Lines(ListDataObj); 
			option.title ={
				//text: '不良反应事件统计分析',
				//subtext: '饼状图',
				//x:'center'
			}
			var container = document.getElementById('charts');
			opt = ECharts.ChartConfig(container, option);
			ECharts.Charts.RenderChart(opt);
		}
	});
}
//初始化统计列表
function StatAllRepByMon()
{
	//定义columns
	var columns=[[
		{field:"name",title:'月份',width:150,align:'center'},
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
		//rownumbers:true,//行号  
		pagination:true

	});
	initScroll("#maindg");//初始化显示横向滚动条
	$('#maindg').datagrid('loadData', {total:0,rows:[]}); 
}
