var init = function () {

	///���ÿɱ༭�����disabled����
	var ClearMain = function () {
		$UI.clearBlock('#MainConditions');
		$UI.clear(INAdjMGrid);
		SetDefaultData();
		setEditEnable();
		ChangeButtonEnable({
			'#DelBT': false,
			'#PrintBT': false,
			'#ComBT': false,
			'#CanComBT': false,
			'#SaveBT': true
		});	
	}
	function setEditDisable() {
		$HUI.combobox("#AdjLoc").disable();
		$HUI.combobox("#ScgStk").disable();
	}
	///�ſ��ɱ༭�����disabled����
	function setEditEnable() {
		$HUI.combobox("#AdjLoc").enable();
		$HUI.combobox("#ScgStk").enable();
	}

	var UomCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetInciUom&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			mode: 'remote',
			onBeforeLoad:function(param){
				var Select = INAdjMGrid.getRows()[INAdjMGrid.editIndex];
				if(!isEmpty(Select)){
					param.Inci = Select.InciId;
				}
			},
			onSelect: function (record) {
				var rows = INAdjMGrid.getRows();
				var row = rows[INAdjMGrid.editIndex];
				row.uomDesc = record.Description;
				var NewUomid = record.RowId;
				var OldUomid = row.UomId;
				if (isEmpty(NewUomid) || (NewUomid == OldUomid)) {
					return false;
				}
				var BUomId = row.BUomId;
				var Rp = row.Rp;
				var InclbQty = row.InclbQty;
				var Qty = row.Qty;
				var Sp = row.Sp;
				var RpAmt = row.RpAmt;
				var SpAmt = row.SpAmt;
				var AvaQty = row.AvaQty;
				var confac = row.ConFac;
				if (NewUomid == BUomId) { //��ⵥλת��Ϊ������λ
					row.Rp = Number(Rp).div(confac);
					row.Sp = Number(Sp).div(confac);
					if(InclbQty!=""){
					row.InclbQty=Number(InclbQty).mul(confac)	
					}
					if(Qty!=""){
					row.Qty=Number(Qty).mul(confac)	
					}
					if(AvaQty!=""){
					row.AvaQty=Number(AvaQty).mul(confac)	
					}
				} else { //������λת��Ϊ��ⵥλ
					row.Rp = Number(Rp).mul(confac);
					row.Sp = Number(Sp).mul(confac);
					if(InclbQty!=""){
					row.InclbQty=Number(InclbQty).div(confac)	
					}
					if(Qty!=""){
					row.Qty=Number(Qty).div(confac)	
					}
					if(AvaQty!=""){
					row.AvaQty=Number(AvaQty).div(confac)	
					}
				}
				row.UomId = NewUomid;
				$('#INAdjMGrid').datagrid('refreshRow', INAdjMGrid.editIndex);
			},
			onShowPanel: function () {
				$(this).combobox('reload');
			}
		}
	};

	var AdjLocParams = JSON.stringify(addSessionParams({
				Type: "All"
			}));
	var AdjLocBox = $HUI.combobox('#AdjLoc', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + AdjLocParams,
			valueField: 'RowId',
			textField: 'Description'
		});
	var UserBox = $HUI.combobox('#User', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetUser&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description'
		});
	var ForAdjustReasonIdParams = JSON.stringify(addSessionParams({
				Type: "M"
			}));
	var ForAdjustReasonIdBox = $HUI.combobox('#ForAdjustReasonId', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetForAdjustReason&ResultSetType=array&Params=' + ForAdjustReasonIdParams,
			valueField: 'Rowid',
			textField: 'Description'
		});
	//��ť��ز���
	$UI.linkbutton('#QueryBT', {
		onClick: function () {
			var HvFlag="N";
			FindWin(Select,HvFlag);
		}
	});
	var Save = function () {
		var MainObj = $UI.loopBlock('#MainConditions')
			var MainInfo = JSON.stringify(MainObj)
			var IsChange = $UI.isChangeBlock('#MainConditions')
			if (MainObj['INADCompleted'] == 'Y') {
				$UI.msg('alert', '�õ����Ѿ����,�����ظ�����!');
				return;
			}
			var MainInfo = JSON.stringify(MainObj)
			var SelectedRow = INAdjMGrid.getSelected();
		if (isEmpty(SelectedRow) && IsChange === false) {
			$UI.msg('alert',"û����Ҫ�������ϸ!");
			return false;
		}
		var ListData = INAdjMGrid.getChangesData('Inclb')
		if (ListData === false){	//δ��ɱ༭����ϸΪ��
			return;
		}
		if (isEmpty(ListData)){	//��ϸ����
			$UI.msg("alert", "û����Ҫ�������ϸ!");
			return;
		}
		var ListData=JSON.stringify(ListData)
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINAdj',
			MethodName: 'SaveAdj',
			MainInfo: MainInfo,
			ListData: ListData
		}, function (jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				Select(jsonData.rowid);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}

	$UI.linkbutton('#SaveBT', {
		onClick: function () {
			Save();
		}
	});

	$UI.linkbutton('#DelBT', {
		onClick: function () {
			var InAdj = $('#RowId').val();
			if (isEmpty(InAdj)) {
				return;
			}
			function del() {
				$.cm({
					ClassName: 'web.DHCSTMHUI.DHCINAdj',
					MethodName: 'Delete',
					InAdj: InAdj
				}, function (jsonData) {
					if (jsonData.success === 0) {
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
				if (MainObj['INADCompleted'] == 'Y') {
					$UI.msg('alert', '�õ����Ѿ����!');
					return;
				}
				var InAdj = MainObj.RowId;
			if (isEmpty(InAdj)) {
				return;
			}
			var Main = JSON.stringify(MainObj);
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINAdj',
				MethodName: 'SetComplete',
				Params: Main,
				InAdj: InAdj
			}, function (jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					Select(InAdj);
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#CanComBT', {
		onClick: function () {
			var MainObj = $UI.loopBlock('#MainConditions')
				if (MainObj['INADCompleted'] != 'Y') {
					$UI.msg('alert', '�õ���δ��ɣ�����ȡ�����!');
					return;
				}
				var InAdj = MainObj.RowId;
			var Main = JSON.stringify(MainObj);
			if (isEmpty(InAdj)) {
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINAdj',
				MethodName: 'SetCancelComplete',
				Params: Main,
				InAdj: InAdj
			}, function (jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					Select(InAdj);
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#ClearBT', {
		onClick: function () {
			ClearMain();
		}
	});
	$UI.linkbutton('#PrintBT', {
		onClick: function () {
			if (isEmpty($('#RowId').val())) {
				$UI.msg('alert', "û����Ҫ��ӡ�ĵ���!");
				return;
			}
			PrintInAdj($('#RowId').val());
		}
	});
	var Select = function (RowId) {
		$UI.clearBlock('#MainConditions');
		$UI.clear(INAdjMGrid);
		setEditDisable()
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINAdj',
			MethodName: 'jsSelect',
			InAdj: RowId
		}, function (jsonData) {
			$UI.fillBlock('#MainConditions', jsonData)
			if ($HUI.checkbox("#INADCompleted").getValue() == false) {
				setUnComp()
			} else {
				setComp()
			}
		});

		var ParamsObj = {
			InAdj: RowId
		};
		var Params = JSON.stringify(ParamsObj);
		$UI.setUrl(INAdjMGrid);
		INAdjMGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINAdjItm',
			QueryName: 'DHCINAdjD',
			Params: Params,
			rows: 99999,
			totalFooter:'"Code":"�ϼ�"',
			totalFields:'RpAmt,SpAmt'
		});
	}
	//���ÿɱ༭�����disabled����
	function setUnComp() {
		ChangeButtonEnable({
			'#SaveBT': true,
			'#DelBT': true,
			'#ComBT': true,
			'#CanComBT': false,
			'#PrintBT': true
		});
	}
	function setComp() {
		ChangeButtonEnable({
			'#SaveBT': false,
			'#DelBT': false,
			'#ComBT': false,
			'#CanComBT': true,
			'#PrintBT': true
		});
	}

	var INAdjMGridCm = [[{
				title: 'RowId',
				field: 'RowId',
				saveCol: true,
				width: 80,
				hidden: true
			}, {
				title: "InciId",
				field: 'InciId',
				width: 150,
				hidden: true
			}, {
				title: "����",
				field: 'Code',
				width: 100
			}, {
				title: '��������',
				field: 'InciDesc',
				jump:false,
				editor: {
					type: 'validatebox',
					options: {
						required: true
					}
				},
				width: 180
			}, {
				title: "���",
				field: 'Spec',
				width: 100
			}, {
				title: "Inclb",
				field: 'Inclb',
				saveCol: true,
				width: 150,
				hidden: true
			}, {
				title: "����~Ч��",
				field: 'BatExp',
				width: 150
			}, {
				title: "����",
				field: 'ManfDesc',
				width: 200
			}, {
				title: "���ο��",
				field: 'InclbQty',
				align: 'right',
				width: 80
			}, {
				title: "���ÿ��",
				field: 'AvaQty',
				align: 'right',
				width: 80
			}, {
				title: "��������",
				field: 'Qty',
				width: 100,
				align: 'right',
				saveCol: true,
				editor: {
					type: 'numberbox',
					options: {
						precision: 2,
						required: true
					}
				}
			}, {
				title: "��λ",
				field: 'UomId',
				width: 100,
				saveCol: true,
				necessary: true,
				formatter: CommonFormatter(UomCombox, 'UomId', 'uomDesc'),
				editor: UomCombox,
				width: 50
			}, {
				title: "����",
				field: 'Rp',
				saveCol: true,
				width: 100
			}, {
				title: "���۽��",
				field: 'RpAmt',
				width: 100
			}, {
				title: "�ۼ�",
				field: 'Sp',
				saveCol: true,
				width: 100
			}, {
				title: "�ۼ۽��",
				field: 'SpAmt',
				width: 100
			},{
				title: "ConFac",
				field: 'ConFac',
				width: 100,
				hidden: true
			}, {
				title: "BUomId",
				field: 'BUomId',
				width: 100,
				hidden: true
			}
		]];
	var INAdjMGrid = $UI.datagrid('#INAdjMGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCINAdjItm',
				QueryName: 'DHCINAdjD',
				rows:99999,
				totalFooter:'"Code":"�ϼ�"',
				totalFields:'RpAmt,SpAmt'
			},
			deleteRowParams: {
				ClassName: 'web.DHCSTMHUI.DHCINAdjItm',
				MethodName: 'jsDelete'
			},
			columns: INAdjMGridCm,
			remoteSort: false,
			showBar: true,
			showAddDelItems: true,
			pagination: false,
			onClickCell: function (index, filed, value) {
				if ($HUI.checkbox("#INADCompleted").getValue()) {
					return false;
				}
			},
			onBeforeEdit: function (index, row) {
				if ($HUI.checkbox("#INADCompleted").getValue()) {
					return false;
				}
			},
			beforeAddFn: function () {
				if ($HUI.checkbox("#INADCompleted").getValue()) {
					$UI.msg('alert', "�Ѿ���ɣ���������һ��!");
					return false;
				}
				if (isEmpty($HUI.combobox("#AdjLoc").getValue())) {
					$UI.msg('alert', "�Ƶ����Ҳ���Ϊ��!");
					return false;
				}
				if (isEmpty($HUI.combobox("#ScgStk").getValue())) {
					$UI.msg('alert', "���鲻��Ϊ��!");
					return false;
				}
				if (isEmpty($HUI.combobox("#ForAdjustReasonId").getValue())) {
					$UI.msg('alert', "����ԭ����Ϊ��!");
					return false;
				}
			},
			beforeDelFn: function () {
				if ($HUI.checkbox("#INADCompleted").getValue()) {
					$UI.msg('alert', "�Ѿ���ɣ�����ɾ��ѡ����!");
					return false;
				}
			},
			onClickCell: function (index, field, value) {
				INAdjMGrid.commonClickCell(index, field);
			},
			onBeginEdit: function (index, row) {
				$('#INAdjMGrid').datagrid('beginEdit', index);
				var ed = $('#INAdjMGrid').datagrid('getEditors', index);
				for (var i = 0; i < ed.length; i++) {
					var e = ed[i];
					if (e.field == "InciDesc") {
						$(e.target).bind("keydown", function (event) {
							if (event.keyCode == 13) {
								var Input = $(this).val();
								var Scg = $("#ScgStk").combotree('getValue');
								var LocDr = $("#AdjLoc").combo('getValue');
								var HV = 'N';
								var ParamsObj = {
									StkGrpRowId: Scg,
									StkGrpType: "M",
									Locdr: LocDr,
									NotUseFlag: "N",
									QtyFlag: "Y",
									HV: HV,
									IntrType: 'A'
								};
								IncItmBatWindow(Input, ParamsObj, ReturnInfoFunc);
							}
						});
					}
				}
			},
			onAfterEdit: function(index, row, changes) {
				if (changes.hasOwnProperty('Qty')) {	
					var Qty = Number(changes['Qty']);
					var AvaQty = Number(row['AvaQty']);
					if (Qty < 0 && accAdd(Qty, AvaQty) < 0) {
						$UI.msg('alert', '��������Ϊ����ʱ, ���ɴ��ڿ��ÿ��!');
						$(this).datagrid('updateRow', {
							index: index,
							row: {
								Qty: '',
								RpAmt: 0,
								SpAmt: 0
							}
						});
						INAdjMGrid.checked = false;
						return;
					}
					var Rp = Number(row['Rp']),Sp = Number(row['Sp']);
					$(this).datagrid('updateRow', {
						index: index,
						row: {
							RpAmt: accMul(Qty, Rp),
							SpAmt: accMul(Qty, Sp)
						}
					});
				}
				INAdjMGrid.setFooterInfo();
			}
		});
	function ReturnInfoFunc(rows) {
		rows = [].concat(rows);
		if (rows == null || rows == "") {
			return;
		}
		$.each(rows, function (index, row) {
			var RowIndex = INAdjMGrid.editIndex;
			var ed = $('#INAdjMGrid').datagrid('getEditor', {
					index: RowIndex,
					field: 'UomId'
				});
			AddComboData(ed.target, row.PurUomId, row.PurUomDesc)
			INAdjMGrid.updateRow({
				index: RowIndex,
				row: {
					InciId: row.InciDr,
					Code: row.InciCode,
					InciDesc: row.InciDesc,
					Spec: row.Spec,
					Inclb: row.Inclb,
					ManfDesc: row.Manf,
					BatExp: row.BatExp,
					Qty: row.OperQty,
					UomId: row.PurUomId,
					uomDesc: row.PurUomDesc,
					Rp: row.Rp,
					Sp: row.Sp,
					RpAmt: accMul(row.OperQty, row.Rp),
					SpAmt: accMul(row.OperQty, row.Sp),
					InclbQty: row.InclbQty,
					ConFac: row.ConFac,
					BUomId: row.BUomId,
					AvaQty: row.AvaQty
				}
			});
			$('#INAdjMGrid').datagrid('refreshRow', RowIndex);
			INAdjMGrid.setFooterInfo();
			if (index < rows.length) {
				INAdjMGrid.commonAddRow();
			}
		});
	}
	/*--���ó�ʼֵ--*/
	var SetDefaultData = function () {
		$('#ScgStk').combotree('options')['setDefaultFun']();
		$('#AdjLoc').combobox('setValue', gLocId);
		$('#Date').datebox('setValue', DateFormatter(new Date()));
		INAdjMGrid.setFooterInfo();
	}
	SetDefaultData();
}
$(init);
