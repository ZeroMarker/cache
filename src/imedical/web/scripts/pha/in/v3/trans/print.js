/**
 * ģ��:     ���ת�Ƶ�-��ӡ
 * ��д����: 2022-06-02
 * ��д��:   yangsj
 */
function PrintTrans(initId) {
	PRINTCOM.XML({
		printBy: 'lodop',
		XMLTemplate: 'PHAINTRANS',
		dataOptions: {
			ClassName: 'PHA.IN.TRANS.Print',
			MethodName: 'GetPrintData',
			initId: initId,
			userId: session['LOGON.USERID']
		},
		listBorder: {
			headBorder: true,
			style: 4,
			startX: 2,
			endX: 200,
			space: 0
		},
		page: {
			//rows: 10,
			x: 180,
			y: 5,
			fontname: '����',
			fontbold: 'true',
			fontsize: '12',
			format: '��{1}ҳ/��{2}ҳ'
		},
		listColAlign: {
			num: 'center',
			qty: 'right',
			rp: 'right',
			sp: 'right',
			rpAmt: 'right',
			spAmt: 'right',
			proLocQty: 'right'
		},
		aptListFields: ['lab_manger', 'lab_chkUser', 'chkUserName', 'lab_printUser', 'printUser', 'lab_printDT', 'printDT'],
		//endPageFields: ['lab_manger', 'lab_chkUser', 'chkUserName', 'lab_printUser', 'printUser', 'lab_printDT', 'printDT']
		preview : com.ParamTrans.PrintType == '2' ? true : false
	});

}
