/* 月报明细查询*/
var init = function() {
	var SCGTYPE = 'M';		// 财务类组(物资类组M,财务类组O)
	var growid = '';
	function GetParamsObj() {
		var ParamsObj = $UI.loopBlock('#StkMonTabConditions');
		return ParamsObj;
	}
	var StkMonLocParams = JSON.stringify(addSessionParams({ Type: 'Login' }));
	var StkMonLocBox = $HUI.combobox('#HistoryStkMonStatLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + StkMonLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var LocId = record['RowId'];
			$HUI.combotree('#StkGrpId').setFilterByLoc(LocId);
		}
	});
	var StkCatBox = $HUI.combobox('#StkCatBox', {
		valueField: 'RowId',
		textField: 'Description'
	});
	$('#StkGrpId').stkscgcombotree({
		onSelect: function(node) {
			$.cm({
				ClassName: 'web.DHCSTMHUI.Common.Dicts',
				QueryName: 'GetStkCat',
				ResultSetType: 'array',
				StkGrpId: node.id
			}, function(data) {
				StkCatBox.clear();
				StkCatBox.loadData(data);
			});
		}
	});
	var FinancialFlag = $HUI.checkbox('#FinancialFlag', {
		onCheckChange: function(e, value) {
			if (value) {
				SCGTYPE = 'O';
			}
		}
	});
	var HandlerParams = function() {
		var ScgId = $('#StkGrpId').combotree('getValue');
		var Locdr = $('#HistoryStkMonStatLoc').combo('getValue');
		var Obj = { StkGrpRowId: ScgId, StkGrpType: 'M', Locdr: Locdr };
		return Obj;
	};
	$('#InciDesc').lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#InciRowid'));
	$HUI.tabs('#StkMonTab', {
		onSelect: function(title) {
			var row = HistoryStkMonStatGrid.getSelected();
			if (isEmpty(row)) { return false; }
			growid = row.smRowid;
			var ParamsObj = GetParamsObj();
			var params = JSON.stringify(addSessionParams({ smRowid: growid }));
			if (title == '月报出库汇总(交叉报表)') {
				var groupid = ParamsObj.StkGrpId;
				var params = JSON.stringify(addSessionParams({ smRowid: growid, StkGrpId: groupid, ScgType: SCGTYPE }));
				p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_ReportInIsRpLocCatCross.raq'
					+ '&growid=' + growid + '&StrParam=' + params;
				var reportFrame = document.getElementById('frameReportInIsRpLocCat');
				reportFrame.src = CommonFillUrl(p_URL);
			} else if (title == '月报入库汇总(供应商)') {
				p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_ReportImportVendorSum.raq'
					+ '&growid=' + growid + '&StrParam=' + params;
				var reportFrame = document.getElementById('frameImportVendorSum');
				reportFrame.src = CommonFillUrl(p_URL);
			} else if (title == '类组汇总(进价)') {
				p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_ReportDetailSCGRp_Common.raq'
					+ '&Type=' + 0 + '&growid=' + growid + '&StrParam=' + params;
				var reportFrame = document.getElementById('frameDetailSCGRp');
				reportFrame.src = CommonFillUrl(p_URL);
			} else if (title == '类组汇总(售价)') {
				p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_ReportDetailSCGRp_Common.raq'
					+ '&Type=' + 1 + '&growid=' + growid + '&StrParam=' + params;
				var reportFrame = document.getElementById('frameDetailSCGSp');
				reportFrame.src = CommonFillUrl(p_URL);
			} else if (title == '多级类组') {
				var Type = 0;
				var params = JSON.stringify(addSessionParams({ smRowid: growid, Type: Type, ScgType: SCGTYPE }));
				p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_ReportMulScg.raq'
					+ '&growid=' + growid + '&StrParam=' + params;
				var reportFrame = document.getElementById('frameMulScgRp');
				reportFrame.src = CommonFillUrl(p_URL);
			} else if (title == '库存分类汇总') {
				var Type = 0;
				var params = JSON.stringify(addSessionParams({ smRowid: growid, Type: Type, ScgType: SCGTYPE }));
				p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_ReportStkCatRp.raq'
					+ '&growid=' + growid + '&StrParam=' + params;
				var reportFrame = document.getElementById('frameStkCatRp');
				reportFrame.src = CommonFillUrl(p_URL);
			} else if (title == '库存分类出库交叉汇总') {
				var Type = 0;
				var params = JSON.stringify(addSessionParams({ smRowid: growid, Type: Type, ScgType: SCGTYPE }));
				p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_ReportStkCatTransRp.raq'
					+ '&growid=' + growid + '&StrParam=' + params;
				var reportFrame = document.getElementById('frameStkCatTransRp');
				reportFrame.src = CommonFillUrl(p_URL);
			} else if (title == '月报明细(售价)') {
				var Params = JSON.stringify(addSessionParams({ smRowid: growid, ScgType: SCGTYPE, stkgrpid: ParamsObj.StkGrpId, stkcatid: ParamsObj.StkCatBox, incdesc: ParamsObj.InciDesc, incid: ParamsObj.InciRowid }));
				StkMonStatDetailSpGrid.load({
					ClassName: 'web.DHCSTMHUI.DHCStkMonRepQuery',
					QueryName: 'StkMonRepItm',
					query2JsonStrict: 1,
					Params: Params
				});
			} else if (title == '月报明细(进价)') {
				var Params = JSON.stringify(addSessionParams({ smRowid: growid, ScgType: SCGTYPE, stkgrpid: ParamsObj.StkGrpId, stkcatid: ParamsObj.StkCatBox, incdesc: ParamsObj.InciDesc, incid: ParamsObj.InciRowid }));
				StkMonStatDetailRpGrid.load({
					ClassName: 'web.DHCSTMHUI.DHCStkMonRepQuery',
					QueryName: 'StkMonRepItmRp',
					query2JsonStrict: 1,
					Params: Params
				});
			} else if (title == '月报明细批次(售价)') {
				var Params = JSON.stringify(addSessionParams({ smRowid: growid, ScgType: SCGTYPE, stkgrpid: ParamsObj.StkGrpId, stkcatid: ParamsObj.StkCatBox, incdesc: ParamsObj.InciDesc, incid: ParamsObj.InciRowid }));
				StkMonStatDetailLBSpGrid.load({
					ClassName: 'web.DHCSTMHUI.DHCStkMonReportLB',
					QueryName: 'StkMonRepLcBt',
					query2JsonStrict: 1,
					Params: Params
				});
			} else if (title == '月报明细批次(进价)') {
				var Params = JSON.stringify(addSessionParams({ smRowid: growid, ScgType: SCGTYPE, stkgrpid: ParamsObj.StkGrpId, stkcatid: ParamsObj.StkCatBox, incdesc: ParamsObj.InciDesc, incid: ParamsObj.InciRowid }));
				StkMonStatDetailLBRpGrid.load({
					ClassName: 'web.DHCSTMHUI.DHCStkMonReportLB',
					QueryName: 'StkMonRepLcBt',
					query2JsonStrict: 1,
					Params: Params
				});
			}
		}
	});
	var HistoryStkMonStatCm = [[
		{
			title: 'smRowid',
			field: 'smRowid',
			width: 100,
			hidden: true
		}, {
			title: '月份',
			field: 'mon',
			width: 80
		}, {
			title: '月报起始日期',
			field: 'frDate',
			width: 100
		}, {
			title: '月报截止日期',
			field: 'toDate',
			width: 100
		}, {
			title: '月报号',
			field: 'StkMonNo',
			width: 120
		}, {
			title: '科室',
			field: 'locDesc',
			width: 150
		}, {
			title: '凭证号',
			field: 'AcctVoucherCode',
			width: 100
		}, {
			title: '凭证日期',
			field: 'AcctVoucherDate',
			width: 100
		}, {
			title: '凭证处理状态',
			field: 'AcctVoucherStatus',
			width: 100
		}, {
			title: 'Pdf文件名称',
			field: 'PdfFile',
			width: 100
		}
	]];
	var HistoryStkMonStatGrid = $UI.datagrid('#HistoryStkMonStatGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCStkMon',
			QueryName: 'DHCStkMon',
			query2JsonStrict: 1
		},
		columns: HistoryStkMonStatCm,
		displayMsg: '',
		onSelect: function(index, row) {
			$('#StkMonTab').tabs('select', '月报出库汇总(交叉报表)');
			var smRowid = row.smRowid;
			growid = smRowid;
			var groupid = GetParamsObj().StkGrpId;
			var params = JSON.stringify(addSessionParams({ smRowid: smRowid, StkGrpId: groupid, ScgType: SCGTYPE }));
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_ReportInIsRpLocCatCross.raq'
				+ '&growid=' + smRowid + '&StrParam=' + params;
			var reportFrame = document.getElementById('frameReportInIsRpLocCat');
			reportFrame.src = CommonFillUrl(p_URL);
		}
	});
	$UI.linkbutton('#PrintBT', {
		onClick: function() {
			var activeTabtmp = $('#StkMonTab').tabs('getSelected').panel('options').title;
			PrintStkMon(growid, activeTabtmp, SCGTYPE);
		}
	});
	$UI.linkbutton('#SearchBT', {
		onClick: function() {
			QueryHistoryStkMonStat();
		}
	});
	function QueryHistoryStkMonStat() {
		var ParamsObj = $UI.loopBlock('#HistoryStkMonStatConditions');
		if (isEmpty(ParamsObj.HistoryStkMonStatLoc)) {
			$UI.msg('alert', '科室不能为空!');
			return false;
		}
		var StartMonth = ParamsObj.StartDate;
		var EndMonth = ParamsObj.EndDate;
		var StartDate = StartMonth + '-01';
		var EndDate = EndMonth + '-01';
		if ((!isEmpty(StartDate)) && (!isEmpty(EndDate)) && compareDate(StartDate, EndDate)) {
			$UI.msg('alert', '截止月份不能小于开始月份!');
			return;
		}
		HistoryStkMonStatGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCStkMon',
			QueryName: 'DHCStkMon',
			query2JsonStrict: 1,
			Params: JSON.stringify(ParamsObj)
		});
	}
	function ClearHistoryStkMonStat() {
		$UI.clearBlock('#HistoryStkMonStatConditions');
		$UI.clear(HistoryStkMonStatGrid);
		// /设置初始值 考虑使用配置
		var DefaultData = {
			HistoryStkMonStatLoc: gLocObj
		};
		GetReportStyle('#frameReportInIsRpLocCat');
		GetReportStyle('#frameImportVendorSum');
		GetReportStyle('#frameDetailSCGRp');
		GetReportStyle('#frameDetailSCGSp');
		GetReportStyle('#frameMulScgRp');
		GetReportStyle('#frameStkCatRp');
		GetReportStyle('#frameStkCatTransRp');
		$UI.fillBlock('#HistoryStkMonStatConditions', DefaultData);
	}
	var StkMonStatDetailCm = [[
		{
			title: 'Rowid',
			field: 'Rowid',
			width: 100,
			hidden: true
		}, {
			title: '物资代码',
			field: 'inciCode',
			width: 150
		}, {
			title: '物资名称',
			field: 'inciDesc',
			width: 150
		}, {
			title: '规格',
			field: 'spec',
			width: 100
		}, {
			title: '单位',
			field: 'uomDesc',
			width: 80
		}, {
			title: '本期结存数量',
			field: 'qty',
			width: 100,
			align: 'right'
		}, {
			title: '本期结存金额',
			field: 'amt',
			width: 100,
			align: 'right'
		}, {
			title: '上期结存数量',
			field: 'lastQty',
			width: 100,
			align: 'right'
		}, {
			title: '上期结存金额',
			field: 'lastAmt',
			width: 100,
			align: 'right'
		}, {
			title: '入库数量',
			field: 'recQty',
			width: 100,
			align: 'right'
		}, {
			title: '入库金额',
			field: 'recAmt',
			width: 100,
			align: 'right'
		}, {
			title: '退货数量',
			field: 'retQty',
			width: 100,
			align: 'right'
		}, {
			title: '退货金额',
			field: 'retAmt',
			width: 100,
			align: 'right'
		}, {
			title: '转出数量',
			field: 'trOutQty',
			width: 100,
			align: 'right'
		}, {
			title: '转出金额',
			field: 'trOutAmt',
			width: 100,
			align: 'right'
		}, {
			title: '转入数量',
			field: 'trInQty',
			width: 100,
			align: 'right'
		}, {
			title: '转入金额',
			field: 'trInAmt',
			width: 100,
			align: 'right'
		}, {
			title: '调整数量',
			field: 'adjQty',
			width: 100,
			align: 'right'
		}, {
			title: '调整金额',
			field: 'adjAmt',
			width: 100,
			align: 'right'
		}, {
			title: '消耗数量',
			field: 'csmQty',
			width: 100,
			align: 'right'
		}, {
			title: '消耗金额',
			field: 'csmAmt',
			width: 100,
			align: 'right'
		}, {
			title: '报损数量',
			field: 'disposeQty',
			width: 100,
			align: 'right'
		}, {
			title: '报损金额',
			field: 'disposeAmt',
			width: 100,
			align: 'right'
		}, {
			title: '调价损益',
			field: 'aspAmt',
			width: 100,
			align: 'right'
		}, {
			title: '赠品入库数量',
			field: 'giftRecQty',
			width: 100,
			align: 'right'
		}, {
			title: '赠品入库金额',
			field: 'giftRecAmt',
			width: 100,
			align: 'right'
		}, {
			title: '赠品出库数量',
			field: 'giftTrOutQty',
			width: 100,
			align: 'right'
		}, {
			title: '赠品出库金额',
			field: 'giftTrOutAmt',
			width: 100,
			align: 'right'
		}, {
			title: '调价换票入库数量',
			field: 'chgRecQty',
			width: 125,
			align: 'right'
		}, {
			title: '调价换票入库金额',
			field: 'chgRecAmt',
			width: 125,
			align: 'right'
		}, {
			title: '调价换票退货数量',
			field: 'chgRetQty',
			width: 125,
			align: 'right'
		}, {
			title: '调价换票退货金额',
			field: 'chgRetAmt',
			width: 125,
			align: 'right'
		}, {
			title: '退货损益(调价)',
			field: 'retAspAmt',
			width: 105,
			align: 'right'
		}, {
			title: '转入损益(调价)',
			field: 'trInAspAmt',
			width: 105,
			align: 'right'
		}, {
			title: '盘点调整数量',
			field: 'stktkAdjQty',
			width: 100,
			align: 'right'
		}, {
			title: '盘点调整金额',
			field: 'stktkAdjAmt',
			width: 100,
			align: 'right'
		}, {
			title: '数量差异',
			field: 'diffQty',
			width: 100,
			align: 'right'
		}, {
			title: '金额差异',
			field: 'diffAmt',
			width: 100,
			align: 'right'
		}
	]];
	var StkMonStatDetailSpGrid = $UI.datagrid('#StkMonStatDetailSpGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCStkMonRepQuery',
			QueryName: 'StkMonRepItm',
			query2JsonStrict: 1
		},
		showBar: true,
		columns: StkMonStatDetailCm,
		rowStyler: function(index, row) {
			var diffQty = Number(row['diffQty']);
			if (diffQty != 0) {
				return 'background-color:yellow;color:black;font-weight:bold;';
			}
		}
	});
	var StkMonStatDetailRpGrid = $UI.datagrid('#StkMonStatDetailRpGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCStkMonRepQuery',
			QueryName: 'StkMonRepItmRp',
			query2JsonStrict: 1
		},
		showBar: true,
		columns: StkMonStatDetailCm,
		rowStyler: function(index, row) {
			var diffQty = Number(row['diffQty']);
			if (diffQty != 0) {
				return 'background-color:yellow;color:black;font-weight:bold;';
			}
		}
	});
	var StkMonStatDetailLBRpCm = [[
		{
			title: 'Rowid',
			field: 'Rowid',
			width: 100,
			hidden: true
		}, {
			title: '物资代码',
			field: 'incicode',
			width: 150
		}, {
			title: '物资名称',
			field: 'incidesc',
			width: 150
		}, {
			title: '规格',
			field: 'spec',
			width: 100
		}, {
			title: '生产厂家',
			field: 'manf',
			width: 150
		}, {
			title: '单位',
			field: 'puomdesc',
			width: 80
		}, {
			title: '批次',
			field: 'IBNO',
			width: 100
		}, {
			title: '进价',
			field: 'PuomRp',
			width: 100,
			align: 'right'
		}, {
			title: '本期结存数量',
			field: 'qty',
			width: 100,
			align: 'right'
		}, {
			title: '本期结存金额',
			field: 'coamt',
			width: 100,
			align: 'right'
		}, {
			title: '上期结存数量',
			field: 'lastqty',
			width: 100,
			align: 'right'
		}, {
			title: '上期结存金额',
			field: 'lastcoamt',
			width: 100,
			align: 'right'
		}, {
			title: '入库数量',
			field: 'recqty',
			width: 100,
			align: 'right'
		}, {
			title: '入库金额',
			field: 'reccoamt',
			width: 100,
			align: 'right'
		}, {
			title: '退货数量',
			field: 'retqty',
			width: 100,
			align: 'right'
		}, {
			title: '退货金额',
			field: 'retcoamt',
			width: 100,
			align: 'right'
		}, {
			title: '转出数量',
			field: 'trfoqty',
			width: 100,
			align: 'right'
		}, {
			title: '转出金额',
			field: 'trfocoamt',
			width: 100,
			align: 'right'
		}, {
			title: '转入数量',
			field: 'trfiqty',
			width: 100,
			align: 'right'
		}, {
			title: '转入金额',
			field: 'trficoamt',
			width: 100,
			align: 'right'
		}, {
			title: '调整数量',
			field: 'adjqty',
			width: 100,
			align: 'right'
		}, {
			title: '调整金额',
			field: 'adjcoamt',
			width: 100,
			align: 'right'
		}, {
			title: '盘点调整数量',
			field: 'stkqty',
			width: 100,
			align: 'right'
		}, {
			title: '盘点调整金额',
			field: 'stkcoamt',
			width: 100,
			align: 'right'
		}, {
			title: '报损数量',
			field: 'conqty',
			width: 100,
			align: 'right'
		}, {
			title: '报损金额',
			field: 'concoamt',
			width: 100,
			align: 'right'
		}, {
			title: '调价损益',
			field: 'aspcoamt',
			width: 100,
			align: 'right'
		}, {
			title: '数量差异',
			field: 'diffQty',
			width: 100,
			align: 'right'
		}, {
			title: '金额差异',
			field: 'diffAmtRp',
			width: 100,
			align: 'right'
		}
	]];
	var StkMonStatDetailLBRpGrid = $UI.datagrid('#StkMonStatDetailLBRpGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCStkMonReportLB',
			QueryName: 'StkMonRepLcBt',
			query2JsonStrict: 1
		},
		showBar: true,
		columns: StkMonStatDetailLBRpCm,
		rowStyler: function(index, row) {
			var diffQty = Number(row['diffQty']);
			if (diffQty != 0) {
				return 'background-color:yellow;color:black;font-weight:bold;';
			}
		}
	});
	var StkMonStatDetailLBCm = [[
		{
			title: 'Rowid',
			field: 'Rowid',
			width: 100,
			hidden: true
		}, {
			title: '物资代码',
			field: 'incicode',
			width: 150
		}, {
			title: '物资名称',
			field: 'incidesc',
			width: 150
		}, {
			title: '规格',
			field: 'spec',
			width: 100
		}, {
			title: '生产厂家',
			field: 'manf',
			width: 150
		}, {
			title: '单位',
			field: 'puomdesc',
			width: 80
		}, {
			title: '批次',
			field: 'IBNO',
			width: 100
		}, {
			title: '售价',
			field: 'PuomSp',
			width: 100,
			align: 'right'
		}, {
			title: '本期结存数量',
			field: 'qty',
			width: 100,
			align: 'right'
		}, {
			title: '本期结存金额',
			field: 'amt',
			width: 100,
			align: 'right'
		}, {
			title: '上期结存数量',
			field: 'lastqty',
			width: 100,
			align: 'right'
		}, {
			title: '上期结存金额',
			field: 'lastamt',
			width: 100,
			align: 'right'
		}, {
			title: '入库数量',
			field: 'recqty',
			width: 100,
			align: 'right'
		}, {
			title: '入库金额',
			field: 'recamt',
			width: 100,
			align: 'right'
		}, {
			title: '退货数量',
			field: 'retqty',
			width: 100,
			align: 'right'
		}, {
			title: '退货金额',
			field: 'retamt',
			width: 100,
			align: 'right'
		}, {
			title: '转出数量',
			field: 'trfoqty',
			width: 100,
			align: 'right'
		}, {
			title: '转出金额',
			field: 'trfoamt',
			width: 100,
			align: 'right'
		}, {
			title: '转入数量',
			field: 'trfiqty',
			width: 100,
			align: 'right'
		}, {
			title: '转入金额',
			field: 'trfiamt',
			width: 100,
			align: 'right'
		}, {
			title: '调整数量',
			field: 'adjqty',
			width: 100,
			align: 'right'
		}, {
			title: '调整金额',
			field: 'adjamt',
			width: 100,
			align: 'right'
		}, {
			title: '盘点调整数量',
			field: 'stkqty',
			width: 100,
			align: 'right'
		}, {
			title: '盘点调整金额',
			field: 'stkamt',
			width: 100,
			align: 'right'
		}, {
			title: '报损数量',
			field: 'conqty',
			width: 100,
			align: 'right'
		}, {
			title: '报损金额',
			field: 'conamt',
			width: 100,
			align: 'right'
		}, {
			title: '调价损益',
			field: 'aspamt',
			width: 100,
			align: 'right'
		}, {
			title: '数量差异',
			field: 'diffQty',
			width: 100,
			align: 'right'
		}, {
			title: '金额差异',
			field: 'diffAmt',
			width: 100,
			align: 'right'
		}
	]];
	var StkMonStatDetailLBSpGrid = $UI.datagrid('#StkMonStatDetailLBSpGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCStkMonReportLB',
			QueryName: 'StkMonRepLcBt',
			query2JsonStrict: 1
		},
		showBar: true,
		columns: StkMonStatDetailLBCm,
		rowStyler: function(index, row) {
			var diffQty = Number(row['diffQty']);
			if (diffQty != 0) {
				return 'background-color:yellow;color:black;font-weight:bold;';
			}
		}
	});
	ClearHistoryStkMonStat();
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			SearchDetail();
		}
	});
	// / 明细中根据分类筛选
	function SearchDetail() {
		var tabtitle = $('#StkMonTab').tabs('getSelected').panel('options').title;
		var ParamsObj = GetParamsObj();
		if (tabtitle == '月报明细(售价)') {
			var Params = JSON.stringify(addSessionParams({ smRowid: growid, ScgType: SCGTYPE, stkgrpid: ParamsObj.StkGrpId, stkcatid: ParamsObj.StkCatBox, incdesc: ParamsObj.InciDesc, incid: ParamsObj.InciRowid }));
			StkMonStatDetailSpGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCStkMonRepQuery',
				QueryName: 'StkMonRepItm',
				query2JsonStrict: 1,
				Params: Params
			});
		} else if (tabtitle == '月报明细(进价)') {
			var Params = JSON.stringify(addSessionParams({ smRowid: growid, ScgType: SCGTYPE, stkgrpid: ParamsObj.StkGrpId, stkcatid: ParamsObj.StkCatBox, incdesc: ParamsObj.InciDesc, incid: ParamsObj.InciRowid }));
			StkMonStatDetailRpGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCStkMonRepQuery',
				QueryName: 'StkMonRepItmRp',
				query2JsonStrict: 1,
				Params: Params
			});
		} else if (tabtitle == '月报明细批次(进价)') {
			var Params = JSON.stringify(addSessionParams({ smRowid: growid, ScgType: SCGTYPE, stkgrpid: ParamsObj.StkGrpId, stkcatid: ParamsObj.StkCatBox, incdesc: ParamsObj.InciDesc, incid: ParamsObj.InciRowid }));
			StkMonStatDetailLBRpGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCStkMonReportLB',
				QueryName: 'StkMonRepLcBt',
				query2JsonStrict: 1,
				Params: Params
			});
		} else if (tabtitle == '月报明细批次(售价)') {
			var Params = JSON.stringify(addSessionParams({ smRowid: growid, ScgType: SCGTYPE, stkgrpid: ParamsObj.StkGrpId, stkcatid: ParamsObj.StkCatBox, incdesc: ParamsObj.InciDesc, incid: ParamsObj.InciRowid }));
			StkMonStatDetailLBSpGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCStkMonReportLB',
				QueryName: 'StkMonRepLcBt',
				query2JsonStrict: 1,
				Params: Params
			});
		}
	}
	$UI.linkbutton('#SubmitBT', {
		onClick: function() {
			SubmitStkMon();
		}
	});
	function SubmitStkMon() {
		var Row = HistoryStkMonStatGrid.getSelected();
		if (isEmpty(Row)) {
			$UI.msg('alert', '请选择需要提交凭证的月报!');
			return;
		}
		var smRowid = Row.smRowid;
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCStkMon',
			MethodName: 'Submit',
			smRowId: smRowid,
			UserId: gUserId
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				QueryHistoryStkMonStat();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	$UI.linkbutton('#CancelSubmitBT', {
		onClick: function() {
			CancelSubmitStkMon();
		}
	});
	function CancelSubmitStkMon() {
		var Row = HistoryStkMonStatGrid.getSelected();
		if (isEmpty(Row)) {
			$UI.msg('alert', '请选择需要取消提交凭证的月报!');
			return;
		}
		var smRowid = Row.smRowid;
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCStkMon',
			MethodName: 'CancelSubmit',
			smRowId: smRowid,
			UserId: gUserId
		}, function(jsonData) {
			$UI.msg('alert', jsonData.msg);
			if (jsonData.success == 0) {
				QueryHistoryStkMonStat();
			}
		});
	}
};
$(init);