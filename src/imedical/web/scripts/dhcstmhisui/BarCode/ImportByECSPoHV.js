var ImportECSPoSearch = function(Fn) {
	$HUI.dialog('#ImportBySciPo', { width: gWinWidth, height: gWinHeight }).open();
	
	$HUI.combobox('#SCIPoVendor', {
		valueField: 'RowId',
		textField: 'Description'
	});
	$HUI.combobox('#SCIPoReqLoc', {
		valueField: 'RowId',
		textField: 'Description'
	});

	$('#SCISxNo').bind('keydown', function(event) {
		if (event.keyCode == '13') {
			var SxNo = $(this).val();
			if (isEmpty(SxNo)) {
				return;
			}
			try {
				var SxNoObj = eval('(' + SxNo + ')');
				SxNo = SxNoObj['text'];
				if (!isEmpty(SxNo)) {
					$(this).val(SxNo);
				}
			} catch (e) {}
			SCIPoQuery();
		}
	});
	
	function SCIPoQuery() {
		var SxNo = $('#SCISxNo').val();
		if (isEmpty(SxNo)) {
			$UI.msg('alert', '���������е���!');
			return;
		}
		var HVFlag = 'Y';
		$.cm({
			ClassName: 'web.DHCSTMHUI.ServiceForECS',
			MethodName: 'getOrderDetail',
			SxNo: SxNo,
			HVFlag: HVFlag,
			HospId: gHospId
		}, function(jsonData) {
			if (jsonData['Main'] == undefined) {
				$UI.msg('alert', 'δ�ҵ������е�,��ȷ���Ƿ��Ǹ�ֵ����!');
				return;
			} else if (jsonData['Main'].PoState == 5) {
				$UI.msg('alert', '���͵��Ѿ�����,���ܵ���!');
				return;
			}
			if (jsonData.hasOwnProperty('Main') && jsonData.hasOwnProperty('Detail')) {
				$UI.fillBlock('#ImportBySciPo', jsonData['Main']);
				PoSciDetailGrid.loadData(jsonData['Detail']);
			} else {
				$UI.msg('alert', '�õ����Ѵ���!');
			}
		});
	}
	
	$UI.linkbutton('#PoSciClearBT', {
		onClick: function() {
			Clear();
		}
	});
	
	function Clear() {
		$UI.clearBlock('#SearchByPoSciConditions');
		$UI.clear(PoSciDetailGrid);
	}
	
	$UI.linkbutton('#PoSciQueryBT', {
		onClick: function() {
			SCIPoQuery();
		}
	});
	
	$UI.linkbutton('#PoSciReturnBT', {
		onClick: function() {
			SCIPoReg();
		}
	});
	
	function SCIPoReg() {
		var MainObj = {};
		MainObj['CreateLoc'] = $HUI.combobox('#CreateLoc').getValue();
		var MainInfo = JSON.stringify(addSessionParams(MainObj));
		var VendorId = $HUI.combobox('#SCIPoVendor').getValue();
		var RegRows = [];
		var Rows = PoSciDetailGrid.getRows();
		var Len = Rows.length;
		if (Len == 0) {
			$UI.msg('alert', 'û����Ҫ�������ϸ!');
			return;
		}
		for (var i = 0; i < Len; i++) {
			var Row = Rows[i];
			var RegRow = {};
			RegRow['InciId'] = Row['IncId'];
			RegRow['BarCode'] = Row['BarCode'];
			RegRow['Qty'] = Row['AvaBarcodeQty'];
			// RegRow['OriginalCode'] = Row['OriginalCode'];			//�Դ�����(Ψһ)
			RegRow['Inpoi'] = Row['PoItmId'];
			RegRow['BatchNo'] = Row['BatNo'];
			RegRow['ExpDate'] = Row['ExpDate'];
			// RegRow['SpecDesc'] = Row[''];
			RegRow['ProduceDate'] = Row['ProduceDate'];
			RegRow['CertNo'] = Row['CerNo'];
			RegRow['CertExpDate'] = Row['CerExpDate'];
			RegRow['Rp'] = Row['Rp'];
			RegRow['ManfId'] = Row['ManfId'];
			RegRow['Manf'] = Row['Manf'];
			RegRow['VendorId'] = VendorId;
			RegRow['OrderDetailSubId'] = Row['OrderDetailSubId'];
			// RegRow['SxNo'] = Row[''];
			RegRow['OldOriginalCode'] = Row['OriginalCode'];		// �Դ�����(��Ψһ)
			RegRow['BatchCode'] = Row['BatchCode'];
			RegRow['BatchCodeFlag'] = Row['BatchCodeFlag'];
			RegRows.push(RegRow);
		}
		var ListDetail = JSON.stringify(RegRows);
		
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			MethodName: 'jsRegHV',
			MainInfo: MainInfo,
			ListDetail: ListDetail
		}, function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				var RowIdStr = jsonData.rowid;
				Fn(RowIdStr);
				$UI.msg('success', jsonData.msg);
				$HUI.dialog('#ImportBySciPo').close();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	var PoSciDetailCm = [[
		{
			title: 'RowId',
			field: 'PoItmId',
			width: 100,
			hidden: true
		}, {
			title: '����id',
			field: 'IncId',
			width: 80,
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
			width: 100
		}, {
			title: '��ֵ����',
			field: 'BarCode',
			width: 200
		}, {
			title: '������',
			field: 'BatchCode',
			width: 200
		}, {
			title: '�Դ���',
			field: 'OriginalCode',
			width: 200
		}, {
			title: '��ֵ��־',
			field: 'HighValueFlag',
			formatter: BoolFormatter,
			width: 80
		}, {
			title: '����',
			field: 'AvaBarcodeQty',
			width: 90
		}, {
			title: '����',
			field: 'Rp',
			width: 100
		}, {
			title: '�ۼ�',
			field: 'Sp',
			width: 60
		}, {
			title: '��λ',
			field: 'PurUom',
			width: 80
		}, {
			title: '��������',
			field: 'PurQty',
			width: 90
		}, {
			title: '���������',
			field: 'ImpQty',
			width: 90
		}, {
			title: '����������',
			field: 'BarcodeQty',
			width: 90
		}, {
			title: 'ע��֤����',
			field: 'CerNo',
			width: 90
		}, {
			title: 'ע��֤Ч��',
			field: 'CerExpDate',
			width: 90
		}, {
			title: '����',
			field: 'BatNo',
			width: 90
		}, {
			title: 'Ч��',
			field: 'ExpDate',
			width: 90
		}, {
			title: 'SCI������Id',
			field: 'OrderDetailSubId',
			hidden: true,
			width: 100
		}, {
			title: '��������',
			field: 'ProduceDate',
			width: 90
		}, {
			title: '��������id',
			field: 'ManfId',
			width: 90,
			hidden: true
		}, {
			title: '��������',
			field: 'Manf',
			width: 90
		}, {
			title: '�������־',
			field: 'BatchCodeFlag',
			width: 90,
			align: 'center'
		}
	]];
	
	var PoSciDetailGrid = $UI.datagrid('#PoSciDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.ServiceForECS',
			MethodName: 'getOrderDetail'
		},
		columns: PoSciDetailCm
	});
	
	Clear();
};