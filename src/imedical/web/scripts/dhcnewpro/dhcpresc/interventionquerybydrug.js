//===========================================================================================
// 作者：      xww
// 编写日期:   2022-02-11
// 描述:	   运营中心
//===========================================================================================
var myDate = new Date(); 
var curYear = myDate.getFullYear()
var curDate = myDate.Format("yyyy-MM-dd");
var orderArr =[{'id':'asc','text':'正序'},{'id':'desc','text':'逆序'}]
var Pid=""
/// 页面初始化函数
function initPageDefault(){
	IntPid();
	
	/// 初始化ComBoBox数量
	InitComBoBox();
	
	/// 初始化DateBox数量
	InitDateBox();
	
	InitMethod()
	
	/// 详细数据
	InitMainGrid();
	

	
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

function initEcharts(){
	InitDrugPassAllChart('asc');
    InitDrugPassChart('asc');
    InitHumanPassChart('asc');
    InitHumanDoubleChart('asc');
}

function InitComBoBox(){
	//查询科室
	$('#loc').combobox({
		url:$URL+'?ClassName=web.DHCPRESCCommonUtil&MethodName=GetLoc&HospID='+LgHospID,
		valueField: 'value',
		textField: 'text',
		mode:'remote',
		blurValidValue:true
	})
	$HUI.combobox("#orderPresc",{
		valueField:'id',
		textField:'text',
		panelHeight:'auto',
		data:orderArr,
		onSelect:function(option){
			InitDrugPassAllChart(option.id);
	    },
	    onLoadSuccess:function(data){
			$HUI.combobox("#orderPresc").setValue(data[0].text);   
		}	
	})
	
	$HUI.combobox("#orderSys",{
		valueField:'id',
		textField:'text',
		panelHeight:'auto',
		data:orderArr,
		onSelect:function(option){
			InitDrugPassChart(option.id);
	    },
	    onLoadSuccess:function(data){
			$HUI.combobox("#orderSys").setValue(data[0].text);   
		}	
	})
	
	$HUI.combobox("#orderPerson",{
		valueField:'id',
		textField:'text',
		panelHeight:'auto',
		data:orderArr,
		onSelect:function(option){
			InitHumanPassChart(option.id);
			//SetHumanPassChart(option.id);
	    },
	    onLoadSuccess:function(data){
			$HUI.combobox("#orderPerson").setValue(data[0].text);   
		}	
	})
	
	$HUI.combobox("#orderDouble",{
		valueField:'id',
		textField:'text',
		panelHeight:'auto',
		data:orderArr,
		onSelect:function(option){
			InitHumanDoubleChart(option.id);
	    },
	    onLoadSuccess:function(data){
			$HUI.combobox("#orderDouble").setValue(data[0].text);   
		}	
	})
	
	$("#checkYear,#checkYearPresc,#checkYearSys,#checkYearPerson,#checkYearDouble").combobox({   
		valueField:'year',    
		textField:'year',  
		panelHeight:'auto'
	});
	var yearArr=[];
	for(startYear=2022;startYear<=curYear;startYear++){ 
		yearArr.push({"year":startYear});   //从2022年开始
	}
	$("#checkYear,#checkYearPresc,#checkYearSys,#checkYearPerson,#checkYearDouble").combobox("loadData", yearArr);//下拉框加载数据
	$("#checkYear,#checkYearPresc,#checkYearSys,#checkYearPerson,#checkYearDouble").combobox("setValue",curYear);//设置默认值为今年
}

function InitDateBox(){
	$HUI.datebox("#stDate").setValue(formatDate(0));
	$HUI.datebox("#endDate").setValue(formatDate(0));
}

/// 自动设置图片展示区分布
function onresize_handler(){
	
	var Width = document.body.offsetWidth;
	//var imgWidth = (Width - 144)/6;
	var imgWidth = (Width - 128)/6;
	$(".pf-nav-item").width(imgWidth);
}



/// 页面DataGrid初始定义已选列表
function InitMainGrid(){
	
	///  定义columns
	var columns=[[
		{field:'DrugSign',title:'药品标识名称',width:150,align:'left'},
		{field:'DrugTotalNum',title:'处方开具次数',width:200},
		{field:'DrugHook',title:'系统审查拦截次数(率)',width:200},
		{field:'DrugNoPass',title:'系统审查不通过次数(率)',width:200},
		{field:'DrugAudit',title:'医生选择药师审核次数(率)',width:200},
		{field:'DrugHumanNoPass',title:'药师审核后不通过次数(率)',width:200},
		{field:'DrugHumanDouble',title:'双签执行次数(率)',width:200},
		{field:'DrugHumanReturn',title:'返回修改次数(率)',width:200},
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
	    	$("#MonitorDrugNum").text(data.DrugSignNum);
		    $("#PrescAvgDrugNum").text(data.PrescAvgNum);
		    $("#QueErrAvgNum").text(data.QueErrAvgNum);
		    $("#PrescAvgDayNum").text(data.PrescTrementAvgNum);
		    $("#ChineseDrugNum").text(data.DrugDataNum);
		    $("#ChinaMedPrescNUm").text(data.ChineseDrugDataNum);
        }
	};
	var stdate = $HUI.datebox("#stDate").getValue();
	var enddate = $HUI.datebox("#endDate").getValue();
	var loc= $HUI.combobox("#loc").getText();
	var params = stdate + "^" + enddate + "^" + loc+"^"+Pid;
	var uniturl = $URL+"?ClassName=web.DHCPRESCInterventQueryByDrug&MethodName=QueryByDrug&Params="+params;
	new ListComponent('datagird', columns, uniturl, option).Init();
}




function InitMethod(){
	/*$("#curDay").on('click',function(){	
		if($("#curDay").css("background-color")=="rgb(204, 204, 204)"){
			$("#curDay").css("background-color","blue")
			$("#curMonth").css("background-color","rgb(204, 204, 204)")
			$("#curYear").css("background-color","rgb(204, 204, 204)")
		}
	})
	
	$("#curMonth").on('click',function(){	
		if($("#curMonth").css("background-color")=="rgb(204, 204, 204)"){
			$("#curMonth").css("background-color","blue")
			$("#curDay").css("background-color","rgb(204, 204, 204)")
			$("#curYear").css("background-color","rgb(204, 204, 204)")
		}
	})
	$("#curYear").on('click',function(){	
		if($("#curYear").css("background-color")=="rgb(204, 204, 204)"){
			$("#curYear").css("background-color","blue")
			$("#curMonth").css("background-color","rgb(204, 204, 204)")
			$("#curDay").css("background-color","rgb(204, 204, 204)")
		}
	})*/
	$("#curDay").on('click',function(){	
		if($("#curDay").hasClass("uncheck")){ 	
			$("#curDay").toggleClass("uncheck");
		}
		if($("#curMonth").hasClass("uncheck")){ 
		}else{
			$("#curMonth").addClass("uncheck");		
		}
		if($("#curYear").hasClass("uncheck")){ 
		}else{
			$("#curYear").addClass("uncheck");		
		}
	})
	
	$("#curMonth").on('click',function(){
		if($("#curMonth").hasClass("uncheck")){ 	
			$("#curMonth").toggleClass("uncheck");
		};
		if($("#curDay").hasClass("uncheck")){ 
		}else{
			$("#curDay").addClass("uncheck");		
		}
		if($("#curYear").hasClass("uncheck")){ 			
		}else{
			$("#curYear").addClass("uncheck");		
		}
		
	})
	$("#curYear").on('click',function(){	
		if($("#curYear").hasClass("uncheck")){ 	
			$("#curYear").toggleClass("uncheck");
		};
		if($("#curDay").hasClass("uncheck")){ 		
		}else{
			$("#curDay").addClass("uncheck");		
		}
		if($("#curMonth").hasClass("uncheck")){ 	
		}else{
			$("#curMonth").addClass("uncheck");		
		}
	})
	
	$("#searchBtn").on('click',function(){
		Query();
		initEcharts();
	})
	
}

function Query(){
	var stdate = $HUI.datebox("#stDate").getValue();
	var enddate = $HUI.datebox("#endDate").getValue();
	var loc= $HUI.combobox("#loc").getText();
	var params = stdate + "^" + enddate + "^" + loc +"^"+Pid;
	$('#datagird').datagrid('load',{
		Params:params
	}); 
}


/// 人工审核通过率排行
function InitHumanPassChart(order){	
	var stdate = $HUI.datebox("#stDate").getValue();
	var enddate = $HUI.datebox("#endDate").getValue();
	var loc= $HUI.combobox("#loc").getText();
	var params = stdate + "^" + enddate +"^"+order+"^"+Pid;
	runClassMethod("web.DHCPRESCInterventQueryByDrug","QueryHumanPass",{"Params":params},function(jsonString){
		if (jsonString != null){
			HumanPassObj = jsonString;
			var myChart = echarts.init(document.getElementById('HumanPass'));
			/*var nameArr=[],valueArr=[];
			for(var i =0;i<ListDataObj.length;i++){ 
				var name=ListDataObj[i].name;
				nameArr.push(name)
				var value=ListDataObj[i].value;
				valueArr.push(value)
			}
			
	        // 指定图表的配置项和数据
	        var option = {
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
	            yAxis : {
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
	        }; */
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
	},'json')
}

/*// 人工审核通过率排行set
function SetHumanPassChart(orderType){	
	var myChart = echarts.init(document.getElementById('HumanPass'));
    option = {
	  dataset: [
	    {
	      dimensions: ['name', 'value'],
	      source:HumanPassObj
	    },
	    {
	      transform: {
	        type: 'sort',
	        config: { dimension: 'value', order: orderType }
	      }
	    }
	  ],
	  xAxis: {
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
}*/

/// 双签执行率排行
function InitHumanDoubleChart(order){	
	var stdate = $HUI.datebox("#stDate").getValue();
	var enddate = $HUI.datebox("#endDate").getValue();
	var loc= $HUI.combobox("#loc").getText();
	var Params = stdate + "^" + enddate +"^"+order+"^"+Pid;
	runClassMethod("web.DHCPRESCInterventQueryByDrug","QueryHumanDouble",{"Params":Params},function(jsonString){
		if (jsonString != null){
			HumanDoubleObj = jsonString;
			var myChart = echarts.init(document.getElementById('HumanDoubleChart'));
	        option = {
			  dataset: [
			    {
			      dimensions: ['name', 'value'],
			      source:HumanDoubleObj
			    },
			    {
			      transform: {
			        type: 'sort',
			        config: { dimension: 'value', order: order }
			      }
			    }
			  ],
			  xAxis: {
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
	},'json')
}

/*// 双签执行率排行set
function SetHumanDoubleChart(orderType){	
	var myChart = echarts.init(document.getElementById('HumanDoubleChart'));
    option = {
	  dataset: [
	    {
	      dimensions: ['name', 'value'],
	      source:HumanDoubleObj
	    },
	    {
	      transform: {
	        type: 'sort',
	        config: { dimension: 'value', order: orderType }
	      }
	    }
	  ],
	  xAxis: {
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
}*/

/// 处方总通过率排行
function InitDrugPassAllChart(order){	
	var stdate = $HUI.datebox("#stDate").getValue();
	var enddate = $HUI.datebox("#endDate").getValue();
	var loc= $HUI.combobox("#loc").getText();
	var params = stdate + "^" + enddate +"^"+order+"^"+Pid;
	runClassMethod("web.DHCPRESCInterventQueryByDrug","QueryLocPassAll",{"Params":params},function(jsonString){
		if (jsonString != null){
			LocPassAllObj = jsonString;
			var myChart = echarts.init(document.getElementById('LocPassAll'));
	        option = {
			  dataset: [
			    {
			      dimensions: ['name', 'value'],
			      source:LocPassAllObj
			    },
			    {
			      transform: {
			        type: 'sort',
			        config: { dimension: 'value', order: order }
			      }
			    }
			  ],
			  xAxis: {
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
	},'json')
}

/*// 处方总通过率排行set
function SetLocPassAllChart(orderType){	
	var myChart = echarts.init(document.getElementById('LocPassAll'));
    option = {
	  dataset: [
	    {
	      dimensions: ['name', 'value'],
	      source:LocPassAllObj
	    },
	    {
	      transform: {
	        type: 'sort',
	        config: { dimension: 'value', order: orderType }
	      }
	    }
	  ],
	  xAxis: {
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
}*/

/// 系统审查通过率排行
function InitDrugPassChart(order){	
	var stdate = $HUI.datebox("#stDate").getValue();
	var enddate = $HUI.datebox("#endDate").getValue();
	var loc= $HUI.combobox("#loc").getText();
	var params = stdate + "^" + enddate +"^"+order+"^"+Pid;
	runClassMethod("web.DHCPRESCInterventQueryByDrug","QueryLocPass",{"Params":params},function(jsonString){
		if (jsonString != null){
			LocPassObj = jsonString;
			var myChart = echarts.init(document.getElementById('LocPass'));
	        option = {
			  dataset: [
			    {
			      dimensions: ['name', 'value'],
			      source:LocPassObj
			    },
			    {
			      transform: {
			        type: 'sort',
			        config: { dimension: 'value', order: order }
			      }
			    }
			  ],
			  xAxis: {
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
	},'json')
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