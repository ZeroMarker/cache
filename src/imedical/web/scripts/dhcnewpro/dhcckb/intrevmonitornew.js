//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2019-06-26
// ����:	   ֪ʶ��������
//===========================================================================================
var library = "";
/// ҳ���ʼ������
function initPageDefault(){
	
	/// ��ʼ����������
	InitTypeTotal();	 
	
	/// ҳ��DataGrid��ʼ������ѡ�б�
	InitMainGrid();
	
	/// ������ҩ�������
	InitTrendChart();
	
	/// ������ҩ���ָ������ͼ
	InitPropChart();
	
	/// �������ָ��
	InitMonIndRule();
	
	///  ҳ��Button���¼�
	InitBlButton(); 
	
}

/// Author:	qunianpeng
/// Date:	2020-05-19
///	Desc:	��ʼ����������
function InitTypeTotal(){

	runClassMethod("web.DHCCKBIntRevMonitor","JsTypeTotal",{},function(jsonString){
		var totalObj=jsonString;
		SetTotal(totalObj);
	
	},'json',false)
}


/// ҳ�� Button ���¼�
function InitBlButton(){
	
	$(".icon-more").bind('click',InHosMonPage);
	
	$(".item-num").bind('click',OpenProCenter);	// ������֣�����������ϸ
}

/// �������ָ��
function InitMonIndRule(){	
	
	runClassMethod("web.DHCCKBIntRevMonitor","JsMonIndRule",{},function(jsonString){
		var itmObj = jsonString;
		AddMonIndRule(itmObj);
	},'json',false)
}

/// ������ҩ�������
function InitTrendChart(){
	runClassMethod("web.DHCCKBIntRevMonitor","JsIntRevMonTrend",{},function(jsonString){
		if (jsonString == null) return;
		var seriesData = [0,34,42,67,0,63,0,0,0,0,0,0];
		for (i=0;  i<jsonString.length-1; i++){
			var month = jsonString[i].name.split("��")[0];
			seriesData[month-1] = jsonString[i].value;	
		}
		var chartDom = document.getElementById('TrendCharts');
		var myChart = echarts.init(chartDom);
		var option;

		option = {		  
		  tooltip: {
		    trigger: 'axis',
		    axisPointer: {
		      type: 'cross',
		      label: {
		        backgroundColor: '#6a7985'
		      }
		    }
		  }, 
		  grid: {
			  top:'3%',
		    left: '3%',
		    right: '4%',
		    bottom: '3%',
		    containLabel: true
		  },
		  color:['#73c0de', '#91cc75', '#fac858', '#ee6666', '#fc8452', '#3ba272', '#5470c6', '#9a60b4', '#ea7ccc'],
		  xAxis: [
		    {
		      type: 'category',
		      boundaryGap: false,
		      data: ['1��', '2��', '3��', '4��', '5��', '6��', '7��','8��','9��','10��','11��','12��']
		    }
		  ],
		  yAxis: [
		    {
		      type: 'value'
		    }
		  ],
		  series: [
		    {
		      name: '�������',
		      type: 'line',
		      stack: 'Total',
		      areaStyle: {},
		      emphasis: {
		        focus: 'series'
		      },
		      data:seriesData // [120, 132, 101, 134, 90, 230, 210]
		    }
		  ]
		};

		option && myChart.setOption(option);
	
	},'json',false)
	/*
	runClassMethod("web.DHCCKBIntRevMonitor","JsIntRevMonTrend",{},function(jsonString){
		
		if (jsonString != null){
			var ListDataObj = jsonString; ///jQuery.parseJSON(jsonString);
			var option = ECharts.ChartOptionTemplates.Lines(ListDataObj); 
			option.title ={
				text: '', ///'���ָ������ͼ',
				subtext: '', ///'��״ͼ',
				x:'center'
			}
			var container = document.getElementById('TrendCharts');
			opt = ECharts.ChartConfig(container, option);
			ECharts.Charts.RenderChart(opt);
		}
	},'json',false)
	*/
}

/// ������ҩ���ָ������ͼ
function InitPropChart(){
	
	
	runClassMethod("web.DHCCKBIntRevMonitor","JsIntRevMonProp",{},function(jsonString){
		if (jsonString == "") return;
		var chartDom = document.getElementById('PropCharts');
		var myChart = echarts.init(chartDom);
		var option;

		option = {
		  tooltip: {
		    trigger: 'item'
		  },	 
		  series: [
		    {
		      name: '',
		      type: 'pie',
		      radius: ['40%', '70%'],
		      avoidLabelOverlap: false,
		      itemStyle: {
		        borderRadius: 10,
		        borderColor: '#fff',
		        borderWidth: 2
		      },
		      label: {
		        show: false,
		        position: 'center'
		      },
		      emphasis: {
		        label: {
		          show: true,
		          fontSize: '40',
		          fontWeight: 'bold'
		        }
		      },
		      labelLine: {
		        show: false
		      },
		      data: jsonString
		    }
		  ]
		};

		myChart.setOption(option);
	},'json',false);	
	
	/*
	runClassMethod("web.DHCCKBIntRevMonitor","JsIntRevMonProp",{},function(jsonString){
		
		if (jsonString != null){
			var ListDataObj = jsonString; ///jQuery.parseJSON(jsonString);
			var option = ECharts.ChartOptionTemplates.Pie(ListDataObj); 
			option.title ={
				text: '', ///'���ָ������ͼ',
				subtext: '', ///'��״ͼ',
				x:'center'
			}
			var container = document.getElementById('PropCharts');
			opt = ECharts.ChartConfig(container, option);
			ECharts.Charts.RenderChart(opt);
		}
	},'json',false)
	*/
}

