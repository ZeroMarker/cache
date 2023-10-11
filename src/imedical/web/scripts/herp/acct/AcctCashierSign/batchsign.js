var batchsign = function () {
	var rowObj = itemGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	var signVouchIdArr = [],
	unbatchsigncount = 0;
	if (len > 0) {
		for (var i = 0; i < len; i++) {
			var vouchId = rowObj[i].get("rowid");
			var signState = rowObj[i].get("IsCheck");
			if (signState == "已签字" ) {
				unbatchsigncount++;
				continue;
			} else if (signVouchIdArr.indexOf(vouchId) == -1) {
				// 过滤掉重复的凭证id
				signVouchIdArr.push(vouchId);
			}
		}

		if (signVouchIdArr.length == 0) {
			Ext.Msg.show({
				title: '注意',
				msg: '所选数据为已签字的凭证，不能再签字！ ',
				buttons: Ext.Msg.OK,
				icon: Ext.MessageBox.WARNING
			});
			return;

		} else {
			/* // 排序，从小到大  //没必要排序
			signVouchIdArr.sort(function (a, b) {
				return a - b;
			}); */
			// console.log("signVouchIdArr:" + signVouchIdArr)
			if (unbatchsigncount > 0) {
				Ext.MessageBox.confirm('提示', '已签字的凭证已过滤，请放心操作！ ', function (btn) {
					if (btn == 'yes') {
						batchsigndetail(signVouchIdArr);
					} else {
						return ;
					}

				});
			}
			else batchsigndetail(signVouchIdArr);
		}
	} else {
		Ext.Msg.show({
			title: '错误',
			msg: '请选择需要审批签字的凭证! ',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.ERROR
		});
	}
	return;
};