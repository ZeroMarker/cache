 
//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2019-07-02
// ����:	   MDT�����Ż�ҳ��
//===========================================================================================
var WeekLimit=0;
var LgUserID = session['LOGON.USERID'];  /// �û�ID
var LgLocID = session['LOGON.CTLOCID'];  /// ����ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID
var LgGroupID = session['LOGON.GROUPID'] /// ��ȫ��ID
var LgParam=LgHospID+"^"+LgLocID+"^"+LgGroupID+"^"+LgUserID
var RightWidth = 480; ///
var LiftRightLimit = 10;
/// ҳ���ʼ������
function initPageDefault(){
	
	/// ������ҩ�������
//	InitDisGrpChart();

	/// ��ʼ����������
	InitWeekDate();
	
	/// ����������
	InitWaitProREQ();
	
	/// ���ջ���
	LoadDailyConsult();
	
	/// ���ܰ���
	InitWeekSchedule();
	
	/// ҳ��Button���¼�
	InitBlButton(); 
	
	/// ��ʼ������
	InitWeekDaily();
	
	multi_Language();         /// ������֧��
	
	LoadMoreScr();
	
	setInterval('FlushTable()',60000);
	
}

/// ҳ�� Button ���¼�
function InitBlButton(){
	
	$("#appoint").bind('click',TakPlan);
	$("#schedule").bind('click',TakSchedule);
	$("#reqmore").bind('click',WaitReq_More);
}

/// ���ջ���
function LoadDailyConsult(){
	var consPlanDate=$HUI.datebox("#consPlanDate").getValue();	
	runClassMethod("web.DHCMDTConsPortal","JsGetDailyConsult",{"mParam":consPlanDate},function(jsonString){
		
		if (jsonString != null){
			InsDailyConsult(jsonString);
		}
	},'json',false)
}

/// ���µ��ջ���
function InsDailyConsult(jsonArr){
	
	var htmlstr = "";
	for(var i=0; i<jsonArr.length; i++){
		var itemCss = "item-plan";
		if (jsonArr[i].StatDesc == "���") itemCss = "item-complete";
		htmlstr = htmlstr + '<li class="pf-nav-item">';
		htmlstr = htmlstr + '	<div class="item-top"><label>'+	jsonArr[i].PatName +'</label></div>';
		htmlstr = htmlstr + '	<div class="item-center"><label>'+	jsonArr[i].DisGroup +'</label></div>';
		htmlstr = htmlstr + '	<div class="item-bottom"><label>'+	jsonArr[i].CstRTime +'</label></div>';
		htmlstr = htmlstr + '	<div class="item-tip '+ itemCss +'"></div>';
		htmlstr = htmlstr + '</li>';
	}
	$("#dailyconsult").html(htmlstr);
}

/// ����������
function InitWaitProREQ_OLD(){
	
	runClassMethod("web.DHCMDTConsPortal","JsGetWaitProREQ",{"mParam":""},function(jsonString){
		
		if (jsonString != null){
			InsWaitProREQ(jsonString);
		}
	},'json',false)
}

/// ����������
function InsWaitProREQ(jsonArr){
	
	var htmlstr = "";
	for(var i=1; i<jsonArr.length; i++){
		htmlstr = htmlstr + '<li class="item-news-item">';
		htmlstr = htmlstr + '	<div class="item-news-xu">������СС</div>';
		htmlstr = htmlstr + '	<div class="item-news-title">������֢</div>';
		htmlstr = htmlstr + '	<div class="item-news-time">19.04.05</div>';
		htmlstr = htmlstr + '</li>';
	}
	$(".item-news").append(htmlstr);
}

/// ����MDT���ﲡ�ֲַ�
function InitDisGrpChart(){

	runClassMethod("web.DHCMDTConsPortal","JsGetDisGrpCharts",{},function(jsonString){
		
		if (jsonString != null){
			var ListDataObj = jsonString; ///jQuery.parseJSON(jsonString);
			
			for(var i in ListDataObj){
				ListDataObj[i].group=$g(ListDataObj[i].group);
			}
			
			var option = ECharts.ChartOptionTemplates.Bars(ListDataObj); 
			option.title ={
				text: '',    ///'���ָ������ͼ',
				subtext: '', ///'��״ͼ',
				x:'center'
			}
			var container = document.getElementById('DisGrpCharts');
			opt = ECharts.ChartConfig(container, option);
			ECharts.Charts.RenderChart(opt);
		}
	},'json',false)
}

