
// �������ֵ��object
var BCInitParamObj = GetAppPropValue('DHCSTBCM');

function PrintInIsTrfBC(Init, AutoFlag) {
	if (PrintMethod == 0) {
		LodopPrintInIsTrfBC(Init, AutoFlag); // Lodop��ӡ
	} else {
		RQPrintInIsTrfBC(Init, AutoFlag); // ��Ǭ��ӡ
	}
}
function LodopPrintInIsTrfBC(Init, AutoFlag) {
	if (Init == null || Init == '') {
		return;
	}
	AutoFlag = typeof (AutoFlag) === 'undefined' ? 'N' : AutoFlag;
	// ��ȡ��ӡ�������Ƿ�Ԥ����ӡ�������ӡ��־�ʹ���
	var PrintNum = parseInt(BCInitParamObj.PrintNum);
	var IndirPrint = BCInitParamObj.IndirPrint;
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
	var DetailData = GetDetailDataBCInIs(Init, 'T'); // ��ϸ��Ϣ
	var FrLocDesc = MainObj.InitFrLoc.Description;
	var ToLocDesc = MainObj.InitToLoc.Description;
	var InitNo = MainObj.InitNo;
	var InitReqUser = MainObj.InitReqUser.Description;
	var InitDate = MainObj.InitDate;
	var InitUser = MainObj.InitUser.Description;
	var PrintDate = DateFormatter(new Date());
	// ������Ϣչʾ
	var TaskName = '����ת�Ƶ���ӡ'; // ��ӡ��������
	// ������Ϣ
	var Title = FrLocDesc + 'ת�Ƶ�';
	// ҳü��Ϣ
	var Head = '���տ���:' + ToLocDesc + '      '
			+ 'ת�Ƶ���:' + InitNo + '      '
			+ '������:' + InitReqUser + '      '
			+ '�Ƶ�����:' + PrintDate;
	// ҳβ��Ϣ
	var Foot = '��ӡ����:' + PrintDate + '          '
			+ '����:' + '' + '          '
			+ '�˶�:' + '' + '          '
			+ '�Ƶ���:' + InitUser;
	// ��ϸ��Ϣչʾ
	var Cols = [
		{ field: 'Num', title: '���', width: '25px', align: 'center' },
		{ field: 'InciCode', title: '���ʴ���', width: '100px', align: 'left' },
		{ field: 'InciDesc', title: '��������', width: '100px', align: 'left' },
		{ field: 'Spec', title: '���', width: '100px', align: 'left' },
		{ field: 'SpecDesc', title: '������', width: '100px', align: 'left' },
		{ field: 'UomDesc', title: '��λ', width: '100px', align: 'left' },
		{ field: 'Qty', title: '����', width: '100px', align: 'right', format: '#,##0.00' },
		{ field: 'BatExp', title: '����~Ч��', width: '100px', align: 'left' },
		{ field: 'Rp', title: '����', width: '100px', align: 'right', format: '#,##0.00' },
		{ field: 'Sp', title: '�ۼ�', width: '100px', align: 'right', format: '#,##0.00' },
		{ field: 'RpAmt', title: '���۽��', width: '100px', align: 'right', format: '#,##0.00', sum: 'Y' },
		{ field: 'SpAmt', title: '�ۼ۽��', width: '100px', align: 'right', format: '#,##0.00', sum: 'Y' }
	];
	PrintDocument(PrintNum, IndirPrint, TaskName, Title, Head, Foot, Cols, DetailData);
}

function RQPrintInIsTrfBC(Init, AutoFlag) {
	if (Init == null || Init == '') {
		return;
	}
	AutoFlag = typeof (AutoFlag) === 'undefined' ? 'N' : AutoFlag;
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
	var RaqName = 'DHCSTM_HUI_InIsTrf_Common.raq';
	if (PrintMode == 'MO') {
		RaqName = 'DHCSTM_HUI_InIsTrf_MO_Common.raq';
	}
	var Params = JSON.stringify({ Init: Init });
	var DirectPrintStr = '{' + RaqName + '(Params=' + Params + ';Init=' + Init + ')}';
	var PrintNum = parseInt(BCInitParamObj.PrintNum);
	if (!isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	var RQPrintStr = TranslateRQStr(DirectPrintStr);
	for (var i = 1; i <= PrintNum; i++) {
		if (BCInitParamObj.IndirPrint != 'N') {
			DHCSTM_DHCCPM_RQPrint(RQPrintStr);
		} else {
			DHCCPM_RQDirectPrint(DirectPrintStr);
		}
		Common_PrintLog('T', Init, AutoFlag);
	}
}

function GetDetailDataBCInIs(Init, InitType) {
	if (isEmpty(Init)) {
		return;
	}
	var Params = JSON.stringify({ Init: Init, InitType: InitType });
	var jsonData = $.cm({
		ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
		QueryName: 'DHCINIsTrfD',
		query2JsonStrict: 1,
		Params: Params
	}, false);
	var DetailData = jsonData.rows;
	return DetailData;
}