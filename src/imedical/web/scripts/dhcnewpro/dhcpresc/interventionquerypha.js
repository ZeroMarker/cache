// 作者：      shy
// 编写日期:   2022-02-11
// 描述:	   药师处方审核统计
var myDate = new Date(); 
var curYear = myDate.getFullYear()
var curDate = myDate.Format("yyyy-MM-dd");
var orderArr =[{'id':'1','text':'正序'},{'id':'2','text':'逆序'}]
var Pid = "";
/// 页面初始化函数
function initPageDefault(){ 
	IntPid();
	InitDateBox();
	InitComBoBox();
	InitMainGrid();
	InitMethod();

	
}
function IntPid(){
	$cm({
		ClassName:"web.DHCPRESCCommonUtil",
		MethodName:"NewPid",
	},function(jsonData){
		Pid=jsonData;
		Query();
		initEcharts();
	});
	
	if(HISUIStyleCode==="lite"){
	    $(".keyscat").css({"color":"#339eff"});
	    $(".keysbyt").css({"border-color":"#339eff"});
	    $(".div-block-right").css({"border-left":"10px solid #F5F5F5"});
	    $(".panel-title").css({"height":"34px"});
	    $(".panel-title").css({"line-height":"34px"});
	}else{
		$(".keyscat").css({"color":"#017bce"});
	    $(".keysbyt").css({"border-color":"#017bce"});
	    $(".div-block-right").css({"border-left":"10px solid white"});
	}
}

/// 页面DataGrid初始定义已选列表
function InitMainGrid(){
	
	///  定义columns
	var columns=[[
		{field:'Pha',title:'药师名称',width:100,align:'left'},
		{field:'LocTotalNum',title:'处方开具次数',width:120,align:'left'},
		{field:'LocHook',title:'系统拦截次数(率)',width:180,align:'left'},
		{field:'LocNoPass',title:'系统审查不通过次数(率)',width:200,align:'left'},
		{field:'LocAudit',title:'医生选择药师次数(率)',width:200,align:'left'},
		{field:'LocHumanNoPass',title:'药师审核后不通过次数(率)',width:200,align:'left'},
		//{field:'phaRefusedNum',title:'药师审核后拒绝发药次数(率)',width:180,align:'left'},
		{field:'LocHumanDouble',title:'双签执行次数(率)',width:200,align:'left'},
		{field:'LocHumanReturn',title:'返回修改次数(率)',width:200,align:'left'}
	]];
			
	///  定义datagrid
	var option = {
		toolbar:'#toolbar',
		//showHeader:false,
		rownumbers:false,
		singleSelect:true,
		pagination:true,
		fit:true,
		fitColumns:true,
		pageSize:10,
		pageList:[10,30,60]	,
	    onDblClickRow: function (rowIndex, rowData) {
			
        },
	    onLoadSuccess: function (data) { //数据加载完毕事件
	    	$("#PhaNum").text(data.PhaNum);
		    $("#HumanDouble").text(data.HumanDouble);
		    $("#HumanRefuse").text(data.HumanRefuse);
		    $("#NoPass").text(data.NoPass);
		    $("#TotalNum").text(data.TotalNum);
		    $("#Hook").text(data.Hook);
        }
	};
	var stdate = $HUI.datebox("#stDate").getValue();
	var enddate = $HUI.datebox("#endDate").getValue();
	var pha= $("#pha").combobox('getText');
	var params = stdate + "^" + enddate + "^" + pha+"^"+Pid;
	var uniturl = $URL+"?ClassName=web.DHCPRESCInterventQuery&MethodName=JsGetInterventPha&Params="+params;
	new ListComponent('prescdatagird', columns, uniturl, option).Init();
}

function InitMethod(){

	$("#curDay").on('click',function(){	

			if($("#curDay").hasClass("uncheck")){ 	
				$("#curDay").toggleClass("uncheck");
			}
			if($("#curMonth").hasClass("uncheck")){ 
			
			}else
			{
				$("#curMonth").addClass("uncheck");		
			}
			if($("#curYear").hasClass("uncheck")){ 
			
			}else
			{
				$("#curYear").addClass("uncheck");		
			}
		
	})
	
	$("#curMonth").on('click',function(){
			if($("#curMonth").hasClass("uncheck")){ 	
				$("#curMonth").toggleClass("uncheck");
			};
			if($("#curDay").hasClass("uncheck")){ 
			
			}else
			{
				$("#curDay").addClass("uncheck");		
			}
			if($("#curYear").hasClass("uncheck")){ 
			
			}else
			{
				$("#curYear").addClass("uncheck");		
			}
		
	})
	$("#curYear").on('click',function(){	
		if($("#curYear").hasClass("uncheck")){ 	
			$("#curYear").toggleClass("uncheck");
		};
			
			if($("#curDay").hasClass("uncheck")){ 
			
			}else
			{
				$("#curDay").addClass("uncheck");		
			}
			if($("#curMonth").hasClass("uncheck")){ 
			
			}else
			{
				$("#curMonth").addClass("uncheck");		
			}
	})
	
	$("#searchBTN").on('click',function(){
		Query();
		initEcharts();
	})
	
}
function initEcharts(){
	InitSysAndHumanPassChart("asc")  
	InitPhaPassChart("asc")
	InitHumanPassChart("asc")
	InitDobHumanPassChart("asc")

	}
