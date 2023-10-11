var init = function() {
	$HUI.radio("[name='DateType']", {
		onChecked: function(e, value) {
			Workchart();
			PkgNum();
			initTips();
		}
	});
	$HUI.radio("[name='AttributeDesc']", {
		onChecked: function(e, value) {
			Workchart();
			PkgNum();
		}
	});
	
	function Workchart() {
		var DateType = $("input[name='DateType']:checked").val();
		var AttributeId = $("input[name='AttributeDesc']:checked").val();
		var Params = JSON.stringify(addSessionParams({
			DateType: DateType,
			AttributeId: AttributeId
		}));
		// 获取各人工作量数据
		var JsonData = $.cm({
			ClassName: 'web.CSSDHUI.Common.Tips',
			MethodName: 'GetPersonWork',
			Params: Params
		}, false);
		
		var option = {
			tooltip: {
				trigger: 'axis',
				axisPointer: {
					type: 'cross'
				}
			},
			legend: {},
			grid: {
				left: '2%',
				right: '2%',
				bottom: '3%',
				containLabel: true
			},
			xAxis: {
				type: 'value'
			},
			yAxis: {
				type: 'category',
				data: JsonData.UserArr,
				axisLabel: { // 坐标轴刻度标签的相关设置。
					interval: 0,
					rotate: 20// 文字倾斜度
				}
			},
			series: [
				{
					name: '回收',
					type: 'bar',
					stack: 'total',
					label: {
						show: true
					},
					emphasis: {
						focus: 'series'
					},
					data: JsonData.CBArr
				}, {
					name: '机器清洗',
					type: 'bar',
					stack: 'total',
					label: {
						show: true
					},
					emphasis: {
						focus: 'series'
					},
					data: JsonData.CleanArr
				}, {
					name: '手工清洗',
					type: 'bar',
					stack: 'total',
					label: {
						show: true
					},
					emphasis: {
						focus: 'series'
					},
					data: JsonData.PCleanArr
				}, {
					name: '包装',
					type: 'bar',
					stack: 'total',
					label: {
						show: true
					},
					emphasis: {
						focus: 'series'
					},
					data: JsonData.PackArr
				}, {
					name: '包装审核',
					type: 'bar',
					stack: 'total',
					label: {
						show: true
					},
					emphasis: {
						focus: 'series'
					},
					data: JsonData.PackAckArr
				}, {
					name: '灭菌',
					type: 'bar',
					stack: 'total',
					label: {
						show: true
					},
					emphasis: {
						focus: 'series'
					},
					data: JsonData.SterArr
				}, {
					name: '发放',
					type: 'bar',
					stack: 'total',
					label: {
						show: true
					},
					emphasis: {
						focus: 'series'
					},
					data: JsonData.DispArr
				}
			]
		};
		var Chart = echarts.init(document.getElementById('EmergencyControl'), 'macarons');
		Chart.setOption(option);
	}
	function PkgNum() {
		var res = [];
		var DateType = $("input[name='DateType']:checked").val();
		var AttributeId = $("input[name='AttributeDesc']:checked").val();
		var Params = JSON.stringify(addSessionParams({ DateType: DateType, AttributeId: AttributeId }));
		$.cm({
			ClassName: 'web.CSSDHUI.Common.Tips',
			QueryName: 'QueryPkgSum',
			Params: Params,
			rows: 999999
		}, function(jsonData) {
			var CallQty = 0, CleanQty = 0, PCleanQty = 0, PackQty = 0, SterQty = 0, DispQty = 0;
			for (var i = 0; i < jsonData.rows.length; i++) {
				if (jsonData.rows[i].Type === '回收') {
					CallQty = Number(CallQty) + Number(jsonData.rows[i].Qty);
				} if (jsonData.rows[i].Type === '机器清洗') {
					CleanQty = Number(CleanQty) + Number(jsonData.rows[i].Qty);
				} if (jsonData.rows[i].Type === '手工清洗') {
					PCleanQty = Number(PCleanQty) + Number(jsonData.rows[i].Qty);
				} if (jsonData.rows[i].Type === '打包') {
					PackQty = Number(PackQty) + Number(jsonData.rows[i].Qty);
				} if (jsonData.rows[i].Type === '灭菌') {
					SterQty = Number(SterQty) + Number(jsonData.rows[i].Qty);
				} if (jsonData.rows[i].Type === '发放') {
					DispQty = Number(DispQty) + Number(jsonData.rows[i].Qty);
				}
			}
			res.push({ value: CallQty, name: '回收' },
				{ value: CleanQty, name: '机器清洗' },
				{ value: PCleanQty, name: '手工清洗' },
				{ value: PackQty, name: '打包' },
				{ value: SterQty, name: '灭菌' },
				{ value: DispQty, name: '发放' });
			PkgNumchart(res);
		});
	}
	function PkgNumchart(data) {
		var option = {
			tooltip: {
				trigger: 'item'
			},
			legend: {
				top: 'bottom',
				left: 'center'
			},
			series: [
				{
					name: '消毒包数量',
					type: 'pie',
					radius: ['20%', '70%'],
					itemStyle: {
						borderRadius: 10,
						borderColor: '#fff',
						borderWidth: 2
					},
					label: {
						show: false,
						position: 'center'
					},
					emphasis: {
						label: {
							show: true,
							fontSize: 28,
							fontWeight: 'bold'
						}
					},
					data: data
				}
			]
		};
		var chart = echarts.init(document.getElementById('EmergencyControl2'), 'macarons');
		chart.setOption(option);
	}
	// 待办
	var CallBackAduit = '<li url="${NodeUrl}" title="${NodeCaption}"><span class=' + 'Num' + '>' + '${Count}</span><p class=' + 'Click' + '>&nbsp;&nbsp;点击查看</p></li>';
	var NeedTodealt = '<li url="${NodeUrl}" title="${NodeCaption}"><span class=' + 'Num' + '>' + ' ${Count}</span><p class=' + 'Click' + '>&nbsp;&nbsp;点击查看</p></li>';
	var Expired = '<li url="${NodeUrl}" title="${NodeCaption}">已经过期&nbsp;<span class=' + 'warn-font-expired' + '>' + ' ${Count}</span></li>';
	var About = '<li url="${NodeUrl}" title="${NodeCaption}">即将过期&nbsp;<span class=' + 'warn-font-about' + '>' + ' ${Count}</span></li>';
	function initTips() {
		$('#Callback').empty();
		$('#Supexpired').empty();
		$('#Supabout').empty();
		$('#Locexpired').empty();
		$('#Locabout').empty();
		$('#Clean').empty();
		$('#Pack').empty();
		$('#Ster').empty();
		$('#Disp').empty();
		var DateType = $("input[name='DateType']:checked").val();
		var Params = JSON.stringify(addSessionParams({
			DateType: DateType
		}));
		$.cm({
			ClassName: 'web.CSSDHUI.Common.TipsWin',
			MethodName: 'GetTips',
			Params: Params,
			wantreturnval: 0
		}, function(jsonData) {
			if (jsonData.docapplycount > 0) {
				$.tmpl(CallBackAduit, jsonData.docapply[0]).appendTo('#Callback');
				$('#Callback').on('click', 'li', function() {
					var url = $(this).attr('url');
					var tabTitle = $(this).attr('title');
					Common_AddTab(tabTitle, url);
				});
			}
			if (jsonData.doccount > 0) {
				console.log(jsonData.doc);
				for (var i = 0; i < jsonData.doc.length; i++) {
					if (jsonData.doc[i].Info === '供应中心已过期') {
						$.tmpl(Expired, jsonData.doc[i]).appendTo('#Supexpired');
						$('#Supexpired').on('click', 'li', function() {
							var url = $(this).attr('url');
							var tabTitle = $(this).attr('title');
							Common_AddTab(tabTitle, url);
						});
					} else if (jsonData.doc[i].Info === '供应中心即将过期') {
						$.tmpl(About, jsonData.doc[i]).appendTo('#Supabout');
						$('#Supabout').on('click', 'li', function() {
							var url = $(this).attr('url');
							var tabTitle = $(this).attr('title');
							Common_AddTab(tabTitle, url);
						});
					} else if (jsonData.doc[i].Info === '科室已过期') {
						$.tmpl(Expired, jsonData.doc[i]).appendTo('#Locexpired');
						$('#Locexpired').on('click', 'li', function() {
							var url = $(this).attr('url');
							var tabTitle = $(this).attr('title');
							Common_AddTab(tabTitle, url);
						});
					} else if (jsonData.doc[i].Info === '科室即将过期') {
						$.tmpl(About, jsonData.doc[i]).appendTo('#Locabout');
						$('#Locabout').on('click', 'li', function() {
							var url = $(this).attr('url');
							var tabTitle = $(this).attr('title');
							Common_AddTab(tabTitle, url);
						});
					}
				}
			}
			if (jsonData.sterilizepackage) {
				for (var j = 0; j < jsonData.sterilizepackage.length; j++) {
					if (jsonData.sterilizepackage[j].Status === 'C') {
						$.tmpl(NeedTodealt, jsonData.sterilizepackage[j]).appendTo('#Clean');
						$('#Clean').on('click', 'li', function() {
							var url = $(this).attr('url');
							var tabTitle = $(this).attr('title');
							Common_AddTab(tabTitle, url);
						});
					} else if (jsonData.sterilizepackage[j].Status === 'P') {
						$.tmpl(NeedTodealt, jsonData.sterilizepackage[j]).appendTo('#Pack');
						$('#Pack').on('click', 'li', function() {
							var url = $(this).attr('url');
							var tabTitle = $(this).attr('title');
							Common_AddTab(tabTitle, url);
						});
					} else if (jsonData.sterilizepackage[j].Status === 'S') {
						$.tmpl(NeedTodealt, jsonData.sterilizepackage[j]).appendTo('#Ster');
						$('#Ster').on('click', 'li', function() {
							var url = $(this).attr('url');
							var tabTitle = $(this).attr('title');
							Common_AddTab(tabTitle, url);
						});
					} else if (jsonData.sterilizepackage[j].Status === 'D') {
						$.tmpl(NeedTodealt, jsonData.sterilizepackage[j]).appendTo('#Disp');
						$('#Disp').on('click', 'li', function() {
							var url = $(this).attr('url');
							var tabTitle = $(this).attr('title');
							Common_AddTab(tabTitle, url);
						});
					}
				}
			}
		});
	}
	PkgNum();
	Workchart();
	initTips();
};
$(init);
// 系统菜单模式下,工作台切换时刷新
var TopWindow = top.window.frames[0];
if (!isEmpty(TopWindow.showNavTab)) {
	var Location = TopWindow.frames[0].location;
	var href = Location.href;
	if (href.indexOf('MWToken') <= 0) {
		if (href.indexOf('?') <= 0) {
			Location.href += '?MWToken=' + websys_getMWToken();
		} else {
			Location.href += '&MWToken=' + websys_getMWToken();
		}
	}
	$(TopWindow.document.getElementById('li_home')).on('click', function() {
		if (!$(this).hasClass('active')) {
			TopWindow.frames[0].location.reload();
		}
	});
	$(TopWindow.document.getElementById('myTab')).find('.glyphicon').on('click', function() {
		if ($(TopWindow.document.getElementById('li_home')).hasClass('active')) {
			TopWindow.frames[0].location.reload();
		}
	});
	$(TopWindow.document.getElementById('jqContextMenu')).on('click', function() {
		if (!$(this).hasClass('active') && TopWindow.length === 2) {
			TopWindow.frames[0].location.reload();
		}
	});
}