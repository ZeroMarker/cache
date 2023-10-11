/* �±���ϸ��ѯ*/
var init = function() {
	var SCGTYPE = 'M';		// ��������(��������M,��������O)
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
			if (title == '�±��������(���汨��)') {
				var groupid = ParamsObj.StkGrpId;
				var params = JSON.stringify(addSessionParams({ smRowid: growid, StkGrpId: groupid, ScgType: SCGTYPE }));
				p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_ReportInIsRpLocCatCross.raq'
					+ '&growid=' + growid + '&StrParam=' + params;
				var reportFrame = document.getElementById('frameReportInIsRpLocCat');
				reportFrame.src = CommonFillUrl(p_URL);
			} else if (title == '�±�������(��Ӧ��)') {
				p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_ReportImportVendorSum.raq'
					+ '&growid=' + growid + '&StrParam=' + params;
				var reportFrame = document.getElementById('frameImportVendorSum');
				reportFrame.src = CommonFillUrl(p_URL);
			} else if (title == '�������(����)') {
				p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_ReportDetailSCGRp_Common.raq'
					+ '&Type=' + 0 + '&growid=' + growid + '&StrParam=' + params;
				var reportFrame = document.getElementById('frameDetailSCGRp');
				reportFrame.src = CommonFillUrl(p_URL);
			} else if (title == '�������(�ۼ�)') {
				p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_ReportDetailSCGRp_Common.raq'
					+ '&Type=' + 1 + '&growid=' + growid + '&StrParam=' + params;
				var reportFrame = document.getElementById('frameDetailSCGSp');
				reportFrame.src = CommonFillUrl(p_URL);
			} else if (title == '�༶����') {
				var Type = 0;
				var params = JSON.stringify(addSessionParams({ smRowid: growid, Type: Type, ScgType: SCGTYPE }));
				p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_ReportMulScg.raq'
					+ '&growid=' + growid + '&StrParam=' + params;
				var reportFrame = document.getElementById('frameMulScgRp');
				reportFrame.src = CommonFillUrl(p_URL);
			} else if (title == '���������') {
				var Type = 0;
				var params = JSON.stringify(addSessionParams({ smRowid: growid, Type: Type, ScgType: SCGTYPE }));
				p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_ReportStkCatRp.raq'
					+ '&growid=' + growid + '&StrParam=' + params;
				var reportFrame = document.getElementById('frameStkCatRp');
				reportFrame.src = CommonFillUrl(p_URL);
			} else if (title == '��������⽻�����') {
				var Type = 0;
				var params = JSON.stringify(addSessionParams({ smRowid: growid, Type: Type, ScgType: SCGTYPE }));
				p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_ReportStkCatTransRp.raq'
					+ '&growid=' + growid + '&StrParam=' + params;
				var reportFrame = document.getElementById('frameStkCatTransRp');
				reportFrame.src = CommonFillUrl(p_URL);
			} else if (title == '�±���ϸ(�ۼ�)') {
				var Params = JSON.stringify(addSessionParams({ smRowid: growid, ScgType: SCGTYPE, stkgrpid: ParamsObj.StkGrpId, stkcatid: ParamsObj.StkCatBox, incdesc: ParamsObj.InciDesc, incid: ParamsObj.InciRowid }));
				StkMonStatDetailSpGrid.load({
					ClassName: 'web.DHCSTMHUI.DHCStkMonRepQuery',
					QueryName: 'StkMonRepItm',
					query2JsonStrict: 1,
					Params: Params
				});
			} else if (title == '�±���ϸ(����)') {
				var Params = JSON.stringify(addSessionParams({ smRowid: growid, ScgType: SCGTYPE, stkgrpid: ParamsObj.StkGrpId, stkcatid: ParamsObj.StkCatBox, incdesc: ParamsObj.InciDesc, incid: ParamsObj.InciRowid }));
				StkMonStatDetailRpGrid.load({
					ClassName: 'web.DHCSTMHUI.DHCStkMonRepQuery',
					QueryName: 'StkMonRepItmRp',
					query2JsonStrict: 1,
					Params: Params
				});
			} else if (title == '�±���ϸ����(�ۼ�)') {
				var Params = JSON.stringify(addSessionParams({ smRowid: growid, ScgType: SCGTYPE, stkgrpid: ParamsObj.StkGrpId, stkcatid: ParamsObj.StkCatBox, incdesc: ParamsObj.InciDesc, incid: ParamsObj.InciRowid }));
				StkMonStatDetailLBSpGrid.load({
					ClassName: 'web.DHCSTMHUI.DHCStkMonReportLB',
					QueryName: 'StkMonRepLcBt',
					query2JsonStrict: 1,
					Params: Params
				});
			} else if (title == '�±���ϸ����(����)') {
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
			title: '�·�',
			field: 'mon',
			width: 80
		}, {
			title: '�±���ʼ����',
			field: 'frDate',
			width: 100
		}, {
			title: '�±���ֹ����',
			field: 'toDate',
			width: 100
		}, {
			title: '�±���',
			field: 'StkMonNo',
			width: 120
		}, {
			title: '����',
			field: 'locDesc',
			width: 150
		}, {
			title: 'ƾ֤��',
			field: 'AcctVoucherCode',
			width: 100
		}, {
			title: 'ƾ֤����',
			field: 'AcctVoucherDate',
			width: 100
		}, {
			title: 'ƾ֤����״̬',
			field: 'AcctVoucherStatus',
			width: 100
		}, {
			title: 'Pdf�ļ�����',
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
			$('#StkMonTab').tabs('select', '�±��������(���汨��)');
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
			$UI.msg('alert', '���Ҳ���Ϊ��!');
			return false;
		}
		var StartMonth = ParamsObj.StartDate;
		var EndMonth = ParamsObj.EndDate;
		var StartDate = StartMonth + '-01';
		var EndDate = EndMonth + '-01';
		if ((!isEmpty(StartDate)) && (!isEmpty(EndDate)) && compareDate(StartDate, EndDate)) {
			$UI.msg('alert', '��ֹ�·ݲ���С�ڿ�ʼ�·�!');
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
		// /���ó�ʼֵ ����ʹ������
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
			title: '���ʴ���',
			field: 'inciCode',
			width: 150
		}, {
			title: '��������',
			field: 'inciDesc',
			width: 150
		}, {
			title: '���',
			field: 'spec',
			width: 100
		}, {
			title: '��λ',
			field: 'uomDesc',
			width: 80
		}, {
			title: '���ڽ������',
			field: 'qty',
			width: 100,
			align: 'right'
		}, {
			title: '���ڽ����',
			field: 'amt',
			width: 100,
			align: 'right'
		}, {
			title: '���ڽ������',
			field: 'lastQty',
			width: 100,
			align: 'right'
		}, {
			title: '���ڽ����',
			field: 'lastAmt',
			width: 100,
			align: 'right'
		}, {
			title: '�������',
			field: 'recQty',
			width: 100,
			align: 'right'
		}, {
			title: '�����',
			field: 'recAmt',
			width: 100,
			align: 'right'
		}, {
			title: '�˻�����',
			field: 'retQty',
			width: 100,
			align: 'right'
		}, {
			title: '�˻����',
			field: 'retAmt',
			width: 100,
			align: 'right'
		}, {
			title: 'ת������',
			field: 'trOutQty',
			width: 100,
			align: 'right'
		}, {
			title: 'ת�����',
			field: 'trOutAmt',
			width: 100,
			align: 'right'
		}, {
			title: 'ת������',
			field: 'trInQty',
			width: 100,
			align: 'right'
		}, {
			title: 'ת����',
			field: 'trInAmt',
			width: 100,
			align: 'right'
		}, {
			title: '��������',
			field: 'adjQty',
			width: 100,
			align: 'right'
		}, {
			title: '�������',
			field: 'adjAmt',
			width: 100,
			align: 'right'
		}, {
			title: '��������',
			field: 'csmQty',
			width: 100,
			align: 'right'
		}, {
			title: '���Ľ��',
			field: 'csmAmt',
			width: 100,
			align: 'right'
		}, {
			title: '��������',
			field: 'disposeQty',
			width: 100,
			align: 'right'
		}, {
			title: '������',
			field: 'disposeAmt',
			width: 100,
			align: 'right'
		}, {
			title: '��������',
			field: 'aspAmt',
			width: 100,
			align: 'right'
		}, {
			title: '��Ʒ�������',
			field: 'giftRecQty',
			width: 100,
			align: 'right'
		}, {
			title: '��Ʒ�����',
			field: 'giftRecAmt',
			width: 100,
			align: 'right'
		}, {
			title: '��Ʒ��������',
			field: 'giftTrOutQty',
			width: 100,
			align: 'right'
		}, {
			title: '��Ʒ������',
			field: 'giftTrOutAmt',
			width: 100,
			align: 'right'
		}, {
			title: '���ۻ�Ʊ�������',
			field: 'chgRecQty',
			width: 125,
			align: 'right'
		}, {
			title: '���ۻ�Ʊ�����',
			field: 'chgRecAmt',
			width: 125,
			align: 'right'
		}, {
			title: '���ۻ�Ʊ�˻�����',
			field: 'chgRetQty',
			width: 125,
			align: 'right'
		}, {
			title: '���ۻ�Ʊ�˻����',
			field: 'chgRetAmt',
			width: 125,
			align: 'right'
		}, {
			title: '�˻�����(����)',
			field: 'retAspAmt',
			width: 105,
			align: 'right'
		}, {
			title: 'ת������(����)',
			field: 'trInAspAmt',
			width: 105,
			align: 'right'
		}, {
			title: '�̵��������',
			field: 'stktkAdjQty',
			width: 100,
			align: 'right'
		}, {
			title: '�̵�������',
			field: 'stktkAdjAmt',
			width: 100,
			align: 'right'
		}, {
			title: '��������',
			field: 'diffQty',
			width: 100,
			align: 'right'
		}, {
			title: '������',
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
			title: '���ʴ���',
			field: 'incicode',
			width: 150
		}, {
			title: '��������',
			field: 'incidesc',
			width: 150
		}, {
			title: '���',
			field: 'spec',
			width: 100
		}, {
			title: '��������',
			field: 'manf',
			width: 150
		}, {
			title: '��λ',
			field: 'puomdesc',
			width: 80
		}, {
			title: '����',
			field: 'IBNO',
			width: 100
		}, {
			title: '����',
			field: 'PuomRp',
			width: 100,
			align: 'right'
		}, {
			title: '���ڽ������',
			field: 'qty',
			width: 100,
			align: 'right'
		}, {
			title: '���ڽ����',
			field: 'coamt',
			width: 100,
			align: 'right'
		}, {
			title: '���ڽ������',
			field: 'lastqty',
			width: 100,
			align: 'right'
		}, {
			title: '���ڽ����',
			field: 'lastcoamt',
			width: 100,
			align: 'right'
		}, {
			title: '�������',
			field: 'recqty',
			width: 100,
			align: 'right'
		}, {
			title: '�����',
			field: 'reccoamt',
			width: 100,
			align: 'right'
		}, {
			title: '�˻�����',
			field: 'retqty',
			width: 100,
			align: 'right'
		}, {
			title: '�˻����',
			field: 'retcoamt',
			width: 100,
			align: 'right'
		}, {
			title: 'ת������',
			field: 'trfoqty',
			width: 100,
			align: 'right'
		}, {
			title: 'ת�����',
			field: 'trfocoamt',
			width: 100,
			align: 'right'
		}, {
			title: 'ת������',
			field: 'trfiqty',
			width: 100,
			align: 'right'
		}, {
			title: 'ת����',
			field: 'trficoamt',
			width: 100,
			align: 'right'
		}, {
			title: '��������',
			field: 'adjqty',
			width: 100,
			align: 'right'
		}, {
			title: '�������',
			field: 'adjcoamt',
			width: 100,
			align: 'right'
		}, {
			title: '�̵��������',
			field: 'stkqty',
			width: 100,
			align: 'right'
		}, {
			title: '�̵�������',
			field: 'stkcoamt',
			width: 100,
			align: 'right'
		}, {
			title: '��������',
			field: 'conqty',
			width: 100,
			align: 'right'
		}, {
			title: '������',
			field: 'concoamt',
			width: 100,
			align: 'right'
		}, {
			title: '��������',
			field: 'aspcoamt',
			width: 100,
			align: 'right'
		}, {
			title: '��������',
			field: 'diffQty',
			width: 100,
			align: 'right'
		}, {
			title: '������',
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
			title: '���ʴ���',
			field: 'incicode',
			width: 150
		}, {
			title: '��������',
			field: 'incidesc',
			width: 150
		}, {
			title: '���',
			field: 'spec',
			width: 100
		}, {
			title: '��������',
			field: 'manf',
			width: 150
		}, {
			title: '��λ',
			field: 'puomdesc',
			width: 80
		}, {
			title: '����',
			field: 'IBNO',
			width: 100
		}, {
			title: '�ۼ�',
			field: 'PuomSp',
			width: 100,
			align: 'right'
		}, {
			title: '���ڽ������',
			field: 'qty',
			width: 100,
			align: 'right'
		}, {
			title: '���ڽ����',
			field: 'amt',
			width: 100,
			align: 'right'
		}, {
			title: '���ڽ������',
			field: 'lastqty',
			width: 100,
			align: 'right'
		}, {
			title: '���ڽ����',
			field: 'lastamt',
			width: 100,
			align: 'right'
		}, {
			title: '�������',
			field: 'recqty',
			width: 100,
			align: 'right'
		}, {
			title: '�����',
			field: 'recamt',
			width: 100,
			align: 'right'
		}, {
			title: '�˻�����',
			field: 'retqty',
			width: 100,
			align: 'right'
		}, {
			title: '�˻����',
			field: 'retamt',
			width: 100,
			align: 'right'
		}, {
			title: 'ת������',
			field: 'trfoqty',
			width: 100,
			align: 'right'
		}, {
			title: 'ת�����',
			field: 'trfoamt',
			width: 100,
			align: 'right'
		}, {
			title: 'ת������',
			field: 'trfiqty',
			width: 100,
			align: 'right'
		}, {
			title: 'ת����',
			field: 'trfiamt',
			width: 100,
			align: 'right'
		}, {
			title: '��������',
			field: 'adjqty',
			width: 100,
			align: 'right'
		}, {
			title: '�������',
			field: 'adjamt',
			width: 100,
			align: 'right'
		}, {
			title: '�̵��������',
			field: 'stkqty',
			width: 100,
			align: 'right'
		}, {
			title: '�̵�������',
			field: 'stkamt',
			width: 100,
			align: 'right'
		}, {
			title: '��������',
			field: 'conqty',
			width: 100,
			align: 'right'
		}, {
			title: '������',
			field: 'conamt',
			width: 100,
			align: 'right'
		}, {
			title: '��������',
			field: 'aspamt',
			width: 100,
			align: 'right'
		}, {
			title: '��������',
			field: 'diffQty',
			width: 100,
			align: 'right'
		}, {
			title: '������',
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
	// / ��ϸ�и��ݷ���ɸѡ
	function SearchDetail() {
		var tabtitle = $('#StkMonTab').tabs('getSelected').panel('options').title;
		var ParamsObj = GetParamsObj();
		if (tabtitle == '�±���ϸ(�ۼ�)') {
			var Params = JSON.stringify(addSessionParams({ smRowid: growid, ScgType: SCGTYPE, stkgrpid: ParamsObj.StkGrpId, stkcatid: ParamsObj.StkCatBox, incdesc: ParamsObj.InciDesc, incid: ParamsObj.InciRowid }));
			StkMonStatDetailSpGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCStkMonRepQuery',
				QueryName: 'StkMonRepItm',
				query2JsonStrict: 1,
				Params: Params
			});
		} else if (tabtitle == '�±���ϸ(����)') {
			var Params = JSON.stringify(addSessionParams({ smRowid: growid, ScgType: SCGTYPE, stkgrpid: ParamsObj.StkGrpId, stkcatid: ParamsObj.StkCatBox, incdesc: ParamsObj.InciDesc, incid: ParamsObj.InciRowid }));
			StkMonStatDetailRpGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCStkMonRepQuery',
				QueryName: 'StkMonRepItmRp',
				query2JsonStrict: 1,
				Params: Params
			});
		} else if (tabtitle == '�±���ϸ����(����)') {
			var Params = JSON.stringify(addSessionParams({ smRowid: growid, ScgType: SCGTYPE, stkgrpid: ParamsObj.StkGrpId, stkcatid: ParamsObj.StkCatBox, incdesc: ParamsObj.InciDesc, incid: ParamsObj.InciRowid }));
			StkMonStatDetailLBRpGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCStkMonReportLB',
				QueryName: 'StkMonRepLcBt',
				query2JsonStrict: 1,
				Params: Params
			});
		} else if (tabtitle == '�±���ϸ����(�ۼ�)') {
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
			$UI.msg('alert', '��ѡ����Ҫ�ύƾ֤���±�!');
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
			$UI.msg('alert', '��ѡ����Ҫȡ���ύƾ֤���±�!');
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