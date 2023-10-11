var init = function() {
	/* --��ť�¼�--*/
	
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			$UI.clear(PurMainGrid);
			$UI.clear(PurDetailGrid);
			var ParamsObj = $UI.loopBlock('#MainConditions');
			var StartDate = ParamsObj.StartDate;
			var EndDate = ParamsObj.EndDate;
			if (isEmpty(ParamsObj.PurLoc)) {
				$UI.msg('alert', '�ɹ����Ҳ���Ϊ��!');
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
			ParamsObj.CompFlag = 'Y';
			ParamsObj.Type = '1';
			var Params = JSON.stringify(ParamsObj);
			if (ParamsObj.AuditFlag == 'Y') {
				setAudit();
			} else {
				setUnAudit();
			}
			PurMainGrid.load({
				ClassName: 'web.DHCSTMHUI.INPurPlan',
				QueryName: 'Query',
				query2JsonStrict: 1,
				Params: Params
			});
		}
	});
	
	// ���ÿɱ༭�����disabled����
	function setUnAudit() {
		ChangeButtonEnable({ '#AduitBT': true, '#DenyBT': true });
	}
	function setAudit() {
		ChangeButtonEnable({ '#AduitBT': false, '#DenyBT': false });
	}
	function DefaultClear() {
		$UI.clearBlock('#MainConditions');
		$UI.clear(PurMainGrid);
		$UI.clear(PurDetailGrid);
		$HUI.combobox('#PurLoc').enable();
		ChangeButtonEnable({ '#AduitBT': true, '#DenyBT': true });
		Default();
	}
	
	$UI.linkbutton('#AduitBT', {
		onClick: function() {
			var Row = PurMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ��Ҫ��˵Ĳɹ��ƻ���!');
				return;
			}
			var Params = JSON.stringify(addSessionParams({ RowId: Row.RowId }));
			showMask();
			$.cm({
				ClassName: 'web.DHCSTMHUI.INPurPlan',
				MethodName: 'jsAudit',
				Params: Params
			}, function(jsonData) {
				hideMask();
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					$UI.clear(PurMainGrid);
					$UI.clear(PurDetailGrid);
					PurMainGrid.commonReload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#CancelAduitBT', {
		onClick: function() {
			var Row = PurMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ��Ҫȡ����˵Ĳɹ��ƻ���!');
				return;
			}
			var DHCPlanStatusDesc = Row.DHCPlanStatusDesc;
			if (DHCPlanStatusDesc == '') {
				$UI.msg('alert', 'δ��˵��ݲ�����ȡ�����!');
				return;
			}
			var Params = JSON.stringify(addSessionParams({ RowId: Row.RowId }));
			showMask();
			$.cm({
				ClassName: 'web.DHCSTMHUI.INPurPlan',
				MethodName: 'jsCancelAudit',
				Params: Params
			}, function(jsonData) {
				hideMask();
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					$UI.clear(PurMainGrid);
					$UI.clear(PurDetailGrid);
					PurMainGrid.commonReload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#DenyBT', {
		onClick: function() {
			if (!PurMainGrid.endEditing()) {
				return;
			}
			var Row = PurMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ��Ҫ�ܾ��Ĳɹ��ƻ���!');
				return;
			}
			if (isEmpty(Row.RefuseCase)) {
				$UI.msg('alert', '����д�ܾ�ԭ��!');
				return;
			}
			$UI.confirm('�Ƿ�ܾ����?', 'warning', '', Deny, '', '', '����', false);
		}
	});
	
	function Deny() {
		var Row = PurMainGrid.getSelected();
		var Params = JSON.stringify(addSessionParams({ RowId: Row.RowId, RefuseCase: Row.RefuseCase }));
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.INPurPlan',
			MethodName: 'jsDeny',
			Params: Params
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				$UI.clear(PurMainGrid);
				$UI.clear(PurDetailGrid);
				PurMainGrid.commonReload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			DefaultClear();
		}
	});
	$UI.linkbutton('#PrintBT', {
		onClick: function() {
			var Row = PurMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ��Ҫ��ӡ�Ĳɹ��ƻ���!');
				return;
			}
			PrintInPurPlan(Row.RowId);
		}
	});

	/* --�󶨿ؼ�--*/
	var PurLocBox = $HUI.combobox('#PurLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + PurLocParams,
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
	
	var VendorBox = $HUI.combobox('#Vendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var AuditBox = $HUI.combobox('#AuditFlag', {
		data: [{ 'RowId': '', 'Description': 'ȫ��' }, { 'RowId': 'N', 'Description': 'δ���' }, { 'RowId': 'Y', 'Description': '�����' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	
	/* --Grid--*/
	var PurDetailCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 80
		}, {
			title: '����ID',
			field: 'IncId',
			width: 100,
			hidden: true
		}, {
			title: '����',
			field: 'InciCode',
			width: 100
		}, {
			title: '����',
			field: 'InciDesc',
			width: 100
		}, {
			title: '���',
			field: 'Spec',
			width: 100
		}, {
			title: '������',
			field: 'SpecDesc',
			width: 100,
			hidden: CodeMainParamObj.UseSpecList == 'Y' ? false : true
		}, {
			title: '�ɹ�����',
			field: 'Qty',
			width: 80,
			align: 'right'
		}, {
			title: '��λ',
			field: 'UomDesc',
			width: 80
		}, {
			title: '����',
			field: 'Rp',
			width: 80,
			align: 'right'
		}, {
			title: '�ۼ�',
			field: 'Sp',
			width: 80,
			align: 'right'
		}, {
			title: '���۽��',
			field: 'RpAmt',
			width: 80,
			align: 'right'
		}, {
			title: '�ۼ۽��',
			field: 'SpAmt',
			width: 80,
			align: 'right'
		}, {
			title: '��������',
			field: 'ManfDesc',
			width: 100
		}, {
			title: '��Ӧ��',
			field: 'VendorDesc',
			width: 100
		}, {
			title: '������',
			field: 'CarrierDesc',
			width: 100
		}, {
			title: '�������',
			field: 'ReqLocDesc',
			width: 100
		}, {
			title: '������ҿ��',
			field: 'StkQty',
			width: 80,
			align: 'right'
		}, {
			title: '�������',
			field: 'MaxQty',
			width: 80,
			align: 'right'
		}, {
			title: '�������',
			field: 'MinQty',
			width: 80,
			align: 'right'
		}
	]];
	
	var PurDetailGrid = $UI.datagrid('#PurDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INPurPlanItm',
			QueryName: 'Query',
			query2JsonStrict: 1,
			rows: 99999
		},
		pagination: false,
		columns: PurDetailCm,
		showBar: true
	});
	
	var PurMainCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '�ƻ�����',
			field: 'PurNo',
			width: 160
		}, {
			title: '�ɹ�����',
			field: 'PurLoc',
			width: 150
		}, {
			title: '����',
			field: 'StkScg',
			width: 150
		}, {
			title: '�Ƶ�����',
			field: 'CreateDate',
			width: 100
		}, {
			title: '�Ƶ���',
			field: 'CreateUser',
			width: 100
		}, {
			title: '��ɱ�־',
			field: 'CompFlag',
			width: 100,
			formatter: function(value) {
				var status = '';
				if (value == 'Y') {
					status = '�����';
				} else {
					status = 'δ���';
				}
				return status;
			}
		}, {
			title: '���״̬',
			field: 'DHCPlanStatusDesc',
			width: 100,
			formatter: function(value) {
				var status = '';
				if (value == '') {
					status = 'δ���';
				} else {
					status = value;
				}
				return status;
			}
		}, {
			title: '�Ƿ������ɶ���',
			field: 'PoFlag',
			width: 120,
			formatter: function(value) {
				var status = '';
				if (value == 'Y') {
					status = '��';
				} else {
					status = '��';
				}
				return status;
			}
		}, {
			title: '�ܾ�ԭ��',
			field: 'RefuseCase',
			width: 100,
			necessary: true,
			editor: {
				type: 'text',
				options: {
					required: true
				}
			}
		}
	]];
	
	var PurMainGrid = $UI.datagrid('#PurMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INPurPlan',
			QueryName: 'Query',
			query2JsonStrict: 1
		},
		columns: PurMainCm,
		fitColumns: true,
		showBar: true,
		onClickRow: function(index, row) {
			PurMainGrid.commonClickRow(index, row);
		},
		onSelect: function(index, row) {
			PurDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.INPurPlanItm',
				QueryName: 'Query',
				query2JsonStrict: 1,
				PurId: row.RowId,
				rows: 99999
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				PurMainGrid.selectRow(0);
			}
		}
	});
	/* --���ó�ʼֵ--*/
	var Default = function() {
		// /���ó�ʼֵ ����ʹ������
		var DefaultValue = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate(),
			PurLoc: gLocObj,
			AuditFlag: 'N'
		};
		$UI.fillBlock('#MainConditions', DefaultValue);
	};
	Default();
	$('#QueryBT').click();
};
$(init);