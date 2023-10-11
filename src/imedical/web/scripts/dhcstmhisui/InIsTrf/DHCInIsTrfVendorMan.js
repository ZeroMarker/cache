var ReqMainCm, ReqDetailCm, ReqItmsCmm, InitMainCm, InitDetailCm;
var ReqMainGrid, ReqDetailGrid, ReqItmsGrid, InitMainGrid, InitDetailGrid;
var init = function() {
	var IngrLocParams = JSON.stringify(addSessionParams({
		Type: 'Login'
	}));
	var IngrLocBox = $HUI.combobox('#IngrLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + IngrLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var LocId = record['RowId'];
			$HUI.combotree('#ScgStk').setFilterByLoc(LocId);
		}
	});

	ReqMainCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 50,
			saveCol: true,
			hidden: true
		}, {
			title: '请求单号',
			field: 'ReqNo',
			width: 150
		}, {
			title: '请求部门',
			field: 'RecLoc',
			width: 100
		}, {
			title: '类组',
			field: 'ScgDesc',
			width: 100
		}, {
			title: '制单人',
			field: 'UserName',
			width: 80
		}, {
			title: '制单日期',
			field: 'Date',
			width: 100
		}, {
			title: '制单时间',
			field: 'Time',
			width: 80
		}
	]];

	ReqMainGrid = $UI.datagrid('#ReqMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfVendorManage',
			QueryName: 'ReqList',
			query2JsonStrict: 1
		},
		columns: ReqMainCm,
		singleSelect: false,
		onSelect: function(index, row) {
			ReqDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINIsTrfVendorManage',
				QueryName: 'ReqItmList',
				query2JsonStrict: 1,
				Req: row.RowId,
				rows: 99999
			});
		},
		onLoadSuccess: function(data) {
			if ((data.rows.length > 0) && (CommParObj.IfSelFirstRow == 'Y')) {
				ReqMainGrid.selectRow(0);
			}
		}
	});

	ReqDetailCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			saveCol: true,
			hidden: true
		}, {
			title: 'IncId',
			field: 'IncId',
			width: 50,
			hidden: true
		}, {
			title: '物资代码',
			field: 'InciCode',
			width: 150
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width: 200
		}, {
			title: '规格',
			field: 'Spec',
			width: 100
		}, {
			title: '单位',
			field: 'ReqUomDesc',
			width: 80
		}, {
			title: '本科室数量',
			field: 'LocQty',
			width: 80,
			align: 'right'
		}, {
			title: '请求数量',
			field: 'ReqQty',
			width: 80,
			align: 'right'
		}, {
			title: '批准数量',
			field: 'ApprovedQty',
			width: 80,
			saveCol: true,
			align: 'right',
			editor: {
				type: 'numberbox',
				options: {
					required: true,
					tipPosition: 'bottom',
					min: 0,
					precision: GetFmtNum('FmtQTY')
				}
			}
		}, {
			title: '已转移数量',
			field: 'TransQty',
			width: 80,
			align: 'right'
		}
	]];
	
	function savecheck() {
		if (!ReqDetailGrid.endEditing()) {
			return false;
		}
		var rowsData = ReqDetailGrid.getRows();
		for (var i = 0; i < rowsData.length; i++) {
			var row = rowsData[i];
			var ApprovedQty = row.ApprovedQty;
			if (ApprovedQty < 0) {
				$UI.msg('alert', '第' + (i + 1) + '行批准数量不能小于0');
				return false;
			}
		}
		return true;
	}
	function DetailSave() {
		if (savecheck() == true) {
			var Details = ReqDetailGrid.getChangesData('RowId');
			$.cm({
				ClassName: 'web.DHCSTMHUI.INReqItm',
				MethodName: 'jsModifyQtyApproved',
				Details: JSON.stringify(Details)
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					ReqDetailGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	}

	ReqDetailGrid = $UI.datagrid('#ReqDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfVendorManage',
			QueryName: 'ReqItmList',
			query2JsonStrict: 1,
			rows: 99999
		},
		pagination: false,
		columns: ReqDetailCm,
		toolbar: [{
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				DetailSave();
			}
		}],
		onClickRow: function(index, row) {
			ReqDetailGrid.commonClickRow(index, row);
		}
	});

	ReqItmsCm = [[
		{
			title: 'IncId',
			field: 'IncId',
			width: 50,
			saveCol: true,
			hidden: true
		}, {
			title: '物资代码',
			field: 'InciCode',
			width: 150
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width: 150
		}, {
			title: '规格',
			field: 'Spec',
			width: 80
		}, {
			title: '型号',
			field: 'Model',
			width: 80
		}, {
			title: '单位',
			field: 'ReqUomId',
			width: 60,
			saveCol: true,
			hidden: true
		}, {
			title: '单位',
			field: 'ReqUomDesc',
			width: 60
		}, {
			title: '批准数量',
			field: 'ApprovedQty',
			width: 80,
			align: 'right'
		}, {
			title: '已转移数量',
			field: 'TransQty',
			width: 80,
			align: 'right'
		}, {
			title: '本次配送数量',
			field: 'Qty',
			width: 100,
			align: 'right',
			saveCol: true,
			editor: {
				type: 'numberbox',
				options: {
					min: 0,
					precision: GetFmtNum('FmtQTY')
				}
			}
		}, {
			title: '批号',
			field: 'BatNo',
			width: 100,
			saveCol: true,
			editor: {
				type: 'validatebox'
			}
		}, {
			title: '效期',
			field: 'ExpDate',
			width: 100,
			saveCol: true,
			editor: {
				type: 'datebox'
			}
		}, {
			title: '进价',
			field: 'Rp',
			width: 80,
			saveCol: true,
			align: 'right'
		}, {
			title: '售价',
			field: 'Sp',
			width: 80,
			saveCol: true,
			align: 'right'
		}, {
			title: '供应商ID',
			field: 'Vendor',
			width: 50,
			saveCol: true,
			hidden: true
		}, {
			title: '供应商',
			field: 'VendorDesc',
			width: 150
		}, {
			title: '生产厂家ID',
			field: 'Manf',
			width: 50,
			saveCol: true,
			hidden: true
		}, {
			title: '生产厂家',
			field: 'ManfDesc',
			width: 150
		}, {
			title: '请求单明细Id',
			field: 'ReqItmStr',
			width: 50,
			saveCol: true,
			hidden: true
		}, {
			title: '批号要求',
			field: 'BatReq',
			width: 50,
			hidden: true
		}, {
			title: '效期要求',
			field: 'ExpReq',
			width: 50,
			hidden: true
		}
	]];

	ReqItmsGrid = $UI.datagrid('#ReqItmsGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfVendorManage',
			QueryName: 'SumReqItm',
			query2JsonStrict: 1
		},
		columns: ReqItmsCm,
		pagination: false,
		onClickRow: function(index, row) {
			ReqItmsGrid.commonClickRow(index, row);
		}
	});

	InitMainCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '库存转移单号',
			field: 'InitNo',
			width: 150
		}, {
			title: '供应科室',
			field: 'FrLoc',
			width: 100
		}, {
			title: '请求科室',
			field: 'ToLoc',
			width: 100
		}, {
			title: '制单日期',
			field: 'InitDate',
			width: 80
		}, {
			title: '制单时间',
			field: 'InitTime',
			width: 80
		}, {
			title: '类组',
			field: 'ScgDesc',
			width: 80
		}
	]];

	InitMainGrid = $UI.datagrid('#InitMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfVendorManage',
			QueryName: 'InitByDstr',
			query2JsonStrict: 1
		},
		columns: InitMainCm,
		onSelect: function(index, row) {
			InitDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
				QueryName: 'DHCINIsTrfDetail',
				query2JsonStrict: 1,
				init: row.RowId
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				InitMainGrid.selectRow(0);
			}
		}
	});

	InitDetailCm = [[
		{
			title: 'initi',
			field: 'initi',
			width: 50,
			hidden: true
		}, {
			title: 'inci',
			field: 'inci',
			width: 50,
			hidden: true
		}, {
			title: '物资代码',
			field: 'inciCode',
			width: 150
		}, {
			title: '物资名称',
			field: 'inciDesc',
			width: 200
		}, {
			title: '规格',
			field: 'spec',
			width: 100
		}, {
			title: '批号~效期',
			field: 'batexp',
			width: 150
		}, {
			title: '单位',
			field: 'TrUomDesc',
			width: 80
		}, {
			title: '转移数量',
			field: 'qty',
			width: 80,
			align: 'right'
		}, {
			title: '进价',
			field: 'rp',
			width: 80,
			align: 'right'
		}, {
			title: '售价',
			field: 'sp',
			width: 80,
			align: 'right'
		}, {
			title: '进价金额',
			field: 'rpAmt',
			width: 80,
			align: 'right'
		}, {
			title: '售价金额',
			field: 'spAmt',
			width: 80,
			align: 'right'
		}
	]];

	InitDetailGrid = $UI.datagrid('#InitDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
			QueryName: 'DHCINIsTrfDetail',
			query2JsonStrict: 1
		},
		columns: InitDetailCm
	});

	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#Conditions');
			var StartDate = ParamsObj.StartDate;
			var EndDate = ParamsObj.EndDate;
			if (isEmpty(ParamsObj.IngrLoc)) {
				$UI.msg('alert', '科室不能为空!');
				return;
			}
			if (isEmpty(StartDate)) {
				$UI.msg('alert', '开始日期不能为空!');
				return;
			}
			if (isEmpty(EndDate)) {
				$UI.msg('alert', '截止日期不能为空!');
				return;
			}
			if (compareDate(StartDate, EndDate)) {
				$UI.msg('alert', '截止日期不能小于开始日期!');
				return;
			}
			var Params = JSON.stringify(ParamsObj);
			ReqMainGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINIsTrfVendorManage',
				QueryName: 'ReqList',
				query2JsonStrict: 1,
				Params: Params
			});
		}
	});

	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			$UI.clearBlock('#Conditions');
			$UI.clear(ReqMainGrid);
			$UI.clear(ReqDetailGrid);
			$UI.clear(ReqItmsGrid);
			$UI.clear(InitMainGrid);
			$UI.clear(InitDetailGrid);
			SetDefaValues();
		}
	});

	$UI.linkbutton('#CollectBT', {
		onClick: function() {
			var Rows = ReqMainGrid.getSelections();
			if (Rows.length <= 0) {
				$UI.msg('alert', '请选择要汇总的请求单!');
				return;
			}
			var ReqStr = GetReqStr();
			ReqItmsGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINIsTrfVendorManage',
				QueryName: 'SumReqItm',
				query2JsonStrict: 1,
				ReqStr: ReqStr
			});
		}
	});

	$UI.linkbutton('#DenyBT', {
		onClick: function() {
			var Rows = ReqMainGrid.getSelections();
			if (Rows.length <= 0) {
				$UI.msg('alert', '请选择要拒绝的请求单!');
				return;
			}
			var ReqStr = ReqMainGrid.getSelectedData();
			$UI.msg('alert', '此功能暂时不考虑!');
			return;
		}
	});

	$UI.linkbutton('#DistributeBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#Conditions');
			if (isEmpty(ParamsObj.IngrLoc)) {
				$UI.msg('alert', '科室不能为空!');
				return;
			}
			var Rows = ReqItmsGrid.getRows();
			if (Rows.length <= 0) {
				$UI.msg('alert', '请先选择请求单进行汇总!');
				return false;
			}
			if (!CheckBeforeHandle(Rows)) {
				return;
			}
			var Params = JSON.stringify(ParamsObj);
			var Data = JSON.stringify(ReqItmsGrid.getRowsData());
			showMask();
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINIsTrfVendorManage',
				MethodName: 'Handle',
				Main: Params,
				Data: Data
			}, function(jsonData) {
				hideMask();
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					$UI.clear(ReqMainGrid);
					$UI.clear(ReqDetailGrid);
					$UI.clear(ReqItmsGrid);
					InitMainGrid.load({
						ClassName: 'web.DHCSTMHUI.DHCINIsTrfVendorManage',
						QueryName: 'InitByDstr',
						query2JsonStrict: 1,
						Dstr: jsonData.rowid
					});
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});

	SetDefaValues();
	$('#QueryBT').click();
};
$(init);

