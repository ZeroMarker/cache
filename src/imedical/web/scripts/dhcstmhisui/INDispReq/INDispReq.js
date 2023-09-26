var init = function () {
	$HUI.radio("[name='ReqMode']", {
		onChecked: function (e, value) {
			var ReqMode = $("input[name='ReqMode']:checked").val();
			if (ReqMode == '0') {
				$('#UserGrp').combobox({
					disabled: false
				});
			} else {
				$('#UserGrp').combobox({
					disabled: true
				});
			}
		}
	});
	var LocParams = JSON.stringify(addSessionParams({
				Type: 'Login'
			}));
	var LocBox = $HUI.combobox('#LocId', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
			valueField: 'RowId',
			textField: 'Description'
		});
	//专业组
	var UserGrpParams = JSON.stringify(addSessionParams({
				User: gUserId,
				SubLoc: gLocId,
				ReqFlag: "1"
			}));
	var UserGrpBox = $HUI.combobox('#UserGrp', {
			url: $URL + '?ClassName=web.DHCSTMHUI.DHCSubLocUserGroup&QueryName=GetUserGrp&ResultSetType=array&Params=' + UserGrpParams,
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
			mode: 'remote',
			onBeforeLoad: function (param) {
				var Select = MainGrid.getRows()[MainGrid.editIndex];
				if (!isEmpty(Select)) {
					param.Inci = Select.InciId;
				}
			}
		}
	};
	var HandlerParams = function () {
		var Scg = $("#Scg").combotree('getValue');
		var LocId = $("#LocId").combo('getValue');
		var ReqLoc = $("#LocId").combo('getValue');
		var QtyFlag = '0';
		var ChargeFlag="";
		var AllowChargeMat=GetAppPropValue('DHCSTINDISPM').AllowChargeMat;
		if (AllowChargeMat!="Y"){ChargeFlag="N";}
		var Obj = {
			StkGrpRowId: Scg,
			StkGrpType: "M",
			Locdr: LocId,
			NotUseFlag: "N",
			QtyFlag: QtyFlag,
			ToLoc: ReqLoc,
			ReqModeLimited: "",
			NoLocReq: "N",
			ChargeFlag:ChargeFlag
		};
		return Obj
	}
	var SelectRow = function (row) {
		var Rows = MainGrid.getRows();
		var Row = Rows[MainGrid.editIndex];
		MainGrid.updateRow({
			index: MainGrid.editIndex,
			row: {
				InciId: row.InciDr,
				InciCode: row.InciCode,
				UomId: row.PUomDr,
				UomDesc: row.PUomDesc,
				Rp: row.PRp,
				Sp: row.PSp,
				InciDesc: row.InciDesc,
				Spec: row.Spec,
				ManfDesc: row.ManfName
			}
		});
		if (!isEmpty(Row.Qty)) {
			Row.SpAmt = accMul(Number(Row.Qty), Number(Row.Sp));
			Row.RpAmt = accMul(Number(Row.Qty), Number(Row.Rp));
		}
		setTimeout(function () {
			MainGrid.refreshRow();
			MainGrid.startEditingNext('InciDesc');
		}, 0);
	}

	var MainCm = [[{
				title: 'RowId',
				field: 'RowId',
				width: 50,
				saveCol: true,
				hidden: true
			}, {
				title: '物资RowId',
				field: 'InciId',
				width: 50,
				saveCol: true,
				hidden: true
			}, {
				title: '物资代码',
				field: 'InciCode',
				width: 100
			}, {
				title: '物资名称',
				field: 'InciDesc',
				editor: InciEditor(HandlerParams, SelectRow),
				width: 150
			}, {
				title: "规格",
				field: 'Spec',
				width: 100
			}, {
				title: "厂商",
				field: 'Manf',
				width: 150
			}, {
				title: "数量",
				field: 'Qty',
				width: 80,
				saveCol: true,
				editor: {
					type: 'numberbox',
					options: {
						min: 0,
						required: true
					}
				},
				align: 'right'
			}, {
				title: "单位",
				field: 'UomId',
				saveCol: true,
				formatter: CommonFormatter(UomCombox, 'UomId', 'UomDesc'),
				editor: UomCombox,
				width: 80
			}, {
				title: "售价",
				field: 'Sp',
				width: 80,
				align: 'right'
			}, {
				title: "售价金额",
				field: 'SpAmt',
				width: 100,
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
				title: '状态',
				field: 'Status',
				width: 90,
				formatter: function (value, row, index) {
					if (value == "G") {
						return "待处理";
					} else if (value == "D") {
						return "已处理";
					} else if (value == "X") {
						return "已作废";
					} else if (value == "R") {
						return "已拒绝";
					}
				}
			}
		]];

	var MainGrid = $UI.datagrid('#MainGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCINDispReqItm',
				QueryName: 'DHCINDispReqItm'
			},
			deleteRowParams: {
				ClassName: 'web.DHCSTMHUI.DHCINDispReqItm',
				MethodName: 'jsDelete'
			},
			columns: MainCm,
			remoteSort: false,
			showBar: true,
			showAddDelItems: true,
			onClickCell: function (index, field, value) {
				MainGrid.commonClickCell(index, field, value);
			},
			onBeforeCellEdit: function (index, field) {
				if ($HUI.checkbox('#CompFlag').getValue()) {
					$UI.msg("alert", "已经完成，不能修改!");
					return false;
				}
			},
			onEndEdit: function (index, row, changes) {
				var Editors = $(this).datagrid('getEditors', index);
				for (var i = 0; i < Editors.length; i++) {
					var Editor = Editors[i];
					if (Editor.field == 'Qty') {
						var Qty = row.Qty;
						if (!isEmpty(Qty)) {
							row.SpAmt = accMul(Number(row.Qty), Number(row.Sp));
							row.RpAmt = accMul(Number(row.Qty), Number(row.Rp));
						}
					}
				}
			},
			beforeDelFn: function () {
				if ($HUI.checkbox('#CompFlag').getValue()) {
					$UI.msg("alert", "已经完成，不能删除选中行!");
					return false;
				}
			},
			beforeAddFn: function () {
				if ($HUI.checkbox('#CompFlag').getValue()) {
					$UI.msg("alert", "已经完成，不能增加一行!");
					return false;
				}
				if (isEmpty($HUI.combobox("#LocId").getValue())) {
					$UI.msg("alert", "科室不能为空!");
					return false;
				};
			},
			onLoadSuccess: function (data) {
				var RowId = $('#RowId').val();
				if (isEmpty(RowId)) {
					for (var i = 0; i < data.rows.length; i++) {
						data.rows[i].RowId = '';
					}
				}
			}
		});

	$UI.linkbutton('#QueryBT', {
		onClick: function () {
			FindWin(Select);
		}
	});

	$UI.linkbutton('#ClearBT', {
		onClick: function () {
			$UI.clearBlock('#Conditions');
			$UI.clear(MainGrid);
			setEditEnable();
			SetDefaValues();
		}
	});

	$UI.linkbutton('#SaveBT', {
		onClick: function () {
			var MainObj = $UI.loopBlock('#Conditions');
			var IsChange = $UI.isChangeBlock('#Conditions');
			var SelectedRow = MainGrid.getSelected();
			if (isEmpty(SelectedRow) && IsChange == false) {
				$UI.msg('alert', "没有需要保存的内容!");
				return;
			}
			if (MainObj['CompFlag'] == 'Y') {
				$UI.msg('alert', '该单据已经完成,不可重复保存!');
				return;
			}
			if (isEmpty(MainObj['LocId'])) {
				$UI.msg('alert', '请选择科室!')
				return;
			}
			var ReqMode = $("input[name='ReqMode']:checked").val();
			if ((ReqMode == '0') && (isEmpty(MainObj['UserGrp']))) {
				$UI.msg('alert', '请选择专业组!')
				return;
			}
			var Main = JSON.stringify(MainObj);
			var Detail = MainGrid.getChangesData();
			if (Detail === false){	//未完成编辑或明细为空
				return;
			}
			if (isEmpty(Detail)){	//明细不变
				$UI.msg("alert", "没有需要保存的明细!");
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINDispReq',
				MethodName: 'jsSave',
				Main: Main,
				Detail: JSON.stringify(Detail)
			}, function (jsonData) {
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
		onClick: function () {
			var ParamsObj = $UI.loopBlock('#Conditions');
			var DsrqId = ParamsObj['RowId'];
			if (isEmpty(DsrqId)) {
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
		onClick: function () {
			var ParamsObj = $UI.loopBlock('#Conditions');
			var DsrqId = ParamsObj['RowId'];
			if (isEmpty(DsrqId)) {
				return;
			}
			var CompFlag = ParamsObj['CompFlag'];
			if (CompFlag == 'Y') {
				$UI.msg('alert', '该单据已完成,不可重复操作!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINDispReq',
				MethodName: 'SetComp',
				Dsrq: DsrqId
			}, function (jsonData) {
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
		onClick: function () {
			var ParamsObj = $UI.loopBlock('#Conditions');
			var DsrqId = ParamsObj['RowId'];
			if (isEmpty(DsrqId)) {
				return;
			}
			var CompFlag = ParamsObj['CompFlag'];
			if (CompFlag != 'Y') {
				$UI.msg('alert', '该单据不是完成状态,不可操作!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINDispReq',
				MethodName: 'CancelComp',
				Dsrq: DsrqId
			}, function (jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					Select(jsonData.rowid);
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#CancelBT', {
		onClick: function () {
			var ParamsObj = $UI.loopBlock('#Conditions');
			var DsrqId = ParamsObj['RowId'];
			if (isEmpty(DsrqId)) {
				return;
			}
			var CompFlag = ParamsObj['CompFlag'];
			if (CompFlag != 'Y') {
				$UI.msg('alert', '该单据未完成,无需作废!');
				return;
			}
			$UI.confirm('您将要作废单据,是否继续?', '', '', CancelReq);
		}
	});
	$UI.linkbutton('#PrintBT', {
		onClick: function () {
			PrintINDispReq($('#RowId').val());
		}
	});

	function CancelReq() {
		var ParamsObj = $UI.loopBlock('#Conditions');
		var DsrqId = ParamsObj['RowId'];
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINDispReq',
			MethodName: 'CancelReq',
			Dsrq: DsrqId
		}, function (jsonData) {
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				Select(jsonData.rowid);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}

	function Delete() {
		var ParamsObj = $UI.loopBlock('#Conditions');
		var DsrqId = ParamsObj['RowId'];
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINDispReq',
			MethodName: 'Delete',
			DsrqId: DsrqId
		}, function (jsonData) {
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

	function setEditDisable() {
		$HUI.combobox("#LocId").disable();
		$HUI.combobox("#Scg").disable();
		ChangeButtonEnable({
			'#DelBT': false,
			'#ComBT': false,
			'#SaveBT': false,
			'#CanComBT': true,
			'#CancelBT': true
		});
	}

	function setEditEnable() {
		$HUI.combobox("#LocId").enable();
		$HUI.combobox("#Scg").enable();
		ChangeButtonEnable({
			'#DelBT': true,
			'#ComBT': true,
			'#SaveBT': true,
			'#CanComBT': false,
			'#CancelBT': false
		});
	}

	function Select(Dsrq) {
		$UI.clearBlock('#Conditions');
		$UI.clear(MainGrid);
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINDispReq',
			MethodName: 'Select',
			Dsrq: Dsrq
		}, function (jsonData) {
			$UI.fillBlock('#Conditions', jsonData);
			if ($HUI.checkbox('#CompFlag').getValue()) {
				setEditDisable();
			} else {
				setEditEnable();
			}
		});
		MainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINDispReqItm',
			QueryName: 'DHCINDispReqItm',
			Parref: Dsrq
		});
	}

	SetDefaValues();
}
$(init);
