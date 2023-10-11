/**
 * ����:     ��ӡ����ִ��
 * ��д��:   Huxt
 * ��д����: 2020-12-02
 * csp:      csp/pha.sys.v1.task.csp
 * js:       scripts/pha/sys/v1/task.js
 */

PHA_TASK_VAR = {};

/*
* �����������
*/
function StartTask(){
	// ��������
	if (!PHA_TASK_VAR.IS_PARSED) {
		ParseValue();
	}
	// ����ҩ����ӡ
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
	// סԺҩ����ӡ
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
	// ҩ���ӡ
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
* ����ģ�����
*/
function Task_OP(){
	// �Զ���ҩ
	if (client["IsAutoPY"] == "Y") {
		Task_OP_AutoDisp();
	}
	// �ƶ��˴�ӡ
	Task_MobPrint_OP();
}
function Task_IP(){
	// �Զ���ҩ
	if (client["IsAutoPY"] == "Y") {
		Task_IP_AutoDisp();
	}
	// �ƶ��˴�ӡ
	Task_IP_MobPrint();
}
function Task_IN(){
	// ���쵥
	if (client["IsPrintReqIN"] == "Y") {
		Task_IN_PrintReq();
	}
}


/*
* ��������
*/
// ����ֵ
function ParseValue(){
	var winIdArr = [];
	for (var k in client) {
		// ��������
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
		// �Զ���ҩʱ��
		// TODO...
	}
	PHA_TASK_VAR.WIN_ID_STR = winIdArr.join("^");
	PHA_TASK_VAR.IS_PARSED = true;
}
// js���쳣��Ϣת��
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
 * ���Ե���
 */
function PrintTest(){
	var LODOP = getLodop();
	LODOP.PRINT_INIT("LODOP_�򵥴�ӡ");
	LODOP.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
	// ����
	LODOP.ADD_PRINT_TEXT(15, 25, 600, 70, "LODOP_�򵥴�ӡ_����");
	LODOP.SET_PRINT_STYLEA(0, "FontSize", 14);
	LODOP.SET_PRINT_STYLEA(0, "Alignment", 2);
	LODOP.SET_PRINT_STYLEA(0, "Horient", 2);
	// ��һ��
	LODOP.ADD_PRINT_TEXT(55, 20, "100%", 28, "������ң����Կ���");
	LODOP.ADD_PRINT_TEXT(55, 400, "100%", 28, "��𣺴���Һ");
	// �ڶ���
	LODOP.ADD_PRINT_TEXT(85, 20, "100%", 28, "���ţ�000001231231");
	LODOP.ADD_PRINT_TEXT(85, 400, "100%", 28, "ʱ�䣺2020-03-02");
	LODOP.PRINT();
}

/**
 * ��д����xmlģ��ķ���
 */
PRINTCOM.loadXMLTemplate = function(templateName){
	//����ģ�����ټ���
	if(this.XMLTemplate[templateName]){
		return;
	}
	//xmlģ����ص�����
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
	//��ȡ������֯�ַ���
	var mystr = "";
	for (var i=0; i < this.PrtAryData.length; i++) {
		mystr += this.PrtAryData[i];
	}
	this.XMLTemplate[templateName] = mystr;
	return;
}
