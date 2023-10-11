var myDate = new Date(); 
var curYear = myDate.getFullYear();
var orderArr =[{'id':'asc','text':'正序'},{'id':'desc','text':'逆序'}]
var Pid=""
/// 页面初始化函数
function initPageDefault(){
	IntPid();
	InitDateBox();
	InitComBoBox();
	InitMethod();
	InitMainGrid();
	//InitTodayAudit();
}

function IntPid(){
	$cm({
		ClassName:"web.DHCPRESCCommonUtil",
		MethodName:"NewPid",
	},function(jsonData){
		Pid=jsonData;
		
		Query();
		initEcharts()	

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

function InitTodayAudit(){
	$cm({
		ClassName:"web.DHCPRESCInterventQueryByLoc",
		MethodName:"GetDynamic",
	},function(jsonData){
		$('.ui-span').each(function(){
			$(this).text(jsonData[this.id]);
		})
	});
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
	
	$("#searchBtn").on('click',function(){
		Query();
		initEcharts()
	})
	
}
function initEcharts(){
	InitSysAndHumanPassChart("asc")  
	InitSystemPassChart("asc")
	InitHumanPassChart("asc")
	InitDoublePassChart("asc")

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

function InitDateBox(){
	$HUI.datebox("#stDate").setValue(formatDate(0));
	$HUI.datebox("#endDate").setValue(formatDate(0));
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
			SetSysAndHumanReview()
			InitSysAndHumanPassChart(option.id)  

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
			SetSystemReview()
			InitSystemPassChart(option.id)

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
			SetHumanReview()
			InitHumanPassChart(option.id)

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
			SetDoubleReview()
			InitDoublePassChart(option.id)
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

/// 页面DataGrid初始定义已选列表
function InitMainGrid(){
	
	///  定义columns
	var columns=[[
		{field:'Doc',title:'医生(科室)',width:200},
		{field:'DocTotalNum',title:'处方开具次数',width:200},
		{field:'DocHook',title:'系统审查拦截次数(率)',width:200},
		{field:'DocNoPass',title:'系统审查不通过次数(率)',width:200},
		{field:'DocAudit',title:'医生选择药师审核次数(率)',width:200},
		{field:'DocHumanNoPass',title:'药师审核后不通过次数(率)',width:200},
		{field:'DocHumanDouble',title:'双签执行次数(率)',width:200},
		{field:'DocHumanReturn',title:'返回修改次数(率)',width:200},
	]];
	
	///  定义datagrid
	var option = {
		toolbar:'#toolbar',
		rownumbers:false,
		singleSelect:true,
		pagination:true,
		fit:true,
		fitColumns:false,
		pageSize:10,
		pageList:[10,30,60],
	    onDblClickRow: function (rowIndex, rowData) {
        },
	    onLoadSuccess: function (data) {
		    $("#Hook").text(data.Hook);
		    $("#HumanDouble").text(data.HumanDouble);
		    $("#HumanRefuse").text(data.HumanRefuse);
		    $("#LocNum").text(data.LocNum);
		    $("#NoPass").text(data.NoPass);
		    $("#TotalNum").text(data.TotalNum);
        }
	};
	
	var stdate = $HUI.datebox("#stDate").getValue();
	var enddate = $HUI.datebox("#endDate").getValue();
	var loc= $HUI.combobox("#loc").getText();
	var params = stdate + "^" + enddate + "^" + loc+"^"+Pid;
	var uniturl = $URL+"?ClassName=web.DHCPRESCInterventQuery&MethodName=QueryByDoc&Params="+params;
	new ListComponent('datagird', columns, uniturl, option).Init();
	
}

/// 系统审查通过率排行
function InitSystemPassChart(order){	
	var HumanPassObj="[]"
	var stdate = $HUI.datebox("#stDate").getValue();
	var enddate = $HUI.datebox("#endDate").getValue();
	var loc= $HUI.combobox("#loc").getText();
	//var order = $HUI.combobox("#orderPerson").getValue()

	var params = stdate + "^" + enddate +"^"+order+"^"+Pid;
	runClassMethod("web.DHCPRESCInterventQuery","jsonSystemReview",{"Params":params},function(jsonString){
		if (jsonString != null){
			HumanPassObj = jsonString;
			var myChart = echarts.init(document.getElementById('orderSysRate'));

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

/// 系统审查通过率排行
function SetSystemReview(){
	HumanPassObj=[{name:"",value:""}]	
	var myChart = echarts.init(document.getElementById('orderSysRate'));
    option = {
	  dataset: [
	    {
	      dimensions: ['name', 'value'],
	      source:HumanPassObj
	    },
	    {
	      transform: {
	        type: 'sort',
	        config: { dimension: 'value', order:  'asc' }
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

/// 人工审核通过率排行
function InitHumanPassChart(order){	
	var HumanPassObj="[]"
	var stdate = $HUI.datebox("#stDate").getValue();
	var enddate = $HUI.datebox("#endDate").getValue();
	var loc= $HUI.combobox("#loc").getText();
	//var order = $HUI.combobox("#orderPerson").getValue()

	var params = stdate + "^" + enddate +"^"+order+"^"+Pid;
	runClassMethod("web.DHCPRESCInterventQuery","jsonHumanReview",{"Params":params},function(jsonString){
		if (jsonString != null){
			HumanPassObj = jsonString;
			var myChart = echarts.init(document.getElementById('moncharts'));

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
function SetHumanReview(){
	HumanPassObj=[{name:"",value:""}]	
	var myChart = echarts.init(document.getElementById('moncharts'));
    option = {
	  dataset: [
	    {
	      dimensions: ['name', 'value'],
	      source:HumanPassObj
	    },
	    {
	      transform: {
	        type: 'sort',
	        config: { dimension: 'value', order:  'asc' }
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
/// 总审核通过率排行
function InitSysAndHumanPassChart(order){	
	var HumanPassObj="[]"
	var stdate = $HUI.datebox("#stDate").getValue();
	var enddate = $HUI.datebox("#endDate").getValue();
	var loc= $HUI.combobox("#loc").getText();
	//var order = $HUI.combobox("#orderPerson").getValue()

	var params = stdate + "^" + enddate +"^"+order+"^"+Pid;
	runClassMethod("web.DHCPRESCInterventQuery","jsonSysAndHumanReview",{"Params":params},function(jsonString){
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

/// 总审核通过率排行
function SetSysAndHumanReview(){
	HumanPassObj=[{name:"",value:""}]	
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
	        config: { dimension: 'value', order:  'asc' }
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
/// 双签执行率排行
function InitDoublePassChart(order){	
	var HumanPassObj="[]"
	var stdate = $HUI.datebox("#stDate").getValue();
	var enddate = $HUI.datebox("#endDate").getValue();
	var loc= $HUI.combobox("#loc").getText();
	//var order = $HUI.combobox("#orderPerson").getValue()

	var params = stdate + "^" + enddate +"^"+order+"^"+Pid;
	runClassMethod("web.DHCPRESCInterventQuery","jsonDoubleReview",{"Params":params},function(jsonString){
		if (jsonString != null){
			HumanPassObj = jsonString;
			var myChart = echarts.init(document.getElementById('orderRate'));

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
function SetDoubleReview(){
	HumanPassObj=[{name:"",value:""}]	
	var myChart = echarts.init(document.getElementById('orderRate'));
    option = {
	  dataset: [
	    {
	      dimensions: ['name', 'value'],
	      source:HumanPassObj
	    },
	    {
	      transform: {
	        type: 'sort',
	        config: { dimension: 'value', order:  'asc' }
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