var ScgTipFlag = '';
var init = function() {
	$UI.linkbutton('#SearchBT', {
		onClick: function() {
			FindWin(Select);
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
				Clear();
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
		ScgTipFlag = '';
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
				var Select = DetailGrid.getRows()[DetailGrid.editIndex];
				if (!isEmpty(Select)) {
					var Inci = Select.Inclb.split('||')[0];
					param.Inci = Inci;
				}
			},
			onSelect: function(record) {
				var rows = DetailGrid.getRows();
				var row = rows[DetailGrid.editIndex];
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
				var ReqQty = row.ReqQty;
				var InclbDirtyQty = row.InclbDirtyQty;
				var DirtyQty = row.DirtyQty;
				var InclbAvaQty = row.InclbAvaQty;
				var confac = row.ConFac;
				if (NewUomid == BUomId) { // 入库单位转换为基本单位
					row.Rp = Number(Rp).div(confac);
					row.Sp = Number(Sp).div(confac);
					if (InclbQty != '') {
						row.InclbQty = Number(InclbQty).mul(confac);
					}
					if (Qty != '') {
						row.Qty = Number(Qty).mul(confac);
					}
					if (InclbDirtyQty != '') {
						row.InclbDirtyQty = Number(InclbDirtyQty).mul(confac);
					}
					if ((DirtyQty != '') && (DirtyQty != undefined)) {
						row.DirtyQty = Number(DirtyQty).mul(confac);
					}
					if (InclbAvaQty != '') {
						row.InclbAvaQty = Number(InclbAvaQty).mul(confac);
					}
				} else { // 基本单位转换为入库单位
					row.Rp = Number(Rp).mul(confac);
					row.Sp = Number(Sp).mul(confac);
					if (InclbQty != '') {
						row.InclbQty = Number(InclbQty).div(confac);
					}
					if (Qty != '') {
						row.Qty = Number(Qty).div(confac);
					}
					if (InclbDirtyQty != '') {
						row.InclbDirtyQty = Number(InclbDirtyQty).div(confac);
					}
					if (DirtyQty != '') {
						row.DirtyQty = Number(DirtyQty).div(confac);
					}
					if (InclbAvaQty != '') {
						row.InclbAvaQty = Number(InclbAvaQty).div(confac);
					}
				}
				row.UomId = NewUomid;
				setTimeout(function() {
					DetailGrid.refreshRow();
				}, 0);
			},
			onShowPanel: function() {
				$(this).combobox('reload');
			}
		}
	};
	
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
			jump: false,
			editor: {
				type: 'validatebox',
				options: {
					required: true,
					tipPosition: 'bottom'
				}
			},
			width: 180
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
			editor: {
				type: 'numberbox',
				options: {
					required: true,
					tipPosition: 'bottom',
					min: 0,
					precision: GetFmtNum('FmtQTY')
				}
			},
			align: 'right',
			width: 80
		}, {
			title: '单位',
			field: 'UomId',
			saveCol: true,
			formatter: CommonFormatter(UomCombox, 'UomId', 'UomDesc'),
			editor: UomCombox,
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
			title: '可用数量',
			field: 'InclbAvaQty',
			align: 'right',
			width: 100
		}, {
			title: '转换系数',
			field: 'ConFac',
			align: 'right',
			width: 100,
			hidden: true
		}, {
			title: 'BUomId',
			field: 'BUomId',
			align: 'right',
			width: 100,
			hidden: true
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
		checkField: 'Inclb',
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
			if (isEmpty($HUI.combotree('#InitScg').getValue()) && isEmpty(ScgTipFlag)) {
				$UI.msg('alert', '类组未选择,请谨慎核实数据!');
				ScgTipFlag = 'Y';
			}
			return true;
		},
		afterAddFn: function() {
			SetEditDisable();
			var BtnEnaleObj = { '#SaveBT': true, '#DeleteBT': false, '#CompleteBT': true, '#CancelCompBT': false };
			ChangeButtonEnable(BtnEnaleObj);
		},
		onClickRow: function(index, row) {
			DetailGrid.commonClickRow(index, row);
		},
		onBeginEdit: function(index, row) {
			// 增加完成情况字数输入限制
			$('#DetailGrid').datagrid('beginEdit', index);
			var ed = $('#DetailGrid').datagrid('getEditors', index);
			for (var i = 0; i < ed.length; i++) {
				var e = ed[i];
				if (e.field == 'InciDesc') {
					$(e.target).bind('keydown', function(event) {
						if (event.keyCode == 13) {
							var Input = $(this).val();
							if (isEmpty(Input)) {
								return;
							}
							var InitScg = $('#InitScg').combotree('getValue');
							var InitFrLoc = $('#InitFrLoc').combobox('getValue');
							var InitToLoc = $('#InitToLoc').combobox('getValue');
							var HV = 'N';
							var ParamsObj = { StkGrpRowId: InitScg, StkGrpType: 'M', Locdr: InitFrLoc, NotUseFlag: 'N', QtyFlag: 'Y',
								ToLoc: InitToLoc, HV: HV };
							IncItmBatWindow(Input, ParamsObj, ReturnInfoFunc);
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
					var Qty = row.Qty;
					var UomId = row.UomId;
					var ConFac = row.ConFac;
					var BUomId = row.BUomId;
					if (UomId == BUomId) {
						if (!CheckFmtQty(ConFac, 'BUom', Qty)) {
							DetailGrid.checked = false;
							return false;
						}
					} else {
						if (!CheckFmtQty(ConFac, 'PUom', Qty)) {
							DetailGrid.checked = false;
							return false;
						}
					}
				}
			}
		}
	});
	
	function ReturnInfoFunc(rows) {
		rows = [].concat(rows);
		$.each(rows, function(index, row) {
			var RowIndex = DetailGrid.getRowIndex(DetailGrid.getSelected());
			var ed = $('#DetailGrid').datagrid('getEditor', { index: RowIndex, field: 'UomId' });
			AddComboData(ed.target, row.PurUomId, row.PurUomDesc);
			DetailGrid.updateRow({
				index: RowIndex,
				row: {
					InciId: row.InciDr,
					InciCode: row.InciCode,
					InciDesc: row.InciDesc,
					Spec: row.Spec,
					Inclb: row.Inclb,
					InclbQty: row.InclbQty,
					BatExp: row.BatExp,
					Qty: row.OperQty,
					UomId: row.PurUomId,
					UomDesc: row.PurUomDesc,
					Rp: row.Rp,
					Sp: row.Sp,
					RpAmt: accMul(row.OperQty, row.Rp),
					SpAmt: accMul(row.OperQty, row.Sp),
					inclbDirtyQty: row.DirtyQty,
					inclbAvaQty: row.AvaQty,
					BUomId: row.BUomId,
					ConFac: row.ConFac,
					MatInsuCode: row.MatInsuCode,
					MatInsuDesc: row.MatInsuDesc
				}
			});
			$('#DetailGrid').datagrid('refreshRow', RowIndex);
			// var ed = $('#DetailGrid').datagrid('getEditor', {index: RowIndex, field: 'Qty'});
			// $(ed.target).focus();
			if (index < rows.length) {
				DetailGrid.commonAddRow();
			}
		});
	}
	
	// 设置缺省值
	function SetDefaValues() {
		var OperateTypeInfo = GetInitTypeDefa();
		var OperateTypeId = OperateTypeInfo.split('^')[0];
		var DefaultData = {
			InitDate: DateFormatter(new Date())
		};
		if (InitParamObj['DefaReturnLoc'] == '0') {
			DefaultData.InitToLoc = gLocObj;
		} else {
			DefaultData.InitFrLoc = gLocObj;
		}
		$UI.fillBlock('#Conditions', DefaultData);
		$HUI.combobox('#OperateType').setValue(OperateTypeId);
	}
	SetDefaValues();
	var BtnEnaleObj = { '#SaveBT': false, '#DeleteBT': false, '#CompleteBT': false, '#CancelCompBT': false };
	ChangeButtonEnable(BtnEnaleObj);
};
$(init);