// 名称:库存报损制单(高值)
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
	// /放开可编辑组件的disabled属性
	function setEditEnable() {
		$HUI.combotree('#ScgStk').enable();
		$HUI.combobox('#SupLoc').enable();
		$HUI.combobox('#INScrapReason').enable();
	}
	
	var SupLocParams = JSON.stringify(addSessionParams({ Type: 'Login' }));
	if (InScrapParamObj.AllowSrapAllLoc == 'Y') {
		SupLocParams = JSON.stringify(addSessionParams({ Type: 'All' }));
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
	var INScrapReasonParams = JSON.stringify(addSessionParams({ Type: 'M' }));
	var INScrapReasonBox = $HUI.combobox('#INScrapReason', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetReasonForScrap&ResultSetType=array&Params=' + INScrapReasonParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			var HvFlag = 'Y';
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
			$UI.msg('alert', '没有需要保存的明细!');
			return false;
		}
		var InStkTkParamObj = GetAppPropValue('DHCSTINSTKTKM');
		if (InStkTkParamObj.AllowBusiness != 'Y') {
			var IfExistInStkTk = tkMakeServerCall('web.DHCSTMHUI.INStkTk', 'CheckInStkTkByLoc', MainObj['SupLoc']);
			if (IfExistInStkTk == 'Y') {
				$UI.msg('alert', '科室存在未完成的盘点单不允许保存!');
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
			$UI.confirm('确定要删除吗?', '', '', del);
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
			var ParamsObj = $UI.loopBlock('#MainConditions');
			var Inspi = ParamsObj['RowId'];
			if (isEmpty(Inspi)) {
				$UI.msg('alert', '没有需要打印的单据!');
				return;
			}
			if (InScrapParamObj.PrintNoComplete != 'Y' && ParamsObj['InsComp'] != 'Y') {
				$UI.msg('alert', '未完成不能打印!');
				return false;
			}
			PrintINScrap(Inspi);
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
			totalFooter: '"InciCode":"合计"',
			totalFields: 'RpAmt,SpAmt'
		});
	};
	var INScrapMGridCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 80,
			saveCol: true,
			hidden: true
		}, {
			title: 'Inclb',
			field: 'Inclb',
			width: 150,
			saveCol: true,
			hidden: true
		}, {
			title: 'dhcit',
			field: 'dhcit',
			width: 80,
			hidden: true
		}, {
			title: '物资代码',
			field: 'InciCode',
			width: 100
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width: 200
		}, {
			title: '规格',
			field: 'Spec',
			width: 100
		}, {
			title: '具体规格',
			field: 'SpecDesc',
			width: 100,
			hidden: CodeMainParamObj.UseSpecList == 'Y' ? false : true
		}, {
			title: '高值条码',
			field: 'HVBarCode',
			width: 150,
			saveCol: true,
			jump: false,
			editor: {
				type: 'validatebox',
				options: {
					required: true,
					tipPosition: 'bottom'
				}
			}
		}, {
			title: '批号~效期',
			field: 'BatExp',
			width: 150
		}, {
			title: '生产厂家',
			field: 'Manf',
			width: 200
		}, {
			title: '批次库存',
			field: 'InclbQty',
			width: 100,
			align: 'right'
		}, {
			title: '批次可用库存',
			field: 'AvaQty',
			saveCol: true,
			width: 100,
			align: 'right'
		}, {
			title: '报损数量',
			field: 'Qty',
			saveCol: true,
			width: 100,
			align: 'right',
			editor: {
				type: 'numberbox',
				options: {
					required: true,
					tipPosition: 'bottom',
					precision: 0
				}
			}
		}, {
			title: '单位RowId',
			field: 'UomId',
			width: 100,
			saveCol: true,
			hidden: true
		}, {
			title: '单位',
			field: 'UomDesc',
			width: 100
		}, {
			title: '进价',
			field: 'Rp',
			saveCol: true,
			width: 100
		}, {
			title: '进价金额',
			field: 'RpAmt',
			width: 100
		}, {
			title: '售价',
			field: 'Sp',
			saveCol: true,
			width: 100
		}, {
			title: '售价金额',
			field: 'SpAmt',
			width: 100
		}, {
			title: '条码类型',
			field: 'OriginalStatus',
			width: 80
		}
	]];
	var INScrapMGrid = $UI.datagrid('#INScrapMGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINScrapItm',
			QueryName: 'DHCINSpD',
			query2JsonStrict: 1,
			rows: 99999,
			totalFooter: '"InciCode":"合计"',
			totalFields: 'RpAmt,SpAmt'
		},
		deleteRowParams: {
			ClassName: 'web.DHCSTMHUI.DHCINScrapItm',
			MethodName: 'jsDelete'
		},
		columns: INScrapMGridCm,
		checkField: 'dhcit',
		showBar: true,
		showFooter: true,
		remoteSort: false,
		showAddDelItems: true,
		pagination: false,
		beforeAddFn: function() {
			var MainConditions = $UI.loopBlock('#MainConditions');
			if (MainConditions['Complate'] == 'Y') {
				$UI.msg('alert', '已经完成，不能增加一行!');
				return false;
			}
			if (isEmpty($HUI.combobox('#SupLoc').getValue())) {
				$UI.msg('alert', '制单科室不能为空!');
				return false;
			}
			if (isEmpty($HUI.combotree('#ScgStk').getValue())) {
				$UI.msg('alert', '类组不能为空!');
				return false;
			}
			return true;
		},
		afterAddFn: function() {
			var BtnEnaleObj = { '#ComBT': true, '#CanComBT': false,
				'#DelBT': false, '#PrintBT': true };
			ChangeButtonEnable(BtnEnaleObj);
		},
		onClickCell: function(index, field, value) {
			var Row = INScrapMGrid.getRows()[index];
			if ((!isEmpty(Row.Inclb) && (field == 'Qty') && (Row.OriginalStatus != 'NotUnique'))) {
				return false;
			}
			INScrapMGrid.commonClickCell(index, field);
		},
		onBeforeCellEdit: function(index, field) {
			var InsComp = $('#InsComp').val();
			if (InsComp == 'Y') {
				return false;
			}
			var RowData = $(this).datagrid('getRows')[index];
			if (field == 'HVBarCode' && !isEmpty(RowData['RowId'])) {
				return false;
			}
			return true;
		},
		onBeginEdit: function(index, row) {
			$('#INScrapMGrid').datagrid('beginEdit', index);
			var ed = $('#INScrapMGrid').datagrid('getEditors', index);
			for (var i = 0; i < ed.length; i++) {
				var e = ed[i];
				if (e.field == 'HVBarCode') {
					$(e.target).bind('keydown', function(event) {
						if (event.keyCode == 13) {
							var BarCode = $(this).val();
							if (isEmpty(BarCode)) {
								INScrapMGrid.stopJump();
								return false;
							}
							var FindIndex = INScrapMGrid.find('HVBarCode', BarCode);
							if (FindIndex >= 0 && FindIndex != index) {
								$UI.msg('alert', '条码不可重复录入!');
								$(this).val('');
								$(this).focus();
								INScrapMGrid.stopJump();
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
								INScrapMGrid.stopJump();
								return;
							}
							var ScgStk = BarCodeData['ScgStk'];
							var ScgStkDesc = BarCodeData['ScgStkDesc'];
							var Inclb = BarCodeData['Inclb'];
							var IsAudit = BarCodeData['IsAudit'];
							var Type = BarCodeData['Type'];
							var Status = BarCodeData['Status'];
							var RecallFlag = BarCodeData['RecallFlag'];
							var Inci = BarCodeData['Inci'];
							var dhcit = BarCodeData['dhcit'];
							var OriginalStatus = BarCodeData['OriginalStatus'];
							var InsScgStk = $('#ScgStk').combotree('getValue');
							if (OriginalStatus == 'NotUnique') {
								var LocId = $('#SupLoc').combobox('getValue');
								Inclb = tkMakeServerCall('web.DHCSTMHUI.DHCItmTrack', 'GetInclbByBarCode', LocId, BarCode); // 获取正确的inclb
							}
							if (!CheckScgRelation(InsScgStk, ScgStk)) {
								$UI.msg('alert', '条码' + BarCode + '属于' + ScgStkDesc + '类组,与当前不符!');
								$(this).val('');
								$(this).focus();
								INScrapMGrid.stopJump();
								return;
							} else if (Inclb == '') {
								$UI.msg('alert', '该高值材料没有相应库存记录,不能制单!');
								$(this).val('');
								$(this).focus();
								INScrapMGrid.stopJump();
								return;
							} else if (IsAudit != 'Y' && OriginalStatus != 'NotUnique') {
								$UI.msg('alert', '该高值材料有未审核的' + lastDetailOperNo + ',请核实!');
								$(this).val('');
								$(this).focus();
								INScrapMGrid.stopJump();
								return;
							} else if (Type == 'T' && OriginalStatus != 'NotUnique') {
								$UI.msg('alert', '该高值材料已经出库,不可制单!');
								$(this).val('');
								$(this).focus();
								INScrapMGrid.stopJump();
								return;
							} else if (Status != 'Enable') {
								$UI.msg('alert', '该高值条码处于不可用状态,不可制单!');
								$(this).val('');
								$(this).focus();
								INScrapMGrid.stopJump();
								return;
							} else if (RecallFlag == 'Y') {
								$UI.msg('alert', '该高值条码处于锁定状态,不可制单!');
								$(this).val('');
								$(this).focus();
								INScrapMGrid.stopJump();
								return;
							}
							var SupLocId = $('#SupLoc').combobox('getValue');
							var ParamsObj = { InciDr: Inci, ProLocId: SupLocId, QtyFlag: 1, Inclb: Inclb };
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
								INScrapMGrid.stopJump();
								return;
							}
							$(this).val(BarCode).validatebox('validate');
							var InclbInfo = $.extend(InclbData.rows[0], { InciDr: Inci, dhcit: dhcit, HVBarCode: BarCode, OriginalStatus: OriginalStatus });
							ReturnInfoFn(index, InclbInfo);
						}
					});
				}
			}
		}
	});
	function ReturnInfoFn(RowIndex, row) {
		if (row.AvaQty < 1) {
			$UI.msg('alert', '可用库存不足');
			return;
		}
		INScrapMGrid.updateRow({
			index: RowIndex,
			row: {
				dhcit: row.dhcit,
				InciCode: row.InciCode,
				InciDesc: row.InciDesc,
				HVBarCode: row.HVBarCode,
				OriginalStatus: row.OriginalStatus,
				Spec: row.Spec,
				SpecDesc: row.SpecDesc,
				Inclb: row.Inclb,
				BatExp: row.BatExp,
				UomId: row.BUomId,
				UomDesc: row.BUomDesc,
				Rp: row.Rp,
				Sp: row.Sp,
				RpAmt: row.Rp,
				SpAmt: row.Sp,
				InclbDirtyQty: row.DirtyQty,
				InclbQty: row.InclbQty,
				AvaQty: row.AvaQty,
				Qty: 1
			}
		});
		$('#INScrapMGrid').datagrid('refreshRow', RowIndex);
		INScrapMGrid.commonAddRow();
	}
	
	function SetDefaValues() {
		$('#ScgStk').combotree('options')['setDefaultFun']();
		$('#SupLoc').combobox('setValue', gLocId);
		$('#Date').dateboxq('setValue', DateFormatter(new Date()));
	}
	ClearMain();
};
$(init);