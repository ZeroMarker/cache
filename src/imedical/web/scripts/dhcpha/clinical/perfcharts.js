/// Creator: bianshuai
/// CreateDate: 2014-09-18
//  Descript: ͼ��

var url="dhcpha.clinical.action.csp";
$(function(){

    var data = [{ name: '1��', group:'�ϸ�',value: 2255}, { name: '2��', group:'�ϸ�',value: 2450 }, { name: '3��', group:'�ϸ�',value: 2155}, 
	  { name: '4��', group:'�ϸ�',value: 3564}, { name: '5��', group:'�ϸ�',value: 4321}, { name: '6��', group:'�ϸ�',value: 2341}, { name: '7��', group:'�ϸ�',value: 2308}
	  , { name: '8��', group:'�ϸ�',value: 2288}, { name: '9��', group:'�ϸ�',value: 2800}, { name: '10��', group:'�ϸ�',value: 3800}, { name: '11��', group:'�ϸ�',value: 2880}
	  , { name: '12��', group:'�ϸ�',value: 2358},{ name: '1��', group:'���ϸ�',value: 865}, { name: '2��', group:'���ϸ�',value: 570 }, { name: '3��', group:'���ϸ�',value: 940}, 
	  { name: '4��', group:'���ϸ�',value: 379}, { name: '5��', group:'���ϸ�',value: 218}, { name: '6��', group:'���ϸ�',value: 1178}, { name: '7��', group:'���ϸ�',value: 508}
	  , { name: '8��', group:'���ϸ�',value: 488}, { name: '9��', group:'���ϸ�',value: 528}, { name: '10��', group:'���ϸ�',value: 438}, { name: '11��', group:'���ϸ�',value: 288}
	  , { name: '12��', group:'���ϸ�',value: 688},{ name: '1��', group:'���ϸ�123',value: 265}, { name: '2��', group:'���ϸ�123',value: 570 }, { name: '3��', group:'���ϸ�123',value: 940}, 
	  { name: '4��', group:'���ϸ�123',value: 379}, { name: '5��', group:'���ϸ�123',value: 418}, { name: '6��', group:'���ϸ�123',value: 1178}, { name: '7��', group:'���ϸ�123',value: 508}
	  , { name: '8��', group:'���ϸ�123',value: 688}, { name: '9��', group:'���ϸ�123',value: 528}, { name: '10��', group:'���ϸ�123',value: 438}, { name: '11��', group:'���ϸ�123',value: 288}
	  , { name: '12��', group:'���ϸ�123',value: 288}];

	var option = ECharts.ChartOptionTemplates.Bars(data); 
	option.title ={
		text: '2014������ﴦ���ϸ���ͳ��',
		subtext: 'ͼ��'
	}

	var container = document.getElementById('charts');
	opt = ECharts.ChartConfig(container, option);
	ECharts.Charts.RenderChart(opt);

})