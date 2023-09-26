/*
dhcpha.outpha.printreturn.js
模块:门诊药房
子模块:门诊药房-退药单打印
createdate:2016-05-13
creator:yunhaibao
 */
var HospitalDesc = tkMakeServerCall("web.DHCSTKUTIL", "GetHospName", session['LOGON.HOSPID']);
var path = tkMakeServerCall("web.DHCDocConfig", "GetPath");
//退药单打印统一入口
function PrintReturn(retrowid, reprint) {
	PRINTCOM.XML({
		printBy: 'lodop',
		XMLTemplate: 'DHCOutPhReturn',
		dataOptions: {
			ClassName: 'PHA.OP.COM.Print',
			MethodName: 'GetReturnPrintData',
			retRowID: retrowid,
			userID: session['LOGON.USERID'],
			rePrintFlag: reprint
		},
		aptListFields: ["label14", "totalMoney", "label16", "userName"],
		listBorder: {style:4, startX:1, endX:190},
		page: {rows:30, x:4, y:2, fontname:'黑体', fontbold:'false', fontsize:'12', format:'第{1}页/共{2}页'},
	});
}
