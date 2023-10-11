var myDate = new Date(); 
var curYear = myDate.getFullYear();
var orderArr =[{'id':'asc','text':'����'},{'id':'desc','text':'����'}]
var Pid=""
/// ҳ���ʼ������
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
	
	//��ѯ����
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
		yearArr.push({"year":startYear});   //��2022�꿪ʼ
	}
	$("#checkYear,#checkYearPresc,#checkYearSys,#checkYearPerson,#checkYearDouble").combobox("loadData", yearArr);//�������������
	$("#checkYear,#checkYearPresc,#checkYearSys,#checkYearPerson,#checkYearDouble").combobox("setValue",curYear);//����Ĭ��ֵΪ����
	
}

/// ҳ��DataGrid��ʼ������ѡ�б�
function InitMainGrid(){
	
	///  ����columns
	var columns=[[
		{field:'Doc',title:'ҽ��(����)',width:200},
		{field:'DocTotalNum',title:'�������ߴ���',width:200},
		{field:'DocHook',title:'ϵͳ������ش���(��)',width:200},
		{field:'DocNoPass',title:'ϵͳ��鲻ͨ������(��)',width:200},
		{field:'DocAudit',title:'ҽ��ѡ��ҩʦ��˴���(��)',width:200},
		{field:'DocHumanNoPass',title:'ҩʦ��˺�ͨ������(��)',width:200},
		{field:'DocHumanDouble',title:'˫ǩִ�д���(��)',width:200},
		{field:'DocHumanReturn',title:'�����޸Ĵ���(��)',width:200},
	]];
	
	///  ����datagrid
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

/// ϵͳ���ͨ��������
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
	        // ʹ�ø�ָ�����������������ʾͼ��
        	myChart.setOption(option);
			
		}
	},'json',true)
}

/// ϵͳ���ͨ��������
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
    // ʹ�ø�ָ�����������������ʾͼ��
	myChart.setOption(option);
}

/// �˹����ͨ��������
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
	        // ʹ�ø�ָ�����������������ʾͼ��
        	myChart.setOption(option);
			
		}
	},'json',true)
}

/// �˹����ͨ��������
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
    // ʹ�ø�ָ�����������������ʾͼ��
	myChart.setOption(option);
}
/// �����ͨ��������
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
	        // ʹ�ø�ָ�����������������ʾͼ��
        	myChart.setOption(option);
			
		}
	},'json',true)
}

/// �����ͨ��������
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
    // ʹ�ø�ָ�����������������ʾͼ��
	myChart.setOption(option);
}
/// ˫ǩִ��������
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
	        // ʹ�ø�ָ�����������������ʾͼ��
        	myChart.setOption(option);
			
		}
	},'json',true)
}

/// ˫ǩִ��������
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
    // ʹ�ø�ָ�����������������ʾͼ��
	myChart.setOption(option);
}

/// �Զ�����ͼƬչʾ���ֲ�
function onresize_handler(){
	
	var Width = document.body.offsetWidth;
	//var imgWidth = (Width - 144)/6;
	var imgWidth = (Width - 128)/6;
	$(".pf-nav-item").width(imgWidth);
}
/// ҳ��ȫ���������֮�����(EasyUI������֮��)
function onload_handler() {
	/// �Զ�����ͼƬչʾ���ֲ�
	onresize_handler();
}

window.onload = onload_handler;
window.onresize = onresize_handler;
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })