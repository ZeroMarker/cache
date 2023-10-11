//===========================================================================================
// ���ߣ�      xww
// ��д����:   2021-10-20
// ����:	   ��Ӫ����
//===========================================================================================
var myDate = new Date(); 
var curYear = myDate.getFullYear()
var curDate = myDate.Format("yyyy-MM-dd");
/// ҳ���ʼ������
function initPageDefault(){
	
	/// ��ʼ�������������
	InitTypeTotal();	 
	
	/// ���·���ҩƷ
	InitMainGrid();
	
	/// �г�ҩ����ͳ��
	InitChineseDrugChart();
	
	/// ҩƷ���ͷֲ�
	InitTrendChart();
	
	/// ��ҩ����ͳ��
	InitPropChart();

	/// ÿ��������������
	InitRuleChart();
	
	/// ����ҩƷ�������
	InitConfirmDrug();
	
	/// ָ�����
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

/// �Զ�����ͼƬչʾ���ֲ�
function onresize_handler(){
	return;
	var Width = document.body.offsetWidth;
	//var imgWidth = (Width - 144)/6;
	var imgWidth = (Width - 132)/6;
	$(".pf-nav-item").width(imgWidth);
}

/// Author:	xww
/// Date:	2021-10-20
///	Desc:	��ʼ�������������
function InitTypeTotal(){

	runClassMethod("web.DHCCKBOperationCenter","QueryHospNum",{},function(jsonString){
		$("#Hosp").html(jsonString);
	
	},'json',false)
}

/// ����ҩƷ�������
function InitConfirmDrug(){

	runClassMethod("web.DHCCKBOperationCenter","QueryConfirmDrug",{"params":curDate},function(jsonString){
		var data=jsonString.split("^")
		$("#confirmNum").html(data[0]);
		$("#unconfirmNum").html(data[1]);
	},'',false)
}


/// �г�ҩ����ͳ��
function InitChineseDrugChart(){	
	
	runClassMethod("web.DHCCKBOperationCenter","QueryChineseDrugByType",{"code":"�г�ҩ����"},function(jsonString){
		
		if (jsonString != null){
			var ListDataObj = jsonString; ///jQuery.parseJSON(jsonString);
			/*var option = ECharts.ChartOptionTemplates.Bars(ListDataObj); 
			option.title ={
				text: '', ///'���ָ������ͼ',
				subtext: '', ///'��״ͼ',
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
	        // ָ��ͼ��������������
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
	                data:['��λ:��'],
	                x:'right'
	            },
	            xAxis: {
	                data: nameArr
	            },
	            yAxis : 
        {
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
	        };
	        // ʹ�ø�ָ�����������������ʾͼ��
        	myChart.setOption(option);
			
		}
	},'json',false)
}

/// ҩƷ���ͷֲ�
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
				text: '', ///'���ָ������ͼ',
				subtext: '', ///'��״ͼ',
				x:'center'
			}
			var container = document.getElementById('TrendCharts');
			opt = ECharts.ChartConfig(container, option);
			ECharts.Charts.RenderChart(opt);
		}
	},'json')
}

/// ��ҩ����ͳ��
function InitPropChart(){
	
	runClassMethod("web.DHCCKBOperationCenter","QueryChineseDrugByType",{"code":"NewDrugCat"},function(jsonString){
		
		if (jsonString != null){
			var ListDataObj = jsonString; ///jQuery.parseJSON(jsonString);
			/*var option = ECharts.ChartOptionTemplates.Bars(ListDataObj); 
			option.title ={
				text: '', ///'���ָ������ͼ',
				subtext: '', ///'��״ͼ',
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
	        // ָ��ͼ��������������
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
	                data:['��λ:��'],
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
	        }
	        // ʹ�ø�ָ�����������������ʾͼ��
        	myChart.setOption(option);
		}
	},'json')
}

/// ҳ��DataGrid��ʼ������ѡ�б�
function InitMainGrid(){
	
	///  ����columns
	var columns=[[
		{field:'dicDrugDesc',title:'ҩƷ',width:150,align:'left'},
		{field:'dicDateTime',title:'����ʱ��',width:150,align:'left'},
		{field:'dicUser',title:'����ҽʦ',width:80,align:'left'},
	
	]];
	
	///  ����datagrid
	var option = {
		//showHeader:false,
		rownumbers:false,
		singleSelect:true,
		pagination:false,
		fit:true,
		toolbar:[],
	    onDblClickRow: function (rowIndex, rowData) {
			
        },
	    onLoadSuccess: function (data) { //���ݼ�������¼�
        }
	};
	var uniturl = $URL+"?ClassName=web.DHCCKBOperationCenter&MethodName=QueryNewReleaseDrug";
	new ListComponent('NewRelease', columns, uniturl, option).Init();
}


/// ÿ��������������
function InitRuleChart(){	
	
	runClassMethod("web.DHCCKBOperationCenter","StatAllRuleByMon",{},function(data){
		var TempArr=[],YearArr=[],DataArr=[]
    	var yeatArr=[curYear,curYear-1];
		for(var i =0;i<yeatArr.length;i++){ 
           DataArr[i]=(data[yeatArr[i]]).split(",");  //�ַ���ת����
			var obj={}
			obj.name=yeatArr[i]
			obj.type='line'
			obj.data= DataArr[i]     
			TempArr.push(obj)
			YearArr.push(yeatArr[i])
		}
		MonQuartCompare=echarts.init(document.getElementById('MonQuartCompare'));
		InitMonthCompare(YearArr,TempArr,MonQuartCompare) // ����ͳ��
	},'json')
}

 //����ͳ��	
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
            	data : ["1��","2��","3��","4��","5��","6��","7��","8��","9��","10��","11��","12��"]  //,"�ϼ�"
        	}
    	],
    	yAxis : [
        {
            type : 'value',
            name:"��λ/��",
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

/// ҳ��ȫ���������֮�����(EasyUI������֮��)
function onload_handler() {
	
	/// �Զ�����ͼƬչʾ���ֲ�
	onresize_handler();
}


window.onload = onload_handler;
window.onresize = onresize_handler;
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
