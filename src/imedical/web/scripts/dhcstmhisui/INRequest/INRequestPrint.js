function PrintINRequest(Req, AutoFlag) {
	if (isEmpty(Req)) {
		return;
	}
	AutoFlag = typeof (AutoFlag) === 'undefined' ? 'N' : AutoFlag;
	// 是否显示已转移数据
	var ShowTransferedFlag = 1;
	var RefuseFlag = 1;
	var Params = '';
	var RQReqStr = ShowTransferedFlag + ',' + RefuseFlag;
	fileName = '{DHCSTM_HUI_INRequest_Common.raq(Params=' + Params + ';Parref=' + Req + ';RQReqStr=' + RQReqStr + ')}';
	if (InRequestParamObj.IndirPrint != 'N') {
		fileName = TranslateRQStr(fileName);
		DHCSTM_DHCCPM_RQPrint(fileName);
	} else {
		DHCCPM_RQDirectPrint(fileName);
	}
	Common_PrintLog('RQ', Req, AutoFlag);
}