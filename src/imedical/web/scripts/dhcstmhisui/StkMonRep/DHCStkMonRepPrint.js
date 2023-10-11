function PrintStkMon(growid, activeTabtmp, SCGTYPE) {
	if (isEmpty(growid)) {
		return false;
	}
	var ParamsObj = $UI.loopBlock('#StkMonTabConditions');
	var Params = JSON.stringify(addSessionParams({ smRowid: growid, ScgType: SCGTYPE, stkgrpid: ParamsObj.StkGrpId, stkcatid: ParamsObj.StkCatBox, incdesc: ParamsObj.InciDesc }));
	if (activeTabtmp == '�±���ϸ(�ۼ�)') {
		fileName = '{DHCSTM_HUI_ReportDetailSp_Common.raq(growid=' + growid + ';Params=' + Params + ')}';
	} else if (activeTabtmp == '�±���ϸ(����)') {
		fileName = '{DHCSTM_HUI_ReportDetailRp_Common.raq(growid=' + growid + ';Params=' + Params + ')}';
	} else if (activeTabtmp == '�±���ϸ����(�ۼ�)') {
		fileName = '{DHCSTM_HUI_ReportDetailLb_Common.raq(growid=' + growid + ';Params=' + Params + ')}';
	} else if (activeTabtmp == '�±���ϸ����(����)') {
		fileName = '{DHCSTM_HUI_ReportDetailLbRp_Common.raq(growid=' + growid + ';Params=' + Params + ')}';
	} else {
		fileName = '';
		$UI.msg('alert', '�˴�ӡ��ťʹ�����±���ϸҳǩ!');
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