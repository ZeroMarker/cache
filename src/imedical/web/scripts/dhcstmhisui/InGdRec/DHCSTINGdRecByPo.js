/*��ⵥ�Ƶ�(���ݶ���)*/
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
	//Grid �� comboxData
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
				if (NewUomid == BUomId) { //��ⵥλת��Ϊ������λ
					var rp = row.Rp;
					var sp = row.Sp;
					row.Rp = Number(rp).div(confac);
					row.Sp = Number(sp).div(confac);
				} else { //������λת��Ϊ��ⵥλ
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
			title: "������",
			field: 'PoNo',
			width: 100
		}, {
			title: "�깺����",
			field: 'ReqLocDesc',
			width: 100
		}, {
			title: "��������",
			field: 'PoLocDesc',
			width: 100
		}, {
			title: "��Ӧ��",
			field: 'Vendor',
			width: 100
		}, {
			title: "����״̬",
			field: 'PoStatus',
			width: 100,
			formatter: function (v) {
				if (v == 0) { return "δ���" }
				else if (v == 1) { return "�������" }
				else { return "ȫ�����" }
			}
		}, {
			title: "��������",
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
			title: "�����ʼ�",
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
			title: "������",
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
			title: "���ʴ���",
			field: 'IncCode',
			width: 100
		}, {
			title: "��������",
			field: 'IncDesc',
			width: 100
		}, {
			title: "���",
			field: 'Spec',
			width: 100
		}, {
			title: "δ�������",
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
			title: "��λ",
			field: 'IngrUomId',
			width: 100,
			formatter: CommonFormatter(UomCombox, 'IngrUomId', 'IngrUom'),
			editor: UomCombox
		}, {
			title: "����",
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
			title: "��������",
			field: 'ManfId',
			width: 100,
			formatter: CommonFormatter(PhManufacturerBox, 'ManfId', 'Manf'),
			editor: PhManufacturerBox
		}, {
			title: "�ۼ�",
			field: 'Sp',
			width: 100,
			align: 'right'
		}, {
			title: "����",
			field: 'BatchNo',
			width: 80,
			editor: {
				type: 'text',
				options: {
				}
			}
		}, {
			title: "��Ч��",
			field: 'ExpDate',
			width: 80,
			editor: {
				type: 'datebox',
				options: {
				}
			}
		}, {
			title: "������λ",
			field: 'BUomId',
			width: 50,
			hidden: true
		}, {
			title: "ת����",
			field: 'ConFacPur',
			width: 100
		}, {
			title: "��������",
			field: 'PurQty',
			width: 100,
			align: 'right'
		}, {
			title: "������Ƶ�����",
			field: 'ImpQty',
			width: 100,
			align: 'right'
		}, {
			title: "����Ҫ��",
			field: 'BatchReq',
			width: 50,
			hidden: true
		}, {
			title: "��Ч��Ҫ��",
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
			title: "������",
			field: 'SpecDesc',
			width: 100,
			formatter: CommonFormatter(SpecDescbox, 'SpecDesc', 'SpecDesc'),
			editor: SpecDescbox
		}, {
			title: "ע��֤��",
			field: 'AdmNo',
			width: 90,
			editor: {
				type: 'text',
				options: {
				}
			}
		}, {
			title: "ע��֤��Ч��",
			field: 'AdmExpdate',
			width: 100,
			editor: {
				type: 'datebox',
				options: {
				}
			}
		}, {
			title: "��ֵ��־",
			field: 'HVFlag',
			width: 100
		}, {
			title: "���������",
			field: 'ImpQtyAudited',
			width: 100,
			align: 'right'
		}, {
			title: "��������",
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
						$UI.msg('alert', "��Ч�ڲ���Ϊ��!");
						IngrInpoDetailGrid.checked = false;
						return false;
					}
					if ((!isEmpty(ExpDate)) && (FormatDate(NowDate) >= FormatDate(ExpDate))) {
						$UI.msg('alert', "��Ч�ڲ���С�ڻ���ڵ�ǰ����!");
						IngrInpoDetailGrid.checked = false;
						return false;
					}
					if ((!isEmpty(ExpDate)) && (ExpReq == "R")){
						var ExpDateMsg = ExpDateValidator(ExpDate, IncId);
						if(!isEmpty(ExpDateMsg)){
							$UI.msg('alert', '��' + row + '��' + ExpDateMsg );
							IngrInpoDetailGrid.checked = false;
							return false;
						}
					}
				} else if (Editor.field == 'BatchNo') {
					var BatchReq = row.BatchReq;
					var BatchNo = row.BatchNo;
					if ((isEmpty(BatchNo)) && (BatchReq == "R")) {
						$UI.msg('alert', "���Ų���Ϊ��!");
						IngrInpoDetailGrid.checked = false;
						return false;
					}
				} else if (Editor.field == 'Rp') {
					var rp = row.Rp;
					if (isEmpty(rp)) {
						$UI.msg('alert', "���۲���Ϊ��!");
						IngrInpoDetailGrid.checked = false;
						return false;
					} else if (rp < 0) {
						$UI.msg('alert', "���۲���С����!");
						IngrInpoDetailGrid.checked = false;
						return false;
					} else if (rp == 0) {
						$UI.msg('alert', "���۵�����!");
					}
					var IncId = row.IncId;
					var UomId = row.IngrUomId;
					var sp = tkMakeServerCall('web.DHCSTMHUI.DHCINGdRec', 'GetSpForRec', IncId, UomId, rp, SessionParams);
					row.Sp = sp;
					//��֤�ӳ���
					var ChargeFlag = tkMakeServerCall('web.DHCSTMHUI.Common.DrugInfoCommon', 'GetChargeFlag', IncId);
					var margin = 0;
					if ((rp != 0) && (ChargeFlag == 'Y')) {
						margin = accSub(accDiv(sp, rp), 1);
						if ((IngrParamObj.MarginWarning != 0) && ((margin > IngrParamObj.MarginWarning) || (margin < 0))) {
							$UI.msg('alert', "�ӳ��ʳ����޶���Χ!");
							IngrInpoDetailGrid.checked = false;
							return false;
						}
					}

				} else if (Editor.field == 'RecQty') {
					var RecQty = row.RecQty;
					if ((isEmpty(RecQty)) || (RecQty <= 0)) {
						$UI.msg('alert', "�����������С�ڻ����0!");
						IngrInpoDetailGrid.checked = false;
						return false;
					}
					var PurQty = row.PurQty;
					var ImpQty = row.ImpQty;
					if ((IngrParamObj.RecQtyExceedOrderAllowed != "Y") && (RecQty > (PurQty - ImpQty))) {
						$UI.msg('alert', "����������ܴ���ʣ�ඩ������!");
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
			$UI.msg('alert', '�����Ҳ���Ϊ��!');
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
			$UI.msg('alert', '��ѡ��Ҫ����ĵ���!');
			return false;
		}
		var PoId = Row.PoId;
		var HVflag = GetCertDocHVFlag(PoId, "PO");
		if (HVflag == "Y") {
			$UI.msg('alert', '�˶���Ϊ��ֵ����,��ȥ��ֵ����������浼�붩��,ע������!');
			return false;
		}
		var Status = Row.PoStatus;
		if (Status == 2) {
			$UI.msg('alert', '�ö����Ѿ�ȫ����⣬���������!');
			return false;
		}
		if (isEmpty(PoRecLoc)) {
			$UI.msg('alert', '��ѡ��������!');
			return false;
		}
		var RowsData = IngrInpoDetailGrid.getRowsData();
		if (RowsData == false) {
			return false;
		}
		if (RowsData.length == 0) {
			$UI.msg('alert', '�˵�������ϸ��');
			return false;
		}
		// ��Ч����
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
				$UI.msg('alert', "��Ч�ڲ���Ϊ��!");
				return false;
			}
			if ((!isEmpty(ExpDate)) && (FormatDate(NowDate) >= FormatDate(ExpDate))) {
				$UI.msg('alert', "��Ч�ڲ���С�ڻ���ڵ�ǰ����!");
				return false;
			}
			if ((!isEmpty(ExpDate)) && (ExpReq == "R")){
				var ExpDateMsg = ExpDateValidator(ExpDate, item);
				if(!isEmpty(ExpDateMsg)){
					$UI.msg('alert', '��' + row + '��' + ExpDateMsg );
					return false;
				}
			}
			var BatchReq = RowsData[i].BatchReq;
			var BatchNo = RowsData[i].BatchNo;
			if ((isEmpty(BatchNo)) && (BatchReq == "R")) {
				$UI.msg('alert', "���Ų���Ϊ��!");
				return false;
			}
		}
		if (RowsData.length <= 0 || count <= 0) {
			$UI.msg('alert', '�������ϸ����!');
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
				Common_AddTab('���', UrlStr);
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