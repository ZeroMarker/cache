var EvalIndexCm, EvalIndexGrid, EvalReasonCm, EvalReasonGrid;
var init = function () {

	$('#AddBT').on('click', function () {
		EvalIndexGrid.commonAddRow();
	});
	$('#SaveBT').on('click', function () {
		$('#EvalIndexGrid').datagrid('acceptChanges');
		var Rows = EvalIndexGrid.getRows();
		var SumWeight = 0;
		for (var i = 0; i < Rows.length; i++) {
			var Weight = Rows[i].Weight;
			if (Weight == undefined ||Weight == "" || Weight <= 0 || Weight > 1) {
				$UI.msg('alert', '第' + (i + 1) + '行权重须大于0小于等于1!');
				return;
			}
			SumWeight = accAdd(SumWeight,Weight);
		}
		if (SumWeight != 1) {
			$UI.msg('alert', '权重之和必须等于1!')
			return;
		}
		var MainObj=JSON.stringify(addSessionParams());
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCVendorEvaluationIndex',
			MethodName: 'Save',
			Main: MainObj,
			Params: JSON.stringify(Rows)
		}, function (jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				EvalIndexGrid.reload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	});
	$('#AddBT_1').on('click', function () {
		EvalReasonGrid.commonAddRow();
	});
	$('#SaveBT_1').on('click', function () {
		var RowData = EvalIndexGrid.getSelected();
		if (RowData == null || RowData == "") {
			$UI.msg('alert', '请选择评价指标信息!');
			return;
		}
		var EvalIndex = RowData.RowId;
		if (EvalIndex == null || EvalIndex == "") {
			$UI.msg('alert', '请先保存评价指标信息!');
			return;
		}
		$('#EvalReasonGrid').datagrid('acceptChanges');
		var Rows = EvalReasonGrid.getRows();
		var SumWeight = 0;
		for (var i = 0; i < Rows.length; i++) {
			var Weight = Rows[i].Weight;
			if (Weight == "" || Weight <= 0 || Weight > 1) {
				$UI.msg('alert', '第' + (i + 1) + '行权重须大于0小于等于1!');
				return;
			}
			SumWeight = accAdd(SumWeight,Weight);
		}
		if (SumWeight != 1) {
			$UI.msg('alert', '权重之和必须等于1!')
			return;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCVendorEvaluationIndex',
			MethodName: 'SaveEvalReason',
			EvalIndex: EvalIndex,
			Params: JSON.stringify(Rows)
		}, function (jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				EvalReasonGrid.reload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	});

	EvalIndexCm = [[{
				title: "RowId",
				field: 'RowId',
				width: 50,
				saveCol: true,
				hidden: true
			}, {
				title: "代码",
				field: 'Code',
				width: 100,
				saveCol: true,
				editor: {
					type: 'validatebox',
					options: {
						required: true
					}
				}
			}, {
				title: "描述",
				field: 'Desc',
				saveCol: true,
				width: 150,
				editor: {
					type: 'validatebox',
					options: {
						required: true
					}
				}
			}, {
				title: "权重",
				field: 'Weight',
				saveCol: true,
				width: 100,
				align: 'right',
				editor: {
					type: 'numberbox',
					options: {
						required: true,
						precision: 4
					}
				}
			}, {
				title: "系统指标",
				field: 'SysIndex',
				saveCol: true,
				align: 'center',
				editor: {
					type: 'icheckbox',
					options: {
						on: 'Y',
						off: 'N'
					}
				},
				formatter :function(v){
					if(v=="Y"){return "是"}
					else{return "否"}
				},
				width: 80
			}, {
				title: "分数可修改",
				field: 'ScoreEdited',
				saveCol: true,
				align: 'center',
				editor: {
					type: 'icheckbox',
					options: {
						on: 'Y',
						off: 'N'
					}
				},
				formatter :function(v){
					if(v=="Y"){return "是"}
					else{return "否"}
				},
				width: 80
			}
		]];

	EvalIndexGrid = $UI.datagrid('#EvalIndexGrid', {
			lazy: false,
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCVendorEvaluationIndex',
				QueryName: 'EvalIndex'
			},
			toolbar: '#EvalIndexBT',
			fitColumns: true,
			columns: EvalIndexCm,
			onSelect: function (index, row) {
				$UI.clear(EvalReasonGrid);
				EvalReasonGrid.load({
					ClassName: 'web.DHCSTMHUI.DHCVendorEvaluationIndex',
					QueryName: 'EvalReason',
					Parref: row.RowId
				});
			},
			onLoadSuccess: function (data) {
				if (data.rows.length > 0) {
					EvalIndexGrid.selectRow(0);
				}
			},
			onClickCell: function (index, field, value) {
				EvalIndexGrid.commonClickCell(index, field);
			}
		});

	EvalReasonCm = [[{
				title: "RowId",
				field: 'RowId',
				width: 50,
				saveCol: true,
				hidden: true
			}, {
				title: "代码",
				field: 'Code',
				width: 100,
				saveCol: true,
				editor: {
					type: 'validatebox',
					options: {
						required: true
					}
				}
			}, {
				title: "描述",
				field: 'Desc',
				saveCol: true,
				width: 180,
				editor: {
					type: 'validatebox',
					options: {
						required: true
					}
				}
			}, {
				title: "权重",
				field: 'Weight',
				saveCol: true,
				width: 100,
				align: 'right',
				editor: {
					type: 'numberbox',
					options: {
						required: true,
						precision: 4
					}
				}
			}
		]];

	EvalReasonGrid = $UI.datagrid('#EvalReasonGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCVendorEvaluationIndex',
				QueryName: 'EvalReason'
			},
			toolbar: '#EvalReasonBT',
			fitColumns: true,
			columns: EvalReasonCm,
			onClickCell: function (index, field, value) {
				EvalReasonGrid.commonClickCell(index, field);
			}
		});
};
$(init);
