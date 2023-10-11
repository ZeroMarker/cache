
var init = function() {
	$UI.linkbutton('#SearchBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		$UI.clear(DetailGrid);
		$UI.clear(MasterGrid);
		var ParamsObj = $UI.loopBlock('Conditions');
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
		if (isEmpty(ParamsObj.FrLoc)) {
			$UI.msg('alert', '库房不能为空!');
			return;
		}
		ParamsObj['DateType'] = '1';
		ParamsObj['Comp'] = 'Y';
		ParamsObj['Status'] = '11';
		var Params = JSON.stringify(ParamsObj);
		MasterGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			QueryName: 'DHCINIsTrfM',
			query2JsonStrict: 1,
			Params: Params,
			totalFooter: '"InitNo":"合计"',
			totalFields: 'RpAmt,SpAmt'
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
			var RowData = MasterGrid.getSelections();
			if (isEmpty(RowData)) {
				$UI.msg('alert', '请选择需要打印的单据!');
				return;
			}
			var InitStr = '';
			for (i = 0; i < RowData.length; i++) {
				var Init = RowData[i].RowId;
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
			var RowData = MasterGrid.getSelections();
			if (isEmpty(RowData)) {
				$UI.msg('alert', '请选择需要打印的单据!');
				return;
			}
			var InitStr = '';
			for (i = 0; i < RowData.length; i++) {
				var Init = RowData[i].RowId;
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
	
	$UI.linkbutton('#AutitYesBT', {
		onClick: function() {
			var Sels = MasterGrid.getSelections();
			if (isEmpty(Sels)) {
				$UI.msg('alert', '请选择需要审核的单据!');
				return;
			}
			if (InitParamObj.ConfirmBeforeAudit == 'Y') {
				$UI.confirm('确定审核选取的单据?', '', '', TransOutAuditYes);
			} else {
				TransOutAuditYes();
			}
		}
	});
	function TransOutAuditYes() {
		var Sels = MasterGrid.getSelections();
		var InitStr = '';
		for (var i = 0, Len = Sels.length; i < Len; i++) {
			var InitId = Sels[i]['RowId'];
			var FrLocId = Sels[i]['FrLocId'];
			var ToLocId = Sels[i]['ToLocId'];
			var InStkTkParamObj = GetAppPropValue('DHCSTINSTKTKM');
			if (InStkTkParamObj.AllowBusiness != 'Y') {
				var IfFrLocExistInStkTk = tkMakeServerCall('web.DHCSTMHUI.INStkTk', 'CheckInStkTkByLoc', FrLocId);
				if (IfFrLocExistInStkTk == 'Y') {
					var FrLocDesc = Sels[i]['FrLocDesc'];
					$UI.msg('alert', '出库科室' + FrLocDesc + '有未完成的盘点单不允许审核!');
					return false;
				}
				var IfToLocExistInStkTk = tkMakeServerCall('web.DHCSTMHUI.INStkTk', 'CheckInStkTkByLoc', ToLocId);
				if (IfToLocExistInStkTk == 'Y') {
					var ToLocDesc = Sels[i]['ToLocDesc'];
					$UI.msg('alert', '接收科室' + ToLocDesc + '有未完成的盘点单不允许审核!');
					return false;
				}
			}
			if (ItmTrackParamObj['UseItmTrack'] == 'Y' && CheckHighValueLabels('T', InitId) == false) {
				continue;
			}
			if (InitStr == '') {
				InitStr = InitId;
			} else {
				InitStr = InitStr + '^' + InitId;
			}
		}
		if (isEmpty(InitStr)) {
			return;
		}
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			MethodName: 'jsTransOutAuditYesStr',
			InitStr: InitStr,
			UserId: gUserId,
			GroupId: gGroupId
		}, function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				var Ret = jsonData.msg;
				var RetArr = Ret.split(',');
				var InitRetStr = RetArr[0];
				var TotalCnt = RetArr[1];
				var SucessCnt = RetArr[2];
				var FailCnt = TotalCnt - SucessCnt;
				var ErrInfo = RetArr[3];
				$UI.msg('success', '共' + TotalCnt + '张单据,成功审核' + SucessCnt + '张单据!');
				if (FailCnt > 0) {
					$UI.msg('error', '失败:' + FailCnt + '条;失败信息:' + ErrInfo);
				}
				if (InitParamObj['AutoPrintAfterAckOut'] == 'Y') {
					PrintInIsTrf(InitRetStr, 'Y');
				}
				Query();
			}
		});
	}
	
	$UI.linkbutton('#AutitNoBT', {
		onClick: function() {
			var Sels = MasterGrid.getSelections();
			if (isEmpty(Sels)) {
				$UI.msg('alert', '请选择需要拒绝的单据!');
				return;
			}
			$UI.confirm('确定拒绝选取的单据?', '', '', TransOutAuditNo);
		}
	});
	function TransOutAuditNo() {
		var Sels = MasterGrid.getSelections();
		var InitStr = '';
		for (var i = 0, Len = Sels.length; i < Len; i++) {
			var InitId = Sels[i]['RowId'];
			if (InitStr == '') {
				InitStr = InitId;
			} else {
				InitStr = InitStr + '^' + InitId;
			}
		}
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			MethodName: 'jsTransOutAuditNoStr',
			InitStr: InitStr,
			UserId: gUserId
		}, function(jsonData) {
			var Ret = jsonData.msg;
			var RetArr = Ret.split(',');
			var InitRetStr = RetArr[0];
			var TotalCnt = RetArr[1];
			var SucessCnt = RetArr[2];
			$UI.msg('success', '共' + TotalCnt + '张单据,成功拒绝' + SucessCnt + '张单据!');
			Query();
			hideMask();
		});
	}

	var FrLoc = $HUI.combobox('#FrLoc', {
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
	$('#FrLoc').combobox('setValue', session['LOGON.CTLOCID']);
	
	var ToLoc = $HUI.combobox('#ToLoc', {
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
	
	var CreateUser = $HUI.combobox('#CreateUser', {
		url: $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetDeptUser&ResultSetType=Array&Params='
			+ JSON.stringify({ LocDr: gLocId }),
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var VirtualFlag = $HUI.checkbox('#VirtualFlag', {
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
	
	var HandlerParams = function() {
		var ScgId = $('#ScgId').combotree('getValue');
		var FrLoc = $('#FrLoc').combobox('getValue');
		var ToLoc = $('#ToLoc').combobox('getValue');
		var Obj = { StkGrpRowId: ScgId, StkGrpType: 'M', Locdr: FrLoc, ToLoc: ToLoc, BDPHospital: gHospId };
		return Obj;
	};
	$('#InciDesc').lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#Inci'));

	var MasterCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			saveCol: true,
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
			title: 'FrLocId',
			field: 'FrLocId',
			width: 10,
			hidden: true
		}, {
			title: 'ToLocId',
			field: 'ToLocId',
			width: 10,
			hidden: true
		}
	]];

	var MasterGrid = $UI.datagrid('#MasterGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			QueryName: 'DHCINIsTrfM',
			query2JsonStrict: 1,
			totalFooter: '"InitNo":"合计"',
			totalFields: 'RpAmt,SpAmt'
		},
		columns: MasterCm,
		showBar: true,
		showFooter: true,
		singleSelect: false,
		onSelect: function(index, row) {
			var Init = row['RowId'];
			var ParamsObj = { Init: Init, InitType: 'T' };
			$UI.clear(DetailGrid);
			$UI.clear(DetailSumGrid);
			var currTab = $('#DetailTabs').tabs('getSelected').panel('options').title;
			if (currTab == '出库单明细') {
				DetailGrid.load({
					ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
					QueryName: 'DHCINIsTrfD',
					query2JsonStrict: 1,
					Params: JSON.stringify(ParamsObj),
					rows: 99999,
					totalFooter: '"InciCode":"合计"',
					totalFields: 'RpAmt,SpAmt'
				});
			} else {
				DetailSumGrid.load({
					ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
					QueryName: 'GetDetailSum',
					query2JsonStrict: 1,
					Params: JSON.stringify(ParamsObj),
					rows: 99999,
					totalFooter: '"InciCode":"合计"',
					totalFields: 'RpAmt,SpAmt'
				});
			}
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
			title: '批次Id',
			field: 'Inclb',
			width: 120,
			hidden: true
		}, {
			title: '批号~效期',
			field: 'BatExp',
			width: 200
		}, {
			title: '生产厂家',
			field: 'ManfDesc',
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
			width: 80
		}
	]];

	var DetailGrid = $UI.datagrid('#DetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
			QueryName: 'DHCINIsTrfD',
			query2JsonStrict: 1,
			rows: 99999,
			totalFooter: '"InciCode":"合计"',
			totalFields: 'RpAmt,SpAmt'
		},
		pagination: false,
		columns: DetailCm,
		showBar: true,
		showFooter: true,
		remoteSort: false
	});
	var DetailSumCm = [[
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
			title: '批次Id',
			field: 'Inclb',
			width: 120,
			hidden: true
		}, {
			title: '批号~效期',
			field: 'BatExp',
			width: 200
		}, {
			title: '生产厂家',
			field: 'ManfDesc',
			width: 160
		}, {
			title: '批次库存',
			field: 'InclbQty',
			align: 'right',
			width: 80
		}, {
			title: '转移数量',
			field: 'Qty',
			align: 'right',
			width: 80
		}, {
			title: '开始条码',
			field: 'StartBarCode',
			width: 160
		}, {
			title: '结束条码',
			field: 'EndBarCode',
			width: 160
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
			title: '占用数量',
			field: 'InclbDirtyQty',
			align: 'right',
			width: 100
		}, {
			title: '可用数量',
			field: 'InclbAvaQty',
			align: 'right',
			width: 100
		}
	]];

	var DetailSumGrid = $UI.datagrid('#DetailSumGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
			QueryName: 'GetDetailSum',
			query2JsonStrict: 1,
			rows: 99999,
			totalFooter: '"InciCode":"合计"',
			totalFields: 'RpAmt,SpAmt'
		},
		pagination: false,
		columns: DetailSumCm,
		showBar: true,
		showFooter: true,
		remoteSort: false
	});
	$HUI.tabs('#DetailTabs', {
		onSelect: function(title) {
			var SelectedRow = MasterGrid.getSelected();
			var Init = SelectedRow['RowId'];
			var ParamsObj = { Init: Init, InitType: 'T' };
			$UI.clear(DetailGrid);
			$UI.clear(DetailSumGrid);
			if (title == '出库单明细') {
				DetailGrid.load({
					ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
					QueryName: 'DHCINIsTrfD',
					query2JsonStrict: 1,
					Params: JSON.stringify(ParamsObj),
					rows: 99999,
					totalFooter: '"InciCode":"合计"',
					totalFields: 'RpAmt,SpAmt'
				});
			} else if (title == '出库单汇总') {
				DetailSumGrid.load({
					ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
					QueryName: 'GetDetailSum',
					query2JsonStrict: 1,
					Params: JSON.stringify(ParamsObj),
					rows: 99999,
					totalFooter: '"InciCode":"合计"',
					totalFields: 'RpAmt,SpAmt'
				});
			}
		}
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