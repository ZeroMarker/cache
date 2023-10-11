//===========================================================================================
// 作者：      xww
// 编写日期:   2021-10-20
// 描述:	   运营中心
//===========================================================================================
var myDate = new Date(); 
var curYear = myDate.getFullYear()
var curDate = myDate.Format("yyyy-MM-dd");
/// 页面初始化函数
function initPageDefault(){
	
	/// 初始化服务机构数量
	InitTypeTotal();	 
	
	/// 最新发布药品
	InitMainGrid();
	
	/// 中成药数量统计
	InitChineseDrugChart();
	
	/// 药品类型分布
	InitTrendChart();
	
	/// 西药数量统计
	InitPropChart();

	/// 每月新增规则数量
	InitRuleChart();
	
	/// 本月药品发布情况
	InitConfirmDrug();
	
	/// 指标情况
	InitData();	
}

function InitData(){

	runClassMethod("web.DHCCKBOperationCenter","QueryRuleNum",{},function(jsonString){
		$("#RuleCount").html(jsonString);
	
	},'')
	
	runClassMethod("web.DHCCKBOperationCenter","GetAuditProjectNum",{},function(jsonString){
		$("#ProjectCount").html(jsonString);
	
	},'')
	
	
}

/// 自动设置图片展示区分布
function onresize_handler(){
	return;
	var Width = document.body.offsetWidth;
	//var imgWidth = (Width - 144)/6;
	var imgWidth = (Width - 132)/6;
	$(".pf-nav-item").width(imgWidth);
}

/// Author:	xww
/// Date:	2021-10-20
///	Desc:	初始化服务机构数量
function InitTypeTotal(){

	runClassMethod("web.DHCCKBOperationCenter","QueryHospNum",{},function(jsonString){
		$("#Hosp").html(jsonString);
	
	},'json',false)
}

/// 本月药品发布情况
function InitConfirmDrug(){

	runClassMethod("web.DHCCKBOperationCenter","QueryConfirmDrug",{"params":curDate},function(jsonString){
		var data=jsonString.split("^")
		$("#confirmNum").html(data[0]);
		$("#unconfirmNum").html(data[1]);
	},'',false)
}


/// 中成药数量统计
function InitChineseDrugChart(){	
	
	runClassMethod("web.DHCCKBOperationCenter","QueryChineseDrugByType",{"code":"中成药分类"},function(jsonString){
		
		if (jsonString != null){
			var ListDataObj = jsonString; ///jQuery.parseJSON(jsonString);
			/*var option = ECharts.ChartOptionTemplates.Bars(ListDataObj); 
			option.title ={
				text: '', ///'审查指标趋势图',
				subtext: '', ///'饼状图',
				x:'left'
			}
			
			
			
			var container = document.getElementById('ChineseDrugCharts');
			opt = ECharts.ChartConfig(container, option);
			ECharts.Charts.RenderChart(opt);*/
			var nameArr=[],valueArr=[];
			for(var i =0;i<ListDataObj.length;i++){ 
           	
				var name=ListDataObj[i].name;
				nameArr.push(name)
				var value=ListDataObj[i].value;
				valueArr.push(value)
			}
			
			var myChart = echarts.init(document.getElementById('ChineseDrugCharts'));
	        // 指定图表的配置项和数据
	        var option = {
		        //color: ['#003366', '#006699', '#4cabce', '#e5323e',#3F79BF],
		        color: ['#3F79BF'],
	            title: {
	                text: ''
	            },
	            grid: {
			        x: 60,
			        y: 42,
			        x2: 40,
			        y2: 32,
			        backgroundColor: 'rgba(0,0,0,0)',
			        borderWidth: 1,
			        borderColor: '#ccc'
			    },
	            tooltip: {},
	            legend: {
	                data:['单位:种'],
	                x:'right'
	            },
	            xAxis: {
	                data: nameArr
	            },
	            yAxis : 
        {
            type : 'value',
            name:"单位:种",
            nameLocation:'end',
            nameTextStyle:{
	            
	        }
        },
	            series: [{
	                name: '单位:种',
	                type: 'bar',
	                data: valueArr
	            }]
	        };
	        // 使用刚指定的配置项和数据显示图表。
        	myChart.setOption(option);
			
		}
	},'json',false)
}

/// 药品类型分布
function InitTrendChart(){

	runClassMethod("web.DHCCKBOperationCenter","QueryDrugNumByType",{},function(jsonString){
		
		if (jsonString != null){
			var total = jsonString.total;
			var drugCount = jsonString.drugCount; 
			var chineseDrugCount = jsonString.chineseDrugCount; 
			var chineseHMCount = jsonString.chineseHMCount; 
			var chinaMedPrescCount = jsonString.chinaMedPrescCount; 
			$("#TotalDrug").html(total) ;
			$("#Drug").html(drugCount) 
			$("#ChineseDrug").html(chineseDrugCount) 
			$("#chineseHMCount").html(chineseHMCount) 
			$("#chinaMedPrescCount").html(chinaMedPrescCount) 
			var ListDataObj = jsonString.drugstat; ///jQuery.parseJSON(jsonString);
			var option = ECharts.ChartOptionTemplates.Pie(ListDataObj); 
			option.title ={
				text: '', ///'审查指标趋势图',
				subtext: '', ///'饼状图',
				x:'center'
			}
			var container = document.getElementById('TrendCharts');
			opt = ECharts.ChartConfig(container, option);
			ECharts.Charts.RenderChart(opt);
		}
	},'json')
}

