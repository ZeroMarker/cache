var init = function() {
	// /���ÿɱ༭�����disabled����
	function setEditDisable() {
		$HUI.combobox('#RetLoc').disable();
		$HUI.combobox('#ScgStk').disable();
		$HUI.combobox('#Vendor').disable();
	}
	// /�ſ��ɱ༭�����disabled����
	function setEditEnable() {
		$HUI.combobox('#RetLoc').enable();
		$HUI.combobox('#ScgStk').enable();
		$HUI.combobox('#Vendor').enable();
	}
	var ClearMain = function() {
		$UI.clearBlock('#MainConditions');
		$UI.clear(RetGrid);
		var DefaultData = {
			RetLoc: gLocObj
		};
		$UI.fillBlock('#MainConditions', DefaultData);
		ChangeButtonEnable({ '#DelBT': false, '#PrintBT': false, '#ComBT': false, '#CanComBT': false });
	};
	// Grid �� comboxData
	var UomCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetInciUom&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			mode: 'remote',
			editable: false,
			onBeforeLoad: function(param) {
				var rows = RetGrid.getRows();
				var row = rows[RetGrid.editIndex];
				if (!isEmpty(row)) {
					param.Inci = row.Inci;
				}
			},
			onSelect: function(record) {
				var rows = RetGrid.getRows();
				var row = rows[RetGrid.editIndex];
				row.UomDesc = record.Description;
			},
			onShowPanel: function() {
				$(this).combobox('reload');
			}
		}
	};
	
	var ReasonParams = JSON.stringify(addSessionParams());
	var ReasonCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetRetReason&ResultSetType=array&Params=' + ReasonParams,
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function(record) {
				var rows = RetGrid.getRows();
				var row = rows[RetGrid.editIndex];
				row.Reason = record.Description;
			}, onShowPanel: function() {
				$(this).combobox('reload');
			}
		}
	};
	var SpecDescParams = JSON.stringify(sessionObj);
	var SpecDescbox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetSpecDesc&ResultSetType=array&Params=' + SpecDescParams,
			valueField: 'Description',
			textField: 'Description',
			mode: 'remote',
			onBeforeLoad: function(param) {
				var rows = RetGrid.getRows();
				var row = rows[RetGrid.editIndex];
				if (!isEmpty(row)) {
					param.Inci = row.Inclb;
				}
			}
		}
	};
	var RetLocParams = JSON.stringify(addSessionParams({ Type: 'Login' }));
	var RetLocBox = $HUI.combobox('#RetLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + RetLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var LocId = record['RowId'];
			$HUI.combotree('#ScgStk').setFilterByLoc(LocId);
			if (CommParObj.ApcScg == 'L') {
				VendorBox.clear();
				var Params = JSON.stringify(addSessionParams({ APCType: 'M', LocId: LocId }));
				var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + Params;
				VendorBox.reload(url);
			}
		}
	});
	var VendorParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
	var VendorBox = $HUI.combobox('#Vendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	$('#ScgStk').stkscgcombotree({
		onSelect: function(node) {
			if (CommParObj.ApcScg == 'S') {
				VendorBox.clear();
				var Params = JSON.stringify(addSessionParams({ APCType: 'M' }));
				var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + Params + '&ScgId=' + node.id ;
				VendorBox.reload(url);
			}
		}
	});
	var UserBox = $HUI.combobox('#User', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetUser&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			FindWin(Select);
		}
	});
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			Save();
		}
	});
	function CheckDataBeforeSave() {
		if (!RetGrid.endEditing()) {
			return false;
		}
		var RowsData = RetGrid.getRows();
		if (RowsData.length == 0) {
			$UI.msg('alert', 'û��Ҫ�������ϸ!');
			return false;
		}
		var MainObj = $UI.loopBlock('#MainConditions');
		var InStkTkParamObj = GetAppPropValue('DHCSTINSTKTKM');
		if (InStkTkParamObj.AllowBusiness != 'Y') {
			var RetLoc = MainObj.RetLoc;
			var IfExistInStkTk = tkMakeServerCall('web.DHCSTMHUI.INStkTk', 'CheckInStkTkByLoc', RetLoc);
			if (IfExistInStkTk == 'Y') {
				$UI.msg('alert', '����δ��ɵ��̵㵥��������!');
				return false;
			}
		}
		for (var i = 0; i < RowsData.length; i++) {
			var row = i + 1;
			var ReasonId = RowsData[i].ReasonId;
			if (IngrtParamObj['AllowSaveReasonEmpty'] != 'Y' && isEmpty(ReasonId)) {
				$UI.msg('alert', '��' + row + '���˻�ԭ����Ϊ��!');
				return false;
			}
		}
	}
	var Save = function() {
		if (CheckDataBeforeSave() == false) {
			return;
		}
		var MainObj = $UI.loopBlock('#MainConditions');
		var Main = JSON.stringify(MainObj);
		var DetailObj = RetGrid.getChangesData('Ingri');
		// �ж�
		var ifChangeMain = $UI.isChangeBlock('#MainConditions');
		if (DetailObj === false) {	// δ��ɱ༭����ϸΪ��
			return;
		}
		if (!ifChangeMain && (isEmpty(DetailObj))) {	// ��������ϸ����
			$UI.msg('alert', 'û����Ҫ�������Ϣ!');
			return;
		}
		var Detail = JSON.stringify(DetailObj);
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRet',
			MethodName: 'jsSave',
			Main: Main,
			Detail: Detail
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				Select(jsonData.rowid);
				if (IngrtParamObj['AutoPrintAfterSaveDRET'] == 'Y') {
					PrintIngDretHVCol(jsonData.rowid);
				}
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	};
	$UI.linkbutton('#DelBT', {
		onClick: function() {
			var RetId = $('#RowId').val();
			if (isEmpty(RetId)) { return; }
			function del() {
				$.cm({
					ClassName: 'web.DHCSTMHUI.DHCINGdRet',
					MethodName: 'Delete',
					RetId: RetId,
					Params: JSON.stringify(sessionObj)
				}, function(jsonData) {
					if (jsonData.success == 0) {
						$UI.msg('success', jsonData.msg);
						ClearMain();
						setEditEnable();
					} else {
						$UI.msg('error', jsonData.msg);
					}
				});
			}
			$UI.confirm('ȷ��Ҫɾ����?', '', '', del);
		}
	});
	$UI.linkbutton('#ComBT', {
		onClick: function() {
			var MainObj = $UI.loopBlock('#MainConditions');
			var RetId = MainObj.RowId;
			if (isEmpty(RetId)) { return; }
			var Main = JSON.stringify(MainObj);
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINGdRet',
				MethodName: 'jsSetCompleted',
				Params: Main
			}, function(jsonData) {
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
		onClick: function() {
			var RetId = $('#RowId').val();
			if (isEmpty(RetId)) { return; }
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINGdRet',
				MethodName: 'jsCancelCompleted',
				RetId: RetId
			}, function(jsonData) {
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
		onClick: function() {
			ClearMain();
			setEditEnable();
		}
	});
	$UI.linkbutton('#PrintBT', {
		onClick: function() {
			if (isEmpty($('#RowId').val())) {
				$UI.msg('alert', 'û����Ҫ��ӡ������!');
				return;
			}
			var AuditFlag = $('#AuditFlag').val();
			if ((IngrtParamObj.PrintNoAudit == 'N') && (AuditFlag != 'Y')) {
				$UI.msg('alert', '�������ӡδ��˵��˻���!');
				return false;
			}
			PrintIngDretHVCol($('#RowId').val());
		}
	});
	
	var Select = function(RetId) {
		$UI.clearBlock('#MainConditions');
		$UI.clear(RetGrid);
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRet',
			MethodName: 'Select',
			RetId: RetId
		},
		function(jsonData) {
			$UI.fillBlock('#MainConditions', jsonData);
			setEditDisable();
			// ��ť����
			if ($HUI.checkbox('#Completed').getValue()) {
				ChangeButtonEnable({ '#DelBT': false, '#PrintBT': true, '#ComBT': false, '#CanComBT': true, '#SaveBT': false });
			} else {
				ChangeButtonEnable({ '#DelBT': true, '#PrintBT': true, '#ComBT': true, '#CanComBT': false, '#SaveBT': true });
			}
		});
		RetGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINGrtItm',
			QueryName: 'DHCINGdRetItm',
			query2JsonStrict: 1,
			RetId: RetId,
			rows: 99999
		});
	};

	var RetCm = [[
		{	field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 100,
			saveCol: true,
			hidden: true
		}, {
			title: 'Ingri',
			field: 'Ingri',
			width: 100,
			saveCol: true,
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
			saveCol: true,
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'Code',
			width: 100
		}, {
			title: '��������',
			field: 'Description',
			width: 150
		}, {
			title: '��ֵ����',
			field: 'HvBarCode',
			width: 150,
			jump: false,
			saveCol: true,
			editor: {
				type: 'validatebox',
				options: {
					required: true,
					tipPosition: 'bottom'
				}
			}
		}, {
			title: '���',
			field: 'Spec',
			width: 100
		}, {
			title: '��������',
			field: 'Manf',
			width: 150
		}, {
			title: '����',
			field: 'BatNo',
			width: 100
		}, {
			title: 'Ч��',
			field: 'ExpDate',
			width: 120
		}, {
			title: '���ο��',
			field: 'StkQty',
			width: 80,
			align: 'right'
		}, {
			title: '�˻�����',
			field: 'Qty',
			width: 80,
			align: 'right',
			saveCol: true,
			editor: {
				type: 'numberbox',
				options: {
					required: true,
					tipPosition: 'bottom',
					min: 0,
					precision: 0
				}
			}
		}, {
			title: '��λ',
			field: 'Uom',
			width: 80,
			saveCol: true,
			formatter: CommonFormatter(UomCombox, 'Uom', 'UomDesc'),
			editor: UomCombox
		}, {
			title: '�˻�ԭ��',
			field: 'ReasonId',
			width: 100,
			formatter: CommonFormatter(ReasonCombox, 'ReasonId', 'Reason'),
			saveCol: true,
			editor: ReasonCombox
		}, {
			title: '�˻�����',
			field: 'Rp',
			width: 80,
			saveCol: true,
			align: 'right'
		}, {
			title: '���۽��',
			field: 'RpAmt',
			width: 80,
			align: 'right'
		}, {
			title: '��Ʊ����',
			field: 'InvCode',
			width: 100,
			align: 'left',
			saveCol: true,
			editor: {
				type: 'text'
			}
		}, {
			title: '��Ʊ��',
			field: 'InvNo',
			width: 100,
			align: 'left',
			saveCol: true,
			editor: {
				type: 'text'
			}
		}, {
			title: '��Ʊ����',
			field: 'InvDate',
			width: 120,
			align: 'left',
			saveCol: true,
			editor: {
				type: 'datebox'
			}
		}, {
			title: '��Ʊ���',
			field: 'InvAmt',
			width: 80,
			align: 'right',
			saveCol: true,
			editor: {
				type: 'numberbox',
				options: {
					precision: GetFmtNum('FmtRA')
				}
			}
		}, {
			title: '���۵���',
			field: 'Sp',
			width: 80,
			saveCol: true,
			align: 'right'
		}, {
			title: '�ۼ۽��',
			field: 'SpAmt',
			width: 80,
			align: 'right'
		}, {
			title: '������',
			field: 'SpecDesc',
			width: 100,
			align: 'left',
			sortable: true,
			saveCol: true,
			formatter: CommonFormatter(SpecDescbox, 'SpecDesc', 'SpecDesc'),
			hidden: CodeMainParamObj.UseSpecList == 'Y' ? false : true
			// editor:(CodeMainParamObj.UseSpecList=="Y"?false:true)?null:SpecDescbox
		}, {
			title: '��ֵ��־',
			field: 'HvFlag',
			width: 80,
			align: 'center',
			hidden: true,
			formatter: BoolFormatter
		}, {
			title: '���е���',
			field: 'SxNo',
			width: 200,
			align: 'left',
			saveCol: true,
			editor: {
				type: 'text'
			}
		}, {
			title: '��������',
			field: 'OriginalStatus',
			width: 80,
			formatter: OriginalStatusFormatter
		}, {
			title: '��ע',
			field: 'Remark',
			width: 200,
			align: 'left',
			saveCol: true,
			editor: {
				type: 'text'
			}
		}, {
			title: '����ҽ������',
			field: 'MatInsuCode',
			width: 160
		}, {
			title: '����ҽ������',
			field: 'MatInsuDesc',
			width: 160
		}
	]];
	
	var RetGrid = $UI.datagrid('#RetGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGrtItm',
			QueryName: 'DHCINGdRetItm',
			query2JsonStrict: 1,
			rows: 99999
		},
		deleteRowParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGrtItm',
			MethodName: 'Delete'
		},
		columns: RetCm,
		checkField: 'Ingri',
		singleSelect: false,
		showBar: true,
		remoteSort: false,
		showAddDelItems: true,
		pagination: false,
		onClickCell: function(index, field, value) {
			if ($HUI.checkbox('#Completed').getValue()) {
				return false;
			}
			var Row = RetGrid.getRows()[index];
			if ((!isEmpty(Row.Inclb) && (field == 'Qty') && (Row.OriginalStatus != 'NotUnique'))) {
				return false;
			}
			RetGrid.commonClickCell(index, field, value);
		},
		onBeginEdit: function(index, row) {
			$('#RetGrid').datagrid('beginEdit', index);
			var Editors = $('#RetGrid').datagrid('getEditors', index);
			for (var i = 0; i < Editors.length; i++) {
				var Editor = Editors[i];
				if (Editor.field == 'HvBarCode') {
					$(Editor.target).bind('keydown', function(event) {
						if (event.keyCode == 13) {
							var BarCode = $(this).val();
							var Find = RetGrid.find('HvBarCode', BarCode);
							if (Find >= 0 && Find != index) {
								$UI.msg('alert', '���벻���ظ�¼��!');
								$(this).val('');
								$(this).focus();
								RetGrid.stopJump();
								return false;
							}
							if (isEmpty(BarCode)) {
								$(this).focus();
								RetGrid.stopJump();
								return;
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
								RetGrid.stopJump();
								return;
							}
							var OriginalStatus = BarCodeData.OriginalStatus;
							if (BarCodeData.Status != 'Enable') {
								$UI.msg('alert', '�ø�ֵ���봦�ڲ�����״̬,�����Ƶ�!');
								$(this).val('');
								$(this).focus();
								RetGrid.stopJump();
								return;
							} else if (BarCodeData.Ingri == '') {
								$UI.msg('alert', '��������δ�������,�����˻�!');
								$(this).val('');
								$(this).focus();
								RetGrid.stopJump();
								return;
							} else if (BarCodeData.IsAudit != 'Y' && OriginalStatus != 'NotUnique') {
								$UI.msg('alert', '�ø�ֵ������δ��˵�' + BarCodeData.OperNo + ',���ʵ!');
								$(this).val('');
								$(this).focus();
								RetGrid.stopJump();
								return;
							} else if (BarCodeData.Type == 'T' && OriginalStatus != 'NotUnique') {
								$UI.msg('alert', '�ø�ֵ�����Ѿ�����,�����˻�!');
								$(this).val('');
								$(this).focus();
								RetGrid.stopJump();
								return;
							}
							// ��ӹ�Ӧ���ж�
							var VendorId = BarCodeData['VendorId'];
							var TmpVendorId = $HUI.combobox('#Vendor').getValue();
							if (TmpVendorId == '') {
								$HUI.combobox('#Vendor').setValue(VendorId);
								TmpVendorId = VendorId;
							}
							
							if (VendorId != TmpVendorId) {
								$UI.msg('alert', '����' + BarCode + '�Ĺ�Ӧ���뵱ǰѡ��Ӧ�̲�һ��!');
								return false;
							}
							var Loc = $HUI.combobox('#RetLoc').getValue();
							var NoZeroFlag = 'Y';
							var Inci = BarCodeData.Inci;
							var Ingri = BarCodeData.Ingri;
							var Inclb = BarCodeData.Inclb;
							if (OriginalStatus == 'NotUnique') {
								Inclb = tkMakeServerCall('web.DHCSTMHUI.DHCItmTrack', 'GetInclbByBarCode', Loc, BarCode);		// ��ȡ��ȷ��inclb
								Ingri = tkMakeServerCall('web.DHCSTMHUI.DHCItmTrack', 'GetIngriByBarCode', Loc, BarCode, Inclb);	// ��ȡ��ȷ��Ingri
							}
							var Params = JSON.stringify(addSessionParams({ Loc: Loc, Vendor: TmpVendorId, NoZeroFlag: NoZeroFlag, Inci: Inci, Ingri: Ingri, Inclb: Inclb }));
							var ItmData = $.cm({
								ClassName: 'web.DHCSTMHUI.DHCINGdRet',
								QueryName: 'GdRecItmToRet',
								query2JsonStrict: 1,
								Params: Params
							}, false);
							if (ItmData.rows.length == 0) {
								$UI.msg('alert', BarCode + 'û����Ӧ����¼,�����Ƶ�!');
								$(this).val('');
								$(this).focus();
								RetGrid.stopJump();
								return false;
							}
							var LastReasonId, LastReasonDesc = '';
							if ((index > 0) && (IngrtParamObj['DefaRetReason'] == 'Y')) {
								var LastRowIndex = index - 1;
								var LastRow = RetGrid.getRows()[LastRowIndex];
								LastReasonId = LastRow.ReasonId;
								LastReasonDesc = LastRow.Reason;
							}
							$(this).val(BarCode).validatebox('validate');
							var Data = ItmData.rows[0];
							RetGrid.updateRow({
								index: index,
								row: {
									Inci: BarCodeData.Inci,
									Code: BarCodeData.Code,
									Description: BarCodeData.Description,
									Ingri: BarCodeData.Ingri,
									Inclb: BarCodeData.Inclb,
									Spec: Data.Spec,
									Manf: Data.ManfName,
									BatNo: Data.BatNo,
									ExpDate: Data.ExpDate,
									StkQty: Data.StkQty,
									OriginalStatus: OriginalStatus,
									Qty: 1,
									Uom: Data.Uom,
									UomDesc: Data.UomDesc,
									Rp: Data.Rp,
									RpAmt: Data.Rp,
									Sp: Data.Sp,
									SpAmt: Data.Sp,
									HvFlag: Data.HvFlag,
									HvBarCode: BarCode,
									ReasonId: LastReasonId,
									Reason: LastReasonDesc,
									MatInsuCode: Data.MatInsuCode,
									MatInsuDesc: Data.MatInsuDesc
								}
							});
							$('#RetGrid').datagrid('refreshRow', index);
							RetGrid.commonAddRow();
						}
					});
				}
				if ((Editor.field == 'InvCode') || (Editor.field == 'InvNo')) {
					$(Editor.target).bind('keydown', function(event) {
						if (event.keyCode == 13) {
							var InvInfo = $(this).val();
							SetInvInfo(InvInfo);
						}
					});
				}
			}
		},
		onEndEdit: function(index, row, changes) {
			var Editors = $(this).datagrid('getEditors', index);
			for (var i = 0; i < Editors.length; i++) {
				var Editor = Editors[i];
				if (Editor.field == 'Qty') {
					var RepLev = RepLev;
					var Qty = Number(row.Qty);
					var StkQty = Number(row.StkQty);
					
					if (Qty > StkQty) {
						$UI.msg('alert', '�˻��������ܴ��ڿ������!');
						RetGrid.checked = false;
						return false;
					} else {
						row.RpAmt = accMul(Qty, row.Rp);
						row.SpAmt = accMul(Qty, row.Sp);
						row.InvAmt = accMul(Qty, row.Rp);
					}
				}
			}
		},
		onBeforeEdit: function(index, row) {
			if ($HUI.checkbox('#Completed').getValue()) {
				$UI.msg('alert', '�Ѿ���ɣ����ܱ༭!');
				return false;
			}
		},
		beforeDelFn: function() {
			if ($HUI.checkbox('#Completed').getValue()) {
				$UI.msg('alert', '�Ѿ���ɣ�����ɾ��ѡ����!');
				return false;
			}
		},
		beforeAddFn: function() {
			if ($HUI.checkbox('#Completed').getValue()) {
				$UI.msg('alert', '�Ѿ���ɣ���������һ��!');
				return false;
			}
			if (isEmpty($HUI.combobox('#RetLoc').getValue())) {
				$UI.msg('alert', '�˻����Ҳ���Ϊ��!');
				return false;
			}
			/*
			if(isEmpty($HUI.combobox("#Vendor").getValue())){
				$UI.msg("alert","��Ӧ�̲���Ϊ��!");
				return false;
			}*/
			$HUI.combobox('#RetLoc').disable();
			$HUI.combobox('#ScgStk').disable();
			$HUI.combobox('#Vendor').disable();
		}
	});
	function SetInvInfo(InvInfo) {
		var InvObj = GetInvInfo(InvInfo);
		if (InvObj === false) {
			$UI.msg('alert', '��¼����ȷ�ķ�Ʊ��Ϣ!');
			return;
		} else if (!isEmpty(InvObj)) {
			var InvCode = InvObj.InvCode;
			var InvNo = InvObj.InvNo;
			var InvAmt = InvObj.InvAmt;
			var InvDate = InvObj.InvDate;
			RetGrid.updateRow({
				index: RetGrid.editIndex,
				row: {
					InvCode: InvCode,
					InvNo: InvNo,
					// InvMoney:InvAmt,
					InvDate: InvDate
				}
			});
			$('#RetGrid').datagrid('refreshRow', RetGrid.editIndex);
		}
	}
	
	ClearMain();
	if (!isEmpty(gIngrtId)) {
		Select(gIngrtId);
	}
};
$(init);