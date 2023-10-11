/**
 * ģ��:     ����ҩ����ӡ����
 * ��д����: 2022-08-10
 * ��д��:   zhaozhiduan
 * scripts/pha/op/v4/printcom.js 
 */
 
var OP_PRINTCOM = {
	/*
	*Description:	���ݴ�ӡ����ѡ���ӡ
	*Input:			_opt:������ʽ{};
	*				_opt.prescNo -- ������, 
	*				_opt.prtType -- ��ӡ����,1-��ҩ��,2-����,3-��ǩ,
	*				_opt.defPrintorFlag -- Ĭ�ϴ�ӡ��
	*				_opt.rePrint --�����ʶ
	*				_opt.phdId -- ��ҩid(һ����ҩ����Ҫ)
	*/
	PrintPrescHandler:function(_opt) {
		var prescNo = _opt.prescNo;
		var defPrintorFlag = _opt.defPrintorFlag ||"N";
		var prtType = _opt.prtType || "";
		var phdId = _opt.phdId || "";
		var rePrint = _opt.rePrint || "";
		if (prtType != "") {
			var arr = prtType.split(",");
			for (var i = 0; i < arr.length; i++) {
				var type = arr[i];
				if ((type == "1") && (phdId != "")) {
					// ��ҩ��
					OP_PRINTCOM.PYD(phdId, rePrint,defPrintorFlag);
				}
				if (type == "2") {
					// ����
					OP_PRINTCOM.Presc(prescNo, "", "",defPrintorFlag);
				}
				if (type == "3") {
					// �÷���ǩ
					OP_PRINTCOM.Label(prescNo, rePrint);
				}
			}
		}
	},
	/*
	*Description:	��ҩ��
	*Input:			phdId -- ��ҩid, printFlag -- �����ʶ,
	*				defPrintorFlag -- Ĭ�ϴ�ӡ��
	*/
	PYD: function (phdId, printFlag,defPrintorFlag) {
		if(defPrintorFlag==undefined){defPrintorFlag="N"}
		printFlag = printFlag || "";
		var prtData = tkMakeServerCall("PHA.OP.COM.Print", "PhdPrintData", phdId, printFlag,defPrintorFlag);
		if (prtData == "{}") {
			return;
		}
		
		var prtJson = JSON.parse(prtData);
		var xmlTrmplate = prtJson.Templet || "";
		if (xmlTrmplate == "") {
			return;
		}
		PRINTCOM.XML({
			printBy: 'lodop',
			XMLTemplate: xmlTrmplate,
			data: prtJson,			
			extendFn: function(data){
				return {
					PrtDevice:prtJson.Para.PrtDevice,
				}
			}			
		});
		/* ��ӡ��־ */
		this.PrintLog("User.DHCPHDISPEN",{
				phdId: phdId,
				printFlag: printFlag,
				defPrintorFlag:defPrintorFlag
			},JSON.parse(prtData),{
				remarks: "��ҩ��",
				pointer: phdId
			}
		)
	},
	/*
	*Description:	������ӡ
	*Input:			prescNo -- ������, zfFlag -- ��/�ױ�ʶ,
	*				prtType -- ��ӡ����, defPrintorFlag -- Ĭ�ϴ�ӡ��
	*/
	Presc : function (prescNo, zfFlag, prtType,defPrintorFlag) {
		if(defPrintorFlag==undefined){defPrintorFlag="N"}
		if ((zfFlag == "") || (zfFlag == null)) {
			zfFlag = "����";
		}
		var useFlag = "5";
		var printDate = "" ; 
		var prtData = tkMakeServerCall("PHA.OP.COM.Print", "PrescPrintData", prescNo, zfFlag, prtType, useFlag, printDate, defPrintorFlag);
		if (prtData == "{}") {
			return;
		} else if (prtData == "-1") {
			PHAOP_COM._Msg("error","<span>"+ prescNo + "</span>"+ $g("Ϊȫ�˴����������ӡ!"));
		} else {
			var prtJson = JSON.parse(prtData);
			var xmlTrmplate = prtJson.Templet || "";
			PRINTCOM.XML({
				printBy: 'lodop',
				XMLTemplate: xmlTrmplate,
				data: prtJson,			
				extendFn: function(data){
					return {
						PrtDevice:prtJson.Para.PrtDevice,
					}
				}			
			});
		}
		/* ��ӡ��־ */
		this.PrintLog("PrescNo",{
				prescNo: prescNo,
				zfFlag: zfFlag,
				prtType: prtType,
				useFlag: useFlag,
				printDate: printDate,
				defPrintorFlag: defPrintorFlag
			},JSON.parse(prtData),{
				remarks: "����",
				pointer: prescNo
			}
		)
	},
	/*
	*Description:	�÷���ǩ
	*Input:			prescNo -- ������
	*				printFlag -- �����ʶ
	*/
	Label: function (prescNo, printFlag) {
		if (printFlag == undefined) {
			printFlag = "";
		}
		var prtData = tkMakeServerCall("PHA.OP.COM.Print", "LabelPrintData", prescNo);
		if (prtData == "[]") {
			if (printFlag != "") {
				PHAOP_COM._Msg("error",prescNo + "û����Ҫ��ӡ�ı�ǩ!");
			}
			return;
		}
		var prtJson = JSON.parse(prtData);
		var prtLen = prtJson.length;
		if (prtLen == 0) {
			return;
		}
		for (var prtI = 0; prtI < prtLen; prtI++) {
			var prtIJson = prtJson[prtI];
			PRINTCOM.XML({
				printBy: 'lodop',
				XMLTemplate: "DHCOutPharmacyKFBQ",
				data: prtIJson
			});
			/* ��ӡ��־ */
			this.PrintLog("Label",{
					prescNo: prescNo
				},prtIJson,{
					remarks: "��ǩ",
					pointer: prescNo + ","  + prtI
				}
			)
		}
		
	},
	/*
	*Description:	��ҩ����ӡ
	*Input:			retId -- ��ҩ��id
	*				printFlag -- �����ʶ
	*/
	PrintReturn:function (retId, printFlag){
		PRINTCOM.XML({
			printBy: 'lodop',
			XMLTemplate: 'DHCOutPhReturn',
			dataOptions: {
				ClassName: 'PHA.OP.COM.Print',
				MethodName: 'GetReturnPrintData',
				retRowID: retId,
				userID: session['LOGON.USERID'],
				rePrintFlag: printFlag
			},
			aptListFields: ["label14", "totalMoney", "label16", "userName"],
			listBorder: {
				headBorder: true,
				style: 4,
				startX: 1,
				endX: 190
			},
			page: {
				rows: 30,
				x: 90,
				y: 260,
				fontname: '����',
				fontbold: 'false',
				fontsize: '12',
				format: '{1}/{2}',
				showSingleNo: false
			}
		});
		/* ��ӡ��־ */
		this.PrintLog("User.DHCPHRETURN",{
				retId: retId,
				printFlag: printFlag,
			},{},{
				remarks: "��ҩ��",
				pointer: retId
			}
		)
	},
	/*
	*	��������ѯ
	*/
	PrintSupply:function (supp) {
		PRINTCOM.XML({
			printBy: 'lodop',
			XMLTemplate: 'PHAOPSupp',
			dataOptions: {
				ClassName: 'PHA.OP.COM.Print',
				MethodName: 'GetSuppPrintData',
				supp: supp,
				userID: session['LOGON.USERID']
			},
			listBorder: {
				headBorder: true,
				style: 4,
				startX: 4,
				endX: 180
			},
			page: {
				rows: 30,
				x: 90,
				y: 260,
				fontname: '����',
				fontbold: 'false',
				fontsize: '12',
				format: '{1}/{2}',
				showSingleNo: false
			}
		});
		/* ��ӡ��־ */
		this.PrintLog("User.DHCPHSUPPLY",{
				supp: supp
			},{},{
				remarks: "������",
				pointer: supp
			}
		)
	},
	// ��ӡǷҩ��,���ΪǷҩ��id
	PrintPhdOwe:function(phdoweid) {
		if (phdoweid == "") {
			return;
		}
		var prtData = tkMakeServerCall("PHA.OP.COM.Print", "GetOwePrintData", phdoweid);
		if (prtData == "{}") {
			return;
		}
		var prtJson = JSON.parse(prtData);

		PRINTCOM.XML({
			printBy: 'lodop',
			XMLTemplate: "DHCOutPhOwe",
			data: prtJson
		});
		/* ��ӡ��־ */
		this.PrintLog("User.DHCPHOweList",{
			phdoweid: phdoweid
		},{},{
			remarks: "Ƿҩ��",
			pointer: phdoweid
		}
	)
		
	},
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