function SetDefaValues() {
	$('#IngrLoc').combobox('setValue', gLocId);
	$('#StartDate').datebox('setValue', DefaultStDate());
	$('#EndDate').datebox('setValue', DefaultEdDate());
}

function CheckBeforeHandle(Rows) {
	for (var i = 0; i < Rows.length; i++) {
		var BatNo = Rows[i].BatNo;
		var ExpDate = Rows[i].ExpDate;
		var Vendor = Rows[i].Vendor;
		var Rp = Rows[i].Rp;
		var Qty = Rows[i].Qty;
		var ApprovedQty = Rows[i].ApprovedQty;
		var TransQty = Rows[i].TransQty;
		var BatReq = Rows[i].BatReq;
		var ExpReq = Rows[i].ExpReq;
		var ReqQty = accSub(ApprovedQty, TransQty);
		if (parseFloat(Qty) == 0)
			continue;
		if ((Rp == '') || (Rp <= 0)) {
			$UI.msg('alert', '第' + (i + 1) + '行进价为零!');
			return false;
		}
		if ((Vendor == '') || (Vendor == null)) {
			$UI.msg('alert', '第' + (i + 1) + '行供应商为空!');
			return false;
		}
		if ((BatReq == 'R') && (BatNo == '')) {
			$UI.msg('alert', '第' + (i + 1) + '行批号为空!');
			return false;
		}
		if ((ExpReq == 'R') && (ExpDate == '')) {
			$UI.msg('alert', '第' + (i + 1) + '行效期为空!');
			return false;
		}
		if (Qty > ReqQty) {
			$UI.msg('alert', '第' + (i + 1) + '行配送数量超过请求数量!');
			return false;
		}
	}
	return true;
}

function GetReqStr() {
	var ReqStr = '';
	var Rows = ReqMainGrid.getChecked();
	for (var i = 0; i < Rows.length; i++) {
		var Req = Rows[i].RowId;
		if (ReqStr == '') {
			ReqStr = Req;
		} else {
			ReqStr = ReqStr + ',' + Req;
		}
	}
	return ReqStr;
}