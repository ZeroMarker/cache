/* ̨�˲�ѯ*/
var init = function() {
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			QueryMasterInfo();
		}
	});
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			MasterClear();
		}
	});
	var PhaLocParams = JSON.stringify(addSessionParams({ Type: 'Login' }));
	var PhaLocBox = $HUI.combobox('#PhaLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + PhaLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var LocId = record['RowId'];
			$HUI.combotree('#StkGrpId').setFilterByLoc(LocId);
		}
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
	var StkCatBox = $HUI.combobox('#StkCat', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	var HandlerParams = function() {
		var StkGrpId = $('#StkGrpId').combotree('getValue');
		var PhaLoc = $('#PhaLoc').combo('getValue');
		var Obj = { StkGrpRowId: StkGrpId, StkGrpType: 'M', Locdr: PhaLoc };
		return Obj;
	};
	$('#InciDesc').lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#Inci'));
	var StockTypeBox = $HUI.combobox('#StockType', {
		data: [{ 'RowId': 0, 'Description': 'ȫ��' }, { 'RowId': 1, 'Description': '���Ϊ��' }, { 'RowId': 2, 'Description': '���Ϊ��' }, { 'RowId': 3, 'Description': '���Ϊ��' }, { 'RowId': 4, 'Description': '������' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	var QueryFlagBox = $HUI.combobox('#QueryFlag', {
		data: [{ 'RowId': '', 'Description': 'ȫ��' }, { 'RowId': '1', 'Description': '������' }, { 'RowId': '2', 'Description': '��������' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	var TransTypeBox = $HUI.combobox('#TransType', {
		data: [
			{ 'RowId': '', 'Description': 'ȫ��' },
			{ 'RowId': 'G', 'Description': '���' },
			{ 'RowId': 'R', 'Description': '�˻�' },
			{ 'RowId': 'T', 'Description': 'ת�Ƴ���' },
			{ 'RowId': 'K', 'Description': 'ת�����' },
			{ 'RowId': 'A', 'Description': '������' },
			{ 'RowId': 'D', 'Description': '��汨��' },
			{ 'RowId': 'MP', 'Description': 'סԺҽ��' },
			{ 'RowId': 'MY', 'Description': 'סԺҽ��ȡ��' },
			{ 'RowId': 'MF', 'Description': '����ҽ��' },
			{ 'RowId': 'MH', 'Description': '����ҽ��ȡ��' },
			{ 'RowId': 'MDP', 'Description': 'סԺҽ������' },
			{ 'RowId': 'MDY', 'Description': 'סԺҽ���˻�' },
			{ 'RowId': 'C', 'Description': '�����ڷ���' },
			{ 'RowId': 'L', 'Description': '�������˻�' }
		],
		valueField: 'RowId',
		textField: 'Description'
	});
	$UI.linkbutton('#FilterBtn', {
		onClick: function() {
			QueryDetailInfo();
		}
	});
	function QueryDetailInfo() {
		var row = MasterInfoGrid.getSelected();
		if (isEmpty(row)) {
			return;
		}
		var ParamsObj = $UI.loopBlock('#Conditions');
		var DeatilParamsObj = $UI.loopBlock('#FilterTB');
		var ParamStr = JSON.stringify($.extend(ParamsObj, { TransType: DeatilParamsObj.TransType }));
		MasterDetailInfoGrid.load({
			ClassName: 'web.DHCSTMHUI.LocItmTransMove',
			MethodName: 'LocItmStkMoveDetail',
			ParamStr: JSON.stringify(ParamsObj),
			INCIL: row.INCIL
		});
	}
	var MasterInfoCm = [[
		{
			title: 'INCIL',
			field: 'INCIL',
			width: 60,
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'InciCode',
			width: 120
		}, {
			title: '��������',
			field: 'InciDesc',
			width: 200
		}, {
			title: '���',
			field: 'Spec',
			width: 100
		}, {
			title: '������',
			field: 'StkCat',
			width: 100
		}, {
			title: '��ⵥλ',
			field: 'PurUom',
			width: 70
		}, {
			title: '������λ',
			field: 'BUom',
			width: 90
		}, {
			title: '�ڳ����',
			field: 'BegQtyUom',
			width: 70,
			align: 'right'
		}, {
			title: '�ڳ����(����)',
			field: 'BegRpAmt',
			width: 70,
			align: 'right'
		}, {
			title: '�ڳ����(�ۼ�)',
			field: 'BegSpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '��ĩ���',
			field: 'EndQtyUom',
			width: 100,
			align: 'right'
		}, {
			title: '��ĩ���(����)',
			field: 'EndRpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '��ĩ���(�ۼ�)',
			field: 'EndSpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '����ҽ������',
			field: 'MatInsuCode',
			width: 160
		}, {
			title: '����ҽ������',
			field: 'MatInsuDesc',
			width: 160
		}
	]];

	var ParamsObj = $UI.loopBlock('#Conditions');
	var MasterInfoGrid = $UI.datagrid('#MasterInfoGrid', {
		lazy: true,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.LocItmTransMove',
			MethodName: 'LocItmStkMoveSum',
			Params: JSON.stringify(ParamsObj)
		},
		columns: MasterInfoCm,
		showBar: true,
		onSelect: function(index, row) {
			var ParamsObj = $UI.loopBlock('#Conditions');
			var DeatilParamsObj = $UI.loopBlock('#FilterTB');
			var ParamStr = JSON.stringify($.extend(ParamsObj, { TransType: DeatilParamsObj.TransType }));
			MasterDetailInfoGrid.load({
				ClassName: 'web.DHCSTMHUI.LocItmTransMove',
				MethodName: 'LocItmStkMoveDetail',
				ParamStr: JSON.stringify(ParamsObj),
				INCIL: row.INCIL
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	var DetailInfoCm = [[
		{
			title: 'TrId',
			field: 'TrId',
			width: 100,
			hidden: true
		}, {
			title: '����',
			field: 'TrDate',
			width: 150
		}, {
			title: '����Ч��',
			field: 'BatExp',
			width: 150
		}, {
			title: '��λ',
			field: 'PurUom',
			width: 80
		}, {
			title: '��ֵ����',
			field: 'HVBarCode',
			width: 140
		}, {
			title: '����',
			field: 'Rp',
			width: 80,
			align: 'right'
		}, {
			title: '�ۼ�',
			field: 'Sp',
			width: 80,
			align: 'right'
		}, {
			title: '��������',
			field: 'EndQtyUom',
			width: 100
		}, {
			title: '���ν���',
			field: 'EndQtyUomInclb',
			width: 100
		}, {
			title: '����',
			field: 'TrQtyUom',
			width: 100
		}, {
			title: '���۽��',
			field: 'RpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '�ۼ۽��',
			field: 'SpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '�����',
			field: 'TrNo',
			width: 120
		}, {
			title: 'ҵ����Ϣ',
			field: 'TrAdm',
			width: 100
		}, {
			title: 'ҵ������',
			field: 'TrMsg',
			width: 100
		}, {
			title: 'ҵ����',
			field: 'OperateUser',
			width: 100
		}, {
			title: '������(����)',
			field: 'EndRpAmt',
			width: 120,
			align: 'right'
		}, {
			title: '������(�ۼ�)',
			field: 'EndSpAmt',
			width: 120,
			align: 'right'
		}, {
			title: '��Ӧ��',
			field: 'Vendor',
			width: 160
		}, {
			title: '��������',
			field: 'Manf',
			width: 160
		}
	]];
	var MasterDetailInfoGrid = $UI.datagrid('#MasterDetailInfoGrid', {
		lazy: true,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.LocItmTransMove',
			MethodName: 'LocItmStkMoveDetail'
		},
		idFiled: 'TrId',
		columns: DetailInfoCm,
		showBar: true,
		toolbar: '#FilterTB',
		onClickRow: function(index, row) {
			MasterDetailInfoGrid.commonClickRow(index, row);
		}
	});
	function QueryMasterInfo() {
		var ParamsObj = $UI.loopBlock('#Conditions');
		var StartDate = ParamsObj.StartDate;
		var EndDate = ParamsObj.EndDate;
		if (isEmpty(ParamsObj.PhaLoc)) {
			$UI.msg('alert', '���Ҳ���Ϊ��!');
			return;
		}
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
		$UI.clear(MasterDetailInfoGrid);
		MasterInfoGrid.load({
			ClassName: 'web.DHCSTMHUI.LocItmTransMove',
			MethodName: 'LocItmStkMoveSum',
			Params: Params
		});
	}
	function MasterClear() {
		$UI.clearBlock('#Conditions');
		$UI.clear(MasterInfoGrid);
		$UI.clear(MasterDetailInfoGrid);
		var DefaultData = {
			StartDate: DateFormatter(new Date()),
			EndDate: DateFormatter(new Date()),
			PhaLoc: gLocObj
		};
		$UI.fillBlock('#Conditions', DefaultData);
	}
	MasterClear();
};
$(init);