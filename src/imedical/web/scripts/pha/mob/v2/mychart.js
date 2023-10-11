/*
* Description: 统计图表公共
* Creator:     Huxt 2021-03-10
* Js:          pha/mob/v2/mychart.js
* Others:      以下为使用举例:
	
	// 用例一: 折线图,柱状图
  	// Echart_Line / Echart_VBar
	Echart_Line('myChart', {
		title: '这是标题',
		data: [
			{
				name: 'bar1',
				data: [
					{xVal:'2021-03-10', yVal:'100'},
					{xVal:'2021-03-11', yVal:'90'},
					{xVal:'2021-03-12', yVal:'67'}
				]
			}, {
				name:'bar2',
				data:[
					{xVal:'2021-03-10', yVal:'100'},
					{xVal:'2021-03-11', yVal:'78'},
					{xVal:'2021-03-12', yVal:'99'}
				]
			}
		]
	});
	// 用例二: 饼状图,横向柱状图
	// Echart_Pie / Echart_HBar
	Echart_Pie('myChart', {
		title: '这是标题',
		sort: false,
		data: [
			{name:'张三', value:'100'},
			{name:'李四', value:'90'},
			{name:'王五', value:'67'}
		]
	});
*/


var init_echarts = {};
/*
* 简单的饼状图 (看比例)
* _options.title: 图表标题
* _options.data: [{name:'张三', value:'100'}, {name:'李四', value:'90'}, {name:'王五', value:'70'}]
*/
function Echart_Pie(_id, _options){
	var _data = _options.data;
	var _title = _options.title;
	
	var legendData = [];
	var seriesData = [];
	for (var i = 0; i < _data.length; i++) {
		var oneData = _data[i];
		legendData.push(oneData.name);
		seriesData.push({
			value: oneData.value,
			name: oneData.name
		});
	}
	var cOption = {
		title: {
	        text: _title,
	        x: "center"
	    },
	    tooltip: {
	        trigger: "item",
	        formatter: "{a} <br/>{b}: {c} ({d}%)"
	    },
	    legend: {
	        orient: "vertical",
	        top: 5,
	        left: 10,
	        data: legendData
	    },
	    series: [
	        {
		        name: _title,
	            type: "pie",
	            radius: "50%",
	            data: seriesData
	        }
	    ]
	};
	
	var myChart;
	if (!init_echarts[_id]) {
		var domObj = document.getElementById(_id);
		var myChart = echarts.init(domObj);
		init_echarts[_id] = myChart;
	}
	myChart = init_echarts[_id];
	
	myChart.clear();
	myChart.setOption(cOption);
}

/*
* 简单的纵向柱状图 (看排名)
* _options.title: 图表标题
* _options.data: [{name:'张三', value:'100'}, {name:'李四', value:'90'}, {name:'王五', value:'70'}]
* _options.sort: 是否排序
*/
function Echart_HBar(_id, _options){
	var _data = _options.data;
	var _title = _options.title;
	
	// 先排序
	if (_options.sort) {
		var len = _data.length;
	    for (var i = 0; i < len; i++) {
	        for (var j = 0; j < len - 1 - i; j++) {
	            if (parseFloat(_data[j].value) > parseFloat(_data[j+1].value)) {
	                var temp = _data[j+1];
	                _data[j+1] = _data[j];
	                _data[j] = temp;
	            }
	        }
	    }
	}
	
	var yAxisData = [];
	var oneBarData = [];
	for (var i = 0; i < _data.length; i++) {
		var oneData = _data[i];
		yAxisData.push(oneData.name);
		oneBarData.push(oneData.value);
	}
	var seriesData = [];
	var oneBar = {
		name: _title,
		type: "bar",
		itemStyle: {
			normal: {
				color: "#3495D8"
			}
		},
		data: oneBarData
	}
	seriesData.push(oneBar)
	
	var cOption = {
		title: {
			text: _title,
			x: "center"
		},
		tooltip: {},
		legend: {},
		xAxis: {
			type: "value"
		},
		yAxis: {
			axisLabel: {interval: -1},
			type: "category",
			data: yAxisData
		},
		series: seriesData
	}
	
	var myChart;
	if (!init_echarts[_id]) {
		var domObj = document.getElementById(_id);
		var myChart = echarts.init(domObj);
		init_echarts[_id] = myChart;
	}
	myChart = init_echarts[_id];
	
	myChart.clear();
	myChart.setOption(cOption);
}

/*
* 简单的横向柱状图 (常用于对比)
* _options.title: 图表标题
* _options.data: [{name:'bar1', data:[{xVal:'2021-03-10', yVal:'100'}, ...]}, ...]
*/
function Echart_VBar(_id, _options){
	var _data = _options.data;
	var _title = _options.title;
	
	var legendData = [];
	var xAxisData = [];
	var seriesData = [];
	for (var i = 0; i < _data.length; i++) {
		var iName = _data[i].name;
		legendData.push(iName);
		
		var iData = _data[i].data;
		var seriesItmes = [];
		for (var j = 0; j < iData.length; j++) {
			var jiData = iData[j];
			if (xAxisData.indexOf(jiData.xVal) < 0) {
				xAxisData.push(jiData.xVal);
			}
			seriesItmes.push(jiData.yVal);
		}
		
		seriesData.push({
			name: iName,
			type: 'bar',
			barGap: '0%', // 间距
			data: seriesItmes
		});
	}
	
	var cOption = {
		title: {
			text: _title,
			x: "left"
		},
		tooltip: {},
		legend: {
			top: 5,
			data: legendData
		},
		xAxis: {
			axisLabel: {interval: 0, rotate: 45},
			data: xAxisData
		},
		yAxis: {},
		series: seriesData
	}
	
	var myChart;
	if (!init_echarts[_id]) {
		var domObj = document.getElementById(_id);
		var myChart = echarts.init(domObj);
		init_echarts[_id] = myChart;
	}
	myChart = init_echarts[_id];
	
	myChart.clear();
	myChart.setOption(cOption);
}

/*
* 简单的折线图 (看趋势/变化)
* _options.title: 图表标题
* _options.data: [{name:'bar1', data:[{xVal:'2021-03-10', yVal:'100'}, ...]}, ...]
*/
function Echart_Line(_id, _options){
	var _data = _options.data;
	var _title = _options.title;
	
	var legendData = [];
	var xAxisData = [];
	var seriesData = [];
	for (var i = 0; i < _data.length; i++) {
		var iName = _data[i].name;
		legendData.push(iName);
		
		var iData = _data[i].data;
		var seriesItmes = [];
		for (var j = 0; j < iData.length; j++) {
			var jiData = iData[j];
			if (xAxisData.indexOf(jiData.xVal) < 0) {
				xAxisData.push(jiData.xVal);
			}
			seriesItmes.push(jiData.yVal);
		}
		
		seriesData.push({
			name: iName,
			type: 'line',
			data: seriesItmes
		});
	}
	
	var cOption = {
		title: {
			text: _title,
			x: "left",
			left: 10
		},
		tooltip: {
			trigger: 'axis' // 鼠标悬停显示纵轴
		},
		legend: {
			top: 5,
			data: legendData
		},
		xAxis: {
			axisLabel: {interval: 0, rotate: 45},
			data: xAxisData
		},
		yAxis: {},
		series: seriesData
	}
	
	var myChart;
	if (!init_echarts[_id]) {
		var domObj = document.getElementById(_id);
		var myChart = echarts.init(domObj);
		init_echarts[_id] = myChart;
	}
	myChart = init_echarts[_id];
	
	myChart.clear();
	myChart.setOption(cOption);
}