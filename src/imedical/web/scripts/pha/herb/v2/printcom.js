/**
模块:		中药房公共
子模块:		中药房公共-处方打印
Creator:	MaYuqiang
CreateDate:	2021-01-17
printcom.js
*/
var HERB_PRINTCOM = {
	// 配药单
	PYD: function (phbdId, rePrt) {
		rePrt = rePrt || "";
		var prtData = tkMakeServerCall("PHA.HERB.Com.Print", "HerbPrintData", phbdId, rePrt);
		if (prtData == "{}") {
			$.messager.alert('提示',"该处方未执行配药流程，不能打印配药单!","info");
			return;
		}
		var prtJson = JSON.parse(prtData);
		var prescNo=prtJson.Para.PrescNo;
		var xmlTrmplate = tkMakeServerCall("PHA.HERB.Com.Print", "GetPrintTemplate", prescNo, 1);
		if (xmlTrmplate == "") {
			$.messager.alert('提示',"未获取到配药单打印模板，不能打印配药单!","info");
			return;
		}
		PRINTCOM.XML({
			printBy: 'lodop',
			XMLTemplate: xmlTrmplate,
			data: prtJson
		});

		/* 打印日志 */
		var defPrintorFlag = "N"	// 默认打印机
		this.PrintLog(
			"HERBPYD",
			{
				phbdId: phbdId,
				printFlag: rePrt,
				defPrintorFlag: defPrintorFlag
			},
			prtJson,
			{
				remarks: "打印配药单",
				pointer: phbdId
			}
		)
		
	},
	// 处方
	Presc: function (prescNo, zfFlag, prtType) {
		if ((zfFlag == "") || (zfFlag == null)) {
			zfFlag = "正方";
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
			$.messager.alert('提示',prescNo + "为全退处方，无需打印!","info");
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

		/* 打印日志 */
		var defPrintorFlag = "N"	// 默认打印机
		this.PrintLog(
			"PrescPrint",
			{
				prescNo: prescNo,
				printFlag: prtType,
				defPrintorFlag: defPrintorFlag
			},
			prtJson,
			{
				remarks: "处方打印",
				pointer: prescNo
			}
		)

	},
	// 用药标签,主要体现用法用量
	Label: function (prescNo,printFlag) {
		if(printFlag==undefined){printFlag="";}
		var prtData = tkMakeServerCall("PHA.OP.COM.Print", "LabelPrintData", prescNo);
		if (prtData == "[]") {
			if(printFlag==""){
				$.messager.alert('提示', prescNo + "没有需要打印的标签!", "info");
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

		/* 打印日志 */
		var defPrintorFlag = "N"	// 默认打印机
		this.PrintLog(
			"InstrucLabel",
			{
				prescNo: prescNo,
				printFlag: "",
				defPrintorFlag: defPrintorFlag
			},
			prtJson,
			{
				remarks: "用药标签",
				pointer: prescNo
			}
		)
	},
	// 煎药标签
	DECLabel: function (prescNo) {
		var prtData = tkMakeServerCall("PHA.HERB.Com.Print", "DECLabelData", prescNo);
		if (prtData == "[]") {	
			$.messager.alert('提示', prescNo + "没有需要打印的标签!", "info");					
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

		/* 打印日志 */
		var defPrintorFlag = "N"	// 默认打印机
		this.PrintLog(
			"DECLabel",
			{
				prescNo: prescNo,
				printFlag: "",
				defPrintorFlag: defPrintorFlag
			},
			prtJson,
			{
				remarks: "煎药标签",
				pointer: prescNo
			}
		)
		
	},
	// 退药单
	ReturnDoc: function (phbrId, printFlag) {
		var template = "PHAHERBReturn"
		var prtDataStr = tkMakeServerCall('PHA.HERB.Com.Print', 'GetReturnData', phbrId, template);
		var prtData = JSON.parse(prtDataStr);

		if (prtData.template === '') {
			//alert('请先在【参数设置】->【住院药房】->【住院退药】中维护打印模板名称 ');
			alert("请先定义退药单模板")
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
			page: { rows: 25, x: 80, y: 260, fontname: '宋体', fontbold: 'false', fontsize: '14', format: '第{1}页/共{2}页' }
		});

		/* 打印日志 */
		var defPrintorFlag = "N"	// 默认打印机
		this.PrintLog(
			"BS.PHA.HERB.RETURN",
			{
				phbrId: phbrId,
				printFlag: printFlag,
				defPrintorFlag: defPrintorFlag
			},
			prtData,
			{
				remarks: "草药退药单",
				pointer: phbrId
			}
		)
		
	},
	// 退药申请单
	RequestDoc: function (phbrrId, printFlag) {
		var template = "PHAHERBRequest"
		var prtDataStr = tkMakeServerCall('PHA.HERB.Com.Print', 'GetRequestData', phbrrId, template);
		var prtData = JSON.parse(prtDataStr);

		if (prtData.template === '') {
			//alert('请先在【参数设置】->【住院药房】->【住院退药】中维护打印模板名称 ');
			alert("请先定义退药单模板")
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
			page: { rows: 25, x: 80, y: 260, fontname: '宋体', fontbold: 'false', fontsize: '14', format: '第{1}页/共{2}页' }
		});

		/* 打印日志 */
		var defPrintorFlag = "N"	// 默认打印机
		this.PrintLog(
			"BS.PHA.HERB.RETREQUEST",
			{
				phbrrId: phbrrId,
				printFlag: printFlag,
				defPrintorFlag: defPrintorFlag
			},
			prtData,
			{
				remarks: "草药退药申请单",
				pointer: phbrrId
			}
		)
		
	},
	// 记录打印日志
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
