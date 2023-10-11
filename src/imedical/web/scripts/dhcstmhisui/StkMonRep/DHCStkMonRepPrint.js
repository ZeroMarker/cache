function PrintStkMon(growid, activeTabtmp, SCGTYPE) {
	if (isEmpty(growid)) {
		return false;
	}
	var ParamsObj = $UI.loopBlock('#StkMonTabConditions');
	var Params = JSON.stringify(addSessionParams({ smRowid: growid, ScgType: SCGTYPE, stkgrpid: ParamsObj.StkGrpId, stkcatid: ParamsObj.StkCatBox, incdesc: ParamsObj.InciDesc }));
	if (activeTabtmp == '月报明细(售价)') {
		fileName = '{DHCSTM_HUI_ReportDetailSp_Common.raq(growid=' + growid + ';Params=' + Params + ')}';
	} else if (activeTabtmp == '月报明细(进价)') {
		fileName = '{DHCSTM_HUI_ReportDetailRp_Common.raq(growid=' + growid + ';Params=' + Params + ')}';
	} else if (activeTabtmp == '月报明细批次(售价)') {
		fileName = '{DHCSTM_HUI_ReportDetailLb_Common.raq(growid=' + growid + ';Params=' + Params + ')}';
	} else if (activeTabtmp == '月报明细批次(进价)') {
		fileName = '{DHCSTM_HUI_ReportDetailLbRp_Common.raq(growid=' + growid + ';Params=' + Params + ')}';
	} else {
		fileName = '';
		$UI.msg('alert', '此打印按钮使用于月报明细页签!');
	}
	if (fileName != '') {
		var fileName = TranslateRQStr(fileName);
		DHCSTM_DHCCPM_RQPrint(fileName);
		// DHCCPM_RQDirectPrint(fileName);
	}
}

function GetMainDataStkMon(growid) {
	if (isEmpty(growid)) {
		return false;
	}
	var mainData = tkMakeServerCall('web.DHCSTMHUI.DHCStkMon', 'GetMain', growid);
	
	return mainData;
}