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
					var InciId = Select.InciId;
					param.Inci = InciId;
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
			width: 150
		}, {
			title: '高值条码',
			field: 'HVBarCode',
			saveCol: true,
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
		showAddDelItems: true,
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
				if (e.field == 'HVBarCode') {
					$(e.target).bind('keydown', function(event) {
						if (event.keyCode == 13) {
							var BarCode = $(this).val();
							if (isEmpty(BarCode)) {
								MainGrid.stopJump();
								return false;
							}
							var FindIndex = MainGrid.find('HVBarCode', BarCode);
							if (FindIndex >= 0 && FindIndex != index) {
								$UI.msg('alert', '条码不可重复录入!');
								$(this).val('');
								$(this).focus();
								MainGrid.stopJump();
								return false;
							}
							var BarCodeData = $.cm({
								ClassName: 'web.DHCSTMHUI.DHCItmTrack',
								MethodName: 'GetItmByBarcode',
								BarCode: BarCode
							}, false);
							if (!isEmpty(BarCodeData.success) && BarCodeData.success != 0) {
								$UI.msg('alert', BarCodeData.msg);
								$(this).val('');
								$(this).focus();
								MainGrid.stopJump();
								return false;
							}
							var ScgStk = BarCodeData['ScgStk'];
							var ScgStkDesc = BarCodeData['ScgStkDesc'];
							var Inclb = BarCodeData['Inclb'];
							var IsAudit = BarCodeData['IsAudit'];
							var OperNo = BarCodeData['OperNo'];
							var Type = BarCodeData['Type'];
							var Status = BarCodeData['Status'];
							var RecallFlag = BarCodeData['RecallFlag'];
							var Inci = BarCodeData['Inci'];
							var dhcit = BarCodeData['dhcit'];
							var OriginalStatus = BarCodeData['OriginalStatus'];
							var INDispItmId = BarCodeData['INDispItmId'];
							var Scg = $('#Scg').combobox('getValue');
							var CheckMsg = '';
							if (!CheckScgRelation(Scg, ScgStk)) {
								CheckMsg = '条码' + BarCode + '属于' + ScgStkDesc + '类组,与当前不符!';
							} else if (Inclb == '') {
								CheckMsg = '该高值材料没有相应库存记录,不能制单!';
							} else if (IsAudit != 'Y' && OriginalStatus != 'NotUnique') {
								CheckMsg = '该高值材料有未审核的' + OperNo + ',请核实!';
							} else if (Type == 'T' && OriginalStatus != 'NotUnique') {
								CheckMsg = '该高值材料已经出库,不可制单!';
							} else if (Status != 'InDisp') {
								CheckMsg = '该高值条码不是发放状态,无需退回!';
							} else if (RecallFlag == 'Y') {
								CheckMsg = '该高值条码处于锁定状态,不可制单!';
							}
							if (CheckMsg != '') {
								$UI.msg('alert', CheckMsg);
								$(this).val('');
								$(this).focus();
								MainGrid.stopJump();
								return false;
							}

							var LocId = $('#LocId').combobox('getValue');
							var RetData = $.cm({
								ClassName: 'web.DHCSTMHUI.DHCINDispRetItm',
								MethodName: 'GetDataForRet',
								Indsi: INDispItmId,
								Loc: LocId
							}, false);
							var Indsi = RetData.Indsi;
							if (isEmpty(Indsi)) {
								$UI.msg('alert', BarCode + '没有相应库存记录,不能制单!');
								$(this).val('');
								$(this).focus();
								MainGrid.stopJump();
								return false;
							}
							$(this).val(BarCode).validatebox('validate');
							var RetInfo = $.extend(RetData, { InciDr: Inci, dhcit: dhcit, HVBarCode: BarCode, OriginalStatus: OriginalStatus });
							ReturnInfoFunc(index, RetInfo);
						}
					});
				}
			}
		}
	});

	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			var HVFlag = 'Y';
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
				$UI.msg('alert', '退回单不存在!');
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
			SelDisp(Select, 'Y');
		}
	});
	function ReturnInfoFunc(RowIndex, row) {
		MainGrid.updateRow({
			index: RowIndex,
			row: {
				HVBarCode: row.HVBarCode,
				InciId: row.InciDr,
				InciCode: row.InciCode,
				InciDesc: row.InciDesc,
				Spec: row.Spec,
				Inclb: row.Inclb,
				BatchNo: row.BatchNo,
				ExpDate: row.ExpDate,
				DispQty: row.DispQty,
				DisRetQty: row.DsiRetQty,
				Qty: 1,
				UomId: row.DispUom,
				UomDesc: row.DispUomDesc,
				Rp: row.Rp,
				Sp: row.Sp,
				RpAmt: row.Rp,
				SpAmt: row.Sp,
				Manf: row.Manf,
				Indsi: row.Indsi
			}
		});
		setTimeout(function() {
			MainGrid.refreshRow();
			MainGrid.commonAddRow();
		}, 50);
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