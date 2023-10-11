// ����:��汨�����
// �������ֵ��object
var InScrapParamObj = GetAppPropValue('DHCSTINSCRAPM');
var CodeMainParamObj = GetAppPropValue('DHCSTDRUGMAINTAINM');
var init = function() {
	var ClearMain = function() {
		$UI.clearBlock('#Conditions');
		$UI.clear(INScrapAuditGrid);
		$UI.clear(INScrapAuditDetailGrid);
		DefaultDataValue();
		$UI.fillBlock('#Conditions', DefaultDataValue);
	};
	// Grid �� comboxData
	var SupLocParams = JSON.stringify(addSessionParams({ Type: 'Login' }));
	if (InScrapParamObj.AllowSrapAllLoc == 'Y') {
		SupLocParams = JSON.stringify(addSessionParams({ Type: 'All' }));
	}
	var SupLocBox = $HUI.combobox('#SupLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + SupLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			$UI.clear(INScrapAuditDetailGrid);
			var ParamsObj = $UI.loopBlock('#Conditions');
			var StartDate = ParamsObj.StartDate;
			var EndDate = ParamsObj.EndDate;
			if (isEmpty(ParamsObj.SupLoc)) {
				$UI.msg('alert', '��Ӧ���Ҳ���Ϊ��!');
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
			INScrapAuditGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINScrap',
				QueryName: 'DHCINSpM',
				query2JsonStrict: 1,
				Params: Params
			});
		}
	});
	$UI.linkbutton('#AduitBT', {
		onClick: function() {
			var Row = INScrapAuditGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ����!');
				return;
			}
			var InStkTkParamObj = GetAppPropValue('DHCSTINSTKTKM');
			if (InStkTkParamObj.AllowBusiness != 'Y') {
				var Loc = Row['Loc'];
				var IfExistInStkTk = tkMakeServerCall('web.DHCSTMHUI.INStkTk', 'CheckInStkTkByLoc', Loc);
				if (IfExistInStkTk == 'Y') {
					$UI.msg('alert', '���Ҵ���δ��ɵ��̵㵥���������!');
					return false;
				}
			}
			var Params = JSON.stringify(addSessionParams({ Inscrap: Row.RowId }));
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINScrap',
				MethodName: 'Audit',
				Params: Params
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					$UI.clear(INScrapAuditGrid);
					$UI.clear(INScrapAuditDetailGrid);
					INScrapAuditGrid.commonReload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			ClearMain();
		}
	});
	$UI.linkbutton('#PrintBT', {
		onClick: function() {
			var SelectedRow = INScrapAuditGrid.getSelected();
			if (isEmpty(SelectedRow)) {
				$UI.msg('alert', 'û����Ҫ��ӡ�ĵ���!');
				return;
			}
			var Inscrap = SelectedRow['RowId'];
			PrintINScrap(Inscrap);
		}
	});
	var INScrapAuditGridCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '���𵥺�',
			field: 'No',
			width: 180,
			align: 'center',
			sortable: true
		}, {
			title: '��������',
			field: 'LocDesc',
			width: 150
		}, {
			title: '�Ƶ���',
			field: 'UserName',
			width: 100,
			align: 'left',
			sortable: true
		}, {
			title: '�Ƶ�����',
			field: 'Date',
			width: 100,
			align: 'left',
			sortable: true
		}, {
			title: '�Ƶ�ʱ��',
			field: 'Time',
			width: 100,
			align: 'left',
			sortable: true
		}, {
			title: '��ɱ�־',
			field: 'Completed',
			width: 80,
			align: 'center',
			formatter: BoolFormatter
		}, {
			title: '��˱�־',
			field: 'ChkFlag',
			width: 80,
			align: 'center',
			formatter: BoolFormatter
		}, {
			title: '�����',
			field: 'ChkUserName',
			width: 100
		}, {
			title: '�������',
			field: 'ChkDate',
			width: 100
		}, {
			title: '���ʱ��',
			field: 'ChkTime',
			width: 100
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
	var INScrapAuditGrid = $UI.datagrid('#INScrapAuditGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINScrap',
			QueryName: 'DHCINSpM',
			query2JsonStrict: 1
		},
		columns: INScrapAuditGridCm,
		showBar: true,
		onSelect: function(index, row) {
			INScrapAuditDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINScrapItm',
				QueryName: 'DHCINSpD',
				query2JsonStrict: 1,
				Inscrap: row.RowId,
				rows: 99999
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				INScrapAuditGrid.selectRow(0);
			}
		}
	});
	var INScrapAuditDetailGridCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 80
		}, {
			title: '����RowId',
			field: 'Inclb',
			width: 150,
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'InciCode',
			width: 100
		}, {
			title: '��������',
			field: 'InciDesc',
			width: 200,
			editor: 'text'
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
			title: '��ֵ��־',
			field: 'HVFlag',
			width: 60,
			hidden: true
		}, {
			title: '��ֵ����',
			field: 'HVBarCode',
			width: 150
		}, {
			title: '����~Ч��',
			field: 'BatExp',
			width: 150
		}, {
			title: '��������',
			field: 'Manf',
			width: 200
		}, {
			title: '��������',
			field: 'Qty',
			width: 60,
			align: 'right'
		}, {
			title: '��λrowid',
			field: 'PurUomId',
			width: 100,
			hidden: true
		}, {
			title: '��λ',
			field: 'PurUomDesc',
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
		}, {
			title: 'Loc',
			field: 'Loc',
			width: 10,
			hidden: true
		}
	]];
	var INScrapAuditDetailGrid = $UI.datagrid('#INScrapAuditDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINScrapItm',
			QueryName: 'DHCINSpD',
			query2JsonStrict: 1,
			rows: 99999
		},
		pagination: false,
		columns: INScrapAuditDetailGridCm,
		showBar: true
	});
	/* --���ó�ʼֵ--*/
	var DefaultDataValue = function() {
		var StDate = DateAdd(new Date(), 'd', parseInt(-7));
		var DefaultDataValue = {
			RowId: '',
			SupLoc: gLocObj,
			StartDate: DateFormatter(StDate),
			EndDate: DateFormatter(new Date()),
			Audit: 'N'
		};
		$UI.fillBlock('#Conditions', DefaultDataValue);
	};
	DefaultDataValue();
	$('#QueryBT').click();
};
$(init);