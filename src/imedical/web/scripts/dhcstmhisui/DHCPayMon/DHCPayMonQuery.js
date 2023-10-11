/* �����±���ϸ��ѯ*/
var init = function() {
	var growid = '';
	function GetParamsObj() {
		var ParamsObj = $UI.loopBlock('#PayMonTabConditions');
		return ParamsObj;
	}
	
	var PayMonLocParams = JSON.stringify(addSessionParams({ Type: 'Login' }));
	var PayMonLocBox = $HUI.combobox('#HistoryPayMonStatLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + PayMonLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var StkCatBox = $HUI.combobox('#StkCatBox', {
		valueField: 'RowId',
		textField: 'Description'
	});
	$('#StkGrpId').stkscgcombotree({
		onSelect: function(node) {
			$.cm({
				ClassName: 'web.DHCSTMHUI.Common.Dicts',
				QueryName: 'GetStkCat',
				ResultSetType: 'array',
				StkGrpId: node.id
			}, function(data) {
				StkCatBox.clear();
				StkCatBox.loadData(data);
			});
		}
	});
	$HUI.tabs('#PayMonTab', {
		onSelect: function(title) {
			var row = HistoryPayMonStatGrid.getSelected();
			if (isEmpty(row)) { return false; }
			growid = row.pmRowid;
			if (title == '�����±�����(��Ӧ��)') {
				p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_PayMDetailRp.raq'
					+ '&growid=' + growid;
				var reportFrame = document.getElementById('frameReportPayMonDetail');
				reportFrame.src = CommonFillUrl(p_URL);
			} else if (title == '�����±���ϸ(��Ӧ�̷���)') {
				p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_PayMLBDetailRp.raq'
					+ '&growid=' + growid;
				var reportFrame = document.getElementById('frameReportPayMonVenCatDetail');
				reportFrame.src = CommonFillUrl(p_URL);
			}
		}
	});
	var HistoryPayMonStatCm = [[
		{
			title: 'pmRowid',
			field: 'pmRowid',
			width: 100,
			hidden: true
		}, {
			title: '�·�',
			field: 'MonthDate',
			width: 100,
			align: 'left'
		}, {
			title: '����',
			field: 'locDesc',
			width: 230,
			align: 'left'
		}, {
			title: '�±���ʼ����',
			field: 'frDate',
			width: 100,
			align: 'left'
		}, {
			title: '�±���ֹ����',
			field: 'toDate',
			width: 100,
			align: 'left'
		}
	]];
	var HistoryPayMonStatGrid = $UI.datagrid('#HistoryPayMonStatGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCPayMon',
			QueryName: 'DHCPayMon',
			query2JsonStrict: 1
		},
		columns: HistoryPayMonStatCm,
		displayMsg: '',
		onSelect: function(index, row) {
			$('#PayMonTab').tabs('select', '�����±�����(��Ӧ��)');
			growid = row.pmRowid;
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_PayMDetailRp.raq'
				+ '&growid=' + growid;
			var reportFrame = document.getElementById('frameReportPayMonDetail');
			reportFrame.src = CommonFillUrl(p_URL);
		}
	});
	$UI.linkbutton('#PrintBT', {
		onClick: function() {
			var activeTabtmp = $('#PayMonTab').tabs('getSelected').panel('options').title;
			PrintPayMon(growid, activeTabtmp);
		}
	});
	$UI.linkbutton('#SearchBT', {
		onClick: function() {
			QueryHistoryPayMonStat();
		}
	});
	function QueryHistoryPayMonStat() {
		var ParamsObj = $UI.loopBlock('#HistoryPayMonStatConditions');
		if (isEmpty(ParamsObj.HistoryPayMonStatLoc)) {
			$UI.msg('alert', '���Ҳ���Ϊ��!');
			return false;
		}
		var StartMonth = ParamsObj.StartDate;
		var EndMonth = ParamsObj.EndDate;
		var StartDate = StartMonth + '-01';
		var EndDate = EndMonth + '-01';
		if ((isEmpty(StartMonth)) || (isEmpty(EndMonth))) {
			$UI.msg('alert', '��ʼ����/��ֹ���²���Ϊ��!');
			return false;
		}
		if ((!isEmpty(StartDate)) && (!isEmpty(EndDate)) && compareDate(StartDate, EndDate)) {
			$UI.msg('alert', '��ֹ�·ݲ���С�ڿ�ʼ�·�!');
			return;
		}
		HistoryPayMonStatGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCPayMon',
			QueryName: 'DHCPayMon',
			query2JsonStrict: 1,
			loc: ParamsObj.HistoryPayMonStatLoc,
			StartDate: StartDate,
			EndDate: EndDate
		});
	}
	function ClearHistoryPayMonStat() {
		$UI.clearBlock('#HistoryPayMonStatConditions');
		$UI.clear(HistoryPayMonStatGrid);
		// /���ó�ʼֵ ����ʹ������
		var DefaultData = {
			HistoryPayMonStatLoc: gLocObj
		};
		$UI.fillBlock('#HistoryPayMonStatConditions', DefaultData);
		GetReportStyle('#frameReportPayMonDetail');
		GetReportStyle('#frameReportPayMonVenCatDetail');
	}
	ClearHistoryPayMonStat();
};
$(init);