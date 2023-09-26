/// Creator: bianshuai
/// CreateDate: 2014-09-18
//  Descript: 图表

var url="dhcpha.clinical.action.csp";
$(function(){

    var data = [{ name: '1月', group:'合格',value: 2255}, { name: '2月', group:'合格',value: 2450 }, { name: '3月', group:'合格',value: 2155}, 
	  { name: '4月', group:'合格',value: 3564}, { name: '5月', group:'合格',value: 4321}, { name: '6月', group:'合格',value: 2341}, { name: '7月', group:'合格',value: 2308}
	  , { name: '8月', group:'合格',value: 2288}, { name: '9月', group:'合格',value: 2800}, { name: '10月', group:'合格',value: 3800}, { name: '11月', group:'合格',value: 2880}
	  , { name: '12月', group:'合格',value: 2358},{ name: '1月', group:'不合格',value: 865}, { name: '2月', group:'不合格',value: 570 }, { name: '3月', group:'不合格',value: 940}, 
	  { name: '4月', group:'不合格',value: 379}, { name: '5月', group:'不合格',value: 218}, { name: '6月', group:'不合格',value: 1178}, { name: '7月', group:'不合格',value: 508}
	  , { name: '8月', group:'不合格',value: 488}, { name: '9月', group:'不合格',value: 528}, { name: '10月', group:'不合格',value: 438}, { name: '11月', group:'不合格',value: 288}
	  , { name: '12月', group:'不合格',value: 688},{ name: '1月', group:'不合格123',value: 265}, { name: '2月', group:'不合格123',value: 570 }, { name: '3月', group:'不合格123',value: 940}, 
	  { name: '4月', group:'不合格123',value: 379}, { name: '5月', group:'不合格123',value: 418}, { name: '6月', group:'不合格123',value: 1178}, { name: '7月', group:'不合格123',value: 508}
	  , { name: '8月', group:'不合格123',value: 688}, { name: '9月', group:'不合格123',value: 528}, { name: '10月', group:'不合格123',value: 438}, { name: '11月', group:'不合格123',value: 288}
	  , { name: '12月', group:'不合格123',value: 288}];

	var option = ECharts.ChartOptionTemplates.Bars(data); 
	option.title ={
		text: '2014年度门诊处方合格率统计',
		subtext: '图表'
	}

	var container = document.getElementById('charts');
	opt = ECharts.ChartConfig(container, option);
	ECharts.Charts.RenderChart(opt);

})