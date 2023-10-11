/**
 * scripts/pharmacy/outpha/dhcpha.outpha.printcom.js
 * 模块: 门诊药房
 * 子模块: 门诊药房-处方公共打印,JQuery版本,为确保原打印正常,故新建此类
 * createdate: 2016-04-26
 * creator: yunhaibao
 */

/*
 * @creator: Huxt 2019-12-23
 * @desc: 基数药补货单打印
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
			fontname: '宋体',
			fontbold: 'false',
			fontsize: '12',
			format: '第{1}页/共{2}页'
		}
	});
}

// 打印欠药单,入参为欠药单id
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
				// 配药单
				OUTPHA_PRINTCOM.PYD(phdrowid, RePrint,defPrintorFlag);
			}
			if (Type == "2") {
				// 处方
				OUTPHA_PRINTCOM.Presc(Prescno, "", "",defPrintorFlag);
			}
			if (Type == "3") {
				// 用法标签
				OUTPHA_PRINTCOM.Label(Prescno, "1");
			}
		}
	}
}

var OUTPHA_PRINTCOM = {
	// 配药单
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
	// 处方
	Presc: function (prescNo, zfFlag, prtType,defPrintorFlag) {
		if(defPrintorFlag==undefined){defPrintorFlag="N"}
		if ((zfFlag == "") || (zfFlag == null)) {
			zfFlag = "正方";
		}
		var prtData = tkMakeServerCall("PHA.OP.COM.Print", "PrescPrintData", prescNo, zfFlag, prtType, "5","",defPrintorFlag);
		if (prtData == "{}") {
			return;
		} else if (prtData == "-1") {
			dhcphaMsgBox.alert(prescNo + $g("为全退处方，无需打印!"));
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
	// 用法标签
	Label: function (prescNo, printFlag) {
		if (printFlag == undefined) {
			printFlag = "";
		}
		var prtData = tkMakeServerCall("PHA.OP.COM.Print", "LabelPrintData", prescNo);
		if (prtData == "[]") {
			if (printFlag == "") {
				dhcphaMsgBox.alert(prescNo + "没有需要打印的标签!");
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
