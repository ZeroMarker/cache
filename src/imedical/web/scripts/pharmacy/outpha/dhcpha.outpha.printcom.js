/**
 * scripts/pharmacy/outpha/dhcpha.outpha.printcom.js
 * ģ��: ����ҩ��
 * ��ģ��: ����ҩ��-����������ӡ,JQuery�汾,Ϊȷ��ԭ��ӡ����,���½�����
 * createdate: 2016-04-26
 * creator: yunhaibao
 */

/*
 * @creator: Huxt 2019-12-23
 * @desc: ����ҩ��������ӡ
 */
function PrintSupp(supp) {
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
			style: 4,
			startX: 4,
			endX: 160
		},
		page: {
			rows: 30,
			x: 4,
			y: 2,
			fontname: '����',
			fontbold: 'false',
			fontsize: '12',
			format: '��{1}ҳ/��{2}ҳ'
		}
	});
}

// ��ӡǷҩ��,���ΪǷҩ��id
function PrintPhdOwe(phdoweid) {
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
}

function AfterExecPrint(Prescno, PrtType, phdrowid, RePrint,defPrintorFlag) {
	if(defPrintorFlag==undefined){defPrintorFlag="N"}
	if (PrtType != "") {
		var arr = PrtType.split(",");
		for (var i = 0; i < arr.length; i++) {
			var Type = arr[i];
			if ((Type == "1") && (phdrowid != "")) {
				// ��ҩ��
				OUTPHA_PRINTCOM.PYD(phdrowid, RePrint,defPrintorFlag);
			}
			if (Type == "2") {
				// ����
				OUTPHA_PRINTCOM.Presc(Prescno, "", "",defPrintorFlag);
			}
			if (Type == "3") {
				// �÷���ǩ
				OUTPHA_PRINTCOM.Label(Prescno, "1");
			}
		}
	}
}

var OUTPHA_PRINTCOM = {
	// ��ҩ��
	PYD: function (phdId, rePrt,defPrintorFlag) {
		if(defPrintorFlag==undefined){defPrintorFlag="N"}
		rePrt = rePrt || "";
		var prtData = tkMakeServerCall("PHA.OP.COM.Print", "PhdPrintData", phdId, rePrt,defPrintorFlag);
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
	},
	// ����
	Presc: function (prescNo, zfFlag, prtType,defPrintorFlag) {
		if(defPrintorFlag==undefined){defPrintorFlag="N"}
		if ((zfFlag == "") || (zfFlag == null)) {
			zfFlag = "����";
		}
		var prtData = tkMakeServerCall("PHA.OP.COM.Print", "PrescPrintData", prescNo, zfFlag, prtType, "5","",defPrintorFlag);
		if (prtData == "{}") {
			return;
		} else if (prtData == "-1") {
			dhcphaMsgBox.alert(prescNo + $g("Ϊȫ�˴����������ӡ!"));
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
	},
	// �÷���ǩ
	Label: function (prescNo, printFlag) {
		if (printFlag == undefined) {
			printFlag = "";
		}
		var prtData = tkMakeServerCall("PHA.OP.COM.Print", "LabelPrintData", prescNo);
		if (prtData == "[]") {
			if (printFlag == "") {
				dhcphaMsgBox.alert(prescNo + "û����Ҫ��ӡ�ı�ǩ!");
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
		}
	}
}
