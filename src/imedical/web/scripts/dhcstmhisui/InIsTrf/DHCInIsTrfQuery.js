
var init = function() {
	$UI.linkbutton('#SearchBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		var ParamsObj = $UI.loopBlock('Conditions');
		var StartDate = ParamsObj.StartDate;
		var EndDate = ParamsObj.EndDate;
		if (isEmpty(ParamsObj.FrLoc)) {
			$UI.msg('alert', '科室不可为空!');
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
		$UI.clear(DetailGrid);
		$UI.clear(MasterGrid);
		MasterGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			QueryName: 'DHCINIsTrfM',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			$UI.clearBlock('Conditions');
			$UI.clear(DetailGrid);
			$UI.clear(MasterGrid);
			SetDefaValues();
		}
	});
	$UI.linkbutton('#PrintBT', {
		onClick: function() {
			var SelectedRow = MasterGrid.getSelections();
			if (isEmpty(SelectedRow)) {
				$UI.msg('alert', '请选择需要打印的单据!');
				return;
			}
			var InitStr = '';
			for (var i = 0; i < SelectedRow.length; i++) {
				var Init = SelectedRow[i].RowId;
				if (InitStr == '') {
					InitStr = Init;
				} else {
					InitStr = InitStr + '^' + Init;
				}
			}
			if (InitStr == '') {
				$UI.msg('alert', '请选择需要打印的信息!');
				return false;
			}
			PrintInIsTrf(InitStr);
		}
	});
	$UI.linkbutton('#PrintHVColBT', {
		onClick: function() {
			var SelectedRow = MasterGrid.getSelections();
			if (isEmpty(SelectedRow)) {
				$UI.msg('alert', '请选择需要打印的单据!');
				return;
			}
			var InitStr = '';
			for (var i = 0; i < SelectedRow.length; i++) {
				var Init = SelectedRow[i].RowId;
				if (InitStr == '') {
					InitStr = Init;
				} else {
					InitStr = InitStr + '^' + Init;
				}
			}
			if (InitStr == '') {
				$UI.msg('alert', '请选择需要打印的信息!');
				return false;
			}
			PrintInIsTrfHVCol(InitStr);
		}
	});
	$UI.linkbutton('#ConfirmBT', {
		onClick: function() {
			var SelectedRow = MasterGrid.getSelections();
			if (isEmpty(SelectedRow)) {
				$UI.msg('alert', '请选择需要确认的单据!');
				return;
			}
			var RowIdStr = '';
			for (var i = 0; i < SelectedRow.length; i++) {
				var RowId = SelectedRow[i].RowId;
				var ConfirmFlag = SelectedRow[i].ConfirmFlag;
				if (ConfirmFlag == 'Y') {
					$UI.msg('alert', '转移单已确认!');
					return;
				}
				if (RowIdStr == '') {
					RowIdStr = RowId;
				} else {
					RowIdStr = RowIdStr + '^' + RowId;
				}
			}
			if (RowIdStr == '') {
				$UI.msg('alert', '没有需要确认的单据!');
				return false;
			}
			Confirm(RowIdStr);
		}
	});

	function Confirm(RowIdStr) {
		var Params = JSON.stringify({ RowIdStr: RowIdStr });
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			MethodName: 'jsConfirm',
			Params: Params
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				Query();
			} else {
				$UI.msg('alert', jsonData.msg);
			}
		}, false);
	}
	$HUI.combobox('#FrLoc', {
		url: $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='
			+ JSON.stringify(addSessionParams({ Type: 'Login', Element: 'FrLoc' })),
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var LocId = record['RowId'];
			$('#CreateUser').combobox('clear');
			$('#CreateUser').combobox('reload', $URL
				+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetDeptUser&ResultSetType=Array&Params='
				+ JSON.stringify({ LocDr: LocId })
			);
			var ToLoc = $('#ToLoc').combobox('getValue');
			$HUI.combotree('#ScgId').setFilterByLoc(LocId, ToLoc);
		}
	});
	$UI.linkbutton('#AutitNoBT', {
		onClick: function() {
			var Sels = MasterGrid.getSelections();
			if (isEmpty(Sels)) {
				$UI.msg('alert', '请选择需要取消审核的单据!');
				return;
			}
			$.messager.confirm('拒绝', '确定取消审核选取的单据?', function(r) {
				if (r) {
					TransInAuditNo();
				}
			});
		}
	});
	function TransInAuditNo() {
		var Sels = MasterGrid.getSelections();
		var InitStr = '';
		for (var i = 0, Len = Sels.length; i < Len; i++) {
			var InitId = Sels[i]['RowId'];
			var InitNo = Sels[i]['InitNo'];	// 单号
			var InitStatus = Sels[i]['StatusCode'];	// 单据状态
			if (InitStatus != '审核通过') {
				$UI.msg('alert', InitNo + '出库单不是审核通过状态,不允许取消审核!');
				return false;
			}
			if (InitStr == '') {
				InitStr = InitId;
			} else {
				InitStr = InitStr + '^' + InitId;
			}
		}
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			MethodName: 'jsTransInAuditNoStr',
			InitStr: InitStr,
			UserId: gUserId
		}, function(jsonData) {
			var Ret = jsonData.msg;
			var RetArr = Ret.split(',');
			var InitRetStr = RetArr[0];
			var TotalCnt = RetArr[1];
			var SucessCnt = RetArr[2];
			if (jsonData.success == 0) {
				$UI.msg('success', '共' + TotalCnt + '张单据,成功取消审核' + SucessCnt + '张单据!');
				Query();
			} else {
				var FailCnt = TotalCnt - SucessCnt;
				$UI.msg('error', '共' + TotalCnt + '张单据,失败' + FailCnt + '张单据!');
			}
			hideMask();
		});
	}
	$('#FrLoc').combobox('setValue', session['LOGON.CTLOCID']);
	
	$HUI.combobox('#ToLoc', {
		url: $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='
			+ JSON.stringify(addSessionParams({ Type: 'All', Element: 'ToLoc' })),
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var ToLoc = record['RowId'];
			var FrLoc = $('#FrLoc').combobox('getValue');
			$HUI.combotree('#ScgId').setFilterByLoc(FrLoc, ToLoc);
		}
	});
	
	$HUI.combobox('#CreateUser', {
		url: $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetDeptUser&ResultSetType=Array&Params='
			+ JSON.stringify({ LocDr: gLocId }),
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var HandlerParams = function() {
		var ScgId = $('#ScgId').combotree('getValue');
		var FrLoc = $('#FrLoc').combobox('getValue');
		var ToLoc = $('#ToLoc').combobox('getValue');
		var Obj = { StkGrpRowId: ScgId, StkGrpType: 'M', Locdr: FrLoc, ToLoc: ToLoc, BDPHospital: gHospId };
		return Obj;
	};
	$('#InciDesc').lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#Inci'));
	
	$HUI.checkbox('#VirtualFlag', {
		onCheckChange: function(e, value) {
			if (value) {
				var FrLoc = $('#FrLoc').combobox('getValue');
				var Info = tkMakeServerCall('web.DHCSTMHUI.Common.UtilCommon', 'GetMainLoc', FrLoc);
				var InfoArr = Info.split('^');
				var VituralLoc = InfoArr[0], VituralLocDesc = InfoArr[1];
				AddComboData($('#FrLoc'), VituralLoc, VituralLocDesc);
				$('#FrLoc').combobox('setValue', VituralLoc);
			} else {
				$('#FrLoc').combobox('setValue', gLocId);
			}
		}
	});
	var FVendorBoxParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
	$HUI.combobox('#FVendorBox', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + FVendorBoxParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var MasterCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 80,
			hidden: true
		}, {
			title: '单号',
			field: 'InitNo',
			align: 'left',
			width: 150,
			sortable: true
		}, {
			title: '出库科室',
			field: 'FrLocDesc',
			width: 150,
			sortable: true
		}, {
			title: '接收科室',
			field: 'ToLocDesc',
			width: 150
		}, {
			title: '请求单号',
			field: 'ReqNo',
			width: 150
		}, {
			title: '制单时间',
			field: 'InitDateTime',
			width: 150
		}, {
			title: '审核时间',
			field: 'AckDateTime',
			width: 150
		}, {
			title: '出库类型',
			field: 'OperateTypeDesc',
			width: 80
		}, {
			title: '单据状态',
			field: 'StatusCode',
			width: 70
		}, {
			title: '制单人',
			field: 'UserName',
			width: 80
		}, {
			title: '接收人',
			field: 'InAckUser',
			width: 80
		}, {
			title: '进价金额',
			field: 'RpAmt',
			align: 'right',
			width: 100
		}, {
			title: '售价金额',
			field: 'SpAmt',
			align: 'right',
			width: 100
		}, {
			title: '进销差',
			field: 'MarginAmt',
			align: 'right',
			width: 100
		}, {
			title: '备注',
			field: 'Remark',
			width: 150
		}, {
			title: '打印标记',
			field: 'PrintFlag',
			formatter: BoolFormatter,
			align: 'center',
			width: 100
		}, {
			title: '确认标记',
			field: 'ConfirmFlag',
			formatter: BoolFormatter,
			align: 'center',
			width: 100
		}
	]];

	var MasterGrid = $UI.datagrid('#MasterGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			QueryName: 'DHCINIsTrfM',
			query2JsonStrict: 1
		},
		columns: MasterCm,
		showBar: true,
		singleSelect: false,
		onSelect: function(index, row) {
			var Init = row['RowId'];
			var ParamsObj = { Init: Init, InitType: 'T' };
			$UI.clear(DetailGrid);
			DetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
				QueryName: 'DHCINIsTrfD',
				query2JsonStrict: 1,
				Params: JSON.stringify(ParamsObj),
				rows: 99999
			});
		},
		onLoadSuccess: function(data) {
			if ((data.rows.length > 0) && (CommParObj.IfSelFirstRow == 'Y')) {
				MasterGrid.selectRow(0);
			}
		}
	});

	var DetailCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 80,
			hidden: true
		}, {
			title: '物资代码',
			field: 'InciCode',
			width: 120
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width: 180
		}, {
			title: '规格',
			field: 'Spec',
			width: 80
		}, {
			title: '高值条码',
			field: 'HVBarCode',
			width: 150
		}, {
			title: '批号~效期',
			field: 'BatExp',
			width: 200
		}, {
			title: '生产厂家',
			field: 'ManfDesc',
			width: 160
		}, {
			title: '供应商',
			field: 'VendorDesc',
			width: 160
		}, {
			title: '批次库存',
			field: 'InclbQty',
			align: 'right',
			width: 80
		}, {
			title: '出库数量',
			field: 'Qty',
			align: 'right',
			width: 80
		}, {
			title: '单位',
			field: 'UomDesc',
			width: 50
		}, {
			title: '进价',
			field: 'Rp',
			align: 'right',
			width: 80
		}, {
			title: '售价',
			field: 'Sp',
			align: 'right',
			width: 80
		}, {
			title: '进价金额',
			field: 'RpAmt',
			align: 'right',
			width: 80
		}, {
			title: '售价金额',
			field: 'SpAmt',
			align: 'right',
			width: 80
		}, {
			title: '国家医保编码',
			field: 'MatInsuCode',
			width: 160
		}, {
			title: '国家医保名称',
			field: 'MatInsuDesc',
			width: 160
		}, {
			title: '灭菌批号',
			field: 'SterilizedBat',
			width: 160
		}, {
			title: '请求数量',
			field: 'ReqQty',
			align: 'right',
			width: 80
		}, {
			title: '请求方库存',
			field: 'ReqLocStkQty',
			align: 'right',
			width: 100
		}, {
			title: '占用数量',
			field: 'InclbDirtyQty',
			align: 'right',
			width: 100
		}, {
			title: '可用数量',
			field: 'InclbAvaQty',
			align: 'right',
			width: 100
		}, {
			title: '备注',
			field: 'Remark',
			width: 150
		}
	]];

	var DetailGrid = $UI.datagrid('#DetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
			QueryName: 'DHCINIsTrfD',
			query2JsonStrict: 1,
			rows: 99999
		},
		pagination: false,
		columns: DetailCm,
		showBar: true,
		remoteSort: false
	});
	
	// 设置缺省值
	function SetDefaValues() {
		var DefaultData = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate(),
			FrLoc: gLocObj
		};
		$UI.fillBlock('#Conditions', DefaultData);
		$('#ScgId').combotree('options')['setDefaultFun']();
		if (ItmTrackParamObj.AutoVirFlag == 'Y') {
			$('#VirtualFlag').checkbox('setValue', true);
		} else {
			$('#VirtualFlag').checkbox('setValue', false);
		}
	}
	
	SetDefaValues();
	Query();
};
$(init);