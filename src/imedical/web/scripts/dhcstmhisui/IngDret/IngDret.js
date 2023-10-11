var init = function() {
	// /设置可编辑组件的disabled属性
	function setEditDisable() {
		$HUI.combobox('#RetLoc').disable();
		$HUI.combobox('#ScgStk').disable();
		$HUI.combobox('#Vendor').disable();
	}
	// /放开可编辑组件的disabled属性
	function setEditEnable() {
		$HUI.combobox('#RetLoc').enable();
		$HUI.combobox('#ScgStk').enable();
		$HUI.combobox('#Vendor').enable();
	}
	function SetDefaValues() {
		$('#RetLoc').combobox('setValue', gLocId);
		$('#ScgStk').combotree('options')['setDefaultFun']();
		RetGrid.setFooterInfo();
		ChangeButtonEnable({
			'#DelBT': false,
			'#PrintBT': false,
			'#ComBT': false,
			'#CanComBT': false,
			'#SaveBT': true
		});
	}
	var ClearMain = function() {
		$UI.clearBlock('#MainConditions');
		$UI.clear(RetGrid);
		SetDefaValues();
		setEditEnable();
	};
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
				var NewUomid = record.RowId;
				var OldUomid = row.Uom;
				if (isEmpty(NewUomid) || (NewUomid == OldUomid)) {
					return false;
				}
				var BUomId = row.BUom;
				var Rp = row.Rp;
				var StkQty = row.StkQty;
				var IngriLeftQty = row.IngriLeftQty;
				var Qty = row.Qty;
				var Sp = row.Sp;
				var RpAmt = row.RpAmt;
				var SpAmt = row.SpAmt;
				var InvAmt = row.InvAmt;
				var confac = row.PConFac;
				if (NewUomid == BUomId) { // 入库单位转换为基本单位
					row.Rp = Number(Rp).div(confac);
					row.Sp = Number(Sp).div(confac);
					if (!isEmpty(StkQty)) {
						row.StkQty = Number(StkQty).mul(confac);
					}
					if (!isEmpty(Qty)) {
						row.Qty = Number(Qty).mul(confac);
					}
					if (!isEmpty(InvAmt)) {
						row.InvAmt = Number(InvAmt).mul(confac);
					}
					if (!isEmpty(IngriLeftQty)) {
						row.IngriLeftQty = Number(IngriLeftQty).mul(confac);
					}
				} else { // 基本单位转换为入库单位
					row.Rp = Number(Rp).mul(confac);
					row.Sp = Number(Sp).mul(confac);
					if (!isEmpty(StkQty)) {
						row.StkQty = Number(StkQty).div(confac);
					}
					if (!isEmpty(Qty)) {
						row.Qty = Number(Qty).div(confac);
					}
					if (!isEmpty(InvAmt)) {
						row.InvAmt = Number(InvAmt).div(confac);
					}
					if (!isEmpty(IngriLeftQty)) {
						row.IngriLeftQty = Number(IngriLeftQty).div(confac);
					}
				}
				row.Uom = NewUomid;
				setTimeout(function() {
					RetGrid.refreshRow();
				}, 0);
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
			required: true,
			onSelect: function(record) {
				var rows = RetGrid.getRows();
				var row = rows[RetGrid.editIndex];
				row.Reason = record.Description;
			},
			onShowPanel: function() {
				$(this).combobox('reload');
			}
		}
	};
	
	var RetLocParams = JSON.stringify(addSessionParams({
		Type: 'Login'
	}));
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
	function CheckDataBeforeSave() {
		if (!RetGrid.endEditing()) {
			return false;
		}
		var MainObj = $UI.loopBlock('#MainConditions');
		var InStkTkParamObj = GetAppPropValue('DHCSTINSTKTKM');
		if (InStkTkParamObj.AllowBusiness != 'Y') {
			var RetLoc = MainObj.RetLoc;
			var IfExistInStkTk = tkMakeServerCall('web.DHCSTMHUI.INStkTk', 'CheckInStkTkByLoc', RetLoc);
			if (IfExistInStkTk == 'Y') {
				$UI.msg('alert', '存在未完成的盘点单不允许保存!');
				return false;
			}
		}
		var RowsData = RetGrid.getRows();
		if (RowsData.length == 0) {
			$UI.msg('alert', '没有要保存的明细!');
			return false;
		}
		for (var i = 0; i < RowsData.length; i++) {
			var row = i + 1;
			var ReasonId = RowsData[i].ReasonId;
			if (IngrtParamObj['AllowSaveReasonEmpty'] != 'Y' && isEmpty(ReasonId)) {
				$UI.msg('alert', '第' + row + '行退货原因不能为空!');
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
		// 判断
		var ifChangeMain = $UI.isChangeBlock('#MainConditions');
		if (DetailObj === false) {	// 未完成编辑或明细为空
			return;
		}
		if (!ifChangeMain && (isEmpty(DetailObj))) {	// 主单和明细不变
			$UI.msg('alert', '没有需要保存的信息!');
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
					PrintIngDret(jsonData.rowid);
				}
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	};
	$UI.linkbutton('#DelBT', {
		onClick: function() {
			var RetId = $('#RowId').val();
			if (isEmpty(RetId)) {
				return;
			}
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
			var RetId = MainObj.RowId;
			if (isEmpty(RetId)) {
				return;
			}
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
			if (isEmpty(RetId)) {
				return;
			}
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
				$UI.msg('alert', '请选择需要打印的退货单!');
				return;
			}
			var AuditFlag = $('#AuditFlag').val();
			if ((IngrtParamObj.PrintNoAudit == 'N') && (AuditFlag != 'Y')) {
				$UI.msg('alert', '不允许打印未审核的退货单!');
				return false;
			}
			PrintIngDret($('#RowId').val());
		}
	});
	var Select = function(RetId) {
		$UI.clearBlock('#MainConditions');
		$UI.clear(RetGrid);
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRet',
			MethodName: 'Select',
			RetId: RetId
		}, function(jsonData) {
			$UI.fillBlock('#MainConditions', jsonData);
			setEditDisable();
			// 按钮控制
			if ($HUI.checkbox('#Completed').getValue()) {
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
			query2JsonStrict: 1,
			RetId: RetId,
			rows: 99999,
			totalFooter: '"Code":"合计"',
			totalFields: 'RpAmt,SpAmt'
		});
	};
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			Save();
		}
	});

	var RetCm = [[
		{
			field: 'ck',
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
			saveCol: true,
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
			saveCol: true,
			hidden: true
		}, {
			title: '物资代码',
			field: 'Code',
			width: 100
		}, {
			title: '物资名称',
			field: 'Description',
			editor: {
				type: 'validatebox',
				options: {
					required: true,
					tipPosition: 'bottom'
				}
			},
			width: 150,
			jump: false
		}, {
			title: '规格',
			field: 'Spec',
			width: 100
		}, {
			title: '生产厂家',
			field: 'Manf',
			width: 150
		}, {
			title: '批号',
			field: 'BatNo',
			width: 100
		}, {
			title: '效期',
			field: 'ExpDate',
			width: 100
		}, {
			title: '批次库存',
			field: 'StkQty',
			width: 80,
			hidden: true,
			align: 'right'
		}, {
			title: '可退数量',
			field: 'IngriLeftQty',
			width: 80,
			align: 'right'
		}, {
			title: '退货数量',
			field: 'Qty',
			width: 80,
			saveCol: true,
			align: 'right',
			editor: {
				type: 'numberbox',
				options: {
					required: true,
					tipPosition: 'bottom',
					min: 0,
					precision: GetFmtNum('FmtQTY')
				}
			}
		}, {
			title: '单位',
			field: 'Uom',
			width: 80,
			saveCol: true,
			formatter: CommonFormatter(UomCombox, 'Uom', 'UomDesc'),
			editor: UomCombox
		}, {
			title: '退货原因',
			field: 'ReasonId',
			width: 100,
			saveCol: true,
			formatter: CommonFormatter(ReasonCombox, 'ReasonId', 'Reason'),
			editor: ReasonCombox
		}, {
			title: '退货进价',
			field: 'Rp',
			width: 80,
			saveCol: true,
			align: 'right'
		}, {
			title: '进价金额',
			field: 'RpAmt',
			width: 80,
			align: 'right'
		}, {
			title: '发票代码',
			field: 'InvCode',
			width: 80,
			saveCol: true,
			editor: {
				type: 'text'
			}
		}, {
			title: '发票号',
			field: 'InvNo',
			width: 100,
			align: 'left',
			saveCol: true,
			editor: {
				type: 'text'
			}
		}, {
			title: '发票日期',
			field: 'InvDate',
			width: 120,
			saveCol: true,
			align: 'left',
			editor: {
				type: 'datebox'
			}

		}, {
			title: '发票金额',
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
			title: '零售单价',
			field: 'Sp',
			width: 80,
			saveCol: true,
			align: 'right'
		}, {
			title: '售价金额',
			field: 'SpAmt',
			width: 80,
			align: 'right'
		}, {
			title: '具体规格',
			field: 'SpecDesc',
			width: 100,
			align: 'left',
			saveCol: true,
			sortable: true,
			hidden: CodeMainParamObj.UseSpecList == 'Y' ? false : true
		}, {
			title: '高值标志',
			field: 'HvFlag',
			width: 80,
			align: 'center',
			hidden: true,
			formatter: BoolFormatter
		}, {
			title: '随行单号',
			field: 'SxNo',
			width: 200,
			align: 'left',
			saveCol: true,
			editor: {
				type: 'text'
			}
		}, {
			title: '备注',
			field: 'Remark',
			width: 200,
			align: 'left',
			saveCol: true,
			editor: {
				type: 'text'
			}
		}, {
			title: 'BUom',
			field: 'BUom',
			width: 100,
			hidden: true
		}, {
			title: 'PConFac',
			field: 'PConFac',
			width: 100,
			hidden: true
		}, {
			title: '国家医保编码',
			field: 'MatInsuCode',
			width: 160
		}, {
			title: '国家医保名称',
			field: 'MatInsuDesc',
			width: 160
		}
	]];

	var RetGrid = $UI.datagrid('#RetGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGrtItm',
			QueryName: 'DHCINGdRetItm',
			query2JsonStrict: 1,
			rows: 99999,
			totalFooter: '"Code":"合计"',
			totalFields: 'RpAmt,SpAmt'
		},
		deleteRowParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGrtItm',
			MethodName: 'Delete'
		},
		columns: RetCm,
		checkField: 'Inclb',
		singleSelect: false,
		showBar: true,
		showFooter: true,
		remoteSort: false,
		showAddDelItems: true,
		pagination: false,
		onClickRow: function(index, row) {
			RetGrid.commonClickRow(index, row);
		},
		onEndEdit: function(index, row, changes) {
			var Editors = $(this).datagrid('getEditors', index);
			for (var i = 0; i < Editors.length; i++) {
				var Editor = Editors[i];
				if (Editor.field == 'Qty') {
					var Qty = row.Qty;
					var UomId = row.Uom;
					var ConFac = row.PConFac;
					var BUomId = row.BUom;
					if (UomId == BUomId) {
						if (!CheckFmtQty(ConFac, 'BUom', Qty)) {
							RetGrid.checked = false;
							return false;
						}
					} else {
						if (!CheckFmtQty(ConFac, 'PUom', Qty)) {
							RetGrid.checked = false;
							return false;
						}
					}
				}
			}
			if (changes.hasOwnProperty('Qty')) {
				var RepLev = row.RepLev;
				var Qty = Number(row.Qty);
				var IngriLeftQty = Number(row.IngriLeftQty);
				if (Qty > IngriLeftQty) {
					$UI.msg('alert', '退货数量不能大于可退数量!');
					RetGrid.updateRow({
						index: index,
						row: {
							'Qty': '',
							'RpAmt': '',
							'SpAmt': '',
							'InvAmt': ''
						}
					});
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
		onBeforeEdit: function(index, row) {
			if ($HUI.checkbox('#Completed').getValue()) {
				$UI.msg('alert', '已经完成，不能编辑!');
				return false;
			}
		},
		beforeDelFn: function() {
			if ($HUI.checkbox('#Completed').getValue()) {
				$UI.msg('alert', '已经完成，不能删除选中行!');
				return false;
			}
		},
		beforeAddFn: function() {
			if ($HUI.checkbox('#Completed').getValue()) {
				$UI.msg('alert', '已经完成，不能增加一行!');
				return false;
			}
			if (isEmpty($HUI.combobox('#RetLoc').getValue())) {
				$UI.msg('alert', '退货科室不能为空!');
				return false;
			}
			$HUI.combobox('#RetLoc').disable();
			$HUI.combobox('#ScgStk').disable();
			$HUI.combobox('#Vendor').disable();
		},
		onBeginEdit: function(index, row) {
			$('#RetGrid').datagrid('beginEdit', index);
			var ed = $('#RetGrid').datagrid('getEditors', index);
			for (var i = 0; i < ed.length; i++) {
				var e = ed[i];
				if (e.field == 'Description') {
					$(e.target).bind('keydown', function(event) {
						if (event.keyCode == 13) {
							var Input = $(this).val();
							if (isEmpty(Input)) {
								return;
							}
							var Scg = $('#ScgStk').combotree('getValue');
							var LocDr = $('#RetLoc').combo('getValue');
							var HV = gHVInRet ? 'Y' : 'N';
							var Vendor = $('#Vendor').combo('getValue');
							var ParamsObj = {
								StkGrpRowId: Scg,
								StkGrpType: 'M',
								Locdr: LocDr,
								NotUseFlag: 'N',
								QtyFlag: '1',
								ZeroFlag: 'Y',
								HV: HV,
								InclbVendor: Vendor
							};
							VendorIncItmBatWindow(Input, ParamsObj, ReturnInfoFn);
						}
					});
				}
				if ((e.field == 'InvCode') || (e.field == 'InvNo')) {
					$(e.target).bind('keydown', function(event) {
						if (event.keyCode == 13) {
							var InvInfo = $(this).val();
							SetInvInfo(InvInfo);
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
			var RowIndex = RetGrid.editIndex;
			var Ingri = row.Ingri;
			var FindIndex = RetGrid.find('Ingri', Ingri);
			if (FindIndex >= 0 && FindIndex != RowIndex) {
				$UI.msg('alert', '相同入库明细物资已存在!');
				return;
			}
			var VendorId = row.Vendor;
			if ($HUI.combobox('#Vendor').getValue() == '') {
				$HUI.combobox('#Vendor').setValue(VendorId);
			}
			
			// 阳光采购 区分试剂 物资单据
			var SunPurPlan = CommParObj.SunPurPlan; // 参数设置 公共
			if (SunPurPlan == '四川省') {
				var DetailObj = RetGrid.getRows();
				var FirstMRFlag = '';
				if (DetailObj.length > 1) {
					var FirstRow = RetGrid.getRows()[0];
					var FirstMRFlag = tkMakeServerCall('web.DHCSTMHUI.ServiceForSCYGCG', 'GetInciFlag', FirstRow.Inci);
				}
				var CurentInciFlag = tkMakeServerCall('web.DHCSTMHUI.ServiceForSCYGCG', 'GetInciFlag', row.InciDr);
				if ((FirstMRFlag != '') && (CurentInciFlag != '') && (CurentInciFlag != FirstMRFlag)) {
					$UI.msg('alert', '请将试剂 物资 分开入库!');
					return false;
				}
			}
			
			var TmpVendorId = $HUI.combobox('#Vendor').getValue();
			var LastReasonId, LastReasonDesc = '';
			if ((RowIndex > 0) && (IngrtParamObj['DefaRetReason'] == 'Y')) {
				var LastRowIndex = RowIndex - 1;
				var LastRow = RetGrid.getRows()[LastRowIndex];
				LastReasonId = LastRow.ReasonId;
				LastReasonDesc = LastRow.Reason;
			}
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
					IngriLeftQty: row.IngriLeftQty,
					ConFac: row.ConFac,
					SpecDesc: row.SpecDesc,
					ReasonId: LastReasonId,
					Reason: LastReasonDesc,
					PConFac: row.PConFac,
					MatInsuCode: row.MatInsuCode,
					MatInsuDesc: row.MatInsuDesc,
					Vendor: row.Vendor,
					VendorDesc: row.VendorDesc
				}
			});
			setTimeout(function() {
				RetGrid.refreshRow();
				var ed = $('#RetGrid').datagrid('getEditor', { index: RowIndex, field: 'Qty' });
				$(ed.target).focus();
			}, 0);
		});
	}
	function SetInvInfo(InvInfo) {
		var InvObj = GetInvInfo(InvInfo);
		if (InvObj === false) {
			$UI.msg('alert', '请录入正确的发票信息!');
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
	
	SetDefaValues();
	if (!isEmpty(gIngrtId)) {
		Select(gIngrtId);
	}
};
$(init);