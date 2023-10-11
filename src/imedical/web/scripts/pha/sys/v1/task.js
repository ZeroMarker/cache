/**
 * 名称:     打印任务执行
 * 编写人:   Huxt
 * 编写日期: 2020-12-02
 * csp:      csp/pha.sys.v1.task.csp
 * js:       scripts/pha/sys/v1/task.js
 */

PHA_TASK_VAR = {};

/*
* 任务启动入口
*/
function StartTask(){
	// 解析变量
	if (!PHA_TASK_VAR.IS_PARSED) {
		ParseValue();
	}
	// 门诊药房打印
	if (client["IsRunTask_OP"] == "Y") {
		var TimeoutOP = parseInt(client["TimeoutOP"] || 5);
		setInterval(function(){
			try {
				Task_OP();
			} catch(e){
				WriteLocalLog(ExceptionToString(e));
			}
		}, TimeoutOP * 1000);
	}
	// 住院药房打印
	if (client["IsRunTask_IP"] == "Y") {
		var TimeoutIP = parseInt(client["TimeoutIP"] || 5);
		setInterval(function(){
			try {
				Task_IP();
			} catch(e){
				WriteLocalLog(ExceptionToString(e));
			}
		}, TimeoutIP * 1000);
	}
	// 药库打印
	if (client["IsRunTask_IN"] == "Y") {
		var TimeoutIN = parseInt(client["TimeoutIN"] || 5);
		setInterval(function(){
			try {
				Task_IN();
			} catch(e){
				WriteLocalLog(ExceptionToString(e));
			}
		}, TimeoutIN * 1000);
	}
}

/*
* 各个模块入口
*/
function Task_OP(){
	// 自动配药
	if (client["IsAutoPY"] == "Y") {
		Task_OP_AutoDisp();
	}
	// 移动端打印
	Task_MobPrint_OP();
}
function Task_IP(){
	// 自动发药
	if (client["IsAutoPY"] == "Y") {
		Task_IP_AutoDisp();
	}
	// 移动端打印
	Task_IP_MobPrint();
}
function Task_IN(){
	// 请领单
	if (client["IsPrintReqIN"] == "Y") {
		Task_IN_PrintReq();
	}
}


/*
* 公共方法
*/
// 解析值
function ParseValue(){
	var winIdArr = [];
	for (var k in client) {
		// 解析窗口
		if (k.indexOf("WINID_") == 0) {
			if (client[k] != "Y") {
				continue;
			}
			var tArr = k.split("_");
			var winId = tArr.length == 2 ? tArr[1] : "";
			if (winId == "") {
				continue;
			}
			winIdArr.push(winId);
		}
		// 自动发药时间
		// TODO...
	}
	PHA_TASK_VAR.WIN_ID_STR = winIdArr.join("^");
	PHA_TASK_VAR.IS_PARSED = true;
}
// js的异常信息转换
function ExceptionToString(e){
	if (!e) {
		return "";
	}
	var logStr = "";
	for (var ek in e) {
		var eStr = ek + ":" + e[ek].toString();
		if (logStr == "") {
			logStr = eStr;
		} else {
			logStr = logStr + "; " + eStr;
		}
	}
	return logStr;
}

/**
 * 测试调用
 */
function PrintTest(){
	var LODOP = getLodop();
	LODOP.PRINT_INIT("LODOP_简单打印");
	LODOP.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
	// 标题
	LODOP.ADD_PRINT_TEXT(15, 25, 600, 70, "LODOP_简单打印_标题");
	LODOP.SET_PRINT_STYLEA(0, "FontSize", 14);
	LODOP.SET_PRINT_STYLEA(0, "Alignment", 2);
	LODOP.SET_PRINT_STYLEA(0, "Horient", 2);
	// 第一行
	LODOP.ADD_PRINT_TEXT(55, 20, "100%", 28, "申请科室：测试科室");
	LODOP.ADD_PRINT_TEXT(55, 400, "100%", 28, "类别：大输液");
	// 第二行
	LODOP.ADD_PRINT_TEXT(85, 20, "100%", 28, "单号：000001231231");
	LODOP.ADD_PRINT_TEXT(85, 400, "100%", 28, "时间：2020-03-02");
	LODOP.PRINT();
}

/**
 * 重写加载xml模板的方法
 */
PRINTCOM.loadXMLTemplate = function(templateName){
	//存在模板则不再加载
	if(this.XMLTemplate[templateName]){
		return;
	}
	//xml模板加载到数组
	try {
		this.PrtAryData.length = 0;
		var ConStr = tkMakeServerCall("PHA.COM.Print", "ReadXML", templateName);
		PRINTCOM.PrtAryData[PRINTCOM.PrtAryData.length] = ConStr;
		for (var i=0; i < this.PrtAryData.length; i++) {
			this.PrtAryData[i] = this.TextEncoder(this.PrtAryData[i]);
		}
	} catch(e) {
		alert(e.message);
		return;
	}
	//读取数组组织字符串
	var mystr = "";
	for (var i=0; i < this.PrtAryData.length; i++) {
		mystr += this.PrtAryData[i];
	}
	this.XMLTemplate[templateName] = mystr;
	return;
}
