
/*
/// Creator		zhaozhiduan
/// CreatDate 	2022��04��06��
/// Description	��汨���ӡ
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
			fontname: '����',
			fontbold: 'false',
			fontsize: '12',
			format: '��{1}ҳ/��{2}ҳ'
		},
		listColAlign: {num:"center",qty:'right', rp:'right', sp:'right', rpAmt:'right', spAmt:'right', difAmt:'right'},
        aptListFields:['lab_printDT', 'printDT', 'lab_manger', 'lab_chkUser', 'chkUserName', 'lab_adjUser', 'printUserName']
	});
}
