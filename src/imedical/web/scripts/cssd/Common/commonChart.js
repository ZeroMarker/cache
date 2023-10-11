// ����ͼ
// XData ����������,YData ����������,divId ��ʾ��div,Title ����ƶ���ȥ��ֵ,
// ChartColor �������� ͼ����������Ԫ�ص���ɫֵ
// LineColor ����������ɫ
function Chart(XData, YData, divId, Title, ChartColor, LineColor) {
	var option = {
		// ������ɫ�������ö����ɫ
		color: LineColor,
		// ͼ�����ܱ߾�����
		grid: {
			left: 30,
			top: 30,
			right: 20,
			bottom: 30
		},
		legend: {
			orient: 'horizontal', // ͼ������ vertical-"����"; horizontal-"����"
			right: 60,	// ͼ��������������ľ���
			top: 10,
			textStyle: {	// ͼ�����ֵ���ʽ
				color: ChartColor
			},
			data: [Title]	// ��series��ÿ��nameһһ��Ӧ
		},
		// �������ʱ��ʾ����/
		tooltip: {
			trigger: 'axis',
			axisPointer: {	// ������ָʾ���������ᴥ����Ч
				type: 'shadow'	// Ĭ��Ϊֱ�ߣ���ѡΪ��'line' | 'shadow'
			}
		},
		xAxis: {
			type: 'category',
			data: XData,
			axisLine: {	// �������ߵ�����
				lineStyle: {
					color: ChartColor
				}
			},
			axisLabel: {	// ����x���lable
				textStyle: {
					fontSize: 10	// �������С
				}
			}
		},
		yAxis: {
			type: 'value',
			splitLine: {	// �����������Ƿ���ʾ
				show: true,
				lineStyle: {	// �ı�������ɫ
					color: ['#132a6e']	// ʹ����ǳ�ļ��ɫ
				}
			},
			// �������ߵ�����
			axisLine: {
				lineStyle: {
					color: ChartColor
				}
			}
		},
		// �������ã����ж�����������������׷��{name: , data: }/
		series: [{
			name: Title,
			data: YData,
			type: 'line',
			symbol: 'circle',
			symbolSize: 10,	// �����۵��С
			smooth: true	// ����Ϊ�⻬����
		}]
	};
	var ChartTemp = echarts.init(document.getElementById(divId));
	ChartTemp.setOption(option);
}