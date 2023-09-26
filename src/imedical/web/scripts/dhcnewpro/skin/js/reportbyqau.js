// Creator: yangyongtao
// CreateDate: 2017-09-20
// Descript: 不良事件季度统计 

var url = "dhcadv.repaction.csp";

 $(function(){
	 
	 //年份
	$("#yearChoose").combobox({   
      valueField:'year',    
      textField:'year' 
      //panelHeight:'auto' //auto设置容器高度自动增长,(设置固定长度显示竖滚动条)
 
     });   	
   var data = [];//创建年度数组
   var startYear;//起始年份
   var thisYear=new Date().getUTCFullYear();//今年
   var endYear=thisYear+1;//结束年份
   //数组添加值（2006-2016）//根据情况自己修改
   for(startYear=endYear-10;startYear<endYear;startYear++)
    {
         data.push({"year":startYear});
    }
   
   $("#yearChoose").combobox("setValue", thisYear); //默认当前年
   
   $("#yearChoose").combobox("loadData", data);//下拉框加载数据
       
   

	//报告类型
	$('#type').combobox({
		//panelHeight:"auto",  //设置容器高度自动增长
		url:url+'?action=selEvent'	
	});
	
	
 	//复选框按钮事件
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
		});
	});
		
	$('#Find').bind("click",Query);  //点击查询
	StatAllRepByQau(); //初始化统计列表	
	
})
	
//查询
 function Query()
{
	//1、清空datagrid 
	$('#maindg').datagrid('loadData', {total:0,rows:[]}); 
	//2、查询
	//季度信息
	 var SeasonCode="";
    if($("#seaone").is(':checked')){
	    SeasonCode+='1,';
	}; //第一季度
    if($("#seatwo").is(':checked')){
	    SeasonCode+='2,';
	}; //第二季度
    if($("#seathree").is(':checked')){
	    SeasonCode+='3,';
    }; //第三季度
    if($("#seafour").is(':checked')){
	    SeasonCode+='4,';
	}; //第四季度
	SeasonCode=SeasonCode==''?'':SeasonCode.substring(0,SeasonCode.length-1); 
	
	var yearCode=$('#yearChoose').combobox('getValue');  //年份
	var typeCode=$('#type').combobox('getValue');  //报告类型
	if(typeof typeCode == "undefined"){typeCode=""}	//如果类型没有定义，就赋值为空	
	var params=yearCode+"^"+typeCode+"^"+SeasonCode;
	//(function(){
		$('#maindg').datagrid({
			url:'dhcapp.broker.csp?ClassName=web.DHCADVREPBYQAU&MethodName=QueryRepByQau',
			//url:url+'?action=StatAllRepByQau',	
			queryParams:{
				params:params}
		});
	//})();
	$.ajax({
		type: "POST",
		url:'dhcapp.broker.csp?ClassName=web.DHCADVREPBYQAU&MethodName=AnalysisRepByQau'+'&params='+params,
		//url: url+"?action=AnalysisRepByQau&params="+params,
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


	//复选框按钮事件
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			setCheckBoxRelation(this.id);
		});
	});


//初始化统计列表
function StatAllRepByQau()
{
	//定义columns
	var columns=[[
		{field:"name",title:'季度',width:169,align:'center'},
		{field:'value',title:'数量',width:169,align:'center'},
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
	initScroll("#maindg");//初始化显示横向滚动条
	$('#maindg').datagrid('loadData', {total:0,rows:[]}); 
}
