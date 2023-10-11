/*
/// Creator		zhaozhiduan
/// CreatDate 	2022年04月01日
/// Description	库存调整打印
 */
function PrintAdj(adjId) {
	PRINTCOM.XML({
		printBy: 'lodop',
		XMLTemplate: "PHAINADJ",
		dataOptions: {
			ClassName: 'PHA.IN.ADJ.Print',
			MethodName: 'GetPrintData',
			adjId: adjId,
			userId: session['LOGON.USERID']
		},
		listBorder: {
			headBorder: true,
			style: 4,
			startX: 2,
			endX: 215,
			space: 0
		},
		page: {
			// rows: 10,
			x: 180,
			y: 5,
			fontname: '黑体',
			fontbold: 'true',
			fontsize: '12',
			format: '第{1}页/共{2}页'
		},
		listColAlign: {
			num: 'center',
			qty: 'right',
			rp: 'right',
			sp: 'right',
			rpAmt: 'right',
			spAmt: 'right',
			difAmt: 'right'
		},
		listValign: 'center',
		aptListFields: ['lab_printDT', 'printDT', 'lab_manger', 'lab_chkUser', 'chkUserName', 'lab_adjUser', 'printUserName'],
		endPageFields: ['lab_printDT', 'printDT', 'lab_manger', 'lab_chkUser', 'chkUserName', 'lab_adjUser', 'printUserName']
	});

}
