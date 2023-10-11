/**
 * 模块:     门诊药房打印汇总
 * 编写日期: 2022-08-10
 * 编写人:   zhaozhiduan
 * scripts/pha/op/v4/printcom.js 
 */
 
var OP_PRINTCOM = {
	/*
	*Description:	根据打印类型选择打印
	*Input:			_opt:参数格式{};
	*				_opt.prescNo -- 处方号, 
	*				_opt.prtType -- 打印类型,1-配药单,2-处方,3-标签,
	*				_opt.defPrintorFlag -- 默认打印机
	*				_opt.rePrint --补打标识
	*				_opt.phdId -- 发药id(一般配药单需要)
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
					// 配药单
					OP_PRINTCOM.PYD(phdId, rePrint,defPrintorFlag);
				}
				if (type == "2") {
					// 处方
					OP_PRINTCOM.Presc(prescNo, "", "",defPrintorFlag);
				}
				if (type == "3") {
					// 用法标签
					OP_PRINTCOM.Label(prescNo, rePrint);
				}
			}
		}
	},
	/*
	*Description:	配药单
	*Input:			phdId -- 发药id, printFlag -- 补打标识,
	*				defPrintorFlag -- 默认打印机
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
		/* 打印日志 */
		this.PrintLog("User.DHCPHDISPEN",{
				phdId: phdId,
				printFlag: printFlag,
				defPrintorFlag:defPrintorFlag
			},JSON.parse(prtData),{
				remarks: "配药单",
				pointer: phdId
			}
		)
	},
	/*
	*Description:	处方打印
	*Input:			prescNo -- 处方号, zfFlag -- 正/底标识,
	*				prtType -- 打印类型, defPrintorFlag -- 默认打印机
	*/
	Presc : function (prescNo, zfFlag, prtType,defPrintorFlag) {
		if(defPrintorFlag==undefined){defPrintorFlag="N"}
		if ((zfFlag == "") || (zfFlag == null)) {
			zfFlag = "正方";
		}
		var useFlag = "5";
		var printDate = "" ; 
		var prtData = tkMakeServerCall("PHA.OP.COM.Print", "PrescPrintData", prescNo, zfFlag, prtType, useFlag, printDate, defPrintorFlag);
		if (prtData == "{}") {
			return;
		} else if (prtData == "-1") {
			PHAOP_COM._Msg("error","<span>"+ prescNo + "</span>"+ $g("为全退处方，无需打印!"));
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
		/* 打印日志 */
		this.PrintLog("PrescNo",{
				prescNo: prescNo,
				zfFlag: zfFlag,
				prtType: prtType,
				useFlag: useFlag,
				printDate: printDate,
				defPrintorFlag: defPrintorFlag
			},JSON.parse(prtData),{
				remarks: "处方",
				pointer: prescNo
			}
		)
	},
	/*
	*Description:	用法标签
	*Input:			prescNo -- 处方号
	*				printFlag -- 补打标识
	*/
	Label: function (prescNo, printFlag) {
		if (printFlag == undefined) {
			printFlag = "";
		}
		var prtData = tkMakeServerCall("PHA.OP.COM.Print", "LabelPrintData", prescNo);
		if (prtData == "[]") {
			if (printFlag != "") {
				PHAOP_COM._Msg("error",prescNo + "没有需要打印的标签!");
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
			/* 打印日志 */
			this.PrintLog("Label",{
					prescNo: prescNo
				},prtIJson,{
					remarks: "标签",
					pointer: prescNo + ","  + prtI
				}
			)
		}
		
	},
	/*
	*Description:	退药单打印
	*Input:			retId -- 退药单id
	*				printFlag -- 补打标识
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
				fontname: '宋体',
				fontbold: 'false',
				fontsize: '12',
				format: '{1}/{2}',
				showSingleNo: false
			}
		});
		/* 打印日志 */
		this.PrintLog("User.DHCPHRETURN",{
				retId: retId,
				printFlag: printFlag,
			},{},{
				remarks: "退药单",
				pointer: retId
			}
		)
	},
	/*
	*	补货单查询
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
				fontname: '宋体',
				fontbold: 'false',
				fontsize: '12',
				format: '{1}/{2}',
				showSingleNo: false
			}
		});
		/* 打印日志 */
		this.PrintLog("User.DHCPHSUPPLY",{
				supp: supp
			},{},{
				remarks: "补货单",
				pointer: supp
			}
		)
	},
	// 打印欠药单,入参为欠药单id
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
		/* 打印日志 */
		this.PrintLog("User.DHCPHOweList",{
			phdoweid: phdoweid
		},{},{
			remarks: "欠药单",
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