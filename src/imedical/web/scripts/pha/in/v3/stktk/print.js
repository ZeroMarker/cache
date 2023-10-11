/*
 * Creatror	zhaozhdiuan
 * Description	�̵���ش�ӡ
 * Date		2022-04-20
 */

function PrintStktk(stktkId, printFlag, othJson) {
	if (printFlag == undefined) {
		printFlag = "1"
	}
	switch (printFlag) {
	case "1":
		// PrintInclbData(stktkId, othJson);
		PrintInclbData_ByHtml(stktkId, othJson);
		break;
	case "2":
		// PrintInciData(stktkId, othJson);
		PrintInciData_ByHtml(stktkId, othJson);
		break;
	default:
		break;
	}
}
/// ��ӡ����
function PrintInclbData(stktkId, othJson) {
	PRINTCOM.XML({
		printBy: 'lodop',
		XMLTemplate: "PHAINSTKTKINCLB",
		dataOptions: {
			ClassName: 'PHA.IN.STKTK.Print',
			MethodName: 'GetPrintInclbData',
			stktkId: stktkId,
			userId: session['LOGON.USERID'],
			othJson: JSON.stringify(othJson)
		},
		listBorder: {
			style: 4,
			startX: 2,
			endX: 214
		},
		page: {
			rows: 30,
			x: 4,
			y: 2,
			fontname: '����',
			fontbold: 'false',
			fontsize: '12',
			format: '��{1}ҳ/��{2}ҳ'
		},
		listColAlign: {},
		aptListFields: ['lab_printDT', 'printDT', 'lab_manger', 'lab_chkUser', 'chkUserName', 'lab_adjUser', 'printUserName']
	});
}

function PrintInclbData_ByHtml(stktkId, othJson) {
	// ��ȡ��ӡ����
	var retJson = $.cm({
		ClassName: 'PHA.IN.STKTK.Print',
		MethodName: 'GetPrintInclbData',
		stktkId: stktkId,
		userId: session['LOGON.USERID'],
		othJson: JSON.stringify(othJson)
	}, false);
	
	// ���ô�ӡ��������
	new PHA_LODOP.Init('�̵㵥_������')
	.Printer('')
	.Page('Orient:1; Width:0; Height:0; PageName:A4')
	.PageNo('Top:270mm; Left:90mm; Format:0')
	.Text(retJson.Para.title, 'Top:5mm; Left:5mm; Width:180mm; Height:20mm; FontName:����; FontSize:16; Alignment:2; Bold:1; ItemType:1')
	.Html({
		type: 'html',
		FromTop: 50,
		FromLeft: 5,
		DivWidth: '98%',
		DivHeight: '88%',
		data: [{
			main: retJson.Para,
			detail: retJson.List
		}],
		width: 195,
		borderStyle: 4,
		padding: 2,
		fontSize: 11,
		rowHeight: 10,
		columns: [{
				name: '���',
				index: 'num',
				width: '5',
				maxTextLen: 20
			}, {
				name: '��λ',
				index: 'stkbinDesc',
				width: '12',
				maxTextLen: 100
			}, {
				name: 'ҩƷ����',
				index: 'inciDesc',
				width: '32'
			}, {
				name: '���',
				index: 'spec',
				width: '12'
			}, {
				name: '����',
				index: 'batNo',
				width: '11'
			}, {
				name: 'Ч��',
				index: 'expDate',
				width: '14'
			}, {
				name: '��������',
				index: 'freQtyUom',
				width: '12'
			}, {
				name: 'ʵ������',
				index: '_actualQtyUom',
				width: '15'
			}
		],
		formatHeader: function (main) {
			return {
				marginTop: 20,
				fontSize: 12,
				data: [
					[{
							td: '�̵���ң�' + main.stktkLocDesc,
							width: 15
						}, {
							td: '�̵㵥�ţ�' + main.stktkNo,
							width: 15
						}, {
							td: '�̵����ڣ�' + main.stktkDT,
							width: 15
						}
					]
				]
			};
		},
		formatFooter: function (main) {
			return {
				fontSize: 12,
				data: [
					[{
							td: '���ܣ�',
							width: 15
						}, {
							td: '�˶��ˣ�',
							width: 15
						}, {
							td: '�Ƶ��ˣ�' + main.printUserName,
							width: 15
						}, {
							td: '��ӡ���ڣ�' + main.printDT,
							width: 20
						}
					]
				]
			};
		}
	})
	.Print();
}

