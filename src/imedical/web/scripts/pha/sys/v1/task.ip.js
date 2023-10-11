/**
 * 名称:     打印任务执行 - 住院药房
 * 编写人:   Huxt
 * 编写日期: 2020-12-02
 * csp:      csp/pha.sys.v1.task.csp
 * js:       scripts/pha/sys/v1/task.ip.js
 */

/**
 * @description: 住院自动发药任务
 * @creator: Huxt 2020-12-08
 */
function Task_IP_AutoDisp() {
	// todo...
}

/**
 * @description: 住院移动端打印任务
 * @creator: Huxt 2020-12-08
 */
function Task_IP_MobPrint() {
	// 封箱贴 & 备药单
	var retArr = tkMakeServerCall('PHA.IP.Print.Auto', 'GetBoxDraw', session['LOGON.CTLOCID']);
	retArr = JSON.parse(retArr);
	var boxArr = retArr.box;
	var drawArr = retArr.draw;
	
	if (boxArr.length > 0){
		if (client["IsPrintBox"] == "Y") {
			PHA_IP_MOBPRINT.Box(boxArr);
		}
	}
	if (drawArr.length > 0){
		if (client["IsPrintDraw"] == "Y") {
			PHA_IP_MOBPRINT.Draw(drawArr);
		}
	}
	
	// 加急药品提示
	/*
	var retStr = tkMakeServerCall('PHA.IP.Print.Auto', 'GetUrgentVoice', session['LOGON.CTLOCID']);
	if (retStr != "") {
		if (client["IsUrgentVoice"] == "Y") {
			SpeakText(retStr);
		}
	}
	*/
}