var init = function() {
	var LocParams = JSON.stringify(addSessionParams({
		Type: 'Login',
		Element: 'LocId',
		LoginLocType: 2
	}));
	var LocBox = $HUI.combobox('#LocId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
		valueField: 'RowId',
		textField: 'Description'
	});

	var UomCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetInciUom&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			tipPosition: 'bottom',
			mode: 'remote',
			editable: false,
			onBeforeLoad: function(param) {
				var Select = MainGrid.getRows()[MainGrid.editIndex];
				if (!isEmpty(Select)) {
					var Inci = Select.Inclb.split('||')[0];
					param.Inci = Inci;
				}
			}
		}
	};

	var MainCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			saveCol: true,
			hidden: true
		}, {
			title: 'Inclb',
			field: 'Inclb',
			width: 50,
			saveCol: true,
			hidden: true
		}, {
			title: '物资RowId',
			field: 'InciId',
			width: 50,
			hidden: true
		}, {
			title: '物资代码',
			field: 'InciCode',
			width: 100
		}, {
			title: '物资名称',
			field: 'InciDesc',
			jump: false,
			editor: {
				type: 'validatebox',
				options: {
					required: true,
					tipPosition: 'bottom'
				}
			},
			width: 150
		}, {
			title: '规格',
			field: 'Spec',
			width: 100
		}, {
			title: '批号',
			field: 'BatchNo',
			width: 100
		}, {
			title: '效期',
			field: 'ExpDate',
			width: 100
		}, {
			title: '生产厂家',
			field: 'Manf',
			width: 150
		}, {
			title: '可退数量',
			field: 'DispQty',
			width: 80,
			align: 'right'
		}, {
			title: '已退占用',
			field: 'DisRetQty',
			width: 80,
			align: 'right',
			hidden: true
		}, {
			title: '退回数量',
			field: 'Qty',
			width: 80,
			saveCol: true,
			editor: {
				type: 'numberbox',
				options: {
					min: 0,
					tipPosition: 'bottom',
					required: true,
					precision: GetFmtNum('FmtQTY')
				}
			},
			align: 'right'
		}, {
			title: '本次占用',
			field: 'RetDirtyQty',
			width: 80,
			align: 'right',
			hidden: true
		}, {
			title: '单位',
			field: 'UomId',
			saveCol: true,
			formatter: CommonFormatter(UomCombox, 'UomId', 'UomDesc'),
			editor: UomCombox,
			width: 80
		}, {
			title: '进价',
			field: 'Rp',
			width: 80,
			saveCol: true,
			align: 'right'
		}, {
			title: '进价金额',
			field: 'RpAmt',
			width: 100,
			saveCol: true,
			align: 'right'
		}, {
			title: '售价',
			field: 'Sp',
			width: 80,
			saveCol: true,
			align: 'right'
		}, {
			title: '售价金额',
			field: 'SpAmt',
			width: 100,
			saveCol: true,
			align: 'right'
		}, {
			title: '备注',
			field: 'Remark',
			editor: {
				type: 'validatebox'
			},
			saveCol: true,
			width: 150
		}, {
			title: '发放明细Id',
			field: 'Indsi',
			width: 50,
			saveCol: true,
			hidden: true
		}
	]];

	var MainGrid = $UI.datagrid('#MainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINDispRetItm',
			QueryName: 'DHCINDispRetItm',
			query2JsonStrict: 1
		},
		deleteRowParams: {
			ClassName: 'web.DHCSTMHUI.DHCINDispRetItm',
			MethodName: 'jsDelete'
		},
		columns: MainCm,
		remoteSort: false,
		showBar: true,
		// showAddDelItems: true,
		onClickRow: function(index, row) {
			MainGrid.commonClickRow(index, row);
		},
		onBeforeEdit: function(index, row) {
			if ($HUI.checkbox('#CompFlag').getValue()) {
				$UI.msg('alert', '已经完成，不能修改!');
				return false;
			}
		},
		onBeginEdit: function(index, row) {
			$('#MainGrid').datagrid('beginEdit', index);
			var ed = $('#MainGrid').datagrid('getEditors', index);
			for (var i = 0; i < ed.length; i++) {
				var e = ed[i];
				if (e.field == 'InciDesc') {
					$(e.target).bind('keydown', function(event) {
						if (event.keyCode == 13) {
							var Input = $(this).val();
							if (isEmpty(Input)) {
								return;
							}
							var DispScg = $('#Scg').combotree('getValue');
							var DispToLoc = $('#LocId').combobox('getValue');
							var HV = 'N';
							var ChargeFlag = '';
							var AllowChargeMat = GetAppPropValue('DHCSTINDISPM').AllowChargeMat;
							if (AllowChargeMat != 'Y') { ChargeFlag = 'N'; }
							var ParamsObj = {
								StkGrpRowId: DispScg,
								StkGrpType: 'M',
								Locdr: gLocId,
								NotUseFlag: 'N',
								QtyFlag: '0',
								ToLoc: DispToLoc,
								ChargeFlag: ChargeFlag
							};
							INDispItmBatWindow(Input, ParamsObj, ReturnInfoFunc);
						}
					});
				} else if (e.field == 'Qty') {
					$(e.target).bind('keyup', function(event) {
						if (event.keyCode == 13) {
							MainGrid.commonAddRow();
						}
					});
				}
			}
		},
		onAfterEdit: function(index, row, changes) {
			if (changes.hasOwnProperty('Oty')) {
				var Qty = Number(changes['Qty']);
				var DispQty = Number(row['DispQty']) - Qty;
				var RetDirtyQty = Number(row['RetDirtyQty']) + Qty;
				if (accSub(Qty, RetDirtyQty) > DispQty) {
					$UI.msg('alert', '数量不可大于可用库存!');
					$(this).datagrid('updateRow', {
						index: index,
						row: {
							Qty: '',
							RpAmt: 0,
							SpAmt: 0
						}
					});
					MainGrid.checked = false;
					return;
				}
				var Rp = Number(row['Rp']), Sp = Number(row['Sp']);
				$(this).datagrid('updateRow', {
					index: index,
					row: {
						RpAmt: accMul(Qty, Rp),
						SpAmt: accMul(Qty, Sp)
					}
				});
			}
			MainGrid.setFooterInfo();
		}
	});

	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			var HVFlag = 'N';
			FindWin(Select, HVFlag);
		}
	});

	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});

	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			var MainObj = $UI.loopBlock('#Conditions');
			var IsChange = $UI.isChangeBlock('#Conditions');
			var SelectedRow = MainGrid.getSelected();
			if (isEmpty(SelectedRow) && IsChange == false) {
				$UI.msg('alert', '没有需要保存的内容!');
				return;
			}
			if (MainObj['CompFlag'] == 'Y') {
				$UI.msg('alert', '该单据已经完成,不可重复保存!');
				return;
			}
			if (isEmpty(MainObj['LocId'])) {
				$UI.msg('alert', '请选择退回科室!');
				return;
			}
			var Main = JSON.stringify(MainObj);
			var Detail = MainGrid.getChangesData('Inclb');
			if (Detail === false) {	// 未完成编辑或明细为空
				return;
			}
			if (isEmpty(Detail)) {	// 明细不变
				$UI.msg('alert', '没有需要保存的明细!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINDispRet',
				MethodName: 'jsSave',
				Main: Main,
				Detail: JSON.stringify(Detail)
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					Select(jsonData.rowid);
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});

	$UI.linkbutton('#DelBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#Conditions');
			var DsrId = ParamsObj['RowId'];
			if (isEmpty(DsrId)) {
				return;
			}
			var CompFlag = ParamsObj['CompFlag'];
			if (CompFlag == 'Y') {
				$UI.msg('alert', '该单据已经完成,不可删除!');
				return;
			}
			$UI.confirm('您将要删除单据,是否继续?', '', '', Delete);
		}
	});

	$UI.linkbutton('#ComBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#Conditions');
			var DsrId = ParamsObj['RowId'];
			if (isEmpty(DsrId)) {
				return;
			}
			var CompFlag = ParamsObj['CompFlag'];
			if (CompFlag == 'Y') {
				$UI.msg('alert', '该单据已完成,不可重复操作!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINDispRet',
				MethodName: 'jsSetComp',
				Dsr: DsrId,
				Params: JSON.stringify(ParamsObj)
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					Select(jsonData.rowid);
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});

	$UI.linkbutton('#CanComBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#Conditions');
			var DsrId = ParamsObj['RowId'];
			if (isEmpty(DsrId)) {
				return;
			}
			var CompFlag = ParamsObj['CompFlag'];
			if (CompFlag != 'Y') {
				$UI.msg('alert', '该单据不是完成状态,不可操作!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINDispRet',
				MethodName: 'CancelComp',
				Dsr: DsrId
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					Select(jsonData.rowid);
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});

	$UI.linkbutton('#PrintBT', {
		onClick: function() {
			PrintINDispRet($('#RowId').val());
		}
	});
	$UI.linkbutton('#SelDispBT', {
		onClick: function() {
			SelDisp(Select, 'N');
		}
	});
	function ReturnInfoFunc(rows) {
		rows = [].concat(rows);
		$.each(rows, function(index, row) {
			var RowIndex = MainGrid.editIndex;
			var ed = $('#MainGrid').datagrid('getEditor', {
				index: RowIndex,
				field: 'UomId'
			});
			AddComboData(ed.target, row.Uom, row.UomDesc);
			MainGrid.updateRow({
				index: RowIndex,
				row: {
					InciId: row.InciDr,
					InciCode: row.InciCode,
					InciDesc: row.InciDesc,
					Spec: row.Spec,
					Inclb: row.Inclb,
					BatchNo: row.BatchNo,
					ExpDate: row.ExpDate,
					DispQty: row.Qty,
					Qty: row.RetQty,
					UomId: row.Uom,
					UomDesc: row.UomDesc,
					Rp: row.BRp,
					Sp: row.BSp,
					RpAmt: accMul(row.RetQty, row.BRp),
					SpAmt: accMul(row.RetQty, row.BSp),
					Manf: row.Manf,
					Indsi: row.RowId
				}
			});
			$('#MainGrid').datagrid('refreshRow', RowIndex);
			if (index < rows.length) {
				MainGrid.commonAddRow();
			}
		});
	}

	function setEditDisable() {
		$HUI.combobox('#LocId').disable();
		$HUI.combobox('#Scg').disable();
		ChangeButtonEnable({
			'#DelBT': false,
			'#ComBT': false,
			'#CanComBT': true
		});
	}

	function setEditEnable() {
		$HUI.combobox('#LocId').enable();
		$HUI.combobox('#Scg').enable();
		ChangeButtonEnable({
			'#DelBT': true,
			'#ComBT': true,
			'#CanComBT': false
		});
	}

	function Select(Dsr) {
		$UI.clearBlock('#Conditions');
		$UI.clear(MainGrid);
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINDispRet',
			MethodName: 'Select',
			Dsr: Dsr
		}, function(jsonData) {
			$UI.fillBlock('#Conditions', jsonData);
			if ($HUI.checkbox('#CompFlag').getValue()) {
				setEditDisable();
			} else {
				setEditEnable();
			}
		});
		MainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINDispRetItm',
			QueryName: 'DHCINDispRetItm',
			query2JsonStrict: 1,
			Parref: Dsr
		});
	}

	function Delete() {
		var ParamsObj = $UI.loopBlock('#Conditions');
		var DsrId = ParamsObj['RowId'];
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINDispRet',
			MethodName: 'Delete',
			Dsr: DsrId
		}, function(jsonData) {
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				$UI.clearBlock('#Conditions');
				$UI.clear(MainGrid);
				SetDefaValues();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	function Clear() {
		$UI.clearBlock('#Conditions');
		$UI.clear(MainGrid);
		SetDefaValues();
		setEditEnable();
	}
	SetDefaValues();
};
$(init);