/// ��ӡƷ��
function PrintInciData(stktkId, othJson) {
	PRINTCOM.XML({
		printBy: 'lodop',
		XMLTemplate: "PHAINSTKTKINCI",
		dataOptions: {
			ClassName: 'PHA.IN.STKTK.Print',
			MethodName: 'GetPrintInciData',
			stktkId: stktkId,
			userId: session['LOGON.USERID'],
			othJson: JSON.stringify(othJson)
		},
		listBorder: {
			style: 4,
			startX: 2,
			endX: 214
		},
		page: {
			rows: 30,
			x: 4,
			y: 2,
			fontname: '����',
			fontbold: 'false',
			fontsize: '12',
			format: '��{1}ҳ/��{2}ҳ'
		},
		listColAlign: {
			partPFreQty: 'right',
			partBFreQty: 'right'
		},
		aptListFields: ['lab_printDT', 'printDT', 'lab_manger', 'lab_chkUser', 'chkUserName', 'lab_adjUser', 'printUserName']
	});
}

function PrintInciData_ByHtml(stktkId, othJson) {
	// ��ȡ��ӡ����
	var retJson = $.cm({
		ClassName: 'PHA.IN.STKTK.Print',
		MethodName: 'GetPrintInciData',
		stktkId: stktkId,
		userId: session['LOGON.USERID'],
		othJson: JSON.stringify(othJson)
	}, false);
	
	// ���ô�ӡ��������
	new PHA_LODOP.Init('�̵㵥_��Ʒ��')
	.Printer('')
	.Page('Orient:1; Width:0; Height:0; PageName:A4')
	.PageNo('Top:270mm; Left:90mm; Format:0')
	.Text(retJson.Para.title, 'Top:5mm; Left:5mm; Width:180mm; Height:20mm; FontName:����; FontSize:16; Alignment:2; Bold:1; ItemType:1')
	.Html({
		type: 'html',
		FromTop: 50,
		FromLeft: 5,
		DivWidth: '98%',
		DivHeight: '88%',
		data: [{
			main: retJson.Para,
			detail: retJson.List
		}],
		width: 195,
		borderStyle: 4,
		padding: 2,
		fontSize: 11,
		rowHeight: 10,
		columns: [{
				name: '���',
				index: 'num',
				width: '5',
				maxTextLen: 20
			}, {
				name: '��λ',
				index: 'stkbinDesc',
				width: '12',
				maxTextLen: 100
			}, {
				name: 'ҩƷ����',
				index: 'inciDesc',
				width: '32'
			}, {
				name: '���',
				index: 'spec',
				width: '12'
			}, {
				name: '����(���)',
				index: 'partPFreQty',
				width: '12',
				align: 'right'
			}, {
				name: '��ⵥλ',
				index: 'pUomDesc',
				width: '12'
			}, {
				name: '����(����)',
				index: 'partBFreQty',
				width: '12',
				align: 'right'
			}, {
				name: '������λ',
				index: 'bUomDesc',
				width: '12'
			}, {
				name: 'ʵ������',
				index: '_actualQtyUom',
				width: '15'
			}
		],
		formatHeader: function (main) {
			return {
				marginTop: 20,
				fontSize: 12,
				data: [
					[{
							td: '�̵���ң�' + main.stktkLocDesc,
							width: 15
						}, {
							td: '�̵㵥�ţ�' + main.stktkNo,
							width: 15
						}, {
							td: '�̵����ڣ�' + main.stktkDT,
							width: 15
						}
					]
				]
			};
		},
		formatFooter: function (main) {
			return {
				fontSize: 12,
				data: [
					[{
							td: '���ܣ�',
							width: 15
						}, {
							td: '�˶��ˣ�',
							width: 15
						}, {
							td: '�Ƶ��ˣ�' + main.printUserName,
							width: 15
						}, {
							td: '��ӡ���ڣ�' + main.printDT,
							width: 20
						}
					]
				]
			};
		}
	})
	.Print();
}
