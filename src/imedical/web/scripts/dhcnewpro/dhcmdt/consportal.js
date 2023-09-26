//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2019-07-02
// ����:	   MDT�����Ż�ҳ��
//===========================================================================================

/// ҳ���ʼ������
function initPageDefault(){
	
	/// ������ҩ�������
//	InitDisGrpChart();

	/// ����������
	InitWaitProREQ();
	
	/// ���ջ���
	LoadDailyConsult();
	
	/// ���ܰ���
	InitWeekSchedule();
	
	///  ҳ��Button���¼�
	InitBlButton(); 
	
	/// ��ʼ������
	InitWeekDaily();
	
	multi_Language();         /// ������֧��
}

/// ҳ�� Button ���¼�
function InitBlButton(){
	
	$("#appoint").bind('click',TakPlan);
	$("#schedule").bind('click',TakSchedule);
	$("#reqmore").bind('click',WaitReq_More);
}

/// ���ջ���
function LoadDailyConsult(){
	
	runClassMethod("web.DHCMDTConsPortal","JsGetDailyConsult",{"mParam":""},function(jsonString){
		
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
		{field:'name',title:'��Դ',width:100,align:'center'},
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
	var uniturl = $URL+"?ClassName=web.DHCMDTConsPortal&MethodName=JsGetGrpJsonData";
	new ListComponent('keptBedTable', columns, uniturl, option).Init();
		
}

/// ��ʼ�����ܰ���
function InitWeekSchedule(){
	
	runClassMethod("web.DHCMDTConsPortal","JsGetWeekPlan",{"mParam":""},function(jsonString){
		
		if (jsonString != null){
			InsWeekSchedule(jsonString);
		}
	},'json',false)
}

/// ����������
function InsWeekSchedule(jsonArr){
	
	for(var i=0; i<jsonArr.length; i++){
		var htmlstr = "";
		htmlstr = htmlstr + '<div class="week-item-grp">';
		htmlstr = htmlstr + '	<div class="item-grp-dis"><label>'+ jsonArr[i].DisGroup +'</label></div>';
		htmlstr = htmlstr + '	<div class="item-grp-time"><label>'+ jsonArr[i].TimeRange +'</label></div>';
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
		{field:'CstRLoc',title:'�������',width:100,align:'center'}
		
	]];
	
	///  ����datagrid
	var option = {
		//showHeader:false,
		rownumbers:false,
		singleSelect:true,
		pagination:false,
		fit:true,
	    onDblClickRow: function (rowIndex, rowData) {
			TakPlan();  /// ���� 
        }
	};
	/// ��������
	var uniturl = $URL+"?ClassName=web.DHCMDTConsPortal&MethodName=JsGetWaitProREQ";
	new ListComponent('WaitProREQ', columns, uniturl, option).Init();
}

/// ԤԼ ����ҳ��
function TakPlan(PatNo){
	
	var rowData = $('#WaitProREQ').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('��ʾ',"����ѡ��һ���������¼!","error");
		return;
	}
    window.location.href = "dhcmdt.platform.csp?PatNo="+rowData.PatNo;
}

/// �Ű� ����ҳ��
function TakSchedule(){
	
	window.open("opadm.scheduletemplate.hui.csp", '_blank', 'height='+ (window.screen.availHeight-100) +', width='+ (window.screen.availWidth-100) +', top=50, left=50, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
}

/// ��ʼ������
function InitWeekDaily(){
	
	runClassMethod("web.DHCMDTConsPortal","JsGetCurDaily",{"mParam":""},function(jsonString){
		
		if (jsonString != null){
			$("#mdtday").text(jsonString);
		}
	},'',false)
}

/// ������ ����
function WaitReq_More(){
	
	window.open("dhcmdt.platform.csp", 'newwindow', 'height='+ (window.screen.availHeight-100) +', width='+ (window.screen.availWidth) +', top=20, left=20, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');	
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
	$(".view-first-left").width(Width - 480);
	$(".view-first-right").css("left",Width - 470);
	$(".view-second-left").width(Width - 480);
	$(".view-second-right").css("left",Width - 470);
	
	/// ���ܻ���
//	$(".week-plan").width(Width - 505);
//	if (Width > 900){
//		var imgWidth = (Width - 630)/5;
//	}else{
//		var imgWidth = (Width - 611)/5;
//	}
//	$(".week-nav-item:not(:nth-child(1))").width(imgWidth);
	
	$(".item-chart").width(Width - 480);
	
	InitDisGrpChart(); /// ������ҩ�������
	InitDisResChart(); /// ����MDT������Դ�ֲ�
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

window.onload = onload_handler;
window.onresize = onresize_handler;

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
