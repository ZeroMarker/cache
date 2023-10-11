/**
ģ��:		��ҩ������
��ģ��:		��ҩ������-������ӡ
Creator:	MaYuqiang
CreateDate:	2021-01-17
printcom.js
*/
var HERB_PRINTCOM = {
	// ��ҩ��
	PYD: function (phbdId, rePrt) {
		rePrt = rePrt || "";
		var prtData = tkMakeServerCall("PHA.HERB.Com.Print", "HerbPrintData", phbdId, rePrt);
		if (prtData == "{}") {
			$.messager.alert('��ʾ',"�ô���δִ����ҩ���̣����ܴ�ӡ��ҩ��!","info");
			return;
		}
		var prtJson = JSON.parse(prtData);
		var prescNo=prtJson.Para.PrescNo;
		var xmlTrmplate = tkMakeServerCall("PHA.HERB.Com.Print", "GetPrintTemplate", prescNo, 1);
		if (xmlTrmplate == "") {
			$.messager.alert('��ʾ',"δ��ȡ����ҩ����ӡģ�壬���ܴ�ӡ��ҩ��!","info");
			return;
		}
		PRINTCOM.XML({
			printBy: 'lodop',
			XMLTemplate: xmlTrmplate,
			data: prtJson
		});

		/* ��ӡ��־ */
		var defPrintorFlag = "N"	// Ĭ�ϴ�ӡ��
		this.PrintLog(
			"HERBPYD",
			{
				phbdId: phbdId,
				printFlag: rePrt,
				defPrintorFlag: defPrintorFlag
			},
			prtJson,
			{
				remarks: "��ӡ��ҩ��",
				pointer: phbdId
			}
		)
		
	},
	// ����
	Presc: function (prescNo, zfFlag, prtType) {
		if ((zfFlag == "") || (zfFlag == null)) {
			zfFlag = "����";
		}
		if (prescNo.indexOf("I") > -1){
			var prtData = tkMakeServerCall("web.DHCINPHA.Common.Print","PrescPrintData",prescNo, zfFlag, prtType, 5);
		}
		else {
			var prtData = tkMakeServerCall("PHA.OP.COM.Print", "PrescPrintData", prescNo, zfFlag, prtType,"5");
		}
		
		if (prtData == "{}") {
			return;
		} else if (prtData == "-1") {
			$.messager.alert('��ʾ',prescNo + "Ϊȫ�˴����������ӡ!","info");
		} else {
			var xmlTrmplate=tkMakeServerCall("PHA.OP.COM.Print", "GetPrintTemplate", prescNo, 2);
			if (xmlTrmplate == "") {
				return;
			}
			var prtJson = JSON.parse(prtData);
			//DHCPHACOMXMLPrint_JsonToXml(prtJson);
			
			PRINTCOM.XML({
				printBy: 'lodop',
				XMLTemplate: xmlTrmplate,
				data: prtJson
			});

		}

		/* ��ӡ��־ */
		var defPrintorFlag = "N"	// Ĭ�ϴ�ӡ��
		this.PrintLog(
			"PrescPrint",
			{
				prescNo: prescNo,
				printFlag: prtType,
				defPrintorFlag: defPrintorFlag
			},
			prtJson,
			{
				remarks: "������ӡ",
				pointer: prescNo
			}
		)

	},
	// ��ҩ��ǩ,��Ҫ�����÷�����
	Label: function (prescNo,printFlag) {
		if(printFlag==undefined){printFlag="";}
		var prtData = tkMakeServerCall("PHA.OP.COM.Print", "LabelPrintData", prescNo);
		if (prtData == "[]") {
			if(printFlag==""){
				$.messager.alert('��ʾ', prescNo + "û����Ҫ��ӡ�ı�ǩ!", "info");
			}
			return;
		}
		var prtJson = JSON.parse(prtData);
		var prtLen = prtJson.length;
		if (prtLen == 0) {
			return;
		}
		var xmlTrmplate=tkMakeServerCall("PHA.OP.COM.Print", "GetPrintTemplate", prescNo, 3);
		if (xmlTrmplate == "") {
			return;
		}
		for (var prtI = 0; prtI < prtLen; prtI++) {
			var prtIJson = prtJson[prtI];
			PRINTCOM.XML({
				printBy: 'lodop',
				XMLTemplate: xmlTrmplate,
				data: prtIJson
			});
		}

		/* ��ӡ��־ */
		var defPrintorFlag = "N"	// Ĭ�ϴ�ӡ��
		this.PrintLog(
			"InstrucLabel",
			{
				prescNo: prescNo,
				printFlag: "",
				defPrintorFlag: defPrintorFlag
			},
			prtJson,
			{
				remarks: "��ҩ��ǩ",
				pointer: prescNo
			}
		)
	},
	// ��ҩ��ǩ
	DECLabel: function (prescNo) {
		var prtData = tkMakeServerCall("PHA.HERB.Com.Print", "DECLabelData", prescNo);
		if (prtData == "[]") {	
			$.messager.alert('��ʾ', prescNo + "û����Ҫ��ӡ�ı�ǩ!", "info");					
			return;
		}
		var prtJson = JSON.parse(prtData);
		var xmlTrmplate = prtJson.Templet;
		if (xmlTrmplate == "") {
			return;
		}
		
		PRINTCOM.XML({
			printBy: 'lodop',
			XMLTemplate: xmlTrmplate,
			data: prtJson
		});

		/* ��ӡ��־ */
		var defPrintorFlag = "N"	// Ĭ�ϴ�ӡ��
		this.PrintLog(
			"DECLabel",
			{
				prescNo: prescNo,
				printFlag: "",
				defPrintorFlag: defPrintorFlag
			},
			prtJson,
			{
				remarks: "��ҩ��ǩ",
				pointer: prescNo
			}
		)
		
	},
	// ��ҩ��
	ReturnDoc: function (phbrId, printFlag) {
		var template = "PHAHERBReturn"
		var prtDataStr = tkMakeServerCall('PHA.HERB.Com.Print', 'GetReturnData', phbrId, template);
		var prtData = JSON.parse(prtDataStr);

		if (prtData.template === '') {
			//alert('�����ڡ��������á�->��סԺҩ����->��סԺ��ҩ����ά����ӡģ������ ');
			alert("���ȶ�����ҩ��ģ��")
			return;
		}

		PRINTCOM.XML({
			printBy: 'lodop',
			XMLTemplate: prtData.template,
			data: {
				Para: prtData.para,
				List: prtData.list
			},
			listColAlign: { retQty: 'right', sp: 'right', spAmt: 'right' },
			preview: false,
			aptListFields: ['label17', 'userName', 'label19', 'label21', 'spAmtSum', 'label23', 'sysDT'],
			listBorder: {headBorder: true, style: 4, startX: 1, endX: 190 },
			page: { rows: 25, x: 80, y: 260, fontname: '����', fontbold: 'false', fontsize: '14', format: '��{1}ҳ/��{2}ҳ' }
		});

		/* ��ӡ��־ */
		var defPrintorFlag = "N"	// Ĭ�ϴ�ӡ��
		this.PrintLog(
			"BS.PHA.HERB.RETURN",
			{
				phbrId: phbrId,
				printFlag: printFlag,
				defPrintorFlag: defPrintorFlag
			},
			prtData,
			{
				remarks: "��ҩ��ҩ��",
				pointer: phbrId
			}
		)
		
	},
	// ��ҩ���뵥
	RequestDoc: function (phbrrId, printFlag) {
		var template = "PHAHERBRequest"
		var prtDataStr = tkMakeServerCall('PHA.HERB.Com.Print', 'GetRequestData', phbrrId, template);
		var prtData = JSON.parse(prtDataStr);

		if (prtData.template === '') {
			//alert('�����ڡ��������á�->��סԺҩ����->��סԺ��ҩ����ά����ӡģ������ ');
			alert("���ȶ�����ҩ��ģ��")
			return;
		}

		if (prtData.errMsg != '') {
			var errMsg = prtData.errMsg
			alert(errMsg)
			return;
		}

		PRINTCOM.XML({
			printBy: 'lodop',
			XMLTemplate: prtData.template,
			data: {
				Para: prtData.para,
				List: prtData.list
			},
			listColAlign: { retQty: 'right', sp: 'right', spAmt: 'right' },
			preview: false,
			aptListFields: ['label17', 'userName', 'label19', 'label21', 'spAmtSum', 'label23', 'sysDT'],
			listBorder: {headBorder: true, style: 4, startX: 1, endX: 190 },
			page: { rows: 25, x: 80, y: 260, fontname: '����', fontbold: 'false', fontsize: '14', format: '��{1}ҳ/��{2}ҳ' }
		});

		/* ��ӡ��־ */
		var defPrintorFlag = "N"	// Ĭ�ϴ�ӡ��
		this.PrintLog(
			"BS.PHA.HERB.RETREQUEST",
			{
				phbrrId: phbrrId,
				printFlag: printFlag,
				defPrintorFlag: defPrintorFlag
			},
			prtData,
			{
				remarks: "��ҩ��ҩ���뵥",
				pointer: phbrrId
			}
		)
		
	},
	// ��¼��ӡ��־
	PrintLog: function (type, queryOpt, prtOpt, othOpt){
		PHA_LOG.Operate({
			operate: 'P',
			logInput: JSON.stringify(queryOpt),
			type: type,
			pointer: othOpt.pointer,
			origData: JSON.stringify(prtOpt),
			remarks: (App_MenuName || "") + ' - ' + othOpt.remarks
		});
	}
}
