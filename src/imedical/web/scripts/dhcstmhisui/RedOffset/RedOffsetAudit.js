/* ��嵥���*/
var init = function() {
	// ������
	var RedLocParams = JSON.stringify(addSessionParams({
		Type: 'Login',
		Element: 'RedLoc',
		onSelect: function(record) {
			var LocId = record['RowId'];
			if (CommParObj.ApcScg == 'L') {
				VendorBox.clear();
				var Params = JSON.stringify(addSessionParams({ APCType: 'M', LocId: LocId }));
				var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + Params;
				VendorBox.reload(url);
			}
		}
	}));
	var RedLocBox = $HUI.combobox('#RedLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + RedLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var LocId = record['RowId'];
			$('#CreateUser').combobox('clear');
			$('#CreateUser').combobox('reload', $URL
				+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetDeptUser&ResultSetType=Array&Params='
				+ JSON.stringify({ LocDr: LocId })
			);
		}
	});
	// ��Ӧ��
	var VendorParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
	var VendorBox = $HUI.combobox('#Vendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	// �Ƶ���
	var CreateUser = $HUI.combobox('#CreateUser', {
		url: $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetDeptUser&ResultSetType=Array&Params='
			+ JSON.stringify({ LocDr: gLocId }),
		valueField: 'RowId',
		textField: 'Description'
	});
	var HandlerParams = function() {
		var Obj = { StkGrpType: 'M' };
		return Obj;
	};
	$('#InciDesc').lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#Inci'));
	$('#RedNo').bind('keydown', function(event) {
		if (event.keyCode == 13) {
			QueryRedInfo();
		}
	});
	
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			QueryRedInfo();
		}
	});
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});
	var RedMainCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '��嵥��',
			field: 'RedNo',
			width: 200
		}, {
			title: '������',
			field: 'RedLoc',
			width: 200
		}, {
			title: '��Ӧ��',
			field: 'Vendor',
			width: 200
		}, {
			title: '������',
			field: 'CreateUser',
			width: 100
		}, {
			title: '��������',
			field: 'CreateDate',
			width: 100
		}, {
			title: '�����',
			field: 'AuditUser',
			width: 100
		}, {
			title: '�������',
			field: 'AuditDate',
			width: 100
		}, {
			title: 'CompFlag',
			field: 'CompFlag',
			width: 10,
			hidden: true
		}, {
			title: 'AuditFlag',
			field: 'AuditFlag',
			width: 10,
			hidden: true
		}
	]];
	var RedMainGrid = $UI.datagrid('#RedMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.RedOffset',
			QueryName: 'Query',
			query2JsonStrict: 1
		},
		columns: RedMainCm,
		fitColumns: true,
		showBar: true,
		singleSelect: false,
		onSelect: function(index, row) {
			RedDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.RedOffsetItm',
				QueryName: 'QueryDetail',
				query2JsonStrict: 1,
				Parref: row.RowId,
				rows: 99999
			});
		},
		onLoadSuccess: function(data) {
			if ((data.rows.length > 0) && (CommParObj.IfSelFirstRow == 'Y')) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});

	var RedDetailCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'InciCode',
			width: 80
		}, {
			title: '��������',
			field: 'InciDesc',
			width: 160
		}, {
			title: '���',
			field: 'Spec',
			width: 80
		}, {
			title: '��������',
			field: 'Manf',
			width: 180
		}, {
			title: '����id',
			field: 'Inclb',
			width: 70,
			hidden: true
		}, {
			title: '����',
			field: 'BatchNo',
			width: 90
		}, {
			title: '��Ч��',
			field: 'ExpDate',
			width: 100
		}, {
			title: '��λ',
			field: 'Uom',
			width: 80
		}, {
			title: '�������',
			field: 'Qty',
			width: 80,
			align: 'right'
		}, {
			title: '�½���',
			field: 'NewRp',
			width: 60,
			align: 'right'
		}, {
			title: '���ۼ�',
			field: 'NewSp',
			width: 60,
			align: 'right'
		}, {
			title: '�½��۽��',
			field: 'NewRpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '���ۼ۽��',
			field: 'NewSpAmt',
			width: 100,
			align: 'right'
		}, {
			title: 'ԭ����',
			field: 'OldRp',
			width: 60,
			align: 'right'
		}, {
			title: 'ԭ�ۼ�',
			field: 'OldSp',
			width: 60,
			align: 'right'
		}, {
			title: 'ԭ���۽��',
			field: 'OldRpAmt',
			width: 100,
			align: 'right'
		}, {
			title: 'ԭ�ۼ۽��',
			field: 'OldSpAmt',
			width: 100,
			align: 'right'
		}
	]];

	var RedDetailGrid = $UI.datagrid('#RedDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.RedOffsetItm',
			QueryName: 'QueryDetail',
			query2JsonStrict: 1,
			rows: 99999
		},
		pagination: false,
		columns: RedDetailCm,
		showBar: true,
		onClickRow: function(index, row) {
			RedDetailGrid.commonClickRow(index, row);
		}
	});
	var Clear = function() {
		$UI.clearBlock('#FindConditions');
		$UI.clear(RedMainGrid);
		$UI.clear(RedDetailGrid);
		// ���ó�ʼֵ ����ʹ������
		var Dafult = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate(),
			RedLoc: gLocObj,
			CompFlag: 'Y',
			AuditFlag: 'N'
		};
		$UI.fillBlock('#FindConditions', Dafult);
	};
	function QueryRedInfo() {
		$UI.clear(RedMainGrid);
		$UI.clear(RedDetailGrid);
		var ParamsObj = $UI.loopBlock('#FindConditions');
		if (isEmpty(ParamsObj.StartDate)) {
			$UI.msg('alert', '��ʼ���ڲ���Ϊ��!');
			return false;
		}
		if (isEmpty(ParamsObj.EndDate)) {
			$UI.msg('alert', '��ֹ���ڲ���Ϊ��!');
			return false;
		}
		if (isEmpty(ParamsObj.RedLoc)) {
			$UI.msg('alert', '�����Ҳ���Ϊ��!');
			return false;
		}
		var Params = JSON.stringify(ParamsObj);
		RedMainGrid.load({
			ClassName: 'web.DHCSTMHUI.RedOffset',
			QueryName: 'Query',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	$UI.linkbutton('#AuditBT', {
		onClick: function() {
			if (CheckDataBeforeAudit()) {
				Audit();
			}
		}
	});
	function CheckDataBeforeAudit() {
		var RowsData = RedMainGrid.getSelections();
		if ((isEmpty(RowsData)) || (RowsData.length == 0)) {
			$UI.msg('alert', '��ѡ����Ҫ��˵ĵ���!');
			return false;
		}
		for (var i = 0; i < RowsData.length; i++) {
			var AuditFlag = RowsData[i].AuditFlag;
			var RedNo = RowsData[i].RedNo;
			if (AuditFlag == 'Y') {
				$UI.msg('alert', RedNo + '��嵥�����!');
				return false;
			}
		}
		return true;
	}
	function Audit() {
		var RowData = RedMainGrid.getSelections();
		var RedIdStr = '';
		for (var i = 0; i < RowData.length; i++) {
			var RowId = RowData[i].RowId;
			if (RedIdStr == '') {
				RedIdStr = RowId;
			} else {
				RedIdStr = RedIdStr + '^' + RowId;
			}
		}
		if (RedIdStr == '') {
			$UI.msg('alert', 'û����Ҫ��˵ĵ���!');
			return false;
		}
		var Params = JSON.stringify(sessionObj);
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.RedOffset',
			MethodName: 'jsAudit',
			RedIdStr: RedIdStr,
			Params: Params
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				QueryRedInfo();
				var info = jsonData.msg;
				var infoArr = info.split('@');
				var Allcnt = infoArr[0];
				var Succnt = infoArr[1];
				var failcnt = Allcnt - Succnt;
				var ErrInfo = infoArr[2];
				$UI.msg('success', '��:' + Allcnt + '��¼,�ɹ�:' + Succnt + '��');
				if (failcnt > 0) {
					$UI.msg('error', 'ʧ��:' + failcnt + '��;' + ErrInfo);
				}
			}
		});
	}
	Clear();
	QueryRedInfo();
};
$(init);