/*入库单制单(依据订单)*/
var init = function () {
	$UI.linkbutton('#PoQueryBT', {
		onClick: function () {
			QueryInpoIngrInfo();
		}
	});
	$UI.linkbutton('#PoClearBT', {
		onClick: function () {
			InpoIngrClear();
		}
	});
	$UI.linkbutton('#PoSaveBT', {
		onClick: function () {
			if (CheckDataBeforeSave()) {
				InpoIngrSave();
			}

		}
	});
	//Grid 列 comboxData
	var UomCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetInciUom&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			mode: 'remote',
			onBeforeLoad: function (param) {
				var rows =IngrInpoDetailGrid.getRows();  
				var row = rows[IngrInpoDetailGrid.editIndex];
				if(!isEmpty(row)){
					param.Inci =row.IncId;
				}

			},
			onSelect: function (record) {
				var rows = IngrInpoDetailGrid.getRows();
				var row = rows[IngrInpoDetailGrid.editIndex];
				row.IngrUom = record.Description;
				var NewUomid = record.RowId;
				var OldUomid = row.IngrUomId;
				if (isEmpty(NewUomid) || (NewUomid == OldUomid)) { return false; }
				var BUomId = row.BUomId;
				var confac = row.ConFacPur;
				if (NewUomid == BUomId) { //入库单位转换为基本单位
					var rp = row.Rp;
					var sp = row.Sp;
					row.Rp = Number(rp).div(confac);
					row.Sp = Number(sp).div(confac);
				} else { //基本单位转换为入库单位
					var rp = row.Rp;
					var sp = row.Sp;
					row.Rp = Number(rp).mul(confac);
					row.Sp = Number(sp).mul(confac);
				}
				row.IngrUomId = NewUomid;
				$('#IngrInpoDetailGrid').datagrid('refreshRow', IngrInpoDetailGrid.editIndex);
			},
			onShowPanel: function () {
				$(this).combobox('reload');
			}
		}
	};
	/// grid combobox
	var PhManufacturerParams = JSON.stringify(addSessionParams({ StkType: "M" }));
	var PhManufacturerBox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPhManufacturer&ResultSetType=array&Params=' + PhManufacturerParams,
			valueField: 'RowId',
			textField: 'Description',
			onBeforeLoad: function (param) {
			}
		}
	};
	var SpecDescParams = JSON.stringify(sessionObj)
	var SpecDescbox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetSpecDesc&ResultSetType=array&Params=' + SpecDescParams,
			valueField: 'Description',
			textField: 'Description',
			mode: 'remote',
			onBeforeLoad: function (param) {
				var Select = IngrInpoDetailGrid.getSelected();
				if (!isEmpty(Select)) {
					param.Inci = Select.IncId;
				}

			}
		}
	};
	var RecLocParams = JSON.stringify(addSessionParams({ Type: "Login" }));
	var RecLocBox = $HUI.combobox('#PoRecLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + RecLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var VendorParams = JSON.stringify(addSessionParams({ APCType: "M", RcFlag: "Y" }));
	var VendorBox = $HUI.combobox('#VendorBox', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var SourceOfFundParams = JSON.stringify(addSessionParams());
	var SourceOfFundBox = $HUI.combobox('#PoSourceOfFund', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetSourceOfFund&ResultSetType=array&Params=' + SourceOfFundParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var IngrInpoMainCm = [[
		{
			title: "RowId",
			field: 'PoId',
			width: 50,
			hidden: true
		}, {
			title: "订单号",
			field: 'PoNo',
			width: 100
		}, {
			title: "申购科室",
			field: 'ReqLocDesc',
			width: 100
		}, {
			title: "订购科室",
			field: 'PoLocDesc',
			width: 100
		}, {
			title: "供应商",
			field: 'Vendor',
			width: 100
		}, {
			title: "订单状态",
			field: 'PoStatus',
			width: 100,
			formatter: function (v) {
				if (v == 0) { return "未入库" }
				else if (v == 1) { return "部分入库" }
				else { return "全部入库" }
			}
		}, {
			title: "订单日期",
			field: 'PoDate',
			width: 100
		}, {
			title: "VenId",
			field: 'VenId',
			width: 50,
			hidden: true
		}, {
			title: "PurUserId",
			field: 'PurUserId',
			width: 50,
			hidden: true
		}, {
			title: "StkGrpId",
			field: 'StkGrpId',
			width: 50,
			hidden: true
		}, {
			title: "CmpFlag",
			field: 'CmpFlag',
			width: 50,
			hidden: true
		}, {
			title: "电子邮件",
			field: 'Email',
			width: 100
		}, {
			title: "ReqLoc",
			field: 'ReqLoc',
			width: 50,
			hidden: true
		}, {
			title: "PoLoc",
			field: 'PoLoc',
			width: 50,
			hidden: true
		}, {
			title: "Approveed",
			field: 'Approveed',
			width: 100,
			hidden: true
		}, {
			title: "订单号",
			field: 'ApproveedUser',
			width: 50,
			hidden: true
		}, {
			title: "ApproveedDate",
			field: 'ApproveedDate',
			width: 50,
			hidden: true
		}, {
			title: "CancelReasonId",
			field: 'CancelReasonId',
			width: 50,
			hidden: true
		}, {
			title: "CancelReason",
			field: 'CancelReason',
			width: 50,
			hidden: true
		}

	]];
	var IngrInpoMainGrid = $UI.datagrid('#IngrInpoMainGrid', {
		url: '',
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INPO',
			QueryName: 'Query'
		},
		columns: IngrInpoMainCm,
		showBar: true,
		onSelect: function (index, row) {
			$UI.setUrl(IngrInpoDetailGrid);
			IngrInpoDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
				QueryName: 'QueryPoItmForRec',
				Parref: row.PoId
			});
		}
	})
	var IngrInpoDetailGridCm = [[
		{
			title: "RowId",
			field: 'Inpoi',
			width: 50,
			hidden: true
		}, {
			title: "IncId",
			field: 'IncId',
			width: 50,
			hidden: true
		}, {
			title: "物资代码",
			field: 'IncCode',
			width: 100
		}, {
			title: "物资名称",
			field: 'IncDesc',
			width: 100
		}, {
			title: "规格",
			field: 'Spec',
			width: 100
		}, {
			title: "未入库数量",
			field: 'RecQty',
			width: 100,
			align: 'right',
			editor: {
				type: 'numberbox',
				options: {
					required: true
				}
			}
		}, {
			title: "单位",
			field: 'IngrUomId',
			width: 100,
			formatter: CommonFormatter(UomCombox, 'IngrUomId', 'IngrUom'),
			editor: UomCombox
		}, {
			title: "进价",
			field: 'Rp',
			width: 80,
			align: 'right',
			editor: {
				type: 'numberbox',
				options: {
					required: true
				}
			}
		}, {
			title: "生产厂商",
			field: 'ManfId',
			width: 100,
			formatter: CommonFormatter(PhManufacturerBox, 'ManfId', 'Manf'),
			editor: PhManufacturerBox
		}, {
			title: "售价",
			field: 'Sp',
			width: 100,
			align: 'right'
		}, {
			title: "批号",
			field: 'BatchNo',
			width: 80,
			editor: {
				type: 'text',
				options: {
				}
			}
		}, {
			title: "有效期",
			field: 'ExpDate',
			width: 80,
			editor: {
				type: 'datebox',
				options: {
				}
			}
		}, {
			title: "基本单位",
			field: 'BUomId',
			width: 50,
			hidden: true
		}, {
			title: "转换率",
			field: 'ConFacPur',
			width: 100
		}, {
			title: "订购数量",
			field: 'PurQty',
			width: 100,
			align: 'right'
		}, {
			title: "已入库制单数量",
			field: 'ImpQty',
			width: 100,
			align: 'right'
		}, {
			title: "批号要求",
			field: 'BatchReq',
			width: 50,
			hidden: true
		}, {
			title: "有效期要求",
			field: 'ExpReq',
			width: 50,
			hidden: true
		}, {
			title: "BarcodeQty",
			field: 'BarcodeQty',
			width: 50,
			align: 'right',
			hidden: true
		}, {
			title: "AvaBarcodeQty",
			field: 'AvaBarcodeQty',
			width: 50,
			align: 'right',
			hidden: true
		}, {
			title: "具体规格",
			field: 'SpecDesc',
			width: 100,
			formatter: CommonFormatter(SpecDescbox, 'SpecDesc', 'SpecDesc'),
			editor: SpecDescbox
		}, {
			title: "注册证号",
			field: 'AdmNo',
			width: 90,
			editor: {
				type: 'text',
				options: {
				}
			}
		}, {
			title: "注册证号效期",
			field: 'AdmExpdate',
			width: 100,
			editor: {
				type: 'datebox',
				options: {
				}
			}
		}, {
			title: "高值标志",
			field: 'HVFlag',
			width: 100
		}, {
			title: "已入库数量",
			field: 'ImpQtyAudited',
			width: 100,
			align: 'right'
		}, {
			title: "生产日期",
			field: 'ProduceDate',
			width: 80,
			editor: {
				type: 'datebox',
				options: {
				}
			}
		}
	]];
	var IngrInpoDetailGrid = $UI.datagrid('#IngrInpoDetailGrid', {
		url: '',
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
			QueryName: 'QueryPoItmForRec'
		},
		columns: IngrInpoDetailGridCm,
		showBar: true,
		onClickCell: function (index, field, value) {
			var Row = IngrInpoDetailGrid.getRows()[index];
			if ((field == 'ExpDate') && (Row.ExpReq == "N")) {
				return false;
			}
			if ((field == 'BatchNo') && (Row.BatchReq == "N")) {
				return false;
			}
			if ((field == 'Rp') && (IngrParamObj.AllowAspWhileReceive == "Y")) {
				return false;
			}
			IngrInpoDetailGrid.commonClickCell(index, field, value);
		},
		onEndEdit: function (index, row, changes) {
			var Editors = $(this).datagrid('getEditors', index);
			for (var i = 0; i < Editors.length; i++) {
				var Editor = Editors[i];
				if (Editor.field == 'ExpDate') {
					var ExpReq = row.ExpReq;
					var ExpDate = row.ExpDate;
					var IncId = row.IncId;
					var NowDate = DateFormatter(new Date());
					if ((isEmpty(ExpDate)) && (ExpReq == "R")) {
						$UI.msg('alert', "有效期不可为空!");
						IngrInpoDetailGrid.checked = false;
						return false;
					}
					if ((!isEmpty(ExpDate)) && (FormatDate(NowDate) >= FormatDate(ExpDate))) {
						$UI.msg('alert', "有效期不能小于或等于当前日期!");
						IngrInpoDetailGrid.checked = false;
						return false;
					}
					if ((!isEmpty(ExpDate)) && (ExpReq == "R")){
						var ExpDateMsg = ExpDateValidator(ExpDate, IncId);
						if(!isEmpty(ExpDateMsg)){
							$UI.msg('alert', '第' + row + '行' + ExpDateMsg );
							IngrInpoDetailGrid.checked = false;
							return false;
						}
					}
				} else if (Editor.field == 'BatchNo') {
					var BatchReq = row.BatchReq;
					var BatchNo = row.BatchNo;
					if ((isEmpty(BatchNo)) && (BatchReq == "R")) {
						$UI.msg('alert', "批号不可为空!");
						IngrInpoDetailGrid.checked = false;
						return false;
					}
				} else if (Editor.field == 'Rp') {
					var rp = row.Rp;
					if (isEmpty(rp)) {
						$UI.msg('alert', "进价不能为空!");
						IngrInpoDetailGrid.checked = false;
						return false;
					} else if (rp < 0) {
						$UI.msg('alert', "进价不能小于零!");
						IngrInpoDetailGrid.checked = false;
						return false;
					} else if (rp == 0) {
						$UI.msg('alert', "进价等于零!");
					}
					var IncId = row.IncId;
					var UomId = row.IngrUomId;
					var sp = tkMakeServerCall('web.DHCSTMHUI.DHCINGdRec', 'GetSpForRec', IncId, UomId, rp, SessionParams);
					row.Sp = sp;
					//验证加成率
					var ChargeFlag = tkMakeServerCall('web.DHCSTMHUI.Common.DrugInfoCommon', 'GetChargeFlag', IncId);
					var margin = 0;
					if ((rp != 0) && (ChargeFlag == 'Y')) {
						margin = accSub(accDiv(sp, rp), 1);
						if ((IngrParamObj.MarginWarning != 0) && ((margin > IngrParamObj.MarginWarning) || (margin < 0))) {
							$UI.msg('alert', "加成率超出限定范围!");
							IngrInpoDetailGrid.checked = false;
							return false;
						}
					}

				} else if (Editor.field == 'RecQty') {
					var RecQty = row.RecQty;
					if ((isEmpty(RecQty)) || (RecQty <= 0)) {
						$UI.msg('alert', "入库数量不能小于或等于0!");
						IngrInpoDetailGrid.checked = false;
						return false;
					}
					var PurQty = row.PurQty;
					var ImpQty = row.ImpQty;
					if ((IngrParamObj.RecQtyExceedOrderAllowed != "Y") && (RecQty > (PurQty - ImpQty))) {
						$UI.msg('alert', "入库数量不能大于剩余订购数量!");
						IngrInpoDetailGrid.checked = false;
						return false;
					}
				}
			}
		}
	});
	function QueryInpoIngrInfo() {
		var ParamsObj = $UI.loopBlock('#PoConditions');
		if (isEmpty(ParamsObj.PoRecLoc)) {
			$UI.msg('alert', '入库科室不能为空!');
			return;
		}
		var Params = JSON.stringify(ParamsObj);
		$UI.clear(IngrInpoDetailGrid);
		$UI.setUrl(IngrInpoMainGrid);
		IngrInpoMainGrid.load({
			ClassName: 'web.DHCSTMHUI.INPO',
			QueryName: 'Query',
			Params: Params
		});
	}
	function CheckDataBeforeSave() {
		var ParamsObj = $UI.loopBlock('#PoConditions');
		var RecLoc = ParamsObj.PoRecLoc;
		var Row = IngrInpoMainGrid.getSelected();
		if (isEmpty(Row)) {
			$UI.msg('alert', '请选择要保存的单据!');
			return false;
		}
		var PoId = Row.PoId;
		var HVflag = GetCertDocHVFlag(PoId, "PO");
		if (HVflag == "Y") {
			$UI.msg('alert', '此订单为高值订单,请去高值生成条码界面导入订单,注册条码!');
			return false;
		}
		var Status = Row.PoStatus;
		if (Status == 2) {
			$UI.msg('alert', '该订单已经全部入库，不能再入库!');
			return false;
		}
		if (isEmpty(PoRecLoc)) {
			$UI.msg('alert', '请选择入库科室!');
			return false;
		}
		var RowsData = IngrInpoDetailGrid.getRowsData();
		if (RowsData == false) {
			return false;
		}
		if (RowsData.length == 0) {
			$UI.msg('alert', '此单据无明细！');
			return false;
		}
		// 有效行数
		var count = 0;
		for (var i = 0; i < RowsData.length; i++) {
			var item = RowsData[i].IncId;
			if (!isEmpty(item)) {
				count++;
			}
			var IncDesc = RowsData[i].IncDesc;
			var ExpReq = RowsData[i].ExpReq;
			var ExpDate = RowsData[i].ExpDate;
			var NowDate = DateFormatter(new Date());
			if ((isEmpty(ExpDate)) && (ExpReq == "R")) {
				$UI.msg('alert', "有效期不可为空!");
				return false;
			}
			if ((!isEmpty(ExpDate)) && (FormatDate(NowDate) >= FormatDate(ExpDate))) {
				$UI.msg('alert', "有效期不能小于或等于当前日期!");
				return false;
			}
			if ((!isEmpty(ExpDate)) && (ExpReq == "R")){
				var ExpDateMsg = ExpDateValidator(ExpDate, item);
				if(!isEmpty(ExpDateMsg)){
					$UI.msg('alert', '第' + row + '行' + ExpDateMsg );
					return false;
				}
			}
			var BatchReq = RowsData[i].BatchReq;
			var BatchNo = RowsData[i].BatchNo;
			if ((isEmpty(BatchNo)) && (BatchReq == "R")) {
				$UI.msg('alert', "批号不可为空!");
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
		var ParamsObj = $UI.loopBlock('#PoConditions');
		var SaveParamsObj = $UI.loopBlock('#PoSaveConditions');
		var RecLoc = ParamsObj.PoRecLoc;
		var SourceOfFund = SaveParamsObj.PoSourceOfFund;
		var Row = IngrInpoMainGrid.getSelected();
		var PoId = Row.PoId;
		var PurchaseUser = Row.PurUserId;
		var Vendor = Row.VenId;
		var StkGrpId = Row.StkGrpId;
		var ReqLocId = Row.ReqLoc;
		var Complete = "N";
		var AdjCheque = "N";
		var GiftFlag = "N";
		var Main = JSON.stringify(addSessionParams({ RecLoc: RecLoc, PurchaseUser: PurchaseUser, ApcvmDr: Vendor, StkGrpId: StkGrpId, SourceOfFund: SourceOfFund, ReqLocId: ReqLocId, Complete: Complete, AdjCheque: AdjCheque, GiftFlag: GiftFlag, PoId: PoId }));
		var DetailObj = IngrInpoDetailGrid.getRowsData();
		var Detail = JSON.stringify(DetailObj);
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			MethodName: 'jsSave',
			MainInfo: Main,
			ListData: Detail
		}, function (jsonData) {
			$UI.msg('alert', jsonData.msg);
			if (jsonData.success == 0) {
				var IngrRowid = jsonData.rowid;
				$UI.clear(IngrInpoDetailGrid);
				var UrlStr = 'dhcstmhui.ingdrec.csp?Rowid=' + IngrRowid;
				Common_AddTab('入库', UrlStr);
			}
		});
	}


	function InpoIngrClear() {
		$UI.clearBlock('#PoConditions');
		$UI.clearBlock('#PoSaveConditions');
		$UI.clear(IngrInpoMainGrid);
		$UI.clear(IngrInpoDetailGrid);
		var Dafult = {
			PoStartDate: DefaultStDate(),
			PoEndDate: DefaultEdDate(),
			PoRecLoc: gLocObj,
			Status: 0,
			AuditFlag: 1
		}
		$UI.fillBlock('#PoConditions', Dafult);
	}
	InpoIngrClear();

}
$(init);