/// ҳ��DataGrid��ʼ������ѡ�б�
function InitMainGrid(){
	
	///  ����columns
	var columns=[[
		{field:'xh',title:'����',width:80,align:'left'},
		{field:'Loc',title:'����',width:300,align:'left'},
		{field:'LocNum',title:'��������',width:130,hidden:true},
		{field:'InEach',title:'�໥����',width:130,align:'left'},
		{field:'Taboo',title:'�������',width:130,align:'left'},
		{field:'Indic',title:'��Ӧ֢',width:130,align:'left'},
		{field:'Usage',title:'�÷�����',width:130,align:'left'},
		{field:'Contr',title:'����֢',width:130,align:'left'}
	]];
	
	///  ����datagrid
	var option = {
		//showHeader:false,
		rownumbers:false,
		singleSelect:true,
		pagination:false,
		fit:true,	
	    onDblClickRow: function (rowIndex, rowData) {
			
        },
	    onLoadSuccess: function (data) { //���ݼ�������¼�
        }
	};
	var uniturl = $URL+"?ClassName=web.DHCCKBIntRevMonitor&MethodName=JsonQryLocRecord";
	new ListComponent('main', columns, uniturl, option).Init();
}

/// �Զ�����ͼƬչʾ���ֲ�
function onresize_handler(){
	
	var Width = document.body.offsetWidth;	
	//var imgWidth = (Width - 144)/6;
	var imgWidth = (Width - 132)/6;
	$(".pf-nav-total-item").width(imgWidth);
	$(".pf-nav-inter-item").width(imgWidth);
	$(".pf-nav-taboo-item").width(imgWidth);
	$(".pf-nav-usage-item").width(imgWidth);
	$(".pf-nav-indic-item").width(imgWidth);
	$(".pf-nav-contr-item").width(imgWidth);
}

/// ȫԺ�����Ҽ��ֵ
function InHosMonPage(){
	
	window.open("", '_blank', 'height='+ (window.screen.availHeight-200) +', width='+ (window.screen.availWidth-200) +', top=100, left=100, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
}

/// Author:	qunianpeng
/// Date:	2020-05-19
///	Desc:	���ø������͵�����
function SetTotal(totalObj){
	
	$.each(totalObj,function (index,obj) {
    	var eleName=obj.code;
    	$("#"+eleName).html(obj.value);
    });
}

function AddMonIndRule(itemObj){
	/*
	var htmlstr = "";
	for(var i=1; i<12; i++){
		htmlstr = htmlstr + '<li class="item-news-item">';
		htmlstr = htmlstr + '	<div class="item-news-icon"></div>';
		htmlstr = htmlstr + '	<div class="item-news-title"><label>ע����ͷ���ƽ���֢</label></div>';
		htmlstr = htmlstr + '	<div class="item-news-time"><label>19.04.05</label></div>';
		htmlstr = htmlstr + '</li>';
	}
	*/
	var htmlstr = "";
	$.each(itemObj,function (index,obj) {
    
   		htmlstr = htmlstr + '<li class="item-news-item">';
		//htmlstr = htmlstr + '	<div class="item-news-icon"></div>';
		htmlstr = htmlstr + '	<div class="item-news-title"><label>' +obj.itemName+ '</label></div>';
		htmlstr = htmlstr + '	<div class="item-news-time"><label>' +obj.createDate+ '</label></div>';
		htmlstr = htmlstr + '</li>';

    });
    
	$(".item-news").append(htmlstr);
}

/// 
function OpenProCenter(){
		
	if ($(this).text() != ""){
			library = $(this).attr("id");
		 //library = $(this).prev().text();
		 if(library == "Count"){
				 library = "";
			}
			addProCenterWin();
			//url =encodeURI('dhcckb.problemscenter.csp?checkFlag='+"monitor"+'&library='+library);
			//window.open(url,'','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,width=1250,height=570,left=80,top=40');
	}		
		
}
	
	//�������ĵ���
function addProCenterWin(){
	
	commonShowWin({
		url:'dhcckb.problemscenter.csp',
		title:'��������',
		height:600,
		width:1100
	})
		
}
	
/// ������������ 
/// <iframe id='diclog' scrolling='auto' frameborder='0' src='dhcckb.diclog.csp"+"?HideFlag="+hideFlag+"&DicName="+tableName+"&dataid="+dataId+"&SetFlag="+setFlag+"&ClientIP="+ClientIPAdd+"&CloseFlag=1"+"&Operator="+LgUserID+"' "+"style='width:100%; height:100%; display:block;'></iframe>
function commonShowWin(option){
		
		var content = '<iframe src="'+option.url+"?library="+library+"&checkFlag="+"monitor"+'" scrolling="auto" width="100%" height="98%" frameborder="0" scrolling="no"></iframe>';
		var defOpt={
			iconCls:"icon-w-paper",
			width: 1110,
			height: 600,
			closed: false,
			content: content,
			modal: true
		}
		$.extend(defOpt,option);
		if (document.getElementById("CommonWin")){
			winObj = $("#CommonWin");
		}else{
			winObj = $('<div id="CommonWin"></div>').appendTo("body");	
		}
		$('#CommonWin').dialog(defOpt);
}

/// ҳ��ȫ���������֮�����(EasyUI������֮��)
function onload_handler() {
	
	/// �Զ�����ͼƬչʾ���ֲ�
	//onresize_handler();
}

window.onload = onload_handler;
window.onresize = onresize_handler;

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })