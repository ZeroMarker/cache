var init = function() {
	/* --按钮事件--*/
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			$UI.clear(ReqMainGrid);
			$UI.clear(ReqDetailGrid);
			$UI.clear(PurDetailGrid);
			var ParamsObj = $UI.loopBlock('#MainConditions');
			var StartDate = ParamsObj.StartDate;
			var EndDate = ParamsObj.EndDate;
			if (isEmpty(ParamsObj.PurLoc)) {
				$UI.msg('alert', '采购科室不能为空!');
				return;
			}
			if (isEmpty(ParamsObj.StkScg)) {
				$UI.msg('alert', '类组不能为空!');
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
				ClassName: 'web.DHCSTMHUI.INPurPlanAuxByReq',
				QueryName: 'INReqM',
				query2JsonStrict: 1,
				Params: Params,
				rows: 9999
			});
		}
	});
	
	function Deny() {
		var Row = ReqDetailGrid.getSelected();
		if (isEmpty(Row)) {
			$UI.msg('alert', '请选择要拒绝的请求单明细!');
			return;
		}
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.INReqItm',
			MethodName: 'SetItmStatus',
			Reqi: Row.RowId
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				$UI.clear(ReqDetailGrid);
				$UI.clear(PurDetailGrid);
				ReqDetailGrid.commonReload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	function Save() {
		if (checkPurQty() == true) {
			SavePur();
		}
		// else if(checkPurQty()=="-2"){
		// $UI.confirm("部分明细库存量大于标准库存,是否继续生成采购计划单?", "warning", "", SavePur, "", "", "警告", false)
		// }
	}
	// 数据检查
	function checkPurQty() {
		var rowsData = PurDetailGrid.getRows();
		if (rowsData.length == 0) {
			$UI.msg('alert', '没有要生成采购的明细!');
			return false;
		}
		for (var i = 0; i < rowsData.length; i++) {
			var row = rowsData[i];
			var PurQty = row.Qty;
			if (PurQty <= 0) {
				$UI.msg('alert', '部分明细采购数量不大于0!');
				return false;
			}
			// var RepQty=row.RepQty;
			// var Locqty=row.Locqty;
			// var ReqQty=row.ReqQty
			// var PurQty = accAdd(accSub(RepQty, Locqty), ReqQty);  //标准库存-科室库存+请求库存
			// if(PurQty<=0){
			// return "-2";
			// }
		}
		return true;
	}
	function SavePur() {
		var MainObj = $UI.loopBlock('#MainConditions');
		var Main = JSON.stringify(MainObj);
		var Detail = PurDetailGrid.getChangesData('RowId');
		// 判断
		var ifChangeMain = $UI.isChangeBlock('#MainConditions');
		if (Detail === false) {	// 未完成编辑或明细为空
			return;
		}
		if (!ifChangeMain && (isEmpty(Detail))) {	// 主单和明细不变
			$UI.msg('alert', '没有需要保存的信息!');
			return;
		}
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.INPurPlanAuxByReq',
			MethodName: 'jsCreatePurByReq',
			Main: Main,
			Detail: JSON.stringify(Detail)
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.clear(PurDetailGrid);
				$UI.clear(ReqDetailGrid);
				$UI.msg('success', jsonData.msg);
				var purId = jsonData.rowid;
				var UrlStr = 'dhcstmhui.inpurplan.csp?gPurId=' + purId;
				Common_AddTab('采购', UrlStr);
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
	function DefaultClear() {
		$UI.clearBlock('#MainConditions');
		$UI.clear(ReqMainGrid);
		$UI.clear(ReqDetailGrid);
		$UI.clear(PurDetailGrid);
		Default();
	}
	/* --绑定控件--*/
	var PurLocBox = $HUI.combobox('#PurLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + PurLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var LocId = record['RowId'];
			$HUI.combotree('#StkScg').setFilterByLoc(LocId);
		}
	});
	var ReqLocParams = JSON.stringify(addSessionParams({
		Type: 'All',
		Element: 'ReqLoc'
	}));
	var ReqLocBox = $HUI.combobox('#ReqLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + ReqLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var StatusBox = $HUI.combobox('#ReqType', {
		data: [{
			'RowId': '',
			'Description': '全部'
		}, {
			'RowId': 'O',
			'Description': '请求单'
		}, {
			'RowId': 'C',
			'Description': '申领计划'
		}
		],
		valueField: 'RowId',
		textField: 'Description'
	});
	StatusBox.setValue('');
	
	var PurDetailCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '物资ID',
			field: 'InciId',
			width: 100,
			hidden: true
		}, {
			title: '代码',
			field: 'InciCode',
			width: 100
		}, {
			title: '名称',
			field: 'InciDesc',
			width: 100
		}, {
			title: '单位Id',
			field: 'UomId',
			width: 80,
			hidden: true
		}, {
			title: '单位',
			field: 'UomDesc',
			width: 80
		}, {
			title: '采购数量',
			field: 'Qty',
			width: 80,
			align: 'right'
		}, {
			title: '科室库存',
			field: 'Locqty',
			width: 80,
			align: 'right'
		}, {
			title: '科室可用库存',
			field: 'LocAvaQty',
			width: 80,
			align: 'right'
		}, {
			title: '请求数量',
			field: 'ReqQty',
			width: 80,
			align: 'right'
		}, {
			title: '已转移数量',
			field: 'TransQty',
			width: 80,
			align: 'right'
		}, {
			title: '进价',
			field: 'Rp',
			width: 100,
			align: 'right'
		}, {
			title: '供应商Id',
			field: 'VendorId',
			width: 100,
			hidden: true
		}, {
			title: '供应商',
			field: 'VendorDesc',
			width: 100
		}, {
			title: '生产厂家Id',
			field: 'ManfId',
			width: 100,
			hidden: true
		}, {
			title: '生产厂家',
			field: 'ManfDesc',
			width: 100
		}, {
			title: '配送商Id',
			field: 'CarrierId',
			width: 100,
			hidden: true
		}, {
			title: '配送商',
			field: 'CarrierDesc',
			width: 100
		}, {
			title: '标准库存',
			field: 'RepQty',
			width: 80,
			align: 'right'
		}, {
			title: '品牌',
			field: 'Brand',
			width: 100
		}, {
			title: '规格',
			field: 'Spec',
			width: 100
		}, {
			title: '具体规格',
			field: 'SpecDesc',
			width: 100,
			hidden: CodeMainParamObj.UseSpecList == 'Y' ? false : true
		}, {
			title: '请求科室',
			field: 'ReqLocId',
			width: 100,
			hidden: true
		}, {
			title: '请求科室',
			field: 'ReqLocDesc',
			width: 100
		}
	]];

	var PurDetailGrid = $UI.datagrid('#PurDetailGrid', {
		queryParams: {},
		columns: PurDetailCm,
		singleSelect: false,
		pagination: false,
		toolbar: [{
			text: '生成采购计划单',
			iconCls: 'icon-accept',
			handler: function() {
				Save();
			}
		}],
		onBeforeCheck: function(index, row) {
			if (row['Qty'] <= 0) {
				$UI.msg('alert', '采购量为0!');
				return false;
			}
		}
	});

	var ReqDetailCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 80
		}, {
			title: '物资ID',
			field: 'InciId',
			width: 100,
			hidden: true
		}, {
			title: '代码',
			field: 'InciCode',
			width: 100
		}, {
			title: '名称',
			field: 'InciDesc',
			width: 100
		}, {
			title: '品牌',
			field: 'Brand',
			width: 100
		}, {
			title: '规格',
			field: 'Spec',
			width: 100
		}, {
			title: '具体规格',
			field: 'SpecDesc',
			width: 100,
			hidden: CodeMainParamObj.UseSpecList == 'Y' ? false : true
		}, {
			title: '单位ID',
			field: 'UomId',
			hidden: true,
			width: 80
		}, {
			title: '单位',
			field: 'UomDesc',
			width: 80
		}, {
			title: '请求数量',
			field: 'ReqQty',
			width: 80,
			align: 'right'
		}, {
			title: '科室库存',
			field: 'Locqty',
			width: 80,
			align: 'right'
		}, {
			title: '已转移数量',
			field: 'TransQty',
			width: 80,
			align: 'right'
		}, {
			title: '标准库存',
			field: 'RepQty',
			width: 80,
			align: 'right'
		}, {
			title: '科室可用库存',
			field: 'LocAvaQty',
			width: 80,
			align: 'right'
		}, {
			title: '基本单位',
			field: 'BUomId',
			width: 100,
			hidden: true
		}, {
			title: '转换系数',
			field: 'ConFac',
			width: 100,
			hidden: true
		}, {
			title: 'ReqLocId',
			field: 'ReqLocId',
			width: 100,
			hidden: true
		}, {
			title: 'ReqLocDesc',
			field: 'ReqLocDesc',
			width: 100,
			hidden: true
		}
	]];

	var ReqDetailGrid = $UI.datagrid('#ReqDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INPurPlanAuxByReq',
			QueryName: 'INReqD',
			query2JsonStrict: 1,
			rows: 9999
		},
		columns: ReqDetailCm,
		selectOnCheck: true,
		checkOnSelect: true,
		singleSelect: false,
		sortName: 'RowId',
		sortOrder: 'Desc',
		pagination: false,
		toolbar: [{
			text: '拒绝一条明细',
			iconCls: 'icon-no',
			handler: function() {
				Deny();
			}
		}],
		onSelect: function(index, row) {
			AddPurDetail(row);
		},
		onUnselect: function(index, row) {
			DelPurDetail(row);
		},
		onSelectAll: function(rows) {
			$UI.clear(PurDetailGrid);
			var count = rows.length;
			for (i = 0; i < count; i++) {
				var row = rows[i];
				AddPurDetail(row);
			}
		},
		onUnselectAll: function(rows) {
			$UI.clear(PurDetailGrid);
		}
	});
	var DelPurDetail = function(rowObj) {
		var row = $.extend({}, rowObj);
		var RowId = row.RowId;
		var PurRows = PurDetailGrid.getRows();
		for (var i = 0; i < PurRows.length; i++) {
			var PurRow = PurRows[i];
			var PurRowId = PurRow.RowId;
			if (PurRowId == RowId) {
				index = PurDetailGrid.getRowIndex(PurRow);
				PurDetailGrid.deleteRow(index);
			} else {
				continue;
			}
		}
	};
	var AddPurDetail = function(rowObj) {
		var purloc = $HUI.combobox('#PurLoc').getValue();
		var purlocDesc = $('#PurLoc').combobox('getText');
		var InciParams = JSON.stringify(addSessionParams({
			PurLoc: purloc
		}));
		$.cm({
			ClassName: 'web.DHCSTMHUI.INPurPlan',
			MethodName: 'GetItmInfo',
			IncId: rowObj.InciId,
			Params: InciParams
		}, function(jsonData) {
			var FindIndex = PurDetailGrid.find('RowId', rowObj.RowId);
			if (FindIndex >= 0) { return false; }
			rowObj.Rp = jsonData.Rp;
			rowObj.VendorId = jsonData.VenId;
			rowObj.VendorDesc = jsonData.VenDesc;
			rowObj.ManfId = jsonData.ManfId;
			rowObj.ManfDesc = jsonData.ManfDesc;
			rowObj.CarrierId = jsonData.CarrierId;
			rowObj.CarrierDesc = jsonData.CarrierDesc;
			var PurQty = rowObj.ReqQty;
			var InPurByLoc = InPoParamObj.PoByLoc;
			var AvaQtyFlag = InPurPlanParamObj.AvaQty;
			var TrfQtyFlag = InPurPlanParamObj.TrfQty;
			if (InPurByLoc != 'Y') {
				rowObj.ReqLocId = purloc;
				rowObj.ReqLocDesc = purlocDesc;
			}
			if (AvaQtyFlag == 'Y') {
				PurQty = PurQty - rowObj.LocAvaQty;
			}
			if (TrfQtyFlag == 'Y') {
				PurQty = PurQty - rowObj.TransQty;
			}
			rowObj.Qty = Math.max(PurQty, 0);
			var row = $.extend({}, rowObj);
			var EditRowIndex = 0;
			var length = PurDetailGrid.getRows().length;
			if (length > 0) {
				EditRowIndex = length;
			}
			PurDetailGrid.insertRow({
				index: EditRowIndex,
				row: row
			});
		});
	};

	var ReqMainCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '请求单号',
			field: 'ReqNo',
			width: 160
		}, {
			title: '请求科室',
			field: 'ReqLoc',
			sortable: true,
			width: 150
		}, {
			title: '类组',
			field: 'StkScg',
			width: 100
		}, {
			title: '转移状态',
			field: 'TransStatus',
			width: 80,
			formatter: function(value, row, index) {
				if (value == 0) {
					return '未转移';
				} else if (value == 1) {
					return '部分转移';
				} else {
					return '全部转移';
				}
			}
		}, {
			title: '制单日期',
			field: 'CreateDate',
			width: 100
		}
	]];

	var ReqMainGrid = $UI.datagrid('#ReqMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INPurPlanAuxByReq',
			QueryName: 'INReqM',
			query2JsonStrict: 1,
			rows: 9999
		},
		columns: ReqMainCm,
		selectOnCheck: true,
		checkOnSelect: true,
		singleSelect: false,
		pagination: false,
		remoteSort: false,
		onSelectChangeFn: function() {
			var Rows = ReqMainGrid.getSelections();
			var count = Rows.length;
			var ReqIdStr = '';
			for (i = 0; i < count; i++) {
				var RowData = Rows[i];
				var ReqId = RowData.RowId;
				if (ReqIdStr == '') {
					ReqIdStr = ReqId;
				} else {
					ReqIdStr = ReqIdStr + ',' + ReqId;
				}
			}
			ReqDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.INPurPlanAuxByReq',
				QueryName: 'INReqD',
				query2JsonStrict: 1,
				ReqIdStr: ReqIdStr,
				LocId: $('#PurLoc').combo('getValue'),
				rows: 9999
			});
		}
	});

	/* --设置初始值--*/
	var Default = function() {
		// /设置初始值 考虑使用配置
		var DefaultValue = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate(),
			PurLoc: gLocObj,
			AuditFlag: 'N'
		};
		$UI.fillBlock('#MainConditions', DefaultValue);
		$('#TransStatus1').checkbox('setValue', 'Y');
		$('#TransStatus0').checkbox('setValue', 'Y');
	};
	Default();
};
$(init);