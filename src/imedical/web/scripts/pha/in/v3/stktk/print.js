/*
 * Creatror	zhaozhdiuan
 * Description	盘点相关打印
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
/// 打印批次
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
			fontname: '宋体',
			fontbold: 'false',
			fontsize: '12',
			format: '第{1}页/共{2}页'
		},
		listColAlign: {},
		aptListFields: ['lab_printDT', 'printDT', 'lab_manger', 'lab_chkUser', 'chkUserName', 'lab_adjUser', 'printUserName']
	});
}

function PrintInclbData_ByHtml(stktkId, othJson) {
	// 获取打印参数
	var retJson = $.cm({
		ClassName: 'PHA.IN.STKTK.Print',
		MethodName: 'GetPrintInclbData',
		stktkId: stktkId,
		userId: session['LOGON.USERID'],
		othJson: JSON.stringify(othJson)
	}, false);
	
	// 调用打印公共方法
	new PHA_LODOP.Init('盘点单_按批次')
	.Printer('')
	.Page('Orient:1; Width:0; Height:0; PageName:A4')
	.PageNo('Top:270mm; Left:90mm; Format:0')
	.Text(retJson.Para.title, 'Top:5mm; Left:5mm; Width:180mm; Height:20mm; FontName:宋体; FontSize:16; Alignment:2; Bold:1; ItemType:1')
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
				name: '序号',
				index: 'num',
				width: '5',
				maxTextLen: 20
			}, {
				name: '货位',
				index: 'stkbinDesc',
				width: '12',
				maxTextLen: 100
			}, {
				name: '药品名称',
				index: 'inciDesc',
				width: '32'
			}, {
				name: '规格',
				index: 'spec',
				width: '12'
			}, {
				name: '批号',
				index: 'batNo',
				width: '11'
			}, {
				name: '效期',
				index: 'expDate',
				width: '14'
			}, {
				name: '账盘数量',
				index: 'freQtyUom',
				width: '12'
			}, {
				name: '实盘数量',
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
							td: '盘点科室：' + main.stktkLocDesc,
							width: 15
						}, {
							td: '盘点单号：' + main.stktkNo,
							width: 15
						}, {
							td: '盘点日期：' + main.stktkDT,
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
							td: '主管：',
							width: 15
						}, {
							td: '核对人：',
							width: 15
						}, {
							td: '制单人：' + main.printUserName,
							width: 15
						}, {
							td: '打印日期：' + main.printDT,
							width: 20
						}
					]
				]
			};
		}
	})
	.Print();
}

/// 打印品种
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
			fontname: '宋体',
			fontbold: 'false',
			fontsize: '12',
			format: '第{1}页/共{2}页'
		},
		listColAlign: {
			partPFreQty: 'right',
			partBFreQty: 'right'
		},
		aptListFields: ['lab_printDT', 'printDT', 'lab_manger', 'lab_chkUser', 'chkUserName', 'lab_adjUser', 'printUserName']
	});
}

function PrintInciData_ByHtml(stktkId, othJson) {
	// 获取打印参数
	var retJson = $.cm({
		ClassName: 'PHA.IN.STKTK.Print',
		MethodName: 'GetPrintInciData',
		stktkId: stktkId,
		userId: session['LOGON.USERID'],
		othJson: JSON.stringify(othJson)
	}, false);
	
	// 调用打印公共方法
	new PHA_LODOP.Init('盘点单_按品种')
	.Printer('')
	.Page('Orient:1; Width:0; Height:0; PageName:A4')
	.PageNo('Top:270mm; Left:90mm; Format:0')
	.Text(retJson.Para.title, 'Top:5mm; Left:5mm; Width:180mm; Height:20mm; FontName:宋体; FontSize:16; Alignment:2; Bold:1; ItemType:1')
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
				name: '序号',
				index: 'num',
				width: '5',
				maxTextLen: 20
			}, {
				name: '货位',
				index: 'stkbinDesc',
				width: '12',
				maxTextLen: 100
			}, {
				name: '药品名称',
				index: 'inciDesc',
				width: '32'
			}, {
				name: '规格',
				index: 'spec',
				width: '12'
			}, {
				name: '数量(入库)',
				index: 'partPFreQty',
				width: '12',
				align: 'right'
			}, {
				name: '入库单位',
				index: 'pUomDesc',
				width: '12'
			}, {
				name: '数量(基本)',
				index: 'partBFreQty',
				width: '12',
				align: 'right'
			}, {
				name: '基本单位',
				index: 'bUomDesc',
				width: '12'
			}, {
				name: '实盘数量',
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
							td: '盘点科室：' + main.stktkLocDesc,
							width: 15
						}, {
							td: '盘点单号：' + main.stktkNo,
							width: 15
						}, {
							td: '盘点日期：' + main.stktkDT,
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
							td: '主管：',
							width: 15
						}, {
							td: '核对人：',
							width: 15
						}, {
							td: '制单人：' + main.printUserName,
							width: 15
						}, {
							td: '打印日期：' + main.printDT,
							width: 20
						}
					]
				]
			};
		}
	})
	.Print();
}
