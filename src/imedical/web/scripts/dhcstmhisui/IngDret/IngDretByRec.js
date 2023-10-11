var init = function() {
	var Clear = function() {
		$UI.clearBlock('#Conditions');
		$UI.clear(MainGrid);
		$UI.clear(DetailGrid);
		var DefaultData = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate(),
			RetLoc: gLocObj
		};
		$UI.fillBlock('#Conditions', DefaultData);
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
				var rows = DetailGrid.getRows();
				var row = rows[DetailGrid.editIndex];
				if (!isEmpty(row)) {
					param.Inci = row.IncId;
				}
			},
			onSelect: function(record) {
				var rows = DetailGrid.getRows();
				var row = rows[DetailGrid.editIndex];
				row.UomDesc = record.Description;
				var NewUomid = record.RowId;
				var OldUomid = row.Uom;
				if (isEmpty(NewUomid) || (NewUomid == OldUomid)) {
					return false;
				}
				var BUomId = row.BUomId;
				var Rp = row.Rp;
				var StkQty = row.StkQty;
				var Qty = row.Qty;
				var Sp = row.Sp;
				var RpAmt = row.RpAmt;
				var SpAmt = row.SpAmt;
				var confac = row.ConFac;
				if (NewUomid == BUomId) { // ��ⵥλת��Ϊ������λ
					row.Rp = Number(Rp).div(confac);
					row.Sp = Number(Sp).div(confac);
					if (!isEmpty(StkQty)) {
						row.StkQty = Number(StkQty).mul(confac);
					}
				} else { // ������λת��Ϊ��ⵥλ
					row.Rp = Number(Rp).mul(confac);
					row.Sp = Number(Sp).mul(confac);
					if (!isEmpty(StkQty)) {
						row.StkQty = Number(StkQty).div(confac);
					}
				}
				row.Uom = NewUomid;
				setTimeout(function() {
					DetailGrid.refreshRow();
				}, 0);
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
				var rows = DetailGrid.getRows();
				var row = rows[DetailGrid.editIndex];
				row.Reason = record.Description;
			}
		}
	};
	var SelReqHandlerParams = function() {
		var Obj = { StkGrpType: 'M' };
		return Obj;
	};
	$('#InciDesc').lookup(InciLookUpOp(SelReqHandlerParams, '#InciDesc', '#InciId'));
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#Conditions');
			var StartDate = ParamsObj.StartDate;
			var EndDate = ParamsObj.EndDate;
			if (isEmpty(ParamsObj.RetLoc)) {
				$UI.msg('alert', '���Ҳ���Ϊ��!');
				return;
			}
			if (isEmpty(StartDate)) {
				$UI.msg('alert', '��ʼ���ڲ���Ϊ��!');
				return;
			}
			if (isEmpty(EndDate)) {
				$UI.msg('alert', '��ֹ���ڲ���Ϊ��!');
				return;
			}
			if (compareDate(StartDate, EndDate)) {
				$UI.msg('alert', '��ֹ���ڲ���С�ڿ�ʼ����!');
				return;
			}
			var InciDesc = $HUI.lookup('#InciDesc').getText();
			ParamsObj.InciDesc = InciDesc;
			var Params = JSON.stringify(ParamsObj);
			$UI.clear(DetailGrid);
			MainGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINGdRetAuxByRec',
				QueryName: 'QueryIngrForRet',
				query2JsonStrict: 1,
				Params: Params
			});
		}
	});
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			Save();
		}
	});
	
	function CheckDataBeforeSave() {
		if (!DetailGrid.endEditing()) {
			return false;
		}
		var RowsData = DetailGrid.getSelections();
		if (RowsData.length == 0) {
			$UI.msg('alert', 'û��Ҫ�������ϸ!');
			return false;
		}
		for (var i = 0, Len = RowsData.length; i < Len; i++) {
			var Row = RowsData[i];
			var RowIndex = DetailGrid.getRowIndex(Row);
			var ReasonId = Row['ReasonId'];
			var Qty = Row['Qty'];
			if (isEmpty(Qty)) {
				$UI.msg('alert', '��' + (RowIndex + 1) + '����������Ϊ��!');
				return false;
			}
			if (IngrtParamObj['AllowSaveReasonEmpty'] != 'Y' && isEmpty(ReasonId)) {
				$UI.msg('alert', '��' + (RowIndex + 1) + '���˻�ԭ����Ϊ��!');
				return false;
			}
			var HVFlag = Row['HVFlag'];
			var Inci = Row['IncId'];
			var BatchCodeFlag = tkMakeServerCall('web.DHCSTMHUI.Common.DrugInfoCommon', 'GetBatchCodeFlag', Inci);
			if (HVFlag == 'Y' && BatchCodeFlag == 'N' && Qty > 1) {
				$UI.msg('alert', '��' + (RowIndex + 1) + '�и�ֵ�����˻��������ܴ���1!');
				return false;
			}
		}
		return true;
	}
	
	var Save = function() {
		if (CheckDataBeforeSave() == false) {
			return;
		}
		var MainObj = $UI.loopBlock('#Conditions');
		var Selected = MainGrid.getSelections();
		if (Selected.length == 0) {
			$UI.msg('alert', '��ѡ��Ҫ���������!!');
			return;
		}
		MainObj = $.extend(true, MainObj, Selected[0]);
		var Main = JSON.stringify(MainObj);
		
		var DetailObj = DetailGrid.getSelections();
		if (DetailObj === false) {
			return;
		} else if (DetailObj.length == 0) {
			$UI.msg('alert', 'û����Ҫ�������ϸ!');
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
				$UI.clear(DetailGrid);
				$UI.msg('success', jsonData.msg);
				var checkedRadioJObj = $("input[name='HvFlag']:checked");
				if (checkedRadioJObj.val() != 'Y') {
					var UrlStr = 'dhcstmhui.ingdret.csp?gIngrtId=' + jsonData.rowid;
				} else {
					var UrlStr = 'dhcstmhui.ingdrethv.csp?gIngrtId=' + jsonData.rowid;
				}
				Common_AddTab('�˻����Ƶ�', UrlStr);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	};
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});

	var RetLocParams = JSON.stringify(addSessionParams({ Type: 'Login' }));
	var RetLocBox = $HUI.combobox('#RetLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + RetLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var LocId = record['RowId'];
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

	var MainCm = [[
		{
			title: 'IngrId',
			field: 'IngrId',
			width: 100,
			hidden: true
		}, {
			title: '��ⵥ��',
			field: 'IngrNo',
			width: 150
		}, {
			title: '��Ӧ��',
			field: 'VendorDesc',
			width: 150
		}, {
			title: '������',
			field: 'RecLoc',
			width: 150
		}, {
			title: '����',
			field: 'StkGrpDesc',
			width: 120
		}
	]];

	var MainGrid = $UI.datagrid('#MainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRetAuxByRec',
			QueryName: 'QueryIngrForRet',
			query2JsonStrict: 1
		},
		columns: MainCm,
		showBar: true,
		onSelect: function(index, row) {
			DetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINGdRetAuxByRec',
				QueryName: 'QueryIngrDetailForRet',
				query2JsonStrict: 1,
				Parref: row.IngrId,
				rows: 9999
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});

	var DetailCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: '�����ϸid',
			field: 'Ingri',
			width: 100,
			hidden: true
		}, {
			title: '����RowId',
			field: 'IncId',
			width: 100,
			hidden: true
		}, {
			title: '����RowId',
			field: 'Inclb',
			width: 100,
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'IncCode',
			width: 100
		}, {
			title: '��������',
			field: 'IncDesc',
			width: 150
		}, {
			title: '�˻�����',
			field: 'Qty',
			width: 80,
			align: 'right',
			editor: {
				type: 'numberbox',
				options: {
					min: 0,
					precision: GetFmtNum('FmtQTY')
				}
			}
		}, {
			title: '��λ',
			field: 'Uom',
			width: 60,
			formatter: CommonFormatter(UomCombox, 'Uom', 'UomDesc'),
			editor: UomCombox
		}, {
			title: '�˻�ԭ��',
			field: 'ReasonId',
			formatter: CommonFormatter(ReasonCombox, 'ReasonId', 'Reason'),
			editor: ReasonCombox,
			width: 100
		}, {
			title: '�˻�����',
			field: 'Rp',
			width: 80,
			align: 'right'
		}, {
			title: '��ֵ��־',
			field: 'HVFlag',
			width: 80,
			align: 'center',
			formatter: BoolFormatter
		}, {
			title: '��ֵ����',
			field: 'HvBarCode',
			width: 150
		}, {
			title: '����~Ч��',
			field: 'BatExp',
			width: 150
		}, {
			title: '���ο��',
			field: 'StkQty',
			width: 80,
			align: 'right'
		}, {
			title: '���۽��',
			field: 'RpAmt',
			width: 80,
			align: 'right'
		}, {
			title: '��������',
			field: 'Manf',
			width: 100,
			align: 'left'
		}, {
			title: 'ռ������',
			field: 'DirtyQty',
			width: 80,
			align: 'right'

		}, {
			title: '��������',
			field: 'AvaQty',
			width: 80,
			align: 'right'
		}, {
			title: '�ۼ�',
			field: 'Sp',
			width: 80,
			align: 'right',
			hidden: true
		}, {
			title: '�ۼ۽��',
			field: 'SpAmt',
			width: 80,
			align: 'right',
			hidden: true
		}, {
			title: 'ת����',
			field: 'ConFac',
			width: 80,
			align: 'right',
			hidden: true
		}, {
			title: '������λ',
			field: 'BUomId',
			width: 100,
			hidden: true,
			align: 'left'
		}
	]];
	var DetailGrid = $UI.datagrid('#DetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRetAuxByRec',
			QueryName: 'QueryIngrDetailForRet',
			query2JsonStrict: 1
		},
		columns: DetailCm,
		pagination: false,
		showBar: true,
		singleSelect: false,
		checkOnSelect: true,
		onClickRow: function(index, row) {
			DetailGrid.commonClickRow(index, row);
		},
		onEndEdit: function(index, row, changes) {
			var Editors = $(this).datagrid('getEditors', index);
			for (var i = 0; i < Editors.length; i++) {
				var Editor = Editors[i];
				if (Editor.field == 'Qty') {
					var Qty = Number(row.Qty);
					var StkQty = Number(row.StkQty);
					if (Qty > StkQty) {
						$UI.msg('alert', '�˻��������ܴ��ڿ������!');
						DetailGrid.checked = false;
						return false;
					} else {
						row.RpAmt = accMul(Qty, row.Rp);
						row.SpAmt = accMul(Qty, row.Sp);
					}
				}
			}
		}
	});
	Clear();
	$('#QueryBT').click();
};
$(init);