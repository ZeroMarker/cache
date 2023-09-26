var init = function () {
	///���ÿɱ༭�����disabled����
	function setEditDisable() {
		$HUI.combobox("#RetLoc").disable();
		$HUI.combobox("#ScgStk").disable();
		$HUI.combobox("#Vendor").disable();
	}
	///�ſ��ɱ༭�����disabled����
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
		//�ж�
		var ifChangeMain=$UI.isChangeBlock('#MainConditions');
		if (DetailObj === false){	//δ��ɱ༭����ϸΪ��
			return;
		}
		if (!ifChangeMain && (isEmpty(DetailObj))){	//��������ϸ����
			$UI.msg("alert", "û����Ҫ�������Ϣ!");
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
			$UI.confirm('ȷ��Ҫɾ����?', '', '', del)
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
				$UI.msg("alert", "��ѡ����Ҫ��ӡ���˻���!");
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
				//��ť����
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
			totalFooter:'"Code":"�ϼ�"',
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
		title: '���ʴ���',
		field: 'Code',
		width: 100
	}, {
		title: '��������',
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
		title: "���",
		field: 'Spec',
		width: 100
	}, {
		title: "����",
		field: 'Manf',
		width: 150
	}, {
		title: "����",
		field: 'BatNo',
		width: 100
	}, {
		title: "Ч��",
		field: 'ExpDate',
		width: 120
	}, {
		title: "���δ���",
		field: 'StkQty',
		width: 100,
		align: 'right'
	}, {
		title: "�˻�����",
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
		title: "��λ",
		field: 'Uom',
		width: 100,
		formatter: CommonFormatter(UomCombox, 'Uom', 'UomDesc'),
		editor: UomCombox
	}, {
		title: "�˻�ԭ��",
		field: 'ReasonId',
		width: 100,
		formatter: CommonFormatter(ReasonCombox, 'ReasonId', 'Reason'),
		editor: ReasonCombox
	}, {
		title: "�˻�����",
		field: 'Rp',
		width: 100,
		align: 'right'
	}, {
		title: "���۽��",
		field: 'RpAmt',
		width: 100,
		align: 'right'
	}, {
		title: "��Ʊ��",
		field: 'InvNo',
		width: 100,
		align: 'left',
		editor: {
			type: 'text'
		}
	}, {
		title: "��Ʊ����",
		field: 'InvDate',
		width: 100,
		align: 'right',
		editor: {
			type: 'datebox'
		}

	}, {
		title: "��Ʊ���",
		field: 'InvAmt',
		width: 100,
		align: 'right',
		editor: {
			type: 'numberbox'
		}
	}, {
		title: "���۵���",
		field: 'Sp',
		width: 100,
		align: 'right'
	}, {
		title: "�ۼ۽��",
		field: 'SpAmt',
		width: 100,
		align: 'right'
	}, {
		title: "��ע",
		field: 'Remark',
		width: 200,
		align: 'left',
		editor: {
			type: 'text'
		}
	}, {
		title: "������",
		field: 'SpecDesc',
		width: 100,
		align: 'left',
		sortable: true
	}, {
		title: "��ֵ��־",
		field: 'HvFlag',
		width: 80,
		align: 'center',
		hidden: true,
		formatter: function (v) {
			if (v == "Y") {
				return "��"
			} else {
				return "��"
			}
		}
	}, {
		title: "���е���",
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
			totalFooter:'"Code":"�ϼ�"',
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
						$UI.msg("alert", "�˻��������ܴ��ڿ������!");
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
				$UI.msg("alert", "�Ѿ���ɣ����ܱ༭!");
				return false;
			}
		},
		beforeDelFn: function () {
			if ($HUI.checkbox("#Completed").getValue()) {
				$UI.msg("alert", "�Ѿ���ɣ�����ɾ��ѡ����!");
				return false;
			}
		},
		beforeAddFn: function () {
			if ($HUI.checkbox("#Completed").getValue()) {
				$UI.msg("alert", "�Ѿ���ɣ���������һ��!");
				return false;
			}
			if (isEmpty($HUI.combobox("#RetLoc").getValue())) {
				$UI.msg("alert", "�˻����Ҳ���Ϊ��!");
				return false;
			};
			if (isEmpty($HUI.combobox("#Vendor").getValue())) {
				$UI.msg("alert", "��Ӧ�̲���Ϊ��!");
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