/// 西药数量统计
function InitPropChart(){
	
	runClassMethod("web.DHCCKBOperationCenter","QueryChineseDrugByType",{"code":"NewDrugCat"},function(jsonString){
		
		if (jsonString != null){
			var ListDataObj = jsonString; ///jQuery.parseJSON(jsonString);
			/*var option = ECharts.ChartOptionTemplates.Bars(ListDataObj); 
			option.title ={
				text: '', ///'审查指标趋势图',
				subtext: '', ///'饼状图',
				x:'left'
			}
			var container = document.getElementById('DrugCharts');
			opt = ECharts.ChartConfig(container, option);
			ECharts.Charts.RenderChart(opt);*/
			var nameArr=[],valueArr=[];
			for(var i =0;i<ListDataObj.length;i++){ 
           	
				var name=ListDataObj[i].name;
				nameArr.push(name)
				var value=ListDataObj[i].value;
				valueArr.push(value)
			}
			
			var myChart = echarts.init(document.getElementById('DrugCharts'));
	        // 指定图表的配置项和数据
	        var option = {
		        //color: ['#003366', '#006699', '#4cabce', '#e5323e',#3F79BF],
		        color: ['#3F79BF'],
	            title: {
	                text: ''
	            },
	            grid: {
			        x: 60,
			        y: 42,
			        x2: 40,
			        y2: 32,
			        backgroundColor: 'rgba(0,0,0,0)',
			        borderWidth: 1,
			        borderColor: '#ccc'
			    },
	            tooltip: {},
	            legend: {
	                data:['单位:种'],
	                x:'right'
	            },
	            axisLabel:{
		            interval:0,
		         formatter: function(params) {
                var newParamsName = ''
                var paramsNameNumber = params.length
                var provideNumber = 5
                var rowNumber = Math.ceil(paramsNameNumber / provideNumber)
                for (var row = 0; row < rowNumber; row++) {
                  newParamsName +=
                    params.substring(
                      row * provideNumber,
                      (row + 1) * provideNumber
                    ) + '\n'
                }
                return newParamsName
              }
		         },
	            xAxis: {
	                data: nameArr,
	                
	            },
	            yAxis : 
		        {
		            type : 'value',
		            name:"单位:种",
		            nameLocation:'end',
		            nameTextStyle:{
			            
			        }
		        },
	            series: [{
	                name: '单位:种',
	                type: 'bar',
	                data: valueArr
	            }]
	        }
	        // 使用刚指定的配置项和数据显示图表。
        	myChart.setOption(option);
		}
	},'json')
}

/// 页面DataGrid初始定义已选列表
function InitMainGrid(){
	
	///  定义columns
	var columns=[[
		{field:'dicDrugDesc',title:'药品',width:150,align:'left'},
		{field:'dicDateTime',title:'发布时间',width:150,align:'left'},
		{field:'dicUser',title:'发布医师',width:80,align:'left'},
	
	]];
	
	///  定义datagrid
	var option = {
		//showHeader:false,
		rownumbers:false,
		singleSelect:true,
		pagination:false,
		fit:true,
		toolbar:[],
	    onDblClickRow: function (rowIndex, rowData) {
			
        },
	    onLoadSuccess: function (data) { //数据加载完毕事件
        }
	};
	var uniturl = $URL+"?ClassName=web.DHCCKBOperationCenter&MethodName=QueryNewReleaseDrug";
	new ListComponent('NewRelease', columns, uniturl, option).Init();
}


/// 每月新增规则数量
function InitRuleChart(){	
	
	runClassMethod("web.DHCCKBOperationCenter","StatAllRuleByMon",{},function(data){
		var TempArr=[],YearArr=[],DataArr=[]
    	var yeatArr=[curYear,curYear-1];
		for(var i =0;i<yeatArr.length;i++){ 
           DataArr[i]=(data[yeatArr[i]]).split(",");  //字符串转数组
			var obj={}
			obj.name=yeatArr[i]
			obj.type='line'
			obj.data= DataArr[i]     
			TempArr.push(obj)
			YearArr.push(yeatArr[i])
		}
		MonQuartCompare=echarts.init(document.getElementById('MonQuartCompare'));
		InitMonthCompare(YearArr,TempArr,MonQuartCompare) // 按月统计
	},'json')
}

 //按月统计	
function InitMonthCompare(YearArr,TempArr,MonQuartCompare){

	option = {
		//color: ['#003366', '#006699', '#4cabce', '#e5323e',#3F79BF],
    	title : {
        	text:'',
        	x:'center'
       
    	},
	    tooltip: {
	        trigger: 'axis'
	    },
	    
	   legend: {
              data:YearArr, //['2017','2018']
              x:'right'
              /*x:150,
              y:30*/
       },
	    toolbox: {
	        show: false,
	        feature: {
	            /* dataZoom: {
	                yAxisIndex: 'none'
	            },
	            dataView: {readOnly: false}, */
	            magicType: {type: ['line', 'bar']},
	            restore: {},
	            saveAsImage: {}
	        }
	    },
    	calculable : true,
    	xAxis : [
        	{
	        	name:"",
            	type : 'category',
            	data : ["1月","2月","3月","4月","5月","6月","7月","8月","9月","10月","11月","12月"]  //,"合计"
        	}
    	],
    	yAxis : [
        {
            type : 'value',
            name:"单位/次",
            nameLocation:'end',
            nameTextStyle:{
	            
	        }
        }
    	],
    	series :TempArr
   	 }
   	 MonQuartCompare.clear();
     MonQuartCompare.setOption(option);
	
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
