/*
 * @Descripttion: 多院区的公共js
 * @Author: yaojining
 * @Date: 2021-12-13 10:18:28
 */

 /**
  * @description: 初始化院区控件
 */
 function initHosp() {
    var regTableName = arguments[0] || '';
	var callbackFun = arguments[1];
	if (typeof GenHospComp == "undefined") {
		GLOBAL.HospEnvironment = false;
	}
	if (GLOBAL.HospEnvironment) {
		var hospComp = GenHospComp(regTableName, session['LOGON.USERID'] + '^' + session['LOGON.GROUPID'] + '^' + session['LOGON.CTLOCID'] + '^' + GLOBAL.HospitalID);
		hospComp.options().onSelect = function (q, row) {
			GLOBAL.HospitalID = row.HOSPRowId;
			if (typeof callbackFun == 'function') {
				callbackFun();
			}
		}
	} else {
		$m({
			ClassName: 'NurMp.Common.Tools.Hospital',
			MethodName: 'hospitalName',
			HospitalID: GLOBAL.HospitalID
		}, function (hospDesc) {
			$HUI.combobox("#_HospList", {
				width: 250,
				valueField: 'HOSPRowId',
				textField: 'HOSPDesc',
				data: [{
					HOSPRowId: GLOBAL.HospitalID,
					HOSPDesc: hospDesc
				}],
				value: GLOBAL.HospitalID,
				disabled: true
			});
		});
	}
}