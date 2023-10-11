/**
 * 名称:     打印任务执行 - 门诊药房
 * 编写人:   Huxt
 * 编写日期: 2020-12-08
 * csp:      csp/pha.sys.v1.task.csp
 * js:       scripts/pha/sys/v1/task.op.js
 */

/**
 * @description: 门诊自动配药任务
 * @creator: Huxt 2020-12-08
 */
function Task_OP_AutoDisp() {
	// 配置的打印类型
	if (!PHA_TASK_VAR.OP_PRINT_TYPE) {
		var congigStr = tkMakeServerCall(
			"PHA.OP.COM.Method",
			"GetParamProp",
			session['LOGON.GROUPID'],
			session['LOGON.CTLOCID'],
			session['LOGON.USERID']);
		var congigArr = congigStr.split('^');
		PHA_TASK_VAR.OP_PRINT_TYPE = congigArr[1];
	}
	
	// 自动配药
	var jsonData = $.cm({
		ClassName: 'PHA.OP.PyAdv.OperTab',
		MethodName: 'AutoDispForClient',
		days: client['PYDays'],
		locId: session['LOGON.CTLOCID'],
		phwStr: PHA_TASK_VAR.WIN_ID_STR,
		userId: session['LOGON.USERID']
	}, false);
	if (jsonData.errCode < 0 || jsonData.success == 0) {
		return;
	}
	
	// 配药后打印
	var phdIdStr = jsonData.data || "";
	if (phdIdStr == "") {
		return;
	}
	var phdIdArr = phdIdStr.split("^");
	for (var phdI = 0; phdI < phdIdArr.length; phdI++) {
		var iPhdIdStr = phdIdArr[phdI] || "";
		if (iPhdIdStr == "") {
			continue;
		}
		var iPhdId = iPhdIdStr.split("$")[0];
		var iPrescNo = iPhdIdStr.split("$")[1];
		AfterExecPrint(iPrescNo, PHA_TASK_VAR.OP_PRINT_TYPE, iPhdId, "");
	}
}

/**
 * @description: 移动端打印任务 (需要兼容门诊住院,中药西药)
 * @creator: Huxt 2020-12-08
 */
function Task_MobPrint_OP(){
	// 需要打印的处方
	var jsonData = $.cm({
		ClassName: 'PHA.MOB.COM.Print',
		MethodName: 'GetPrintCommon',
		locId: session['LOGON.CTLOCID'],
		phwStr: PHA_TASK_VAR.WIN_ID_STR
	}, false);
	if (jsonData.errCode < 0 || jsonData.success == 0) {
		return;
	}
	var PrescNoArr = jsonData.PrescNoArr;
	var FinePrescNoArr = jsonData.FinePrescNoArr;
	var BoxIdArr = jsonData.BoxIdArr;
	
	// 处方/配药单/用法标签
	for (var i = 0; i < PrescNoArr.length; i++) {
		var prescNo = PrescNoArr[i];
		if (client["IsMobPrintPresc"] == "Y") {
			PrintPresc(prescNo);
		}
		if (client["IsMobPrintPyd"] == "Y") {
			PrintPyd(prescNo);
		}
		if (client["IsMobPrintLabel"] == "Y") {
			PrintLabel(prescNo);
		}
	}
	
	// 贵重药标签
	if (client["IsMobPrintPriceLabel"] == "Y") {
		for(var i = 0; i < FinePrescNoArr.length; i++){
			var prescNo = FinePrescNoArr[i];
			PrintPriceLabel(prescNo);
		}
	}
	
	// 物流箱标签
	if (client["IsMobPrintBoxLable"] == "Y") {
		for(var i = 0; i < BoxIdArr.length; i++){
			var boxId = BoxIdArr[i];
			PrintBoxLable(boxId);
		}
	}
}

/**
 * @creator: Huxt 2020-12-08
 * @description: 打印处方 (西药&中药)
 */
function PrintPresc(prescNo){
	var jsonData = $.cm({
		ClassName: 'PHA.MOB.COM.Print',
		MethodName: 'PrescPrintData',
		prescNo: prescNo
	}, false);
	if (jsonData.errCode < 0 || jsonData.success == 0) {
		return;
	}
	if (!jsonData.Templet) {
		return;
	}
	PRINTCOM.XML({
		printBy: 'lodop',
		XMLTemplate: jsonData.Templet,
		data: jsonData,
		extendFn: function(data){
			return {
				PrtDevice: data.Para.PrtDevice
			}
		}
	});
}
/**
 * @creator: Huxt 2020-12-08
 * @description: 打印配药单 (西药&中药)
 */
function PrintPyd(prescNo) {
	var jsonData = $.cm({
		ClassName: 'PHA.MOB.COM.Print',
		MethodName: 'PydPrintData',
		prescNo: prescNo
	}, false);
	if (jsonData.errCode < 0 || jsonData.success == 0) {
		return;
	}
	if (!jsonData.Templet) {
		return;
	}
	
	PRINTCOM.XML({
		printBy: 'lodop',
		XMLTemplate: jsonData.Templet,
		data: jsonData,
		extendFn: function(data){
			return {
				PrtDevice: data.Para.PrtDevice
			}
		}
	});
}
/**
 * @creator: Huxt 2020-12-08
 * @description: 打印用法标签 (门诊西药)
 */
function PrintLabel(prescNo) {
	OUTPHA_PRINTCOM.Label(prescNo, "1");
}

/**
 * @creator: Huxt 2020-12-08
 * @description: 打印贵重要品标签 (仅中药)
 */
function PrintPriceLabel(prescNo) {
	var jsonData = $.cm({
		ClassName: 'PHA.MOB.COM.Print',
		MethodName: 'PriceLabelPrintData',
		prescNo: prescNo
	}, false);
	if (jsonData.errCode < 0 || jsonData.success == 0) {
		return;
	}
	
	PRINTCOM.XML({
		printBy: 'lodop',
		XMLTemplate: "PHAINPriceLabel",
		data: jsonData,
		page: {
			rows: 1,
			format: ""
		},
		extendFn: function(data){
			return {
				PrtDevice: data.Para.PrtDevice
			}
		}
	});
}

/**
 * @creator: Huxt 2020-12-08
 * @description: 物流箱汇总标签 (中药物流标签-封箱贴)
 */
function PrintBoxLable(boxId){
	var jsonData = $.cm({
		ClassName: 'PHA.MOB.COM.Print',
		MethodName: 'BoxPrintData',
		boxId: boxId
	}, false);
	if (jsonData.errCode < 0 || jsonData.success == 0) {
		return;
	}
	
	PRINTCOM.XML({
		printBy: 'lodop',
		XMLTemplate: "PHAINBoxLabel",
		data: jsonData,
		extendFn: function(data){
			return {
				PrtDevice: data.Para.PrtDevice
			}
		}
	});
}
