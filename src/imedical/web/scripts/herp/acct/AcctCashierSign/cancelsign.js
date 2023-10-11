function cancelsign() {
	var rowObj = itemGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	var vouchIdArr = [],
	uncancelsigncount = 0;
	if (len > 0) {
		for (var i = 0; i < len; i++) {
			var vouchId = rowObj[i].get("rowid");
			var signUserId = rowObj[i].get("CheckerID");
			var signState = rowObj[i].get("IsCheck");
			var vouchState = rowObj[i].get("VouchState1");
			if (signUserId !== userdr || signState == "未签字" || vouchState > 21) {
				uncancelsigncount++;
				continue;
			} else if (vouchIdArr.indexOf(vouchId) == -1) {
				// 过滤掉重复的凭证id
				vouchIdArr.push(vouchId);
			}
		}

		if (vouchIdArr.length == 0) {
			Ext.Msg.show({
				title: '注意',
				msg: '所选数据为未签字、已记账、已结账</br>或非本人签字的凭证，不能取消签字！ ',
				buttons: Ext.Msg.OK,
				icon: Ext.MessageBox.WARNING
			});
			return;

		} else {
			/* // 排序，从小到大	//没必要排序
			vouchIdArr.sort(function (a, b) {
				return a - b;
			}); */
			// console.log("vouchIdArr:" + vouchIdArr)
			if (uncancelsigncount > 0) {
				Ext.MessageBox.confirm('提示', '不符合取消签字的凭证已过滤，请放心操作！ ', function (btn) {
					if (btn == 'yes') {
						cancelsigndetail(vouchIdArr);
					} else {
						return ;
					}

				});
			}
			else cancelsigndetail(vouchIdArr);
		}

	} else {
		Ext.Msg.show({
			title: '错误',
			msg: '请选择需要取消签字的凭证! ',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.ERROR
		});
	}
	return;
}

