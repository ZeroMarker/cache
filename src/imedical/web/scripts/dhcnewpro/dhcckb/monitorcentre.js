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
	
	/// ����ҩ��ʹ�����
	InitOrdChart();
	
	/// �������ָ��
	InitMonIndRule();
	
	///  ҳ��Button���¼�
	InitBlButton(); 
	
}


///	Desc:	��ʼ����������
function InitTypeTotal(){
      $("#Count").html(272);
      $("#InterEach").html(12);
      $("#Taboo").html(35);
      $("#RuleUsage").html(115);
      $("#RuleIndic").html(0);
      $("#RuleContr").html(110);
}


/// ҳ�� Button ���¼�
function InitBlButton(){
	$(".icon-more").bind('click',InHosMonPage);
}

/// �������ָ��
function InitMonIndRule(){	
	var htmlstr = "";
	htmlstr = htmlstr + '<li class="item-news-item"><div class="item-news-icon"></div><div class="item-news-title"><label>�Ŵ���������Ƭ</label></div><div class="item-news-time"><label>2021-01-12</label></div></li>';
	$(".item-news").append(htmlstr);
	var htmlstr = "";
	htmlstr = htmlstr + '<li class="item-news-item"><div class="item-news-icon"></div><div class="item-news-title"><label>�������ػ���Ƭ</label></div><div class="item-news-time"><label>2021-01-12</label></div></li>';
	$(".item-news").append(htmlstr);
	var htmlstr = "";
	htmlstr = htmlstr + '<li class="item-news-item"><div class="item-news-icon"></div><div class="item-news-title"><label>ע����Ӣ����������100mg</label></div><div class="item-news-time"><label>2021-01-12</label></div></li>';
	$(".item-news").append(htmlstr);
	var htmlstr = "";
	htmlstr = htmlstr + '<li class="item-news-item"><div class="item-news-icon"></div><div class="item-news-title"><label>��ȥ�����ὺ��250mg</label></div><div class="item-news-time"><label>2021-01-15</label></div></li>';
	$(".item-news").append(htmlstr);
	var htmlstr = "";
	htmlstr = htmlstr + '<li class="item-news-item"><div class="item-news-icon"></div><div class="item-news-title"><label>�⻯��Ƭ</label></div><div class="item-news-time"><label>2021-01-15</label></div></li>';
	$(".item-news").append(htmlstr);
	var htmlstr = "";
	htmlstr = htmlstr + '<li class="item-news-item"><div class="item-news-icon"></div><div class="item-news-title"><label>ά����E����������</label></div><div class="item-news-time"><label>2021-01-15</label></div></li>';
	$(".item-news").append(htmlstr);
	var htmlstr = "";
	htmlstr = htmlstr + '<li class="item-news-item"><div class="item-news-icon"></div><div class="item-news-title"><label>��˾��������þ����Ƭ40mg</label></div><div class="item-news-time"><label>2021-01-15</label></div></li>';
	$(".item-news").append(htmlstr);
	var htmlstr = "";
	htmlstr = htmlstr + '<li class="item-news-item"><div class="item-news-icon"></div><div class="item-news-title"><label>����һ��ͽ���</label></div><div class="item-news-time"><label>2021-01-15</label></div></li>';
	$(".item-news").append(htmlstr);
}

/// ������ҩ�������
function InitTrendChart(){
			var option = ECharts.ChartOptionTemplates.Lines([{"name":"9��","group":"�������","value":"651"},{"name":"10��","group":"�������","value":"781"},{"name":"11��","group":"�������","value":"1080"},{"name":"12��","group":"�������","value":"800"}]); 
			option.title ={
				text: '', ///'���ָ������ͼ',
				subtext: '', ///'��״ͼ',
				x:'center'
			}
			var container = document.getElementById('TrendCharts');
			opt = ECharts.ChartConfig(container, option);
			ECharts.Charts.RenderChart(opt);                                                                           
}

/// ������ҩ���ָ������ͼ
function InitPropChart(){
			var option = ECharts.ChartOptionTemplates.Pie([{"code":"InterEach","name":"�໥����","value":"12"},{"code":"Taboo","name":"�������","value":"35"},{"code":"RuleUsage","name":"�÷�����","value":"115"},{"code":"RuleContr","name":"����֢","value":"90"}]); 
			option.title ={
				text: '', ///'���ָ������ͼ',
				subtext: '', ///'��״ͼ',
				x:'center'
			}
			var container = document.getElementById('PropCharts');
			opt = ECharts.ChartConfig(container, option);
			ECharts.Charts.RenderChart(opt);
}
/// ҩ��ʹ�����
function InitOrdChart(){
			var option = ECharts.ChartOptionTemplates.Lines([{"name":"9��","group":"�������","value":"321"},{"name":"10��","group":"�������","value":"237"},{"name":"11��","group":"�������","value":"254"},{"name":"12��","group":"�������","value":"366"}]); 
			option.title ={
				text: '', ///'���ָ������ͼ',
				subtext: '', ///'��״ͼ',
				x:'center'
			}
			var container = document.getElementById('orderCharts');
			opt = ECharts.ChartConfig(container, option);
			ECharts.Charts.RenderChart(opt);
}
/// ҳ��DataGrid��ʼ������ѡ�б�
function InitMainGrid(){
	
	$HUI.datagrid('#main',{
		rownumbers:false,
		singleSelect:true,
		pagination:false,
		fit:true,
		columns:[[
			{field:'xh',title:'����',width:80,align:'center'},
			{field:'Hosp',title:'ҽԺ',width:300},
			{field:'LocNum',title:'��������',width:130,hidden:true},
			{field:'InEach',title:'�໥����',width:130,align:'center'},
			{field:'Taboo',title:'�������',width:130,align:'center'},
			{field:'Indic',title:'��Ӧ֢',width:130,align:'center'},
			{field:'Usage',title:'�÷�����',width:130,align:'center'},
			{field:'Contr',title:'����֢',width:130,align:'center'}
		]],
		data:{
			rows:[
			{xh:'1',Hosp:'�人�е�һҽԺ',LocNum:'',InEach:'',Taboo:'23',Indic:'',Usage:'23',Contr:'28'},
			{xh:'2',Hosp:'�人�еڶ�ҽԺ',LocNum:'',InEach:'',Taboo:'12',Indic:'',Usage:'18',Contr:'22'},
			{xh:'3',Hosp:'�人�е���ҽԺ',LocNum:'',InEach:'',Taboo:'',Indic:'',Usage:'23',Contr:'20'},
			{xh:'4',Hosp:'�人������ҽԺ',LocNum:'',InEach:'12',Taboo:'',Indic:'',Usage:'',Contr:'22'},
			{xh:'5',Hosp:'ұ�������������������',LocNum:'',InEach:'',Taboo:'',Indic:'',Usage:'23',Contr:'8'},
			{xh:'6',Hosp:'�䳵��������վ',LocNum:'',InEach:'',Taboo:'',Indic:'',Usage:'18',Contr:'2'},
			{xh:'7',Hosp:'�人�е���ҽԺ',LocNum:'',InEach:'',Taboo:'',Indic:'',Usage:'10',Contr:'8'},
			],
			total:10
		}
	})
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


/// ҳ��ȫ���������֮�����(EasyUI������֮��)
function onload_handler() {
	
	/// �Զ�����ͼƬչʾ���ֲ�
	onresize_handler();
}

window.onload = onload_handler;
window.onresize = onresize_handler;

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })