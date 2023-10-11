/*
����Ƶ�
 */
var init = function() {
	// ������
	var RedLocParams = JSON.stringify(addSessionParams({
		Type: 'Login',
		Element: 'RedLoc'
	}));
	var RedLocBox = $HUI.combobox('#RedLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + RedLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});
	var Clear = function() {
		$UI.clearBlock('#MainConditions');
		$UI.clear(RedGrid);
		var Dafult = {
			RedLoc: gLocObj
		};
		$UI.fillBlock('#MainConditions', Dafult);
	};
	$UI.linkbutton('#DelBT', {
		onClick: function() {
			$UI.confirm('ȷ��Ҫɾ����?', '', '', DelRed);
		}
	});
	function DelRed() {
		var RowId = $('#RowId').val();
		if (isEmpty(RowId)) {
			$UI.msg('alert', '��嵥������!');
			return false;
		}
		if ($HUI.checkbox('#Comp').getValue()) {
			$UI.msg('alert', '��嵥����ɲ���ɾ��!');
			return false;
		}
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.RedOffset',
			MethodName: 'jsDelete',
			RedId: RowId
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				Clear();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	$UI.linkbutton('#ComBT', {
		onClick: function() {
			MakeComplete();
		}
	});
	function MakeComplete() {
		var RowId = $('#RowId').val();
		if (isEmpty(RowId)) {
			$UI.msg('alert', '��嵥������!');
			return false;
		}
		if ($HUI.checkbox('#Comp').getValue()) {
			$UI.msg('alert', '��嵥�����!');
			return false;
		}
		var RowData = RedGrid.getRowsData();
		if (isEmpty(RowData) || RowData.length == 0) {
			$UI.msg('alert', '��嵥����ϸ!');
			return false;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.RedOffset',
			MethodName: 'jsMakeComplete',
			RedId: RowId
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				Select(RowId);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}

	$UI.linkbutton('#CanComBT', {
		onClick: function() {
			var RowId = $('#RowId').val();
			CancelComplete(RowId);
		}
	});
	function CancelComplete(RowId) {
		if (isEmpty(RowId)) {
			$UI.msg('alert', '��嵥������!');
			return false;
		}
		var Params = JSON.stringify(addSessionParams());
		$.cm({
			ClassName: 'web.DHCSTMHUI.RedOffset',
			MethodName: 'jsCancleComplete',
			RedId: RowId
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				Select(RowId);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	$UI.linkbutton('#CreateBT', {
		onClick: function() {
			Create(Select);
		}
	});
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			RedFind(Select);
		}
	});
	var Select = function(RedId) {
		$UI.clearBlock('#MainConditions');
		$UI.clear(RedGrid);
		$.cm({
			ClassName: 'web.DHCSTMHUI.RedOffset',
			MethodName: 'Select',
			RedId: RedId
		}, function(jsonData) {
			$UI.fillBlock('#MainConditions', jsonData);
		});
		RedGrid.load({
			ClassName: 'web.DHCSTMHUI.RedOffsetItm',
			QueryName: 'QueryDetail',
			query2JsonStrict: 1,
			Parref: RedId,
			rows: 99999
		});
	};
	function SaveRedInfo() {
		var IsChange = $UI.isChangeBlock('#MainConditions');
		var DetailObj = RedGrid.getRowsData();
		if (DetailObj === false) {
			return false;
		} else if ((DetailObj.length == 0) && IsChange == false) {
			$UI.msg('alert', '����Ҫ�������ϸ!');
			return false;
		}
		var MainObj = GetParamsObj();
		var Main = JSON.stringify(MainObj);
		var Detail = JSON.stringify(DetailObj);
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.RedOffset',
			MethodName: 'jsSave',
			MainInfo: Main,
			ListData: Detail
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				var Rowid = jsonData.rowid;
				Select(Rowid);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	var RedCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '����RowId',
			field: 'IncId',
			width: 100,
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'InciCode',
			width: 100
		}, {
			title: '��������',
			field: 'InciDesc',
			width: 230
		}, {
			title: '���',
			field: 'Spec',
			width: 100
		}, {
			title: '�ͺ�',
			field: 'Model',
			width: 100
		}, {
			title: '��������RowId',
			field: 'ManfId',
			width: 150,
			hidden: true
		}, {
			title: '��������',
			field: 'Manf',
			width: 150
		}, {
			title: '����',
			field: 'BatchNo',
			width: 90
		}, {
			title: '��Ч��',
			field: 'ExpDate',
			width: 120
		}, {
			title: '��λ',
			field: 'Uom',
			width: 70
		}, {
			title: '����',
			field: 'Qty',
			width: 80,
			align: 'right'
		}, {
			title: '�½���',
			field: 'NewRp',
			width: 60,
			align: 'right'
		}, {
			title: '���ۼ�',
			field: 'NewSp',
			align: 'right',
			width: 60
		}, {
			title: 'ԭ����',
			field: 'OldRp',
			width: 60,
			align: 'right'
		}, {
			title: 'ԭ�ۼ�',
			field: 'OldSp',
			align: 'right',
			width: 60
		}, {
			title: '�½��۽��',
			field: 'NewRpAmt',
			align: 'right',
			width: 100
		}, {
			title: '���ۼ۽��',
			field: 'NewSpAmt',
			align: 'right',
			width: 100
		}
	]];
	var RedGrid = $UI.datagrid('#RedGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.RedOffsetItm',
			QueryName: 'QueryDetail',
			query2JsonStrict: 1,
			rows: 99999
		},
		singleSelect: false,
		columns: RedCm,
		idField: 'RowId',
		showBar: true,
		remoteSort: false,
		pagination: false,
		onClickRow: function(index, row) {
			RedGrid.commonClickRow(index, row);
		}
	});
	Clear();
};
$(init);