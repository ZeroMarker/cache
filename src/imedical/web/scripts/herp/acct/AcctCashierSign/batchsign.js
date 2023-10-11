var batchsign = function () {
	var rowObj = itemGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	var signVouchIdArr = [],
	unbatchsigncount = 0;
	if (len > 0) {
		for (var i = 0; i < len; i++) {
			var vouchId = rowObj[i].get("rowid");
			var signState = rowObj[i].get("IsCheck");
			if (signState == "��ǩ��" ) {
				unbatchsigncount++;
				continue;
			} else if (signVouchIdArr.indexOf(vouchId) == -1) {
				// ���˵��ظ���ƾ֤id
				signVouchIdArr.push(vouchId);
			}
		}

		if (signVouchIdArr.length == 0) {
			Ext.Msg.show({
				title: 'ע��',
				msg: '��ѡ����Ϊ��ǩ�ֵ�ƾ֤��������ǩ�֣� ',
				buttons: Ext.Msg.OK,
				icon: Ext.MessageBox.WARNING
			});
			return;

		} else {
			/* // ���򣬴�С����  //û��Ҫ����
			signVouchIdArr.sort(function (a, b) {
				return a - b;
			}); */
			// console.log("signVouchIdArr:" + signVouchIdArr)
			if (unbatchsigncount > 0) {
				Ext.MessageBox.confirm('��ʾ', '��ǩ�ֵ�ƾ֤�ѹ��ˣ�����Ĳ����� ', function (btn) {
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
			title: '����',
			msg: '��ѡ����Ҫ����ǩ�ֵ�ƾ֤! ',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.ERROR
		});
	}
	return;
};