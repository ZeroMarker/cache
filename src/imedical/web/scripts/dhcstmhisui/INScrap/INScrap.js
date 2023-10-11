// ����:��汨���Ƶ�
// �������ֵ��object
var InScrapParamObj = GetAppPropValue('DHCSTINSCRAPM');
var CodeMainParamObj = GetAppPropValue('DHCSTDRUGMAINTAINM');
var init = function() {
	var ClearMain = function() {
		$UI.clearBlock('#MainConditions');
		$UI.clear(INScrapMGrid);
		setEditEnable();
		SetDefaValues();
		ChangeButtonEnable({ '#ComBT': false, '#CanComBT': false, '#DelBT': false, '#PrintBT': false, '#SaveBT': true });
	};
	function setEditDisable() {
		$HUI.combobox('#SupLoc').disable();
		$HUI.combotree('#ScgStk').disable();
		var MainParams = $UI.loopBlock('#MainConditions');
		if (MainParams['Complate'] == 'Y') {
			$HUI.combobox('#INScrapReason').disable();
			$('#Remark').attr('readonly', true);
		} else {
			$HUI.combobox('#INScrapReason').enable();
			$('#Remark').attr('readonly', false);
		}
	}
	// /�ſ��ɱ༭�����disabled����
	function setEditEnable() {
		$HUI.combotree('#ScgStk').enable();
		$HUI.combobox('#SupLoc').enable();
		$HUI.combobox('#INScrapReason').enable();
	}
	// Grid �� comboxData
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
				var rows = INScrapMGrid.getRows();
				var row = rows[INScrapMGrid.editIndex];
				if (!isEmpty(row) && !isEmpty(row['Inclb'])) {
					var Inci = row['Inclb'].split('||')[0];
					param.Inci = Inci;
				}
			},
			onSelect: function(record) {
				var rows = INScrapMGrid.getRows();
				var row = rows[INScrapMGrid.editIndex];
				row.UomDesc = record.Description;
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
				var Pp = row.Pp;
				var PpAmt = row.PpAmt;
				var confac = row.ConFac;
				if (NewUomid == BUomId) { // ��ⵥλת��Ϊ������λ
					row.Rp = Number(Rp).div(confac);
					row.Sp = Number(Sp).div(confac);
					row.Pp = Number(Pp).div(confac);
					if (InclbQty != '') {
						row.InclbQty = Number(InclbQty).mul(confac);
					}
					if (Qty != '') {
						row.Qty = Number(Qty).mul(confac);
					}
					if (AvaQty != '') {
						row.AvaQty = Number(AvaQty).mul(confac);
					}
				} else { // ������λת��Ϊ��ⵥλ
					row.Rp = Number(Rp).mul(confac);
					row.Sp = Number(Sp).mul(confac);
					if (InclbQty != '') {
						row.InclbQty = Number(InclbQty).div(confac);
					}
					if (Qty != '') {
						row.Qty = Number(Qty).div(confac);
					}
					if (AvaQty != '') {
						row.AvaQty = Number(AvaQty).div(confac);
					}
				}
				row.UomId = NewUomid;
				setTimeout(function() {
					INScrapMGrid.refreshRow();
				}, 0);
			},
			onShowPanel: function() {
				$(this).combobox('reload');
			}
		}
	};
	var SupLocParams = JSON.stringify(addSessionParams({
		Type: 'Login'
	}));
	if (InScrapParamObj.AllowSrapAllLoc == 'Y') {
		SupLocParams = JSON.stringify(addSessionParams({
			Type: 'All'
		}));
	}
	var SupLocBox = $HUI.combobox('#SupLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + SupLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var LocId = record['RowId'];
			$HUI.combotree('#ScgStk').setFilterByLoc(LocId);
		}
	});
	var INScrapReasonParams = JSON.stringify(addSessionParams({
		Type: 'M'
	}));
	var INScrapReasonBox = $HUI.combobox('#INScrapReason', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetReasonForScrap&ResultSetType=array&Params=' + INScrapReasonParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			var HvFlag = 'N';
			FindWin(Select, HvFlag);
		}
	});
	
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			Save();
		}
	});

	var Save = function() {
		var MainObj = $UI.loopBlock('#MainConditions');
		var IsChange = $UI.isChangeBlock('#MainConditions');
		var MainInfo = JSON.stringify(MainObj);
		var ListData = INScrapMGrid.getChangesData('Inclb');
		if (ListData === false) {
			return;
		}
		if (isEmpty(ListData) && IsChange == false) {
			$UI.msg('alert', 'û����Ҫ�������ϸ!');
			return false;
		}
		var InStkTkParamObj = GetAppPropValue('DHCSTINSTKTKM');
		if (InStkTkParamObj.AllowBusiness != 'Y') {
			var IfExistInStkTk = tkMakeServerCall('web.DHCSTMHUI.INStkTk', 'CheckInStkTkByLoc', MainObj['SupLoc']);
			if (IfExistInStkTk == 'Y') {
				$UI.msg('alert', '���Ҵ���δ��ɵ��̵㵥��������!');
				return false;
			}
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINScrap',
			MethodName: 'Save',
			MainInfo: MainInfo,
			ListData: JSON.stringify(ListData)
		}, function(jsonData) {
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				Select(jsonData.rowid);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	};

	$UI.linkbutton('#DelBT', {
		onClick: function() {
			var Inscrap = $('#RowId').val();
			if (isEmpty(Inscrap)) {
				return;
			}
			function del() {
				$.cm({
					ClassName: 'web.DHCSTMHUI.DHCINScrap',
					MethodName: 'Delete',
					Inscrap: Inscrap
				}, function(jsonData) {
					if (jsonData.success === 0) {
						$UI.msg('success', jsonData.msg);
						ClearMain();
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
			var Inscrap = MainObj.RowId;
			if (isEmpty(Inscrap)) {
				return;
			}
			var Main = JSON.stringify(MainObj);
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINScrap',
				MethodName: 'SetComplete',
				Params: Main
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
			var Inscrap = $('#RowId').val();
			if (isEmpty(Inscrap)) {
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINScrap',
				MethodName: 'CancelComplete',
				Inscrap: Inscrap
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
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			ClearMain();
		}
	});
	$UI.linkbutton('#PrintBT', {
		onClick: function() {
			if (isEmpty($('#RowId').val())) {
				$UI.msg('alert', 'û����Ҫ��ӡ������!');
				return;
			}
			PrintINScrap($('#RowId').val());
		}
	});
	var Select = function(Inscrap) {
		$UI.clearBlock('#MainConditions');
		$UI.clear(INScrapMGrid);
		
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINScrap',
			MethodName: 'Select',
			Inscrap: Inscrap
		}, function(jsonData) {
			$UI.fillBlock('#MainConditions', jsonData);
			var Complate = jsonData['Complate'];
			if (Complate == 'Y') {
				var BtnEnaleObj = { '#ComBT': false, '#CanComBT': true, '#DelBT': false, '#PrintBT': true, '#SaveBT': false };
			} else {
				var BtnEnaleObj = { '#ComBT': true, '#CanComBT': false, '#DelBT': true, '#PrintBT': true, '#SaveBT': true };
			}
			ChangeButtonEnable(BtnEnaleObj);
			setEditDisable();
		});
		INScrapMGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINScrapItm',
			QueryName: 'DHCINSpD',
			query2JsonStrict: 1,
			Inscrap: Inscrap,
			rows: 99999,
			totalFooter: '"InciCode":"�ϼ�"',
			totalFields: 'RpAmt,SpAmt'
		});
	};
	var INScrapMGridCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			saveCol: true,
			hidden: true
		}, {
			title: 'Inclb',
			field: 'Inclb',
			width: 80,
			saveCol: true,
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'InciCode',
			width: 100
		}, {
			title: '��������',
			field: 'InciDesc',
			width: 200,
			editor: 'text',
			jump: false
		}, {
			title: '���',
			field: 'Spec',
			width: 100
		}, {
			title: '������',
			field: 'SpecDesc',
			width: 100,
			hidden: CodeMainParamObj.UseSpecList == 'Y' ? false : true
		}, {
			title: '����~Ч��',
			field: 'BatExp',
			width: 150
		}, {
			title: '��������',
			field: 'Manf',
			width: 150
		}, {
			title: '���ο��',
			field: 'InclbQty',
			width: 100,
			align: 'right'
		}, {
			title: '���ο��ÿ��',
			field: 'AvaQty',
			width: 100,
			saveCol: true,
			align: 'right'
		}, {
			title: '��������',
			field: 'Qty',
			width: 100,
			align: 'right',
			necessary: true,
			saveCol: true,
			editor: {
				type: 'numberbox',
				options: {
					required: true,
					tipPosition: 'bottom',
					precision: GetFmtNum('FmtQTY')
				}
			}
		}, {
			title: '��λ',
			field: 'UomId',
			width: 80,
			necessary: true,
			saveCol: true,
			formatter: CommonFormatter(UomCombox, 'UomId', 'UomDesc'),
			editor: UomCombox
		}, {
			title: '����',
			field: 'Rp',
			width: 80,
			saveCol: true,
			align: 'right'
		}, {
			title: '���۽��',
			field: 'RpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '�ۼ�',
			field: 'Sp',
			width: 80,
			saveCol: true,
			align: 'right'
		}, {
			title: '�ۼ۽��',
			field: 'SpAmt',
			width: 100,
			align: 'right'
		}, {
			title: 'ConFac',
			field: 'ConFac',
			width: 100,
			hidden: true
		}, {
			title: 'BUomId',
			field: 'BUomId',
			width: 100,
			hidden: true
		}
	]];
	
	var INScrapMGrid = $UI.datagrid('#INScrapMGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINScrapItm',
			QueryName: 'DHCINSpD',
			query2JsonStrict: 1,
			rows: 99999,
			totalFooter: '"InciCode":"�ϼ�"',
			totalFields: 'RpAmt,SpAmt'
		},
		deleteRowParams: {
			ClassName: 'web.DHCSTMHUI.DHCINScrapItm',
			MethodName: 'jsDelete'
		},
		columns: INScrapMGridCm,
		checkField: 'Inclb',
		showBar: true,
		showFooter: true,
		remoteSort: false,
		showAddDelItems: true,
		pagination: false,
		onClickRow: function(index, row) {
			INScrapMGrid.commonClickRow(index, row);
		},
		onBeforeEdit: function(index, row) {
			var MainConditions = $UI.loopBlock('#MainConditions');
			if (MainConditions['Complate'] == 'Y') {
				$UI.msg('alert', '���������,�������޸�!');
				return false;
			}
		},
		beforeAddFn: function() {
			var MainConditions = $UI.loopBlock('#MainConditions');
			if (MainConditions['Complate'] == 'Y') {
				$UI.msg('alert', '�Ѿ����,��������һ��!');
				return false;
			}
			if (isEmpty($HUI.combobox('#SupLoc').getValue())) {
				$UI.msg('alert', '�Ƶ����Ҳ���Ϊ��!');
				return false;
			}
			if (isEmpty($HUI.combotree('#ScgStk').getValue())) {
				$UI.msg('alert', '���鲻��Ϊ��!');
				return false;
			}
		},
		onEndEdit: function(index, row, changes) {
			var Editors = $(this).datagrid('getEditors', index);
			for (var i = 0; i < Editors.length; i++) {
				var Editor = Editors[i];
				if (Editor.field == 'Qty') {
					var Qty = row.Qty;
					var UomId = row.UomId;
					var ConFac = row.ConFac;
					var BUomId = row.BUomId;
					if (UomId == BUomId) {
						if (!CheckFmtQty(ConFac, 'BUom', Qty)) {
							INScrapMGrid.checked = false;
							return false;
						}
					} else {
						if (!CheckFmtQty(ConFac, 'PUom', Qty)) {
							INScrapMGrid.checked = false;
							return false;
						}
					}
				}
			}
			if (changes.hasOwnProperty('Qty')) {
				var Qty = Number(row.Qty);
				var AvaQty = Number(row.AvaQty);
				if (Qty > AvaQty) {
					$UI.msg('alert', '�����������ܴ��ڿ��ÿ��!');
					$(this).datagrid('updateRow', {
						index: index,
						row: {
							Qty: '',
							RpAmt: 0,
							SpAmt: 0
						}
					});
					INScrapMGrid.checked = false;
					return false;
				} else {
					row.RpAmt = accMul(Qty, row.Rp);
					row.SpAmt = accMul(Qty, row.Sp);
				}
			}
			INScrapMGrid.setFooterInfo();
		},
		onBeginEdit: function(index, row) {
			$('#INScrapMGrid').datagrid('beginEdit', index);
			var ed = $('#INScrapMGrid').datagrid('getEditors', index);
			for (var i = 0; i < ed.length; i++) {
				var e = ed[i];
				if (e.field == 'InciDesc') {
					$(e.target).bind('keydown', function(event) {
						if (event.keyCode == 13) {
							var Input = $(this).val();
							if (isEmpty(Input)) {
								return;
							}
							var Scg = $('#ScgStk').combotree('getValue');
							var LocDr = $('#SupLoc').combo('getValue');
							var HV = 'N';
							var ParamsObj = {
								StkGrpRowId: Scg,
								StkGrpType: 'M',
								Locdr: LocDr,
								NotUseFlag: 'N',
								QtyFlag: 'Y',
								HV: HV
							};
							IncItmBatWindow(Input, ParamsObj, ReturnInfoFn);
						}
					});
				}
			}
		}
	});
	function ReturnInfoFn(rows) {
		rows = [].concat(rows);
		if (rows == null || rows == '') {
			return;
		}
		$.each(rows, function(index, row) {
			var RowIndex = INScrapMGrid.editIndex;
			var Inclb = row['Inclb'];
			var FindIndex = INScrapMGrid.find('Inclb', Inclb);
			if (FindIndex >= 0 && FindIndex != RowIndex) {
				$UI.msg('alert', row.InciDesc + ':' + row['BatExp'] + ' �����Ѵ����ڵ�' + (FindIndex + 1) + '��!');
				return true;
			}
			INScrapMGrid.updateRow({
				index: RowIndex,
				row: {
					Inclb: row.Inclb,
					InciCode: row.InciCode,
					InciDesc: row.InciDesc,
					Spec: row.Spec,
					SpecDesc: row.SpecDesc,
					BatExp: row.BatExp,
					Manf: row.Manf,
					Qty: row.OperQty,
					UomId: row.PurUomId,
					UomDesc: row.PurUomDesc,
					ConFac: row.ConFac,
					BUomId: row.BUomId,
					Rp: row.Rp,
					Sp: row.Sp,
					RpAmt: accMul(row.OperQty, row.Rp),
					SpAmt: accMul(row.OperQty, row.Sp),
					InclbQty: row.InclbQty,
					AvaQty: row.AvaQty
				}
			});
			$('#INScrapMGrid').datagrid('refreshRow', RowIndex);
			if (index < rows.length) {
				INScrapMGrid.commonAddRow();
			}
		});
	}
	function SetDefaValues() {
		$('#ScgStk').combotree('options')['setDefaultFun']();
		$('#SupLoc').combobox('setValue', gLocId);
		$('#Date').dateboxq('setValue', DateFormatter(new Date()));
	}
	ClearMain();
};
$(init);