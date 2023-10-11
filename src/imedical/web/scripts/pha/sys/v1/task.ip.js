/**
 * ����:     ��ӡ����ִ�� - סԺҩ��
 * ��д��:   Huxt
 * ��д����: 2020-12-02
 * csp:      csp/pha.sys.v1.task.csp
 * js:       scripts/pha/sys/v1/task.ip.js
 */

/**
 * @description: סԺ�Զ���ҩ����
 * @creator: Huxt 2020-12-08
 */
function Task_IP_AutoDisp() {
	// todo...
}

/**
 * @description: סԺ�ƶ��˴�ӡ����
 * @creator: Huxt 2020-12-08
 */
function Task_IP_MobPrint() {
	// ������ & ��ҩ��
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
	
	// �Ӽ�ҩƷ��ʾ
	/*
	var retStr = tkMakeServerCall('PHA.IP.Print.Auto', 'GetUrgentVoice', session['LOGON.CTLOCID']);
	if (retStr != "") {
		if (client["IsUrgentVoice"] == "Y") {
			SpeakText(retStr);
		}
	}
	*/
}