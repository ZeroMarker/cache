function GetSciItm() {
	var Clear = function() {
		$UI.clearBlock('#SciConditions');
		$UI.clear(SciGrid);
		var DefaultData = {
			SciStartDate: DateFormatter(new Date()),
			SciEndDate: DateFormatter(new Date()),
			CreatedFlag: 'N'
		};
		$UI.fillBlock('#SciWin', DefaultData);
	};
	$HUI.dialog('#SciWin', { width: gWinWidth, height: gWinHeight }).open();
	$UI.linkbutton('#SciQueryBT', {
		onClick: function() {
			NewItmSearch();
		}
	});
	
	function NewItmSearch() {
		var ParamsObj = $UI.loopBlock('#SciConditions');
		var Params = JSON.stringify(ParamsObj);
		SciGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCNewItm',
			QueryName: 'GetNewItm',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	$UI.linkbutton('#SciPickBT', {
		onClick: function() {
			SciPickFun();
		}
	});
	function SciPickFun() {
		if (isEmpty(SciGrid.getSelected())) {
			return;
		}
		var NIRowId = SciGrid.getSelected().NIRowId;
		var Inci = SciGrid.getSelected().Inci;
		if (!isEmpty(Inci)) {
			$UI.msg('alert', '�����ɿ��������ظ����ɣ�');
			return;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCNewItm',
			MethodName: 'GetItmDetail',
			RowId: NIRowId,
			HospId: GetHospId()
		}, function(jsonData) {
			$UI.clearBlock('#InciData');
			$UI.clearBlock('#ArcimData');
			$UI.fillBlock('#InciData', jsonData);
			// ע��, �˴������#ArcimData��ֵ, ���ܻ��ScMap���ó�ͻ;ͬʱ����ط��ƺ�������ȷ�Ƿ�����ScMap����;
			// �����Ҫ,����ͨ��ȫ�ֱ���,���߱������һ��������Inci��Ԫ��,���Կ���
			$HUI.dialog('#SciWin').close();
		});
	}
	
	$UI.linkbutton('#SciClearBT', {
		onClick: function() {
			Clear();
		}
	});
	$UI.linkbutton('#NewItmSynSCIBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#SciConditions');
			ParamsObj.BDPHospital = GetHospId();
			var Params = JSON.stringify(ParamsObj);
			showMask();
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCNewItm',
				MethodName: 'jsGetSpecifications',
				Params: Params
			}, function(jsonData) {
				hideMask();
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					NewItmSearch();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	var SciCm = [[
		{
			title: 'NIRowId',
			field: 'NIRowId',
			width: 150,
			hidden: true
		}, {
			title: 'Inci',
			field: 'Inci',
			width: 150,
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'InciCode',
			width: 150,
			hidden: true
		}, {
			title: '��������',
			field: 'InciDesc',
			width: 150,
			hidden: true
		}, {
			title: '����',
			field: 'NIDesc',
			width: 100
		}, {
			title: '���',
			field: 'NISpec',
			width: 55
		}, {
			title: '�ͺ�',
			field: 'NIModel',
			width: 55
		}, {
			title: 'Ʒ��',
			field: 'NIBrand',
			width: 55
		}, {
			title: '������λ',
			field: 'NIBUomDesc',
			width: 75
		}, {
			title: '��ⵥλ',
			field: 'NIPUomDesc',
			width: 75
		}, { title: '����',
			field: 'NIRpPUom',
			width: 55,
			align: 'right'
		}, {
			title: '���ڱ�־',
			field: 'NIImportFlag',
			width: 75,
			align: 'cenrer'
		}, {
			title: '��Ӧ��',
			field: 'NIVendorDesc',
			width: 70
		}, {
			title: '��������',
			field: 'NIManfDesc',
			width: 75
		}, {
			title: 'һ���Ա�־',
			field: 'NIBAflag',
			width: 90,
			align: 'cenrer'
		}, {
			title: '�ٲɱ�־',
			field: 'TemPurchase',
			width: 75,
			align: 'cenrer'
		}, {
			title: '���ɱ�־',
			field: 'CentralPurFlag',
			width: 75,
			align: 'cenrer'
		}, {
			title: '����Ҫ��',
			field: 'BatchReq',
			width: 75,
			align: 'cenrer'
		}, {
			title: 'Ч��Ҫ��',
			field: 'ExpReq',
			width: 75,
			align: 'cenrer'
		}
	]];
	var SciGrid = $UI.datagrid('#SciGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCNewItm',
			QueryName: 'GetNewItm',
			query2JsonStrict: 1
		},
		columns: SciCm,
		onDblClickRow: function(index, row) {
			SciPickFun();
		}
	});
	Clear();
	NewItmSearch();
}