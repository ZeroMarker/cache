/*
依据平台订单入库
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
			title: '物资代码',
			field: 'IncCode',
			width: 100
		}, {
			title: '物资名称',
			field: 'IncDesc',
			width: 100
		}, {
			title: '规格',
			field: 'Spec',
			width: 100
		}, {
			title: '具体规格',
			field: 'SpecDesc',
			width: 100
		}, {
			title: '数量',
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
			title: '单位',
			field: 'PurUom',
			width: 100 //, alias : 'IngrUom'
		}, {
			title: '进价',
			field: 'Rp',
			width: 80,
			align: 'right'
		}, {
			title: '生产厂家',
			field: 'Manf',
			width: 100
		}, {
			title: 'ManfId',
			field: 'ManfId',
			width: 100,
			hidden: true
		}, {
			title: '售价',
			field: 'Sp',
			width: 100,
			align: 'right'
		}, {
			title: '批号',
			field: 'BatchNo',
			width: 80
		}, {
			title: '有效期',
			field: 'ExpDate',
			width: 80
		}, {
			title: '基本单位',
			field: 'BUomId',
			width: 50,
			hidden: true
		}, {
			title: '转换率',
			field: 'ConFac',
			width: 100,
			alias: 'ConFacPur'
		}, {
			title: '订购数量',
			field: 'PurQty',
			width: 100,
			align: 'right'
		}, {
			title: '已入库数量',
			field: 'ImpQty',
			width: 100,
			align: 'right'
		}, {
			title: '批号要求',
			field: 'BatchReq',
			width: 50,
			hidden: true
		}, {
			title: '有效期要求',
			field: 'ExpReq',
			width: 50,
			hidden: true
		}, {
			title: '注册证号',
			field: 'CerNo',
			width: 90
		}, {
			title: '注册证号效期',
			field: 'CerExpDate',
			width: 100
		}, {
			title: '高值标志',
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
			$UI.msg('alert', '随行单号不能为空!');
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
				$UI.msg('alert', '未找到此随行单,请确定是否是高值订单!');
				return;
			} else if (jsonData['Main'].PoState == 5) {
				$UI.msg('alert', '配送单已经撤销,不能导入!');
				return;
			}
			if (jsonData.hasOwnProperty('Main') && jsonData.hasOwnProperty('Detail')) {
				$UI.fillBlock('#SCIPoConditions', jsonData['Main']);
				IngrSCIPoDetailGrid.loadData(jsonData['Detail']);
			} else {
				$UI.msg('alert', '该单据已处理!');
			}
		});
	}
	function CheckDataBeforeSave() {
		var RowsData = IngrSCIPoDetailGrid.getRows();
		// 有效行数
		var count = 0;
		for (var i = 0; i < RowsData.length; i++) {
			var item = RowsData[i].IncId;
			if (!isEmpty(item)) {
				count++;
			}
		}
		if (RowsData.length <= 0 || count <= 0) {
			$UI.msg('alert', '无明细数据!');
			return false;
		}
		return true;
	}
	function SCIPoIngrSave() {
		var ParamsObj = $UI.loopBlock('#SCIPoConditions');
		var RecLoc = ParamsObj['SCIPoLoc'];
		var PoId = ParamsObj.PoId; // 隐藏显示订单主表id
		var HVflag = GetCertDocHVFlag(PoId, 'PO');
		if (HVflag == 'Y') {
			$UI.msg('alert', '此订单为高值订单,请去高值生成条码界面导入订单!');
			return false;
		}
		var Vendor = ParamsObj.SCIPoVendor;
		var Main = JSON.stringify(addSessionParams({ RecLoc: RecLoc, ApcvmDr: Vendor }));
		var DetailObj = IngrSCIPoDetailGrid.getSelectedData();
		if (DetailObj.length == 0) {
			$UI.msg('alert', '请选择订单明细!');
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