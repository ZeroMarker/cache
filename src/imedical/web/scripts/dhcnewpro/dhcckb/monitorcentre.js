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
	
	/// 基本药物使用情况
	InitOrdChart();
	
	/// 新增监测指标
	InitMonIndRule();
	
	///  页面Button绑定事件
	InitBlButton(); 
	
}


///	Desc:	初始化分类数量
function InitTypeTotal(){
      $("#Count").html(272);
      $("#InterEach").html(12);
      $("#Taboo").html(35);
      $("#RuleUsage").html(115);
      $("#RuleIndic").html(0);
      $("#RuleContr").html(110);
}


/// 页面 Button 绑定事件
function InitBlButton(){
	$(".icon-more").bind('click',InHosMonPage);
}

/// 新增监测指标
function InitMonIndRule(){	
	var htmlstr = "";
	htmlstr = htmlstr + '<li class="item-news-item"><div class="item-news-icon"></div><div class="item-news-title"><label>吲达帕胺缓释片</label></div><div class="item-news-time"><label>2021-01-12</label></div></li>';
	$(".item-news").append(htmlstr);
	var htmlstr = "";
	htmlstr = htmlstr + '<li class="item-news-item"><div class="item-news-icon"></div><div class="item-news-title"><label>格列齐特缓释片</label></div><div class="item-news-time"><label>2021-01-12</label></div></li>';
	$(".item-news").append(htmlstr);
	var htmlstr = "";
	htmlstr = htmlstr + '<li class="item-news-item"><div class="item-news-icon"></div><div class="item-news-title"><label>注射用英夫利西单抗100mg</label></div><div class="item-news-time"><label>2021-01-12</label></div></li>';
	$(".item-news").append(htmlstr);
	var htmlstr = "";
	htmlstr = htmlstr + '<li class="item-news-item"><div class="item-news-icon"></div><div class="item-news-title"><label>熊去氧胆酸胶囊250mg</label></div><div class="item-news-time"><label>2021-01-15</label></div></li>';
	$(".item-news").append(htmlstr);
	var htmlstr = "";
	htmlstr = htmlstr + '<li class="item-news-item"><div class="item-news-icon"></div><div class="item-news-title"><label>碘化钾片</label></div><div class="item-news-time"><label>2021-01-15</label></div></li>';
	$(".item-news").append(htmlstr);
	var htmlstr = "";
	htmlstr = htmlstr + '<li class="item-news-item"><div class="item-news-icon"></div><div class="item-news-title"><label>维生素E烟酸酯胶囊</label></div><div class="item-news-time"><label>2021-01-15</label></div></li>';
	$(".item-news").append(htmlstr);
	var htmlstr = "";
	htmlstr = htmlstr + '<li class="item-news-item"><div class="item-news-icon"></div><div class="item-news-title"><label>艾司奥美拉唑镁肠溶片40mg</label></div><div class="item-news-time"><label>2021-01-15</label></div></li>';
	$(".item-news").append(htmlstr);
	var htmlstr = "";
	htmlstr = htmlstr + '<li class="item-news-item"><div class="item-news-icon"></div><div class="item-news-title"><label>布洛芬缓释胶囊</label></div><div class="item-news-time"><label>2021-01-15</label></div></li>';
	$(".item-news").append(htmlstr);
}

/// 合理用药审查趋势
function InitTrendChart(){
			var option = ECharts.ChartOptionTemplates.Lines([{"name":"9月","group":"监测总数","value":"651"},{"name":"10月","group":"监测总数","value":"781"},{"name":"11月","group":"监测总数","value":"1080"},{"name":"12月","group":"监测总数","value":"800"}]); 
			option.title ={
				text: '', ///'审查指标趋势图',
				subtext: '', ///'饼状图',
				x:'center'
			}
			var container = document.getElementById('TrendCharts');
			opt = ECharts.ChartConfig(container, option);
			ECharts.Charts.RenderChart(opt);                                                                           
}

/// 合理用药审查指标趋势图
function InitPropChart(){
			var option = ECharts.ChartOptionTemplates.Pie([{"code":"InterEach","name":"相互作用","value":"12"},{"code":"Taboo","name":"配伍禁忌","value":"35"},{"code":"RuleUsage","name":"用法用量","value":"115"},{"code":"RuleContr","name":"禁忌症","value":"90"}]); 
			option.title ={
				text: '', ///'审查指标趋势图',
				subtext: '', ///'饼状图',
				x:'center'
			}
			var container = document.getElementById('PropCharts');
			opt = ECharts.ChartConfig(container, option);
			ECharts.Charts.RenderChart(opt);
}
/// 药物使用情况
function InitOrdChart(){
			var option = ECharts.ChartOptionTemplates.Lines([{"name":"9月","group":"监测总数","value":"321"},{"name":"10月","group":"监测总数","value":"237"},{"name":"11月","group":"监测总数","value":"254"},{"name":"12月","group":"监测总数","value":"366"}]); 
			option.title ={
				text: '', ///'审查指标趋势图',
				subtext: '', ///'饼状图',
				x:'center'
			}
			var container = document.getElementById('orderCharts');
			opt = ECharts.ChartConfig(container, option);
			ECharts.Charts.RenderChart(opt);
}
/// 页面DataGrid初始定义已选列表
function InitMainGrid(){
	
	$HUI.datagrid('#main',{
		rownumbers:false,
		singleSelect:true,
		pagination:false,
		fit:true,
		columns:[[
			{field:'xh',title:'排名',width:80,align:'center'},
			{field:'Hosp',title:'医院',width:300},
			{field:'LocNum',title:'科室数量',width:130,hidden:true},
			{field:'InEach',title:'相互作用',width:130,align:'center'},
			{field:'Taboo',title:'配伍禁忌',width:130,align:'center'},
			{field:'Indic',title:'适应症',width:130,align:'center'},
			{field:'Usage',title:'用法用量',width:130,align:'center'},
			{field:'Contr',title:'禁忌症',width:130,align:'center'}
		]],
		data:{
			rows:[
			{xh:'1',Hosp:'武汉市第一医院',LocNum:'',InEach:'',Taboo:'23',Indic:'',Usage:'23',Contr:'28'},
			{xh:'2',Hosp:'武汉市第二医院',LocNum:'',InEach:'',Taboo:'12',Indic:'',Usage:'18',Contr:'22'},
			{xh:'3',Hosp:'武汉市第三医院',LocNum:'',InEach:'',Taboo:'',Indic:'',Usage:'23',Contr:'20'},
			{xh:'4',Hosp:'武汉市中心医院',LocNum:'',InEach:'12',Taboo:'',Indic:'',Usage:'',Contr:'22'},
			{xh:'5',Hosp:'冶金街社区卫生服务中心',LocNum:'',InEach:'',Taboo:'',Indic:'',Usage:'23',Contr:'8'},
			{xh:'6',Hosp:'武车社区卫生站',LocNum:'',InEach:'',Taboo:'',Indic:'',Usage:'18',Contr:'2'},
			{xh:'7',Hosp:'武汉市第四医院',LocNum:'',InEach:'',Taboo:'',Indic:'',Usage:'10',Contr:'8'},
			],
			total:10
		}
	})
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


/// 页面全部加载完成之后调用(EasyUI解析完之后)
function onload_handler() {
	
	/// 自动设置图片展示区分布
	onresize_handler();
}

window.onload = onload_handler;
window.onresize = onresize_handler;

/// JQuery 初始化页面
$(function(){ initPageDefault(); })