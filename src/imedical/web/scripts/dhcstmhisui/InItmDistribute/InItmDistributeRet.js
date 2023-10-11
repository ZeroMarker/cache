var init = function() {
	var Params = JSON.stringify(addSessionParams());
	$HUI.combobox('#WardLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetWardLoc&ResultSetType=array&Params=' + Params,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	$('#PatNo').bind('keydown', function(event) {
		if (event.keyCode == 13) {
			var PatNo = $(this).val();
			if (isEmpty(PatNo)) {
				$UI.msg('alert', '������ǼǺ�!');
				return false;
			}
			try {
				var patinfostr = tkMakeServerCall('web.DHCSTMHUI.HVMatOrdItm', 'Pa', PatNo);
				var patinfoarr = patinfostr.split('^');
				var newPaAdmNo = patinfoarr[0];
				$('#PatNo').val(newPaAdmNo);
			} catch (e) {}
		}
	});
	$UI.linkbutton('#AlQueryBT', {
		onClick: function() {
			FindRetWin();
		}
	});
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		$UI.clear(RetGrid);
		var ParamsObj = $UI.loopBlock('#MainConditions');
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
		RetGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCInMatRet',
			QueryName: 'QueryInMatNeedRet',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	
	function DefaultClear() {
		$UI.clearBlock('#MainConditions');
		$UI.clear(RetGrid);
		Default();
	}
	
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			DefaultClear();
		}
	});
	
	$UI.linkbutton('#RetBT', {
		onClick: function() {
			var DetailRowsData = RetGrid.getSelections();
			if (DetailRowsData.length == 0) {
				$UI.msg('alert', '��ѡ����˻ز�����Ϣ��');
				return false;
			}
			var Detail = JSON.stringify(DetailRowsData);
			
			showMask();
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCInMatRet',
				MethodName: 'jsInMatRet',
				Main: Params,
				Detail: Detail
			}, function(jsonData) {
				hideMask();
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					$('#PatNo').val('');
					Query();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	
	/* --Grid--*/
	// /�����б�
	var RetGridCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'DMainId',
			field: 'DMainId',
			width: 60,
			hidden: true
		}, {
			title: 'DDetailId',
			field: 'DDetailId',
			width: 60,
			hidden: true
		}, {
			title: 'DspId',
			field: 'DspId',
			width: 60,
			hidden: true
		}, {
			title: '����',
			field: 'WardLocId',
			width: 80,
			hidden: true
		}, {
			title: '����',
			field: 'WardLocDesc',
			width: 150
		}, {
			title: '�ǼǺ�',
			field: 'PatNo',
			width: 80
		}, {
			title: '����',
			field: 'BedNo',
			width: 60
		}, {
			title: '����',
			field: 'PatName',
			width: 100
		}, {
			title: '�����id',
			field: 'InciId',
			width: 150,
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
			title: '��λ',
			field: 'UomDesc',
			width: 80
		}, {
			title: '��������',
			field: 'DspQty',
			width: 80,
			align: 'right'
		}, {
			title: '���˻�����',
			field: 'AlRetQty',
			width: 100,
			align: 'right'
		}, {
			title: '���˻�����',
			field: 'RetQty',
			width: 100,
			align: 'right'/*,
			editor: {
				type: 'numberbox',
				options: {
					
				}
			}*/
		}, {
			title: '��������',
			field: 'DispDate',
			width: 100
		}, {
			title: '����ʱ��',
			field: 'DispTime',
			width: 150
		}, {
			title: '���ŵ���',
			field: 'DispNo',
			width: 150
		}
	]];

	var RetGrid = $UI.datagrid('#RetGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCInMatRet',
			QueryName: 'QueryInMatNeedRet',
			query2JsonStrict: 1
		},
		selectOnCheck: true,
		checkOnSelect: true,
		singleSelect: false,
		showBar: true,
		columns: RetGridCm,
		onClickRow: function(index, row) {
			RetGrid.commonClickRow(index, row);
		}
	});
	
	/* --���ó�ʼֵ--*/
	var Default = function() {
		// /���ó�ʼֵ ����ʹ������
		var StartDate = DateAdd(new Date(), 'd', -5);
		var EndDate = DateAdd(new Date(), 'd', 3);
		var DefaultValue = {
			StartDate: DateFormatter(StartDate),
			EndDate: DateFormatter(EndDate)
		};
		$UI.fillBlock('#MainConditions', DefaultValue);
	};
	Default();
	Query();
};
$(init);
function PrintDispRet(RowId) {
	if (isEmpty(RowId)) {
		return;
	}
	var RaqName = 'DHCSTM_HUI_InItmDispRetCol.raq';
	var fileName = '{' + RaqName + '(Parref=' + RowId + ')}';
	// alert(DispId)
	// alert(fileName)
	// DHCCPM_RQDirectPrint(fileName);  //ֱ�Ӵ�ӡ
	var transfileName = TranslateRQStr(fileName);
	DHCSTM_DHCCPM_RQPrint(transfileName);
	// var transfileName = TranslateRQStr(fileName);
	// DHCSTM_DHCCPM_RQPrint(transfileName);
	// Common_PrintLog('DP', DispId, "");
}