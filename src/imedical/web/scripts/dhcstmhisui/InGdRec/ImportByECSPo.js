/*
����ƽ̨�������
*/
var ImpByECSPoFN = function(Fn) {
	$HUI.dialog('#ImportBySCIPoWin', {
		width: gWinWidth,
		height: gWinHeight,
		onOpen: function() {
			SCIPoIngrClear();
		}
	}).open();
	$UI.linkbutton('#SCIPoQueryBT', {
		onClick: function() {
			QuerySCIPoIngrInfo();
		}
	});
	$UI.linkbutton('#SCIPoClearBT', {
		onClick: function() {
			SCIPoIngrClear();
		}
	});
	$UI.linkbutton('#SCIPoSaveBT', {
		onClick: function() {
			if (CheckDataBeforeSave()) {
				SCIPoIngrSave();
			}
		}
	});
	
	var SCIPoReqLocParams = JSON.stringify(addSessionParams({ Type: 'All' }));
	$HUI.combobox('#SCIPoReqLoc', {
		valueField: 'RowId',
		textField: 'Description'
	});
	var SCIPoVendorParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
	var SCIPoVendorBox = $HUI.combobox('#SCIPoVendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + SCIPoVendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var SCIPoLocParams = JSON.stringify(addSessionParams({ Type: 'Login' }));
	var SCIPoLocBox = $HUI.combobox('#SCIPoLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + SCIPoLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var IngrSCIPoDetailGridCm = [[
		{
			field: 'check',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'PoItmId',
			width: 50,
			alias: 'Inpoi',
			hidden: true
		}, {
			title: 'IncId',
			field: 'IncId',
			width: 50,
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'IncCode',
			width: 100
		}, {
			title: '��������',
			field: 'IncDesc',
			width: 100
		}, {
			title: '���',
			field: 'Spec',
			width: 100
		}, {
			title: '������',
			field: 'SpecDesc',
			width: 100
		}, {
			title: '����',
			field: 'AvaQty',
			width: 100,
			align: 'right',
			alias: 'RecQty'
		}, {
			title: 'PurUomId',
			field: 'PurUomId',
			width: 100,
			hidden: true,
			alias: 'IngrUomId'
		}, {
			title: '��λ',
			field: 'PurUom',
			width: 100 //, alias : 'IngrUom'
		}, {
			title: '����',
			field: 'Rp',
			width: 80,
			align: 'right'
		}, {
			title: '��������',
			field: 'Manf',
			width: 100
		}, {
			title: 'ManfId',
			field: 'ManfId',
			width: 100,
			hidden: true
		}, {
			title: '�ۼ�',
			field: 'Sp',
			width: 100,
			align: 'right'
		}, {
			title: '����',
			field: 'BatchNo',
			width: 80
		}, {
			title: '��Ч��',
			field: 'ExpDate',
			width: 80
		}, {
			title: '������λ',
			field: 'BUomId',
			width: 50,
			hidden: true
		}, {
			title: 'ת����',
			field: 'ConFac',
			width: 100,
			alias: 'ConFacPur'
		}, {
			title: '��������',
			field: 'PurQty',
			width: 100,
			align: 'right'
		}, {
			title: '���������',
			field: 'ImpQty',
			width: 100,
			align: 'right'
		}, {
			title: '����Ҫ��',
			field: 'BatchReq',
			width: 50,
			hidden: true
		}, {
			title: '��Ч��Ҫ��',
			field: 'ExpReq',
			width: 50,
			hidden: true
		}, {
			title: 'ע��֤��',
			field: 'CerNo',
			width: 90
		}, {
			title: 'ע��֤��Ч��',
			field: 'CerExpDate',
			width: 100
		}, {
			title: '��ֵ��־',
			field: 'HighValueFlag',
			width: 100,
			alias: 'HVFlag'
		}
	]];
	var IngrSCIPoDetailGrid = $UI.datagrid('#IngrSCIPoDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.ServiceForECS',
			QueryName: 'getOrderDetail',
			query2JsonStrict: 1
		},
		columns: IngrSCIPoDetailGridCm,
		showBar: true,
		singleSelect: false,
		remoteSort: false,
		pagination: false
	});
	function QuerySCIPoIngrInfo() {
		var ParamsObj = $UI.loopBlock('#SCIPoSearchConditions');
		if (isEmpty(ParamsObj['PoSXNo'])) {
			$UI.msg('alert', '���е��Ų���Ϊ��!');
			return false;
		}
		SCIPoIngrClear();
		$.cm({
			ClassName: 'web.DHCSTMHUI.ServiceForECS',
			MethodName: 'getOrderDetail',
			SxNo: ParamsObj['PoSXNo'],
			HVFlag: 'N',
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
				$UI.fillBlock('#SCIPoConditions', jsonData['Main']);
				IngrSCIPoDetailGrid.loadData(jsonData['Detail']);
			} else {
				$UI.msg('alert', '�õ����Ѵ���!');
			}
		});
	}
	function CheckDataBeforeSave() {
		var RowsData = IngrSCIPoDetailGrid.getRows();
		// ��Ч����
		var count = 0;
		for (var i = 0; i < RowsData.length; i++) {
			var item = RowsData[i].IncId;
			if (!isEmpty(item)) {
				count++;
			}
		}
		if (RowsData.length <= 0 || count <= 0) {
			$UI.msg('alert', '����ϸ����!');
			return false;
		}
		return true;
	}
	function SCIPoIngrSave() {
		var ParamsObj = $UI.loopBlock('#SCIPoConditions');
		var RecLoc = ParamsObj['SCIPoLoc'];
		var PoId = ParamsObj.PoId; // ������ʾ��������id
		var HVflag = GetCertDocHVFlag(PoId, 'PO');
		if (HVflag == 'Y') {
			$UI.msg('alert', '�˶���Ϊ��ֵ����,��ȥ��ֵ����������浼�붩��!');
			return false;
		}
		var Vendor = ParamsObj.SCIPoVendor;
		var Main = JSON.stringify(addSessionParams({ RecLoc: RecLoc, ApcvmDr: Vendor }));
		var DetailObj = IngrSCIPoDetailGrid.getSelectedData();
		if (DetailObj.length == 0) {
			$UI.msg('alert', '��ѡ�񶩵���ϸ!');
			return false;
		}
		var Detail = JSON.stringify(DetailObj);
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			MethodName: 'jsSave',
			MainInfo: Main,
			ListData: Detail
		}, function(jsonData) {
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				var IngrRowid = jsonData.rowid;
				$HUI.dialog('#ImportBySCIPoWin').close();
				if (IngrParamObj.AutoPrintAfterSave == 'Y') {
					PrintRec(IngrRowid, 'Y');
				}
				Fn(IngrRowid);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	function SCIPoIngrClear() {
		$UI.clearBlock('#SCIPoSearchConditions');
		$UI.clearBlock('#SCIPoConditions');
		$UI.clear(IngrSCIPoDetailGrid);
	}
	SCIPoIngrClear();
};