/*
dhcpha.outpha.printreturn.js
ģ��:����ҩ��
��ģ��:����ҩ��-��ҩ����ӡ
createdate:2016-05-13
creator:yunhaibao
 */
var HospitalDesc = tkMakeServerCall("web.DHCSTKUTIL", "GetHospName", session['LOGON.HOSPID']);
var path = tkMakeServerCall("web.DHCDocConfig", "GetPath");
//��ҩ����ӡͳһ���
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
		page: {rows:30, x:4, y:2, fontname:'����', fontbold:'false', fontsize:'12', format:'��{1}ҳ/��{2}ҳ'},
	});
}
