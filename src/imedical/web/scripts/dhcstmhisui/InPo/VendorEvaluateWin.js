var VendorEvaluateWin = function(Pointer) {
	$HUI.dialog('#VendorEvaluateWin').open();
	var ReasonData = '';
	var ReasonCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.DHCVendorEvaluationIndex&QueryName=EvalReason&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Desc',
			multiple: true,
			selectOnNavigation: false,
			rowStyle: 'checkbox',
			onBeforeLoad: function(param) {
				var rows = MainGrid.getRows();
				var row = rows[MainGrid.editIndex];
				if (!isEmpty(row)) {
					param.Parref = row.IndexId;
				}
			},
			onLoadSuccess: function() {
				ReasonData = $(this).combobox('getData');
			},
			onSelect: function(record) {
				var rows = MainGrid.getRows();
				var row = rows[MainGrid.editIndex];
				var Reason = $(this).combobox('getValues').join(',');
				row.ReasonId = Reason;
				row.ReasonDesc = $(this).combobox('getText'); // tkMakeServerCall('web.DHCSTMHUI.DHCVendorEvaluationIndex', 'EvalReasonDescByReason', Reason);
				var Score = tkMakeServerCall('web.DHCSTMHUI.DHCVendorEvaluationIndex', 'EvalScoreByReason', Reason);
				row.Score = Number(Score);
			},
			onUnselect: function(record) {
				var rows = MainGrid.getRows();
				var row = rows[MainGrid.editIndex];
				var Reason = $(this).combobox('getValues').join(',');
				row.ReasonId = Reason;
				row.ReasonDesc = $(this).combobox('getText');
				var Score = tkMakeServerCall('web.DHCSTMHUI.DHCVendorEvaluationIndex', 'EvalScoreByReason', Reason);
				row.Score = Number(Score);
			},
			onAllSelectClick: function(e) {
				var rows = MainGrid.getRows();
				var row = rows[MainGrid.editIndex];
				var Reason = $(this).combobox('getValues').join(',');
				row.ReasonId = Reason;
				row.ReasonDesc = $(this).combobox('getText');
				var Score = tkMakeServerCall('web.DHCSTMHUI.DHCVendorEvaluationIndex', 'EvalScoreByReason', Reason);
				row.Score = Number(Score);
			},
			onShowPanel: function() {
				$(this).combobox('reload');
			}
		}
	};
	var MainCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '����ָ��Id',
			field: 'IndexId',
			width: 50,
			hidden: true
		}, {
			title: '����ָ��',
			field: 'IndexDesc',
			width: 150
		}, {
			title: '����',
			field: 'Score',
			editor: {
				type: 'numberbox',
				options: {
					min: 0,
					precision: 2
				}
			},
			width: 100
		}, {
			title: '�۷���',
			field: 'ReasonId',
			editor: ReasonCombox,
			formatter: CommonFormatter(ReasonCombox, 'ReasonId', 'ReasonDesc'),
			width: 150
		}, {
			title: '��ע',
			field: 'Remark',
			editor: {
				type: 'text'
			},
			width: 150
		}, {
			title: '�ύ״̬',
			field: 'SubmitFlag',
			width: 50,
			hidden: true
		}, {
			title: '�����Ƿ���޸�',
			field: 'ScoreEdited',
			width: 110,
			formatter: BoolFormatter
		}
	]];
	var MainGrid = $UI.datagrid('#EvaluateGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCVendorEvaluationIndex',
			QueryName: 'GetIndexByPointer',
			query2JsonStrict: 1
		},
		columns: MainCm,
		pagination: false,
		onClickCell: function(index, filed, value) {
			var Row = MainGrid.getRows()[index];
			if ((filed == 'Score') && (Row.ScoreEdited == 'N')) {
				$UI.msg('alert', '���������޸�');
				return false;
			}
			MainGrid.commonClickCell(index, filed, value);
		}
	});

	$UI.linkbutton('#VSaveBT', {
		onClick: function() {
			VSave();
		}
	});
	$UI.linkbutton('#VSubmitBT', {
		onClick: function() {
			VSubmit();
		}
	});

	function VSave() {
		var DetailObj = MainGrid.getRowsData();
		if (DetailObj === false) {
			return false;
		} else if (DetailObj.length == 0) {
			$UI.msg('alert', '����ά����Ӧ������ָ��!');
			return false;
		}
		var SubmitFlag = DetailObj[0].SubmitFlag;
		if (SubmitFlag == 'Y') {
			$UI.msg('alert', '��Ӧ��������Ϣ���ύ,�����޸�!');
			MainGrid.reload();
			return false;
		}
		var Detail = JSON.stringify(DetailObj);
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCVendorEvaluationIndex',
			MethodName: 'SaveVenEvalByPointer',
			Pointer: Pointer,
			List: Detail,
			Type: 'P'
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				MainGrid.reload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	function VSubmit() {
		var DetailObj = MainGrid.getRowsData();
		if (DetailObj === false) {
			return false;
		} else if (DetailObj.length == 0) {
			$UI.msg('alert', '����ά����Ӧ������ָ��!');
			return false;
		}
		var SubmitFlag = DetailObj[0].SubmitFlag;
		if (SubmitFlag == 'Y') {
			$UI.msg('alert', '��Ӧ��������Ϣ���ύ,�����ظ��ύ!');
			MainGrid.reload();
			return false;
		}
		var Detail = JSON.stringify(DetailObj);
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCVendorEvaluationIndex',
			MethodName: 'SubmitEvaluation',
			List: Detail
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				MainGrid.reload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	$UI.clear(MainGrid);
	MainGrid.load({
		ClassName: 'web.DHCSTMHUI.DHCVendorEvaluationIndex',
		QueryName: 'GetIndexByPointer',
		query2JsonStrict: 1,
		Pointer: Pointer,
		Type: 'P'
	});
};