function PrintInIsTrf(InitStr, AutoFlag) {
	InitStr = InitStr.toString();
	if (PrintMethod == 0) {
		var InitArr = InitStr.split('^');
		var InitCount = InitArr.length;
		if (InitCount <= 0) {
			return;
		}
		for (var i = 0; i < InitCount; i++) {
			var Init = InitArr[i];
			var HVFlag = GetCertDocHVFlag(Init, 'T');
			if (HVFlag == 'Y') {
				LodopPrintInIsTrf(Init, AutoFlag);
			} else {
				LodopPrintInIsTrfHVCol(Init, AutoFlag);
			}
		}
	} else {
		RQPrintInIsTrf(InitStr, AutoFlag);
	}
}

function PrintInIsTrfHVCol(InitStr, AutoFlag) {
	InitStr = InitStr.toString();
	if (PrintMethod == 0) {
		var InitArr = InitStr.split('^');
		var InitCount = InitArr.length;
		if (InitCount <= 0) {
			return;
		}
		for (var i = 0; i < InitCount; i++) {
			var Init = InitArr[i];
			LodopPrintInIsTrfHVCol(Init, AutoFlag);
		}
	} else {
		RQPrintInIsTrfHVCol(InitStr, AutoFlag);
	}
}

function PrintInIsTrfReturn(InitStr, AutoFlag) {
	InitStr = InitStr.toString();
	if (PrintMethod == 0) {
		var InitArr = InitStr.split('^');
		var InitCount = InitArr.length;
		if (InitCount <= 0) {
			return;
		}
		for (var i = 0; i < InitCount; i++) {
			var Init = InitArr[i];
			var HVFlag = GetCertDocHVFlag(Init, 'T');
			if (HVFlag == 'Y') {
				LodopPrintInIsTrfReturn(Init, AutoFlag);
			} else {
				LodopPrintInIsTrfReturnHVCol(Init, AutoFlag);
			}
		}
	} else {
		RQPrintInIsTrfReturn(InitStr, AutoFlag);
	}
}

function PrintInIsTrfReturnHVCol(InitStr, AutoFlag) {
	InitStr = InitStr.toString();
	if (PrintMethod == 0) {
		var InitArr = InitStr.split('^');
		var InitCount = InitArr.length;
		if (InitCount <= 0) {
			return;
		}
		for (var i = 0; i < InitCount; i++) {
			var Init = InitArr[i];
			LodopPrintInIsTrfReturnHVCol(Init, AutoFlag);
		}
	} else {
		RQPrintInIsTrfReturnHVCol(InitStr, AutoFlag);
	}
}

