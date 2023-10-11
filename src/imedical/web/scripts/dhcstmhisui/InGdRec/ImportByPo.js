/*
依据订单入库
*/
var ImpByPoFN = function(Fn) {
	$HUI.dialog('#ImportByPoWin', { width: gWinWidth, height: gWinHeight }).open();
	$UI.linkbutton('#PoQueryBT', {
		onClick: function() {
			QueryInpoIngrInfo();
		}
	});
	$UI.linkbutton('#PoClearBT', {
		onClick: function() {
			InpoIngrClear();
		}
	});
	$UI.linkbutton('#PoSplitBT', {
		onClick: function() {
			PosplitDetail();
		}
	});
	$UI.linkbutton('#PoSaveBT', {
		onClick: function() {
			if (CheckDataBeforeSave()) {
				InpoIngrSave();
			}
		}
	});
	// Grid 列 comboxData
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
				var rows = IngrInpoDetailGrid.getRows();
				var row = rows[IngrInpoDetailGrid.editIndex];
				if (!isEmpty(row)) {
					param.Inci = row.IncId;
				}
			},
			onSelect: function(record) {
				var rows = IngrInpoDetailGrid.getRows();
				var row = rows[IngrInpoDetailGrid.editIndex];
				row.IngrUom = record.Description;
				var NewUomid = record.RowId;
				var OldUomid = row.IngrUomId;
				if (isEmpty(NewUomid) || (NewUomid == OldUomid)) { return false; }
				var BUomId = row.BUomId;
				var confac = row.ConFacPur;
				if (NewUomid == BUomId) { // 入库单位转换为基本单位
					var rp = row.Rp;
					var sp = row.Sp;
					row.Rp = Number(rp).div(confac);
					row.Sp = Number(sp).div(confac);
				} else { // 基本单位转换为入库单位
					var rp = row.Rp;
					var sp = row.Sp;
					row.Rp = Number(rp).mul(confac);
					row.Sp = Number(sp).mul(confac);
				}
				row.IngrUomId = NewUomid;
				setTimeout(function() {
					IngrInpoDetailGrid.refreshRow();
				}, 0);
			},
			onShowPanel: function() {
				$(this).combobox('reload');
			}
		}
	};
	// / grid combobox
	var PhManufacturerParams = JSON.stringify(addSessionParams({ StkType: 'M' }));
	var PhManufacturerBox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPhManufacturer&ResultSetType=array&Params=' + PhManufacturerParams,
			valueField: 'RowId',
			textField: 'Description'
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
				var Select = IngrInpoDetailGrid.getSelected();
				if (!isEmpty(Select)) {
					param.Inci = Select.IncId;
				}
			}
		}
	};
	var RecLocParams = JSON.stringify(addSessionParams({ Type: 'Login' }));
	var RecLocBox = $HUI.combobox('#PoRecLoc', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+RecLocParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	/*
	$('#PoRecLoc').lookup({
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetCTLoc',
			Params: RecLocParams,
			rows: 99999
		}
	});*/
	var VendorParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
	var VendorBox = $HUI.combobox('#VendorBox', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+VendorParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	/*
	$('#VendorBox').lookup({
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetVendor',
			Params: VendorParams,
			rows: 99999
		}
	});
	*/
	var SourceOfFundParams = JSON.stringify(addSessionParams());
	var SourceOfFundBox = $HUI.combobox('#PoSourceOfFund', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetSourceOfFund&ResultSetType=array&Params='+SourceOfFundParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	/*
	$('#PoSourceOfFund').lookup({
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetSourceOfFund',
			Params: SourceOfFundParams,
			rows: 99999
		}
	});*/
	var IngrInpoMainCm = [[
		{
			title: 'RowId',
			field: 'PoId',
			width: 50,
			hidden: true
		}, {
			title: '订单号',
			field: 'PoNo',
			width: 100
		}, {
			title: '申购科室',
			field: 'ReqLocDesc',
			width: 100
		}, {
			title: '订购科室',
			field: 'PoLocDesc',
			width: 100
		}, {
			title: '供应商',
			field: 'Vendor',
			width: 100
		}, {
			title: '订单状态',
			field: 'PoStatus',
			width: 100,
			formatter: function(v) {
				if (v == 0) { return '未入库'; } else if (v == 1) { return '部分入库'; } else { return '全部入库'; }
			}
		}, {
			title: '订单日期',
			field: 'PoDate',
			width: 100
		}, {
			title: 'VenId',
			field: 'VenId',
			width: 50,
			hidden: true
		}, {
			title: 'PurUserId',
			field: 'PurUserId',
			width: 50,
			hidden: true
		}, {
			title: 'StkGrpId',
			field: 'StkGrpId',
			width: 50,
			hidden: true
		}, {
			title: 'CmpFlag',
			field: 'CmpFlag',
			width: 50,
			hidden: true
		}, {
			title: '电子邮件',
			field: 'Email',
			width: 100
		}, {
			title: 'ReqLoc',
			field: 'ReqLoc',
			width: 50,
			hidden: true
		}, {
			title: 'PoLoc',
			field: 'PoLoc',
			width: 50,
			hidden: true
		}, {
			title: '是否审批',
			field: 'Approveed',
			width: 100,
			formatter: function(value) {
				if (value == 'Y')
					return '是';
				else
					return '否';
			}
		}, {
			title: '订单号',
			field: 'ApproveedUser',
			width: 50,
			hidden: true
		}, {
			title: 'ApproveedDate',
			field: 'ApproveedDate',
			width: 50,
			hidden: true
		}, {
			title: 'CancelReasonId',
			field: 'CancelReasonId',
			width: 50,
			hidden: true
		}, {
			title: 'CancelReason',
			field: 'CancelReason',
			width: 50,
			hidden: true
		}
	]];
	var IngrInpoMainGrid = $UI.datagrid('#IngrInpoMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INPO',
			QueryName: 'Query',
			query2JsonStrict: 1
		},
		columns: IngrInpoMainCm,
		onSelect: function(index, row) {
			IngrInpoDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
				QueryName: 'QueryPoItmForRec',
				query2JsonStrict: 1,
				rows: 99999,
				Parref: row.PoId
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				IngrInpoMainGrid.selectRow(0);
			}
		}
	});
	var IngrInpoDetailGridCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'Inpoi',
			width: 50,
			saveCol: true,
			hidden: true
		}, {
			title: 'IncId',
			field: 'IncId',
			width: 50,
			saveCol: true,
			hidden: true
		}, {
			title: '物资代码',
			field: 'IncCode',
			width: 100
		}, {
			title: '物资名称',
			field: 'IncDesc',
			width: 100
		}, {
			title: '规格',
			field: 'Spec',
			width: 100
		}, {
			title: '未入库数量',
			field: 'RecQty',
			width: 100,
			align: 'right',
			saveCol: true,
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
			field: 'IngrUomId',
			width: 100,
			saveCol: true,
			formatter: CommonFormatter(UomCombox, 'IngrUomId', 'IngrUom'),
			editor: UomCombox
		}, {
			title: '进价',
			field: 'Rp',
			width: 80,
			align: 'right',
			saveCol: true,
			editor: {
				type: 'numberbox',
				options: {
					required: true,
					tipPosition: 'bottom',
					min: 0,
					precision: GetFmtNum('FmtRP')
				}
			}
		}, {
			title: '生产厂家',
			field: 'ManfId',
			width: 100,
			saveCol: true,
			formatter: CommonFormatter(PhManufacturerBox, 'ManfId', 'Manf'),
			editor: PhManufacturerBox
		}, {
			title: '批号',
			field: 'BatchNo',
			width: 80,
			saveCol: true,
			editor: {
				type: 'text',
				options: {
				}
			}
		}, {
			title: '有效期',
			field: 'ExpDate',
			width: 80,
			saveCol: true,
			editor: {
				type: 'datebox',
				options: {
				}
			}
		}, {
			title: '售价',
			field: 'Sp',
			width: 100,
			align: 'right',
			saveCol: true
		}, {
			title: '转换率',
			field: 'ConFacPur',
			width: 100
		}, {
			title: '订购数量',
			field: 'PurQty',
			width: 100,
			align: 'right'
		}, {
			title: '已入库制单数量',
			field: 'ImpQty',
			width: 110,
			align: 'right'
		}, {
			title: '具体规格',
			field: 'SpecDesc',
			width: 100,
			saveCol: CodeMainParamObj.UseSpecList == 'Y' ? true : false,
			formatter: CommonFormatter(SpecDescbox, 'SpecDesc', 'SpecDesc'),
			hidden: CodeMainParamObj.UseSpecList == 'Y' ? false : true,
			editor: (CodeMainParamObj.UseSpecList == 'Y' ? false : true) ? null : SpecDescbox
		}, {
			title: '注册证号',
			field: 'AdmNo',
			width: 90,
			saveCol: true,
			editor: {
				type: 'text',
				options: {
				}
			}
		}, {
			title: '注册证号效期',
			field: 'AdmExpdate',
			width: 100,
			saveCol: true,
			editor: {
				type: 'datebox',
				options: {
				}
			}
		}, {
			title: '高值标志',
			field: 'HVFlag',
			width: 100,
			formatter: BoolFormatter
		}, {
			title: '已入库数量',
			field: 'ImpQtyAudited',
			width: 100,
			align: 'right'
		}, {
			title: '批号要求',
			field: 'BatchReq',
			width: 50,
			hidden: true
		}, {
			title: '有效期要求',
			field: 'ExpReq',
			width: 50,
			hidden: true
		}, {
			title: 'BarcodeQty',
			field: 'BarcodeQty',
			width: 50,
			align: 'right',
			hidden: true
		}, {
			title: 'AvaBarcodeQty',
			field: 'AvaBarcodeQty',
			width: 50,
			align: 'right',
			hidden: true
		}, {
			title: '基本单位',
			field: 'BUomId',
			width: 50,
			hidden: true
		}
	]];
	var IngrInpoDetailGrid = $UI.datagrid('#IngrInpoDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
			QueryName: 'QueryPoItmForRec',
			query2JsonStrict: 1
		},
		singleSelect: false,
		pagination: false,
		columns: IngrInpoDetailGridCm,
		onClickRow: function(index, row) {
			IngrInpoDetailGrid.commonClickRow(index, row);
		}
		
	});
	function QueryInpoIngrInfo() {
		var ParamsObj = $UI.loopBlock('#PoConditions');
		if (isEmpty(ParamsObj.PoRecLoc)) {
			$UI.msg('alert', '入库科室不能为空!');
			return false;
		}
		ParamsObj.AuditFlag = 'Y';
		ParamsObj.includeCancelInPo = 'N';
		var Params = JSON.stringify(ParamsObj);
		$UI.clear(IngrInpoDetailGrid);
		$UI.clear(IngrInpoMainGrid);
		IngrInpoMainGrid.load({
			ClassName: 'web.DHCSTMHUI.INPO',
			QueryName: 'Query',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	function CheckDataBeforeSave() {
		if (!IngrInpoDetailGrid.endEditing()) {
			return false;
		}
		var ParamsObj = $UI.loopBlock('#PoConditions');
		var RecLoc = ParamsObj.PoRecLoc;
		var Row = IngrInpoMainGrid.getSelected();
		if (isEmpty(Row)) {
			$UI.msg('alert', '请选择要保存的单据!');
			return false;
		}
		var Status = Row.PoStatus;
		if (Status == 2) {
			$UI.msg('alert', '该订单已经全部入库，不能再入库!');
			return false;
		}
		if (isEmpty(RecLoc)) {
			$UI.msg('alert', '请选择入库科室!');
			return false;
		}
		var RowsData = IngrInpoDetailGrid.getSelections();
		// 有效行数
		var count = 0;
		for (var i = 0; i < RowsData.length; i++) {
			var item = RowsData[i].IncId;
			if (!isEmpty(item)) {
				count++;
			}
			var RecQty = RowsData[i].RecQty;
			if (RecQty == null || RecQty <= 0) {
				$UI.msg('alert', '数量不能小于或等于0!');
				return false;
			}
		}
		if (RowsData.length <= 0 || count <= 0) {
			$UI.msg('alert', '无入库明细数据!');
			return false;
		}
		return true;
	}
	function InpoIngrSave() {
		var ParamsObj = $UI.loopBlock('PoConditions');
		var SaveParamsObj = $UI.loopBlock('#PoSaveConditions');
		var RecLoc = ParamsObj.PoRecLoc;
		var SourceOfFund = SaveParamsObj.PoSourceOfFund;
		var Row = IngrInpoMainGrid.getSelected();
		if (isEmpty(Row)) {
			$UI.msg('alert', '请选择要保存的单据!');
			return false;
		}
		var PoId = Row.PoId;
		var HVflag = GetCertDocHVFlag(PoId, 'PO');
		if (HVflag == 'Y') {
			$UI.msg('alert', '此订单为高值订单,请去高值生成条码界面导入订单,注册条码!');
			return false;
		}
		var PurchaseUser = Row.PurUserId;
		var Vendor = Row.VenId;
		var StkGrpId = Row.StkGrpId;
		var ReqLocId = Row.ReqLoc;
		if (RecLoc == ReqLocId) { ReqLocId = ''; }
		var Complete = 'N';
		var AdjCheque = 'N';
		var GiftFlag = 'N';
		var MainParamsObj = $UI.loopBlock('#MainConditions');
		var IngrTypeId = MainParamsObj.IngrTypeId;
		var Main = JSON.stringify(addSessionParams({ RecLoc: RecLoc, PurchaseUser: PurchaseUser, ApcvmDr: Vendor, StkGrpId: StkGrpId, SourceOfFund: SourceOfFund, ReqLocId: ReqLocId, Complete: Complete, AdjCheque: AdjCheque, GiftFlag: GiftFlag, PoId: PoId, IngrTypeId: IngrTypeId }));
		var DetailObj = IngrInpoDetailGrid.getSelectedData();
		var Detail = JSON.stringify(DetailObj);
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			MethodName: 'jsSave',
			MainInfo: Main,
			ListData: Detail
		}, function(jsonData) {
			$UI.msg('success', jsonData.msg);
			if (jsonData.success == 0) {
				var IngrRowid = jsonData.rowid;
				$HUI.dialog('#ImportByPoWin').close();
				if (IngrParamObj.AutoPrintAfterSave == 'Y') {
					PrintRec(IngrRowid, 'Y');
				}
				Fn(IngrRowid);
			}
		});
	}
	var PosplitDetail = function() {
		var RowsData = IngrInpoDetailGrid.getSelections();
		for (var i = 0; i < RowsData.length; i++) {
			IngrInpoDetailGrid.commonAddRow();
			IngrInpoDetailGrid.updateRow({
				index: IngrInpoDetailGrid.editIndex,
				row: RowsData[i]
			});
			setTimeout(function() {
				IngrInpoDetailGrid.refreshRow();
			}, 0);
		}
	};
	function InpoIngrClear() {
		$UI.clearBlock('#PoConditions');
		$UI.clearBlock('#PoSaveConditions');
		$UI.clear(IngrInpoMainGrid);
		$UI.clear(IngrInpoDetailGrid);
		var LocId = $('#RecLoc').combobox('getValue');
		var LocDesc = $('#RecLoc').combobox('getText');
		var DefaultData = {
			PoStartDate: DefaultStDate(),
			PoEndDate: DefaultEdDate(),
			PoRecLoc: { RowId: LocId, Description: LocDesc },
			Status: 0
		};
		$UI.fillBlock('#PoConditions', DefaultData);
	}
	InpoIngrClear();
	QueryInpoIngrInfo();
};