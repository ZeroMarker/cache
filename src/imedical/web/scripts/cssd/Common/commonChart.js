// 曲线图
// XData 横坐标数据,YData 纵坐标数据,divId 显示的div,Title 鼠标移动上去的值,
// ChartColor 除了曲线 图中其他所有元素的颜色值
// LineColor 曲线条的颜色
function Chart(XData, YData, divId, Title, ChartColor, LineColor) {
	var option = {
		// 线条颜色，可设置多个颜色
		color: LineColor,
		// 图像四周边距设置
		grid: {
			left: 30,
			top: 30,
			right: 20,
			bottom: 30
		},
		legend: {
			orient: 'horizontal', // 图例排项 vertical-"竖向"; horizontal-"横向"
			right: 60,	// 图例组件离容器左侧的距离
			top: 10,
			textStyle: {	// 图例文字的样式
				color: ChartColor
			},
			data: [Title]	// 与series中每个name一一对应
		},
		// 鼠标悬浮时显示数据/
		tooltip: {
			trigger: 'axis',
			axisPointer: {	// 坐标轴指示器，坐标轴触发有效
				type: 'shadow'	// 默认为直线，可选为：'line' | 'shadow'
			}
		},
		xAxis: {
			type: 'category',
			data: XData,
			axisLine: {	// 设置轴线的属性
				lineStyle: {
					color: ChartColor
				}
			},
			axisLabel: {	// 调整x轴的lable
				textStyle: {
					fontSize: 10	// 让字体变小
				}
			}
		},
		yAxis: {
			type: 'value',
			splitLine: {	// 控制网格线是否显示
				show: true,
				lineStyle: {	// 改变轴线颜色
					color: ['#132a6e']	// 使用深浅的间隔色
				}
			},
			// 设置轴线的属性
			axisLine: {
				lineStyle: {
					color: ChartColor
				}
			}
		},
		// 数据配置，若有多条折线则在数组中追加{name: , data: }/
		series: [{
			name: Title,
			data: YData,
			type: 'line',
			symbol: 'circle',
			symbolSize: 10,	// 设置折点大小
			smooth: true	// 设置为光滑曲线
		}]
	};
	var ChartTemp = echarts.init(document.getElementById(divId));
	ChartTemp.setOption(option);
}