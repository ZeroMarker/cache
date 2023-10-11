﻿var init = function() {
	$UI.linkbutton('#SearchBT', {
		onClick: function() {
			var HvFlag = 'Y';
			FindWin(Select, '', HvFlag);
		}
	});
	
	function Select(RowId) {
		$UI.clearBlock('#Conditions');
		$UI.clear(DetailGrid);
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			MethodName: 'Select',
			Init: RowId
		}, function(jsonData) {
			$UI.fillBlock('#Conditions', jsonData);
			$('#InitFrLoc').combobox('setValue', jsonData.InitFrLoc.RowId);
			SetEditDisable();
			var InitComp = jsonData['InitComp'];
			var InitState = jsonData['InitState'];
			if (InitComp == 'Y') {
				if (InitState == '21') {
					var BtnEnaleObj = { '#SaveBT': false, '#DeleteBT': false, '#CompleteBT': false, '#CancelCompBT': false };
				} else if (InitState == '31') {
					var BtnEnaleObj = { '#SaveBT': false, '#DeleteBT': false, '#CompleteBT': false, '#CancelCompBT': false };
				} else {
					var BtnEnaleObj = { '#SaveBT': false, '#DeleteBT': false, '#CompleteBT': false, '#CancelCompBT': true };
				}
			} else {
				var BtnEnaleObj = { '#SaveBT': true, '#DeleteBT': true, '#CompleteBT': true, '#CancelCompBT': false };
			}
			ChangeButtonEnable(BtnEnaleObj);
		});
		
		var ParamsObj = { Init: RowId };
		var Params = JSON.stringify(ParamsObj);
		DetailGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
			QueryName: 'DHCINIsTrfD',
			query2JsonStrict: 1,
			Params: Params,
			rows: 99999,
			totalFooter: '"InciCode":"合计"',
			totalFields: 'RpAmt,SpAmt'
		});
	}
	
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			var MainObj = $UI.loopBlock('#Conditions');
			if (MainObj['InitComp'] == 'Y') {
				$UI.msg('alert', '该单据已经完成,不可重复保存!');
				return;
			}
			if (isEmpty(MainObj['InitFrLoc'])) {
				$UI.msg('alert', '出库科室不可为空!');
				return;
			}
			if (isEmpty(MainObj['InitToLoc'])) {
				$UI.msg('alert', '接收科室不可为空!');
				return;
			}
			MainObj['InitState'] = '10';
			var Main = JSON.stringify(MainObj);
			var Detail = DetailGrid.getChangesData('Inclb');
			// 判断
			var ifChangeMain = $UI.isChangeBlock('#Conditions');
			if (Detail === false) {	// 未完成编辑或明细为空
				return;
			}
			if (!ifChangeMain && (isEmpty(Detail))) {	// 主单和明细不变
				$UI.msg('alert', '没有需要保存的信息!');
				return;
			}
			var InStkTkParamObj = GetAppPropValue('DHCSTINSTKTKM');
			if (InStkTkParamObj.AllowBusiness != 'Y') {
				var IfFrLocExistInStkTk = tkMakeServerCall('web.DHCSTMHUI.INStkTk', 'CheckInStkTkByLoc', MainObj['InitFrLoc']);
				if (IfFrLocExistInStkTk == 'Y') {
					$UI.msg('alert', '退库科室存在未完成的盘点单不允许保存!');
					return false;
				}
				var IfToLocExistInStkTk = tkMakeServerCall('web.DHCSTMHUI.INStkTk', 'CheckInStkTkByLoc', MainObj['InitToLoc']);
				if (IfToLocExistInStkTk == 'Y') {
					$UI.msg('alert', '库房存在未完成的盘点单不允许保存!');
					return false;
				}
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
				MethodName: 'jsSave',
				Main: Main,
				Detail: JSON.stringify(Detail)
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					var InitId = jsonData.rowid;
					Select(InitId);
					if (InitParamObj['AutoPrintAfterSave'] == 'Y') {
						PrintInIsTrfReturn(InitId, 'Y');
					}
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#CompleteBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#Conditions');
			var InitId = ParamsObj['RowId'];
			if (isEmpty(InitId)) {
				return;
			}
			var InitComp = ParamsObj['InitComp'];
			if (InitComp == 'Y') {
				$UI.msg('alert', '该单据已完成,不可重复操作!');
				return;
			}
			var Params = JSON.stringify(ParamsObj);
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
				MethodName: 'jsSetCompleted',
				Params: Params
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					var InitId = jsonData.rowid;
					// Select(InitId);
					$('#InitComp').checkbox('setValue', true);
					var BtnEnaleObj = { '#SaveBT': false, '#DeleteBT': false, '#CompleteBT': false, '#CancelCompBT': true };
					ChangeButtonEnable(BtnEnaleObj);
					// 完成后自动打印 或 完成后自动出库审核，出库审核后自动打印
					if ((InitParamObj.AutoPrintAfterComp == 'Y') || (InitParamObj.AutoAckOutAfterCompleted == 'Y' && InitParamObj.AutoPrintAfterAckOut == 'Y')) {
						PrintInIsTrfReturn(InitId, 'Y');
					}
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#CancelCompBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#Conditions');
			var InitId = ParamsObj['RowId'];
			if (isEmpty(InitId)) {
				return;
			}
			var InitComp = ParamsObj['InitComp'];
			if (InitComp != 'Y') {
				$UI.msg('alert', '该单据不是完成状态,不可操作!');
				return;
			}
			var Params = JSON.stringify(ParamsObj);
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
				MethodName: 'jsCancelComplete',
				Params: Params
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					var InitId = jsonData.rowid;
					// Select(InitId);
					$('#InitComp').checkbox('setValue', false);
					var BtnEnaleObj = { '#SaveBT': true, '#DeleteBT': true, '#CompleteBT': true, '#CancelCompBT': false };
					ChangeButtonEnable(BtnEnaleObj);
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#DeleteBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#Conditions');
			var InitId = ParamsObj['RowId'];
			if (isEmpty(InitId)) {
				return;
			}
			var InitComp = ParamsObj['InitComp'];
			if (InitComp == 'Y') {
				$UI.msg('alert', '该单据已经完成,不可删除!');
				return;
			}
			$UI.confirm('您将要删除单据,是否继续?', '', '', Delete);
		}
	});
	function Delete() {
		var ParamsObj = $UI.loopBlock('#Conditions');
		var Params = JSON.stringify(ParamsObj);
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			MethodName: 'jsDelete',
			Params: Params
		}, function(jsonData) {
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				$UI.clearBlock('#Conditions');
				$UI.clear(DetailGrid);
				SetDefaValues();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});
	function Clear() {
		$UI.clearBlock('#Conditions');
		$UI.clear(DetailGrid);
		SetDefaValues();
		var BtnEnaleObj = { '#SaveBT': false, '#DeleteBT': false, '#CompleteBT': false, '#CancelCompBT': false };
		ChangeButtonEnable(BtnEnaleObj);
		SetEditEnable();
	}
	function SetEditDisable() {
		$HUI.combobox('#InitFrLoc').disable();
		$HUI.combobox('#InitToLoc').disable();
		$HUI.combobox('#InitScg').disable();
	}
	function SetEditEnable() {
		$HUI.combobox('#InitFrLoc').enable();
		$HUI.combobox('#InitToLoc').enable();
		$HUI.combobox('#InitScg').enable();
	}
	
	$UI.linkbutton('#PrintBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#Conditions');
			var InitId = ParamsObj['RowId'];
			if (isEmpty(InitId)) {
				$UI.msg('alert', '请选择需要打印的单据!');
				return;
			}
			if (InitParamObj['PrintNoComplete'] == 'N' && $('#InitComp').checkbox('getValue') == false) {
				$UI.msg('warning', '不允许打印未完成的转移单!');
				return;
			}
			PrintInIsTrfReturn(InitId);
		}
	});
	$UI.linkbutton('#PrintHVColBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#Conditions');
			var InitId = ParamsObj['RowId'];
			if (isEmpty(InitId)) {
				$UI.msg('alert', '请选择需要打印的单据!');
				return;
			}
			if (InitParamObj['PrintNoComplete'] == 'N' && $('#InitComp').checkbox('getValue') == false) {
				$UI.msg('warning', '不允许打印未完成的转移单!');
				return;
			}
			PrintInIsTrfReturnHVCol(InitId);
		}
	});
	$UI.linkbutton('#SelOutBT', {
		onClick: function() {
			OutReq(Select);
		}
	});

	var InitFrLocParams, InitToLocParams;
	if (InitParamObj['DefaReturnLoc'] == '0') {		// 库房使用
		InitFrLocParams = JSON.stringify(addSessionParams({
			Type: 'Trans',
			Element: 'InitFrLoc'
		}));
		InitToLocParams = JSON.stringify(addSessionParams({
			Type: 'Login',
			Element: 'InitToLoc'
		}));
	} else {	// 临床使用
		InitFrLocParams = JSON.stringify(addSessionParams({
			Type: 'Login',
			Element: 'InitFrLoc',
			LoginLocType: 2
		}));
		InitToLocParams = JSON.stringify(addSessionParams({
			Type: 'Trans',
			Element: 'InitToLoc'
		}));
	}
	var InitToLoc = $HUI.combobox('#InitToLoc', {
		url: $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='
			+ InitToLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			if (InitParamObj['DefaReturnLoc'] == '0') {
				var ToLocId = record['RowId'];
				$('#InitFrLoc').combobox('clear');
				$('#InitFrLoc').combobox('reload', $URL
				+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='
				+ JSON.stringify(addSessionParams({
					Type: 'Trans',
					LocId: ToLocId,
					TransLocType: 'T'
				})));
			}
			var ToLoc = record['RowId'];
			var FrLoc = $('#InitFrLoc').combobox('getValue');
			$HUI.combotree('#InitScg').setFilterByLoc(FrLoc, ToLoc);
		}
	});
	var InitFrLoc = $HUI.combobox('#InitFrLoc', {
		url: $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params=' + InitFrLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			if (InitParamObj['DefaReturnLoc'] == '1') {
				var FrLocId = record['RowId'];
				$('#InitToLoc').combobox('clear');
				$('#InitToLoc').combobox('reload', $URL
				+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='
				+ JSON.stringify(addSessionParams({
					Type: 'Trans',
					LocId: FrLocId,
					TransLocType: 'F',
					Element: 'InitToLoc'
				})));
				var DefaInfo = tkMakeServerCall('web.DHCSTMHUI.DHCTransferLocConf', 'GetDefLoc', FrLocId, gGroupId);
				var ToLocId = DefaInfo.split('^')[0], ToLocDesc = DefaInfo.split('^')[1];
				if (ToLocId && ToLocDesc) {
					AddComboData($('#InitToLoc'), ToLocId, ToLocDesc);
					$('#InitToLoc').combobox('setValue', ToLocId);
				}
			}
			var FrLoc = record['RowId'];
			var ToLoc = $('#InitToLoc').combobox('getValue');
			$HUI.combotree('#InitScg').setFilterByLoc(FrLoc, ToLoc);
		}
	});
	
	var OperateType = $HUI.combobox('#OperateType', {
		url: $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOperateType&ResultSetType=Array&Params='
			+ JSON.stringify(addSessionParams({ Type: 'OM' })),
		valueField: 'RowId',
		textField: 'Description'
	});
	var VirtualFlag = $HUI.checkbox('#VirtualFlag', {
		onCheckChange: function(e, value) {
			if (value) {
				var InitToLoc = $('#InitToLoc').combobox('getValue');
				var Info = tkMakeServerCall('web.DHCSTMHUI.Common.UtilCommon', 'GetMainLoc', InitToLoc);
				var InfoArr = Info.split('^');
				var VituralLoc = InfoArr[0], VituralLocDesc = InfoArr[1];
				AddComboData($('#InitToLoc'), VituralLoc, VituralLocDesc);
				$('#InitToLoc').combobox('setValue', VituralLoc);
			} else {
				$('#InitToLoc').combobox('setValue', gLocId);
			}
		}
	});
	var DetailCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			saveCol: true,
			width: 80,
			hidden: true
		}, {
			title: 'InciId',
			field: 'InciId',
			width: 80,
			hidden: true
		}, {
			title: '物资代码',
			field: 'InciCode',
			width: 120
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width: 180
		}, {
			title: 'dhcit',
			field: 'dhcit',
			width: 80,
			hidden: true
		}, {
			title: '高值条码',
			field: 'HVBarCode',
			jump: false,
			saveCol: true,
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
			width: 80
		}, {
			title: 'Inclb',
			field: 'Inclb',
			saveCol: true,
			width: 80,
			hidden: true
		}, {
			title: '批号~效期',
			field: 'BatExp',
			width: 200
		}, {
			title: '生产厂家',
			field: 'ManfDesc',
			width: 160
		}, {
			title: '批次库存',
			field: 'InclbQty',
			align: 'right',
			width: 80
		}, {
			title: '出库数量',
			field: 'Qty',
			saveCol: true,
			align: 'right',
			width: 80,
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
			title: '单位Id',
			field: 'UomId',
			saveCol: true,
			width: 50,
			hidden: true
		}, {
			title: '单位',
			field: 'UomDesc',
			width: 50
		}, {
			title: '进价',
			field: 'Rp',
			align: 'right',
			width: 80
		}, {
			title: '售价',
			field: 'Sp',
			align: 'right',
			width: 80
		}, {
			title: '进价金额',
			field: 'RpAmt',
			align: 'right',
			width: 80
		}, {
			title: '售价金额',
			field: 'SpAmt',
			align: 'right',
			width: 80
		}, {
			title: '国家医保编码',
			field: 'MatInsuCode',
			width: 160
		}, {
			title: '国家医保名称',
			field: 'MatInsuDesc',
			width: 160
		}, {
			title: '灭菌批号',
			field: 'SterilizedBat',
			width: 160
		}, {
			title: '请求数量',
			field: 'ReqQty',
			align: 'right',
			width: 80
		}, {
			title: '请求方库存',
			field: 'ReqLocStkQty',
			align: 'right',
			width: 100
		}, {
			title: '占用数量',
			field: 'InclbDirtyQty',
			align: 'right',
			width: 100
		}, {
			title: '条码类型',
			field: 'OriginalStatus',
			width: 80,
			formatter: OriginalStatusFormatter
		}, {
			title: 'InitiDR',
			field: 'InitiDR',
			align: 'InitiDR',
			width: 100,
			hidden: true
		}, {
			title: '备注',
			field: 'Remark',
			saveCol: true,
			width: 100,
			editor: {
				type: 'text'
			}
		}
	]];
	
	var DetailGrid = $UI.datagrid('#DetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
			QueryName: 'DHCINIsTrfD',
			query2JsonStrict: 1,
			rows: 99999,
			totalFooter: '"InciCode":"合计"',
			totalFields: 'RpAmt,SpAmt'
		},
		deleteRowParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
			MethodName: 'jsDelete'
		},
		columns: DetailCm,
		checkField: 'dhcit',
		remoteSort: false,
		showBar: true,
		showFooter: true,
		showAddDelItems: true,
		pagination: false,
		beforeAddFn: function() {
			if ($HUI.checkbox('#InitComp').getValue()) {
				$UI.msg('alert', '单据已完成, 不可增加');
				return false;
			}
			if (isEmpty($HUI.combobox('#InitFrLoc').getValue())) {
				$UI.msg('alert', '退库科室不可为空!');
				return false;
			}
			var OperateType = $HUI.combobox('#OperateType').getValue();
			if (InitParamObj.OutTypeNotNull == 'Y' && isEmpty(OperateType)) {
				$UI.msg('alert', '请选择出库类型!');
				return false;
			}
			if (isEmpty($HUI.combotree('#InitScg').getValue())) {
				$UI.msg('alert', '类组不可为空!');
				return false;
			}
			return true;
		},
		afterAddFn: function() {
			SetEditDisable();
			var BtnEnaleObj = { '#SaveBT': true, '#DeleteBT': false, '#CompleteBT': true, '#CancelCompBT': false };
			ChangeButtonEnable(BtnEnaleObj);
		},
		onClickCell: function(index, field, value) {
			if ($HUI.checkbox('#InitComp').getValue()) {
				$UI.msg('alert', '单据已完成, 不可修改');
				return false;
			}
			var Row = DetailGrid.getRows()[index];
			if ((!isEmpty(Row.Inclb) && (field == 'Qty') && (Row.OriginalStatus != 'NotUnique'))) {
				return false;
			}
			DetailGrid.commonClickCell(index, field);
		},
		onBeginEdit: function(index, row) {
			// 增加完成情况字数输入限制
			$('#DetailGrid').datagrid('beginEdit', index);
			var ed = $('#DetailGrid').datagrid('getEditors', index);
			for (var i = 0; i < ed.length; i++) {
				var e = ed[i];
				if (e.field == 'HVBarCode') {
					$(e.target).bind('keydown', function(event) {
						if (event.keyCode == 13) {
							var BarCode = $(this).val();
							if (isEmpty(BarCode)) {
								DetailGrid.stopJump();
								return;
							}
							var FindIndex = DetailGrid.find('HVBarCode', BarCode);
							if (FindIndex >= 0 && FindIndex != index) {
								$UI.msg('alert', '条码不可重复录入!');
								$(this).val('');
								$(this).focus();
								DetailGrid.stopJump();
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
								DetailGrid.stopJump();
								return;
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
							var InitScg = $('#InitScg').combobox('getValue');
							if (OriginalStatus == 'NotUnique') {
								var LocId = $('#InitFrLoc').combobox('getValue');
								Inclb = tkMakeServerCall('web.DHCSTMHUI.DHCItmTrack', 'GetInclbByBarCode', LocId, BarCode); // 获取正确的inclb
							}
							if (!CheckScgRelation(InitScg, ScgStk)) {
								$UI.msg('alert', '条码' + BarCode + '属于' + ScgStkDesc + '类组,与当前不符!');
								$(this).val('');
								$(this).focus();
								DetailGrid.stopJump();
								return;
							} else if (Inclb == '') {
								$UI.msg('alert', BarCode + '没有相应库存记录,不能制单!');
								$(this).val('');
								$(this).focus();
								DetailGrid.stopJump();
								return;
							} else if (IsAudit != 'Y' && OriginalStatus != 'NotUnique') {
								$UI.msg('alert', BarCode + '有未审核的' + OperNo + ',请核实!');
								$(this).val('');
								$(this).focus();
								DetailGrid.stopJump();
								return;
							} else if (Type == 'T' && OriginalStatus != 'NotUnique') {
								$UI.msg('alert', BarCode + '已经出库,不可制单!');
								$(this).val('');
								$(this).focus();
								DetailGrid.stopJump();
								return;
							} else if (Status != 'Enable') {
								$UI.msg('alert', BarCode + '处于不可用状态,不可制单!');
								$(this).val('');
								$(this).focus();
								DetailGrid.stopJump();
								return;
							} else if (RecallFlag == 'Y') {
								$UI.msg('alert', BarCode + '处于锁定状态,不可制单!');
								$(this).val('');
								$(this).focus();
								DetailGrid.stopJump();
								return;
							}
							
							var ProLocId = $('#InitFrLoc').combobox('getValue');
							var ReqLocId = $('#InitToLoc').combobox('getValue');
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
								DetailGrid.stopJump();
								return;
							}
							$(this).val(BarCode).validatebox('validate');
							var InclbInfo = $.extend(InclbData.rows[0], { InciDr: Inci, dhcit: dhcit, HVBarCode: BarCode, OriginalStatus: OriginalStatus });
							//							row['HVBarCode'] = BarCode;
							//							row['dhcit'] = dhcit;
							ReturnInfoFunc(index, InclbInfo);
						}
					});
				}
			}
		}
	});
	
	function ReturnInfoFunc(RowIndex, row) {
		if (row.AvaQty < 1) {
			$UI.msg('alert', '可用库存不足');
			return;
		}
		DetailGrid.updateRow({
			index: RowIndex,
			row: {
				HVBarCode: row.HVBarCode,
				OriginalStatus: row.OriginalStatus,
				dhcit: row.dhcit,
				InciId: row.InciDr,
				InciCode: row.InciCode,
				InciDesc: row.InciDesc,
				Spec: row.Spec,
				Inclb: row.Inclb,
				BatExp: row.BatExp,
				UomId: row.PurUomId,
				UomDesc: row.PurUomDesc,
				Rp: row.Rp,
				Sp: row.Sp,
				RpAmt: row.Rp,
				SpAmt: row.Sp,
				InclbDirtyQty: row.DirtyQty,
				Qty: 1,
				MatInsuCode: row.MatInsuCode,
				MatInsuDesc: row.MatInsuDesc
			}
		});
		$('#DetailGrid').datagrid('refreshRow', RowIndex);
		DetailGrid.commonAddRow();
	}
	
	// 设置缺省值
	function SetDefaValues() {
		var OperateTypeInfo = GetInitTypeDefa();
		var OperateTypeId = OperateTypeInfo.split('^')[0];
		$('#InitToLoc').combobox('setValue', session['LOGON.CTLOCID']);
		var DefaultData = {
			InitDate: DateFormatter(new Date())
		};
		if (InitParamObj['DefaReturnLoc'] == '0') {
			DefaultData.InitToLoc = gLocObj;
		} else {
			DefaultData.InitFrLoc = gLocObj;
		}
		$UI.fillBlock('#Conditions', DefaultData);
		$('#InitScg').combotree('options')['setDefaultFun']();
		if (ItmTrackParamObj.AutoVirFlag == 'Y') {
			$('#VirtualFlag').checkbox('setValue', true);
		} else {
			$('#VirtualFlag').checkbox('setValue', false);
		}
		$HUI.combobox('#OperateType').setValue(OperateTypeId);
	}
	SetDefaValues();
	var BtnEnaleObj = { '#SaveBT': false, '#DeleteBT': false, '#CompleteBT': false, '#CancelCompBT': false };
	ChangeButtonEnable(BtnEnaleObj);
};
$(init);