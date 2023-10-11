//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2019-06-26
// ����:	   ֪ʶ��������
//===========================================================================================
var library = "";
var hospId = session['LOGON.HOSPID']
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

	runClassMethod("web.DHCCKBIntRevMonitor","JsTypeTotal",{hospId:hospId},function(jsonString){
		var totalObj=jsonString;
		SetTotal(totalObj);
	
	},'json',false)
}


/// ҳ�� Button ���¼�
function InitBlButton(){
	
	$(".icon-more").bind('click',InHosMonPage);
	
	//$(".item-num").bind('click',OpenProCenter);	// ������֣�����������ϸ
	
	$('.item-num').on('mouseover', function() {
    	var eleWidth = $(this).width();
    	var wordWith = $(this)[0].scrollWidth;
    	if (wordWith>eleWidth){	    
    		$(this).append('<a id="numtips" href="#" title='+$(this).text()+' class="hisui-tooltip"></a>')
	    	$HUI.tooltip("#numtips",{position:'bottom'}).show();
	    }
	})
    	
    $('.item-num').on('mouseout', function() {
       $("#numtips").remove();
       $(".tooltip").hide();
	})	

}

/// �������ָ��
function InitMonIndRule(){	
	
	runClassMethod("web.DHCCKBIntRevMonitor","JsMonIndRule",{hospId:hospId},function(jsonString){
		var itmObj = jsonString;
		AddMonIndRule(itmObj);
	},'json',false)
}

/// ������ҩ�������
function InitTrendChart(){

	runClassMethod("web.DHCCKBIntRevMonitor","JsIntRevMonTrend",{hospId:hospId},function(jsonString){
		
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
}

/// ������ҩ���ָ������ͼ
function InitPropChart(){
	
	runClassMethod("web.DHCCKBIntRevMonitor","JsIntRevMonProp",{hospId:hospId},function(jsonString){
		
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
}

/// ҳ��DataGrid��ʼ������ѡ�б�
function InitMainGrid(){
	
	///  ����columns
	var columns=[[
		{field:'xh',title:'����',width:80,align:'center'},
		{field:'Loc',title:'����',width:300},
		{field:'LocNum',title:'��������',width:130,hidden:true},
		{field:'InEach',title:'�໥����',width:130,align:'center'},
		{field:'Taboo',title:'�������',width:130,align:'center'},
		{field:'Indic',title:'��Ӧ֢',width:130,align:'center'},
		{field:'Usage',title:'�÷�����',width:130,align:'center'},
		{field:'Contr',title:'����֢',width:130,align:'center'}
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
	var uniturl = $URL+"?ClassName=web.DHCCKBIntRevMonitor&MethodName=JsonQryLocRecord&hospId="+hospId;
	new ListComponent('main', columns, uniturl, option).Init();
}

/// �Զ�����ͼƬչʾ���ֲ�
function onresize_handler(){
	
	var Width = document.body.offsetWidth;
	//var imgWidth = (Width - 144)/6;
	var imgWidth = (Width - 132)/6;
	$(".pf-nav-item").width(imgWidth);
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
		htmlstr = htmlstr + '	<div class="item-news-icon" style="display:none"></div>';
		htmlstr = htmlstr + '	<div class="item-news-title nowrap"><label>' +obj.itemName+ '</label></div>';
		htmlstr = htmlstr + '	<div class="item-news-time nowrap"><label>' +obj.createDate+ '</label></div>';
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
		url:'dhcckb.problemscenter.csp'+(("undefined"!==typeof websys_getMWToken)?"&MWToken="+websys_getMWToken():""),
		title:'��������',
		height:600,
		width:1100
	})
		
}
	
/// ������������ 
/// <iframe id='diclog' scrolling='auto' frameborder='0' src='dhcckb.diclog.csp"+"?HideFlag="+hideFlag+"&DicName="+tableName+"&dataid="+dataId+"&SetFlag="+setFlag+"&ClientIP="+ClientIPAdd+"&CloseFlag=1"+"&Operator="+LgUserID+"' "+"style='width:100%; height:100%; display:block;'></iframe>
function commonShowWin(option){
		var linkurl = option.url+"?library="+library+"&checkFlag="+"monitor";
		linkurl += ("undefined"!==typeof websys_getMWToken)?"&MWToken="+websys_getMWToken():"";
		var content = '<iframe src="'+linkurl+'" scrolling="auto" width="100%" height="98%" frameborder="0" scrolling="no"></iframe>';
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
	onresize_handler();
}

window.onload = onload_handler;
window.onresize = onresize_handler;

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
