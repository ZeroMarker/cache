var DispLocId = '';
var init = function() {
	$HUI.radio("[name='ReqMode']", {
		onChecked: function(e, value) {
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
	// 发放科室
	var DispLocParams = JSON.stringify(addSessionParams({
		Type: 'Login',
		Element: 'LocId',
		LoginLocType: 2
	}));
	var DispLocBox = $HUI.combobox('#LocId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + DispLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			DispLocId = record['RowId'];
			$('#ReqLoc').combobox('clear');
			$('#ReqLoc').combobox('reload', $URL
				+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='
				+ JSON.stringify(addSessionParams({
					Type: 'LeadLoc',
					LocId: DispLocId,
					Element: 'ReqLoc'
				})));
			$('#ReqLoc').combobox('setValue', DispLocId);
		}
	});
	$('#LocId').combobox('setValue', gLocId);
	DispLocId = $('#LocId').combobox('getValue');
	// 接收科室
	var ReqLocParams = JSON.stringify(addSessionParams({
		Type: 'LeadLoc',
		LocId: DispLocId,
		Element: 'ReqLoc'
	}));
	var ReqLocBox = $HUI.combobox('#ReqLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + ReqLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onChange: function(newValue, oldValue) {
			var LocId = newValue;
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
		},
		onSelect: function(record) {
			var LocId = record['RowId'];
			if ((DispLocId != LocId) && (INDispParamObj.AllowCrossLoc != 'Y')) {
				$UI.msg('alert', '不允许跨科室发放!');
				$('#ReqLoc').combobox('clear');
				return false;
			}
		}
	});
	$('#ReqLoc').combobox('setValue', DispLocId);
	// 专业组
	var GrpListBox = $HUI.combobox('#GrpList', {
		url: '',
		valueField: 'RowId',
		textField: 'Description'
	});
	// 科室人员
	var UserListBox = $HUI.combobox('#UserList', {
		url: '',
		valueField: 'RowId',
		textField: 'Description'
	});
	// 单位
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
					param.Inci = Select.InciId;
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
			title: '物资代码',
			field: 'InciCode',
			width: 100
		}, {
			title: '物资名称',
			field: 'InciDesc',
			jump: false,
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
			title: '数量',
			field: 'Qty',
			width: 80,
			saveCol: true,
			align: 'right'
		}, {
			title: '单位',
			field: 'UomId',
			saveCol: true,
			formatter: CommonFormatter(UomCombox, 'UomId', 'UomDesc'),
			editor: UomCombox,
			width: 80
		}, {
			title: '可用库存',
			field: 'AvaQty',
			width: 100,
			align: 'right',
			hidden: true
		}, {
			title: '批次占用库存',
			field: 'DirtyQty',
			width: 50,
			align: 'right',
			hidden: true
		}, {
			title: '进价',
			field: 'Rp',
			saveCol: true,
			width: 80,
			align: 'right'
		}, {
			title: '进价金额',
			field: 'RpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '售价',
			field: 'Sp',
			saveCol: true,
			width: 80,
			align: 'right'
		}, {
			title: '售价金额',
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
			QueryName: 'DHCINDispItm',
			query2JsonStrict: 1
		},
		deleteRowParams: {
			ClassName: 'web.DHCSTMHUI.DHCINDispItm',
			MethodName: 'jsDelete'
		},
		columns: MainCm,
		checkField: 'Inclb',
		showBar: true,
		remoteSort: false,
		showAddDelItems: true,
		pagination: false,
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
							} else if (Status != 'Enable') {
								CheckMsg = '该高值条码处于不可用状态,不可制单!';
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
							var ProLocId = $('#LocId').combobox('getValue');
							var ReqLocId = $('#ReqLoc').combobox('getValue');
							var ParamsObj = { InciDr: Inci, ProLocId: ProLocId, ReqLocId: ReqLocId, QtyFlag: 1, Inclb: Inclb };
							var Params = JSON.stringify(ParamsObj);
							var InclbData = $.cm({
								ClassName: 'web.DHCSTMHUI.Util.DrugUtil',
								MethodName: 'GetDrugBatInfo',
								page: 1,
								rows: 1,
								Params: Params
							}, false);
							if (!InclbData || InclbData.rows.length < 1) {
								$UI.msg('alert', BarCode + '没有相应库存记录,不能制单!');
								$(this).val('');
								$(this).focus();
								MainGrid.stopJump();
								return false;
							}
							$(this).val(BarCode).validatebox('validate');
							var InclbInfo = $.extend(InclbData.rows[0], { InciDr: Inci, dhcit: dhcit, HVBarCode: BarCode, OriginalStatus: OriginalStatus });
							ReturnInfoFunc(index, InclbInfo);
						}
					});
				}
			}
		},
		onAfterEdit: function(index, row, changes) {
			if (changes.hasOwnProperty('Qty')) {
				var Qty = Number(changes['Qty']);
				if (Qty <= 0) {
					$UI.msg('alert', '数量不可小于或等于0!');
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
			}
		},
		beforeDelFn: function() {
			if ($HUI.checkbox('#CompFlag').getValue()) {
				$UI.msg('alert', '已经完成，不能删除选中行!');
				return false;
			}
		},
		beforeAddFn: function() {
			if ($HUI.checkbox('#CompFlag').getValue()) {
				$UI.msg('alert', '已经完成，不能增加一行!');
				return false;
			}
			if (isEmpty($HUI.combobox('#LocId').getValue())) {
				$UI.msg('alert', '发放科室不能为空!');
				return false;
			}
			if (isEmpty($HUI.combobox('#ReqLoc').getValue())) {
				$UI.msg('alert', '接收科室不能为空!');
				return false;
			}
		},
		onLoadSuccess: function(data) {
			var RowId = $('#RowId').val();
			if (isEmpty(RowId)) {
				for (var i = 0; i < data.rows.length; i++) {
					data.rows[i].RowId = '';
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
			$UI.clearBlock('#Conditions');
			$UI.clear(MainGrid);
			SetDefaValues();
			setEditEnable();
		}
	});

	$UI.linkbutton('#PrintBT', {
		onClick: function() {
			PrintINDisp($('#RowId').val());
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
				$UI.msg('alert', '请选择发放科室!');
				return;
			}
			if (isEmpty(MainObj['ReqLoc'])) {
				$UI.msg('alert', '请选择接收科室!');
				return;
			}
			var ReqMode = $("input[name='ReqMode']:checked").val();
			if ((ReqMode == '1') && (isEmpty(MainObj['UserList']))) {
				$UI.msg('alert', '请选择发放人员!');
				return;
			}
			if ((ReqMode == '0') && (isEmpty(MainObj['GrpList']))) {
				$UI.msg('alert', '请选择发放专业组!');
				return;
			}
			var Main = JSON.stringify(MainObj);
			var Detail = MainGrid.getChangesData();
			// 判断
			if (Detail === false) {	// 未完成编辑或明细为空
				return;
			}
			if (isEmpty(Detail)) {	// 明细不变
				$UI.msg('alert', '没有需要保存的明细!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINDisp',
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
			var Inds = ParamsObj['RowId'];
			if (isEmpty(Inds)) {
				$UI.msg('alert', '发放单不存在!');
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
			var Inds = ParamsObj['RowId'];
			if (isEmpty(Inds)) {
				return;
			}
			var CompFlag = ParamsObj['CompFlag'];
			if (CompFlag == 'Y') {
				$UI.msg('alert', '该单据已完成,不可重复操作!');
				return;
			}
			if (isEmpty(ParamsObj.ReqLoc)) {
				$UI.msg('alert', '接收科室不能为空!');
				return false;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINDisp',
				MethodName: 'jsSetComp',
				Inds: Inds,
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

	function ReturnInfoFunc(RowIndex, row) {
		console.log(row);
		var BatchNo = row.BatExp.split('~')[0];
		var ExpDate = row.BatExp.split('~')[1];
		MainGrid.updateRow({
			index: RowIndex,
			row: {
				HVBarCode: row.HVBarCode,
				InciId: row.InciDr,
				InciCode: row.InciCode,
				InciDesc: row.InciDesc,
				Spec: row.Spec,
				Inclb: row.Inclb,
				Manf: row.Manf,
				BatchNo: BatchNo,
				ExpDate: ExpDate,
				Qty: 1,
				UomId: row.PurUomId,
				UomDesc: row.PurUomDesc,
				Rp: row.Rp,
				Sp: row.Sp,
				RpAmt: row.Rp,
				SpAmt: row.Sp,
				DirtyQty: row.DirtyQty,
				AvaQty: row.AvaQty
			}
		});
		setTimeout(function() {
			MainGrid.refreshRow();
			MainGrid.commonAddRow();
		}, 50);
	}

	function Select(Inds) {
		$UI.clearBlock('#Conditions');
		$UI.clear(MainGrid);
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINDisp',
			MethodName: 'Select',
			Inds: Inds
		}, function(jsonData) {
			$UI.fillBlock('#Conditions', jsonData);
			if (jsonData.UserList.RowId != '') {
				$HUI.radio('#DisByUser').setValue(true);
				$('#UserList').combobox('setValue', jsonData.UserList.RowId);
			}
			if (jsonData.GrpList.RowId != '') {
				$HUI.radio('#DisByGrp').setValue(true);
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
			query2JsonStrict: 1,
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

	function setEditDisable() {
		$HUI.combobox('#LocId').disable();
		$HUI.combobox('#Scg').disable();
		ChangeButtonEnable({
			'#DelBT': false,
			'#ComBT': false,
			'#SaveBT': false,
			'#CanComBT': true
		});
	}

	function setEditEnable() {
		$HUI.combobox('#LocId').enable();
		$HUI.combobox('#Scg').enable();
		ChangeButtonEnable({
			'#DelBT': true,
			'#ComBT': true,
			'#SaveBT': true,
			'#CanComBT': false
		});
	}
	SetDefaValues();
};
$(init);