function Query(){
	var stdate = $HUI.datebox("#stDate").getValue();
	var enddate = $HUI.datebox("#endDate").getValue();
	var drugtype=$("#pha").combobox('getText')
	var params = stdate + "^" + enddate + "^" + drugtype+"^"+Pid;
	$('#prescdatagird').datagrid('load',{
		Params:params
	}); 
}

function InitDateBox(){
	$HUI.datebox("#stDate").setValue(formatDate(0));
	$HUI.datebox("#endDate").setValue(formatDate(0));
	
}

function InitComBoBox(){
	$HUI.combobox("#totalprescorder",{
		valueField:'id',
		textField:'text',
		data:orderArr,
		onSelect:function(option){
		   InitSysAndHumanPassChart(option.id)  
	    },
	    onLoadSuccess:function(data){
			$HUI.combobox("#totalprescorder").setValue(data[0].text);   
		}	
	})	
	
	$HUI.combobox("#doublecheckorder",{
		valueField:'id',
		textField:'text',
		data:orderArr,
		onSelect:function(option){
	       
	    },
	    onLoadSuccess:function(data){
			$HUI.combobox("#doublecheckorder").setValue(data[0].text);   
		}	
	})
	
	$HUI.combobox("#peopleauditorder",{
		valueField:'id',
		textField:'text',
		data:orderArr,
		onSelect:function(option){
	       
	    },
	    onLoadSuccess:function(data){
			$HUI.combobox("#peopleauditorder").setValue(data[0].text);   
		}	
	})
	
	$HUI.combobox("#sysauditorder",{
		valueField:'id',
		textField:'text',
		data:orderArr,
		onSelect:function(option){
	       
	    },
	    onLoadSuccess:function(data){
			$HUI.combobox("#sysauditorder").setValue(data[0].text);   
		}	
	})
	
	$HUI.combobox("#pha",{
		url:$URL+"?ClassName=web.DHCPRESCCommonUtil&MethodName=QueryPhaDescComb&hospId="+LgHospID ,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	       
	    },
	    onLoadSuccess:function(data){
			
		}	
	})
	
	/*$("#sysaudityear,#peopleaudityear,#doublecheckyear,#totalprescyear,#prescyear").combobox({   
		valueField:'year',    
		textField:'year',  
		panelHeight:'auto'
	});
	var yearArr=[];
	for(startYear=2021;startYear<=curYear;startYear++){ 
		yearArr.push({"year":startYear});   //从2021年开始
	}
	$("#sysaudityear,#peopleaudityear,#doublecheckyear,#totalprescyear,#prescyear").combobox("loadData", yearArr);//下拉框加载数据
	$("#sysaudityear,#peopleaudityear,#doublecheckyear,#totalprescyear,#prescyear").combobox("setValue",curYear);//设置默认值为今年*/
}
/// 药师处理处方数量排行
function InitPhaPassChart(order){	
	var HumanPassObj="[]"
	var stdate = $HUI.datebox("#stDate").getValue();
	var enddate = $HUI.datebox("#endDate").getValue();

	var params = stdate + "^" + enddate +"^"+order+"^"+Pid;
	runClassMethod("web.DHCPRESCInterventQuery","GetPhaPassData",{"Params":params},function(jsonString){
		if (jsonString != null){
			HumanPassObj = jsonString;
			var myChart = echarts.init(document.getElementById('phanum'));

	        option = {
			  dataset: [
			    {
			      dimensions: ['name', 'value'],
			      source:HumanPassObj
			    },
			    {
			      transform: {
			        type: 'sort',
			        config: { dimension: 'value', order:order}
			      }
			    }
			  ],
			  xAxis: {
				//data: nameArr
			    type: 'category',
			    axisLabel: { interval: 0, rotate: 30 }
			  },
			  yAxis: {},
			  series: {
			    type: 'bar',
			    encode: { x: 'name', y: 'value' },
			    datasetIndex: 1
			  }
			};
	        // 使用刚指定的配置项和数据显示图表。
        	myChart.setOption(option);
			
		}
	},'json',true)
}
/// 总审核通过率排行
function InitSysAndHumanPassChart(order){	
	var HumanPassObj="[]"
	var stdate = $HUI.datebox("#stDate").getValue();
	var enddate = $HUI.datebox("#endDate").getValue();

	var params = stdate + "^" + enddate +"^"+order+"^"+Pid;
	runClassMethod("web.DHCPRESCInterventQuery","GetSystemPassData",{"Params":params},function(jsonString){
		if (jsonString != null){
			HumanPassObj = jsonString;
			var myChart = echarts.init(document.getElementById('total'));

	        option = {
			  dataset: [
			    {
			      dimensions: ['name', 'value'],
			      source:HumanPassObj
			    },
			    {
			      transform: {
			        type: 'sort',
			        config: { dimension: 'value', order:order}
			      }
			    }
			  ],
			  xAxis: {
				//data: nameArr
			    type: 'category',
			    axisLabel: { interval: 0, rotate: 30 }
			  },
			  yAxis: {},
			  series: {
			    type: 'bar',
			    encode: { x: 'name', y: 'value' },
			    datasetIndex: 1
			  }
			};
	        // 使用刚指定的配置项和数据显示图表。
        	myChart.setOption(option);
			
		}
	},'json',true)
}
/// 人工审核通过率排行
function InitHumanPassChart(order){	
	var HumanPassObj="[]"
	var stdate = $HUI.datebox("#stDate").getValue();
	var enddate = $HUI.datebox("#endDate").getValue();

	var params = stdate + "^" + enddate +"^"+order+"^"+Pid;
	runClassMethod("web.DHCPRESCInterventQuery","GetPersonPassData",{"Params":params},function(jsonString){
		if (jsonString != null){
			HumanPassObj = jsonString;
			var myChart = echarts.init(document.getElementById('perpass'));

	        option = {
			  dataset: [
			    {
			      dimensions: ['name', 'value'],
			      source:HumanPassObj
			    },
			    {
			      transform: {
			        type: 'sort',
			        config: { dimension: 'value', order:order}
			      }
			    }
			  ],
			  xAxis: {
				//data: nameArr
			    type: 'category',
			    axisLabel: { interval: 0, rotate: 30 }
			  },
			  yAxis: {},
			  series: {
			    type: 'bar',
			    encode: { x: 'name', y: 'value' },
			    datasetIndex: 1
			  }
			};
	        // 使用刚指定的配置项和数据显示图表。
        	myChart.setOption(option);
			
		}
	},'json',true)
}
/// 双签执行率排行
function InitDobHumanPassChart(order){	
	var HumanPassObj="[]"
	var stdate = $HUI.datebox("#stDate").getValue();
	var enddate = $HUI.datebox("#endDate").getValue();

	var params = stdate + "^" + enddate +"^"+order+"^"+Pid;
	runClassMethod("web.DHCPRESCInterventQuery","GetDobPersonPassData",{"Params":params},function(jsonString){
		if (jsonString != null){
			HumanPassObj = jsonString;
			var myChart = echarts.init(document.getElementById('dobperpass'));

	        option = {
			  dataset: [
			    {
			      dimensions: ['name', 'value'],
			      source:HumanPassObj
			    },
			    {
			      transform: {
			        type: 'sort',
			        config: { dimension: 'value', order:order}
			      }
			    }
			  ],
			  xAxis: {
				//data: nameArr
			    type: 'category',
			    axisLabel: { interval: 0, rotate: 30 }
			  },
			  yAxis: {},
			  series: {
			    type: 'bar',
			    encode: { x: 'name', y: 'value' },
			    datasetIndex: 1
			  }
			};
	        // 使用刚指定的配置项和数据显示图表。
        	myChart.setOption(option);
			
		}
	},'json',true)
}

/// 自动设置图片展示区分布
function onresize_handler(){
	
	var Width = document.body.offsetWidth;
	//var imgWidth = (Width - 144)/6;
	var imgWidth = (Width - 128)/6;
	$(".pf-nav-item").width(imgWidth);
}
/// 页面全部加载完成之后调用(EasyUI解析完之后)
function onload_handler() {
	/// 自动设置图片展示区分布
	onresize_handler();
}

window.onload = onload_handler;
window.onresize = onresize_handler;
/// JQuery 初始化页面
$(function(){ initPageDefault(); })