var init = function () {
	///设置可编辑组件的disabled属性
	function setEditDisable() {
		$HUI.combobox("#RetLoc").disable();
		$HUI.combobox("#ScgStk").disable();
		$HUI.combobox("#Vendor").disable();
	}
	///放开可编辑组件的disabled属性
	function setEditEnable() {
		$HUI.combobox("#RetLoc").enable();
		$HUI.combobox("#ScgStk").enable();
		$HUI.combobox("#Vendor").enable();
	}
	function SetDefaValues() {
		$('#RetLoc').combobox('setValue', gLocId);
		$('#ScgStk').combotree('options')['setDefaultFun']();
		RetGrid.setFooterInfo()
		ChangeButtonEnable({
			'#DelBT': false,
			'#PrintBT': false,
			'#ComBT': false,
			'#CanComBT': false,
			'#SaveBT': true
		});
	}
	var ClearMain = function () {
		$UI.clearBlock('#MainConditions');
		$UI.clear(RetGrid);
		SetDefaValues();
		setEditEnable();
	}
	var UomCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetInciUom&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			mode: 'remote',
			onBeforeLoad: function (param) {
				var rows = RetGrid.getRows();
				var row = rows[RetGrid.editIndex];
				if (!isEmpty(row)) {
					param.Inci = row.Inci;
				}

			},
			onSelect: function (record) {
				var rows = RetGrid.getRows();
				var row = rows[RetGrid.editIndex];
				row.UomDesc = record.Description;

			}
		}
	};
	/*var ReasonComData = $.cm({
		ClassName: 'web.DHCSTMHUI.Common.Dicts',
		QueryName: 'GetRetReason',
		ResultSetType: 'array'
	}, false);
	var ReasonCombox = {
		type: 'combobox',
		options: {
			data: ReasonComData,
			valueField: 'RowId',
			textField: 'Description'
		}
	}*/
	var ReasonParams = JSON.stringify(addSessionParams())
	var ReasonCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetRetReason&ResultSetType=array&Params=' + ReasonParams,
			valueField: 'RowId',
			textField: 'Description'
		}
	}
	var SpecDescParams = JSON.stringify(sessionObj)
	var SpecDescbox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetSpecDesc&ResultSetType=array&Params=' + SpecDescParams,
			valueField: 'Description',
			textField: 'Description',
			mode: 'remote',
			onBeforeLoad: function (param) {
				var rows = RetGrid.getRows();
				var row = rows[RetGrid.editIndex];
				if (!isEmpty(row)) {
					param.Inci = row.Inclb;
				}

			}
		}
	};
	var RetLocParams = JSON.stringify(addSessionParams({
		Type: 'Login'
	}));
	var RetLocBox = $HUI.combobox('#RetLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + RetLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var VendorParams = JSON.stringify(addSessionParams({
		APCType: "M",
		RcFlag: "Y"
	}));
	var VendorBox = $HUI.combobox('#Vendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var UserBox = $HUI.combobox('#User', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetUser&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	$UI.linkbutton('#QueryBT', {
		onClick: function () {
			FindWin(Select)
		}
	});
	var Save = function () {
		var MainObj = $UI.loopBlock('#MainConditions')
		var Main = JSON.stringify(MainObj)
		var DetailObj = RetGrid.getChangesData('Ingri');
		//判断
		var ifChangeMain=$UI.isChangeBlock('#MainConditions');
		if (DetailObj === false){	//未完成编辑或明细为空
			return;
		}
		if (!ifChangeMain && (isEmpty(DetailObj))){	//主单和明细不变
			$UI.msg("alert", "没有需要保存的信息!");
			return;
		}
		var Detail = JSON.stringify(DetailObj)
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRet',
			MethodName: 'Save',
			Main: Main,
			Detail: Detail
		}, function (jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				Select(jsonData.rowid);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	};
	$UI.linkbutton('#DelBT', {
		onClick: function () {
			var RetId = $('#RowId').val()
			if (isEmpty(RetId)) {
				return;
			}
			function del() {
				$.cm({
					ClassName: 'web.DHCSTMHUI.DHCINGdRet',
					MethodName: 'Delete',
					RetId: RetId,
					Params: JSON.stringify(sessionObj)
				}, function (jsonData) {
					if (jsonData.success == 0) {
						$UI.msg('success', jsonData.msg);
						ClearMain();
					} else {
						$UI.msg('error', jsonData.msg);
					}
				});
			}
			$UI.confirm('确定要删除吗?', '', '', del)
		}
	});
	$UI.linkbutton('#ComBT', {
		onClick: function () {
			var MainObj = $UI.loopBlock('#MainConditions')
			var RetId = MainObj.RowId;
			if (isEmpty(RetId)) {
				return;
			}
			var Main = JSON.stringify(MainObj)
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINGdRet',
				MethodName: 'SetCompleted',
				Params: Main
			}, function (jsonData) {
				if (jsonData.success == 0) {
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
			var RetId = $('#RowId').val();
			if (isEmpty(RetId)) {
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINGdRet',
				MethodName: 'CancelCompleted',
				RetId: RetId
			}, function (jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					Select(jsonData.rowid);
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#ClearBT', {
		onClick: function () {
			ClearMain();
			setEditEnable();
		}
	});
	$UI.linkbutton('#PrintBT', {
		onClick: function () {
			if (isEmpty($('#RowId').val())) {
				$UI.msg("alert", "请选择需要打印的退货单!");
				return;
			}
			PrintIngDret($('#RowId').val());
		}
	});
	var Select = function (RetId) {
		$UI.clearBlock('#MainConditions');
		$UI.clear(RetGrid);
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRet',
			MethodName: 'Select',
			RetId: RetId
		},function (jsonData) {
				$UI.fillBlock('#MainConditions', jsonData);
				setEditDisable();
				//按钮控制
				if ($HUI.checkbox("#Completed").getValue()) {
					ChangeButtonEnable({
						'#DelBT': false,
						'#PrintBT': true,
						'#ComBT': false,
						'#CanComBT': true,
						'#SaveBT': false
					});
				} else {
					ChangeButtonEnable({
						'#DelBT': true,
						'#PrintBT': true,
						'#ComBT': true,
						'#CanComBT': false,
						'#SaveBT': true
					});
				}
			});
		RetGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINGrtItm',
			QueryName: 'DHCINGdRetItm',
			RetId: RetId,
			rows:99999,
			totalFooter:'"Code":"合计"',
			totalFields:'RpAmt,SpAmt'
		});

	}
	$UI.linkbutton('#SaveBT', {
		onClick: function () {
			Save();
		}
	});

	var RetCm = [[{
		field: 'ck',
		checkbox: true
	}, {
		title: 'RowId',
		field: 'RowId',
		width: 100,
		hidden: true
	}, {
		title: 'Ingri',
		field: 'Ingri',
		width: 100,
		hidden: true
	}, {
		title: 'Inci',
		field: 'Inci',
		width: 100,
		hidden: true
	}, {
		title: 'Inclb',
		field: 'Inclb',
		width: 100,
		hidden: true
	}, {
		title: '物资代码',
		field: 'Code',
		width: 100
	}, {
		title: '物资名称',
		field: 'Description',
		editor: {
			type: 'validatebox',
			options: {
				required: true
			}
		},
		width: 150,
		jump:false
	}, {
		title: "规格",
		field: 'Spec',
		width: 100
	}, {
		title: "厂商",
		field: 'Manf',
		width: 150
	}, {
		title: "批号",
		field: 'BatNo',
		width: 100
	}, {
		title: "效期",
		field: 'ExpDate',
		width: 120
	}, {
		title: "批次存数",
		field: 'StkQty',
		width: 100,
		align: 'right'
	}, {
		title: "退货数量",
		field: 'Qty',
		width: 100,
		align: 'right',
		editor: {
			type: 'numberbox',
			options: {
				required: true
			}
		}
	}, {
		title: "单位",
		field: 'Uom',
		width: 100,
		formatter: CommonFormatter(UomCombox, 'Uom', 'UomDesc'),
		editor: UomCombox
	}, {
		title: "退货原因",
		field: 'ReasonId',
		width: 100,
		formatter: CommonFormatter(ReasonCombox, 'ReasonId', 'Reason'),
		editor: ReasonCombox
	}, {
		title: "退货进价",
		field: 'Rp',
		width: 100,
		align: 'right'
	}, {
		title: "进价金额",
		field: 'RpAmt',
		width: 100,
		align: 'right'
	}, {
		title: "发票号",
		field: 'InvNo',
		width: 100,
		align: 'left',
		editor: {
			type: 'text'
		}
	}, {
		title: "发票日期",
		field: 'InvDate',
		width: 100,
		align: 'right',
		editor: {
			type: 'datebox'
		}

	}, {
		title: "发票金额",
		field: 'InvAmt',
		width: 100,
		align: 'right',
		editor: {
			type: 'numberbox'
		}
	}, {
		title: "零售单价",
		field: 'Sp',
		width: 100,
		align: 'right'
	}, {
		title: "售价金额",
		field: 'SpAmt',
		width: 100,
		align: 'right'
	}, {
		title: "备注",
		field: 'Remark',
		width: 200,
		align: 'left',
		editor: {
			type: 'text'
		}
	}, {
		title: "具体规格",
		field: 'SpecDesc',
		width: 100,
		align: 'left',
		sortable: true
	}, {
		title: "高值标志",
		field: 'HvFlag',
		width: 80,
		align: 'center',
		hidden: true,
		formatter: function (v) {
			if (v == "Y") {
				return "是"
			} else {
				return "否"
			}
		}
	}, {
		title: "随行单号",
		field: 'SxNo',
		width: 200,
		align: 'left',
		editor: {
			type: 'text'
		}
	}
	]];

	var RetGrid = $UI.datagrid('#RetGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGrtItm',
			QueryName: 'DHCINGdRetItm',
			rows:99999,
			totalFooter:'"Code":"合计"',
			totalFields:'RpAmt,SpAmt'
		},
		deleteRowParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGrtItm',
			MethodName: 'Delete'
		},
		columns: RetCm,
		singleSelect: false,
		showBar: true,
		showAddDelItems: true,
		pagination: false,
		onClickCell: function (index, filed, value) {
			if ($HUI.checkbox("#Completed").getValue()) {
				return false;
			}
			RetGrid.commonClickCell(index, filed, value);
		},
		onEndEdit: function (index, row, changes) {
				if (changes.hasOwnProperty('Qty')) {
					var RepLev = row.RepLev;
					var Qty = Number(row.Qty);
					var StkQty = Number(row.StkQty);

					if (Qty > StkQty) {
						$UI.msg("alert", "退货数量不能大于库存数量!");
						RetGrid.checked = false;
						return false;
					} else {
						row.RpAmt = accMul(Qty, row.Rp);
						row.SpAmt = accMul(Qty, row.Sp);
						row.InvAmt = accMul(Qty, row.Rp);
					}
				}
		 	RetGrid.setFooterInfo();	
		},
		onBeforeEdit: function (index, row) {
			if ($HUI.checkbox("#Completed").getValue()) {
				$UI.msg("alert", "已经完成，不能编辑!");
				return false;
			}
		},
		beforeDelFn: function () {
			if ($HUI.checkbox("#Completed").getValue()) {
				$UI.msg("alert", "已经完成，不能删除选中行!");
				return false;
			}
		},
		beforeAddFn: function () {
			if ($HUI.checkbox("#Completed").getValue()) {
				$UI.msg("alert", "已经完成，不能增加一行!");
				return false;
			}
			if (isEmpty($HUI.combobox("#RetLoc").getValue())) {
				$UI.msg("alert", "退货科室不能为空!");
				return false;
			};
			if (isEmpty($HUI.combobox("#Vendor").getValue())) {
				$UI.msg("alert", "供应商不能为空!");
				return false;
			};
			$HUI.combobox("#RetLoc").disable();
			$HUI.combobox("#ScgStk").disable();
			$HUI.combobox("#Vendor").disable();

		},
		onBeginEdit: function (index, row) {
			$('#RetGrid').datagrid('beginEdit', index);
			var ed = $('#RetGrid').datagrid('getEditors', index);
			for (var i = 0; i < ed.length; i++) {
				var e = ed[i];
				if (e.field == "Description") {
					$(e.target).bind("keydown", function (event) {
						if (event.keyCode == 13) {
							var Input = $(this).val();
							var Scg = $("#ScgStk").combotree('getValue');
							var LocDr = $("#RetLoc").combo('getValue');
							var HV = gHVInRet ? 'Y' : 'N';
							var Vendor = $("#Vendor").combo('getValue');
							var ParamsObj = {
								StkGrpRowId: Scg,
								StkGrpType: "M",
								Locdr: LocDr,
								NotUseFlag: "N",
								QtyFlag: "1",
								ZeroFlag: "Y",
								HV: HV,
								InclbVendor: Vendor
							};
							VendorIncItmBatWindow(Input, ParamsObj, ReturnInfoFn);
						}
					});
				}
			}
		}
	});
	function ReturnInfoFn(rows) {
		rows = [].concat(rows);
		if (rows == null || rows == "") {
			return;
		}
		$.each(rows, function (index, row) {
			var RowIndex = RetGrid.editIndex;
			RetGrid.updateRow({
				index: RetGrid.editIndex,
				row: {
					Inci: row.InciDr,
					Code: row.InciCode,
					Description: row.InciDesc,
					Spec: row.Spec,
					BUom: row.BUom,
					Inclb: row.Inclb,
					Ingri: row.Ingri,
					Rp: row.Rp,
					Sp: row.Sp,
					BatNo: row.BatNo,
					ExpDate: row.ExpDate,
					Uom: row.Uom,
					UomDesc: row.UomDesc,
					Manf: row.ManfName,
					StkQty: row.StkQty,
					ConFac: row.ConFac,
					SpecDesc: row.SpecDesc
				}
			});
			setTimeout(function () {
				RetGrid.refreshRow();
				var ed = $('#RetGrid').datagrid('getEditor', {index: RowIndex, field: 'Qty'});
				$(ed.target).focus();
			}, 0);
		});
	}
	SetDefaValues();
	if (!isEmpty(gIngrtId)) {
		Select(gIngrtId);
	}
}
$(init);
