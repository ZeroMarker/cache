// /����: ���۵�(����)��ѯ
// /����: ���۵�(����)��ѯ
// /��д�ߣ�zhangxiao
// /��д����: 2018.07.12
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
		$UI.clear(MasterGrid);
		$UI.clear(DetailGrid);
		var DefaultData = {
			StartDate: DateFormatter(new Date()),
			EndDate: DateFormatter(new Date()),
			AdjSPCat: '0'
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
		$UI.clear(MasterGrid);
		$UI.clear(DetailGrid);
		MasterGrid.load({
			ClassName: 'web.DHCSTMHUI.INAdjPriceBatch',
			QueryName: 'QueryAspBatNo',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	var MasterGridCm = [[
		{
			title: '���۵�ID',
			field: 'AspBatIdStr',
			width: 200,
			hidden: true
		}, {
			title: '���۵���',
			field: 'AspNo',
			width: 150
		}, {
			title: '����������',
			field: 'AspDate',
			width: 100,
			align: 'right'
		}, {
			title: '������',
			field: 'AspUser',
			width: 70,
			align: 'right'
		}
	]];
	var MasterGrid = $UI.datagrid('#MasterGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INAdjPriceBatch',
			QueryName: 'QueryAspBatNo',
			query2JsonStrict: 1
		},
		columns: MasterGridCm,
		fitColumns: true,
		showBar: true,
		onSelect: function(index, row) {
			var ParamsObj = $UI.loopBlock('Conditions');
			var Params = JSON.stringify(ParamsObj);
			DetailGrid.load({
				ClassName: 'web.DHCSTMHUI.INAdjPriceBatch',
				QueryName: 'QueryDetail',
				query2JsonStrict: 1,
				AspNo: row.AspNo,
				AspBatIdStr: row.AspBatIdStr,
				Params: Params
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	var DetailGridCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: 'Incib',
			field: 'Incib',
			hidden: true,
			width: 60
		}, {
			title: '״̬',
			field: 'Status',
			width: 80
		}, {
			title: '������',
			field: 'StkCatDesc',
			width: 80
		}, {
			title: '���ʴ���',
			field: 'InciCode',
			width: 120
		}, {
			title: '��������',
			field: 'InciDesc',
			width: 150
		}, {
			title: '���',
			field: 'Spec',
			width: 100
		}, {
			title: '���۵�λ',
			field: 'AspUomDesc',
			width: 100
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
			width: 80
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
			width: 100
		}, {
			title: '����ԭ��',
			field: 'AdjReason',
			width: 80,
			align: 'center'
		}, {
			title: '����ļ���',
			field: 'WarrentNo',
			width: 100,
			align: 'center'
		}, {
			title: '�ƻ���Ч����',
			field: 'PreExecuteDate',
			width: 100,
			align: 'center'
		}, {
			title: 'ʵ����Ч����',
			field: 'ExecuteDate',
			width: 100,
			align: 'left'
		}, {
			title: '�Ƶ���',
			field: 'AdjUserName',
			width: 60,
			align: 'left'
		}, {
			title: '�����',
			field: 'AuditUserName',
			width: 60,
			align: 'left'
		}, {
			title: '��Ч��',
			field: 'ExeUserName',
			width: 60,
			align: 'left'
		}, {
			title: '����/��Ч��',
			field: 'BatExp',
			width: 100,
			align: 'left'
		}
	]];
	var DetailGrid = $UI.datagrid('#DetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INAdjPriceBatch',
			QueryName: 'QueryDetail',
			query2JsonStrict: 1
		},
		columns: DetailGridCm,
		showBar: true
	});
	Clear();
	Query();
};
$(init);