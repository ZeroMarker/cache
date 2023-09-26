var init = function () {
	$HUI.radio("[name='ReqMode']", {
		onChecked: function (e, value) {
			var ReqMode = $("input[name='ReqMode']:checked").val();
			if (ReqMode == '0') {
				$('#UserList').combobox({
					disabled: true
				});
				$('#GrpList').combobox({
					disabled: false
				});
			} else {
				$('#UserList').combobox({
					disabled: false
				});
				$('#GrpList').combobox({
					disabled: true
				});
			}
		}
	});
	//发放科室
	var DispLocParams = JSON.stringify(addSessionParams({
		Type: 'Login'
	}));
	var DispLocBox = $HUI.combobox('#LocId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + DispLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	//接收科室
	var ReqLocParams = JSON.stringify(addSessionParams({
		Type: 'All'
	}));
	var ReqLocBox = $HUI.combobox('#ReqLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + ReqLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function (record) {
			var LocId = record['RowId'];
			$('#UserList').combobox('clear');
			$('#GrpList').combobox('clear');
			$('#UserList').combobox('reload', $URL
				+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetDeptUser&ResultSetType=Array&Params='
				+ JSON.stringify({
					LocDr: LocId
				}));
			$('#GrpList').combobox('reload', $URL
				+ '?ClassName=web.DHCSTMHUI.DHCSubLocUserGroup&QueryName=GetLocGrp&ResultSetType=Array&Params='
				+ JSON.stringify({
					SubLoc: LocId
				}));
		}
	});
	//专业组
	var GrpListBox = $HUI.combobox('#GrpList', {
		url: '',
		valueField: 'RowId',
		textField: 'Description'
	});
	//科室人员
	var UserListBox = $HUI.combobox('#UserList', {
		url: '',
		valueField: 'RowId',
		textField: 'Description'
	});
	//单位
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

	var MainCm = [[{
		title: 'RowId',
		field: 'RowId',
		width: 50,
		saveCol: true,
		hidden: true
	}, {
		title: '物资批次Id',
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
		title: '代码',
		field: 'InciCode',
		width: 100
	}, {
		title: '描述',
		field: 'InciDesc',
		jump:false,
		editor: {
			type: 'validatebox',
			options: {
				required: true
			}
		},
		width: 150
	}, {
		title: "规格",
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
		title: "批次库存",
		field: 'InclbQty',
		width: 80,
		align: 'right'
	}, {
		title: "可用库存",
		field: 'AvaQty',
		width: 100,
		align: 'right'
	}, {
		title: "批次占用库存",
		field: 'DirtyQty',
		width: 50,
		align: 'right',
		hidden: true
	}, {
		title: "进价",
		field: 'Rp',
		saveCol: true,
		width: 80,
		align: 'right'
	}, {
		title: "进价金额",
		field: 'RpAmt',
		width: 100,
		align: 'right'
	}, {
		title: "售价",
		field: 'Sp',
		saveCol: true,
		width: 80,
		align: 'right'
	}, {
		title: "售价金额",
		field: 'SpAmt',
		width: 100,
		align: 'right'
	}, {
		title: '物品备注',
		field: 'Remark',
		editor: {
			type: 'validatebox'
		},
		saveCol: true,
		width: 150
	}
	]];

	var MainGrid = $UI.datagrid('#MainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINDispItm',
			QueryName: 'DHCINDispItm'
		},
		deleteRowParams: {
			ClassName: 'web.DHCSTMHUI.DHCINDispItm',
			MethodName: 'jsDelete'
		},
		columns: MainCm,
		showBar: true,
		showAddDelItems: true,
		pagination: false,
		onClickCell: function (index, field, value) {
			MainGrid.commonClickCell(index, field);
		},
		onBeforeCellEdit: function (index, field) {
			if ($HUI.checkbox('#CompFlag').getValue()) {
				$UI.msg("alert", "已经完成，不能修改!");
				return false;
			}
		},
		onBeginEdit: function (index, row) {
			$('#MainGrid').datagrid('beginEdit', index);
			var ed = $('#MainGrid').datagrid('getEditors', index);
			for (var i = 0; i < ed.length; i++) {
				var e = ed[i];
				if (e.field == 'InciDesc') {
					$(e.target).bind('keydown', function (event) {
						if (event.keyCode == 13) {
							var Input = $(this).val();
							var Scg = $('#Scg').combotree('getValue');
							var LocId = $('#LocId').combobox('getValue');
							var ReqLoc = $('#ReqLoc').combobox('getValue');
							var HV = 'N';
							var ChargeFlag="";
							var AllowChargeMat=GetAppPropValue('DHCSTINDISPM').AllowChargeMat;
							if (AllowChargeMat!="Y"){ChargeFlag="N";}
							var ParamsObj = {
								StkGrpRowId: Scg,
								StkGrpType: 'M',
								Locdr: LocId,
								NotUseFlag: 'N',
								QtyFlag: '1',
								ToLoc: ReqLoc,
								NoLocReq: 'N',
								HV: HV,
								QtyFlagBat: '1',
								ChargeFlag:ChargeFlag
							};
							IncItmBatWindow(Input, ParamsObj, ReturnInfoFunc);
						}
					});
				} else if (e.field == 'Qty') {
					$(e.target).bind('keyup', function (event) {
						if (event.keyCode == 13) {
							MainGrid.commonAddRow();
						}
					});
				}
			}
		},
		onAfterEdit: function (index, row, changes) {
			if (changes.hasOwnProperty('Qty')) {
				var Qty = Number(changes['Qty']);
				if (Qty<0) {
					$UI.msg('alert', '数量不可小于0!');
					$(this).datagrid('updateRow', {
						index: index,
						row: {
							Qty: '',
							RpAmt: 0,
							SpAmt: 0
						}
					});
					return false;
				}
				var AvaQty = Number(row['AvaQty']);
				var DirtyQty = Number(row['DirtyQty']);
				if (accSub(Qty, DirtyQty) > AvaQty) {
					$UI.msg('alert', '数量不可大于可用库存!');
					$(this).datagrid('updateRow', {
						index: index,
						row: {
							Qty: '',
							RpAmt: 0,
							SpAmt: 0
						}
					});
					return;
				}
				var Rp = Number(row['Rp']);
				var Sp = Number(row['Sp']);
				$(this).datagrid('updateRow', {
					index: index,
					row: {
						RpAmt: accMul(Qty, Rp),
						SpAmt: accMul(Qty, Sp)
					}
				});
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
				$UI.msg("alert", "发放科室不能为空!");
				return false;
			};
			if (isEmpty($HUI.combobox("#ReqLoc").getValue())) {
				$UI.msg("alert", "接收科室不能为空!");
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
			SetDefaValues();
			setEditEnable();
		}
	});

	$UI.linkbutton('#PrintBT', {
		onClick: function () {
			PrintINDisp($('#RowId').val());
		}
	});

	$UI.linkbutton('#SelReqBT', {
		onClick: function () {
			var DispLoc = $('#LocId').combobox('getValue');
			SelReqWin(Select, DispLoc);
		}
	});

	$UI.linkbutton('#SelInitBT', {
		onClick: function () {
			var DispLoc = $('#LocId').combobox('getValue');
			var ReqLoc = $('#ReqLoc').combobox('getValue');
			if (ReqLoc == "") {
				$UI.msg('alert', "请选择接收科室!");
				return;
			}
			SelInitWin(Select, DispLoc, ReqLoc);
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
				$UI.msg('alert', '请选择发放科室!')
				return;
			}
			if (isEmpty(MainObj['ReqLoc'])) {
				$UI.msg('alert', '请选择接收科室!')
				return;
			}
			var ReqMode = $("input[name='ReqMode']:checked").val();
			if ((ReqMode == '1') && (isEmpty(MainObj['UserList']))) {
				$UI.msg('alert', '请选择发放人员!')
				return;
			}
			if ((ReqMode == '0') && (isEmpty(MainObj['GrpList']))) {
				$UI.msg('alert', '请选择发放专业组!')
				return;
			}
			var Main = JSON.stringify(MainObj);
			var Detail = MainGrid.getChangesData();
			//判断
			if (Detail === false){	//未完成编辑或明细为空
				return;
			}
			if (isEmpty(Detail)){	//明细不变
				$UI.msg("alert", "没有需要保存的明细!");
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINDisp',
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
			var Inds = ParamsObj['RowId'];
			if (isEmpty(Inds)) {
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
			var Inds = ParamsObj['RowId'];
			if (isEmpty(Inds)) {
				return;
			}
			var CompFlag = ParamsObj['CompFlag'];
			if (CompFlag == 'Y') {
				$UI.msg('alert', '该单据已完成,不可重复操作!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINDisp',
				MethodName: 'SetComp',
				Inds: Inds
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
			var Inds = ParamsObj['RowId'];
			if (isEmpty(Inds)) {
				return;
			}
			var CompFlag = ParamsObj['CompFlag'];
			if (CompFlag != 'Y') {
				$UI.msg('alert', '该单据不是完成状态,不可操作!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINDisp',
				MethodName: 'CancelComp',
				Inds: Inds
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

	function ReturnInfoFunc(rows) {
		rows = [].concat(rows);
		$.each(rows, function (index, row) {
			if (row.OperQty<0)
			{
				$UI.msg("alert","发放数量不能小于0");
				return false;
			}
			var RowIndex = MainGrid.editIndex;
			var ed = $('#MainGrid').datagrid('getEditor', { index: RowIndex, field: 'UomId' });
			AddComboData(ed.target, row.PurUomId, row.PurUomDesc);
			var BatchNo = row.BatExp.split("~")[0];
			var ExpDate = row.BatExp.split("~")[1];
			MainGrid.updateRow({
				index: RowIndex,
				row: {
					InciId: row.InciDr,
					InciCode: row.InciCode,
					InciDesc: row.InciDesc,
					Spec: row.Spec,
					Inclb: row.Inclb,
					BatchNo: BatchNo,
					ExpDate: ExpDate,
					Qty: row.OperQty,
					UomId: row.PurUomId,
					UomDesc: row.PurUomDesc,
					Rp: row.Rp,
					Sp: row.Sp,
					RpAmt: accMul(row.OperQty, row.Rp),
					SpAmt: accMul(row.OperQty, row.Sp),
					InclbQty: row.InclbQty,
					DirtyQty: row.DirtyQty,
					AvaQty: row.AvaQty
				}
			});
			$('#MainGrid').datagrid('refreshRow', RowIndex);
			if (index < rows.length) {
				MainGrid.commonAddRow();
			}
		});
	}

	function Select(Inds) {
		$UI.clearBlock('#Conditions');
		$UI.clear(MainGrid);
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINDisp',
			MethodName: 'Select',
			Inds: Inds
		}, function (jsonData) {
			$UI.fillBlock('#Conditions', jsonData);
			if(jsonData.UserList.RowId!=""){
				$HUI.radio("#DisByUser").setValue(true);
				$('#UserList').combobox('setValue', jsonData.UserList.RowId);
			}
			if(jsonData.GrpList.RowId!=""){
				$HUI.radio("#DisByGrp").setValue(true);
				$('#GrpList').combobox('setValue', jsonData.GrpList.RowId);
			}
			if ($HUI.checkbox('#CompFlag').getValue()) {
				setEditDisable();
			} else {
				setEditEnable();
			}
		});
		MainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINDispItm',
			QueryName: 'DHCINDispItm',
			Parref: Inds,
			rows: 9999
		});
	}

	function Delete() {
		var ParamsObj = $UI.loopBlock('#Conditions');
		var Inds = ParamsObj['RowId'];
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINDisp',
			MethodName: 'Delete',
			Inds: Inds
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
			'#CanComBT': true
		});
	}

	function setEditEnable() {
		$HUI.combobox("#LocId").enable();
		$HUI.combobox("#Scg").enable();
		ChangeButtonEnable({
			'#DelBT': true,
			'#ComBT': true,
			'#SaveBT': true,
			'#CanComBT': false
		});
	}
	SetDefaValues();
}
$(init);
