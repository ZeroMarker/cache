/* �������ⵥ��ѯ���޸�*/
var init = function() {
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			QueryIngrInfo();
		}
	});
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			IngrClear();
		}
	});
	$UI.linkbutton('#UpadateBT', {
		onClick: function() {
			UpadateData();
		}
	});
	$UI.linkbutton('#UpVendBT', {
		onClick: function() {
			UpVendData();
		}
	});
	$UI.linkbutton('#CancelAuditBT', {
		onClick: function() {
			CancelAudit();
		}
	});
	function UpadateData() {
		var Row = InGdRecMainGrid.getSelected();
		if (isEmpty(Row)) {
			$UI.msg('alert', '��ѡ��Ҫ����ĵ���!');
			return false;
		}
		var MainObj = $UI.loopBlock('#FindConditions');
		var Main = JSON.stringify(MainObj);
		var DetailObj = InGdRecDetailGrid.getChangesData('RowId');
		if (DetailObj === false) {	// δ��ɱ༭����ϸΪ��
			return false;
		}
		if (isEmpty(DetailObj)) {	// ��ϸ����
			$UI.msg('alert', 'û����Ҫ�������ϸ!');
			return false;
		}
		var Detail = JSON.stringify(DetailObj);
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRecMod',
			MethodName: 'UpdateRecInfo',
			ListData: Detail
		}, function(jsonData) {
			hideMask();
			$UI.msg('alert', jsonData.msg);
			if (jsonData.success == 0) {
				QueryIngrInfo();
			}
		});
	}
	function UpVendData() {
		var MainObj = $UI.loopBlock('#FindConditions');
		var newVendorId = MainObj.FVendorBox;
		if (isEmpty(newVendorId)) {
			$UI.msg('alert', '��ѡ��Ӧ��!');
			return false;
		}
		var Row = InGdRecMainGrid.getSelected();
		if (isEmpty(Row)) {
			$UI.msg('alert', '��ѡ��Ҫ����ĵ���!');
			return false;
		}
		var oldVendorId = Row.Vendor;
		if (newVendorId == oldVendorId) {
			return false;
		}
		var IngrId = Row.IngrId;
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRecMod',
			MethodName: 'GrUpdateVen',
			IngrId: IngrId,
			VendorId: newVendorId
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				QueryIngrInfo();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	function CancelAudit() {
		var Row = InGdRecMainGrid.getSelected();
		if (isEmpty(Row)) {
			$UI.msg('alert', '��ѡ��Ҫȡ����˵ĵ���!');
			return false;
		}
		var IngrId = Row.IngrId;
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRecMod',
			MethodName: 'GrCancelAudit',
			IngrId: IngrId
		}, function(jsonData) {
			hideMask();
			$UI.msg('alert', jsonData.msg);
			if (jsonData.success == 0) {
				QueryIngrInfo();
			}
		});
	}
	$UI.linkbutton('#PrintBT', {
		onClick: function() {
			var Row = InGdRecMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ����Ҫ��ӡ����Ϣ!');
				return false;
			}
			var Rowid = Row.IngrId;
			PrintRec(Rowid);
		}
	});

	$UI.linkbutton('#PrintHVColBT', {
		onClick: function() {
			var Row = InGdRecMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ����Ҫ��ӡ����Ϣ!');
				return false;
			}
			var Rowid = Row.IngrId;
			PrintRecHVCol(Rowid);
		}
	});
	var FRecLocParams = JSON.stringify(addSessionParams({ Type: 'Login' }));
	var FRecLocBox = $HUI.combobox('#FRecLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + FRecLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var LocId = record['RowId'];
			if (CommParObj.ApcScg == 'L') {
				FVendorBox.clear();
				var Params = JSON.stringify(addSessionParams({ APCType: 'M', LocId: LocId }));
				var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + Params;
				FVendorBox.reload(url);
			}
		}
	});
	var FVendorBoxParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
	var FVendorBox = $HUI.combobox('#FVendorBox', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + FVendorBoxParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var PhManufacturerParams = JSON.stringify(addSessionParams({ StkType: 'M' }));
	var PhManufacturerBox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPhManufacturer&ResultSetType=array&Params=' + PhManufacturerParams,
			valueField: 'RowId',
			textField: 'Description',
			onBeforeLoad: function(param) {
				// var ScgId=GetParamsObj().StkGrpId;
				// param.ScgId =ScgId;
			}
		}
	};
	var InGdRecMainCm = [[
		{
			title: 'RowId',
			field: 'IngrId',
			width: 100,
			hidden: true
		}, {
			title: '��ⵥ��',
			field: 'IngrNo',
			width: 120
		}, {
			title: 'VenId',
			field: 'VenId',
			width: 200,
			hidden: true
		}, {
			title: '��Ӧ��',
			field: 'Vendor',
			width: 200
		}, {
			title: 'RecLocId',
			field: 'RecLocId',
			width: 100,
			hidden: true
		}, {
			title: '������',
			field: 'ReqLocDesc',
			width: 150
		}, {
			title: '��������',
			field: 'ReqLocDesc',
			width: 150
		}, {
			title: '������',
			field: 'AcceptUser',
			width: 70
		}, {
			title: '��������',
			field: 'CreateDate',
			width: 90
		}, {
			title: '�ɹ�Ա',
			field: 'PurchUser',
			width: 70
		}, {
			title: '��ɱ�־',
			field: 'Complete',
			width: 70
		}, {
			title: '���۽��',
			field: 'RpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '�ۼ۽��',
			field: 'SpAmt',
			width: 100,
			align: 'right'
		}
	]];
	
	var InGdRecMainGrid = $UI.datagrid('#InGdRecMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			QueryName: 'Query',
			query2JsonStrict: 1
		},
		columns: InGdRecMainCm,
		showBar: true,
		onSelect: function(index, row) {
			var VenId = row.VenId;
			var Vendor = row.Vendor;
			var VenObj = { RowId: VenId, Description: Vendor };
			$('#FVendorBox').combobox('setValue', VenId);
			InGdRecDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
				QueryName: 'QueryDetail',
				query2JsonStrict: 1,
				Parref: row.IngrId,
				rows: 99999
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	
	var InGdRecDetailCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 100,
			saveCol: true,
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'IncCode',
			width: 80
		}, {
			title: '��������',
			field: 'IncDesc',
			width: 230
		}, {
			title: '���',
			field: 'Spec',
			width: 180
		}, {
			title: '������',
			field: 'SpecDesc',
			width: 180,
			hidden: CodeMainParamObj.UseSpecList == 'Y' ? false : true
		}, {
			title: '��������',
			field: 'ManfId',
			width: 180,
			saveCol: true,
			formatter: CommonFormatter(PhManufacturerBox, 'ManfId', 'Manf'),
			editor: PhManufacturerBox
		}, {
			title: '����',
			field: 'BatchNo',
			width: 90,
			saveCol: true,
			editor: {
				type: 'text'
			}
		}, {
			title: '��Ч��',
			field: 'ExpDate',
			width: 100,
			saveCol: true,
			editor: {
				type: 'datebox'
			}
		}, {
			title: '����Ҫ��',
			field: 'BatchReq',
			width: 80,
			hidden: true
		}, {
			title: '��Ч��Ҫ��',
			field: 'ExpReq',
			width: 80,
			hidden: true
		}, {
			title: '��λ',
			field: 'IngrUom',
			width: 80
		}, {
			title: '����',
			field: 'RecQty',
			width: 80,
			align: 'right'
		}, {
			title: '����',
			field: 'Rp',
			width: 60,
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
			title: 'ע��֤��',
			field: 'AdmNo',
			width: 80,
			hidden: true
		}, {
			title: 'ע��֤��Ч��',
			field: 'AdmExpdate',
			width: 80,
			hidden: true
		}, {
			title: 'ժҪ',
			field: 'Remark',
			width: 60,
			hidden: true
		}, {
			title: '�ۼ�',
			field: 'Sp',
			width: 60,
			align: 'right',
			saveCol: true
		}, {
			title: '��Ʊ��',
			field: 'InvNo',
			width: 80,
			saveCol: true,
			editor: {
				type: 'text'
			}
		}, {
			title: '��Ʊ����',
			field: 'InvDate',
			width: 100,
			saveCol: true,
			editor: {
				type: 'datebox',
				options: {
				}
			}
		}, {
			title: '��Ʊ���',
			field: 'InvMoney',
			width: 80,
			align: 'right',
			saveCol: true,
			editor: {
				type: 'numberbox',
				options: {
					min: 0,
					precision: GetFmtNum('FmtRA')
				}
			}
		}, {
			title: '����ҽ������',
			field: 'MatInsuCode',
			width: 160
		}, {
			title: '����ҽ������',
			field: 'MatInsuDesc',
			width: 160
		}, {
			title: '���۽��',
			field: 'RpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '�ۼ۽��',
			field: 'SpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '���е���',
			field: 'SxNo',
			width: 90,
			saveCol: true,
			editor: {
				type: 'text'
			}
		}, {
			title: '��ֵ����',
			field: 'HVBarCode',
			width: 80
		}, {
			title: '�Դ�����',
			field: 'OrigiBarCode',
			width: 80
		}
	]];
	
	var InGdRecDetailGrid = $UI.datagrid('#InGdRecDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
			QueryName: 'QueryDetail',
			query2JsonStrict: 1,
			rows: 99999
		},
		pagination: false,
		columns: InGdRecDetailCm,
		showBar: true,
		onClickCell: function(index, field, value) {
			var Row = InGdRecDetailGrid.getRows()[index];
			if ((field == 'ExpDate') && (Row.ExpReq == 'N')) {
				return false;
			}
			if ((field == 'BatchNo') && (Row.BatchReq == 'N')) {
				return false;
			}
			InGdRecDetailGrid.commonClickCell(index, field, value);
		}
	});
	function QueryIngrInfo() {
		$UI.clear(InGdRecMainGrid);
		$UI.clear(InGdRecDetailGrid);
		var ParamsObj = $UI.loopBlock('#FindConditions');
		var StartDate = ParamsObj.StartDate;
		var EndDate = ParamsObj.EndDate;
		if (isEmpty(ParamsObj.FRecLoc)) {
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
		var Params = JSON.stringify(ParamsObj);
		InGdRecMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			QueryName: 'Query',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	function IngrClear() {
		$UI.clearBlock('#FindConditions');
		$UI.clear(InGdRecMainGrid);
		$UI.clear(InGdRecDetailGrid);
		var DefaultData = { StartDate: DefaultStDate(),
			EndDate: DefaultEdDate(),
			FRecLoc: gLocObj,
			AuditFlag: 'Y'
		};
		$UI.fillBlock('#FindConditions', DefaultData);
	}
	IngrClear();
	QueryIngrInfo();
};
$(init);