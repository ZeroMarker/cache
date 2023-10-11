//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2019-06-26
// 描述:	   知识库监测中心
//===========================================================================================
var library = "";
var hospId = session['LOGON.HOSPID']
/// 页面初始化函数
function initPageDefault(){
	
	/// 初始化分类数量
	InitTypeTotal();	 
	
	/// 页面DataGrid初始定义已选列表
	InitMainGrid();
	
	/// 合理用药审查趋势
	InitTrendChart();
	
	/// 合理用药审查指标趋势图
	InitPropChart();
	
	/// 新增监测指标
	InitMonIndRule();
	
	///  页面Button绑定事件
	InitBlButton(); 
	
}

/// Author:	qunianpeng
/// Date:	2020-05-19
///	Desc:	初始化分类数量
function InitTypeTotal(){

	runClassMethod("web.DHCCKBIntRevMonitor","JsTypeTotal",{hospId:hospId},function(jsonString){
		var totalObj=jsonString;
		SetTotal(totalObj);
	
	},'json',false)
}


/// 页面 Button 绑定事件
function InitBlButton(){
	
	$(".icon-more").bind('click',InHosMonPage);
	
	//$(".item-num").bind('click',OpenProCenter);	// 点击数字，弹出问题明细
	
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

/// 新增监测指标
function InitMonIndRule(){	
	
	runClassMethod("web.DHCCKBIntRevMonitor","JsMonIndRule",{hospId:hospId},function(jsonString){
		var itmObj = jsonString;
		AddMonIndRule(itmObj);
	},'json',false)
}

/// 合理用药审查趋势
function InitTrendChart(){

	runClassMethod("web.DHCCKBIntRevMonitor","JsIntRevMonTrend",{hospId:hospId},function(jsonString){
		
		if (jsonString != null){
			var ListDataObj = jsonString; ///jQuery.parseJSON(jsonString);
			var option = ECharts.ChartOptionTemplates.Lines(ListDataObj); 
			option.title ={
				text: '', ///'审查指标趋势图',
				subtext: '', ///'饼状图',
				x:'center'
			}
			var container = document.getElementById('TrendCharts');
			opt = ECharts.ChartConfig(container, option);
			ECharts.Charts.RenderChart(opt);
		}
	},'json',false)
}

/// 合理用药审查指标趋势图
function InitPropChart(){
	
	runClassMethod("web.DHCCKBIntRevMonitor","JsIntRevMonProp",{hospId:hospId},function(jsonString){
		
		if (jsonString != null){
			var ListDataObj = jsonString; ///jQuery.parseJSON(jsonString);
			var option = ECharts.ChartOptionTemplates.Pie(ListDataObj); 
			option.title ={
				text: '', ///'审查指标趋势图',
				subtext: '', ///'饼状图',
				x:'center'
			}
			var container = document.getElementById('PropCharts');
			opt = ECharts.ChartConfig(container, option);
			ECharts.Charts.RenderChart(opt);
		}
	},'json',false)
}

/// 页面DataGrid初始定义已选列表
function InitMainGrid(){
	
	///  定义columns
	var columns=[[
		{field:'xh',title:'排名',width:80,align:'center'},
		{field:'Loc',title:'科室',width:300},
		{field:'LocNum',title:'科室数量',width:130,hidden:true},
		{field:'InEach',title:'相互作用',width:130,align:'center'},
		{field:'Taboo',title:'配伍禁忌',width:130,align:'center'},
		{field:'Indic',title:'适应症',width:130,align:'center'},
		{field:'Usage',title:'用法用量',width:130,align:'center'},
		{field:'Contr',title:'禁忌症',width:130,align:'center'}
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
	var uniturl = $URL+"?ClassName=web.DHCCKBIntRevMonitor&MethodName=JsonQryLocRecord&hospId="+hospId;
	new ListComponent('main', columns, uniturl, option).Init();
}

/// 自动设置图片展示区分布
function onresize_handler(){
	
	var Width = document.body.offsetWidth;
	//var imgWidth = (Width - 144)/6;
	var imgWidth = (Width - 132)/6;
	$(".pf-nav-item").width(imgWidth);
}

/// 全院各科室监测值
function InHosMonPage(){
	
	window.open("", '_blank', 'height='+ (window.screen.availHeight-200) +', width='+ (window.screen.availWidth-200) +', top=100, left=100, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
}

/// Author:	qunianpeng
/// Date:	2020-05-19
///	Desc:	设置各个类型的总数
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
		htmlstr = htmlstr + '	<div class="item-news-title"><label>注射用头孢钠禁忌症</label></div>';
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
	
	//问题中心弹框
function addProCenterWin(){
	
	commonShowWin({
		url:'dhcckb.problemscenter.csp'+(("undefined"!==typeof websys_getMWToken)?"&MWToken="+websys_getMWToken():""),
		title:'问题中心',
		height:600,
		width:1100
	})
		
}
	
/// 公共弹出界面 
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

/// 页面全部加载完成之后调用(EasyUI解析完之后)
function onload_handler() {
	
	/// 自动设置图片展示区分布
	onresize_handler();
}

window.onload = onload_handler;
window.onresize = onresize_handler;

/// JQuery 初始化页面
$(function(){ initPageDefault(); })
