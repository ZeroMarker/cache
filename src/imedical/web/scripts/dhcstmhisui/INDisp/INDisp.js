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
	//���ſ���
	var DispLocParams = JSON.stringify(addSessionParams({
		Type: 'Login'
	}));
	var DispLocBox = $HUI.combobox('#LocId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + DispLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	//���տ���
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
	//רҵ��
	var GrpListBox = $HUI.combobox('#GrpList', {
		url: '',
		valueField: 'RowId',
		textField: 'Description'
	});
	//������Ա
	var UserListBox = $HUI.combobox('#UserList', {
		url: '',
		valueField: 'RowId',
		textField: 'Description'
	});
	//��λ
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
		title: '��������Id',
		field: 'Inclb',
		width: 50,
		saveCol: true,
		hidden: true
	}, {
		title: '����RowId',
		field: 'InciId',
		width: 50,
		hidden: true
	}, {
		title: '����',
		field: 'InciCode',
		width: 100
	}, {
		title: '����',
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
		title: "���",
		field: 'Spec',
		width: 100
	}, {
		title: '����',
		field: 'BatchNo',
		width: 100
	}, {
		title: 'Ч��',
		field: 'ExpDate',
		width: 100
	}, {
		title: "����",
		field: 'Manf',
		width: 150
	}, {
		title: "����",
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
		title: "��λ",
		field: 'UomId',
		saveCol: true,
		formatter: CommonFormatter(UomCombox, 'UomId', 'UomDesc'),
		editor: UomCombox,
		width: 80
	}, {
		title: "���ο��",
		field: 'InclbQty',
		width: 80,
		align: 'right'
	}, {
		title: "���ÿ��",
		field: 'AvaQty',
		width: 100,
		align: 'right'
	}, {
		title: "����ռ�ÿ��",
		field: 'DirtyQty',
		width: 50,
		align: 'right',
		hidden: true
	}, {
		title: "����",
		field: 'Rp',
		saveCol: true,
		width: 80,
		align: 'right'
	}, {
		title: "���۽��",
		field: 'RpAmt',
		width: 100,
		align: 'right'
	}, {
		title: "�ۼ�",
		field: 'Sp',
		saveCol: true,
		width: 80,
		align: 'right'
	}, {
		title: "�ۼ۽��",
		field: 'SpAmt',
		width: 100,
		align: 'right'
	}, {
		title: '��Ʒ��ע',
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
				$UI.msg("alert", "�Ѿ���ɣ������޸�!");
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
					$UI.msg('alert', '��������С��0!');
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
					$UI.msg('alert', '�������ɴ��ڿ��ÿ��!');
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
				$UI.msg("alert", "�Ѿ���ɣ�����ɾ��ѡ����!");
				return false;
			}
		},
		beforeAddFn: function () {
			if ($HUI.checkbox('#CompFlag').getValue()) {
				$UI.msg("alert", "�Ѿ���ɣ���������һ��!");
				return false;
			}
			if (isEmpty($HUI.combobox("#LocId").getValue())) {
				$UI.msg("alert", "���ſ��Ҳ���Ϊ��!");
				return false;
			};
			if (isEmpty($HUI.combobox("#ReqLoc").getValue())) {
				$UI.msg("alert", "���տ��Ҳ���Ϊ��!");
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
				$UI.msg('alert', "��ѡ����տ���!");
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
				$UI.msg('alert', "û����Ҫ���������!");
				return;
			}
			if (MainObj['CompFlag'] == 'Y') {
				$UI.msg('alert', '�õ����Ѿ����,�����ظ�����!');
				return;
			}
			if (isEmpty(MainObj['LocId'])) {
				$UI.msg('alert', '��ѡ�񷢷ſ���!')
				return;
			}
			if (isEmpty(MainObj['ReqLoc'])) {
				$UI.msg('alert', '��ѡ����տ���!')
				return;
			}
			var ReqMode = $("input[name='ReqMode']:checked").val();
			if ((ReqMode == '1') && (isEmpty(MainObj['UserList']))) {
				$UI.msg('alert', '��ѡ�񷢷���Ա!')
				return;
			}
			if ((ReqMode == '0') && (isEmpty(MainObj['GrpList']))) {
				$UI.msg('alert', '��ѡ�񷢷�רҵ��!')
				return;
			}
			var Main = JSON.stringify(MainObj);
			var Detail = MainGrid.getChangesData();
			//�ж�
			if (Detail === false){	//δ��ɱ༭����ϸΪ��
				return;
			}
			if (isEmpty(Detail)){	//��ϸ����
				$UI.msg("alert", "û����Ҫ�������ϸ!");
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
				$UI.msg('alert', '�õ����Ѿ����,����ɾ��!');
				return;
			}
			$UI.confirm('����Ҫɾ������,�Ƿ����?', '', '', Delete);
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
				$UI.msg('alert', '�õ��������,�����ظ�����!');
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
				$UI.msg('alert', '�õ��ݲ������״̬,���ɲ���!');
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
				$UI.msg("alert","������������С��0");
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