// ���ⵥLodop��ӡ
function LodopPrintInIsTrf(Init, AutoFlag) {
	if (Init == null || Init == '') {
		return;
	}
	AutoFlag = typeof (AutoFlag) === 'undefined' ? 'N' : AutoFlag;
	// ��ȡ��ӡ�������Ƿ�Ԥ����ӡ�������ӡ��־�ʹ���
	var PrintNum = parseInt(InitParamObj.PrintNum);
	var IndirPrint = InitParamObj.IndirPrint;
	// ��־�ʹ�������
	if (!isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	Common_PrintLog('T', Init, AutoFlag, PrintNum);
	var MainObj = $.cm({
		ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
		MethodName: 'Select',
		Init: Init
	}, false);
	var DetailData = GetDetailDataInIs(Init, 'T'); // ��ϸ��Ϣ
	var FrLocDesc = MainObj.InitFrLoc.Description;
	var ToLocDesc = MainObj.InitToLoc.Description;
	var InitNo = MainObj.InitNo;
	var InitReqUser = MainObj.InitReqUser.Description;
	var InitDate = MainObj.InitDate;
	var InitUser = MainObj.InitUser.Description;
	var InitAckUser = MainObj.InitAckUserName;
	var PrintDate = DateFormatter(new Date());
	// ������Ϣչʾ
	var TaskName = '���ⵥ��ӡ'; // ��ӡ��������
	// ������Ϣ
	var Title = FrLocDesc + '���ⵥ';
	// ҳü��Ϣ
	var Head = '���տ���:' + ToLocDesc + '      '
			+ '���ⵥ��:' + InitNo + '      '
			+ '�Ƶ�����:' + InitDate;
	// ҳβ��Ϣ
	var Foot = '��ӡ����:' + PrintDate + '          '
			+ '�Ƶ�:' + InitUser + '          '
			+ '���:' + InitAckUser + '          '
			+ '����:' + InitReqUser;
	// ��ϸ��Ϣչʾ
	var Cols = [
		{ field: 'Num', title: '���', width: '25px', align: 'center' },
		{ field: 'InciCode', title: '���ʴ���', width: '10%', align: 'left' },
		{ field: 'InciDesc', title: '��������', width: '13%', align: 'left' },
		{ field: 'Spec', title: '���', width: '7%', align: 'left' },
		{ field: 'SterilizedBat', title: '�������', width: '10%', align: 'left' },
		{ field: 'UomDesc', title: '��λ', width: '5%', align: 'left' },
		{ field: 'Qty', title: '����', width: '5%', align: 'right', format: '#,##0.00' },
		{ field: 'BatExp', title: '����~Ч��', width: '15%', align: 'left' },
		{ field: 'Rp', title: '����', width: '7%', align: 'right', format: '#,##0.00' },
		{ field: 'RpAmt', title: '���۽��', width: '10%', align: 'right', format: '#,##0.00', sum: 'Y' },
		{ field: 'SpecDesc', title: '������', width: '10%', align: 'left' },
		{ field: 'ManfDesc', title: '��������', width: '10%', align: 'left' }
		//	{field:"Sp",title:"�ۼ�",width:"100px",align:"right",format:"#,##0.00"},
		//	{field:"SpAmt",title:"�ۼ۽��",width:"100px",align:"right",format:"#,##0.00",sum:"Y"}
	];
	PrintDocument(PrintNum, IndirPrint, TaskName, Title, Head, Foot, Cols, DetailData);
}
// ��ֵ���ⵥLodop��ӡ
function LodopPrintInIsTrfHVCol(Init, AutoFlag) {
	if (Init == null || Init == '') {
		return;
	}
	AutoFlag = typeof (AutoFlag) === 'undefined' ? 'N' : AutoFlag;
	// ��ȡ��ӡ�������Ƿ�Ԥ����ӡ�������ӡ��־�ʹ���
	var PrintNum = parseInt(InitParamObj.PrintNum);
	var IndirPrint = InitParamObj.IndirPrint;
	// ��־�ʹ�������
	if (!isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	Common_PrintLog('T', Init, AutoFlag, PrintNum);
	var MainObj = $.cm({
		ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
		MethodName: 'Select',
		Init: Init
	}, false);
	var DetailData = GetHVColDetailData(Init, 'T'); // ��ϸ��Ϣ
	var FrLocDesc = MainObj.InitFrLoc.Description;
	var ToLocDesc = MainObj.InitToLoc.Description;
	var InitNo = MainObj.InitNo;
	var InitReqUser = MainObj.InitReqUser.Description;
	var InitDate = MainObj.InitDate;
	var InitUser = MainObj.InitUser.Description;
	var InitAckUser = MainObj.InitAckUserName;
	var PrintDate = DateFormatter(new Date());
	// ������Ϣչʾ
	var TaskName = '��ֵ���ⵥ��ӡ'; // ��ӡ��������
	// ������Ϣ
	var Title = FrLocDesc + '���ⵥ';
	// ҳü��Ϣ
	var Head = '���տ���:' + ToLocDesc + '      '
			+ '���ⵥ��:' + InitNo + '      '
			+ '�Ƶ�����:' + InitDate;
	// ҳβ��Ϣ
	var Foot = '��ӡ����:' + PrintDate + '          '
			+ '�Ƶ�:' + InitUser + '          '
			+ '���:' + InitAckUser + '          '
			+ '����:' + InitReqUser;
	// ��ϸ��Ϣչʾ
	var Cols = [
		{ field: 'Num', title: '���', width: '25px', align: 'center' },
		{ field: 'InciCode', title: '���ʴ���', width: '10%', align: 'left' },
		{ field: 'InciDesc', title: '��������', width: '13%', align: 'left' },
		{ field: 'Spec', title: '���', width: '7%', align: 'left' },
		{ field: 'SterilizedBat', title: '�������', width: '10%', align: 'left' },
		{ field: 'UomDesc', title: '��λ', width: '5%', align: 'left' },
		{ field: 'Qty', title: '����', width: '5%', align: 'right', format: '#,##0.00' },
		{ field: 'BatExp', title: '����~Ч��', width: '15%', align: 'left' },
		{ field: 'Rp', title: '����', width: '7%', align: 'right', format: '#,##0.00' },
		{ field: 'RpAmt', title: '���۽��', width: '10%', align: 'right', format: '#,##0.00', sum: 'Y' },
		{ field: 'SpecDesc', title: '������', width: '10%', align: 'left' },
		{ field: 'ManfDesc', title: '��������', width: '10%', align: 'left' }
	//	{field:"Sp",title:"�ۼ�",width:"100px",align:"right",format:"#,##0.00"},
	//	{field:"SpAmt",title:"�ۼ۽��",width:"100px",align:"right",format:"#,##0.00",sum:"Y"}
	];
	PrintDocument(PrintNum, IndirPrint, TaskName, Title, Head, Foot, Cols, DetailData);
}
// �˿ⵥLodop��ӡ
function LodopPrintInIsTrfReturn(Init, AutoFlag) {
	if (Init == null || Init == '') {
		return;
	}
	AutoFlag = typeof (AutoFlag) === 'undefined' ? 'N' : AutoFlag;
	// ��ȡ��ӡ�������Ƿ�Ԥ����ӡ�������ӡ��־�ʹ���
	var PrintNum = parseInt(InitParamObj.PrintNum);
	var IndirPrint = InitParamObj.IndirPrint;
	// ��־�ʹ�������
	if (isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	Common_PrintLog('T', Init, AutoFlag, PrintNum);
	var MainObj = $.cm({
		ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
		MethodName: 'Select',
		Init: Init
	}, false);
	var DetailData = GetDetailDataInIs(Init, 'K'); // ��ϸ��Ϣ
	var FrLocDesc = MainObj.InitFrLoc.Description;
	var ToLocDesc = MainObj.InitToLoc.Description;
	var InitNo = MainObj.InitNo;
	var InitReqUser = MainObj.InitReqUser.Description;
	var InitDate = MainObj.InitDate;
	var InitUser = MainObj.InitUser.Description;
	var PrintDate = DateFormatter(new Date());
	// ������Ϣչʾ
	var TaskName = '�˿ⵥ��ӡ'; // ��ӡ��������
	// ������Ϣ
	var Title = ToLocDesc + '�˿ⵥ';
	// ҳü��Ϣ
	var Head = '�˿����:' + FrLocDesc + '      '
			+ '�˿ⵥ��:' + InitNo + '      '
			+ '�Ƶ�����:' + InitDate;
	// ҳβ��Ϣ
	var Foot = '��ӡ����:' + PrintDate + '          '
			+ '���:' + '          '
			+ '�˿���:' + '          '
			+ '�Ƶ���:' + InitUser;
	// ��ϸ��Ϣչʾ
	var Cols = [
		{ field: 'Num', title: '���', width: '25px', align: 'center' },
		{ field: 'InciCode', title: '���ʴ���', width: '10%', align: 'left' },
		{ field: 'InciDesc', title: '��������', width: '13%', align: 'left' },
		{ field: 'Spec', title: '���', width: '7%', align: 'left' },
		{ field: 'SterilizedBat', title: '�������', width: '10%', align: 'left' },
		{ field: 'UomDesc', title: '��λ', width: '5%', align: 'left' },
		{ field: 'Qty', title: '����', width: '5%', align: 'right', format: '#,##0.00' },
		{ field: 'BatExp', title: '����~Ч��', width: '15%', align: 'left' },
		{ field: 'Rp', title: '����', width: '7%', align: 'right', format: '#,##0.00' },
		{ field: 'RpAmt', title: '���۽��', width: '10%', align: 'right', format: '#,##0.00', sum: 'Y' },
		{ field: 'SpecDesc', title: '������', width: '10%', align: 'left' },
		{ field: 'ManfDesc', title: '��������', width: '10%', align: 'left' }
	//	{field:"Sp",title:"�ۼ�",width:"100px",align:"right",format:"#,##0.00"},
	//	{field:"SpAmt",title:"�ۼ۽��",width:"100px",align:"right",format:"#,##0.00",sum:"Y"}
	];
	PrintDocument(PrintNum, IndirPrint, TaskName, Title, Head, Foot, Cols, DetailData);
}
// ��ֵ�˿ⵥLodop��ӡ
function LodopPrintInIsTrfReturnHVCol(Init, AutoFlag) {
	if (Init == null || Init == '') {
		return;
	}
	AutoFlag = typeof (AutoFlag) === 'undefined' ? 'N' : AutoFlag;
	// ��ȡ��ӡ�������Ƿ�Ԥ����ӡ�������ӡ��־�ʹ���
	var PrintNum = parseInt(InitParamObj.PrintNum);
	var IndirPrint = InitParamObj.IndirPrint;
	// ��־�ʹ�������
	if (isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	Common_PrintLog('T', Init, AutoFlag, PrintNum);
	var MainObj = $.cm({
		ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
		MethodName: 'Select',
		Init: Init
	}, false);
	var DetailData = GetHVColDetailData(Init, 'K'); // ��ϸ��Ϣ
	var FrLocDesc = MainObj.InitFrLoc.Description;
	var ToLocDesc = MainObj.InitToLoc.Description;
	var InitNo = MainObj.InitNo;
	var InitReqUser = MainObj.InitReqUser.Description;
	var InitDate = MainObj.InitDate;
	var InitUser = MainObj.InitUser.Description;
	var PrintDate = DateFormatter(new Date());
	// ������Ϣչʾ
	var TaskName = '��ֵ�˿ⵥ��ӡ'; // ��ӡ��������
	// ������Ϣ
	var Title = ToLocDesc + '�˿ⵥ';
	// ҳü��Ϣ
	var Head = '�˿����:' + FrLocDesc + '      '
			+ '�˿ⵥ��:' + InitNo + '      '
			+ '�Ƶ�����:' + InitDate;
	// ҳβ��Ϣ
	var Foot = '��ӡ����:' + PrintDate + '          '
			+ '���:' + '          '
			+ '�˿���:' + '          '
			+ '�Ƶ���:' + InitUser;
	// ��ϸ��Ϣչʾ
	var Cols = [
		{ field: 'Num', title: '���', width: '25px', align: 'center' },
		{ field: 'InciCode', title: '���ʴ���', width: '10%', align: 'left' },
		{ field: 'InciDesc', title: '��������', width: '13%', align: 'left' },
		{ field: 'Spec', title: '���', width: '7%', align: 'left' },
		{ field: 'SterilizedBat', title: '�������', width: '10%', align: 'left' },
		{ field: 'UomDesc', title: '��λ', width: '5%', align: 'left' },
		{ field: 'Qty', title: '����', width: '5%', align: 'right', format: '#,##0.00' },
		{ field: 'BatExp', title: '����~Ч��', width: '15%', align: 'left' },
		{ field: 'Rp', title: '����', width: '7%', align: 'right', format: '#,##0.00' },
		{ field: 'RpAmt', title: '���۽��', width: '10%', align: 'right', format: '#,##0.00', sum: 'Y' },
		{ field: 'SpecDesc', title: '������', width: '10%', align: 'left' },
		{ field: 'ManfDesc', title: '��������', width: '10%', align: 'left' }
	//	{field:"Sp",title:"�ۼ�",width:"100px",align:"right",format:"#,##0.00"},
	//	{field:"SpAmt",title:"�ۼ۽��",width:"100px",align:"right",format:"#,##0.00",sum:"Y"}
	];
	PrintDocument(PrintNum, IndirPrint, TaskName, Title, Head, Foot, Cols, DetailData);
}

function GetDetailDataInIs(Init, InitType) {
	if (isEmpty(Init)) {
		return;
	}
	var Params = JSON.stringify({ Init: Init, InitType: InitType });
	var jsonData = $.cm({
		ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
		QueryName: 'DHCINIsTrfD',
		query2JsonStrict: 1,
		Params: Params,
		rows: 99999
	}, false);
	var DetailData = jsonData.rows;
	return DetailData;
}

function GetHVColDetailData(Init, InitType) {
	if (isEmpty(Init)) {
		return;
	}
	var Params = JSON.stringify({ Init: Init, InitType: InitType });
	var jsonData = $.cm({
		ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
		QueryName: 'QueryHVColDetail',
		query2JsonStrict: 1,
		Params: Params,
		rows: 99999
	}, false);
	var DetailData = jsonData.rows;
	return DetailData;
}
function RQPrintInIsTrf(InitStr, AutoFlag) {
	InitStr = InitStr.toString();
	var InitArr = InitStr.split('^');
	var ArrCount = InitArr.length;
	if (ArrCount <= 0) {
		return;
	}
	AutoFlag = typeof (AutoFlag) === 'undefined' ? 'N' : AutoFlag;
	var PrintNum = parseInt(InitParamObj.PrintNum);
	if (!isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	var DictPrintStr = '';
	var DictPrintStrLen = '';
	for (var i = 0; i < ArrCount; i++) {
		var Init = InitArr[i];
		var InitObj = $.cm({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			MethodName: 'Select',
			Init: Init
		}, false);
		var FrLocId = InitObj['InitFrLoc']['RowId'];
		var ScgId = InitObj['ScgId'];
		if (isEmpty(FrLocId)) {
			return;
		}
		var PrintMode = GetPrintMode(FrLocId, ScgId);
		var HVFlag = GetCertDocHVFlag(Init, 'T');	// ���ⵥ��ѯ��ѡ��ӡ���ָߵ�ֵ����
		var RaqName = 'DHCSTM_HUI_InIsTrf_Common' + RQSuffix;
		if (HVFlag == 'Y') {
			if (PrintMode != '') {
				RaqName = 'DHCSTM_HUI_InIsTrfHVCol_Common_' + PrintMode + RQSuffix;
			} else {
				RaqName = 'DHCSTM_HUI_InIsTrfHVCol_Common' + RQSuffix;
			}
		} else {
			if (PrintMode != '') {
				RaqName = 'DHCSTM_HUI_InIsTrf_Common_' + PrintMode + RQSuffix;
			} else {
				RaqName = 'DHCSTM_HUI_InIsTrf_Common' + RQSuffix;
			}
		}
		var Params = '';
		var RQInitStr = Init;
		var PrintStr = '{' + RaqName + '(Params=' + Params + ';Init=' + Init + ';RQInitStr=' + RQInitStr + ')}';
		var RQPrintStr = TranslateRQStr(PrintStr);
		for (var j = 1; j <= PrintNum; j++) {
			if (InitParamObj.IndirPrint != 'N') {
				DHCSTM_DHCCPM_RQPrint(RQPrintStr);
				Common_PrintLog('T', Init, AutoFlag);
			} else {
				if (HISVersion < 8.5) {
					DHCCPM_RQDirectPrint(PrintStr);
					Common_PrintLog('T', Init, AutoFlag);
				} else {
					if (DictPrintStr == '') {
						DictPrintStr = PrintStr;
					} else {
						DictPrintStr = DictPrintStr + PrintStr;
					}
					DictPrintStrLen = DictPrintStr.length;
					if (DictPrintStrLen > 512) {
						$UI.msg('alert', '��ӡ��������,����ֻ�ܴ�ӡ' + i + '�ݵ���,������ѡ�񵥾�!');
						return;
					}
				}
			}
		}
	}
	if ((HISVersion >= 8.5) && (InitParamObj.IndirPrint == 'N')) {
		DHCCPM_RQDirectPrint(DictPrintStr);
		Common_PrintLog('T', InitStr, AutoFlag, '', PrintNum);
	}
}
/*
 * ��ӡ��ֵ����
 */
function RQPrintInIsTrfHVCol(InitStr, AutoFlag) {
	InitStr = InitStr.toString();
	var InitArr = InitStr.split('^');
	var ArrCount = InitArr.length;
	if (ArrCount <= 0) {
		return;
	}
	AutoFlag = typeof (AutoFlag) === 'undefined' ? 'N' : AutoFlag;
	var PrintNum = parseInt(InitParamObj.PrintNum);
	if (!isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	var DictPrintStr = '';
	var DictPrintStrLen = '';
	for (var i = 0; i < ArrCount; i++) {
		var Init = InitArr[i];
		var InitObj = $.cm({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			MethodName: 'Select',
			Init: Init
		}, false);
		var FrLocId = InitObj['InitFrLoc']['RowId'];
		var ScgId = InitObj['ScgId'];
		if (isEmpty(FrLocId)) {
			return;
		}
		var PrintMode = GetPrintMode(FrLocId, ScgId);
		var RaqName = 'DHCSTM_HUI_InIsTrfHVCol_Common' + RQSuffix;
		if (PrintMode != '') {
			RaqName = 'DHCSTM_HUI_InIsTrfHVCol_Common_' + PrintMode + RQSuffix;
		}
		var Params = '';
		var RQInitStr = Init;
		var PrintStr = '{' + RaqName + '(Params=' + Params + ';Init=' + Init + ';RQInitStr=' + RQInitStr + ')}';
		var RQPrintStr = TranslateRQStr(PrintStr);
		for (var j = 1; j <= PrintNum; j++) {
			if (InitParamObj.IndirPrint != 'N') {
				DHCSTM_DHCCPM_RQPrint(RQPrintStr);
				Common_PrintLog('T', Init, AutoFlag);
			} else {
				if (HISVersion < 8.5) {
					DHCCPM_RQDirectPrint(PrintStr);
					Common_PrintLog('T', Init, AutoFlag);
				} else {
					if (DictPrintStr == '') {
						DictPrintStr = PrintStr;
					} else {
						DictPrintStr = DictPrintStr + PrintStr;
					}
					DictPrintStrLen = DictPrintStr.length;
					if (DictPrintStrLen > 512) {
						$UI.msg('alert', '��ӡ��������,����ֻ�ܴ�ӡ' + i + '�ݵ���,������ѡ�񵥾�!');
						return;
					}
				}
			}
		}
	}
	if ((HISVersion >= 8.5) && (InitParamObj.IndirPrint == 'N')) {
		DHCCPM_RQDirectPrint(DictPrintStr);
		Common_PrintLog('T', InitStr, AutoFlag, '', PrintNum);
	}
}

/*
 * ��ӡ�˿ⵥ
 */
function RQPrintInIsTrfReturn(InitStr, AutoFlag) {
	InitStr = InitStr.toString();
	var InitArr = InitStr.split('^');
	var ArrCount = InitArr.length;
	if (ArrCount <= 0) {
		return;
	}
	AutoFlag = typeof (AutoFlag) === 'undefined' ? 'N' : AutoFlag;
	var PrintNum = parseInt(InitParamObj.PrintNum);
	if (!isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	var DictPrintStr = '';
	var DictPrintStrLen = '';
	for (var i = 0; i < ArrCount; i++) {
		var Init = InitArr[i];
		var InitObj = $.cm({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			MethodName: 'Select',
			Init: Init
		}, false);
		var ToLocId = InitObj['InitToLoc']['RowId'];
		var ScgId = InitObj['ScgId'];
		if (isEmpty(ToLocId)) {
			return;
		}
		var PrintMode = GetPrintMode(ToLocId, ScgId);
		var HVFlag = GetCertDocHVFlag(Init, 'T');
		var RaqName = 'DHCSTM_HUI_InIsTrfRet_Common.raq';
		if (HVFlag == 'Y') {
			if (PrintMode != '') {
				RaqName = 'DHCSTM_HUI_InIsTrfRetHVCol_Common_' + PrintMode + RQSuffix;
			} else {
				RaqName = 'DHCSTM_HUI_InIsTrfRetHVCol_Common' + RQSuffix;
			}
		} else {
			if (PrintMode != '') {
				RaqName = 'DHCSTM_HUI_InIsTrfRet_Common_' + PrintMode + RQSuffix;
			} else {
				RaqName = 'DHCSTM_HUI_InIsTrfRet_Common' + RQSuffix;
			}
		}
		var Params = '';
		var RQInitStr = Init + ',K';
		var PrintStr = '{' + RaqName + '(Params=' + Params + ';Init=' + Init + ';RQInitStr=' + RQInitStr + ')}';
		var RQPrintStr = TranslateRQStr(PrintStr);
		for (var j = 1; j <= PrintNum; j++) {
			if (InitParamObj.IndirPrint != 'N') {
				DHCSTM_DHCCPM_RQPrint(RQPrintStr);
				Common_PrintLog('T', Init, AutoFlag);
			} else {
				if (HISVersion < 8.5) {
					DHCCPM_RQDirectPrint(PrintStr);
					Common_PrintLog('T', Init, AutoFlag);
				} else {
					if (DictPrintStr == '') {
						DictPrintStr = PrintStr;
					} else {
						DictPrintStr = DictPrintStr + PrintStr;
					}
					DictPrintStrLen = DictPrintStr.length;
					if (DictPrintStrLen > 512) {
						$UI.msg('alert', '��ӡ��������,����ֻ�ܴ�ӡ' + i + '�ݵ���,������ѡ�񵥾�!');
						return;
					}
				}
			}
		}
	}
	if ((HISVersion >= 8.5) && (InitParamObj.IndirPrint == 'N')) {
		DHCCPM_RQDirectPrint(DictPrintStr);
		Common_PrintLog('T', InitStr, AutoFlag, '', PrintNum);
	}
}

/*
 * ��ӡ�˿ⵥ(��ֵ����)
 */
function RQPrintInIsTrfReturnHVCol(InitStr, AutoFlag) {
	InitStr = InitStr.toString();
	var InitArr = InitStr.split('^');
	var ArrCount = InitArr.length;
	if (ArrCount <= 0) {
		return;
	}
	AutoFlag = typeof (AutoFlag) === 'undefined' ? 'N' : AutoFlag;
	var PrintNum = parseInt(InitParamObj.PrintNum);
	if (!isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	var DictPrintStr = '';
	var DictPrintStrLen = '';
	for (var i = 0; i < ArrCount; i++) {
		var Init = InitArr[i];
		var InitObj = $.cm({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			MethodName: 'Select',
			Init: Init
		}, false);
		var ToLocId = InitObj['InitToLoc']['RowId'];
		var ScgId = InitObj['ScgId'];
		if (isEmpty(ToLocId)) {
			return;
		}
		var PrintMode = GetPrintMode(ToLocId, ScgId);
		var RaqName = 'DHCSTM_HUI_InIsTrfRetHVCol_Common' + RQSuffix;
		if (PrintMode != '') {
			RaqName = 'DHCSTM_HUI_InIsTrfRetHVCol_Common_' + PrintMode + RQSuffix;
		}
		var Params = '';
		var RQInitStr = Init + ',K';
		var PrintStr = '{' + RaqName + '(Params=' + Params + ';Init=' + Init + ';RQInitStr=' + RQInitStr + ')}';
		var RQPrintStr = TranslateRQStr(PrintStr);
		for (var j = 1; j <= PrintNum; j++) {
			if (InitParamObj.IndirPrint != 'N') {
				DHCSTM_DHCCPM_RQPrint(RQPrintStr);
				Common_PrintLog('T', Init, AutoFlag);
			} else {
				if (HISVersion < 8.5) {
					DHCCPM_RQDirectPrint(PrintStr);
					Common_PrintLog('T', Init, AutoFlag);
				} else {
					if (DictPrintStr == '') {
						DictPrintStr = PrintStr;
					} else {
						DictPrintStr = DictPrintStr + PrintStr;
					}
					DictPrintStrLen = DictPrintStr.length;
					if (DictPrintStrLen > 512) {
						$UI.msg('alert', '��ӡ��������,����ֻ�ܴ�ӡ' + i + '�ݵ���,������ѡ�񵥾�!');
						return;
					}
				}
			}
		}
	}
	if ((HISVersion >= 8.5) && (InitParamObj.IndirPrint == 'N')) {
		DHCCPM_RQDirectPrint(DictPrintStr);
		Common_PrintLog('T', InitStr, AutoFlag, '', PrintNum);
	}
}