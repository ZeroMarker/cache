//===========================================================================================
// ���ߣ�      xww
// ��д����:   2022-02-11
// ����:	   ��Ӫ����
//===========================================================================================
var myDate = new Date(); 
var curYear = myDate.getFullYear()
var curDate = myDate.Format("yyyy-MM-dd");
var orderArr =[{'id':'asc','text':'����'},{'id':'desc','text':'����'}]
var Pid=""
/// ҳ���ʼ������
function initPageDefault(){
	IntPid();
	
	/// ��ʼ��ComBoBox����
	InitComBoBox();
	
	/// ��ʼ��DateBox����
	InitDateBox();
	
	InitMethod()
	
	/// ��ϸ����
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
		yearArr.push({"year":startYear});   //��2022�꿪ʼ
	}
	$("#checkYear,#checkYearPresc,#checkYearSys,#checkYearPerson,#checkYearDouble").combobox("loadData", yearArr);//�������������
	$("#checkYear,#checkYearPresc,#checkYearSys,#checkYearPerson,#checkYearDouble").combobox("setValue",curYear);//����Ĭ��ֵΪ����
}

function InitDateBox(){
	$HUI.datebox("#stDate").setValue(formatDate(0));
	$HUI.datebox("#endDate").setValue(formatDate(0));
}

/// �Զ�����ͼƬչʾ���ֲ�
function onresize_handler(){
	
	var Width = document.body.offsetWidth;
	//var imgWidth = (Width - 144)/6;
	var imgWidth = (Width - 128)/6;
	$(".pf-nav-item").width(imgWidth);
}



/// ҳ��DataGrid��ʼ������ѡ�б�
function InitMainGrid(){
	
	///  ����columns
	var columns=[[
		{field:'DrugSign',title:'ҩƷ��ʶ����',width:150,align:'left'},
		{field:'DrugTotalNum',title:'�������ߴ���',width:200},
		{field:'DrugHook',title:'ϵͳ������ش���(��)',width:200},
		{field:'DrugNoPass',title:'ϵͳ��鲻ͨ������(��)',width:200},
		{field:'DrugAudit',title:'ҽ��ѡ��ҩʦ��˴���(��)',width:200},
		{field:'DrugHumanNoPass',title:'ҩʦ��˺�ͨ������(��)',width:200},
		{field:'DrugHumanDouble',title:'˫ǩִ�д���(��)',width:200},
		{field:'DrugHumanReturn',title:'�����޸Ĵ���(��)',width:200},
	]];
	
	///  ����datagrid
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
	    onLoadSuccess: function (data) { //���ݼ�������¼�
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


/// �˹����ͨ��������
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
			
	        // ָ��ͼ��������������
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
	                data:['��λ:��'],
	                x:'right'
	            },
	            xAxis: {
	                data: nameArr
	            },
	            yAxis : {
		            type : 'value',
		            name:"��λ:��",
		            nameLocation:'end',
		            nameTextStyle:{  
			        }
		        },
	            series: [{
	                name: '��λ:��',
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
	        // ʹ�ø�ָ�����������������ʾͼ��
        	myChart.setOption(option);
			
		}
	},'json')
}

/*// �˹����ͨ��������set
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
    // ʹ�ø�ָ�����������������ʾͼ��
	myChart.setOption(option);
}*/

/// ˫ǩִ��������
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
	        // ʹ�ø�ָ�����������������ʾͼ��
        	myChart.setOption(option);
			
		}
	},'json')
}

/*// ˫ǩִ��������set
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
    // ʹ�ø�ָ�����������������ʾͼ��
	myChart.setOption(option);
}*/

/// ������ͨ��������
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
	        // ʹ�ø�ָ�����������������ʾͼ��
        	myChart.setOption(option);
			
		}
	},'json')
}

/*// ������ͨ��������set
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
    // ʹ�ø�ָ�����������������ʾͼ��
	myChart.setOption(option);
}*/

/// ϵͳ���ͨ��������
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
	        // ʹ�ø�ָ�����������������ʾͼ��
        	myChart.setOption(option);
			
		}
	},'json')
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