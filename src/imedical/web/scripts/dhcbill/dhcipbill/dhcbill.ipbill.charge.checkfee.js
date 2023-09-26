/**
 *FileName:	dhcbill.ipbill.charge.checkfee.js
 *Anchor: ZhYW
 *Date:	2019-03-11
 *Description:	住院收费费用监控检查
*/

function checkFee() {
	var rtnValue = $.m({ClassName: "web.DHCIPBillCheckAdmCost", MethodName: "AdmSettlementCheck", episodeId: getGlobalValue("EpisodeID"), billId: getGlobalValue("BillID")}, false);
	var myAry = rtnValue.split(String.fromCharCode(2));
	var errCode = myAry[0];
	if (+errCode != 0) {
		var errMsg = myAry[1];
		$.messager.popover({msg: errMsg, type: "info"});
		return false;
	}
	return true;
}