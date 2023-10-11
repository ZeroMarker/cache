/**
 * 名称:     打印任务执行 - 药库
 * 编写人:   Huxt
 * 编写日期: 2020-12-02
 * csp:      csp/pha.sys.v1.task.csp
 * js:       scripts/pha/sys/v1/task.in.js
 */

/*
* 请领单
*/
function Task_IN_PrintReq() {
	// 不执行任务,使用推送模式
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
	// 重开进程,防止卡顿
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
		
		// 语音提醒
		if (client["IsPrintReqIN_Voice"] == "Y") {
			SpeakText("您有新的请领单，请及时处理。");
		}
	}, 100);
}