/// ��������ͼ
function InitTrendChartCharts(){

	var ListDataObj = [
		{"name":"1��","group":"2021","value":"1"},
		{"name":"2��","group":"2021","value":"2"},
		{"name":"3��","group":"2021","value":"3"},
		{"name":"4��","group":"2021","value":"6"},
		{"name":"5��","group":"2021","value":"2"},
		{"name":"6��","group":"2021","value":"5"},
		{"name":"7��","group":"2021","value":"3"},
		{"name":"8��","group":"2021","value":"8"},
		{"name":"9��","group":"2021","value":"12"},
		{"name":"10��","group":"2021","value":"1"},
		{"name":"11��","group":"2021","value":"3"},
		{"name":"12��","group":"2021","value":"5"},
		{"name":"1��","group":"2020","value":"1"},
		{"name":"2��","group":"2020","value":"9"},
		{"name":"3��","group":"2020","value":"3"},
		{"name":"4��","group":"2020","value":"5"},
		{"name":"5��","group":"2020","value":"7"},
		{"name":"6��","group":"2020","value":"2"},
		{"name":"7��","group":"2020","value":"9"},
		{"name":"8��","group":"2020","value":"1"},
		{"name":"9��","group":"2020","value":"5"},
		{"name":"10��","group":"2020","value":"1"},
		{"name":"11��","group":"2020","value":"4"},
		{"name":"12��","group":"2020","value":"1"}
	];
	
	var option = ECharts.ChartOptionTemplates.Lines(ListDataObj); 
	option.title ={
		text: '',    ///'���ָ������ͼ',
		subtext: '', ///'��״ͼ',
		x:'center'
	}
	var container = document.getElementById('TrendChartCharts');
	opt = ECharts.ChartConfig(container, option);
	ECharts.Charts.RenderChart(opt);

}


/// ���ﻼ������ֲ�
function InitConsAgeCharts(){

	
	var ListDataObj = [
		{"name":"1-10","value":"1"},
		{"name":"10-20","value":"5"},
		{"name":"20-30","value":"23"},
		{"name":"30-40","value":"34"},
		{"name":"40-50","value":"22"},
		{"name":"50-60","value":"34"},
		{"name":"60-70","value":"35"},
		{"name":"70-80","value":"2"},
		{"name":"80-90","value":"17"}
		]; 
	var option = ECharts.ChartOptionTemplates.Pie(ListDataObj); 
	option.title ={
		text: '',    ///'���ָ������ͼ',
		subtext: '', ///'��״ͼ',
		x:'center'
	}
	var container = document.getElementById('ConsAgeCharts');
	opt = ECharts.ChartConfig(container, option);
	ECharts.Charts.RenderChart(opt);
	
}

/// ���ﴦ��ͳ��
function InitConsAuditCharts(){
	var ListDataObj = [
		{"name":"ͨ��","value":"188"},
		{"name":"����","value":"7"}
		]; 
	var option = ECharts.ChartOptionTemplates.Pie(ListDataObj); 
	option.title ={
		text: '',    ///'���ָ������ͼ',
		subtext: '', ///'��״ͼ',
		x:'center'
	}
	var container = document.getElementById('ConsAuditCharts');
	opt = ECharts.ChartConfig(container, option);
	ECharts.Charts.RenderChart(opt);
}


/// ����MDT���ﲡ�ֲַ�
/**function InitDisResChart(){

	runClassMethod("web.DHCMDTConsPortal","JsGetGrpCharts",{},function(jsonString){
		
		if (jsonString != null){
			var ListDataObj = jsonString; ///jQuery.parseJSON(jsonString);
			var str='';
			for(var i=1;i<ListDataObj.length;i++){
				   alert(ListDataObj[i].name)
				    str += "<tr>";
                    str += '<td>' + ListDataObj[i].name + "</td>";
                    str += '<td>' + ListDataObj[i].value + "</td>";
                    str += "</tr>";
				}
				$("#keptBedTable").append(htmlstr);
		}
	},'json',false)
}*/


/// ����MDT������Դ�ֲ�
function InitDisResChart(){
		
	///  ����columns
	var columns=[[
		{field:'name',title:'��Դ',width:100,align:'center',formatter:formatName},
		{field:'value',title:'����',width:100,align:'center'},
		{field:'range',title:'����',width:100,align:'center'}
	]];
	
	var option = {
		rownumbers:false,
		singleSelect:true,
		pagination:false,
		fit:true,
	    onDblClickRow: function (rowIndex, rowData) {
			
        }
	};
	var uniturl = $URL+"?ClassName=web.DHCMDTConsPortal&MethodName=JsGetGrpJsonData"+"&MWToken="+websys_getMWToken();
	new ListComponent('keptBedTable', columns, uniturl, option).Init();
		
}

function formatName(value, rowData,index){
	return $g(value);    
}

