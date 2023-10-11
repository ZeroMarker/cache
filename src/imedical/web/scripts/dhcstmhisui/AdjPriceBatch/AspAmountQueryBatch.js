// /����: ���������ѯ
// /����: ���������ѯ
// /��д�ߣ�zhangxiao
// /��д����: 2018.06.15
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
	var LocParams = JSON.stringify(addSessionParams({ Type: 'Login' }));
	var LocBox = $HUI.combobox('#Loc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var Clear = function() {
		$UI.clearBlock('#Conditions');
		$UI.clear(DetailGrid);
		var DefaultData = {
			StartDate: DateFormatter(new Date()),
			EndDate: DateFormatter(new Date()),
			Loc: gLocObj,
			OptType: '1'
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
		DetailGrid.load({
			ClassName: 'web.DHCSTMHUI.AspAmount',
			QueryName: 'QueryAspBatAmount',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	var DetailGridCm = [[
		{
			title: 'AspaIdLb',
			field: 'AspaIdLb',
			hidden: true,
			width: 60
		}, {
			title: 'Incib',
			field: 'Incib',
			hidden: true,
			width: 60
		}, {
			title: '���ʴ���',
			field: 'InciCode',
			width: 120
		}, {
			title: '��������',
			field: 'InciDesc',
			width: 150
		}, {
			title: '����/Ч��',
			field: 'BatExp',
			width: 100
		}, {
			title: '���',
			field: 'Spec',
			width: 100
		}, {
			title: '���۵�λ',
			field: 'AspUom',
			width: 100
		}, {
			title: '�����',
			field: 'StkLbQty',
			align: 'right',
			hidden: true,
			width: 100
		}, {
			title: '��ǰ�ۼ�',
			field: 'PriorSp',
			width: 100,
			align: 'right'
		}, {
			title: '�����ۼ�',
			field: 'ResultSp',
			width: 100,
			align: 'right'
		}, {
			title: '���(�ۼ�)',
			field: 'DiffSp',
			hidden: true,
			width: 80
		}, {
			title: '��ǰ����',
			field: 'PriorRp',
			width: 100,
			align: 'right'
		}, {
			title: '�������',
			field: 'ResultRp',
			width: 100,
			align: 'right'
		}, {
			title: '���(����)',
			field: 'DiffRp',
			hidden: true,
			width: 100
		}, {
			title: '������(�ۼ�)',
			field: 'SpLbAmt',
			width: 120,
			align: 'center'
		}, {
			title: '������(����)',
			field: 'RpLbAmt',
			width: 120,
			align: 'center'
		}, {
			title: '����',
			field: 'LocDesc',
			width: 100,
			align: 'center'
		}, {
			title: '��Ч����',
			field: 'ExecuteDate',
			width: 100,
			align: 'left'
		}, {
			title: '������',
			field: 'AspUser',
			width: 60,
			align: 'left'
		}, {
			title: '����ԭ��',
			field: 'AspReason',
			width: 60,
			align: 'left'
		}
	]];
	var DetailGrid = $UI.datagrid('#DetailGrid', {
		url: $URL,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.AspAmount',
			QueryName: 'QueryAspBatAmount',
			query2JsonStrict: 1
		},
		sortName: 'RowId',
		sortOrder: 'Desc',
		showBar: true,
		columns: DetailGridCm,
		navigatingWithKey: true,
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	
	Clear();
	Query();
};
$(init);