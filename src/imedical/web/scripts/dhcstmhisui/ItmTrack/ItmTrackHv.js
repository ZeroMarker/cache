/* ȷ��*/
var init = function() {
	var Clear = function() {
		$UI.clearBlock('#FindConditions');
		$UI.clear(BarMainGrid);
		$UI.clear(BarDetailGrid);
		// /���ó�ʼֵ ����ʹ������
		var DefaultData = {
			StartDate: TrackDefaultStDate(),
			EndDate: TrackDefaultEdDate()
		};
		$UI.fillBlock('#FindConditions', DefaultData);
	};
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});
	$UI.linkbutton('#ConfirmBT', {
		onClick: function() {
			var Selected = BarMainGrid.getSelectedData();
			if (Selected.length == 0) {
				$UI.msg('alert', '��ѡ��!!');
				return;
			}
			var BarCode = Selected[0].BarCode;
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCItmTrack',
				MethodName: 'SaveHv',
				label: BarCode
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	var BarMainCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: 'InciId',
			field: 'InciId',
			width: 120,
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'InciCode',
			width: 150
		}, {
			title: '��������',
			field: 'InciDesc',
			width: 150
		}, {
			title: '����',
			field: 'BarCode',
			width: 200
		}, {
			title: '�Դ�����',
			field: 'OriginalCode',
			width: 200
		}, {
			title: '״̬',
			field: 'Status',
			formatter: StatusFormatter,
			width: 70
		}, {
			title: '����id',
			field: 'BatNo',
			width: 90,
			hidden: true
		}, {
			title: '����~Ч��',
			field: 'BatExp',
			width: 100
		}, {
			title: '���',
			field: 'Spec',
			width: 120
		}, {
			title: '������',
			field: 'SpecDesc',
			width: 120,
			hidden: CodeMainParamObj.UseSpecList == 'Y' ? false : true
		}, {
			title: '��λ',
			field: 'UomDesc',
			width: 80
		}, {
			title: '��Ӧ��',
			field: 'VendorDesc',
			width: 180
		}, {
			title: '��������',
			field: 'ManfDesc',
			width: 100
		}, {
			title: 'ȷ��',
			field: 'RetOriFlag',
			width: 100
		}, {
			title: '��������(ע��)����',
			field: 'DhcitDate',
			width: 150
		}, {
			title: '��������(ע��)ʱ��',
			field: 'DhcitTime',
			width: 150
		}, {
			title: '������',
			field: 'DhcitUser',
			width: 100
		}
	]];
	var BarMainGrid = $UI.datagrid('#BarMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			QueryName: 'Query',
			query2JsonStrict: 1
		},
		columns: BarMainCm,
		showBar: true,
		onSelect: function(index, row) {
			BarDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCItmTrack',
				QueryName: 'QueryItmTrackItem',
				query2JsonStrict: 1,
				Parref: row.RowId
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	
	var BarDetailCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '����',
			field: 'Type',
			formatter: TypeRenderer,
			width: 80
		}, {
			title: 'Pointer',
			field: 'Pointer',
			width: 80,
			hidden: true
		}, {
			title: '̨�˱��',
			field: 'IntrFlag',
			width: 80
		}, {
			title: '�����',
			field: 'OperNo',
			width: 150
		}, {
			title: 'ҵ��������',
			field: 'Date',
			width: 180
		}, {
			title: 'ҵ����ʱ��',
			field: 'Time',
			width: 180
		}, {
			title: 'ҵ�������',
			field: 'User',
			width: 100
		}, {
			title: 'λ����Ϣ',
			field: 'OperOrg',
			width: 150
		}
	]];
	
	var BarDetailGrid = $UI.datagrid('#BarDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			QueryName: 'QueryItmTrackItem',
			query2JsonStrict: 1
		},
		columns: BarDetailCm,
		showBar: true
	});
	function Query() {
		var ParamsObj = $UI.loopBlock('#FindConditions');
		var StartDate = ParamsObj.StartDate;
		var EndDate = ParamsObj.EndDate;
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
		$UI.clear(BarDetailGrid);
		BarMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			QueryName: 'Query',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	
	Clear();
	Query();
};
$(init);