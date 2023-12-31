/// Creator: congyue
/// CreateDate: 2016-04-29
//  Descript: 预警平台

var url = "dhcadv.repaction.csp";
$(function(){
	var myDate = new Date();
	var StDate="";
	if(DateFormat=="4"){ //日期格式 4:"DMY" DD/MM/YYYY
		StDate="01"+"/"+"01"+"/"+myDate.getFullYear();  //当年开始日期
	}else if(DateFormat=="3"){ //日期格式 3:"YMD" YYYY-MM-DD
		StDate=myDate.getFullYear()+"-"+"01"+"-"+"01";  //当年开始日期
	}else if(DateFormat=="1"){ //日期格式 1:"MDY" MM/DD/YYYY
		StDate="01"+"/"+"01"+"/"+myDate.getFullYear();  //当年开始日期
	}
	var date=CurentTime(); //获取当前日期
	var params=StDate+"^"+date;
	var param=StDate+"^"+date+"^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID;
	WardInfo(); //初始化统计列表
	UntreatedInfo();//待办报告统计列表
	//病区统计
	$('#warddg').datagrid({
		url:url+'?action=StaticPreAlert',	
		queryParams:{
			params:params}
	});
	
	$('#untreated').datagrid({
	  url:url+'?action=UntreatedList',	
		queryParams:{
			param:param}
	});

	//医疗等级分布
	$.ajax({
		type: "POST",
		url: url+"?action=QueryLelAnalysis&params="+params,
		success: function(jsonString){

			var ListDataObj = jQuery.parseJSON(jsonString);
			var option = ECharts.ChartOptionTemplates.Bars(ListDataObj); 
			option.title ={
				//text: '医疗等级分布',
				//subtext: '柱状图',
				//x:'center'
			}
			var container = document.getElementById('medcharts');
			opt = ECharts.ChartConfig(container, option);
			ECharts.Charts.RenderChart(opt);
		}
	});
	//病区分布
	$.ajax({
		type: "POST",
		url: url+"?action=AnalyPreAlert&params="+params,
		success: function(jsonString){

			var ListDataObj = jQuery.parseJSON(jsonString);
			var option = ECharts.ChartOptionTemplates.Bars(ListDataObj); 
			option.title ={
				//text: '病区分布',
				//subtext: '柱状图',
				//x:'center'
			}
			var container = document.getElementById('wardcharts');
			opt = ECharts.ChartConfig(container, option);
			ECharts.Charts.RenderChart(opt);
		}
	});
})

// 待办报告初始化列表
function UntreatedInfo(){
		//定义columns
	var columns=[[
		{field:'name',title:'报告类型',width:150,align:'center'},
		{field:'value',title:'报告数量',width:150,align:'center'},
	]];
	//定义datagrid
	$('#untreated').datagrid({
		//url: url+"?action=UntreatedList&param="+param,
		url:'',
		fit:true,
		columns:columns,
		rownumbers:true,
	    singleSelect:false,
		loadMsg: '正在加载信息...',
		showFooter:true,
		pageSize:10,  // 每页显示的记录条数
		pageList:[10,20,30],
		pagination:true
	});
	initScroll("#untreated");//初始化显示横向滚动条
	}
//初始化统计列表
function WardInfo()
{
	//定义columns
	var columns=[[
		{field:"name",title:'病区',width:150,align:'center',sortable:true},
		{field:'reptype',title:'报告类型',width:150,align:'center'},
		{field:'value',title:'报告数量',width:150,align:'center'},
	]];
	//定义datagrid
	$('#warddg').datagrid({
		url:'',
		fit:true,
		columns:columns,
		rownumbers:true,
		remoteSort:false,  //问题所在
		sortName:'name',
		sortOrder:'asc',
	    singleSelect:false,
		loadMsg: '正在加载信息...',
		showFooter:true,
		pageSize:10,  // 每页显示的记录条数
		pageList:[10,20,30],
		pagination:true
	});
	initScroll("#warddg");//初始化显示横向滚动条
	
}
//获取当前日期
function CurentTime()
{ 
	var now=new Date();
	var year=now.getFullYear();  //年
	var month=now.getMonth() + 1;  //月
	var day=now.getDate();  //日
	var clock=year+"-";
	
	if(month<10)
	clock+="0";
	clock+=month+"-";
	if(day<10)
	clock+="0";
	clock+=day;
 	return(clock);
}
