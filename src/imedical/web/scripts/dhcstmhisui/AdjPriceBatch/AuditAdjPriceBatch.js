// /����: ��˵��۵�(����)
// /����: ��˵��۵�(����)
// /��д�ߣ�zhangxiao
// /��д����: 2018.07.16
var init = function() {
	var InciHandlerParams = function() {
		var Scg = $('#ScgId').combotree('getValue');
		var Obj = {
			StkGrpRowId: Scg,
			StkGrpType: 'M',
			BDPHospital: gHospId
		};
		return Obj;
	};
	$('#InciDesc').lookup(InciLookUpOp(InciHandlerParams, '#InciDesc', '#Inci'));
	var Clear = function() {
		$UI.clearBlock('#Conditions');
		$UI.clear(DetailGrid);
		var DefaultData = {
			StartDate: DateFormatter(new Date()),
			EndDate: DateFormatter(new Date()),
			Status: 'N'
		};
		$UI.fillBlock('#Conditions', DefaultData);
		$('#ScgId').combotree('options')['setDefaultFun']();
	};
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		var ParamsObj = $UI.loopBlock('Conditions');
		var StartDate = ParamsObj.StartDate;
		var EndDate = ParamsObj.EndDate;
		if (isEmpty(StartDate)) {
			$UI.msg('alert', '��ʼ���ڲ���Ϊ��!');
			return;
		}
		if (isEmpty(EndDate)) {
			$UI.msg('alert', '��ֹ���ڲ���Ϊ��!');
			return;
		}
		if (compareDate(StartDate, EndDate)) {
			$UI.msg('alert', '��ֹ���ڲ���С�ڿ�ʼ����!');
			return;
		}
		var Params = JSON.stringify(ParamsObj);
		$UI.clear(DetailGrid);
		DetailGrid.load({
			ClassName: 'web.DHCSTMHUI.INAdjPriceBatch',
			QueryName: 'QueryAspBatInfo',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	$UI.linkbutton('#DenyBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#Conditions');
			var Params = JSON.stringify(ParamsObj);
			var Rows = DetailGrid.getSelectedData();
			if (Rows === false) { return; } // ��֤δͨ��  ���ܱ���
			if (Rows == '') {
				$UI.msg('alert', '��ѡ����Ҫȡ����˵ĵ��۵�!');
				return false;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.INAdjPriceBatch',
				MethodName: 'SetCancelAudit',
				Params: Params,
				Rows: JSON.stringify(Rows)
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					$UI.clear(DetailGrid);
					Query();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#AduitBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#Conditions');
			var Params = JSON.stringify(ParamsObj);
			var Rows = DetailGrid.getSelectedData();
			if (Rows === false) { return; } // ��֤δͨ��  ���ܱ���
			if (Rows == '') {
				$UI.msg('alert', '��ѡ����Ҫ��˵ĵ��۵�!');
				return false;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.INAdjPriceBatch',
				MethodName: 'SetAudit',
				Params: Params,
				Rows: JSON.stringify(Rows)
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					$UI.clear(DetailGrid);
					Query();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	var DetailCm = [[
		{	field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			saveCol: true,
			hidden: true,
			width: 60
		}, {
			title: '���۵���',
			field: 'AspNo',
			width: 180
		}, {
			title: 'Incib',
			field: 'Incib',
			hidden: true,
			width: 60
		}, {
			title: '״̬',
			field: 'Status',
			width: 100
		}, {
			title: '������',
			field: 'StkCatDesc',
			width: 100,
			align: 'left'
		}, {
			title: '����RowId',
			field: 'Inci',
			hidden: true,
			width: 60
		}, {
			title: '���ʴ���',
			field: 'InciCode',
			width: 100
		}, {
			title: '��������',
			field: 'InciDesc',
			width: 150
		}, {
			title: '���',
			field: 'Spec',
			width: 100
		}, {
			title: '����/Ч��',
			field: 'BatExp',
			width: 100
		}, {
			title: '���۵�λ',
			field: 'AspUomDesc',
			width: 100,
			align: 'right'
		}, {
			title: '��ǰ�ۼ�',
			field: 'PriorSpUom',
			width: 100,
			align: 'right'
		}, {
			title: '�����ۼ�',
			field: 'ResultSpUom',
			width: 100,
			align: 'right'
		}, {
			title: '���(�ۼ�)',
			field: 'DiffSpUom',
			width: 100,
			align: 'right'
		}, {
			title: '��ǰ����',
			field: 'PriorRpUom',
			width: 100,
			align: 'right'
		}, {
			title: '�������',
			field: 'ResultRpUom',
			width: 100,
			align: 'right'
		}, {
			title: '���(����)',
			field: 'DiffRpUom',
			width: 100,
			align: 'right'
		}, {
			title: '�Ƶ�����',
			field: 'AdjDate',
			width: 120,
			align: 'left'
		}, {
			title: '�ƻ���Ч����',
			field: 'PreExecuteDate',
			width: 120,
			align: 'left'
		}, {
			title: 'ʵ����Ч����',
			field: 'ExecuteDate',
			width: 120,
			align: 'left'
		}, {
			title: '����ԭ��',
			field: 'AdjReason',
			width: 120,
			align: 'left'
		}, {
			title: '������',
			field: 'AdjUserName',
			width: 100,
			align: 'left'
		}, {
			title: '��������',
			field: 'MarkTypeDesc',
			width: 120,
			align: 'left'
		}, {
			title: '����ļ���',
			field: 'WarrentNo',
			width: 120,
			align: 'left'
		}, {
			title: '����ļ�����',
			field: 'WnoDate',
			width: 120,
			align: 'left'
		}
	]];
	var DetailGrid = $UI.datagrid('#DetailGrid', {
		url: $URL,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INAdjPriceBatch',
			QueryName: 'QueryAspBatInfo',
			query2JsonStrict: 1
		},
		columns: DetailCm,
		singleSelect: false,
		showBar: true,
		sortName: 'RowId',
		sortOrder: 'Desc',
		navigatingWithKey: true,
		onLoadSuccess: function(data) {
			if ((data.rows.length > 0) && (CommParObj.IfSelFirstRow == 'Y')) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	Clear();
	Query();
};
$(init);