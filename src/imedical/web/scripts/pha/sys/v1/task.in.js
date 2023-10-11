/**
 * ����:     ��ӡ����ִ�� - ҩ��
 * ��д��:   Huxt
 * ��д����: 2020-12-02
 * csp:      csp/pha.sys.v1.task.csp
 * js:       scripts/pha/sys/v1/task.in.js
 */

/*
* ���쵥
*/
function Task_IN_PrintReq() {
	// ��ִ������,ʹ������ģʽ
	return;
	
	var reqIdStr = $.cm({
		ClassName: 'web.DHCST.INRequest',
		MethodName: 'GetReqIdStr',
		days: (client["DaysIN"] || 1),
		recLoc: session["LOGON.CTLOCID"],
		dataType: 'text'
	}, false);
	PrintReqIN(reqIdStr);
}

function PrintReqIN(reqIdStr) {
	reqIdStr = reqIdStr || "";
	if (reqIdStr == "") {
		return;
	}
	// �ؿ�����,��ֹ����
	setTimeout(function(){
		var reqIdArr = reqIdStr.split("^");
		for (var i = 0; i < reqIdArr.length; i++) {
			var iReqId = reqIdArr[i];
			var reqMainStr = tkMakeServerCall("web.DHCST.INRequest", "Select", iReqId);
			var reqMainArr = reqMainStr.split("^");
			var INReqNo = reqMainArr[1];
			var INReqDate = reqMainArr[6];
			var INRecLoc = reqMainArr[12];
			var INReqLoc = reqMainArr[13];
			var INReqScg = reqMainArr[16];
			var INReqUser = reqMainArr[14];
			var INReqRemark = reqMainArr[10];
			var INReqType = reqMainArr[17];
			var RQDTFormat = "";
			var showTransfered = 1;
			
			try {
				PRINTCOM.RQ({
					QRFileName: 'DHCST_INRequest_Common.raq',
					Params: {
						ShowTransfered: showTransfered,
						Parref: iReqId,
						INReqNo: INReqNo,
						INReqDate: INReqDate,
						RQDTFormat: RQDTFormat
					},
					preview: false
				}, true);
			} catch(e){
				alert(e.message);
			}
		}
		
		// ��������
		if (client["IsPrintReqIN_Voice"] == "Y") {
			SpeakText("�����µ����쵥���뼰ʱ����");
		}
	}, 100);
}