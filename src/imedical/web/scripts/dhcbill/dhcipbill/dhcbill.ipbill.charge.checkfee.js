/**
 *FileName:	dhcbill.ipbill.charge.checkfee.js
 *Author: ZhYW
 *Date:	2019-03-11
 *Description: 住院收费费用监控检查
*/

function checkFee() {
	var rtnValue = $.m({ClassName: "web.DHCIPBillCheckAdmCost", MethodName: "AdmSettlementCheck", episodeId: GV.EpisodeID, billId: GV.BillID}, false);
	var myAry = rtnValue.split(PUBLIC_CONSTANT.SEPARATOR.CH2);
	if (myAry[0] != 0) {
		$.messager.popover({msg: (myAry[1] || myAry[0]), type: "info"});
		return false;
	}
	return true;
}