/// ����������ͳ��
function InitJoinConsLoc(){
		
	///  ����columns
	var columns=[[
		{field:'loc',title:'����',width:100,align:'center'},
		{field:'value',title:'����',width:100,align:'center'}
	]];
	
	var option = {
		data:[
			{"loc":"�����ڿ�","value":1},
			{"loc":"CT��","value":6},
			{"loc":"�����ڿ�","value":9},
			{"loc":"���Ǻ��","value":8}
		],
		rownumbers:false,
		singleSelect:true,
		pagination:false,
		fit:true,
		fitColumns:true,
	    onDblClickRow: function (rowIndex, rowData) {
			
        }
	};
	var uniturl = "" //$URL+"?ClassName=web.DHCMDTConsPortal&MethodName=JsGetGrpJsonData";
	new ListComponent('joinConsLoc', columns, uniturl, option).Init();
		
}

function SetNowWeek(){
	WeekLimit=0;	
	InitWeekSchedule();
}
function SetTopWeek(){
	WeekLimit--;
	InitWeekSchedule();
}
function SetNextWeek(){
	WeekLimit++;
	InitWeekSchedule();
}

/// ��ʼ�����ܰ���
function InitWeekSchedule(){
	runClassMethod("web.DHCMDTConsPortal","JsGetWeekDay",{"WeekLimit":WeekLimit},function(ret){
		var retArr=ret.split("^");
		$("#weekOneDay").html("("+retArr[0]+")");
		$("#weekTwoDay").html("("+retArr[1]+")");
		$("#weekThreeDay").html("("+retArr[2]+")");
		$("#weekFourDay").html("("+retArr[3]+")");
		$("#weekFiveDay").html("("+retArr[4]+")");
	},'text',false)
	
	runClassMethod("web.DHCMDTConsPortal","JsGetWeekPlan",{"mParam":WeekLimit},function(jsonString){
		
		if (jsonString != null){
			InsWeekSchedule(jsonString);
		}
	},'json',false)
}

/// ����������
function InsWeekSchedule(jsonArr){
	$(".weekM").html("")
	for(var i=0; i<jsonArr.length; i++){
		var htmlstr = "";
		htmlstr = htmlstr + '<div class="week-item-grp">';
		htmlstr = htmlstr + '	<div class="item-grp-dis"><label class="grp-dis-text">'+ jsonArr[i].DisGroup +'</label></div>';
		htmlstr = htmlstr + '	<div class="item-grp-time"><label class="grp-dis-text">'+ jsonArr[i].TimeRange +'</label></div>';
		htmlstr = htmlstr + '	<div class="item-grp-value"><label>'+ jsonArr[i].value +'</label></div>';
		htmlstr = htmlstr + '</div>';
		$("#"+jsonArr[i].Week).append(htmlstr);
	}
}

/// ҳ��DataGrid��ʼ������ѡ�б�
function InitWaitProREQ(){
	
	///  ����columns
	var columns=[[
		{field:'PatNo',title:'����ID',width:100,align:'center'},
		{field:'PatName',title:'����',width:80},
		{field:'DisGroup',title:'��������',width:150},
		{field:'CstRUser',title:'����ҽ��',width:100,align:'center'},
		{field:'CstRTime',title:'����ʱ��',width:140,align:'center'},
		{field:'CstRLoc',title:'�������',width:100,align:'center'},
		{field:'Status',title:'��ǰ״̬',width:100,align:'center'}
	]];
	
	///  ����datagrid
	var option = {
		fit:true,
		rownumbers:false,
		singleSelect:true,
		pagination:false,
	    onDblClickRow: function (rowIndex, rowData) {
			TakPlan();  /// ���� 
        }
	};
	/// ��������
	var uniturl = $URL+"?ClassName=web.DHCMDTConsPortal&MethodName=JsGetWaitProREQ&LgParam="+LgParam+"&MWToken="+websys_getMWToken();
	new ListComponent('WaitProREQ', columns, uniturl, option).Init();
}

/// ԤԼ ����ҳ��
function TakPlan(PatNo){
	
	var rowData = $('#WaitProREQ').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('��ʾ',"����ѡ��һ���������¼!","error");
		return;
	}
	
	//ID EpisodeID 
	//dhcmdt.makeresplan.csp?ID=59&amp;mdtMakResID=&amp;DisGrpID=1&amp;EpisodeID=35
	//dhcmdt.matreview.csp?ID=57&amp;mdtMakResID=undefined&amp;DisGrpID=1&amp;EpisodeID=71
	Link = "dhcmdt.matreview.csp?ID="+rowData.ID +"&mdtMakResID="+rowData.mdtMakResID+"&DisGrpID="+ rowData.DisGrpID+"&EpisodeID="+ rowData.EpisodeID
			+"&IsConsCentPlan=1"+"&MWToken="+websys_getMWToken();
	
	commonShowWin({
		url: Link,
		title: $g("����"),
		width: window.screen.availWidth - 60,
		height: window.screen.availHeight - 120,
		onClose:function(){
			FlushTable();
		}
	})	
	return;
	
}

