/**
 *FileName:	dhcipbillchargecheckfee.js
 *Anchor:	hujunbin
 *Date:	2015-03-11
 *Description:	新版住院收费费用监控检查
*/

function checkFee() {
	var checkFlag = "PAY";
	//var billVersion = "New";  //7.0之前版本为"Old",之后包括7.0为 "New"	
	
	var returnValStr = tkMakeServerCall("web.DHCIPBillCheckAdmCost", "AdmSettlementCheck", GlobalObj.episodeId, GlobalObj.billId, checkFlag);
	
	var checkStatus = _checkAdmFee(returnValStr);
	if (!checkStatus) {
		return false;
	}

	var babyCheckStatus = true;
	var returnValStr = tkMakeServerCall("web.DHCIPBillCheckAdmCost", "GetBabySettlementCheck", GlobalObj.episodeId, GlobalObj.billId, checkFlag);
	if (returnValStr != "") {
		var returnValStr1 = returnValStr.split(String.fromCharCode(3));
		for (var i = 0; i < returnValStr1.length - 1; i++) {
			if (returnValStr1[i] != "") {
				var returnValStr12 = returnValStr1[i].split(String.fromCharCode(2));
				var babyName = returnValStr12[0];
				var returnVal = returnValStr12[1].split("^");
				var babyCheckStatus = _checkAdmFee(returnValStr12[1]);
				if (!babyCheckStatus) {
					break;
				}
			}
		}
	}

	if (!babyCheckStatus) {
		return false;
	}

	return true;
}

function _checkAdmFee(returnValStr) {
	var myAry = returnValStr.split(String.fromCharCode(2));
	var errCode = myAry[0];
	var errMsg = myAry[1];
	if (+errCode != 0) {
		$.messager.alert("费用检查", errMsg, "error");
		return false;
	}

	return true;
}