function PrintINStk(Inst, type) {
	if (Inst == null || Inst == '') {
		return;
	}
	var NoFreezeZero = InStkTkParamObj.NoFreezeZeroWhilePrint;		// ��ӡʱ���˶�����Ϊ0����Ŀ
	var Others = JSON.stringify({ NoFreezeZero: NoFreezeZero });
	var MainObj = GetMainData(Inst);
	var ScgId = MainObj.StkScg.RowId;
	var RecLoc = MainObj.SupLoc.RowId;
	var PrintMode = GetPrintMode(RecLoc, ScgId);
	if (type == 2) {
		RaqName = 'DHCSTM_HUI_INStkTk_Commoninci.raq';
		if (PrintMode != '') {
			RaqName = 'DHCSTM_HUI_INStkTk_Commoninci_' + PrintMode + '.raq';
		}
	} else {
		RaqName = 'DHCSTM_HUI_INStkTk_Common.raq';
		if (PrintMode != '') {
			RaqName = 'DHCSTM_HUI_INStkTk_Common_' + PrintMode + '.raq';
		}
	}
	var fileName = '{' + RaqName + '(Inst=' + Inst + ';Others=' + Others + ')}';
	if (InStkTkParamObj.IndirPrint != 'N') {
		fileName = TranslateRQStr(fileName);
		DHCSTM_DHCCPM_RQPrint(fileName);
	} else {
		DHCCPM_RQDirectPrint(fileName);
	}
	Common_PrintLog('STK', Inst, '');
	PrintFlag(Inst);
}
function PrintFlag(Inst) {
	if (isEmpty(Inst)) {
		return;
	}
	$.cm({
		ClassName: 'web.DHCSTMHUI.INStkTk',
		MethodName: 'jsUpPrintFlag',
		Inst: Inst
	}, function(jsonData) {
		
	});
}
/*
 * description:ȡ���̵㵥������Ϣ
 * params: ingr:�̵㵥����id
 * return:
*/
function GetMainData(Inst) {
	if (isEmpty(Inst)) {
		return;
	}
	var MainObj = $.cm({
		ClassName: 'web.DHCSTMHUI.INStkTk',
		MethodName: 'jsSelect',
		Inst: Inst
	}, false);
	return MainObj;
}