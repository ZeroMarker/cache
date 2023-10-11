var init = function() {
	var tmpltodo = '<span id="${App}" url="${NodeUrl}" title="${NodeCaption}" type="${TabType}" class=' + 'data-cell-centerNum' + '>' + '${Count}</span>';
	var tmpexpired = '<span id="${Type}" IdStr="${IdStr}" url="${NodeUrl}" title="${NodeCaption}" type="${TabType}"</span><p><span class="Exp-warn-font-about">${AboutCount}</span>������&nbsp;&nbsp;<span class="Exps-warn-font-expired">${ExpiredCount}</span>�ѹ���</p>';
	function initTips() 	{
		$.cm({
			ClassName: 'web.DHCSTMHUI.Common.TipsWin',
			MethodName: 'GetTips',
			Params: JSON.stringify(sessionObj),
			wantreturnval: 0
		}, function(jsonData) {
			var Obj = {
				TabType: 'Search'
			};
			if (jsonData.doccount > 0) {
				for (var i = 0; i < jsonData.doccount; i++) {
					$.tmpl(tmpltodo, jsonData.doc[i]).appendTo('#Num' + jsonData.doc[i].App);
					$('#toDo-' + jsonData.doc[i].App).on('click', function() {
						var childAppId = $(this)[0].id.split('-')[1];
						var url = $('#' + childAppId).attr('url');
						if (url.indexOf('.csp') <= 0) {
							return;
						}
						
						var tabTitle = $('#' + childAppId).attr('title');
						Obj.TabType = $('#' + childAppId).attr('type');
						url = url + '?' + 'TabParams=' + encodeUrlStr(JSON.stringify(Obj));
						Common_AddTab(tabTitle, url);
					});
				}
			}
			$.tmpl(tmpexpired, jsonData.vexp).appendTo('#expList');
			if (jsonData.vexpcount > 0) {
				$('#expList').on('click', function() {
					var url = $('#Ven').attr('url');
					if (url.indexOf('.csp') <= 0) {
						return;
					}
					var tabTitle = $('#Ven').attr('title');
					Obj.TabType = $('#Ven').attr('type');
					Obj.TabId = $('#Ven').attr('IdStr');
					url = url + '?' + 'TabParams=' + encodeUrlStr(JSON.stringify(Obj));
					Common_AddTab(tabTitle, url);
				});
			}
			
			$.tmpl(tmpexpired, jsonData.mexp).appendTo('#mexpList');
			if (jsonData.mexpcount > 0) {
				$('#mexpList').on('click', function() {
					var url = $('#Manf').attr('url');
					if (url.indexOf('.csp') <= 0) {
						return;
					}
					var tabTitle = $('#Manf').attr('title');
					Obj.TabType = $('#Manf').attr('type');
					Obj.TabId = $('#Manf').attr('IdStr');
					url = url + '?' + 'TabParams=' + encodeUrlStr(JSON.stringify(Obj));
					Common_AddTab(tabTitle, url);
				});
			}

			$.tmpl(tmpexpired, jsonData.incicert).appendTo('#cexpList');
			if (jsonData.incicertcount > 0) {
				$('#cexpList').on('click', function() {
					var url = $('#InciCert').attr('url');
					if (url.indexOf('.csp') <= 0) {
						return;
					}
					var tabTitle = $('#InciCert').attr('title');
					Obj.TabType = $('#InciCert').attr('type');
					Obj.TabId = $('#InciCert').attr('IdStr');
					url = url + '?' + 'TabParams=' + encodeUrlStr(JSON.stringify(Obj));
					Common_AddTab(tabTitle, url);
				});
			}

			$.tmpl(tmpexpired, jsonData.incicontract).appendTo('#contractexpList');
			if (jsonData.incicontractcount > 0) {
				$('#contractexpList').on('click', function() {
					var url = $('#InciContract').attr('url');
					if (url.indexOf('.csp') <= 0) {
						return;
					}
					var tabTitle = $('#InciContract').attr('title');
					Obj.TabType = $('#InciContract').attr('type');
					Obj.TabId = $('#InciContract').attr('IdStr');
					url = url + '?' + 'TabParams=' + encodeUrlStr(JSON.stringify(Obj));
					Common_AddTab(tabTitle, url);
				});
			}
		});
	}
	// ������ռ�ȷ���
	$.cm({
		ClassName: 'web.DHCSTMHUI.Charts',
		MethodName: 'GetScgChildNode',
		NodeId: 'AllSCG',
		StrParam: gLocId + '^' + gUserId + '^^^' + 'Amt',
		Type: 'M'
	}, function(jsonData) {
		sunburstAmt(jsonData);
	});
	function sunburstAmt(data) {
		// ָ��ͼ������ú�����
		var option = {
			tooltip: {
				trigger: 'item'
			},
			legend: {
				type: 'scroll',
				orient: 'vertical',
				left: 5,
				top: 45
			},
			series: [
				{
					type: 'pie',
					radius: '70%',
					center: ['60%', '50%'],
					avoidLabelOverlap: false,
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
							fontSize: 10,
							fontWeight: 'bold'
						}
					},
					labelLine: {
						show: false
					},
					data: data
				}
			]
		};
		// ��ʼ��echartsʵ��
		var Chart = echarts.init(document.getElementById('sunburstAmt'), 'macarons');
		Chart.setOption(option);
	}
	// ��������ռ�ȷ���
	$.cm({
		ClassName: 'web.DHCSTMHUI.Charts',
		MethodName: 'GetScgChildNode',
		NodeId: 'AllSCG',
		StrParam: gLocId + '^' + gUserId + '^^^' + 'Qty',
		Type: 'M'
	}, function(jsonData) {
		sunburstQty(jsonData);
	});
	function sunburstQty(data) {
		// ָ��ͼ������ú�����
		var option = {
			/* title: {
				text: '������ռ�ȷ���',
				// subtext: 'Fake Data',
				left: 'center'
			},*/
			tooltip: {
				trigger: 'item'
			},
			legend: {
				type: 'scroll',
				orient: 'vertical',
				left: 5,
				top: 45
			},
			series: {
				type: 'pie', // ����ͼ������Ϊ��ͼ
				radius: '70%', // ��ͼ�İ뾶����뾶Ϊ�������ߴ磨�����߿��н�Сһ��� 55% ����
				center: ['60%', '50%'],
				// roseType: 'angle',
				// radius: '50%',
				avoidLabelOverlap: false,
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
						fontSize: 10,
						fontWeight: 'bold',
						formatter: '{b}:{c}'
					}
				},
				labelLine: {
					show: false
				},
				data: data
			}
		};
		// ��ʼ��echartsʵ��
		var Chart = echarts.init(document.getElementById('sunburstQty'), 'macarons');
		Chart.setOption(option);
	}
	initTips();
};
$(init);
