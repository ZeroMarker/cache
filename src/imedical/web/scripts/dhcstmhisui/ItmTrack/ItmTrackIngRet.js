var init = function() {
	/* --按钮事件--*/
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#MainConditions');
			var StartDate = ParamsObj.StartDate;
			var EndDate = ParamsObj.EndDate;
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
			if (isEmpty(ParamsObj.PhaLoc)) {
				$UI.msg('alert', '库房不能为空!');
				return;
			}
			if (isEmpty(ParamsObj.CurrLoc)) {
				$UI.msg('alert', '科室不能为空!');
				return;
			}
			if (isEmpty(ParamsObj.Vendor)) {
				$UI.msg('alert', '供应商不能为空!');
				return;
			}
			if (isEmpty(ParamsObj.StkScg)) {
				$UI.msg('alert', '类组不能为空!');
				return;
			}
		
			ParamsObj.Status = 'Enable';
			var Params = JSON.stringify(addSessionParams(ParamsObj));
			$UI.clearBlock('#InitInfo');
			$UI.clearBlock('#RetInfo');
			$UI.clear(InitDetailGrid);
			$UI.clear(RetDetailGrid);
			TrackGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCItmTrack',
				QueryName: 'QueryTrack',
				query2JsonStrict: 1,
				Params: Params
			});
		}
	});
	
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Default();
		}
	});
	
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			Save();
		}
	});
	function Save() {
		var MainObj = $UI.loopBlock('#MainConditions');
		if (isEmpty(MainObj.PhaLoc)) {
			$UI.msg('alert', '库房不能为空!');
			return;
		}
		if (isEmpty(MainObj.CurrLoc)) {
			$UI.msg('alert', '科室不能为空!');
			return;
		}
		if (isEmpty(MainObj.Vendor)) {
			$UI.msg('alert', '供应商不能为空!');
			return;
		}
		if (isEmpty(MainObj.StkScg)) {
			$UI.msg('alert', '类组不能为空!');
			return;
		}
		var Main = JSON.stringify(MainObj);
		var DetailObj = TrackGrid.getSelectedData();
		if (DetailObj === false) {
			$UI.msg('alert', '数据检查未通过!');
			return;
		} else if (DetailObj.length == 0) {
			$UI.msg('alert', '没有需要保存的明细!');
			return;
		}
		var Detail = JSON.stringify(DetailObj);
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCItmTrackIngret',
			MethodName: 'jsCreatIngRet',
			Main: Main,
			Detail: Detail
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				var arr = jsonData.rowid.split(',');
				var Init = arr[0];
				var RetId = arr[1];
				ReturnInfo(Init, RetId);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	function ReturnInfo(Init, RetId) {
		$UI.clear(InitDetailGrid);
		$UI.clear(RetDetailGrid);
		$UI.clearBlock('#InitInfo');
		$UI.clearBlock('#RetInfo');
		// 本次退库
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCItmTrackIngret',
			MethodName: 'QueryInit',
			Init: Init
		},
		function(jsonData) {
			$UI.fillBlock('#InitInfo', jsonData);
		});
		InitDetailGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCItmTrackIngret',
			QueryName: 'QueryIniti',
			query2JsonStrict: 1,
			Init: Init,
			rows: 99999
		});
		// 本次退货
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCItmTrackIngret',
			MethodName: 'QueryIngt',
			RetId: RetId
		},
		function(jsonData) {
			$UI.fillBlock('#RetInfo', jsonData);
		});
		RetDetailGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCItmTrackIngret',
			QueryName: 'QueryIngti',
			query2JsonStrict: 1,
			RetId: RetId,
			rows: 99999
		});
	}
	/* --Grid--*/
	var DetailCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '物资RowId',
			field: 'InciId',
			width: 50,
			hidden: true
		}, {
			title: '代码',
			field: 'InciCode',
			width: 100
		}, {
			title: '描述',
			field: 'InciDesc',
			width: 150
		}, {
			title: '高值条码',
			field: 'HVBarCode',
			width: 150
		}, {
			title: '规格',
			field: 'Spec',
			width: 100
		}, {
			title: '批号',
			field: 'BatNo',
			width: 100
		}, {
			title: '效期',
			field: 'ExpDate',
			width: 100,
			align: 'right'
		}, {
			title: '生产厂家',
			field: 'ManfDesc',
			width: 100
		}, {
			title: '数量',
			field: 'Qty',
			width: 60,
			align: 'right'
		}, {
			title: '单位',
			field: 'UomDesc',
			width: 60
		}, {
			title: '进价',
			field: 'Rp',
			width: 60,
			align: 'right'
		}, {
			title: '进价金额',
			field: 'RpAmt',
			width: 80,
			align: 'right'
		}, {
			title: '售价',
			field: 'Sp',
			width: 80,
			align: 'right'
		}, {
			title: '售价金额',
			field: 'SpAmt',
			width: 80,
			align: 'right'
		}
	]];
	
	var RetDetailGrid = $UI.datagrid('#RetDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCItmTrackIngret',
			QueryName: 'QueryIngti',
			query2JsonStrict: 1,
			rows: 99999
		},
		columns: DetailCm,
		showBar: true,
		pagination: false
	});
	
	var InitDetailGrid = $UI.datagrid('#InitDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCItmTrackIngret',
			QueryName: 'QueryIniti',
			query2JsonStrict: 1,
			rows: 99999
		},
		columns: DetailCm,
		showBar: true,
		pagination: false
	});
	
	/* --Grid--*/
	var TrackCm = [[
		{ field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '操作',
			field: 'Icon',
			width: 50,
			align: 'center',
			allowExport: false,
			formatter: function(value, row, index) {
				var str = '<div href="#" class="icon-paper-info col-icon" title="跟踪信息" onclick="TrackInfo(' + row.RowId + ');"></div>';
				return str;
			}
		}, {
			title: '物资RowId',
			field: 'InciId',
			width: 50,
			hidden: true
		}, {
			title: '代码',
			field: 'InciCode',
			width: 100
		}, {
			title: '描述',
			field: 'InciDesc',
			width: 150
		}, {
			title: '高值条码',
			field: 'Label',
			width: 150
		}, {
			title: '自带条码',
			field: 'OriginalCode',
			width: 150
		}, {
			title: '状态',
			field: 'Status',
			formatter: StatusFormatter,
			width: 80
		}, {
			title: '批次',
			field: 'Incib',
			width: 100,
			hidden: true
		}, {
			title: '批号',
			field: 'BatNo',
			width: 100
		}, {
			title: '效期',
			field: 'ExpDate',
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
			title: '单位',
			field: 'UomDesc',
			width: 60
		}, {
			title: '供应商',
			field: 'VendorDesc',
			width: 100
		}, {
			title: '生产厂家',
			field: 'ManfDesc',
			width: 100
		}, {
			title: '当前位置',
			field: 'CurrentLoc',
			width: 100
		}, {
			title: '日期',
			field: 'DhcitDate',
			width: 100
		}, {
			title: '时间',
			field: 'DhcitTime',
			width: 80
		}, {
			title: '操作人',
			field: 'DhcitUser',
			width: 80
		}, {
			title: '数量',
			field: 'Qty',
			width: 60,
			align: 'right'
		}, {
			title: 'Inclb',
			field: 'Inclb',
			width: 100,
			hidden: true
		}
	]];
	
	var TrackGrid = $UI.datagrid('#TrackGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			QueryName: 'QueryTrack',
			query2JsonStrict: 1
		},
		columns: TrackCm,
		showBar: true,
		singleSelect: false,
		navigatingWithKey: true,
		onLoadSuccess: function(data) {
			if ((data.rows.length > 0) && (CommParObj.IfSelFirstRow == 'Y')) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	
	var HandlerParams = function() {
		var PhaLoc = $('#PhaLoc').combo('getValue');
		var StkScg = $('#StkScg').combo('getValue');
		var Obj = { StkGrpRowId: StkScg, StkGrpType: 'M', Locdr: PhaLoc };
		return Obj;
	};
	$('#InciDesc').lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#Inci'));
	
	var VendorParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
	var VendorBox = $HUI.combobox('#Vendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var CurrLocParams = JSON.stringify(addSessionParams({ Type: 'All', Element: 'CurrLoc' }));
	var CurrLocBox = $HUI.combobox('#CurrLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + CurrLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var PhaLocBox = $HUI.combobox('#PhaLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + JSON.stringify(addSessionParams({ Type: 'Login', Element: 'PhaLoc' })),
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var LocId = record['RowId'];
			if (CommParObj.ApcScg == 'L') {
				VendorBox.clear();
				var Params = JSON.stringify(addSessionParams({ APCType: 'M', LocId: LocId }));
				var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + Params;
				VendorBox.reload(url);
			}
		}
	});
	$('#PhaLoc').combobox('setValue', session['LOGON.CTLOCID']);
	$('#StkScg').stkscgcombotree({
		onSelect: function(node) {
			if (CommParObj.ApcScg == 'S') {
				VendorBox.clear();
				var Params = JSON.stringify(addSessionParams({ APCType: 'M' }));
				var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + Params + '&ScgId=' + node.id ;
				VendorBox.reload(url);
			}
		}
	});
	function CheckChange(value) {
		if (value) {
			var FrLoc = $('#PhaLoc').combobox('getValue');
			var Info = tkMakeServerCall('web.DHCSTMHUI.Common.UtilCommon', 'GetMainLoc', FrLoc);
			var InfoArr = Info.split('^');
			var VituralLoc = InfoArr[0], VituralLocDesc = InfoArr[1];
			AddComboData($('#PhaLoc'), VituralLoc, VituralLocDesc);
			$('#PhaLoc').combobox('setValue', VituralLoc);
		} else {
			$('#PhaLoc').combobox('setValue', gLocId);
		}
	}
	var VirtualFlag = $HUI.checkbox('#VirtualFlag', {
		onCheckChange: function(e, value) {
			CheckChange(value);
		}
	});
	
	/* --设置初始值--*/
	var Default = function() {
		$UI.clearBlock('#MainConditions');
		$UI.clearBlock('#InitInfo');
		$UI.clearBlock('#RetInfo');
		$UI.clear(TrackGrid);
		$UI.clear(InitDetailGrid);
		$UI.clear(RetDetailGrid);
		// /设置初始值 考虑使用配置
		var DefaultValue = {
			StartDate: TrackDefaultStDate(),
			EndDate: TrackDefaultEdDate(),
			PhaLoc: gLocObj,
			AuditFlag: 'N'
		};
		
		$UI.fillBlock('#MainConditions', DefaultValue);
		if (ItmTrackParamObj.AutoVirFlag == 'Y') {
			$('#VirtualFlag').checkbox('setValue', true);
		} else {
			$('#VirtualFlag').checkbox('setValue', false);
		}
	};
	Default();
};
$(init);

// 跟踪信息窗口
function TrackInfo(RowId) {
	$HUI.dialog('#FindWin').open();

	/* --Grid--*/
	var TrackDetailCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '类型',
			field: 'Type',
			width: 115,
			formatter: TypeRenderer
		}, {
			title: 'Pointer',
			field: 'Pointer',
			width: 100,
			hidden: true
		}, {
			title: '处理号',
			field: 'OperNo',
			width: 160
		}, {
			title: '日期',
			field: 'Date',
			width: 100
		}, {
			title: '时间',
			field: 'Time',
			width: 80
		}, {
			title: '操作人',
			field: 'UserDesc',
			width: 80
		}, {
			title: '位置信息',
			field: 'OperOrg',
			width: 180
		}
	]];

	var TrackDetailGrid = $UI.datagrid('#TrackDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			QueryName: 'QueryTrackItm',
			query2JsonStrict: 1,
			Parref: RowId,
			rows: 9999
		},
		columns: TrackDetailCm,
		lazy: false,
		pagination: false,
		onClickRow: function(index, row) {
			TrackDetailGrid.commonClickRow(index, row);
		}
	});
}