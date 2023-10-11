
/*
/// Creator		zhaozhiduan
/// CreatDate 	2022年04月06日
/// Description	库存报损打印
*/
function PrintScrap(scrapId){
    PRINTCOM.XML({
		printBy: 'lodop',
        XMLTemplate: "PHAINSCRAP",
		dataOptions: {
			ClassName: 'PHA.IN.SCRAP.Print',
			MethodName: 'GetPrintData',
			scrapId: scrapId,
			userId: session['LOGON.USERID']
		},
		listBorder: {
			headBorder:true,
                                                style: 4,
			startX: 2,
			endX: 207

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
		listColAlign: {num:"center",qty:'right', rp:'right', sp:'right', rpAmt:'right', spAmt:'right', difAmt:'right'},
        aptListFields:['lab_printDT', 'printDT', 'lab_manger', 'lab_chkUser', 'chkUserName', 'lab_adjUser', 'printUserName']
	});
}
