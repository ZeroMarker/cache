// 库存调整单打印
function PrintInAdj(InAdj, AutoFlag) {
	if (InAdj == null || InAdj == '') {
		return;
	}
	AutoFlag = typeof (AutoFlag) === 'undefined' ? 'N' : AutoFlag;
	// var Params = JSON.stringify({InAdj:InAdj});
	var Params = '';
	var RQStr = InAdj;
	var MainObj = $.cm({
		ClassName: 'web.DHCSTMHUI.DHCINAdj',
		MethodName: 'jsSelect',
		InAdj: InAdj
	}, false);
	var RowId = MainObj.RowId;
	var AjdLocId = MainObj.AdjLoc.RowId;
	var AjdScg = MainObj.ScgStk.RowId;
	var PrintMode = GetPrintMode(AjdLocId, AjdScg);
	var RaqName = 'DHCSTM_HUI_InAdj_Common.raq';
	if (PrintMode != '') {
		RaqName = 'DHCSTM_HUI_InAdj_Common_' + PrintMode + '.raq';
	}
	fileName = '{' + RaqName + '(Params=' + Params + ';adj=' + InAdj + ';RQStr=' + RQStr + ')}';
	if (InAdjParamObj.IndirPrint != 'N') {
		fileName = TranslateRQStr(fileName);
		DHCSTM_DHCCPM_RQPrint(fileName);
	} else {
		DHCCPM_RQDirectPrint(fileName);
	}
	Common_PrintLog('A', InAdj, AutoFlag);
}