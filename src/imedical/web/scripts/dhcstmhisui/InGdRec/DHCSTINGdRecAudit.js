/* 入库单审核*/
var init = function() {
	var Clear = function() {
		$UI.clearBlock('#FindConditions');
		$UI.clear(InGdRecMainGrid);
		$UI.clear(InGdRecDetailGrid);
		// 设置初始值 考虑使用配置
		var DefaultData = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate(),
			FRecLoc: gLocObj,
			AuditFlag: 'N',
			FStatusBox: 'Y'
		};
		$UI.fillBlock('#FindConditions', DefaultData);
		if (ItmTrackParamObj.AutoVirFlag == 'Y') {
			$('#VirtualFlag').checkbox('setValue', true);
		} else {
			$('#VirtualFlag').checkbox('setValue', false);
		}
		// $('#ScgId').combotree('options')['setDefaultFun']();
	};
	var FRecLocParams = JSON.stringify(addSessionParams({
		Type: 'Login',
		Element: 'FRecLoc'
	}));
	var FRecLocBox = $HUI.combobox('#FRecLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + FRecLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var LocId = record['RowId'];
			$HUI.combotree('#ScgId').setFilterByLoc(LocId);
			if (CommParObj.ApcScg == 'L') {
				FVendorBox.clear();
				var Params = JSON.stringify(addSessionParams({ APCType: 'M', LocId: LocId }));
				var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + Params;
				FVendorBox.reload(url);
			}
			$('#CreateUserId').combobox('clear');
			$('#CreateUserId').combobox('reload', $URL
				+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetDeptUser&ResultSetType=Array&Params='
				+ JSON.stringify({LocDr:LocId})
			);
		}
	});
	var VirtualFlag = $HUI.checkbox('#VirtualFlag', {
		onCheckChange: function(e, value) {
			if (value) {
				var LocId = $('#FRecLoc').combobox('getValue');
				var Info = tkMakeServerCall('web.DHCSTMHUI.Common.UtilCommon', 'GetMainLoc', LocId);
				var InfoArr = Info.split('^');
				var VituralLoc = InfoArr[0], VituralLocDesc = InfoArr[1];
				AddComboData($('#FRecLoc'), VituralLoc, VituralLocDesc);
				$('#FRecLoc').combobox('setValue', VituralLoc);
			} else {
				$('#FRecLoc').combobox('setValue', gLocId);
			}
		}
	});
	
	var RequestLocParams = JSON.stringify(addSessionParams({
		Type: 'All',
		Element: 'RequestLoc'
	}));
	var RequestLocBox = $HUI.combobox('#RequestLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + RequestLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var CreateUserIdParams = JSON.stringify(addSessionParams({
		LocDr: ''
	}));
	var CreateUserIdBox = $HUI.combobox('#CreateUserId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetDeptUser&ResultSetType=array&Params=' + CreateUserIdParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var FVendorBoxParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
	var FVendorBox = $HUI.combobox('#FVendorBox', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + FVendorBoxParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var HandlerParams = function() {
		var ScgId = $('#ScgId').combotree('getValue');
		var Locdr = $('#FRecLoc').combobox('getValue');
		var Obj = { StkGrpRowId: ScgId, StkGrpType: 'M', Locdr: Locdr, BDPHospital: gHospId };
		return Obj;
	};
	$('#InciDesc').lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#Inci'));
	$('#FInGrNo').bind('keydown', function(event) {
		if (event.keyCode == 13) {
			QueryIngrInfo();
		}
	});
	$('#HVFlag').simplecombobox({
		data: [
			{ 'RowId': '', 'Description': '全部' },
			{ 'RowId': 'Y', 'Description': '高值' },
			{ 'RowId': 'N', 'Description': '非高值' }
		]
	});
	
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			QueryIngrInfo();
		}
	});
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});
	$UI.linkbutton('#SaveInvBT', {
		onClick: function() {
			SaveInvInfo();
		}
	});
	$UI.linkbutton('#PrintBT', {
		onClick: function() {
			var RowsData = InGdRecMainGrid.getSelections();
			if (isEmpty(RowsData)) {
				$UI.msg('alert', '请选择需要打印的单据!');
				return;
			}
			var IngrStr = '';
			for (var i = 0; i < RowsData.length; i++) {
				var IngrId = RowsData[i].IngrId;
				if (IngrStr == '') {
					IngrStr = IngrId;
				} else {
					IngrStr = IngrStr + '^' + IngrId;
				}
			}
			if (IngrStr == '') {
				$UI.msg('alert', '请选择需要打印的信息!');
				return false;
			}
			PrintRec(IngrStr);
		}
	});

	$UI.linkbutton('#PrintHVColBT', {
		onClick: function() {
			var RowsData = InGdRecMainGrid.getSelections();
			if (isEmpty(RowsData)) {
				$UI.msg('alert', '请选择需要打印的单据!');
				return;
			}
			var IngrStr = '';
			for (var i = 0; i < RowsData.length; i++) {
				var IngrId = RowsData[i].IngrId;
				if (IngrStr == '') {
					IngrStr = IngrId;
				} else {
					IngrStr = IngrStr + '^' + IngrId;
				}
			}
			if (IngrStr == '') {
				$UI.msg('alert', '请选择需要打印的信息!');
				return false;
			}
			PrintRecHVCol(IngrStr);
		}
	});
	
	var SunPurPlan = CommParObj.SunPurPlan; // 参数设置 公共
	// /20221112 阳光采购
	$UI.linkbutton('#SendIngdrecBT', {
		onClick: function() {
			if (isEmpty(SunPurPlan)) {
				$UI.msg('alert', '请配置采购平台信息!');
				return;
			}
			if (SunPurPlan == '四川省') {
				SCSendIngdrec();
			}
		}
	});
	function SCSendIngdrec() {
		var RowData = InGdRecMainGrid.getSelections();
		var IngrIdStr = '';
		for (var i = 0; i < RowData.length; i++) {
			var RowIndex = InGdRecMainGrid.getRowIndex(RowData[i]);
			var AuditFlag = RowData[i].AuditFlag;
			var IngrNo = RowData[i].IngrNo;
			if (AuditFlag != 'Y') {
				$UI.msg('alert', '入库单:' + IngrNo + '未审核!');
				InGdRecMainGrid.unselectRow(RowIndex);
			}
			var IngrId = RowData[i].IngrId;
			if (IngrIdStr == '') {
				IngrIdStr = IngrId;
			} else {
				IngrIdStr = IngrIdStr + '^' + IngrId;
			}
		}
		if (isEmpty(IngrIdStr)) {
			$UI.msg('alert', '请选择要同步的入库单!');
			return false;
		}
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.ServiceForSCYGCG',
			MethodName: 'JsSendIngrStr',
			IngrStr: IngrIdStr
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				var retinfo = jsonData.msg;
				var retarr = retinfo.split('@');
				var all = Number(retarr[0]) + Number(retarr[1]);
				var sucret = retarr[2];
				var failret = retarr[3];
				$UI.msg('alert', '共' + all + '条入库单；成功：' + retarr[0] + '条；失败：' + retarr[1] + '条' + failret);
			}
		});
	}
	// / 20221112 阳光采购 依据入库单生成订单
	$UI.linkbutton('#CreatePoByRecBT', {
		onClick: function() {
			 	if (isEmpty(SunPurPlan)) {
				$UI.msg('alert', '请配置采购平台信息!');
				return;
			}
			if (SunPurPlan == '四川省') {
				SCjsCreatePoByRec();
			}
		}
	});
	function SCjsCreatePoByRec() {
		var RowData = InGdRecMainGrid.getSelections();
		var IngrIdStr = '';
		for (var i = 0; i < RowData.length; i++) {
			var AuditFlag = RowData[i].AuditFlag;
			if (AuditFlag != 'Y') {
				continue;
			}
			var IngrId = RowData[i].IngrId;
			if (IngrIdStr == '') {
				IngrIdStr = IngrId;
			} else {
				IngrIdStr = IngrIdStr + '^' + IngrId;
			}
		}
		if (IngrIdStr == '') {
			$UI.msg('alert', '没有需要处理的单据!');
			return false;
		}
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.INPurPlan',
			MethodName: 'jsCreatePoByRec',
			UserId: gUserId,
			IngrIdStr: IngrIdStr
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				QueryIngrInfo();
				var info = jsonData.msg;
				var infoArr = info.split('@');
				var Allcnt = infoArr[0];
				var Succnt = infoArr[1];
				var failcnt = Number(Allcnt) - Number(Succnt);
				var ErrInfo = infoArr[2];
				$UI.msg('success', '共:' + Allcnt + '记录,成功:' + Succnt + '条');
				if (failcnt > 0) {
					$UI.msg('error', '失败:' + failcnt + '条;' + ErrInfo);
				}
			}
		});
	}
		
	// 阳光 end
	var InGdRecMainCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'IngrId',
			width: 100,
			hidden: true
		}, {
			title: '入库单号',
			field: 'IngrNo',
			width: 120
		}, {
			title: '入库科室',
			field: 'RecLoc',
			width: 150
		}, {
			title: '接收科室',
			field: 'ReqLocDesc',
			width: 150
		}, {
			title: '供应商',
			field: 'Vendor',
			width: 200
		}, {
			title: '资金来源',
			field: 'SourceOfFund',
			width: 80
		}, {
			title: '创建人',
			field: 'CreateUser',
			width: 70
		}, {
			title: '创建日期',
			field: 'CreateDate',
			width: 90
		}, {
			title: '创建时间',
			field: 'CreateTime',
			width: 90
		}, {
			title: '审核人',
			field: 'AuditUser',
			width: 70
		}, {
			title: '审核日期',
			field: 'AuditDate',
			width: 90
		}, {
			title: '订单号',
			field: 'PoNo',
			width: 120
		}, {
			title: '入库类型',
			field: 'IngrType',
			width: 80
		}, {
			title: '进价金额',
			field: 'RpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '售价金额',
			field: 'SpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '进销差价',
			field: 'Margin',
			width: 100,
			align: 'right'
		}, {
			title: '备注',
			field: 'InGrRemarks',
			width: 100
		}, {
			title: '赠送标志',
			field: 'GiftFlag',
			width: 80,
			formatter: BoolFormatter,
			align: 'center'
		}, {
			title: '调价换票标志',
			field: 'AdjCheque',
			width: 100,
			formatter: BoolFormatter,
			align: 'center'
		}, {
			title: 'ReqLoc',
			field: 'ReqLoc',
			width: 10,
			hidden: true
		}, {
			title: 'Complete',
			field: 'Complete',
			width: 10,
			hidden: true
		}, {
			title: 'StkGrp',
			field: 'StkGrp',
			width: 10,
			hidden: true
		}, {
			title: 'AuditFlag',
			field: 'AuditFlag',
			width: 10,
			hidden: true
		}, {
			title: '审核状态',
			field: 'Audit',
			width: 80
		}, {
			title: '打印次数',
			field: 'PrintCount',
			width: 80,
			align: 'right'
		}, {
			title: 'RecLocId',
			field: 'RecLocId',
			width: 10,
			hidden: true
		}
	]];
	var InGdRecMainGrid = $UI.datagrid('#InGdRecMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			QueryName: 'Query',
			query2JsonStrict: 1,
			totalFooter: '"IngrNo":"合计"',
			totalFields: 'RpAmt,SpAmt'
		},
		columns: InGdRecMainCm,
		showBar: true,
		showFooter: true,
		singleSelect: false,
		onSelect: function(index, row) {
			InGdRecDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
				QueryName: 'QueryDetail',
				query2JsonStrict: 1,
				Parref: row.IngrId,
				rows: 99999,
				totalFooter: '"IncCode":"合计"',
				totalFields: 'RpAmt,SpAmt'
			});
		},
		onLoadSuccess: function(data) {
			if ((data.rows.length > 0) && (CommParObj.IfSelFirstRow == 'Y')) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});

	var InGdRecDetailCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '物资代码',
			field: 'IncCode',
			width: 80
		}, {
			title: '物资名称',
			field: 'IncDesc',
			width: 160
		}, {
			title: '规格',
			field: 'Spec',
			width: 80
		}, {
			title: '高值条码',
			field: 'HVBarCode',
			width: 140
		}, {
			title: '自带条码',
			field: 'OrigiBarCode',
			width: 80
		}, {
			title: '生产厂家',
			field: 'Manf',
			width: 180
		}, {
			title: '批次id',
			field: 'Inclb',
			width: 70,
			hidden: true
		}, {
			title: '批号',
			field: 'BatchNo',
			width: 90
		}, {
			title: '有效期',
			field: 'ExpDate',
			width: 100
		}, {
			title: '单位',
			field: 'IngrUom',
			width: 80
		}, {
			title: '数量',
			field: 'RecQty',
			width: 80,
			align: 'right'
		}, {
			title: '进价',
			field: 'Rp',
			width: 60,
			align: 'right'
		}, {
			title: '售价',
			field: 'Sp',
			width: 60,
			align: 'right'
		}, {
			title: '发票代码',
			field: 'InvCode',
			width: 80,
			editor: {
				type: 'text'
			}
		}, {
			title: '发票号',
			field: 'InvNo',
			width: 80,
			editor: {
				type: 'text'
			}
		}, {
			title: '发票日期',
			field: 'InvDate',
			width: 100,
			editor: {
				type: 'datebox'
			}
		}, {
			title: '发票金额',
			field: 'InvMoney',
			width: 100,
			align: 'right',
			editor: {
				type: 'numberbox',
				options: {
					min: 0,
					precision: GetFmtNum('FmtRA')
				}
			}
		}, {
			title: '国家医保编码',
			field: 'MatInsuCode',
			width: 160
		}, {
			title: '国家医保名称',
			field: 'MatInsuDesc',
			width: 160
		}, {
			title: '进价金额',
			field: 'RpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '售价金额',
			field: 'SpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '进销差价',
			field: 'Margin',
			width: 100,
			align: 'right'
		}, {
			title: '随行单号',
			field: 'SxNo',
			width: 140
		}, {
			title: '调价单状态',
			field: 'AdjSpStatus',
			width: 80
		}, {
			title: '病人信息',
			field: 'PatInfo',
			width: 160
		}
	]];

	var InGdRecDetailGrid = $UI.datagrid('#InGdRecDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
			QueryName: 'QueryDetail',
			query2JsonStrict: 1,
			rows: 99999,
			totalFooter: '"IncCode":"合计"',
			totalFields: 'RpAmt,SpAmt'
		},
		pagination: false,
		columns: InGdRecDetailCm,
		showBar: true,
		showFooter: true,
		toolbar: [
			{
				text: '打印条码',
				iconCls: 'icon-print',
				handler: function() {
					IngrPrintBarcode();
				}
			}
		],
		onClickRow: function(index, row) {
			InGdRecDetailGrid.commonClickRow(index, row);
		}
	});

	function IngrPrintBarcode() {
		var Rows = InGdRecDetailGrid.getSelections();
		$.each(Rows, function(index, item) {
			var BarCode = item.HVBarCode;
			if (isEmpty(BarCode)) {
				return;
			}
			PrintBarcode(BarCode);
		});
	}

	function QueryIngrInfo() {
		$UI.clear(InGdRecMainGrid);
		$UI.clear(InGdRecDetailGrid);
		var ParamsObj = $UI.loopBlock('#FindConditions');
		var StartDate = ParamsObj.StartDate;
		var EndDate = ParamsObj.EndDate;
		if (isEmpty(ParamsObj.FRecLoc)) {
			$UI.msg('alert', '入库科室不能为空!');
			return false;
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
		ParamsObj.QueryType = 'audit';
		var Params = JSON.stringify(ParamsObj);
		InGdRecMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			QueryName: 'Query',
			query2JsonStrict: 1,
			Params: Params,
			totalFooter: '"IngrNo":"合计"',
			totalFields: 'RpAmt,SpAmt'
		});
	}
	function CheckDataBeforeAudit() {
		var RowsData = InGdRecMainGrid.getSelections();
		for (var i = 0; i < RowsData.length; i++) {
			var AuditFlag = RowsData[i].AuditFlag;
			var IngrNo = RowsData[i].IngrNo;
			if (AuditFlag == 'Y') {
				$UI.msg('alert', IngrNo + '入库单已审核!');
				return false;
			}
			var IngrId = RowsData[i].IngrId;
			var Oerecflag = tkMakeServerCall('web.DHCSTMHUI.DHCINGdRec', 'GetOeriRecFlag', IngrId);
			if ((Oerecflag != 'Y') && (UseItmTrack) && (CheckHighValueLabels('G', IngrId) == false)) {
				$UI.msg('alert', IngrNo + '高值条码数异常!');
				return false;
			}
			var InStkTkParamObj = GetAppPropValue('DHCSTINSTKTKM');
			if (InStkTkParamObj.AllowBusiness != 'Y') {
				var phaLoc = RowsData[i].RecLocId;
				var IfExistInStkTk = tkMakeServerCall('web.DHCSTMHUI.INStkTk', 'CheckInStkTkByLoc', phaLoc);
				if (IfExistInStkTk == 'Y') {
					$UI.msg('alert', '存在未完成的盘点单不允许审核!');
					return false;
				}
			}
		}
		return true;
	}
	$UI.linkbutton('#AuditBT', {
		onClick: function() {
			if (CheckDataBeforeAudit()) {
				var RowData = InGdRecMainGrid.getSelections();
				if ((isEmpty(RowData)) || (RowData.length == 0)) {
					$UI.msg('alert', '请选择需要审核的单据!');
					return false;
				}
				if (IngrParamObj.ConfirmBeforeAudit == 'Y') {
					$UI.confirm('您将要审核所选单据,是否继续?', '', '', IngrAudit);
				} else {
					IngrAudit();
				}
			}
		}
	});
	function IngrAudit() {
		var RowData = InGdRecMainGrid.getSelections();
		var IngrIdStr = '';
		for (var i = 0; i < RowData.length; i++) {
			var IngrId = RowData[i].IngrId;
			if (IngrIdStr == '') {
				IngrIdStr = IngrId;
			} else {
				IngrIdStr = IngrIdStr + '^' + IngrId;
			}
		}
		if (IngrIdStr == '') {
			$UI.msg('alert', '没有需要审核的单据!');
			return false;
		}
		var Params = JSON.stringify(sessionObj);
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			MethodName: 'jsAudit',
			Params: Params,
			IngrIdStr: IngrIdStr
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				QueryIngrInfo();
				var info = jsonData.msg;
				var infoArr = info.split('@');
				var Allcnt = infoArr[0];
				var Succnt = infoArr[1];
				var failcnt = Allcnt - Succnt;
				var ErrInfo = infoArr[2];
				$UI.msg('success', '共:' + Allcnt + '记录,成功:' + Succnt + '条');
				if (failcnt > 0) {
					$UI.msg('error', '失败:' + failcnt + '条;' + ErrInfo);
				}
				var IngrIdStr = jsonData.rowid;
				if ((Succnt > 0) && (IngrParamObj.AutoPrintAfterAudit == 'Y')) {
					PrintRec(IngrIdStr);
				}
			}
		});
	}
	function SaveInvInfo() {
		var rowsData = InGdRecDetailGrid.getRowsData();
		if (rowsData.length <= 0) {
			$UI.msg('alert', '无需要处理的明细信息!');
			return false;
		}
		for (var i = 0; i < rowsData.length; i++) {
			var row = rowsData[i];
			var RowId = row.RowId;
			var InvCode = row.InvCode;
			var InvNo = row.InvNo;
			var InvDate = row.InvDate;
			var InvMoney = row.InvMoney;
			var SxNo = row.SxNo;
			var Params = JSON.stringify(addSessionParams({
				TrType: 'G',
				RowId: RowId,
				InvCode: InvCode,
				InvNo: InvNo,
				InvDate: InvDate,
				InvMoney: InvMoney,
				SxNo: SxNo
			}));
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINGdRec',
				MethodName: 'jsUpdateINV',
				Params: Params
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					QueryIngrInfo();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	}
	Clear();
	QueryIngrInfo();
};
$(init);