/**
 * 模块:     库存请求单-打印
 * 编写日期: 2022-06-01
 * 编写人:   yangsj
 */
function PrintReq(inrqId) {
	PRINTCOM.XML({
		printBy: 'lodop',
		XMLTemplate: 'PHAINREQ',
		dataOptions: {
			ClassName: 'PHA.IN.REQ.Print',
			MethodName: 'GetPrintData',
			inrqId: inrqId,
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
			spAmt: 'right'
		},
		aptListFields: ['lab_manger', 'lab_chkUser', 'chkUserName', 'lab_printUser', 'printUser', 'lab_printDT', 'printDT'],
		endPageFields: ['lab_manger', 'lab_chkUser', 'chkUserName', 'lab_printUser', 'printUser', 'lab_printDT', 'printDT']
	});

}
