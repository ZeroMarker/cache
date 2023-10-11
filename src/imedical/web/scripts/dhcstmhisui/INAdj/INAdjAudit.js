var init = function() {
	var Clear = function() {
		$UI.clearBlock('#Conditions');
		$UI.clear(AdjMainGrid);
		$UI.clear(AdjDetailGrid);
		SetDefValue();
	};
	function Query() {
		var ParamsObj = $UI.loopBlock('#Conditions');
		var StartDate = ParamsObj.StartDate;
		var EndDate = ParamsObj.EndDate;
		if (isEmpty(ParamsObj.AdjLoc)) {
			$UI.msg('alert', '�������Ҳ���Ϊ��!');
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
		AdjMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINAdj',
			QueryName: 'DHCINAdjM',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}

	});
	$UI.linkbutton('#AuditBT', {
		onClick: function() {
			var Row = AdjMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ��Ҫ��˵ĵ�����!');
				return;
			}
			var AdjId = Row.RowId;
			var Params = JSON.stringify(addSessionParams({
				RowId: AdjId
			}));
			showMask();
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINAdj',
				MethodName: 'JsAudit',
				Params: Params,
				AdjId: AdjId
			}, function(jsonData) {
				// $UI.msg('alert',jsonData.msg);
				if (jsonData.success == 0) {
					$UI.msg('success', '��˳ɹ�!');
					$UI.clear(AdjDetailGrid);
					AdjMainGrid.commonReload();
					if (InAdjParamObj['AutoPrintAfterAuditDAdj'] == 'Y') {
						PrintInAdj(AdjId);
					}
				} else {
					$UI.msg('error', jsonData.msg);
				}
				hideMask();
			});
		}
	});
	$UI.linkbutton('#CancelAuditBT', {
		onClick: function() {
			var Row = AdjMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ��Ҫȡ����˵ĵ�����!');
				return;
			}
			$UI.confirm('ȷ��ȡ�����?', '', '', CancelConfirmYes);
		}
	});
	function CancelConfirmYes() {
		var Row = AdjMainGrid.getSelected();
		var AdjId = Row.RowId;
		var Params = JSON.stringify(addSessionParams({
			RowId: AdjId
		}));
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINAdj',
			MethodName: 'JsCancelAudit',
			Params: Params,
			AdjId: AdjId
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', 'ȡ����˳ɹ�!');
				$UI.clear(AdjDetailGrid);
				AdjMainGrid.commonReload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
			hideMask();
		});
	}
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});
	$UI.linkbutton('#PrintBT', {
		onClick: function() {
			var Row = AdjMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', 'û����Ҫ��ӡ�ĵ���!');
				return;
			}
			var AdjId = Row.RowId;
			PrintInAdj(AdjId);
		}
	});
	var AdjLocParams = JSON.stringify(addSessionParams({
		Type: 'Login'
	}));
	if (InAdjParamObj.AllowAdjAllLoc == 'Y') {
		AdjLocParams = JSON.stringify(addSessionParams({
			Type: 'All'
		}));
	}
	var AdjLocBox = $HUI.combobox('#AdjLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + AdjLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var AdjMainCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 80,
			hidden: true
		}, {
			title: '��������',
			field: 'No',
			width: 180
		}, {
			title: '��������',
			field: 'AdjLocDesc',
			width: 150
		}, {
			title: '�Ƶ���',
			field: 'AdjUserName',
			width: 100
		}, {
			title: '�Ƶ�ʱ��',
			field: 'AdjDateTime',
			width: 150
		}, {
			title: '���״̬',
			field: 'Completed',
			width: 80
		}, {
			title: '��˱�־',
			field: 'chkFlag',
			width: 80
		}, {
			title: '�����',
			field: 'chkUserName',
			width: 100
		}, {
			title: '���ʱ��',
			field: 'chkDateTime',
			width: 150
		}, {
			title: '��ע',
			field: 'remarks',
			width: 140
		}, {
			title: '���۽��',
			field: 'RpAmt',
			align: 'right',
			width: 100
		}, {
			title: '�ۼ۽��',
			field: 'SpAmt',
			align: 'right',
			width: 100
		}
	]];
	var AdjMainGrid = $UI.datagrid('#AdjMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINAdj',
			QueryName: 'DHCINAdjM',
			query2JsonStrict: 1
		},
		columns: AdjMainCm,
		showBar: true,
		onSelect: function(index, row) {
			var Adjrowid = row['RowId'];
			var ParamsObj = {
				InAdj: Adjrowid
			};
			AdjDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINAdjItm',
				QueryName: 'DHCINAdjD',
				query2JsonStrict: 1,
				Params: JSON.stringify(ParamsObj),
				rows: 99999
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				AdjMainGrid.selectRow(0);
			}
		}
	});
	var AdjDetailCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 80,
			hidden: true
		}, {
			title: 'InciId',
			field: 'InciId',
			hidden: true,
			width: 60
		}, {
			title: 'Inclb',
			field: 'Inclb',
			hidden: true,
			width: 80
		}, {
			title: '���ʴ���',
			field: 'Code',
			width: 100
		}, {
			title: '��������',
			field: 'InciDesc',
			width: 150
		}, {
			title: '���',
			field: 'Spec',
			align: 'left',
			width: 100
		}, {
			title: '��������',
			field: 'ManfDesc',
			width: 100
		}, {
			title: '����~Ч��',
			field: 'BatExp',
			width: 200
		}, {
			title: '��������',
			field: 'Qty',
			align: 'right',
			width: 100
		}, {
			title: '��ֵ����',
			field: 'HvBarCode',
			width: 150
		}, {
			title: '��λ',
			field: 'uomDesc',
			align: 'left',
			width: 60
		}, {
			title: '����',
			field: 'Rp',
			align: 'right',
			width: 80
		}, {
			title: '���۽��',
			field: 'RpAmt',
			align: 'right',
			width: 100
		}, {
			title: '�ۼ�',
			field: 'Sp',
			align: 'right',
			width: 80
		}, {
			title: '�ۼ۽��',
			field: 'SpAmt',
			align: 'right',
			width: 100
		}
	]];
	var AdjDetailGrid = $UI.datagrid('#AdjDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINAdjItm',
			QueryName: 'DHCINAdjD',
			query2JsonStrict: 1,
			rows: 99999
		},
		pagination: false,
		columns: AdjDetailCm,
		showBar: true,
		remoteSort: false
	});
	function SetDefValue() {
		var DefaultValue = {
			StartDate: DateFormatter(new Date()),
			EndDate: DateFormatter(new Date()),
			AdjLoc: gLocObj,
			Complate: 'Y',
			Audit: 'N'
		};
		$UI.fillBlock('#Conditions', DefaultValue);
	}
	SetDefValue();
	Query();
};
$(init);