function FlushTable(){
	$("#WaitProREQ").datagrid('reload');	
}

/// �Ű� ����ҳ��
function TakSchedule(){
	
	var url="opadm.scheduletemplate.hui.csp"+"?MWToken="+websys_getMWToken();
	window.open(url, '_blank', 'height='+ (window.screen.availHeight-100) +', width='+ (window.screen.availWidth-100) +', top=50, left=50, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
}

/// ��ʼ������
function InitWeekDaily(){
	$HUI.datebox("#consPlanDate",{
		onSelect: function(date){
        	LoadDailyConsult();
    	}	
	})
	$HUI.datebox("#consPlanDate").setValue(ToDayDate);
	return;
	runClassMethod("web.DHCMDTConsPortal","JsGetCurDaily",{"mParam":""},function(jsonString){
		
		if (jsonString != null){
			//$("#mdtday").text(jsonString);
			
		}
	},'',false)
}

/// ������ ����
function WaitReq_More(){
	var url="dhcmdt.platform.csp"+"?MWToken="+websys_getMWToken();
	window.open(url, 'newwindow', 'height='+ (window.screen.availHeight-100) +', width='+ (window.screen.availWidth) +', top=20, left=20, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');	
}

/// �Զ�����ͼƬչʾ���ֲ�
function onresize_handler(){
	
	
	var Width = document.body.offsetWidth;
	//var Height = document.body.scrollHeight;
	var Height = window.screen.availHeight;
	var TainerHeight = Height - 110;
	/// �������
	$(".container").width(Width - 30);
	$(".view-first").width(Width - 30);
	$(".view-second").width(Width - 30);
	
	/// ���
	$(".view-first-left").width(Width - RightWidth);
	$(".view-first-right").css("left",Width - RightWidth + LiftRightLimit);
	$(".view-second-left").width(Width - RightWidth);
	$(".view-second-right").css("left",Width - RightWidth + LiftRightLimit);
	$(".bt-item-right").css("width","80px");
	
	
	if(IsOpenMoreScreen!="0"){
		$("#reqmore").hide();
		$(".view-first-right-top").hide()
		$(".view-first-right-bottom").css({"top":0,"height":"100%"});
		$(".list-order-item-req").css({"height":560});
	}
	
	$(".view-second-right,.list-order-item-req,.view-first-right-bottom,.view-first-right,.view-first-right-top").css("width",RightWidth -LiftRightLimit*3);
	$(".bt-nav-item").css("width",parseInt(RightWidth/2-20));
	
	/// ���ܻ���
//	$(".week-plan").width(Width - 505);
//	if (Width > 900){
//		var imgWidth = (Width - 630)/5;
//	}else{
//		var imgWidth = (Width - 611)/5;
//	}
//	$(".week-nav-item:not(:nth-child(1))").width(imgWidth);
	
	$(".item-chart").width(Width - RightWidth);
	
	InitDisGrpChart(); /// ������ҩ�������
	InitDisResChart(); /// ����MDT������Դ�ֲ�
	$HUI.datagrid("#WaitProREQ").resize();
}

/// ��ʼ����������
function InitWeekDate(){
	
	runClassMethod("web.DHCMDTConsPortal","JsGetWeekDate",{},function(jsonString){
		
		if (jsonString != null){
			InsWeekDate(jsonString);
		}
	},'json',false)
}

/// ����������
function InsWeekDate(jsonObject){
	
	$('.week-plan-title [id^="Week"]').each(function(){
		var week_date = typeof jsonObject[this.id] == "undefined"?"":jsonObject[this.id];
		if (week_date != "") week_date = "["+ week_date +"]"; 
		$(this).text(week_date);
	})
}

/// ������֧��
function multi_Language(){
	
	$g("��ʾ");
	$g("����ѡ��һ���������¼!");
}

/// ҳ��ȫ���������֮�����(EasyUI������֮��)
function onload_handler() {
	
	/// �Զ��ֲ�
	onresize_handler();
}

function SetToDay(){
	$HUI.datebox("#consPlanDate").setValue(ToDayDate);
	LoadDailyConsult();
}


/// �����鿴:���ں�
function LoadMoreScr(){
	
	websys_on("onMdtPortal",function(res){
		LoadDailyConsult();
		InitWeekSchedule();
	});
}

window.onload = onload_handler;
window.onresize = onresize_handler;

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
