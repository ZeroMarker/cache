// ����:�����ɹ���Ϣ
// ��д����:2022-08-24
function PurchaseInfo(Inci, PurNo) {
	$HUI.dialog('#PurchaseInfo', {
		width: gWinWidth,
		height: gWinHeight
	}).open();

	var SPurType = $HUI.combobox('#SPurType', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetDictVal&ResultSetType=array&Params=' + JSON.stringify(addSessionParams({ BDPHospital: GetHospId(), Type: 'PurType' })),
		valueField: 'RowId',
		textField: 'Description'
	});
	function Query() {
		$UI.clear(PurInfoHistoryGrid);
		PurInfoHistoryGrid.load({
			ClassName: 'web.DHCSTMHUI.PurchaseInfo',
			QueryName: 'GetPurInfoHistory',
			query2JsonStrict: 1,
			Inci: Inci
		});
	}
	$UI.linkbutton('#SavePurInfoBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#PurInfoConditions');
			ParamsObj.Inci = Inci;
			var PurStartDate = ParamsObj.PurStartDate;
			var PurEndDate = ParamsObj.PurEndDate;
			if ((!isEmpty(PurStartDate)) && (!isEmpty(PurEndDate)) && compareDate(PurStartDate, PurEndDate)) {
				$UI.msg('alert', '��ʼ���ڲ��ܴ��ڽ�ֹ����!');
				return;
			}
			var Params = JSON.stringify(ParamsObj);
			$.cm({
				ClassName: 'web.DHCSTMHUI.PurchaseInfo',
				MethodName: 'jsSave',
				Main: Params
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					SetDrugPurInfo();
					$HUI.dialog('#PurchaseInfo').close();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#NewPurInfoBT', {
		onClick: function() {
			$UI.clearBlock('#PurInfoConditions');
			$('#SPurNo').attr('readonly', false);
		}
	});
	
	function SetDrugPurInfo() {
		AddComboData($('#PurNo'), $('#PurInfoRowId').val(), $('#SPurNo').val());
		$('#PurNo').combobox('setValue', $('#PurInfoRowId').val());
		$('#PurType').combobox('setValue', $('#SPurType').combobox('getValue'));
		$('#PurDesc').val($('#SPurDesc').val());
		$('#PurStartDate').dateboxq('setValue', $('#SPurStartDate').dateboxq('getValue'));
		$('#PurEndDate').dateboxq('setValue', $('#SPurEndDate').dateboxq('getValue'));
		$('#PurQty').val($('#SPurQty').val());
	}
	function SetData() {
		$UI.clearBlock('#PurInfoConditions');
		$('#PurInfoRowId').val($('#PurNo').combobox('getValue'));
		$('#SPurNo').val($('#PurNo').combobox('getText'));
		$('#SPurType').combobox('setValue', $('#PurType').combobox('getValue'));
		$('#SPurDesc').val($('#PurDesc').val());
		$('#SPurStartDate').dateboxq('setValue', $('#PurStartDate').dateboxq('getValue'));
		$('#SPurEndDate').dateboxq('setValue', $('#PurEndDate').dateboxq('getValue'));
		$('#SPurQty').val($('#PurQty').val());
	}
	function ChangeState(PurNo) {
		if (!isEmpty(PurNo)) {
			$('#SPurNo').attr('readonly', true);
			SetData();
		} else {
			$UI.clearBlock('#PurInfoConditions');
			$('#SPurNo').attr('readonly', false);
		}
	}
	var PurInfoHistoryCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '�������',
			field: 'PurNo',
			width: 150
		}, {
			title: '��������',
			field: 'PurDesc',
			width: 180
		}, {
			title: '��������',
			field: 'PurType',
			width: 150
		}, {
			title: '��ʼ����',
			field: 'PurStartDate',
			width: 100
		}, {
			title: '��������',
			field: 'PurEndDate',
			width: 100
		}, {
			title: '��������',
			field: 'PurQty',
			width: 100
		}
	]];
	
	var PurInfoHistoryGrid = $UI.datagrid('#PurInfoHistoryGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.PurchaseInfo',
			QueryName: 'GetPurInfoHistory',
			query2JsonStrict: 1
		},
		columns: PurInfoHistoryCm,
		fitColumns: true,
		onClickRow: function(index, row) {
			PurInfoHistoryGrid.commonClickRow(index, row);
		}
	});
	Query(Inci);
	ChangeState(PurNo);
}