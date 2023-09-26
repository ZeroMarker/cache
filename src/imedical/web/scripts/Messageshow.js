function Getmessage() {
	var message = tkMakeServerCall("web.DHCBedManager", "GetChangebedAppnum");
	var Authstatus = tkMakeServerCall("web.DHCBedManager", "GetAuthstatus"); //当前床位权限状态 

	if ((message != "0") && (message != "")) {

		//$.messager.show("<font color='red'>信息提示</font>","<a href='DHCBedAuditingManager.csp' onclick='window.open('href','_blank','height=100,width=400,top=0,left=0,toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no')'>"+abc+"</a>",0);

		//$.messager.show("<font color='red'>信息提示</font>","<a href='#' onclick='BedAudit()'>"+message+"</a>",0);
		$.messager.show("<font color='red'>" + Authstatus + "</font>", "<a href='#' onclick='BedAudit()'>" + message + "</a>", 0);

	} else {
		try {
			$.messager.close("<font color='red'>" + Authstatus + "</font>", "<a href='#' onclick='BedAudit()'>" + "暂无换床申请" + "</a>", 0);
		} catch (e) {
		}

	}
	setTimeout(Getmessage, 30000);


}

function BedAudit() {

	var lnk = 'DHCBedAuditingManager.csp'
	window.open(lnk, '_blank', 'toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1890,height=680,left=120,top=0')
		//window.close();
}